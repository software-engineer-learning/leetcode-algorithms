# Intuition

A valid trade removes some internal block of `'1'`s (turning them into `'0'`s)
and then flips a larger block of `'0'`s into `'1'`s. That flip merges two adjacent
runs of zeros that sit on either side of a `'1'`-run, so the net gain equals the
sum of those two zero-run lengths (the removed ones become ones again as part of
the flipped block).

Without a trade the answer is just the number of `'1'`s. With one trade, add the
largest sum of any two consecutive zero-runs in `s`.

# Approach: Scan Consecutive Zero Runs

1. Count total `'1'`s in `s`.
2. Walk the string by runs of equal characters.
3. For each run of `'0'`s of length `current`, if a previous zero-run `prev`
   exists, update `best = max(best, prev + current)`.
4. Set `prev = current` and continue.
5. Return `countOne + best` (if no pair of zero-runs exists, `best` stays 0).

# Complexity

- Time complexity: $$O(n)$$, where `n` is `s.length` — one linear scan.
- Space complexity: $$O(1)$$ extra space.

# Code

## Go

```go
func maxActiveSectionsAfterTrade(s string) int {
    n := len(s)
    countOne := 0
    for _, ch := range s {
        if ch == '1' {
            countOne++
        }
    }
    best := 0
    for prev, current, i := -1, 0, 0; i < n; {
        start := i
        for i < n && s[i] == s[start] {
            i++
        }
        if s[start] == '0' {
            current = i - start
            if prev != -1 {
                best = max(best, prev+current)
            }
            prev = current
        }
    }
    return countOne + best
}
```

## Rust

```rust
impl Solution {
    pub fn max_active_sections_after_trade(s: String) -> i32 {
        let count_one = s.bytes().filter(|&c| c == b'1').count() as i32;
        let s = s.as_bytes();
        let n = s.len();

        let mut best = 0;
        let mut prev = -1;
        let mut current = 0;
        let mut i = 0;
        while i < n {
            let start = i;
            while i < n && s[i] == s[start] {
                i += 1;
            }
            if s[start] == b'0' {
                current = (i - start) as i32;
                if prev != -1 {
                    best = best.max(current + prev);
                }
                prev = current;
            }
        }
        count_one + best
    }
}
```
