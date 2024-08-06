
=======
# Intuition

You are given a string `s` consisting only of characters 'a' and 'b'. You can delete any number of characters in `s` to make `s` balanced. A string is balanced if there is no pair of indices `(i, j)` such that `i < j` and `s[i] = 'b'` and `s[j] = 'a'`.

Return the minimum number of deletions needed to make `s` balanced.

<p>&nbsp;</p>

# Approach 1: Dynamic Programming
To solve this problem, we can use dynamic programming. The idea is to iterate through the string while keeping track of the counts of 'a' and 'b' in a way that allows us to compute the minimum deletions required to make the string balanced.
## Explanation:

1. **Count Suffix 'a'**:
   - We create an array `countA` where `countA[i]` represents the number of 'a' characters from index `i` to the end of the string. This helps in calculating the number of 'a' characters that need to be deleted if we choose to keep all characters up to index `i`.

2. **Iterate and Count 'b'**:
   - We iterate through the string from left to right, keeping a running total of 'b' characters encountered (`countB`). For each position `i`, we compute the possible deletions required to make the string balanced by summing `countB` (deletions needed for 'b's up to `i`) and `countA[i]` (deletions needed for 'a's from `i` onwards).

3. **Calculate Total Points**:

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the string `s`.
- Space complexity: $O(n)$ for storing the `countA` array.

## Code 
```cpp
class Solution {
public:
    int minimumDeletions(string s) {
        ios_base::sync_with_stdio(false);
        cin.tie(nullptr);
        cout.tie(nullptr);
        int n = s.length();
        vector<int> countA(n + 1, 0); 

        for (int i = n - 1; i >= 0; --i) {
            countA[i] = countA[i + 1] + (s[i] == 'a' ? 1 : 0);
        }

        int countB = 0; 
        int result = INT_MAX;

        for (int i = 0; i <= n; ++i) {
            result = min(result, countB + countA[i]);
            if (i < n && s[i] == 'b') {
                countB++;
            }
        }

        return result;
    }
};

```

<p>&nbsp;</p>

# Approach 2: Greedy
The idea is to traverse the string once while keeping track of the number of 'b' characters seen so far and the number of deletions required. We adjust the deletions whenever we encounter an 'a' such that the deletions needed do not exceed the number of 'b' characters already seen.

## Explanation:

1. **Initialize counters**:
   - `res` to store the number of deletions required.
   - `count` to store the number of 'b' characters encountered so far.

2. **Traverse the string**:
   - For each character `c` in the string `s`:
     - If `c` is 'b', increment `count`.
     - If `c` is 'a':
       - Increment `res` (indicating a potential deletion of this 'a' to balance the string).
       - If `res` exceeds `count`, set `res` to `count` to ensure the number of deletions does not surpass the number of 'b' characters.

3. **Return the result**:
   - After the traversal, `res` will hold the minimum number of deletions required to make the string balanced.

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the string.
- Space complexity: $O(1)$, since we use a constant amount of extra space.

## Code 
```cpp
class Solution {
public:
    int minimumDeletions(const string& s) {
        int res = 0;
        int count = 0;

        for (auto& c: s) {
            if (c == 'b') {
                ++count;
            }
            else if (++res > count) {
                res = count;
            }
        }

        return res;
    }
};
```

