# Intuition

To solve the problem of finding the k-th smallest pair distance in an array, we can use a combination of binary search and a sliding window approach. The key insight is that the problem can be framed as a search for the smallest possible distance such that at least `k` pairs have this distance or smaller. 

<p>&nbsp;</p>

# Approach: Binary Search + Sliding Window
This approach uses binary search on the possible distances and a sliding window to count how many pairs have a distance less than or equal to a given value. The binary search allows us to efficiently zero in on the k-th smallest distance.

## Explanation:

1. **Sorting the Array**:
   - Start by sorting the array `nums`. This allows us to use the sliding window technique effectively.
   - Sorting ensures that the difference between consecutive elements is minimized, which helps in counting pairs with smaller distances first.

2. **Binary Search on Distance**:
   - We use binary search to find the k-th smallest distance. The search range is from `left = 0` (the smallest possible distance) to `right = max(nums) - min(nums)` (the largest possible distance).

3. **Sliding Window to Count Pairs**:
   - For each midpoint `mid` in the binary search, we use the `sliding` function to count how many pairs have a distance less than or equal to `mid`.
   - The `sliding` function uses two pointers (`left` and `right`) to maintain a window where the difference between `nums[right]` and `nums[left]` is less than or equal to `mid`. If the difference exceeds `mid`, the `left` pointer is incremented.
   - The number of valid pairs for a given `right` index is `right - left`, which is added to a running `count`.

4. **Adjusting the Binary Search Range**:
   - If the number of pairs with distance less than or equal to `mid` is less than `k`, it means we need to search for a larger distance, so `left` is adjusted to `mid + 1`.
   - Otherwise, we search for a smaller distance by setting `right` to `mid - 1`.

5. **Return the Result**:
   - The binary search terminates when `left` equals the smallest distance that satisfies the condition of having at least `k` pairs, so `left` is returned as the k-th smallest distance.

## Complexity
- Time complexity: $O(n \log d + n \log n)$, where $d$ is the range of the possible distances and $n$ is the size of the array.
- Space complexity: $O(1)$, as we only use a few additional variables for the binary search and sliding window.

## Code
```cpp
class Solution {
public:
    int sliding(vector<int>& nums, int target) {
        int n = nums.size(), count = 0;

        for (int left = 0, right = 0; right < n; right++) {
            while (nums[right] - nums[left] > target) {
                ++left;
            }

            count += right - left;
        }

        return count;
    }

    int smallestDistancePair(vector<int>& nums, int k) {
        ranges::sort(nums);

        int left = 0;
        int right = nums.back() - nums[0];
        int mid;

        while (left <= right) {
            mid = left + (right - left) / 2;

            if (sliding(nums, mid) < k) {
                left = mid + 1;
            }
            else {
                right = mid - 1;
            }
        }

        return left;
    }
};
```