# Intuition

A number written with `d` digits gets a comma after every three digits from the
right, so it carries $$\lfloor (d-1)/3 \rfloor$$ of them: none below `1,000`, one
from `1,000` to `999,999`, two from `1,000,000` on.

The constraint `n <= 10^5` keeps every number in range at six digits or fewer, so
no number in `[1, n]` can carry more than one comma. Summing commas therefore
degenerates into *counting numbers*: the total is simply how many integers in
`[1, n]` have at least four digits.

# Approach: Closed Form

The four-digit-and-up numbers in range are `1000, 1001, ..., n`, of which there
are `n - 1000 + 1 = n - 999`. When `n < 1000` that expression goes negative and
the true answer is `0`, so clamp it:

$$\text{answer} = \max(n - 999,\; 0)$$

No loop, no digit counting — one subtraction and one comparison.

## Why one comma is the ceiling

This is the constraint doing the real work, and it is worth seeing how much slack
there is. A second comma needs $$\lfloor (d-1)/3 \rfloor \ge 2$$, hence `d >= 7`,
hence a number of at least `1,000,000` — ten times the largest legal `n`. So the
single-band count is not a near-miss approximation; it holds comfortably past the
stated limit.

## What a larger limit would need

If the ceiling on `n` were raised, each additional band contributes one more comma
to everything above it, and the answer becomes a sum of the same clamped term:

$$\text{answer} = \sum_{k \ge 1} \max\!\left(n - 10^{3k} + 1,\; 0\right)$$

The `k = 1` term is exactly `max(n - 999, 0)`, and every later term is zero while
`n < 10^6`. That is why the one-liner stays correct for inputs a full order of
magnitude beyond the constraint.

# Worked examples

| `n`       | `n - 999` | answer  | why                                            |
| --------- | --------- | ------- | ---------------------------------------------- |
| `998`     | `-1`      | `0`     | Example 2 — every number has three digits      |
| `999`     | `0`       | `0`     | last comma-free input                          |
| `1000`    | `1`       | `1`     | first comma appears, at `"1,000"`              |
| `1002`    | `3`       | `3`     | Example 1 — `"1,000"`, `"1,001"`, `"1,002"`    |
| `100000`  | `99001`   | `99001` | maximal input                                  |

Example 1 reads directly off the formula: the commas come from the three numbers
`1,000` through `1,002`, one each.

# Edge cases

- **`n < 1000`.** The subtraction is negative — as low as `1 - 999 = -998` — and
  the clamp is the whole of the edge-case handling. Without it the function
  returns a negative count.
- **The `999`/`1000` boundary.** Both sides are covered by the same expression,
  since `n - 999` is `0` at `n = 999` and `1` at `n = 1000`.
- **Overflow.** Nothing to worry about: inputs are at most `10^5` and the
  intermediate never leaves `[-998, 99001]`, far inside `i32`.

# Complexity

- Time complexity: $$O(1)$$ — the answer is a single arithmetic expression; `n` is
  never iterated over.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func countCommas(n int) int {
    return max(n - 999, 0)
}
```

`max` is the builtin added in Go 1.21; on an older toolchain it has to be written
out as an `if` or a helper.

## Rust

```rust
impl Solution {
    pub fn count_commas(n: i32) -> i32 {
        (n-999).max(0)
    }
}
```

## Python

```python
class Solution:
    def countCommas(self, n: int) -> int:
        return max(n-999, 0)
```

# Test cases

| `n`      | answer  | why                                       |
| -------- | ------- | ----------------------------------------- |
| `1002`   | `3`     | Example 1                                 |
| `998`    | `0`     | Example 2                                 |
| `1`      | `0`     | smallest legal input                      |
| `999`    | `0`     | last input before the first comma         |
| `1000`   | `1`     | first input with a comma                  |
| `100000` | `99001` | largest legal input                       |

All three implementations were checked exhaustively: for every legal `n` from `1`
to `10^5` they agree with a reference that formats each number and counts its
separators via $$\lfloor (d-1)/3 \rfloor$$, accumulated as a running prefix sum —
no mismatches anywhere in the input domain. The same reference confirms the two
premises behind the formula: the most commas on any single number in range is one,
and the first number to carry one is `1,000`.
