---
name: add-solution
description: Add a LeetCode solution write-up to this repo following its conventions. Use when the user wants to add/create a solution for a LeetCode problem (given a URL, problem id/title, and/or code in one or more languages). Creates the difficulty/<id>.<Title> folder, writes solution.md (+ optional description.md), and updates the README index.
---

# Add LeetCode Solution

Automates adding a new solution to this repository. Follow these steps in order.

## 1. Resolve the problem metadata

You need: **problem id**, **exact title**, **difficulty** (Easy/Medium/Hard), and the
**statement/examples/constraints**.

- If given a LeetCode URL, extract the `titleSlug` (the path segment after
  `/problems/`).
- `WebFetch` on leetcode.com usually returns **403** — do not rely on it. Instead
  query the GraphQL API for everything in one call:

  ```bash
  curl -s 'https://leetcode.com/graphql' \
    -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0' \
    --data '{"query":"query q($titleSlug:String!){question(titleSlug:$titleSlug){questionFrontendId title difficulty content}}","variables":{"titleSlug":"<TITLE-SLUG>"}}'
  ```

  `questionFrontendId` is the problem id, `difficulty` maps to the folder, and
  `content` is the HTML statement (convert to clean markdown for `description.md`).
- If the user already supplied id/title/difficulty, trust those; only fetch what's
  missing.

## 2. Create the folder

```text
<Difficulty>/<id>.<Problem-Title-With-Hyphens>/
```

- Difficulty is `Easy`, `Medium`, or `Hard` (matches LeetCode).
- Title: replace spaces with hyphens, keep the original casing and roman numerals
  (e.g. `3739.Count-Subarrays-With-Majority-Element-II`).
- Use `mkdir -p`.

## 3. Write `solution.md`

Use the repo template exactly:

```md
# Intuition

Brief explanation of the key insight.

# Approach: <Technique Name>

Step-by-step algorithm description.

# Complexity

- Time complexity: $$O(...)$$
- Space complexity: $$O(...)$$

# Code

## Go

```go
...
```

## Rust

```rust
...
```
```

Rules:

- One `solution.md` with `## Go`, `## Rust`, `## C++` sub-sections under `# Code`
  when documenting multiple languages. Use a single language-specific file
  (`solution-go.md`, `solution-rust.md`, `solution-cpp.md`) only when the user
  asks for that layout or just one language with extra context.
- Use `$$...$$` (KaTeX) for **all** math, including big-O. GitBook's Git sync only
  renders double-dollar math; single `$...$` shows up as literal text there.
  GitHub renders `$$...$$` too, so it works on both. Do **not** use single `$...$`
  or plain text for formulas.
- Write complexity on one line, e.g. `- Time complexity: $$O(n \log n)$$, where `n`
  is the array length.` (prose variables can stay in backticks; formulas go in `$$`).
- Use LaTeX inside the math: `\log`, `\frac{a}{b}`, `\lceil x \rceil`, `\cdot`,
  `\times`, `\le`, `\alpha(n)`, exponents `x^2` / `10^5`, subscripts `a_i`.
- After writing, run `./tools/mathfix.py <file>` to convert any stray `$...$` to
  `$$...$$` (it skips code blocks, inline code, and currency, and is idempotent).
- Keep explanations concise and focused on **why** the approach works.
- Paste the user's code verbatim (only fix obvious formatting); do not invent a
  different algorithm than what they provided.
- No empty placeholder sections.

## 4. Write `description.md` (optional but preferred)

Convert the GraphQL `content` HTML into markdown: a title heading, the statement,
`## Example N` blocks (in fenced ```text), and a `## Constraints` list. Use `^` for
exponents (e.g. `10^5`).

## 5. Update `README.md`

`README.md` has per-difficulty tables and counts.

1. Add a row to the matching difficulty table, kept in ascending id order:

   ```md
   | <id>. <Title> | [Link](https://leetcode.com/problems/<slug>/) | [main](<Difficulty>/<folder>/solution.md) |
   ```

   - The solution column links each variant: `main` for `solution.md`, or the
     suffix label for `solution-<variant>.md`, joined with ` · `
     (e.g. `[go](...) · [rust](...) · [main](...)`).

2. Increment the difficulty header count, e.g. `### Hard (27)` → `### Hard (28)`.
3. Increment the total near the top:
   `Total: **N** problems with at least one solution file.`

Also update the count in `CLAUDE.md` ("The index currently lists **N** problems.")
if you bump the README total.

## 6. Normalize math in markdown

Convert any single-dollar `$...$` to GitBook-compatible `$$...$$` (KaTeX) so the
math renders on both GitBook and GitHub:

```bash
./tools/mathfix.py <new-solution-file>   # or no args to scan Easy/ Medium/ Hard
```

Pass a specific file path to limit the scope. Use `--check` to preview changes.
The script skips code blocks, inline code, and currency, and is idempotent.

## 7. Regenerate the GitBook table of contents

The repo is published as a GitBook space synced from `main` (`.gitbook.yaml` →
`SUMMARY.md`). After creating the folder and solution file(s), regenerate the
table of contents so the new problem appears in the nav:

```bash
./tools/gen-summary.sh
```

This rewrites `SUMMARY.md` from the current folder layout (grouped by difficulty,
sorted by id, variant files nested). Commit the updated `SUMMARY.md` alongside the
solution so GitBook picks it up on the next push. (If the Docsify sidebar is also
in use, run `./tools/gen-sidebar.sh` to refresh `_sidebar.md` as well.)

## 8. Git (only if the user asks)

Do not commit or open a PR unless asked. When asked:

- Create a feature branch (e.g. `add-<id>-<short-slug>`).
- Commit message: `Add solution for <id>. <Problem Title>`
- Open a PR against `main`; do not push unless asked.

## Verification checklist

- [ ] Folder under the correct difficulty, named `<id>.<Title-With-Hyphens>`.
- [ ] `solution.md` follows the template; code compiles logically and matches the
      stated complexity.
- [ ] README row added in id order with working relative links.
- [ ] README difficulty count and total incremented; CLAUDE.md count synced.
- [ ] `SUMMARY.md` regenerated via `./tools/gen-summary.sh` so the GitBook nav
      includes the new problem.
- [ ] All math written as `$$...$$`; `./tools/mathfix.py` run on new/changed files.
