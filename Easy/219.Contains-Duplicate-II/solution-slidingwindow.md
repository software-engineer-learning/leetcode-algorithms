# Intuition

- The provided code aims to determine if there are any duplicate elements within a distance
  `𝑘` of each other in the array. The approach uses a `sliding window` technique with a `HashSet` to track the elements
  within the current window of size `𝑘`

# Approach

## 1. Initialization

- `currentWindow`: Keeps track of the right boundary of the sliding window, initially set to 1.
- If `k` is zero, return `false` immediately since no duplicates can be within a distance of zero.
- Use a `HashSet` to store elements in the current window for quick lookup.

## 2. Sliding Window Technique

- Start with the first element and add it to the `HashSet`.
- Iterate through the array with a sliding window approach.
- Expand the window by including elements up to the distance 𝑘.
- If adding an element to the `HashSet` fails (indicating a duplicate), return `true`.
- Otherwise, remove the leftmost element from the window and continue.

## 3. Return Result

- If no duplicates are found within the distance 𝑘, return false.

# Complexity

- Time complexity: `O(n)`

- Space complexity: `O(k)`

# Code

```java
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        int currentWindow = 1;
        if (k == 0)
            return false;
        HashSet<Integer> set = new HashSet<>();
        set.add(nums[0]);

        for (int i = 0; currentWindow < nums.length; i++) {
            while (currentWindow - i <= Math.min(k, nums.length - 1)) {
                if (set.add(nums[currentWindow])) {
                    currentWindow++;
                } else
                    return true;
            }

            set.remove(nums[i]);
        }

        return false;
    }
}
```
