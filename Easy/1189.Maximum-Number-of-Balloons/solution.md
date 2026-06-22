# Intuition

The word **balloon** needs one `b`, one `a`, one `n`, and **two** each of `l` and `o`. Each complete word consumes those letters from `text`, so the answer is limited by whichever required letter runs out first.

Count how many times each needed letter appears, halve the counts for `l` and `o`, then take the minimum.

# Approach: Frequency Count

1. Count character frequencies in `text`.
2. For `l` and `o`, divide their counts by `2` because each **balloon** uses two of each.
3. Return the minimum among the counts for `b`, `a`, `l`, `o`, and `n`.

# Complexity

- Time complexity: $O(n)$, where $n$ is the length of `text`.
- Space complexity: $O(1)$ — at most 26 letters (Go) or 5 tracked letters (Rust).

# Code

## Go

```go
func maxNumberOfBalloons(text string) int {
    freq := [26]int{}
    for _, ch := range text {
        freq[ch-'a']++
    }
    return min(freq['a'-'a'], freq['b'-'a'], freq['l'-'a']/2, freq['o'-'a']/2, freq['n'-'a'])
}
```

## Rust

```rust
impl Solution {
    pub fn max_number_of_balloons(text: String) -> i32 {
        let mut freq = [0; 5];
        for ch in text.as_bytes() {
            match ch {
                b'a' => freq[0] += 1,
                b'b' => freq[1] += 1,
                b'l' => freq[2] += 1,
                b'o' => freq[3] += 1,
                b'n' => freq[4] += 1,
                _ => {},
            }
        }
        freq[2] /= 2;
        freq[3] /= 2;
        *freq.iter().min().unwrap_or(&0)
    }
}
```
