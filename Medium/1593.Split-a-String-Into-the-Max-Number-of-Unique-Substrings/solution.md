# Intuition
The problem involves finding the maximum number of unique substrings into which the given string can be split. My first thought is that this can be solved using backtracking. The key observation is that we need to try every possible split of the string and check how many unique substrings we can generate.

# Approach
The approach is based on backtracking. We iterate over all possible substrings starting from the current position, checking if the substring has already been used. If not, we add it to the set of unique substrings and recursively continue from the next position. After the recursive call, we remove the substring from the set to backtrack and explore other possibilities. This ensures we try every combination and find the one that produces the maximum number of unique splits.

# Complexity
- **Time complexity:**  
  The time complexity is approximately $O(n \cdot 2^n)$ where `n` is the length of the string. This arises because at each position, there are two choices: to include the substring or not, leading to exponential growth in the number of possible splits.

- **Space complexity:**  
  The space complexity is $O(n)$ due to the recursive stack and the set of unique substrings, where `n` is the length of the input string.

# Code
```java
class Solution {
    public int maxUniqueSplit(String s) {
        return backTracking(s, 0, new HashSet<>());
    }

    private int backTracking(String s, int start, Set<String> uniqueSubString) {
        if (start == s.length()) {
            return uniqueSubString.size();
        }

        int maxSplit = 0;

        for (int end = start + 1; end <= s.length(); end++) {
            String currentSubString = s.substring(start, end);

            if (!uniqueSubString.contains(currentSubString)) {
                uniqueSubString.add(currentSubString);

                maxSplit = Math.max(maxSplit, backTracking(s, end, currentSubString));

                uniqueSubString.remove(currentSubString);
            }
        }

        return maxSplit;
    }
}
```