#!/usr/bin/env python3
"""
fix_complexity_markdown.py

Quét toàn bộ file Markdown (.md) trong một thư mục (repo LeetCode solutions),
tìm các công thức kiểu LaTeX inline `$...$` (vốn không render đúng trên GitBook)
và chuyển sang dạng `code span` + ký tự mũ Unicode, ví dụ:

    $O(n^2)$        ->  `O(n²)`
    $O(n)$          ->  `O(n)`
    $O(\\log n)$     ->  `O(log n)`
    $O(n \\log n)$   ->  `O(n log n)`
    $n$             ->  `n`
    $O(2^n)$        ->  `O(2ⁿ)`
    $O(n!)$         ->  `O(n!)`

----------------------------------------------------------------------
CÁCH DÙNG
----------------------------------------------------------------------
1) Xem trước những gì sẽ bị thay đổi (KHÔNG ghi file):

    python3 fix_complexity_markdown.py /path/to/repo --dry-run

2) Áp dụng thật (ghi đè file .md):

    python3 fix_complexity_markdown.py /path/to/repo

3) Chỉ áp dụng cho 1 file:

    python3 fix_complexity_markdown.py /path/to/repo/easy/solution.md

Script sẽ in ra danh sách file đã thay đổi và số lượng pattern đã sửa trong
từng file. Một bản backup (.bak) được tạo cho mỗi file bị sửa, trừ khi bạn
truyền --no-backup.
----------------------------------------------------------------------
"""

import argparse
import re
import sys
from pathlib import Path

# Bảng chuyển số/chữ thường dùng trong Big-O sang ký tự mũ Unicode
SUPERSCRIPT_MAP = {
    "0": "\u2070",
    "1": "\u00B9",
    "2": "\u00B2",
    "3": "\u00B3",
    "4": "\u2074",
    "5": "\u2075",
    "6": "\u2076",
    "7": "\u2077",
    "8": "\u2078",
    "9": "\u2079",
    "n": "\u207F",
    "k": "\u1D4F",
    "m": "\u1D50",
}


def to_superscript(token: str) -> str:
    """Chuyển một token số mũ (ví dụ '2', 'n', '10') sang ký tự Unicode superscript.
    Nếu gặp ký tự không có trong bảng, giữ nguyên ký tự gốc (an toàn, không crash)."""
    return "".join(SUPERSCRIPT_MAP.get(ch, ch) for ch in token)


def normalize_latex_expr(expr: str) -> str:
    """Chuyển nội dung bên trong $...$ (đã bỏ dấu $) thành văn bản thường,
    áp dụng các quy tắc thay thế LaTeX -> ký hiệu thường dùng trong Markdown/code span."""

    text = expr.strip()

    # \log -> log (loại bỏ backslash)
    text = re.sub(r"\\log", "log", text)
    # \cdot -> * (hiếm khi xuất hiện trong complexity nhưng xử lý cho chắc)
    text = re.sub(r"\\cdot", "*", text)
    # \times -> x
    text = re.sub(r"\\times", "x", text)
    # \sqrt{X} -> sqrt(X)
    text = re.sub(r"\\sqrt\{([^}]*)\}", r"sqrt(\1)", text)

    # Mũ dạng base^{exponent} (exponent nhiều ký tự, có ngoặc nhọn)
    def repl_braced_power(m):
        base, exp = m.group(1), m.group(2)
        return f"{base}{to_superscript(exp)}"

    text = re.sub(r"([A-Za-z0-9\)])\^\{([^}]+)\}", repl_braced_power, text)

    # Mũ dạng base^x (exponent 1 ký tự/số, không ngoặc nhọn), ví dụ n^2, 2^n
    def repl_simple_power(m):
        base, exp = m.group(1), m.group(2)
        return f"{base}{to_superscript(exp)}"

    text = re.sub(r"([A-Za-z0-9\)])\^([A-Za-z0-9])", repl_simple_power, text)

    # Dọn khoảng trắng dư thừa kiểu LaTeX, ví dụ "n \log n" sau khi xử lý \log
    # đã thành "n log n" rồi, chỉ cần normalize multiple spaces.
    text = re.sub(r"\s+", " ", text).strip()

    return text


# Regex bắt các cụm $...$ inline (không bắt $$...$$ block, không bắt \$ đã escape)
INLINE_MATH_PATTERN = re.compile(r"(?<!\\)\$(?!\$)([^$\n]+?)(?<!\\)\$(?!\$)")


def convert_line(line: str) -> tuple[str, int]:
    """Trả về (dòng đã sửa, số lượng pattern đã thay thế)."""
    count = 0

    def replacer(m):
        nonlocal count
        count += 1
        inner = normalize_latex_expr(m.group(1))
        return f"`{inner}`"

    new_line = INLINE_MATH_PATTERN.sub(replacer, line)
    return new_line, count


