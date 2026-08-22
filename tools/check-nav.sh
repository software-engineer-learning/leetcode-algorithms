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
cp SUMMARY.md "$tmp/SUMMARY.md.orig"
cp _sidebar.md "$tmp/_sidebar.md.orig"

./tools/gen-summary.sh >/dev/null
./tools/gen-sidebar.sh >/dev/null

for f in SUMMARY.md _sidebar.md; do
  if diff -q "$tmp/$f.orig" "$f" >/dev/null; then
    ok "$f is up to date"
  else
    bad "$f is stale — run ./tools/gen-summary.sh && ./tools/gen-sidebar.sh"
    diff -u "$tmp/$f.orig" "$f" | head -20 | sed 's/^/       /'
  fi
  # Restore the committed version so this script never mutates the tree.
  cp "$tmp/$f.orig" "$f"
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
