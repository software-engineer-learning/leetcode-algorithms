#!/usr/bin/env python3
"""Normalize inline math in solution markdown files.

Fixes common KaTeX/GitBook rendering issues:
- Spaces inside $ delimiters ($ O(n) $ -> $O(n)$)
- Split complexity bullets (label on one line, math on the next)
- Big-O notation in backticks (`O(n)` -> $O(n)$)
- Display math used for short inline vars ($$n$$ -> $n$)
- Orphan / broken math lines in # Complexity sections
- Bare O(...) on complexity lines without math delimiters

Usage:
  ./tools/fix-math-markdown.py              # fix all solution*.md
  ./tools/fix-math-markdown.py --check      # report only, no writes
  ./tools/fix-math-markdown.py path/to/file # fix specific file(s)
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

COMPLEXITY_LABEL = re.compile(
    r"^(\s*(?:[-*]\s+)?(?:\*\*)?(?:Time|Space)\s+[Cc]omplexity(?:\*\*)?\s*:)\s*$",
    re.IGNORECASE,
)
HEADING = re.compile(r"^#\s+")
COMPLEXITY_HEADING = re.compile(r"^#\s+Complexity\b", re.IGNORECASE)
COMPLEXITY_LINE = re.compile(
    r"^(\s*(?:[-*]\s+)?(?:\*\*)?(?:Time|Space)\s+[Cc]omplexity(?:\*\*)?\s*:)",
    re.IGNORECASE,
)
ORPHAN_MATH = re.compile(r"^\s*\$O\([^)]*\)\s*$")
BACKTICK_O = re.compile(r"`(O\([^`]*?\))\.?`")
SPACED_INLINE = re.compile(r"(?<!\$)\$\s+([^$]+?)\s+\$(?!\$)")
DISPLAY_INLINE = re.compile(r"\$\$([^$\n]+?)\$\$")
BARE_O_AFTER_LABEL = re.compile(
    r"^(\s*(?:[-*]\s+)?(?:\*\*)?(?:Time|Space)\s+[Cc]omplexity(?:\*\*)?\s*:\s*)"
    r"(O\([^$\n]+?\))(\s*[,.]|$|\s+[-—])",
    re.IGNORECASE,
)
UNCLOSED_O = re.compile(r"^\s*\$O\([^)]*\)\s*$")
DOUBLE_COMPLEXITY_DASH = re.compile(
    r"^(\s*(?:[-*]\s+)?(?:\*\*)?(?:Time|Space)\s+[Cc]omplexity(?:\*\*)?\s*:\s*)-\s+",
    re.IGNORECASE,
)
STANDALONE_MATH = re.compile(r"^\s*(?:[-*]\s+)?(\$[^$]+\$.*)$")


def is_display_math(content: str) -> bool:
    stripped = content.strip()
    if not stripped:
        return True
    if "\n" in content:
        return True
    if any(token in stripped for token in (r"\begin", r"\frac", r"\text", r"\sum", r"\cdot")):
        return True
    if stripped.startswith("O(") or stripped.startswith("O\\"):
        return len(stripped) > 80
    return False


MATH_INNER = re.compile(
    r"^(?:O\(|\\|[0-9]|[A-Za-z][\w\\^]*(?:\(|\^|_|\\|log|alpha|sum|cdot|times|cdot|frac))"
)


def looks_like_math(inner: str) -> bool:
    stripped = inner.strip()
    if not stripped:
        return False
    return bool(MATH_INNER.match(stripped))


def normalize_spaced_inline(text: str) -> str:
    def repl(match: re.Match[str]) -> str:
        inner = match.group(1).strip()
        if not looks_like_math(inner):
            return match.group(0)
        return f"${inner}$"

    return SPACED_INLINE.sub(repl, text)


def normalize_display_inline(text: str) -> str:
    def repl(match: re.Match[str]) -> str:
        content = match.group(1)
        if is_display_math(content):
            return match.group(0)
        inner = content.strip()
        return f"${inner}$"

    return DISPLAY_INLINE.sub(repl, text)


def normalize_backtick_o(text: str) -> str:
    def repl(match: re.Match[str]) -> str:
        expr = match.group(1).rstrip(".")
        return f"${expr}$"

    return BACKTICK_O.sub(repl, text)


def normalize_bare_o(text: str) -> str:
    def repl(match: re.Match[str]) -> str:
        prefix, expr, suffix = match.group(1), match.group(2), match.group(3)
        return f"{prefix}${expr.rstrip('.')}${suffix}"

    return BARE_O_AFTER_LABEL.sub(repl, text)


def continuation_body(line: str) -> str | None:
    stripped = line.strip()
    if not stripped or HEADING.match(stripped):
        return None
    if COMPLEXITY_LABEL.match(line):
        return None
    list_match = re.match(r"^-\s+(.+)$", stripped)
    if list_match:
        return list_match.group(1).strip()
    if line[:1].isspace() or stripped.startswith("$") or stripped.startswith("O("):
        return stripped
    return None


def merge_complexity_lines(lines: list[str]) -> list[str]:
    merged: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if COMPLEXITY_LABEL.match(line):
            j = i + 1
            while j < len(lines) and not lines[j].strip():
                j += 1
            if j < len(lines):
                body = continuation_body(lines[j])
                if body:
                    prefix = line.rstrip().rstrip(":")
                    merged.append(f"{prefix}: {body}")
                    i = j + 1
                    continue
        merged.append(line)
        i += 1
    return merged


def collapse_standalone_math_lines(lines: list[str]) -> list[str]:
    """Merge orphan `$O(n)$` lines into the preceding complexity label."""
    collapsed: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if (
            i + 1 < len(lines)
            and COMPLEXITY_LABEL.match(line)
            and STANDALONE_MATH.match(lines[i + 1])
        ):
            body = STANDALONE_MATH.match(lines[i + 1]).group(1).strip()
            prefix = line.rstrip().rstrip(":")
            collapsed.append(f"{prefix}: {body}")
            i += 2
            continue
        collapsed.append(line)
        i += 1
    return collapsed


def complexity_section_ranges(lines: list[str]) -> list[tuple[int, int]]:
    ranges: list[tuple[int, int]] = []
    i = 0
    while i < len(lines):
        if COMPLEXITY_HEADING.match(lines[i]):
            start = i + 1
            end = start
            while end < len(lines) and not HEADING.match(lines[end]):
                end += 1
            ranges.append((start, end))
        i += 1
    return ranges


def drop_orphan_math_in_complexity(lines: list[str]) -> list[str]:
    ranges = complexity_section_ranges(lines)
    if not ranges:
        return lines

    drop: set[int] = set()
    for start, end in ranges:
        for idx in range(start, end):
            line = lines[idx].strip()
            if ORPHAN_MATH.match(line) or UNCLOSED_O.match(line):
                drop.add(idx)

    if not drop:
        return lines
    return [line for idx, line in enumerate(lines) if idx not in drop]


def normalize_line(line: str, in_complexity: bool) -> str:
    line = normalize_backtick_o(line)
    line = normalize_display_inline(line)
    line = normalize_spaced_inline(line)
    line = DOUBLE_COMPLEXITY_DASH.sub(r"\1", line)
    if in_complexity or COMPLEXITY_LINE.match(line):
        line = normalize_bare_o(line)
    return line


def normalize_content(text: str) -> str:
    lines = text.splitlines()
    lines = drop_orphan_math_in_complexity(lines)
    lines = merge_complexity_lines(lines)
    lines = collapse_standalone_math_lines(lines)

    ranges = complexity_section_ranges(lines)
    complexity_indices: set[int] = set()
    for start, end in ranges:
        complexity_indices.update(range(start, end))

    normalized: list[str] = []
    for idx, line in enumerate(lines):
        normalized.append(normalize_line(line, idx in complexity_indices))

    result = "\n".join(normalized)
    if text.endswith("\n"):
        result += "\n"
    return result


def iter_solution_files(paths: list[Path]) -> list[Path]:
    if paths:
        return [p.resolve() for p in paths]
    return sorted(ROOT.glob("**/solution*.md"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "paths",
        nargs="*",
        type=Path,
        help="Specific markdown files (default: all solution*.md)",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Report files that would change without writing",
    )
    args = parser.parse_args()

    files = iter_solution_files(args.paths)
    changed_files: list[Path] = []

    for path in files:
        if not path.is_file():
            print(f"skip missing: {path}", file=sys.stderr)
            continue
        original = path.read_text(encoding="utf-8")
        updated = normalize_content(original)
        if updated == original:
            continue
        changed_files.append(path)
        if args.check:
            print(path.relative_to(ROOT))
        else:
            path.write_text(updated, encoding="utf-8")
            print(f"fixed: {path.relative_to(ROOT)}")

    if args.check:
        print(f"\n{len(changed_files)} file(s) would be updated.")
    else:
        print(f"\nUpdated {len(changed_files)} file(s).")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
