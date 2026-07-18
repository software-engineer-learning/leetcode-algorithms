# Intuition

The answer depends only on the minimum and maximum values in `nums` — every other
element is ignored. Compute those two extremes in one pass, then take their GCD
with the Euclidean algorithm.

# Approach: Min/Max + Euclidean GCD

1. Find the smallest and largest elements of `nums`.
2. Return `gcd(smallest, largest)` via repeated modulo until the remainder is 0.

# Complexity

- Time complexity: $$O(n + \log A)$$, where `n` is `nums.length` and `A` is the
  maximum value — one linear scan plus Euclidean GCD.
- Space complexity: $$O(1)$$ extra space.

# Code

## Go

```go
import "slices"

func gcd(a, b int) int {
    for b != 0 {
        r := a % b
        a, b = b, r
    }
    return a
}
func findGCD(nums []int) int {
    smallest, largest := slices.Max(nums), slices.Min(nums)
    return gcd(smallest, largest)
}
```

## Rust

```rust
impl Solution {
    pub fn find_gcd(nums: Vec<i32>) -> i32 {
        let smallest = *nums.iter().min().unwrap_or(&i32::MAX);
        let largest = *nums.iter().max().unwrap_or(&0);
        Self::gcd(smallest, largest)
    }
    pub fn gcd(mut a: i32, mut b: i32) -> i32 {
        while b != 0 {
            (a, b) = (b, a % b);
        }
        a
    }
}
```
