# Intuition

For each index, `prefixGcd[i] = gcd(nums[i], max of the prefix ending at i)`.
After sorting this array, pairs are formed as (smallest, largest), (second
smallest, second largest), and so on. The middle element is unused when `n` is
odd. Sum the GCD of each such pair.

# Approach: Prefix Max + Sort + Two Pointers

1. Scan `nums` left to right, tracking the running maximum `maxI`. Append
   `gcd(maxI, nums[i])` to `prefixGcd` (for `i = 0`, this is just `nums[0]`).
2. Sort `prefixGcd` in non-decreasing order.
3. With two pointers `l` and `r` from both ends, add `gcd(prefixGcd[l],
   prefixGcd[r])` while `l < r`.
4. Return the accumulated sum as a 64-bit integer.

# Complexity

- Time complexity: $$O(n \log n + n \log A)$$, where `n` is `nums.length` and
  `A` is the maximum value — sorting dominates; each GCD is $$O(\log A)$$.
- Space complexity: $$O(n)$$ for the `prefixGcd` array.

# Code

## Go

```go
import "sort"

func gcdSum(nums []int) int64 {
    n := len(nums)
    maxI := 0
    prefixGcd := make([]int, 0, n)
    maxI = nums[0]
    prefixGcd = append(prefixGcd, nums[0])
    for _, num := range nums[1:] {
        maxI = max(maxI, num)
        prefixGcd = append(prefixGcd, gcd(maxI, num))
    }

    sort.Ints(prefixGcd)
    ans := 0
    for l, r := 0, n-1; l < r; l, r = l+1, r-1 {
        ans += gcd(prefixGcd[l], prefixGcd[r])
    }
    return int64(ans)
}

func gcd(a, b int) int {
    for b != 0 {
        a, b = b, a%b
    }
    return a
}
```

## Rust

```rust
impl Solution {
    pub fn gcd_sum(nums: Vec<i32>) -> i64 {
        let n = nums.len();
        let mut prefix_gcd = Vec::with_capacity(n);
        prefix_gcd.push(nums[0]);
        let mut max_i = nums[0];
        for &num in nums.iter().skip(1) {
            max_i = max_i.max(num);
            prefix_gcd.push(Self::gcd(max_i, num));
        }

        prefix_gcd.sort_unstable();
        let (mut l, mut r) = (0, n - 1);
        let mut ans = 0;
        while l < r {
            ans += Self::gcd(prefix_gcd[l], prefix_gcd[r]) as i64;
            l += 1;
            r -= 1;
        }
        ans
    }

    pub fn gcd(mut a: i32, mut b: i32) -> i32 {
        while b != 0 {
            (a, b) = (b, a % b);
        }
        a
    }
}
```
