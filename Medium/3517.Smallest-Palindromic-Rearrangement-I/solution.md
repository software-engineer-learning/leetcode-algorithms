# Intuition

Because `s` is already a palindrome, the left half determines the right half.
To get the lexicographically smallest palindromic permutation, sort the left
half's characters ascending, keep the middle character when the length is odd,
and mirror the left half for the right half.

# Approach: Frequency Count Left Half

1. Count character frequencies in the left half `s[0 .. n/2)`.
2. Build `left` by emitting characters `'a'` to `'z'` according to those counts
   (already sorted).
3. Set `right` to the reverse of `left`.
4. If `n` is odd, place `s[n/2]` in the middle.
5. Concatenate `left + (middle?) + right`.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `s.length` — one pass over the left
  half plus $$O(n)$$ to build the result.
- Space complexity: $$O(n)$$ for the output (and temporary left/right buffers).

# Code

## Go

```go
import (
    "slices"
    "fmt"
)

func smallestPalindrome(s string) string {
    middle := len(s) / 2
    freq := [26]int{}
    for i := range middle {
        freq[s[i]-'a']++
    }
    left := []uint8{}
    for i := range 26 {
        if freq[i] > 0 {
            for range freq[i] {
                left = append(left, uint8(i+'a'))
            }
        }
    }

    right := slices.Clone(left)
    slices.Reverse(right)

    if len(s)%2 == 1 {
        return fmt.Sprintf("%s%c%s", string(left), s[middle], string(right))
    } else {
        return fmt.Sprintf("%s%s", string(left), string(right))
    }
}
```

## Rust

```rust
impl Solution {
    pub fn smallest_palindrome(s: String) -> String {
        let s = s.as_bytes();
        let mut freq = [0; 26];
        let middle = s.len() / 2;
        for i in 0..middle {
            freq[(s[i] - b'a') as usize] += 1;
        }
        let mut left = Vec::with_capacity(middle);
        for i in 0..26 {
            for _ in 0..freq[i] {
                left.push((i as u8) + b'a');
            }
        }
        let mut right = left.clone();
        right.reverse();
        let mut res = Vec::with_capacity(s.len());
        res.extend_from_slice(&left);
        if s.len() % 2 == 1 {
            res.push(s[middle]);
        }
        res.extend_from_slice(&right);
        String::from_utf8(res).unwrap_or("".to_string())
    }
}
```
