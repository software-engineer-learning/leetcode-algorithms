# Intuition

The problem requires us to flip subarrays of length k in such a way that all elements in the binary array `nums` are converted to 1. So we can start from the leftmost and using a sliding window to flip as soon as we encounter a 0 that needs to be turned into 1.
<p>&nbsp;</p>

# Approach 1: Using a Queue

This approach uses a queue to efficiently manage the flips in a sliding window.

## Explanation:

1. **Initialization**:
   - `n`: The size of the input array `nums`.
   - `count`: A counter to keep track of the number of k-bit flips performed.
   - `state`: A boolean flag to represent the current flip state (0 means no flip, 1 means flipped).
   - `q`: A queue to keep track of the end indices of the k-bit flip segments.

2. **Traversing the Array**:
   - Iterate over each element in the array `nums` using a for loop.

3. **Checking and Flipping**:
   - **Condition to Flip**: If the current element `nums[i]` is equal to the `state` (indicating it needs to be flipped to become 1):
     - Check if flipping a subarray of length `k` starting at index `i` would exceed the bounds of the array. If so, return -1 as it is impossible to flip the required subarray.
     - If within bounds, increment the `count` of flips.
     - Toggle the `state` to indicate a new flip segment has started.
     - Push the end index of the current flip segment (`i + k - 1`) into the queue.

4. **Maintaining the Flip State**:
   - After processing the current element, check if there are any flip segments in the queue whose end index is equal to the current index `i`.
   - If so, this means the effect of the flip segment ends at the current index. Toggle the `state` back and pop the end index from the queue.

5. **Returning the Result**:
   - After traversing the entire array, return the total count of k-bit flips performed.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(n)$

## Code
```cpp []
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int n = nums.size(), count = 0;
        bool state = 0;
        queue<int> q;

        for (int i = 0; i < n; i++) {
            if (nums[i] == state) {
                if (i + k > n) return -1;

                ++count;
                state ^= 1;
                q.push(i + k - 1);
            }

            if (!q.empty() && q.front() == i) {
                state ^= 1;
                q.pop();
            }
        }

        return count;
    }
};
```
<p>&nbsp;</p>

# Approach 2: In-place Modification

Instead of using a queue, we can modify the input array in place to save memory

## Explanation:

1. **Initialization**:
   - `n`: The size of the input array `nums`.
   - `count`: A counter to keep track of the number of k-bit flips performed.
   - `state`: A boolean flag to represent the current flip state (0 means no flip, 1 means flipped).

2. **Traversing the Array**:
   - Iterate over each element in the array `nums` using a for loop.

3. **Checking and Flipping**:
   - **Condition to Flip**: If the current element `nums[i]` is equal to the `state` (indicating it needs to be flipped to become 1):
     - Check if flipping a subarray of length `k` starting at index `i` would exceed the bounds of the array. If so, return -1 as it is impossible to flip the required subarray.
     - If within bounds, increment the `count` of flips.
     - Toggle the `state` to indicate a new flip segment has started.
     - Mark the start of the flip at nums[i] by XOR-ing nums[i] with -1. This effectively flips all the bits of nums[i].

4. **Maintaining the Flip State**:
   - **Check for Ending Flips**: When `i - k + 1 >= 0`, it means the flip effect (if any) from `i - k + 1` is ending.
     - If `nums[i - k + 1]` is less than 0, it means this position marked the start of a flip.
     - Toggle the `state` back.
     - (Optional) Reset `nums[i - k + 1]` by XOR-ing it with `-1` to remove the mark.

5. **Returning the Result**:
   - After traversing the entire array, return the total count of k-bit flips performed.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(1)$

## Code
```cpp []
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int n = nums.size(), count = 0;
        bool state = 0;

        for (int i = 0; i < n; i++) {
            if (nums[i] == state) {
                if (i + k > n) return -1;

                ++count;
                state ^= 1;
                nums[i] ^= -1;
            }

            if (i - k + 1 >= 0 && nums[i - k + 1] < 0) {
                state ^= 1;
                nums[i - k + 1] ^= -1;
            }
        }

        return count;
    }
};
```