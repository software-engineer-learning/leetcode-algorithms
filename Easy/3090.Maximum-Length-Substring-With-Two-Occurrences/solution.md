# Intuition

We want the longest substring where no character appears more than twice. Validity
is monotonic: if a window is valid, so is any window inside it. This is the classic
sliding-window setup — grow the right edge, and shrink from the left only when a
character's count exceeds two.

# Approach: Sliding Window + Frequency Counts

Keep a window `[left, right]` and a size-26 frequency array for lowercase letters.

1. Extend `right`, incrementing the count of the new character.
2. If that character now appears more than twice, shrink from the left —
   decrementing counts and advancing `left` — until it appears at most twice again.
   Only the just-added character can break the invariant, so checking it suffices.
3. After each step the window is valid; update the answer with its length
   `right - left + 1`.

Each index enters and leaves the window at most once, so the scan is linear.

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `s` — each character is
  added and removed at most once.
- Space complexity: $$O(1)$$ — a fixed 26-element frequency array.

# Code

## Go

```go
func maximumLengthSubstring(s string) int {
    freq := [26]int{}
    left, ans := 0, 0
    for right, ch := range s {
        index := ch - 'a'
        freq[index]++
        for freq[index] > 2 {
            leftIdx := s[left] - 'a'
            freq[leftIdx]--
            left++
        }
        ans = max(ans, right - left + 1)
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn maximum_length_substring(s: String) -> i32 {
        let s = s.as_bytes();
        let mut freq = [0; 26];
        let (mut left, mut ans) = (0, 0);
        for right in 0..s.len() {
            let right_idx = (s[right] - b'a') as usize;
            freq[right_idx] += 1;
            while freq[right_idx] > 2 {
                let left_idx = (s[left] - b'a') as usize;
                freq[left_idx] -= 1;
                left += 1;
            }
            ans = ans.max(right - left + 1);
        }
        ans as i32
    }
}
```
