# Intuition

The original array once held every integer in a contiguous range, and its
endpoints (the smallest and largest values) are guaranteed to still be present.
So the full range is exactly `[min(nums), max(nums)]`, and the answer is every
value in that range not present in `nums`. Since values are bounded by `100`, a
fixed boolean lookup table makes membership checks constant time.

# Approach: Boolean Presence Array

1. Scan `nums` once to find `min_value`, `max_value`, and mark each value as seen
   in a boolean array `seen` of size `101` (values are in `[1, 100]`).
2. Iterate `i` from `min_value` to `max_value`; whenever `seen[i]` is false, `i`
   is missing, so append it to the answer.

Because we iterate the range in increasing order, the output is already sorted.

# Complexity

- Time complexity: $$O(n + R)$$, where `n` is the length of `nums` and `R` is the
  range width `max - min`. Both are bounded by `100`.
- Space complexity: $$O(1)$$ — the `seen` array has a fixed size of `101`
  (excluding the output).

# Code

## Go

```go
func findMissingElements(nums []int) []int {
    minValue, maxValue := nums[0], nums[0]
    seen := make([]bool, 100+1)
    for _, num := range nums {
        minValue = min(minValue, num)
        maxValue = max(maxValue, num)
        seen[num] = true
    }
    ans := make([]int, 0)
    for num := minValue; num <= maxValue; num++ {
        if !seen[num] {
            ans = append(ans, num)
        }
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn find_missing_elements(nums: Vec<i32>) -> Vec<i32> {
        let (mut min_value, mut max_value) = (nums[0], nums[0]);
        let mut seens = [false; 101];
        for num in nums {
            min_value = min_value.min(num);
            max_value = max_value.max(num);
            seens[num as usize] = true;
        }
        let mut ans = vec![];
        for i in min_value..=max_value {
            let i_u32 = i as usize;
            if !seens[i_u32] {
                ans.push(i);
            }
        }
        ans
    }
}
```
