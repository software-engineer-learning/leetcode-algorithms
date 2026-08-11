# Intuition

The longest sequential prefix is uniquely determined: start at `nums[0]` and keep
extending while each element is exactly one more than the previous. Once we have
that prefix sum, the answer is simply the first integer `>= sum` that does not
appear in `nums`. Since values are small (`<= 50` for `50` elements, so any prefix
sum is at most `2500`), a fixed boolean presence table makes the membership scan
trivial.

# Approach: Prefix Sum + Presence Array

1. Mark every value present in `nums` in a boolean array `counts` sized `2501`
   (an upper bound on the longest sequential prefix sum).
2. Compute the longest sequential prefix sum: start with `sum = nums[0]` and add
   `nums[i]` while `nums[i] == nums[i-1] + 1`, stopping at the first break.
3. Scan `i` upward from `sum`; the first `i` with `counts[i] == false` is the
   answer.

# Complexity

- Time complexity: $$O(n + M)$$, where `n` is the array length and `M = 2500` is
  the value bound scanned for the missing integer.
- Space complexity: $$O(M)$$ for the presence array.

# Code

## Go

```go
func missingInteger(nums []int) int {
    counts := make([]bool, 2501)
    for _, num := range nums {
        counts[num] = true
    }
    sum := nums[0]
    for i := 1; i < len(nums) && nums[i] == nums[i-1] + 1; i++ {
        sum += nums[i]
    }
    for i := sum; i <= 2500; i++ {
        if !counts[i] {
            return i
        }
    }
    return -1
}
```

## Rust

```rust
impl Solution {
    pub fn missing_integer(nums: Vec<i32>) -> i32 {
        let mut freq = [false; 2501];
        let n = nums.len();
        for &num in &nums {
            freq[num as usize] = true;
        }
        let mut sum = nums[0];
        for i in 1..n {
            if nums[i] != nums[i-1] + 1 {
                break;
            }
            sum += nums[i];
        }
        for i in (sum as usize..=2500) {
            if !freq[i] {
                return i as i32;
            }
        }
        -1
    }
}
```
