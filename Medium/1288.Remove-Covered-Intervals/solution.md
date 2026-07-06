# Intuition

Interval `[a, b)` is covered by `[c, d)` when `c <= a` and `b <= d`. After sorting
by left endpoint, any interval that extends no farther right than the best end seen
so far is fully contained by a previous interval.

Sort by start ascending and, for equal starts, by end **descending** so the widest
interval at each start is processed first.

# Approach: Sort + Track Maximum Right Endpoint

1. Sort intervals by `start` ascending; break ties with `end` descending.
2. Scan in order, keeping `maxVal` = largest right endpoint seen.
3. If `interval[1] > maxVal`, this interval is not covered — increment the answer
   and update `maxVal`.
4. Return the count of non-covered intervals.

# Complexity

- Time complexity: $$O(n \log n)$$, where `n` is `intervals.length` — dominated by
  sorting.
- Space complexity: $$O(\log n)$$ to $$O(n)$$ depending on the sort implementation
  (excluding the input).

# Code

## Go

```go
import "sort"

func removeCoveredIntervals(intervals [][]int) int {
    sort.Slice(intervals, func(i, j int) bool {
        if intervals[i][0] == intervals[j][0] {
            return intervals[i][1] > intervals[j][1]
        }
        return intervals[i][0] < intervals[j][0]
    })
    ans, maxVal := 0, 0
    for _, interval := range intervals {
        currVal := interval[1]
        if maxVal < currVal {
            maxVal = currVal
            ans++
        }
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn remove_covered_intervals(mut intervals: Vec<Vec<i32>>) -> i32 {
        intervals.sort_unstable_by(|a, b| {
            if a[0] == b[0] {
                b[1].cmp(&a[1])
            } else {
                a[0].cmp(&b[0])
            }
        });
        let (mut ans, mut max_val) = (0, 0);
        for interval in &intervals {
            if max_val < interval[1] {
                max_val = interval[1];
                ans += 1;
            }
        }
        ans as i32
    }
}
```
