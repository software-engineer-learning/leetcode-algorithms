# Intuition

Scan `s` once and ask, for each character, the only question that matters: is it
used to match the next needed character of `t`, or skipped? That gives a count
over prefixes. Let `dp[i][j]` be the number of distinct subsequences of the first
`i` characters of `s` that spell the first `j` characters of `t`:

$$dp[i][j] = dp[i-1][j] + \begin{cases} dp[i-1][j-1] & s[i-1] = t[j-1] \\ 0 & \text{otherwise} \end{cases}$$

The first term skips `s[i-1]`; the second consumes it to match `t[j-1]`, which is
only legal when the characters agree. The base case is `dp[i][0] = 1` — there is
exactly one way to spell the empty string, by taking nothing — and `dp[0][j] = 0`
for `j > 0`, since an empty source spells nothing.

Row `i` only ever reads row `i - 1`, so the table collapses to a single array
indexed by `j`, updated in place while `i` sweeps over `s`.

# Approach: 1-D DP over `t`, Sweeping `j` Downward

1. Allocate `dp` of length `n + 1` with `dp[0] = 1` and the rest `0`. The
   invariant is that after processing `i` characters of `s`, `dp[j]` holds the
   number of ways to spell `t[0..j)` from `s[0..i)`.
2. For each character `s[i-1]`, walk `j` from `n` down to `1`. If
   `s[i-1] == t[j-1]`, do `dp[j] += dp[j-1]`.
3. Return `dp[n]`.

The "skip" branch needs no code at all: leaving `dp[j]` untouched *is* carrying
`dp[i-1][j]` forward. Only the matching branch adds anything.

## Why `j` must descend

This is the one detail that makes or breaks the 1-D version. The update needs
`dp[j-1]` as it stood *before* the current character was considered — the value
from row `i - 1`. Descending `j` reads each cell before that cell is itself
rewritten, so the row-`i-1` values are still intact.

Ascending `j` would overwrite `dp[j-1]` first and then read the fresh row-`i`
value, letting a single character of `s` match several positions of `t` at once.
The damage shows up on the smallest possible input:

| `s`         | `t`        | descending (correct) | ascending (wrong) |
| ----------- | ---------- | -------------------- | ----------------- |
| `"aa"`      | `"aa"`     | `1`                  | `3`               |
| `"rabbbit"` | `"rabbit"` | `3`                  | `6`               |

With `s = "aa"` and `t = "aa"` the ascending sweep already reports `1` after
reading a single `a`, having used that one character for both positions of `t`.

# Worked example: `s = "babgbag"`, `t = "bag"` → `5`

`dp` starts as `[1, 0, 0, 0]`, the entries standing for `""`, `"b"`, `"ba"`,
`"bag"`.

| step | `s[i-1]` | update            | `dp` after     |
| ---- | -------- | ----------------- | -------------- |
| 1    | `b`      | `dp[1] += dp[0]`  | `[1, 1, 0, 0]` |
| 2    | `a`      | `dp[2] += dp[1]`  | `[1, 1, 1, 0]` |
| 3    | `b`      | `dp[1] += dp[0]`  | `[1, 2, 1, 0]` |
| 4    | `g`      | `dp[3] += dp[2]`  | `[1, 2, 1, 1]` |
| 5    | `b`      | `dp[1] += dp[0]`  | `[1, 3, 1, 1]` |
| 6    | `a`      | `dp[2] += dp[1]`  | `[1, 3, 4, 1]` |
| 7    | `g`      | `dp[3] += dp[2]`  | `[1, 3, 4, 5]` |

The answer is `dp[3] = 5`. Reading the last two steps backwards explains the
count: the final `g` extends all `4` ways of spelling `"ba"`, and one `"bag"` was
already completed by the earlier `g` at step 4 — but that earlier `g` could only
draw on the single `"ba"` that existed at the time.

# Overflow: what the 32-bit guarantee does and does not cover

The problem promises the *answer* fits in a signed 32-bit integer. It says
nothing about the intermediate cells, and those can be astronomically larger. For
`s = "a" * 1000` and `t = "a" * 999` — a perfectly legal input whose answer is
just `1000` — the cell `dp[500]` reaches $$\binom{1000}{500} \approx 10^{299}$$.
No fixed-width integer type holds that.

It turns out not to matter, and the reason is structural: the recurrence is
**addition only**. No subtraction, comparison, or division ever inspects a
partial sum. Two's-complement addition is exact modulo $$2^{32}$$, so every cell
stays congruent to its true value, and `dp[n]` comes out congruent to the true
answer modulo $$2^{32}$$. Since that answer is guaranteed to be a non-negative
value below $$2^{31}$$, the congruence pins it exactly. Wrapping is harmless
here.

