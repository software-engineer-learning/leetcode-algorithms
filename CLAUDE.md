# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

This repo stores LeetCode algorithm solutions as markdown write-ups — there is no build or test suite; the "product" is the markdown plus the navigation files generated from it. Solutions are grouped by difficulty and problem id:

```text
Easy/
Medium/
Hard/
  └── <problem_id>.<Problem-Title-With-Hyphens>/
        ├── solution.md          # primary write-up (required)
        ├── description.md       # optional problem statement
        ├── solution-go.md       # optional language-specific file
        ├── solution-rust.md
        └── solution-cpp.md
```

Telegram group: <https://t.me/+ST0unit9nTRkYjhl>

## Adding a solution

Prefer the repo skill: `/add-solution` (in `.claude/skills/add-solution/`). It resolves problem metadata via the LeetCode GraphQL API (direct `WebFetch` on leetcode.com returns 403), creates the folder, writes `solution.md`/`description.md`, and updates the README index. The conventions below are what that skill enforces.

## Publishing pipeline

The repo is published two ways from the same markdown, each with its own generated navigation file:

- **GitBook** — Git-synced via `.gitbook.yaml`; navigation is `SUMMARY.md`.
- **Docsify** — static site served by `index.html`; navigation is `_sidebar.md`.

`SUMMARY.md` and `_sidebar.md` are **generated — do not hand-edit them**. After adding, renaming, or removing a problem folder or solution file, regenerate both:

```bash
./tools/gen-summary.sh   # rebuilds SUMMARY.md (GitBook TOC)
./tools/gen-sidebar.sh   # rebuilds _sidebar.md (Docsify sidebar)
```

Both scripts derive everything from the `<Difficulty>/<id>.<Title>/solution*.md` layout, so correct folder naming matters.

To check the whole publishing surface before pushing:

```bash
./tools/check-nav.sh   # nav freshness, link resolution, README counts, math convention
```

CI runs the same script: `.github/workflows/gitbook.yml` validates it on pull requests and, on pushes to `main`, regenerates the navigation and commits any drift so GitBook's Git sync publishes correct pages. That workflow then dispatches a rebuild of `swe-site`, authenticated with the `SITE_DISPATCH_TOKEN` secret. If that dispatch returns 403, diagnose the token's scoping with:

```bash
./tools/check-dispatch-token.sh              # read-only checks
./tools/check-dispatch-token.sh --dispatch   # also fire a real deploy
```

It reads the token from `$SITE_DISPATCH_TOKEN` or prompts for it — never pass a token as a command-line argument.

## Conventions

### Directory naming

- Format: `<problem_id>.<Problem-Title-With-Hyphens>`
- Examples:
  - `Medium/1833.Maximum-Ice-Cream-Bars/`
  - `Easy/1636.Sort-Array-By-Increasing-Frequency/`
- Place the folder under the correct difficulty directory (`Easy`, `Medium`, or `Hard`).

### Solution files

- Default file name: `solution.md`
- Use language-specific files when only one language is documented or when a language needs extra context:
  - `solution-go.md`
  - `solution-rust.md`
  - `solution-cpp.md`
- When documenting multiple languages for the same problem, prefer one `solution.md` with `## Go`, `## Rust`, etc. under `# Code`.

### Solution markdown template

Follow the structure used across the repo:

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

Notes:

- Use `$$...$$` (KaTeX) for all complexity/math expressions, e.g.
  `$$O(n \log n)$$`. GitBook's Git sync only renders double-dollar math; single
  `$...$` shows up as literal text there. GitHub renders `$$...$$` too, so this
  works on both. Plain text loses real typesetting (`\frac`, `\lceil`, ...).
- Run `./tools/mathfix.py` on new solution files to convert any `$...$` to
  `$$...$$` (it skips code blocks, inline code, and currency). Use
  `--check` to preview without writing. This is the canonical math tool;
  `tools/fix-math-markdown.py` and `tools/fix_complexity_markdown.py` are
  older scripts that convert math *away* from LaTeX (to Unicode/code spans)
  and contradict the current `$$...$$` convention — do not run them.
- Keep explanations concise and focused on why the approach works.
- Match the documentation style of nearby problems in the same folder/difficulty.
- Optional `description.md` can contain the LeetCode problem statement, examples, and constraints.

### Markdown style

Follow: <https://github.com/DavidAnson/markdownlint/blob/v0.35.0/doc/Rules.md>

### Git workflow

- Create a feature branch for new solutions.
- Commit message style: `Add solution for <id>. <Problem Title>`
- Open a PR against `main`; do not push unless asked.

## README maintenance

`README.md` contains a full solutions index grouped by difficulty (`Easy`, `Medium`, `Hard`). When adding a new problem:

1. Create the problem folder and solution file(s) under the correct difficulty directory.
2. Add a row to the matching difficulty table in `README.md` with:
   - Problem id and title
   - LeetCode link
   - Link(s) to each `solution*.md` variant (`main` for `solution.md`, or the suffix for `solution-<variant>.md`)

Also update the total problem count in the README header line ("Total: **N** problems") and the per-difficulty count in the section heading. Regenerate the tables from the repo if many entries change at once.

## Common patterns in this repo

- **Hash map / frequency counting** — e.g. 219, 1636, 1833
- **Stack** — e.g. 155, 921
- **Union-Find** — e.g. 1579
- **Binary search** — e.g. 875, 1760
- **DFS / BFS** — e.g. 1905, 1110
- **Trie** — e.g. 208
- **Segment tree** — e.g. 307

## What not to do

- Do not post full LeetCode test harness code unless the repo already uses that style for the problem.
- Do not create commits or PRs unless the user asks.
- Do not add unrelated refactors when adding a single solution.
- Do not create empty placeholder sections; prefer concise, complete write-ups.
