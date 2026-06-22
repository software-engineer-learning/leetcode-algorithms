# CLAUDE.md

Guidance for AI assistants working in this repository.

## Project overview

This repo stores LeetCode algorithm solutions as markdown write-ups. Solutions are grouped by difficulty and problem id:

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

- Time complexity: ...
- Space complexity: ...

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

- Use `$...$` for inline math in complexity sections when helpful.
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

The index currently lists **159** problems. Regenerate the tables from the repo if many entries change at once.

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
