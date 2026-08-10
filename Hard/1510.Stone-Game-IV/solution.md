# Intuition

This is an impartial game, so each pile size `i` is either a **winning** position
(the player to move can force a win) or a **losing** one. A position is winning if
there exists *some* move to a losing position for the opponent. The only moves are
removing a perfect square `j*j`, so `i` is winning when any `i - j*j` is a losing
position.

# Approach: Dynamic Programming (Game States)

Let `dp[i]` be `true` if the player to move on a pile of `i` stones wins with
optimal play.

- Base case: `dp[0] = false` — no move available, so the player to move loses.
- Transition: for each `i`, try every square `j*j <= i`. If some `dp[i - j*j]` is
  `false` (leaving the opponent in a losing position), then `dp[i] = true`.

The answer is `dp[n]` (Alice moves first). The Go version ORs across all squares;
the Rust version breaks early on the first winning move.

# Complexity

- Time complexity: $$O(n \sqrt{n})$$, since for each of the `n` states we try up to
  $$\sqrt{i}$$ square moves.
- Space complexity: $$O(n)$$ for the `dp` array.

# Code

## Go

```go
func winnerSquareGame(n int) bool {
    dp := make([]bool, n + 1)
    for i := 1; i <= n; i++ {
        for j := 1; j * j <= i; j++ {
            dp[i] = dp[i] || (!dp[i - j * j])
        }
    }
    return dp[n]
}
```

## Rust

```rust
impl Solution {
    pub fn winner_square_game(n: i32) -> bool {
        let n = n as usize;
        let mut dp = vec![false; n + 1];
        for i in 1..=n {
            let mut j = 1;
            while j * j <= i {
                if !dp[i - j * j] {
                    dp[i] = true;
                    break;
                }
                j += 1;
            }
        }
        dp[n]
    }
}
```
