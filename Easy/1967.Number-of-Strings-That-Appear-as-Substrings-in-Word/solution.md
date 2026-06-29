# Intuition

The task is just to count how many of the given `patterns` are substrings of
`word`. Since the inputs are tiny (everything `<= 100`), a direct substring check
per pattern is more than fast enough — no preprocessing or suffix structure
needed.

# Approach: Direct substring check

Iterate over each pattern and test whether it occurs in `word` using the
language's built-in substring search (`String::contains` in Rust,
`strings.Contains` in Go). Increment a counter for every pattern that matches and
return the total.

# Complexity

- Time complexity: $$O(p \cdot L \cdot m)$$, where `p` is the number of patterns,
  `L` is the length of `word`, and `m` is the longest pattern length — each of the
  `p` substring searches is $$O(L \cdot m)$$ in the worst case.
- Space complexity: $$O(1)$$ extra space (only a counter is kept).

# Code

## Go

```go
import "strings"

func numOfStrings(patterns []string, word string) int {
    count := 0
    for _, pattern := range patterns {
        if strings.Contains(word, pattern) {
            count++
        }
    }
    return count
}
```

## Rust

```rust
impl Solution {
    pub fn num_of_strings(patterns: Vec<String>, word: String) -> i32 {
        let mut ans = 0;
        for pattern in patterns.into_iter() {
            if word.contains(&pattern) {
                ans += 1;
            }
        }
        ans
    }
}
```
