# Intuition

To solve the problem of finding the maximum score for a pair of sightseeing spots, we can break down the score equation as follows:

The score is given by:

$
\text{score}(i, j) = \text{values}[i] + \text{values}[j] + i - j
$

This can be rearranged as:

$
\text{score}(i, j) = (\text{values}[i] + i) + (\text{values}[j] - j)
$

the term $(\text{values}[i] + i)$ depends only on `i`, and $(\text{values}[j] - j)$ depends only on `j`. This allows us to use a greedy approach to compute the maximum score efficiently.

# Approach

1. Iterate Over values:

- Keep track of the maximum value of $(\text{values}[i] + i)$ encountered so far.

2. Calculate Scores:

- For each index i (starting from 1), compute the potential score using: `prev_max_score + values[i] - i`

1. Update `prev_max_score`:
   Update the maximum value of $(\text{values}[i] + i)$ as you iterate through the array.

# Complexity:

- Time complexity: $O(N)$.
- Space complexity: $O(1)$ for constant space used for variables.

# Code

## Go

```go
func maxScoreSightseeingPair(values []int) int {
    n := len(values)
    ans := 0
    prevMaxValue := values[0]
    for i := 1; i < n; i++ {
        ans = max(ans, prevMaxValue + values[i] - i)
        prevMaxValue = max(prevMaxValue, values[i] + i)
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn max_score_sightseeing_pair(values: Vec<i32>) -> i32 {
        let mut ans = 0;
        let mut n = values.len();
        let mut prev_max_score = values[0];
        for i in 1..n {
            ans = ans.max(prev_max_score + values[i] - i as i32);
            prev_max_score = prev_max_score.max(values[i] + i as i32);
        }
        ans
    }
}
```

$$
$$
