# Intuition

The problem requires us to find the maximum value in each sliding window of size `k` as it moves from the left to the right of the array. A monotonic queue is an efficient data structure that can help keep track of maximum values in a sliding window, maintaining the elements in a way that allows us to access the maximum value quickly.

<p>&nbsp;</p>

# Approach: Monotonic Queue

## Explanation:

1. **Initialization**:
   - We use a deque `dq` to store the elements of the current window in a way that the front of the deque always contains the maximum value of the current window.

2. **Sliding Window Process**:
   - As we iterate through the array, we manage the deque to maintain the properties of the sliding window and ensure it remains monotonic.

3. **Maintaining the Deque**:
   - For each element `nums[i]`:
     - Remove elements from the back of the deque while the current element `nums[i]` is greater than the elements at the back. This ensures that the deque only contains potential candidates for the maximum value.
     - Add the current element to the back of the deque.

4. **Sliding the Window**:
   - When the window is fully formed (i.e., when `i - k + 1 >= 0`):
     - If the element that is going out of the window (i.e., `nums[i - k + 1]`) is the same as the element at the front of the deque, remove it from the front. This ensures that we only keep elements within the current window in the deque.
     - Store the current maximum value (i.e., `dq.front()`) in the array `nums` at the position corresponding to the start of the window.

5. **Final Adjustments**:
   - Resize the array `nums` to contain only the results of the maximum values for each window.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(k)$

## Code

```cpp
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        deque<int> dq;

        for (int i = 0; i < (int)nums.size(); i++) {
            while (!dq.empty() && nums[i] > dq.back()) {
                dq.pop_back();
            }

            dq.push_back(nums[i]);

            if (i - k + 1 >= 0) {
                if (nums[i - k + 1] == dq.front()) {
                    dq.pop_front();
                }
                else {
                    nums[i - k + 1] = dq.front();
                }
            }
        }

        nums.resize(nums.size() - k + 1);

        return move(nums);
    }
};
```