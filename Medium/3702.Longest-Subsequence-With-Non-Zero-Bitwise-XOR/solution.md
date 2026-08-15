# Intuition

XOR of a set of numbers is zero when the bits cancel out perfectly. Look at the XOR
of the **entire** array:

- If the total XOR is already non-zero, the whole array is the answer — you can't do
  better than taking every element.
- If the total XOR is zero, taking all elements fails, but dropping a single
  non-zero element leaves a subsequence whose XOR equals that dropped value
  (non-zero). So the answer is `n - 1`, provided at least one non-zero element
  exists.
- If every element is zero, any subsequence XORs to zero, so no valid subsequence
  exists and the answer is `0`.

# Approach: XOR Parity Check

1. Compute `totalXor` over all elements and track whether the array is all zeroes.
2. If `totalXor != 0`, return `n` (the full array works).
3. Otherwise, if the array is all zeroes, return `0` (impossible).
4. Otherwise return `n - 1` (drop one non-zero element to break the cancellation).

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `nums` — a single pass.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func longestSubsequence(nums []int) int {
    totalXor := 0
    hasAllZeroes := true
    for _, num := range nums {
        totalXor ^= num
        if num > 0 {
            hasAllZeroes = false
        }
    }
    if totalXor > 0 {
        return len(nums)
    }
    if hasAllZeroes {
        return 0
    }
    return len(nums) - 1
}
```

## Rust

```rust
impl Solution {
    pub fn longest_subsequence(nums: Vec<i32>) -> i32 {
        let n = nums.len() as i32;
        let (mut total_xor, mut has_all_zeroes) = (0, true);
        for num in nums {
            total_xor ^= num;
            if num > 0 {
                has_all_zeroes = false;
            }
        }
        if total_xor > 0 {
           n
        } else if has_all_zeroes {
            0
        } else {
            n - 1
        }
    }
}
```
