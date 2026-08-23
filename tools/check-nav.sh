#!/usr/bin/env bash
#
# Validate everything GitBook consumes before it syncs the repo.
#
# GitBook publishes this space via Git sync (.gitbook.yaml -> SUMMARY.md), so a
# stale or broken SUMMARY.md ships straight to the live site with no build step
# to catch it. This script is that build step.
#
# Checks:
#   1. SUMMARY.md and _sidebar.md match what the generators produce.
#   2. Every relative link in SUMMARY.md / _sidebar.md / README.md resolves.
#   3. README problem counts (total and per difficulty) match the folders on disk.
#   4. .gitbook.yaml points at files that exist.
#   5. No single-dollar math is left (GitBook only renders $$...$$).
#
# Run from anywhere:  ./tools/check-nav.sh
#
set -uo pipefail

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

fail=0
ok()  { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }

# --- 1. generated navigation is up to date --------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Generate into a scratch tree rather than over the real files. An earlier version
# wrote SUMMARY.md in place and restored it afterwards, which truncated the file
# whenever the script was interrupted between the two steps. The generators derive
# everything from the directory layout, so symlinking the difficulty folders into a
# temp root reproduces their output without touching anything tracked.
work="$tmp/work"
mkdir -p "$work/tools"
cp tools/gen-summary.sh tools/gen-sidebar.sh "$work/tools/"
# Mirror the layout as real (empty) files. The generators enumerate with `find
# -type d`, which does not descend into a symlinked directory, so a skeleton is
# needed rather than links. Only names matter to them, never file contents.
for d in Easy Medium Hard; do
  mkdir -p "$work/$d"
done
find Easy Medium Hard -mindepth 2 -maxdepth 2 -name 'solution*.md' -print0 |
  while IFS= read -r -d '' f; do
    mkdir -p "$work/$(dirname "$f")"
    : > "$work/$f"
  done
(cd "$work" && ./tools/gen-summary.sh >/dev/null && ./tools/gen-sidebar.sh >/dev/null)

for f in SUMMARY.md _sidebar.md; do
  if diff -q "$work/$f" "$f" >/dev/null 2>&1; then
    ok "$f is up to date"
  else
    bad "$f is stale — run ./tools/gen-summary.sh && ./tools/gen-sidebar.sh"
    diff -u "$f" "$work/$f" | head -20 | sed 's/^/       /'
  fi
done

# --- 2 & 3. link resolution and README counts -----------------------------
# Done in Python: markdown targets here contain both escaped and bare
# parentheses (Medium/208.Implement-trie-(prefix-tree)) plus %20-encoded
# spaces, which a grep/sed pass cannot parse reliably.
python3 - <<'PY'
import pathlib
import re
import sys

root = pathlib.Path.cwd()
problems = 0


def link_targets(text):
    """Yield each markdown link target, handling nested and escaped parens."""
    i = 0
    while (i := text.find("](", i)) != -1:
        i += 2
        depth, out = 1, []
        while i < len(text):
            ch = text[i]
            if ch == "\\" and i + 1 < len(text):
                out.append(text[i + 1])
                i += 2
                continue
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    break
            elif ch == "\n":
                break
            out.append(ch)
            i += 1
        yield "".join(out)


for name in ("SUMMARY.md", "_sidebar.md", "README.md"):
    src = root / name
    if not src.exists():
        print(f"FAIL {name} is missing")
        problems += 1
        continue

    broken = []
    for target in link_targets(src.read_text(encoding="utf-8")):
        target = target.split()[0] if target.split() else ""
        if not target or target.startswith(("http://", "https://", "#", "mailto:")):
            continue
        target = target.split("#", 1)[0].replace("%20", " ")
        if not (root / target).exists():
            broken.append(target)

    if broken:
        print(f"FAIL {name} has {len(broken)} broken link(s)")
        for t in broken[:10]:
            print(f"       -> {t}")
        problems += 1
    else:
        print(f"ok   {name} links all resolve")

# README counts vs folders on disk.
readme = (root / "README.md").read_text(encoding="utf-8")
total = 0
for difficulty in ("Easy", "Medium", "Hard"):
    on_disk = sum(
        1
        for d in (root / difficulty).iterdir()
        if d.is_dir() and any(d.glob("solution*.md"))
    )
    total += on_disk

    m = re.search(rf"^### {difficulty} \((\d+)\)", readme, re.M)
    if not m:
        print(f"FAIL README.md has no '### {difficulty} (N)' heading")
        problems += 1
    elif int(m.group(1)) != on_disk:
        print(f"FAIL README.md says '### {difficulty} ({m.group(1)})' but {on_disk} folder(s) exist")
        problems += 1
    else:
        print(f"ok   README.md {difficulty} count ({on_disk}) matches disk")