The one build where it does bite is a **debug Rust build**, where arithmetic
overflow is a panic rather than a wrap: the input above aborts with `attempt to
add with overflow`. LeetCode compiles Rust with optimisations, so submissions
wrap and pass — but running the same code locally under `cargo run` without
`--release` will crash on adversarial input. Go's `int` is 64-bit and wraps
silently, so it is unaffected in practice, and Python's integers are unbounded,
so the question never arises.

# Complexity

- Time complexity: $$O(m \cdot n)$$, where `m` is the length of `s` and `n` the
  length of `t` — at most $$10^6$$ character comparisons under the constraints.
- Space complexity: $$O(n)$$ for the single rolling row, down from
  $$O(m \cdot n)$$ for the full table.

# Code

## Go

```go
func numDistinct(s string, t string) int {
    m, n := len(s), len(t)
    if m < n {
        return 0
    }
    dp := make([]int, n + 1)
    dp[0] = 1
    for i := range m {
        for j := n - 1; j >= 0; j-- {
            if s[i] == t[j] {
                dp[j+1] += dp[j]
            }
        }
    }
    return dp[n]
}
```

Two small departures from the other two versions. The `m < n` guard is a pure
shortcut — the DP already returns `0` when `t` is longer than `s`, because no
sweep can ever reach `dp[n]`. And the loops are 0-based, so the update reads
`dp[j+1] += dp[j]`; it is the same walk over the same pairs. Note `for i := range m`
is the Go 1.22 integer-range form; on an older toolchain write
`for i := 0; i < m; i++`.

## Rust

```rust
impl Solution {
    pub fn num_distinct(s: String, t: String) -> i32 {
        let (s, t) = (s.as_bytes(), t.as_bytes());
        let (m, n) = (s.len(), t.len());
        let mut dp = vec![0; n + 1];
        dp[0] = 1;
        for i in 1..=m {
            for j in (1..=n).rev() {
                if s[i-1] == t[j-1] {
                    dp[j] += dp[j-1];
                }
            }
        }
        dp[n]
    }
}
```

`as_bytes` avoids the cost of `chars()` on a `String`: the constraints say English
letters, so byte comparison and character comparison agree. The element type of
`dp` is inferred as `i32` from the return of `dp[n]`.

## Python

```python
class Solution:
    def numDistinct(self, s: str, t: str) -> int:
        m, n = len(s), len(t)
        dp = [0] * (n + 1)
        dp[0] = 1
        for i in range(1, m+1):
            for j in range(n, 0, -1):
                if s[i-1] == t[j-1]:
                    dp[j] += dp[j-1]
        return dp[n]
```

# Test cases

| `s`               | `t`             | answer   | why                                     |
| ----------------- | --------------- | -------- | --------------------------------------- |
| `"rabbbit"`       | `"rabbit"`      | `3`      | Example 1                               |
| `"babgbag"`       | `"bag"`         | `5`      | Example 2                               |
| `"aa"`            | `"aa"`          | `1`      | catches an ascending `j` sweep          |
| `"abc"`           | `"abcd"`        | `0`      | `t` longer than `s`                     |
| `"abc"`           | `"d"`           | `0`      | no character of `t` occurs in `s`       |
| `"abc"`           | `"abc"`         | `1`      | `s` and `t` identical                   |
| `"a" * 1000`      | `"a"`           | `1000`   | every position matches                  |
| `"a" * 1000`      | `"a" * 999`     | `1000`   | answer fits, intermediates hit `10^299` |

All three implementations were checked against a big-integer reference DP on a
shared corpus: the two examples, all 620 pairs of non-empty binary strings up to
length 4 with `|t| <= |s|`, 400 random small inputs over alphabets of one to ten
letters, and 36 large inputs up to the maximum `|s| = |t| = 1000`. Of the 1058
generated cases, 1039 have an answer that fits in 32 bits — the rest would violate
the problem's own guarantee — and all three agreed with the reference on every one
of them. The reference was itself validated against a brute force enumerating
subsequence index sets, on every case short enough to enumerate.

The Rust build used for that run was a debug build, where overflow panics rather
than wraps, and it completed the 1036 cases whose intermediates fit in `i32`
without panicking. Run on `s = "a" * 1000, t = "a" * 999` it does panic, while the
optimised build returns the correct `1000` — the wrapping argument above, observed
directly.
