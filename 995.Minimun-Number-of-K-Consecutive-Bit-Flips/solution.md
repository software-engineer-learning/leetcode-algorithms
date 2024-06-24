# Intuition
- The goal is to ensure there are no 0 left in the array after performing the minimum number of k-bit flips. The k-bit flip flips every bit (0 to 1, or 1 to 0) in a sub-array of length k. To achieve the minimum number of flips, we need to be strategic about where and when to flip the bits.

# Approach
## 1.Initialize Variables:
- `flippedTime` to track the number of flips that affect the current position.
- `cnt` to count the total number of flips performed. 
## 2.Iterate through `nums`:
- For each element `i` in `nums` , if `i` is greater than or equal to `k` and the element `k` positions before was a flip (marked by `2`), reduce `flippedTime` because that flip no longer affects the current window.
- If the current element, considering `flippedTime`, need to be flipped (`flippedTime % 2 == nums[i]`), check if it's possible to flip the next `k` elements
    - If `i + k` exceeds the array bounds , return `-1`.
    - Otherwise, increment `cnt`, `flippedTime`, and mark the current position with `2`.
## 3.Return the result:
- If the loop completes, return `cnt` the count of flips.

# Complexity
- Time complexity: `O(N).`
- Space complexity: `O(1).`

# Code
```cpp
class Solution {
public:
    int minKBitFlips(vector<int>& nums, int k) {
        int flippedTime = 0, cnt = 0;
        for (int i = 0; i < nums.size(); ++i) {
            if (i >= k && nums[i - k] == 2)
                --flippedTime;
            if (flippedTime % 2 == nums[i]) {
                if (i + k > nums.size())
                    return -1;
                ++cnt;
                ++flippedTime;
                nums[i] = 2;
            }
        }
        return cnt;
    }
};
```