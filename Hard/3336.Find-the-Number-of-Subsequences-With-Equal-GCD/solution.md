# Intuition

Each array element may be: assigned to the first subsequence, assigned to the
second, or skipped. Track the running GCD of each subsequence; we want the
count of ways both subsequences are non-empty and end with the same GCD.

Let `dp[g1][g2]` be the number of ways to assign elements so far so the first
subsequence has GCD `g1` and the second has GCD `g2` (`0` means empty).

# Approach: DP on Pair of GCDs

1. Let `M` be `max(nums)`. Initialize `dp[0][0] = 1` (both subsequences empty).
2. For each `num` in `nums`, build `nextDp`:
   - Skip `num`: keep `(g1, g2)`.
   - Put `num` in the first subsequence: new GCD `gcd(g1, num)` (with `gcd(0, x) = x`).
   - Put `num` in the second subsequence: new GCD `gcd(g2, num)`.
3. Add transitions modulo $$10^9 + 7$$.
4. Sum `dp[i][i]` for all `i >= 1` (both non-empty and equal GCD).

# Complexity

- Time complexity: $$O(n \cdot M^2 \cdot \log M)$$, where `n` is `nums.length`
  and `M = \max(nums)` — each of the `n` updates scans an $$M \times M$$ DP table
  with GCD work per cell.
- Space complexity: $$O(M^2)$$ for the DP tables.

# Code

## Go

```go
import "slices"

const MOD = 1_000_000_007

func subsequencePairCount(nums []int) int {
    maxVal := slices.Max(nums)
    dp := make([][]int, maxVal+1)
    for i := range dp {
        dp[i] = make([]int, maxVal+1)
    }
    dp[0][0] = 1
    for _, num := range nums {
        nextDp := make([][]int, maxVal+1)
        for i := range nextDp {
            nextDp[i] = make([]int, maxVal+1)
        }
        for g1 := range maxVal + 1 {
            for g2 := range maxVal + 1 {
                valGCD := dp[g1][g2]
                if valGCD == 0 {
                    continue
                }
                n1, n2 := gcd(g1, num), gcd(g2, num)
                nextDp[g1][g2] = (nextDp[g1][g2] + valGCD) % MOD
                nextDp[n1][g2] = (nextDp[n1][g2] + valGCD) % MOD
                nextDp[g1][n2] = (nextDp[g1][n2] + valGCD) % MOD
            }
        }
        dp = nextDp
    }
    ans := 0
    for i := 1; i <= maxVal; i++ {
        ans = (ans + dp[i][i]) % MOD
    }
    return ans
}

func gcd(a, b int) int {
    for b > 0 {
        r := a % b
        a, b = b, r
    }
    return a
}
```

## Rust

```rust
const MOD: i32 = 1_000_000_007;
impl Solution {
    pub fn subsequence_pair_count(nums: Vec<i32>) -> i32 {
        let max_val = *nums.iter().max().unwrap_or(&0) as usize;
        let mut dp = vec![vec![0; max_val + 1]; max_val + 1];
        dp[0][0] = 1;
        let gcd = |mut a: i32, mut b: i32| -> i32 {
            while b != 0 {
                let r = a % b;
                a = b;
                b = r;
            }
            a
        };
        for num in nums.into_iter() {
            let num = num as usize;
            let mut next_dp = vec![vec![0; max_val + 1]; max_val + 1];
            for g1 in 0..max_val + 1 {
                for g2 in 0..max_val + 1 {
                    let val = dp[g1][g2];
                    if val == 0 {
                        continue;
                    }
                    let (n1, n2) = (gcd(g1 as i32, num as i32) as usize, gcd(g2 as i32, num as i32) as usize);
                    next_dp[g1][g2] = (next_dp[g1][g2] + val) % MOD;
                    next_dp[n1][g2] = (next_dp[n1][g2] + val) % MOD;
                    next_dp[g1][n2] = (next_dp[g1][n2] + val) % MOD;
                }
            }
            dp = next_dp;
        }
        let mut ans = 0;
        for i in 1..max_val + 1 {
            ans = (ans + dp[i][i]) % MOD;
        }
        ans
    }
}
```
