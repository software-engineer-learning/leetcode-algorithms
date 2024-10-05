# Intuition

The task is to determine if one of the permutations of the string `s1` is present as a substring in `s2`. To achieve this, we use a sliding window approach that compares character frequencies between the current window of `s2` and `s1`.

<p>&nbsp;</p>

# Approach: Counting + Sliding Window

We maintain a frequency array (`freq[26]`) that tracks the difference in character counts between the current window in `s2` and the string `s1`. A key idea is that if all character frequencies match (i.e., their differences are zero), the current window of `s2` contains a permutation of `s1`.

## Explanation:

1. **Initial Setup**:
   - We first check if the length of `s1` is greater than `s2`. If `s1` is longer, it's impossible for a permutation of `s1` to be in `s2`, so we return `false`.
   - We initialize `freq[26]` to store the frequency difference between `s1` and the first window (substring) of `s2` of length `n` (length of `s1`).
   - `diffCount` keeps track of how many characters have non-zero frequency differences between `s1` and the current window in `s2`.

2. **Processing the First Window**:
   - For the first `n` characters of `s2`, we decrement the frequency for the characters of `s1` and increment it for the corresponding characters of `s2`.
   - We update `diffCount` based on the frequency values. If a frequency changes from zero to non-zero or vice versa, `diffCount` is adjusted accordingly.

3. **Sliding the Window**:
   - For each subsequent character in `s2` (starting from index `n`), we update the window by removing the effect of the character that is sliding out (at index `i - n`) and adding the effect of the new character (at index `i`).
   - After adjusting the frequencies, we check if `diffCount` is zero, which indicates that the current window matches a permutation of `s1`.

4. **Termination**:
   - If at any point `diffCount` becomes zero, we return `true`.
   - If we finish sliding through `s2` without finding a valid window, we return `false`.

## Complexity

- **Time complexity**: $O(m)$, where `m` is the length of `s2`. We perform constant-time updates on the frequency array for each character in `s2`.
- **Space complexity**: $O(d)$, where `d` is the number of distinct characters (in this case, `d = 26` for lowercase English letters).

## Code 
```cpp
int freq[26];

class Solution {
public:
    bool checkInclusion(string& s1, string& s2) {
        int n = s1.size(), m = s2.size();
        if (n > m) return false;

        memset(freq, 0, sizeof(freq));
        int diffCount = 0;

        for (size_t i = 0; i < n; i++) {
            diffCount += (freq[s1[i] - 'a'] == 0) - (--freq[s1[i] - 'a'] == 0);
            diffCount += (freq[s2[i] - 'a'] == 0) - (++freq[s2[i] - 'a'] == 0);
        }

        if (diffCount == 0) return true;

        for (size_t i = n; i < m; i++) {
            diffCount += (freq[s2[i - n] - 'a'] == 0) - (--freq[s2[i - n] - 'a'] == 0);
            diffCount += (freq[s2[i] - 'a'] == 0) - (++freq[s2[i] - 'a'] == 0);

            if (diffCount == 0) return true;
        }

        return false;
    }
};
```
