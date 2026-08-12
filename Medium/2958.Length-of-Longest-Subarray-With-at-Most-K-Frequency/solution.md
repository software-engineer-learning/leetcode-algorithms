# Intuition

A subarray is "good" when every value appears at most `k` times. Goodness is
monotonic under shrinking: if a window is good, any sub-window is also good. This
is the classic setup for a sliding window — grow the right end greedily, and only
shrink from the left when the window becomes invalid.

# Approach: Sliding Window + Frequency Map

Maintain a window `[left, right]` and a hash map `freq` of value counts inside it.

1. Extend `right` one step at a time, incrementing `freq[nums[right]]`.
2. If the newly added value now exceeds `k` (`freq[nums[right]] > k`), shrink from
   the left — decrement `freq[nums[left]]` and advance `left` — until the window is
   good again. Only the just-added value can violate the constraint, so checking it
   is sufficient.
3. After each step the window is good, so update the answer with its length
   `right - left + 1`.

Each index enters and leaves the window at most once, giving linear time.

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `nums` — each element is
  added and removed from the window at most once.
- Space complexity: $$O(n)$$ for the frequency map in the worst case (all distinct
  values).

# Code

## Go

```go
func maxSubarrayLength(nums []int, k int) int {
    ans, left := 0, 0
    freq := map[int]int{}
    for right, num := range nums {
        freq[num]++
        for freq[num] > k {
            freq[nums[left]]--
            left++
        }
        ans = max(ans, right - left + 1)
    }
    return ans
}
```

## Rust

```rust
use std::collections::HashMap;
impl Solution {
    pub fn max_subarray_length(nums: Vec<i32>, k: i32) -> i32 {
        let mut freq = HashMap::new();
        let mut ans = 0;
        let mut left = 0;
        for right in 0..nums.len() {
            let num = nums[right];
            *freq.entry(num).or_insert(0) += 1;
            while freq[&num] > k {
                if let Some(count) = freq.get_mut(&nums[left]) {
                    *count -= 1;
                }
                left += 1;
            }
            ans = ans.max(right - left + 1);
        }
        ans as i32
    }
}
```
