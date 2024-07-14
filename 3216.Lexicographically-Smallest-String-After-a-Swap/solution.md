# Intuition

To find the lexicographically smallest string by swapping adjacent digits with the same parity, we need to identify the first opportunity where a swap will result in a smaller string. This approach ensures that we achieve the smallest possible lexicographical order with a single swap.

<p>&nbsp;</p>

# Approach

## Explanation:

1. **Initialization**:
   - Iterate through the string `s` starting from the second character (index 1) to the end.

2. **Checking adjacent digits**:
   - For each character `s[i]`, check if it has the same parity as the previous character `s[i-1]`.
     - Digits have the same parity if both are even or both are odd. This is determined using the modulus operator (`% 2`).
   - If `s[i-1]` is greater than `s[i]` and both have the same parity, swapping them will result in a smaller string.
     - Perform the swap.
     - Break out of the loop since only one swap is allowed.

3. **Return the modified string**:
   - Return the modified string `s` after the swap.

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the string.
- Space complexity: $O(1)$, as we are modifying the string in place and using only a constant amount of extra space.

## Code 
```cpp
class Solution {
public:
    string getSmallestString(string& s) {
        for (int i = 1; i < s.size(); i++) {
            if (s[i] % 2 == s[i-1] % 2 && s[i-1] > s[i]) {
                swap(s[i-1], s[i]);
                break;
            }
        }
        return move(s);
    }
};
```