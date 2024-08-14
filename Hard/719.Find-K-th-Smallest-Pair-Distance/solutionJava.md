## Approach

1. **Binary Search on Distance**: 
    Instead of calculating all pairwise distances and sorting them, this approach uses binary search to find the k-th smallest distance. The possible distances range from 0 to the difference between the maximum and minimum elements in the array.

2.  **Counting Pairs**: 
    For each mid value during the binary search, count how many pairs have a distance less than or equal to mid. This allows you to adjust the search space effectively.

3. **Sorting the Array**: 
    The array is sorted upfront, allowing us to efficiently count pairs with a given maximum distance using a two-pointer technique.

## Complexity

- **Time complexity**

  * Sorting: $$O(N \log ⁡N)O(N \log N)

  * Binary Search: The binary search runs in $$O(\log⁡ D)O(\log D), where DD is the difference between the maximum and minimum element in the array.

  * Counting Pairs: Counting pairs takes $$O(N)O(N) for each iteration of the binary search.

The overall time complexity is $$O(N \log ⁡N + N \log ⁡D)O(N \log N + N \log D), which is significantly more efficient than generating all pairs and sorting them.

## Code 
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