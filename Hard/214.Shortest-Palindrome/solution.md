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