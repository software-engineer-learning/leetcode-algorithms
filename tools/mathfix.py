#!/usr/bin/env python3
"""Convert single-dollar $...$ inline math to GitBook-compatible $$...$$ (KaTeX).

GitHub renders both $...$ (inline) and $$...$$ (block). GitBook's Git-synced
markdown only recognizes $$...$$, so single-dollar math shows up as literal text
there. This script rewrites $...$ -> $$...$$ everywhere it is real math.

Safety:
  * Fenced code blocks (``` ... ``` and ~~~ ... ~~~) are left untouched.
  * Inline code spans (`...`) are left untouched, so "$" inside code survives.
  * Existing $$...$$ is never doubled (idempotent: re-running is a no-op).
  * Only non-empty, single-line, $-free content between the dollars is matched.

Usage:
  python3 tools/mathfix.py --check            # report what would change, exit 1 if any
  python3 tools/mathfix.py                     # convert Easy/ Medium/ Hard in place
  python3 tools/mathfix.py path/to/file.md ... # convert specific files
"""
import re
import sys
import pathlib

# A single $, then non-empty content with no $ or newline, then a single $.
# Rules (mirroring markdown-it-katex) so currency like "$5 ... $10" is skipped:
#   * not part of an existing $$...$$ block
#   * no whitespace just inside either delimiter  ($x$ ok, "$ x $" / "$x $" not)
#   * the closing $ is not immediately followed by a digit  (rules out "$10")
INLINE = re.compile(r"(?<!\$)\$(?!\$)(?=\S)([^$\n]*?)(?<=\S)\$(?!\$)(?!\d)")

# Splits a line into [text, code, text, code, ...] on backtick spans.
INLINE_CODE = re.compile(r"(`+[^`]*`+)")

# A line that opens/closes a fenced code block.
FENCE = re.compile(r"^(\s*)(`{3,}|~{3,})")


def convert_line(line: str) -> str:
    parts = INLINE_CODE.split(line)
    for i in range(0, len(parts), 2):  # even indices are outside inline code
        parts[i] = INLINE.sub(lambda m: f"$${m.group(1)}$$", parts[i])
    return "".join(parts)


def convert_text(text: str) -> str:
    out, in_fence, marker = [], False, ""
    for line in text.split("\n"):
        m = FENCE.match(line)
        if m:
            tok = m.group(2)
            if not in_fence:
                in_fence, marker = True, tok[0]
            elif tok[0] == marker:
                in_fence, marker = False, ""
            out.append(line)
        elif in_fence:
            out.append(line)
        else:
            out.append(convert_line(line))
    return "\n".join(out)


def iter_targets(args):
    if args:
        for a in args:
            yield pathlib.Path(a)
    else:
        for d in ("Easy", "Medium", "Hard"):
            yield from sorted(pathlib.Path(d).rglob("*.md"))


def main():
    argv = sys.argv[1:]
    check = "--check" in argv
    paths = [a for a in argv if not a.startswith("--")]

    changed = 0
    for path in iter_targets(paths):
        if not path.is_file():
            continue
        original = path.read_text(encoding="utf-8")
        updated = convert_text(original)
        if updated != original:
            changed += 1
            n = updated.count("$$") - original.count("$$")
            print(f"{'would update' if check else 'updated'}: {path}  (+{n // 2} math spans)")
            if not check:
                path.write_text(updated, encoding="utf-8")

    print(f"\n{changed} file(s) {'need conversion' if check else 'converted'}.")
    sys.exit(1 if (check and changed) else 0)


if __name__ == "__main__":
    main()
