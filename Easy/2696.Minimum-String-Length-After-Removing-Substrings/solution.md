# Intuition

- A key insite for this problem is that we can gradually build a newer string, and removing the substring "AB" and "CD" when we meet them.
- We need a way to efficiently keeping track of the last character in the newer string to compare it with the current string. Which data structure fits in this case? (hint: LIFO)

## Approach

- We can compute the final string by using a stack, as it provides O(1) access and deletion of the last elements. We can check the top of the stack in each steps while iterate the input string and pop it if we get "AB" or "CD" substring.
- We can further optimize this solution by instead of using stack, we will operate the input string for O(1) space. We can do this by using 2 variables as pointers: `curr` and the `index` pointers:
  - `curr` variable will be set to 0, this point to the index where we will fill the string with current `index` character.
  - We will gradually replace `s[curr]` with `s[index]`
  - At every steps, we will need to **check if the current character and previous character make up the substring "AB" or "CD" or not**:
    - If it is, we need to reduce the `curr` value by 1. We do this so that the next insertion will replace the previously inserted 'A' or 'C', hence effectively remove the supposed "AB" or "CD"
    - Else, we increase the `curr` after replacement at the above step
- The result will be `curr`
- We do not need to account for the end of string "AB" or "CD" case, because in those case, curr will be reduce from position n-1 to n-2, which still made up the correct result.

## Complexity

- Time complexity: $O(n)$, as we iterate the whole input string.
- Space complexity: $O(n)$ for stack impl and $O(1)$ for two pointers impl. In worse case the stack size is equal the input string size.

## Code

```cpp
class Solution {
public:
    int minLength(string s) {
        int n = s.size();
        if(n < 2) return n;
        int curr = 0;
        for(char c : s) {
            s[curr] = c;
            if(curr > 0) {
                bool is_ab = s[curr-1] == 'A' &&  s[curr] == 'B';
                bool is_cd = s[curr-1] == 'C' &&  s[curr] == 'D';
                if(is_ab || is_cd) {
                    curr--;
                    continue;
                }
            }
            curr++;
        }
        return curr;
    }
};
```

```Go
// stack impl
// Author: shawnlies
func minLength(s string) int { 
    stack := []rune{}
    for _, ch := range s {
        if len(stack) == 0 {
            stack = append(stack, ch)
            continue
        }
        if (ch == 'B' && stack[len(stack) - 1] == 'A') || (ch == 'D' && stack[len(stack) - 1] == 'C') {
            stack = stack[:len(stack) - 1]
        } else {
            stack = append(stack, ch)
        }
    }
    return len(stack)
}
```