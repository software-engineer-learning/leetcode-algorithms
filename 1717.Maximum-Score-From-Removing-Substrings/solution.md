# Intuition

The problem requires us to maximize the points gained by removing specific substrings ("ab" or "ba") from the given string `s`. Depending on the points associated with removing each substring, we can derive a strategy to maximize our total score. The solution uses a greedy approach to achieve this by prioritizing the removal of the substring that yields the highest points.

<p>&nbsp;</p>

# Approach 1: Two Pointers & Greedy
The idea is to use a two-pointer technique combined with a stack-like approach to keep track of characters and remove substrings in a way that maximizes the points gained. We will prioritize the removal of the substring that gives the higher points first and then proceed to remove the other substring.

## Explanation:

1. **Prioritize High Points Removal**:
   - If `x` (points for "ab") is greater than `y` (points for "ba"), we first remove all occurrences of "ab" to maximize points.
   - If `y` is greater, we first remove all occurrences of "ba".

2. **Remove Function**:
   - We define a helper function `remove` that takes the string `s`, and two characters `first` and `second`.
   - We use a variable `top` to simulate the behavior of a stack where `top` indicates the index of the top element.
   - Iterate through the string. For each character:
     - If the top of the stack (represented by `s[top]`) and the current character form the target substring (`first` followed by `second`), we remove this pair and increase the count.
     - Otherwise, push the current character onto the stack.
   - After processing, resize the string to the valid portion tracked by `top`.

3. **Calculate Total Points**:
   - Depending on which substring removal yields higher points, call the `remove` function accordingly.
   - Calculate the total points by multiplying the count of removed substrings by their respective points.

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the string `s`.
- Space complexity: $O(1)$, as the modifications are done in-place and the stack usage is implicit in the string itself.

## Code 
```cpp
class Solution {
public:
    int maximumGain(string& s, int x, int y) {
        if (x > y) {
            return x * remove(s, 'a', 'b') + y * remove(s, 'b', 'a');
        }
        else {
            return y * remove(s, 'b', 'a') + x * remove(s, 'a', 'b');
        }
    }

    int remove(string& s, char first, char second) {
        int count = 0;
        int top = -1;

        for (int i = 0; i < s.size(); i++) {
            if (top >= 0 && s[top] == first && s[i] == second) {
                --top;
                ++count;
            } else {
                s[++top] = s[i];
            }
        }

        s.resize(++top);
        return count;
    }
};
```