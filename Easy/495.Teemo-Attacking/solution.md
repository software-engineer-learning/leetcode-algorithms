# Intuition

Each attack poisons Ashe for `duration` seconds, but a new attack before the
effect ends only extends coverage by the gap since the previous attack (capped
at `duration`). The last attack always contributes a full `duration` seconds.

# Approach: One-Pass Interval Merging

1. Start with `ans = duration` for the poison window after the first attack.
2. For each consecutive pair `timeSeries[i - 1]` and `timeSeries[i]`, add
   `min(duration, timeSeries[i] - timeSeries[i - 1])` — the extra poison time
   gained before the timer resets.
3. Return `ans`.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `timeSeries.length` — one pass over
  adjacent pairs.
- Space complexity: $$O(1)$$ extra space.

# Code

## Go

```go
func findPoisonedDuration(timeSeries []int, duration int) int {
    ans := duration
    for i := 1; i < len(timeSeries); i++ {
        ans += min(duration, timeSeries[i]-timeSeries[i-1])
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn find_poisoned_duration(time_series: Vec<i32>, duration: i32) -> i32 {
        time_series
            .windows(2)
            .fold(duration, |acc, num| acc + duration.min(num[1] - num[0]))
    }
}
```
