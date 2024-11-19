# Intuition
The problem can be approached by leveraging the sliding window technique. The goal is to find a subarray of fixed size `k` with the maximum sum while ensuring all elements in the subarray are unique. Using a frequency array helps in tracking duplicate elements efficiently.

# Approach
1. Use two pointers, `l` and `r`, to represent the current window in the array.
2. Maintain a running sum, `result`, for the elements in the window and a frequency array, `freq`, to count occurrences of elements.
3. Expand the window by moving `r` and adding `nums[r]` to `result`.
4. If a duplicate is detected (`freq[nums[r]] > 1`), shrink the window from the left by moving `l` and updating `result` and `freq` accordingly.
5. Once the window size equals `k`, calculate the maximum sum and adjust the window by removing the leftmost element (`nums[l]`) to prepare for the next iteration.
6. Return the maximum sum found during the process.

# Complexity
- **Time complexity:**  
  $O(n)$ 
  Each element is processed at most twice (once when expanding the window and once when shrinking it), resulting in a linear time complexity.

- **Space complexity:**  
  $O(u)$  
  Where `u` is the range of numbers in `nums` (here, up to 100,000 due to the size of `freq`).

# Code
```java
class Solution {
    public long maximumSubarraySum(int[] nums, int k) {
        int l = 0;
        long result = 0;
        long max = 0;
        int[] freq = new int[100001];
        
        for (int r = 0; r < nums.length; r++) {
            result += nums[r];
            freq[nums[r]]++;
            
            while (freq[nums[r]] > 1) {
                result -= nums[l];
                freq[nums[l++]]--;
            }
            
            if (r - l + 1 == k) {
                max = Math.max(max, result);
                freq[nums[l]]--;
                result -= nums[l++];
            }
        }
        
        return max;
    }
}
```