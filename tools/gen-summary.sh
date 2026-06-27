#!/usr/bin/env bash
#
# Generate SUMMARY.md (GitBook table of contents) from the repo's folder layout.
#
#   <Difficulty>/<id>.<Title-With-Hyphens>/solution*.md
#
# Problems are grouped by difficulty (## headings) and sorted by numeric id.
# A folder with a plain solution.md gets a single page; one with only variant
# files (solution-go.md, solution-bottomup.md, ...) gets nested sub-pages.
#
# GitBook reads this file as the space's navigation (see .gitbook.yaml).
#
# Run from anywhere:  ./tools/gen-summary.sh
#
set -euo pipefail

# Move to repo root (parent of this script's directory).
cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

out="SUMMARY.md"

# Encode spaces so GitBook resolves folder names like "37. Sudoku Solver".
enc() { printf '%s' "$1" | sed 's/ /%20/g'; }

# "219.Contains-Duplicate-II" -> "Contains Duplicate II"
title_of() {
  local rest="${1#*.}"                       # strip leading "<id>."
  rest="${rest#"${rest%%[![:space:]]*}"}"    # trim leading spaces
  printf '%s' "${rest//-/ }"                  # hyphens -> spaces
}

{
  echo "# Table of contents"
  echo ""
  echo "* [🏠 Home](README.md)"

  for diff in Easy Medium Hard; do
    [ -d "$diff" ] || continue
    echo ""
    echo "## $diff"
    echo ""

    # List problem folders sorted numerically by the leading id.
    find "$diff" -mindepth 1 -maxdepth 1 -type d -print \
      | sort -t/ -k2 -n \
      | while IFS= read -r dir; do
          base="$(basename "$dir")"
          id="${base%%.*}"
          title="$(title_of "$base")"

          if [ -f "$dir/solution.md" ]; then
            printf '* [%s. %s](%s)\n' "$id" "$title" "$(enc "$dir/solution.md")"
          else
            # No plain solution.md: nest each variant file under the problem.
            printf '* %s. %s\n' "$id" "$title"
            for f in "$dir"/solution*.md; do
              [ -e "$f" ] || continue
              fname="$(basename "$f" .md)"     # e.g. solution-go
              variant="${fname#solution}"      # e.g. -go  (or "" )
              variant="${variant#-}"           # e.g. go
              [ -n "$variant" ] || variant="main"
              printf '  * [%s](%s)\n' "$variant" "$(enc "$f")"
            done
          fi
        done
  done
} > "$out"

count="$(grep -cE '^\s*\* \[' "$out" || true)"
echo "Wrote $out ($count linked pages)."
