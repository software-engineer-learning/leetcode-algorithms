# Intuition
The problem asks to find, for each value `val` in the array, the maximum number `num` such that `num < val` and `num | (num + 1) == val`. The bitwise OR operation `num | (num + 1)` sets all trailing zeros in `num` to 1, creating a pattern where consecutive numbers produce specific bitwise OR results. If no such `num` exists, we return -1.

# Approach

## Approach 1: Bit Manipulation (Rust Solution)
The Rust solution uses an elegant bit manipulation trick:
1. For each value `x`, if `x == 2`, return -1 (special case where no valid `num` exists).
2. Otherwise, compute `x - (((x + 1) & -(x + 1)) >> 1)`:
   - `(x + 1) & -(x + 1)` extracts the lowest set bit of `(x + 1)` using two's complement
   - Right shifting by 1 gives half of that value
   - Subtracting from `x` yields the maximum `num` where `num | (num + 1) == x`

## Approach 2: Brute Force Search (Go Solution)
The Go solution uses a straightforward approach:
1. For each value `val` in the array, iterate through all numbers `num` from 0 to `val - 1`.
2. Check if `num | (num + 1) == val`.
3. If found, store the maximum such `num`; otherwise, return -1.

# Complexity

## Rust Solution (Bit Manipulation)
- Time complexity:
  $O(N)$, where `N` is the length of the array. Each element is processed in constant time using bit operations.

- Space complexity:
  $O(1)$ excluding the output array, as we only use constant extra space for the computation.

## Go Solution (Brute Force)
- Time complexity:
  $O(N \cdot M)$, where `N` is the length of the array and `M` is the maximum value in the array. In the worst case, we iterate through all values up to each element.

- Space complexity:
  $O(N)$ for the output array.

# Code

## Rust Solution
```rust
impl Solution {
    pub fn min_bitwise_array(nums: Vec<i32>) -> Vec<i32> {
        nums.into_iter().map(|x: i32| -> i32 {
           if x == 2 {
                -1
           } else {
            x - (((x + 1) & -(x + 1)) >> 1)
           }
        }).collect()
    }
}
```

## Go Solution
```go
func minBitwiseArray(nums []int) []int {
    n := len(nums)
    ans := make([]int, n)
    for i, val := range nums {
        res := -1
        for num := 0; num < val; num++ {
            if num | (num + 1) == val {
                res = num
                break
            }
        }
        ans[i] = res
    }
    return ans
}
```
