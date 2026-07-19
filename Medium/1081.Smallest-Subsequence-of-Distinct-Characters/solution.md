# Intuition

We need every distinct letter exactly once, in the lexicographically smallest
order that can still be formed as a subsequence. Greedy stack: keep a growing
answer; when a new letter arrives that is smaller than the stack top, and that
top letter appears again later, pop it so we can place the smaller letter
earlier.

# Approach: Monotonic Stack + Frequency

1. Count the frequency of each character in `s`.
2. Scan left to right with a stack and a bit mask of letters already in the
   stack.
3. Decrement the remaining count for the current character.
4. If it is already in the stack, skip it.
5. Otherwise, while the stack top is greater than the current character and
   still has remaining occurrences later, pop it and clear its bit.
6. Push the current character and set its bit.
7. Return the stack contents as the answer string.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `s.length` — each character is pushed
  and popped at most once.
- Space complexity: $$O(1)$$ extra space beyond the output — at most 26 letters
  on the stack, plus fixed-size frequency and mask arrays.

# Code

## Go

```go
func smallestSubsequence(s string) string {
    freq := [26]int{}
    for _, ch := range s {
        freq[ch-'a']++
    }
    stack := []uint8{}
    mask := 0 // [26]bool
    for i := range s {
        ch := s[i]
        idx := int(ch - 'a')

        if (mask>>idx)&1 == 0 {
            for len(stack) > 0 && stack[len(stack)-1] > ch {
                last := stack[len(stack)-1] - 'a'
                if freq[last] == 0 {
                    break
                }
                stack = stack[:len(stack)-1]
                mask = mask & ^(1 << last)
            }
            stack = append(stack, ch)
            mask |= 1 << idx
        }
        freq[idx]--
    }
    return string(stack)
}
```

## Rust

```rust
impl Solution {
    pub fn smallest_subsequence(s: String) -> String {
        let mut freq = [0; 26];
        for ch in s.chars() {
            freq[(ch as u8 - b'a') as usize] += 1;
        }
        let mut mask = 0;
        let mut stack: Vec<char> = Vec::new();
        for ch in s.chars() {
            let idx = (ch as u8 - b'a') as usize;
            freq[idx] -= 1;
            if (mask >> idx) & 1 == 0 {
                while let Some(&top) = stack.last() {
                  let last_idx = (top as u8 - b'a') as usize;
                    if top > ch && freq[last_idx] > 0 {
                        stack.pop();
                        mask &= !(1 << last_idx);
                    } else {
                        break;
                    }
                }
                stack.push(ch);
                mask |= (1 << idx);
            }

        }
        stack.into_iter().collect()
    }
}
```
