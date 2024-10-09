# Intuition

- A key insight to easily solve this problem is that you can ignore the valid parentheses.
- Try thinking about building a new string which only contains invalid parentheses, that string length will be the result

## Approach

- You can either use stack to build the new string mentioned above, or use 2 variables `open` and `close` to compute the result.

### Use stack

- Iterate the input string, at every characters you:
  - Check if the top of the stack is an opening bracket or not
  - If it is pop the top and move on
  - If not, add it to the stack
- The result is the length of the stack.

### Counting

- You can achieve $O(1)$ space complexity for this problem by using 2 variables. Lets call them `open` and `close`.
- A key insight is that when you encounter a closing bracket, you need to remove 1 open bracket before because it makes a complete parenthesis and no longer contribute to our result.
- Iterate the input string, at every character you:
  - Check if current char is '(' or not. If it is just increase `open`
  - Else, there is another 2 cases: either it makes a complete parenthesis or not
    - If there is already another '(' before (`open` > 0) then subtract open by 1 `open--`
    - If there are no '(' available (`open` == 0) then increase close
- The result is `open + close`

## Complexity

- **Time complexity:**  $O(n)$ as you iterate the whole string to compute the count or construct the stack

- **Space complexity:**  $O(n)$ for stack implementation and $O(1)$ for pointers/count implementation. In worse case the stack size will be the same as the length of the input string

## Code

```cpp
// count impl
class Solution {
public:
    int minAddToMakeValid(string s) {
        int n = s.size();
        int open = 0, close = 0;
        for(int i = 0; i < n; i++) {
            char c = s[i];
            if(c == '(') open++;
            else {
                if(open > 0) open--;
                else close++;
            }
        }
        return close+open;
    }
};

// stack impl
class Solution {
public:
    int minAddToMakeValid(string s) {
        int n = s.size();
        stack<char> stack;
        for(int i = 0; i < n; i++) {
            char c = s[i];
            bool valid = !stack.empty() && stack.top() == '(' && c == ')';
            if(valid) stack.pop();
            else stack.push(c);
        }
        return stack.size();
    }
};

```

```rust
impl Solution {
    pub fn min_add_to_make_valid(s: String) -> i32 {
        let (mut open_brackets, mut min_add) = (0, 0);
        for ch in s.chars() {
            if ch == '(' {
                open_brackets += 1;
            } else if open_brackets > 0 {   
                open_brackets -= 1;
            } else {
                min_add += 1;
            }
        }
        min_add + open_brackets
    }
}
```