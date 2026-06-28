#!/usr/bin/env python3
"""Normalize math notation in solution markdown for GitBook/plain markdown.

GitBook in this repo does not reliably render $...$ / $$...$$ (KaTeX). This
tool converts LaTeX-style math to plain text, Unicode symbols, and HTML
<sup>/<sub> tags that render everywhere.

Examples:
  $O(n \\log n)$     -> O(n log n)
  $O(n^2)$           -> O(n²)
  $10^5$             -> 10⁵
  $$m, n$$           -> m, n
  `O(n)`             -> O(n)

Also merges split complexity bullets and removes orphan math lines.

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

_COMPLEXITY_NAME = (
    r"(?:"
    r"\*\*(?:Time|Space)\s+[Cc]omplexity:\*\*"
    r"|\*\*(?:Time|Space)\s+[Cc]omplexity\*\*"
    r"|(?:Time|Space)\s+[Cc]omplexity"
    r")"
)
COMPLEXITY_LABEL = re.compile(
    rf"^(\s*(?:[-*]\s+)?{_COMPLEXITY_NAME}\s*:?)\s*$",
    re.IGNORECASE,
)
HEADING = re.compile(r"^#\s+")
COMPLEXITY_HEADING = re.compile(r"^#\s+Complexity\b", re.IGNORECASE)
COMPLEXITY_LINE = re.compile(
    rf"^(\s*(?:[-*]\s+)?{_COMPLEXITY_NAME}\s*:?)",
    re.IGNORECASE,
)
ORPHAN_MATH = re.compile(r"^\s*\$[^$]*$")
BACKTICK_O = re.compile(r"`(O\([^`]*?\))\.?`")
DOUBLE_COMPLEXITY_DASH = re.compile(
    rf"^(\s*(?:[-*]\s+)?{_COMPLEXITY_NAME}\s*:?\s*)-\s+",
    re.IGNORECASE,
)
STANDALONE_MATH = re.compile(r"^\s*(?:[-*]\s+)?(O\([^)]+\).*)$")
INLINE_MATH = re.compile(r"(?<!\$)\$([^$\n]+?)\$(?!\$)")
DISPLAY_MATH = re.compile(r"\$\$([^$]+?)\$\$", re.DOTALL)

SUPERSCRIPT = str.maketrans("0123456789+-=()", "⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾")
SUBSCRIPT = str.maketrans("0123456789", "₀₁₂₃₄₅₆₇₈₉")

LATEX_COMMANDS: dict[str, str] = {
    r"\log": "log",
    r"\cdot": "·",
    r"\times": "×",
    r"\oplus": "⊕",
    r"\alpha": "α",
    r"\dots": "…",
    r"\ldots": "…",
    r"\leq": "≤",
    r"\le": "≤",
    r"\geq": "≥",
    r"\ge": "≥",
    r"\ne": "≠",
    r"\neq": "≠",
    r"\infty": "∞",
    r"\sum": "∑",
    r"\min": "min",
    r"\max": "max",
}


def to_superscript(exp: str) -> str:
    exp = exp.strip()
    if exp and all(ch in "0123456789+-=()" for ch in exp):
        return exp.translate(SUPERSCRIPT)
    return f"<sup>{exp}</sup>"


def to_subscript(sub: str) -> str:
    sub = sub.strip()
    if len(sub) == 1 and sub.isdigit():
        return sub.translate(SUBSCRIPT)
    return f"<sub>{sub}</sub>"


def replace_latex_commands(expr: str) -> str:
    for command, plain in sorted(LATEX_COMMANDS.items(), key=lambda item: -len(item[0])):
        expr = expr.replace(command, plain)
    return expr


def replace_exponents(expr: str) -> str:
    while True:
        updated = re.sub(
            r"([0-9A-Za-z)\]])\^\{([^}]+)\}",
            lambda match: match.group(1) + to_superscript(match.group(2)),
            expr,
        )
        updated = re.sub(
            r"([0-9A-Za-z)\]])\^([0-9]+)",
            lambda match: match.group(1) + to_superscript(match.group(2)),
            updated,
        )
        if updated == expr:
            return expr
        expr = updated


def replace_subscripts(expr: str) -> str:
    expr = re.sub(
        r"_\{([^}]+)\}",
        lambda match: to_subscript(match.group(1)),
        expr,
    )
    return re.sub(
        r"_([0-9]+)",
        lambda match: to_subscript(match.group(1)),
        expr,
    )


def latex_to_plain(expr: str) -> str:
    text = expr.strip()
    if not text:
        return text

    text = re.sub(r"\\text\{([^}]*)\}", r"\1", text)
    text = re.sub(r"\\frac\{([^}]*)\}\{([^}]*)\}", r"\1/\2", text)
    text = replace_latex_commands(text)
    text = replace_exponents(text)
    text = replace_subscripts(text)
    text = re.sub(r"\\([a-zA-Z]+)", r"\1", text)
    text = text.replace("{", "").replace("}", "")
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def strip_math(text: str) -> str:
    text = DISPLAY_MATH.sub(lambda match: latex_to_plain(match.group(1)), text)
    text = INLINE_MATH.sub(lambda match: latex_to_plain(match.group(1)), text)
    return text


def normalize_backtick_o(text: str) -> str:
    return BACKTICK_O.sub(lambda match: match.group(1).rstrip("."), text)


def continuation_body(line: str) -> str | None:
    stripped = line.strip()
    if not stripped or HEADING.match(stripped):
        return None
    if COMPLEXITY_LABEL.match(line):
        return None
    list_match = re.match(r"^-\s+(.+)$", stripped)
    if list_match:
        return list_match.group(1).strip()
    if line[:1].isspace() or stripped.startswith("O("):
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
                    prefix = line.rstrip()
                    if not re.search(r":\s*$", prefix):
                        prefix = f"{prefix}:"
                    merged.append(f"{prefix} {body}")
                    i = j + 1
                    continue
        merged.append(line)
        i += 1
    return merged


def collapse_standalone_math_lines(lines: list[str]) -> list[str]:
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
            prefix = line.rstrip()
            if not re.search(r":\s*$", prefix):
                prefix = f"{prefix}:"
            collapsed.append(f"{prefix} {body}")
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
            if ORPHAN_MATH.match(lines[idx].strip()):
                drop.add(idx)

    if not drop:
        return lines
    return [line for idx, line in enumerate(lines) if idx not in drop]


def normalize_line(line: str) -> str:
    line = normalize_backtick_o(line)
    line = strip_math(line)
    line = DOUBLE_COMPLEXITY_DASH.sub(r"\1", line)
    line = re.sub(
        r"(\*\*(?:Time|Space)\s+[Cc]omplexity:\*\*):",
        r"\1",
        line,
        flags=re.IGNORECASE,
    )
    line = re.sub(
        r"((?:Time|Space)\s+[Cc]omplexity):+(?=\s)",
        r"\1:",
        line,
        flags=re.IGNORECASE,
    )
    return line


def normalize_outside_code(text: str) -> str:
    parts = re.split(r"(```.*?```)", text, flags=re.DOTALL)
    normalized: list[str] = []
    for index, part in enumerate(parts):
        if index % 2 == 1:
            normalized.append(part)
        else:
            normalized.append(normalize_line(part) if part else part)
    return "".join(normalized)


def normalize_content(text: str) -> str:
    lines = text.splitlines()
    lines = merge_complexity_lines(lines)
    lines = collapse_standalone_math_lines(lines)
    lines = drop_orphan_math_in_complexity(lines)

    body = "\n".join(lines)
    if text.endswith("\n"):
        body += "\n"

    return normalize_outside_code(body)


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
