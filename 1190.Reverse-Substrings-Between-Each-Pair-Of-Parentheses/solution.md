# Approach

1. Initialization: We initialize a stack to keep track of characters and handle nested parentheses.

2. Iterating through the string:

- If the current character is a closing parenthesis `)`, we pop characters from the stack until we find the corresponding opening parenthesis `(`. The popped characters are stored in a temporary string temp, which is then reversed and pushed back onto the stack.
- If the current character is not a closing parenthesis, we simply push it onto the stack.

3. Result Construction: After processing all characters, the stack will contain the final result without any parentheses, which we then convert to a string and return.

# Complexity

- Time complexity: $O(N)$.
- Space complexity: $O(N)$.

# Solution

## Go

```go
func reverseParentheses(s string) string {
    stack := []string{}
    for _, char := range s {
       if char == ')' {
            temp := []string{}
            for len(stack) > 0 {
                top := stack[len(stack) - 1]
                stack = stack[:len(stack) - 1]
                if top == "(" {
                    break
                }
                temp = append(temp, top)

            }
            stack = append(stack, temp...)
       } else {
        stack = append(stack, string(char));
       }
    }
    var result strings.Builder
    for _, str := range stack {
        result.WriteString(str)
    }
    return result.String()
}
```

## Rust

```rust
impl Solution {
    pub fn reverse_parentheses(s: String) -> String {
        let mut stack = vec![];
        for ch in s.chars() {
            if ch == ')' {
                let mut temp = vec![];
                while let Some(top) = stack.pop() {
                    if top == '(' {
                        break;
                    }
                    temp.push(top);
                }
                stack.extend(temp);
            } else {
                stack.push(ch);
            }
        }
        stack.into_iter().collect()
    }
}
```