# Stray single "$" in a page GitBook renders. KaTeX treats an unpaired dollar
# as the start of math mode, so everything after it -- including "#" headings --
# is parsed as math and the page dies with
#   You can't use 'macro parameter character #' in math mode
# mathfix.py deliberately leaves currency alone, so it cannot catch this.
def _strip_code(text):
    out, in_fence, fence = [], False, None
    for line in text.split("\n"):
        m = re.match(r"^\s*(```|~~~)", line)
        if m:
            tok = m.group(1)
            if not in_fence:
                in_fence, fence = True, tok
            elif tok == fence:
                in_fence = False
            out.append("")
            continue
        out.append("" if in_fence else re.sub(r"`[^`]*`", "", line))
    return "\n".join(out)


rendered = {"README.md"}
summary = root / "SUMMARY.md"
if summary.exists():
    for t in re.findall(r"\]\(([^)]+)\)", summary.read_text(encoding="utf-8")):
        if not t.startswith(("http", "#")):
            rendered.add(t.replace("%20", " "))

stray = []
for name in sorted(rendered):
    page = root / name
    if not page.exists():
        continue
    body = _strip_code(page.read_text(encoding="utf-8"))
    body = body.replace("\\$", "")                       # escaped currency is fine
    body = re.sub(r"\$\$.*?\$\$", "", body, flags=re.S)   # proper math is fine
    for m in re.finditer(r"\$", body):
        stray.append((name, body[max(0, m.start() - 40):m.start() + 40].replace("\n", " ")))

# A $$...$$ span that crosses a newline. GitBook treats the opening $$ as a block
# delimiter and does not find its terminator on the same line, so math mode runs on
# into the following prose. The first "#" heading it swallows then fails with
#   You can't use 'macro parameter character #' in math mode
multiline_math = []
for name in sorted(rendered):
    page = root / name
    if not page.exists():
        continue
    body = _strip_code(page.read_text(encoding="utf-8"))
    for m in re.finditer(r"\$\$(.+?)\$\$", body, re.S):
        if "\n" in m.group(1):
            snippet = " ".join(m.group(1).split())[:60]
            multiline_math.append((name, snippet))

if multiline_math:
    print(f"FAIL {len(multiline_math)} math span(s) cross a newline — GitBook will run math mode into the next heading")
    for name, snip in multiline_math[:10]:
        print(f"       {name}: $${snip}...$$")
    print("       Keep each $$...$$ span on a single line.")
    problems += 1
else:
    print("ok   no math span crosses a newline")

if stray:
    print(f"FAIL {len(stray)} stray single '$' in rendered page(s) — KaTeX will read it as math mode")
    for name, ctx in stray[:10]:
        print(f"       {name}: ...{ctx}...")
    print("       Escape currency as \\$5, or wrap it in backticks.")
    problems += 1
else:
    print(f"ok   no stray '$' across {len(rendered)} rendered page(s)")

m = re.search(r"^Total: \*\*(\d+)\*\*", readme, re.M)
if not m:
    print("FAIL README.md has no 'Total: **N** problems' line")
    problems += 1
elif int(m.group(1)) != total:
    print(f"FAIL README.md says Total: **{m.group(1)}** but {total} problem folder(s) exist")
    problems += 1
else:
    print(f"ok   README.md total ({total}) matches disk")

sys.exit(1 if problems else 0)
PY
[ $? -eq 0 ] || fail=1

# --- 4. .gitbook.yaml targets exist ---------------------------------------
if [ -f .gitbook.yaml ]; then
  gb_ok=1
  for key in readme summary; do
    target="$(sed -n "s/^ *$key: *//p" .gitbook.yaml | head -1)"
    if [ -n "$target" ] && [ ! -f "$target" ]; then
      printf '       .gitbook.yaml %s: %s does not exist\n' "$key" "$target"
      gb_ok=0
    fi
  done
  if [ "$gb_ok" -eq 1 ]; then ok ".gitbook.yaml targets exist"; else bad ".gitbook.yaml points at missing file(s)"; fi
else
  bad ".gitbook.yaml is missing — GitBook Git sync needs it"
fi

# --- 5. math is GitBook-compatible ----------------------------------------
if ./tools/mathfix.py --check >/dev/null 2>&1; then
  ok 'all math uses $$...$$'
else
  bad 'single-dollar math found — run ./tools/mathfix.py'
  ./tools/mathfix.py --check 2>&1 | head -20 | sed 's/^/       /'
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "All GitBook checks passed."
else
  echo "GitBook checks failed."
fi
exit "$fail"
