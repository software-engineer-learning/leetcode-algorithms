
# Intuition
The goal is to find the minimum number of `pushes` required to type a given string `word` by remapping keys on a telephone keypad. Each letter must be assigned to a key, and we need to minimize the total number of key presses.
# Approach
1. **Count Character Frequencies:**:
   - Use a vector `Count` of size 26 to store the frequency of each character in the input string `word`.
   - Iterate through the string and populate the `Count` vector based on character occurrences.

2. **Sort Frequencies**:
   - Sort the `Count` vector in descending order to prioritize characters with higher frequencies.
3. **Calculate Pushes**:
   - Initialize a result variable res to zero.
   - Iterate through the sorted `Count` vector and calculate the required "pushes" for each character frequency using the formula `(i / 8 + 1) * Count[i]`. This formula ensures that the first 8 most frequent characters require 1 push, the next 8 require 2 pushes, and so on. 
   - Sum the calculated values into `res`.

# Complexity

- Time complexity: `O(N).`, where N is the length of the input string `word`.

- Space complexity: `O(1).`

# Code
```cpp
class Solution {
public:
    int minimumPushes(string word) {
        ios_base::sync_with_stdio(0);
        cin.tie(0);
        cout.tie(0);
        vector<int> Count(26, 0);
        int res = 0;

        for (char i : word) {
            Count[i - 'a']++;
        }
        sort(Count.rbegin(), Count.rend());
        for (int i = 0; i < 26; i++) {
            if(Count[i] == 0) break;
            res += (i / 8 + 1) * Count[i];
        }
        return res;
    }
};
```