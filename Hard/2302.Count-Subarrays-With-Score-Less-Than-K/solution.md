# Intuition

The problem asks us to determine the number of non-empty subarrays of nums whose score is strictly less than `k`.

**Key Insight:**

- Subarrays are contiguous.
- Positive integers means:

  - sum increases as we add more elements.
  - product increases as we add more elements.

- We want an efficient method, not `O(n²)` brute-force.

# Approach (Sliding window)

- Maintain a window `[left..right]`.
- Keep track of sum inside the window.
- Expand `right` to include more elements.
- If `(sum * length) >= k`, then move left to shrink the window until it’s valid.
- For each right, number of valid subarrays ending at right is `(right - left + 1)`.

# Complexity

**Time Complexity:**

- O(N) where N is the number of elements in array.

**Space Complexity:**

- O(1) for extra space.

# Code

## Go

```go
func countSubarrays(nums []int, k int64) int64 {
    count, sum := 0, 0
    for left, right := 0, 0; right < len(nums); right++ {
        sum += nums[right]
        for sum * (right-left+1) >= int(k) {
            sum -= nums[left]
            left++
        }
        count += right - left + 1
    }
    return int64(count)
}
```

## Rust

```rust
impl Solution {
    pub fn count_subarrays(nums: Vec<i32>, k: i64) -> i64 {
        let (mut ans, mut sum, mut left) = (0, 0, 0);
        for right in 0..nums.len() {
            sum += nums[right] as i64;
            while sum * (right - left + 1) as i64 >= k {
                sum -= nums[left] as i64;
                left += 1;
            }
            ans += right - left + 1;
        }
        ans as i64
    }
}
```
