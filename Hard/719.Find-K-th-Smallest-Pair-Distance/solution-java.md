# Approach

1. **Binary Search on Distance**:
   Instead of calculating all pairwise distances and sorting them, this approach uses binary search to find the k-th smallest distance. The possible distances range from 0 to the difference between the maximum and minimum elements in the array.
2. **Counting Pairs**:
   For each mid value during the binary search, count how many pairs have a distance less than or equal to mid. This allows you to adjust the search space effectively.
3. **Sorting the Array**:
   The array is sorted upfront, allowing us to efficiently count pairs with a given maximum distance using a two-pointer technique.

# Complexity

**Time complexity**

- **_Sorting_**: $O(n\log n)$.
- **_Binary Search_**: The binary search runs in $O(\log⁡ d)$, where d is the difference between the maximum and minimum element in the array.
- **_Counting Pairs_**: Counting pairs takes $O(n)$ for each iteration of the binary search.
  The overall time complexity is $O(n \log n + n \log d)$, which is significantly more efficient than generating all pairs and sorting them.

**Space complexity**

- $O(1)$.

# Code

## Java

```Java
class Solution {
    public int smallestDistancePair(int[] nums, int k) {
        Arrays.sort(nums);
        int low = 0, high = nums[nums.length - 1] - nums[0];

        while (low < high) {
            int mid = (low + high) / 2;
            int count = 0, left = 0;

            for (int right = 0; right < nums.length; right++) {
                while (nums[right] - nums[left] > mid) {
                    left++;
                }
                count += right - left;
            }

            if (count >= k) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        return low;
    }
}
```
