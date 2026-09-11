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

````md
# Intuition

Brief explanation of the key insight.

# Approach: <Technique Name>

Step-by-step algorithm description.

## <Sub-heading for any subtlety worth its own section>

Use `##` sub-sections under the approach for anything that looks like a bug until
explained: an unusual loop bound, a sentinel value, a language-specific hazard.

# Worked example

`<the first LeetCode example>`:

| step | state | result |
| --- | --- | --- |
| 1 | ... | ... |

One or two sentences on what this example pins down that the others do not.

# Complexity

- Time complexity: $$O(...)$$, where `n` is ...
- Space complexity: $$O(...)$$

One line on what the naive alternative would cost, and which step avoids it.

# Code

## Go

```go
...
```

## Rust

```rust
...
```

## Python

```python
...
```

# Test cases

| input | answer | what it exercises |
| --- | --- | --- |
| `<example 1>` | `...` | Example 1 — traced above |
| `<edge case>` | `...` | ... |

One paragraph naming the reference implementation, the corpus, and the result.
````

Rules:

- One `solution.md` with `## Go`, `## Rust`, `## C++` sub-sections under `# Code`
  when documenting multiple languages. Use a single language-specific file
  (`solution-go.md`, `solution-rust.md`, `solution-cpp.md`) only when the user
  asks for that layout or just one language with extra context.
- Open code fences with three backticks and a bare language token, nothing
  else. When pasting from LeetCode, strip the trailing `[]` it adds after the
  language — GitBook tolerates it, but the MkDocs build of swe.springlee.dev
  stops recognising the line as a fence and the code leaks in as prose.
  Always close the final fence too.
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
- `# Worked example`, `# Complexity` and `# Test cases` are **required**, not
  optional — see 3a, 3b and 3c below for what each must contain.
- No empty placeholder sections. If a section would be filler, the fix is to run
  the code and get real content for it, not to delete the section.

## 3a. Write the `# Worked example` section

Trace the **first** LeetCode example through the actual algorithm, as a table with
one row per step. Pick a second example only when it exercises a branch the first
one misses (a tie-break, an empty result, a sentinel path).

**Every number in the table must come from running the code, never from mental
arithmetic.** Write a throwaway script that prints the trace, then transcribe it.
Hand-computed traces are the single most common way these write-ups go wrong, and
a wrong trace is worse than no trace.

Close with a sentence naming what the example demonstrates that the others do not.

Sample — from `Medium/2265.Count-Nodes-Equal-to-Average-of-Subtree/solution.md`:

````md
# Worked example

`root = [4,8,5,0,1,null,6]`:

```text
        4
      /   \
     8     5
    / \      \
   0   1      6
```

Post-order means children report before their parent:

| visit order | node | subtree sum | count | `sum / count` | counts? |
| --- | --- | --- | --- | --- | --- |
| 1 | `0` | `0` | `1` | `0` | **yes** |
| 2 | `1` | `1` | `1` | `1` | **yes** |
| 3 | `8` | `9` | `3` | `9 / 3 = 3` | no |
| 4 | `6` | `6` | `1` | `6` | **yes** |
| 5 | `5` | `11` | `2` | `11 / 2 = 5` | **yes** |
| 6 | `4` | `24` | `6` | `24 / 6 = 4` | **yes** |

Five nodes qualify. Two things this example demonstrates: every leaf always counts
(a single value equals its own average), and node `5` only qualifies because the
division floors — the exact average is `5.5`.
````

An ASCII diagram helps for trees and grids; skip it for flat arrays.

## 3b. Write the `# Complexity` section

Two bullets, each on one line, with the bound in `$$...$$` and the variable named
in prose. Then one line comparing against the obvious slower approach, so the
reader sees what the technique bought.

State the bound **per language** when the implementations genuinely differ — an
allocation in one and an in-place mutation in another is a real difference, not a
rounding error. Do not label something $$O(1)$$ space when it allocates an
`n`-element buffer.

Sample:

````md
# Complexity

- Time complexity: $$O(n)$$, where `n` is the number of nodes — each is visited
  once and does constant work.