def process_file(path: Path, dry_run: bool, make_backup: bool) -> int:
    original = path.read_text(encoding="utf-8")
    lines = original.splitlines(keepends=True)

    total_changes = 0
    new_lines = []
    for line in lines:
        # Bỏ qua các dòng code block thuần (giữa ``` ```), tránh sửa nhầm code C++/Python
        # có chứa dấu $ (hiếm nhưng để an toàn ta vẫn xử lý theo state machine bên dưới
        # ở process_text thay vì ở đây).
        new_line, n = convert_line(line)
        total_changes += n
        new_lines.append(new_line)

    if total_changes == 0:
        return 0

    new_content = "".join(new_lines)

    if dry_run:
        print(f"[DRY-RUN] {path}: {total_changes} pattern(s) sẽ được sửa")
        return total_changes

    if make_backup:
        backup_path = path.with_suffix(path.suffix + ".bak")
        backup_path.write_text(original, encoding="utf-8")

    path.write_text(new_content, encoding="utf-8")
    print(f"[FIXED]   {path}: {total_changes} pattern(s) đã sửa")
    return total_changes


def process_text_aware_of_codeblocks(path: Path, dry_run: bool, make_backup: bool) -> int:
    """
    Phiên bản an toàn hơn: bỏ qua mọi đoạn nằm trong fenced code block (``` ... ```)
    để không vô tình sửa nhầm code mẫu (C++/Python/Go) có chứa dấu '$' (ví dụ trong
    string literal hoặc shell command minh hoạ).
    """
    original = path.read_text(encoding="utf-8")
    lines = original.splitlines(keepends=True)

    in_code_block = False
    total_changes = 0
    new_lines = []

    fence_re = re.compile(r"^\s*```")

    for line in lines:
        if fence_re.match(line):
            in_code_block = not in_code_block
            new_lines.append(line)
            continue

        if in_code_block:
            new_lines.append(line)
            continue

        new_line, n = convert_line(line)
        total_changes += n
        new_lines.append(new_line)

    if total_changes == 0:
        return 0

    new_content = "".join(new_lines)

    if dry_run:
        print(f"[DRY-RUN] {path}: {total_changes} pattern(s) sẽ được sửa")
        return total_changes

    if make_backup:
        backup_path = path.with_suffix(path.suffix + ".bak")
        backup_path.write_text(original, encoding="utf-8")

    path.write_text(new_content, encoding="utf-8")
    print(f"[FIXED]   {path}: {total_changes} pattern(s) đã sửa")
    return total_changes


def find_markdown_files(root: Path) -> list[Path]:
    if root.is_file():
        return [root]
    return sorted(root.rglob("*.md"))


def main():
    parser = argparse.ArgumentParser(
        description="Sửa pattern $O(n^2)$ kiểu LaTeX sang `O(n²)` (backtick + Unicode superscript) trong toàn bộ file Markdown."
    )
    parser.add_argument(
        "path", help="Đường dẫn tới repo (thư mục) hoặc 1 file .md cụ thể")
    parser.add_argument("--dry-run", action="store_true",
                        help="Chỉ xem trước, không ghi file")
    parser.add_argument("--no-backup", action="store_true",
                        help="Không tạo file .bak khi sửa")
    args = parser.parse_args()

    root = Path(args.path).expanduser().resolve()
    if not root.exists():
        sys.exit(f"Đường dẫn không tồn tại: {root}")

    md_files = find_markdown_files(root)
    if not md_files:
        sys.exit(f"Không tìm thấy file .md nào trong: {root}")

    print(f"Tìm thấy {len(md_files)} file .md. Bắt đầu xử lý...\n")

    total_files_changed = 0
    total_patterns = 0

    for f in md_files:
        n = process_text_aware_of_codeblocks(
            f, dry_run=args.dry_run, make_backup=not args.no_backup)
        if n > 0:
            total_files_changed += 1
            total_patterns += n

    print("\n--- Tổng kết ---")
    print(f"Số file bị ảnh hưởng : {total_files_changed}")
    print(f"Tổng số pattern sửa  : {total_patterns}")
    if args.dry_run:
        print("\nĐây là DRY-RUN, chưa có file nào bị ghi đè.")
        print("Chạy lại không có --dry-run để áp dụng thật.")
    elif total_files_changed > 0 and not args.no_backup:
        print(
            "\nMỗi file đã sửa có 1 bản backup '.bak' cùng thư mục, để khôi phục nếu cần.")


if __name__ == "__main__":
    main()
