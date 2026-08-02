# Intuition

Two players alternately take a pile from either end, both playing optimally. A
clean way to model "optimal play" is to track the **score difference** between the
current player and the opponent, rather than each player's absolute score. Alice
wins exactly when the best achievable difference over the whole row is positive.

There is also a shortcut: the number of piles is even and the total is odd, which
guarantees Alice can always win.

# Approach: Range DP (Score Difference)

Let `dp[i][j]` be the maximum score difference (current player minus opponent) the
player to move can secure on the subarray `piles[i..=j]`.

- Base case: a single pile leaves the mover ahead by its value, so
  `dp[i][i] = piles[i]`.
- Transition: the mover either takes `piles[i]` or `piles[j]`. After taking one,
  the opponent becomes the mover on the remaining range, so their optimal
  difference is subtracted:

  $$dp[i][j] = \max(piles[i] - dp[i+1][j],\; piles[j] - dp[i][j-1])$$

Filling by increasing range length, the answer for the full row is `dp[0][n-1]`.
Alice (the first mover) wins iff this difference is positive: `dp[0][n-1] > 0`.

# Approach: Math (Parity Argument)

The pile count is even, so the indices split into two groups — even-indexed piles
and odd-indexed piles. Whichever group has the larger sum, Alice can force herself
to take **exactly that entire group**: by always taking from the end that keeps the
opponent restricted to the other parity, she claims all evens or all odds. Since
the total is odd the two group sums can never be equal, so one group is strictly
larger and Alice takes it. Therefore Alice always wins and the answer is `true`.

# Complexity

- Range DP: Time complexity $$O(n^2)$$, space complexity $$O(n^2)$$, where `n` is
  the number of piles.
- Math: Time complexity $$O(1)$$, space complexity $$O(1)$$.

# Code

## Go

```go
// O(n^2) range DP
func stoneGame(piles []int) bool {
    n := len(piles)
    dp := make([][]int, n)
    for i := range dp {
        dp[i] = make([]int, n)
        dp[i][i] = piles[i]
    }
    for i := range n {
        for j := i + 1; j < n; j++ {
            dp[i][j] = max(piles[i]-dp[i+1][j], piles[j]-dp[i][j-1])
        }
    }
    return dp[0][n-1] > 0
}
```

```go
// O(1) parity argument
func stoneGame(piles []int) bool {
    return true
}
```

## Rust

```rust
// O(n^2) range DP
impl Solution {
    pub fn stone_game(piles: Vec<i32>) -> bool {
        let n = piles.len();
        let mut dp = vec![vec![0; n]; n];
        for i in 0..n {
            dp[i][i] = piles[i];
        }
        for i in 0..n {
            for j in i + 1..n {
                dp[i][j] = (piles[i] - dp[i+1][j]).max(piles[j] - dp[i][j-1]);
            }
        }
        dp[0][n-1] > 0
    }
}
```

```rust
// O(1) parity argument
impl Solution {
    pub fn stone_game(piles: Vec<i32>) -> bool {
        true
    }
}
```
