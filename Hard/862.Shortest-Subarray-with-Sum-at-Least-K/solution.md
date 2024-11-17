# Intuition
To find the shortest subarray whose sum is at least `k`, the problem can be translated into a **prefix sum** problem. By leveraging the prefix sum, we can efficiently calculate the sum of any subarray and use a deque-like approach to find the minimal subarray length.

# Approach
1. **Prefix Sum**:
   - Compute a `prefixSum` array where `prefixSum[i]` represents the sum of the first `i` elements. This allows for quick computation of subarray sums as `prefixSum[j] - prefixSum[i]`.
   
2. **Deque for Optimization**:
   - Maintain a deque (implemented using a fixed-size array `queue` with indices `l` and `r`) to store indices of the prefix sums in increasing order.
   - For each index `i`, perform two key checks:
     - **Sum Check**: Remove indices from the front of the deque if the difference between the current prefix sum and the smallest prefix sum in the deque is at least `k`. Update the minimum length of the subarray accordingly.
     - **Monotonicity Check**: Remove indices from the back of the deque if the current prefix sum is less than or equal to the prefix sum at those indices. This ensures the deque remains monotonic.
   
3. **Final Result**:
   - If no subarray with a sum of at least `k` is found, return `-1`. Otherwise, return the minimum length.

# Complexity
- **Time complexity**:  
  $O(n)$, where $$n$$ is the length of the input array. Each element is processed at most twice (once when added to and once when removed from the deque).
  
- **Space complexity**:  
  $O(n)$, for the `prefixSum` array and the deque.

# Code
```java
class Solution {
    public int shortestSubarray(int[] nums, int k) {
        int N = nums.length;
        long[] prefixSum = new long[N + 1];

        for (int i = 0; i < N; i++) {
            prefixSum[i + 1] = prefixSum[i] + nums[i];
        }

        int minLength = N + 1;
        int[] queue = new int[N + 1];
        int r = 0;
        int l = 0;

        for (int i = 0; i <= N; i++) {
            while (r > l && prefixSum[i] - prefixSum[queue[l]] >= k) {
                minLength = Math.min(minLength, i - queue[l++]);
            }

            while (r > l && prefixSum[i] <= prefixSum[queue[r - 1]]) {
                r--;
            }

            queue[r++] = i;
        }

        return minLength == N + 1 ? -1 : minLength; 
    }
}
```