# Intuition

The string is a concatenation of **primitive** valid parentheses groups. Each
primitive group starts at depth 0, rises to depth 1 on its opening `(`, and
returns to depth 0 on its closing `)`. The outermost `(` and `)` of each primitive
piece are exactly the characters seen at depth 0 — skip those and keep everything
in between.

# Approach: Depth Counter

1. Track `count` = current nesting depth.
2. On `'('`: append only if `count > 0` (not the outermost open), then increment.
3. On `')'`: decrement first, then append only if `count > 0` (not the outermost
   close).
4. Return the built string.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `s.length` — one pass over the string.
- Space complexity: $$O(n)$$ for the output string.

# Code

## Go

```go
func removeOuterParentheses(s string) string {
    count := 0
    ans := make([]uint8, 0, len(s))
    for _, ch := range s {
        if ch == '(' {
            if count > 0 {
                ans = append(ans, '(')
            }
            count++
        } else if ch == ')' {
            count--
            if count > 0 {
                ans = append(ans, ')')
            }
        }
    }
    return string(ans)
}
```

## Rust

```rust
impl Solution {
    pub fn remove_outer_parentheses(s: String) -> String {
        let mut ans = String::new();
        let mut count = 0;
        for ch in s.chars() {
            if ch == '(' {
                if count > 0 {
                    ans.push(ch);
                }
                count += 1;
            } else if ch == ')' {
                count -= 1;
                if count > 0 {
                    ans.push(ch);
                }
            }
        }
        ans
    }
}
```
