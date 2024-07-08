# Intuition

- The provided code aims to determine if there are any duplicate elements within a distance `k` of each other in the
  array. The approach uses a HashMap to track the indices of the elements within the current window of size `k`

# Approach

## 1. Initialization

- If `k` is zero, return `false` immediately since no duplicates can be within a distance of zero.
- Use a `HashMap` to store the elements and their latest indices in the current window for quick lookup.

## 2. HashMap Iteration

- Iterate through the array, keeping track of the indices of the elements in the `HashMap`.
- For each element, check if it already exists in the `HashMap` and if the difference between the current index and the
  stored index is less than or equal to `k`.
    - If true, return true.
    - Otherwise, update the HashMap with the current index of the element.
- Continue this process for all elements in the array.

## 3. Return Result

- If no duplicates are found within the distance `k`, return `false`

# Complexity

- Time complexity: `O(n)`

- Space complexity: `O(min(n,k))`

# Code

```java
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        if (k == 0) return false;

        HashMap<Integer, Integer> map = new HashMap<>();

        for (int i = 0; i < nums.length; i++) {
            if (map.containsKey(nums[i]) && i - map.get(nums[i]) <= k) {
                return true;
            } else {
                map.put(nums[i], i);
            }
        }

        return false;
    }
}
```