- Space complexity: $$O(h)$$ for the recursion stack, where `h` is the tree
  height. That is $$O(\log n)$$ when balanced and $$O(n)$$ for a degenerate spine,
  which the constraints permit.

Recomputing each subtree independently would be $$O(n \cdot h)$$ — up to
$$O(n^2)$$ on a spine. The returned pair is what collapses that to linear.
````

**Never let a `$$...$$` span wrap across a newline.** GitBook reads the opening
`$$` as a block delimiter, finds no terminator on that line, and runs math mode
into the following prose — the next `#` heading then fails the page with
`You can't use 'macro parameter character #' in math mode`. Keep each span on one
line, or split it into two display blocks. `./tools/check-nav.sh` enforces this.

## 3c. Write the `# Test cases` section

A table of `input | answer | what it exercises`, containing **every** LeetCode
example plus the edge cases the constraints permit: empty results, single
elements, the value ceiling, the maximum size, and whatever degenerate shape the
problem allows.

Run every row. Do not put a value in this table that you have not executed.

Then one paragraph recording how the solutions were verified: the reference
implementation, the corpus, and the outcome. This is what lets a later reader
trust the page without re-deriving it.

Sample — from `Medium/2265.Count-Nodes-Equal-to-Average-of-Subtree/solution.md`:

````md
# Test cases

| tree | answer | what it exercises |
| --- | --- | --- |
| `[4,8,5,0,1,null,6]` | `5` | Example 1 — traced above |
| `[1]` | `1` | Example 2 — single node |
| `[0]` | `1` | zero value, `0 / 1 == 0` |
| `[2,1,4]` | `3` | root `2` matches `7 / 3 = 2` by flooring |
| 1000-node left spine of `7`s | `1000` | maximum depth; every node averages `7` |
| complete tree of 1000 nodes, values `0..999` | `500` | maximum size |

All three implementations were checked against a brute force that, for every node,
walks that node's entire subtree from scratch and compares against the linear
version. The corpus was **4005** trees: the two examples, 4000 randomly shaped
trees of up to 40 nodes over value ranges `0..3`, `0..10` and `0..1000` (small
ranges make ties and near-misses common), a 1000-node complete tree, and a
1000-deep left spine. All three agreed on every tree, and the Rust build was made
in debug mode where an overflow or a double `RefCell` borrow would panic — neither
occurred.
````

### How to verify before writing that paragraph

1. Write an independent reference — the naive definition, not a variant of the
   submitted algorithm.
2. Generate a corpus: every LeetCode example, then exhaustive small inputs
   (all arrays up to length 4 over a tiny alphabet catches ties and off-by-ones),
   then randoms, then the constraint ceiling.
3. Run each language against the corpus and diff the outputs against the
   reference **and** against each other.
4. Build Rust with plain `rustc` (no `-O`) so arithmetic overflow and `RefCell`
   double-borrows panic instead of passing silently.
5. Record real numbers. If a language could not be run — a toolchain too old for
   the syntax, say — state that and what was substituted.

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

- [ ] Checked whether the problem folder **already exists** before writing. If it
      does, merge into it — never overwrite; an existing `solution.md` may hold a
      solution in another language that is not in the paste.
- [ ] Folder under the correct difficulty, named `<id>.<Title-With-Hyphens>`.
- [ ] `solution.md` follows the template; code compiles logically and matches the
      stated complexity.
- [ ] `# Worked example` present, traced from a real run rather than by hand.
- [ ] `# Complexity` present, one line per bound, per-language where they differ.
- [ ] `# Test cases` present, every row executed, with the verification paragraph
      naming the reference, the corpus size and the outcome.
- [ ] README row added in id order with working relative links.
- [ ] README difficulty count and total incremented; CLAUDE.md count synced.
- [ ] `SUMMARY.md` regenerated via `./tools/gen-summary.sh` so the GitBook nav
      includes the new problem.
- [ ] All math written as `$$...$$`; `./tools/mathfix.py` run on new/changed files.
- [ ] `./tools/check-nav.sh` passes — it catches stale nav, broken links, wrong
      README counts, stray single `$`, and `$$...$$` spans that wrap a line.
