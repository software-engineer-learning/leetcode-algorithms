# Intuition

- This is a very straightforward two pointers problem. If you don't know about this technique it is highly recommended to study it first.
- We can see that for str2 to be subsequence of str1, str2 length will have to be less or equal than str1 length. Also the order of the characters is very important.
- First, let's think about how we should tackle this:
    - We will need to compare all of str2 with str1.
    - If we found a match (either exact match or increamental match), we move to the next characters of str1 and str2.
    - If current `str1[i] != str2[j]`, we really only need to move i to the next position and keep tracking
    - The above 2 points strongly suggests some kind of iterator for both string.
    - If j ever goes out of bound of str2, then we can transform str1 so str2 is the subsequence, if not then it is simple impossible. 

<p>&nbsp;</p>

# Approach: Two pointers

- Create 2 variables to act as iterators/pointers for both string. (lets call them i and j for simplicity sake)
- Iterate through str1, compare `str1[i]` with `str2[j]`, if it is either exact match or incremental match that mean the portion `str2[0, j)` is the subsequence of str1. move both i and j to next position.
- If `str1[i] != str2[j]`, only increase i and perform comparision again.
- We can use the int conversion of char to simplify the increamental comparision (`str1[i] - 'a'` and `str1[i]-'a'+1`)

## Complexity
- Time complexity: $O(n)$ as in worst case we will travel all the str1, also if `str2.size() > str1.size()` then the result will always be false.
- Space complexity: $O(1)$ No extra buffer used, we only utilize 2 pointers to track the progress.

## Code 

### CPP
```cpp
class Solution {
public:
    bool canMakeSubsequence(string str1, string str2) {
        int m = str1.size(), n = str2.size();
        int idx = 0;
        for(int i = 0; i < m; i++) {
            char c = str1[i];
            bool valid = idx < n && ((c-'a'+1)%26 == str2[idx]-'a' || c-'a' == str2[idx]-'a');
            if(valid) {
                idx++;
            }
        }
        if(idx >= n) return true;
        return false;
    }
};
```