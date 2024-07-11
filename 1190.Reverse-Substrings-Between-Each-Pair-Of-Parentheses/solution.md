# Approach 1: Brute Force

1. Initialization: We initialize a stack to keep track of characters and handle nested parentheses.

2. Iterating through the string:

- If the current character is a closing parenthesis `)`, we pop characters from the stack until we find the corresponding opening parenthesis `(`. The popped characters are stored in a temporary string temp, which is then reversed and pushed back onto the stack.
- If the current character is not a closing parenthesis, we simply push it onto the stack.

3. Result Construction: After processing all characters, the stack will contain the final result without any parentheses, which we then convert to a string and return.

# Complexity

- Time complexity: $O(N^2)$.
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

<p>&nbsp;</p>

# Approach 2: Teleport

We use a stack to identify matching parentheses and a vector to store the teleport positions, which indicate where to jump when encountering a parenthesis. We then construct the result string by iterating through the original string and handling the teleportation to reverse the segments correctly.

## Explanation:

1. **Initialization**:
   - `n`: the length of the input string `s`.
   - `st`: a stack to keep track of the indices of opening parentheses.
   - `teleport`: a vector of size `n` to store the matching indices of parentheses.

2. **Identify Matching Parentheses**:
   - Iterate through the string `s`:
     - If the current character is '(', push its index onto the stack.
     - If the current character is ')', pop the top index from the stack to get the matching opening parenthesis. Store the matching indices in the `teleport` vector for both '(' and ')'.

3. **Construct Result String**:
   - Initialize `res` as an empty string to store the result.
   - Initialize `dir` as 1 to indicate the direction of traversal (1 for forward, -1 for backward).
   - Iterate through the string `s`:
     - If the current character is '(' or ')', teleport to the matching parenthesis index and reverse the direction.
     - Otherwise, append the current character to `res`.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(n)$

## Code 
```cpp
class Solution {
public:
    string reverseParentheses(string& s) {
        int n = s.size();

        stack<int> st;
        vector<int> teleport(n);

        for (int i = 0; i < n; i++) {
            if (s[i] == '(') {
                st.push(i);
            }
            else if (s[i] == ')') {
                int j = st.top();
                st.pop();

                teleport[i] = j;
                teleport[j] = i;
            }
        }

        string res;
        int dir = 1;

        for (int i = 0; i < n; i += dir) {
            if (s[i] == '(' || s[i] == ')') {
                i = teleport[i];
                dir *= -1;
            }
            else {
                res += s[i];
            }
        }

        return res;
    }
};
```