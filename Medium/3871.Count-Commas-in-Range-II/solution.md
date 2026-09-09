# Intuition

A number contributes one comma for every threshold it reaches:

- at least `1,000` contributes its first comma;
- at least `1,000,000` contributes a second;
- at least `1,000,000,000` contributes a third;
- and so on.

Instead of formatting every number, count how many numbers cross each threshold.
For a threshold `power`, all integers from `power` through `n` contribute one
comma for that threshold, giving `n - power + 1` commas.

# Approach: Count by Powers of 1000

Start with `power = 1000`. While `power <= n`:

1. Add `n - power + 1` to the answer.
2. Multiply `power` by `1000` to move to the next comma position.

Thus,

$$\text{answer} = \sum_{k \ge 1,\; 1000^k \le n} \left(n - 1000^k + 1\right)$$

Each comma is counted exactly once at the threshold that introduces it.

# Complexity

- Time complexity: $$O(\log_{1000} n)$$.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func countCommas(n int64) int64 {
    power, ans := int64(1000), int64(0)
    for power <= n {
        ans += n - power + 1
        power *= 1000
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn count_commas(n: i64) -> i64 {
        let mut power = 1000_i64;
        let mut ans = 0;
        while power <= n {
            ans += n - power + 1;
            power *= 1000;
        }
        ans
    }
}
```

## Python

```python
class Solution:
    def countCommas(self, n: int) -> int:
        power, ans = 1000, 0
        while power <= n:
            ans += n - power + 1
            power *= 1000
        return ans
```
