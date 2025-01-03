# Approach

1. **Prefix and suffix sums:**

- Use a prefix sum array to calculate the sum of the first `i + 1` elements.
- Use the total sum of the array to calculate the suffix sum dynamically: $suffix_sum = total_sum - prefix_sum$.

2. **Check valid Splits:**

- Iterate through the array from index `0` to `n-2`.
- For each i, check if:
  $$prefix_sum \ge suffix_sum$$
  equiqvalent to:
  $$2 * prefix_sum \ge total_sum$$

1. **Count valid Splits:**

- Increment the count whenever the above condition is true.

# Complexity

- Time complexity: `O(N)` where N is the length of the given array.

- Space complexity: `O(1)` extra space.

# Code

## Go

```go
func waysToSplitArray(nums []int) int {
    ans, n, totalSum := 0, len(nums), 0
    for _, num := range nums {
        totalSum += num
    }
    sum := 0
    for i := 0; i < n - 1; i++ {
        sum += nums[i]
        if 2 * sum >= totalSum {
            ans++
        }
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn ways_to_split_array(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        let mut ans = 0;
        let total_sum = nums.iter().fold(0i64, |acc, &val| acc + val as i64);
        nums
          .into_iter()
          .take(n - 1)
          .scan(0, |s, num| {
            *s += num as i64;
            Some(if *s >= total_sum - *s {1} else {0})
          }).sum()
    }
}
```
