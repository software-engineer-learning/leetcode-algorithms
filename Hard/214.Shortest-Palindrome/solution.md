# Intuition
To find the shortest palindrome by adding characters only at the beginning, the first thought is to locate the longest palindromic prefix. Once this prefix is identified, the remaining suffix (which is not a palindrome) can be reversed and appended to the front, forming the shortest palindrome.

# Approach
1. Reverse the original string `s`.
2. Concatenate the original string with its reverse using a separator (to avoid overlaps when searching for palindromes).
3. Use the Z-function to compute the longest palindrome prefix in the combined string.
4. Based on the longest palindrome prefix, append the non-palindromic suffix (from the reverse) to the original string.

# Complexity
- Time complexity:
  The time complexity is $O(n)$, where `n` is the length of the string, due to the linear time required to compute the Z-function.

- Space complexity:
  The space complexity is $O(n)$, required for storing the reversed string, the combined string, and the Z-function array.

# Code
```java
class Solution {
    public String shortestPalindrome(String s) {
        if (s == null || s.length() == 0) {
            return s;
        }
        // Reverse the string
        String rs = new StringBuilder(s).reverse().toString();

        // Concatenate s + '$' + reverse(s) to find the longest palindrome prefix
        String combined = s + "$" + rs;

        // Compute the Z-function for the combined string
        int[] z = zFunction(combined);

        int lenS = s.length();
        // Find the longest palindrome prefix
        int maxLen = 0;
        for (int i = 0; i < lenS; i++) {
            if (z[lenS + 1 + i] == lenS - i) {
                maxLen = lenS - i;
                break;
            }
        }

        // Append the remaining suffix of the reversed string to the original
        return rs.substring(0, lenS - maxLen) + s;
    }

    private int[] zFunction(String S) {
        int n = S.length();
        int[] Z = new int[n];
        int l = 0, r = 0;
        Z[0] = n;
        for (int i = 1; i < n; i++) {
            if (i <= r) {
                Z[i] = Math.min(r - i + 1, Z[i - l]);
            }
            while (i + Z[i] < n && S.charAt(Z[i]) == S.charAt(i + Z[i])) {
                Z[i]++;
            }
            if (i + Z[i] - 1 > r) {
                l = i;
                r = i + Z[i] - 1;
            }
        }
        return Z;
    }
}
```

<p>&nbsp;</p>

# Approach 2: Rolling Hash
To solve this problem efficiently, the algorithm leverages a double hashing technique, comparing both the forward and reverse hash values as the string is traversed. The goal is to find the longest prefix of the string that is already a palindrome, and then add the minimum number of characters to the front to complete the palindrome.

## Explanation:

1. **Hash Calculation**:
   - The algorithm computes two hashes: `hash1` for the forward part of the string and `hash2` for the reverse.
   - `hash1` is updated by adding characters in a forward manner, while `hash2` accumulates the characters in reverse.
   - As the string is processed, whenever the two hash values match, it indicates a potential palindrome from the start up to that point.

2. **Updating Palindrome Position**:
   - Each time `hash1 == hash2`, the algorithm records the position (`pos`) up to which the string is a palindrome.
   - This ensures that the longest prefix of the string that forms a palindrome is tracked.

3. **Appending Characters**:
   - After determining the longest palindrome prefix, the algorithm calculates how many characters (`m`) need to be added at the front of the string.
   - It then adjusts the string to add these characters by shifting existing characters and copying the reverse of the remaining suffix at the front.

4. **Final String Adjustment**:
   - The string is resized to accommodate the additional characters, and the characters from the reverse of the unmatched suffix are prepended to the string.

## Complexity
- **Time complexity**: $O(n)$, where `n` is the length of the string.
- **Space complexity**: $O(n)$

## Code 
```cpp
const int64_t BASE = 31, MOD = 1e9 + 7;

class Solution {
public:
    string shortestPalindrome(string& s) {
        int64_t hash1 = 0, hash2 = 0, pow = 1, x = 0;
        int n = s.size(), pos = -1;

        for (int i = 0; i < n; i++) {
            x = s[i] & 31;

            hash1 = (hash1 * BASE + x) % MOD;
            hash2 = (hash2 + x * pow) % MOD;

            pow = (pow * BASE) % MOD;

            if (hash1 == hash2) {
                pos = i;
            }
        }

        int m = n - pos - 1;
        n += m;
        s.resize(n);

        for (int i = n - 1; i >= m; i--) {
            s[i] = s[i - m];
        }

        for (int i = 0; i < m; i++) {
            s[i] = s[n - i - 1];
        }

        return move(s);
    }
};
```
