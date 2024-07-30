# Intuition

You are given a string s consisting only of characters 'a' and 'b'. You can delete any number of characters in s to make s balanced. A string is balanced if there is no pair of indices (i, j) such that i < j and s[i] = 'b' and s[j]= 'a'.

Return the minimum number of deletions needed to make s balanced.

<p>&nbsp;</p>

# Approach 1: Dynamic Programming
To solve this problem, we can use dynamic programming. The idea is to iterate through the string while keeping track of the counts of 'a' and 'b' in a way that allows us to compute the minimum deletions required to make the string balanced.
## Explanation:

1. **Count Suffix 'a'**:
   - We create an array `countA` where `countA[i]` represents the number of 'a' characters from index `i` to the end of the string. This helps in calculating the number of 'a' characters that need to be deleted if we choose to keep all characters up to index `i`.

2. **Iterate and Count 'b'**:
   - We iterate through the string from left to right, keeping a running total of 'b' characters encountered (`countB`). For each position `i`, we compute the possible deletions required to make the string balanced by summing `countB` (deletions needed for 'b's up to `i`) and `countA[i]` (deletions needed for 'a's from `i` onwards).
3. **Calculate Total Points**:
   - 

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the string `s`.
- Space complexity: $O(n)$ for storing the `countA` array.

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