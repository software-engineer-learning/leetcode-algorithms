# Intuition

Both players play optimally and always take from either end. Define
`dp[i][j]` as the best score difference (current player minus opponent) on
subarray `nums[i..j]`. The current player chooses the end that maximizes
`nums[end] - dp[remaining]`. Player 1 wins if the difference on the full array
is non-negative.

# Approach: 1D DP on Score Difference

1. Initialize `dp` as a copy of `nums` — for a single-element subarray, the
   difference is that value.
2. For length from 2 up to `n`, fill intervals right-to-left:
   `dp[j] = max(nums[i] - dp[j], nums[j] - dp[j-1])` for each `i < j`.
3. After processing, `dp[n-1]` is the difference for `[0..n-1]`.
4. Return `dp[n-1] >= 0`.

# Complexity

- Time complexity: $$O(n^2)$$, where `n` is `nums.length` — every interval is
  computed once.
- Space complexity: $$O(n)$$ for the rolling 1D DP array.

# Code

## Go

```go
import "slices"

func predictTheWinner(nums []int) bool {
    n := len(nums)
    dp := slices.Clone(nums)
    for i := n - 2; i >= 0; i-- {
        for j := i + 1; j < n; j++ {
            dp[j] = max(nums[i]-dp[j], nums[j]-dp[j-1])
        }
    }

    return dp[n-1] >= 0
}
```

## Rust

```rust
impl Solution {
    pub fn predict_the_winner(nums: Vec<i32>) -> bool {
        let n = nums.len();
        let mut dp: Vec<i32> = nums.clone();
        for i in (0..n-1).rev() {
            for j in (i+1..n) {
                dp[j] = (nums[i] - dp[j]).max(nums[j] - dp[j-1]);
            }
        }
        dp[n-1] >= 0
    }
}
```
