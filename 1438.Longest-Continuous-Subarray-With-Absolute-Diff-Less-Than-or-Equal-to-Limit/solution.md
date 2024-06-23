# Intuition

To solve this problem, we can use a sliding window approach and keep track of the minimum and maximum elements within the current window.

<p>&nbsp;</p>

# Approach 1: Sliding Window + Binary Search Tree
This approach utilizes a sliding window in combination with a balanced binary search tree implemented via `std::multiset` in C++. The `multiset` allows for efficient insertion, deletion, and access to the smallest and largest elements, making it a suitable data structure for this problem.

## Explanation:

1. **Initialization**:
   - Initialize `res` to store the result (length of the longest subarray).
   - `left` is initialized to 0 to denote the starting index of the sliding window.
   - A `multiset` called `ms` is used to maintain the elements within the current window.

2. **Expanding the Window**:
   - Iterate through the array using a `right` pointer to expand the window.
   - Insert the current element `nums[right]` into the `multiset`.

3. **Maintaining the Condition**:
   - After inserting a new element, check if the current window satisfies the condition: the difference between the maximum and minimum elements in the window should be less than or equal to `limit`.
   - In `multiset`, the smallest element can be accessed using `*ms.begin()` and the largest element using `*ms.rbegin()`.
   - If the difference between these elements exceeds `limit`, shrink the window from the left by removing `nums[left]` from the `multiset` and incrementing the `left` pointer.

4. **Updating the Result**:
   - Update `res` with the size of the current valid window, which is `right - left + 1`.

5. **Return the Result**:
   - After iterating through the array, `res` will contain the length of the longest subarray that satisfies the condition.

## Complexity
- Time complexity: $O(n*log(n))$
- Space complexity: $O(n)$

## Code 

```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        int res = 0, left = 0;
        multiset<int> ms;

        for (int right = 0; right < (int)nums.size(); right++) {
            ms.insert(nums[right]);

            while (*ms.rbegin() - *ms.begin() > limit) {
                ms.erase(ms.find(nums[left++]));
            }

            res = max(res, right - left + 1);
        }

        return res;
    }
};
```

<p>&nbsp;</p>

# Approach 2: Sliding Window + Monotonic Queue

This optimized solution uses a sliding window in combination with two monotonic queues to efficiently maintain the minimum and maximum values within the current window. This approach ensures that the operations of inserting, removing, and accessing the minimum and maximum values are all handled in constant time, making it more efficient than using a binary search tree.

## Explanation:

1. **Initialization**:
   - Initialize `res` to store the result (length of the longest subarray).
   - `left` is initialized to 0 to denote the starting index of the sliding window.
   - Two deques, `minDq` and `maxDq`, are used to maintain elements in the current window in increasing and decreasing order, respectively.

2. **Expanding the Window**:
   - Iterate through the array using a `right` pointer to expand the window.
   - Update `minDq` to maintain the minimum elements: remove elements from the back of `minDq` while the current element is smaller than the elements at the back.
   - Update `maxDq` to maintain the maximum elements: remove elements from the back of `maxDq` while the current element is larger than the elements at the back.
   - Insert the current element into both `minDq` and `maxDq`.

3. **Maintaining the Condition**:
   - Check if the current window satisfies the condition: the difference between the maximum and minimum elements should be less than or equal to `limit`.
   - The minimum element can be accessed using `minDq.front()` and the maximum element using `maxDq.front()`.
   - If the condition is violated, shrink the window from the left by removing the elements at `left` from the deques and incrementing the `left` pointer.

4. **Updating the Result**:
   - Update `res` with the size of the current valid window, which is `right - left + 1`.

5. **Return the Result**:
   - After iterating through the array, `res` will contain the length of the longest subarray that satisfies the condition.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(n)$

## Code 
```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        int res = 0, left = 0;

        deque<int> minDq, maxDq;

        for (int right = 0; right < (int)nums.size(); right++) {
            while (!minDq.empty() && nums[right] < minDq.back()) {
                minDq.pop_back();
            }

            while (!maxDq.empty() && nums[right] > maxDq.back()) {
                maxDq.pop_back();
            }

            minDq.push_back(nums[right]);
            maxDq.push_back(nums[right]);

            while (maxDq.front() - minDq.front() > limit) {
                if (minDq.front() == nums[left]) minDq.pop_front();
                if (maxDq.front() == nums[left]) maxDq.pop_front();
                ++left;
            }

            res = max(res, right - left + 1);
        }

        return res;
    }
};
```