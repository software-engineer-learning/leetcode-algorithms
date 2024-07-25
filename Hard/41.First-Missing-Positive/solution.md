# Intuition

The goal is to find the smallest positive integer missing from an unsorted array of integers. The solution leverages the property that if the array contains a positive integer `x` within the range `[1, n]` (where `n` is the length of the array), then `x` should ideally be placed at index `x - 1`. By rearranging the elements of the array such that each value `x` is placed at its corresponding index `x - 1`, the problem can be solved in linear time with constant space.

<p>&nbsp;</p>

# Approach: Index Placement with Swapping

## Explanation:

1. **Initialization**:
   - Determine the size of the array `n`.

2. **Placement Loop**:
   - Iterate through each element in the array.
   - For each element `nums[i]`, if it is a positive integer within the range `[1, n]` and is not already at its correct position (i.e., `nums[i] != nums[nums[i] - 1]`), swap it with the element at its target position `nums[nums[i] - 1]`.
   - This ensures that each element is placed at its correct index `x-1` if it falls within the range `[1, n]`.

3. **Finding the Missing Positive Integer**:
   - After rearranging the elements, iterate through the array again.
   - The first index `i` for which `nums[i] != i + 1` is the smallest missing positive integer.
   - If all indices contain their correct values, then the smallest missing positive integer is `n + 1`.

## Complexity
- Time complexity: $O(n)$
  - Each element is processed at most twice (once during the initial placement and once during the final check), resulting in linear time complexity.
- Space complexity: $O(1)$
  - The algorithm uses a constant amount of extra space.

## Code

```cpp
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();

        for (int i = 0; i < n; i++) {
            while (nums[i] > 0 && nums[i] <= n && nums[i] != nums[nums[i] - 1]) {
                swap(nums[i], nums[nums[i] - 1]);
            }
        }

        for (int i = 0; i < n; i++) {
            if (nums[i] != i + 1) {
                return i + 1;
            }
        }

        return n + 1;
    }
};
```