# Approach 1: Sliding windows

## Intuition

When we look for the longest subsequence each number can form, we're essentially looking for a window of consecutive numbers. Instead of repeatedly searching for where each window ends, we can be more efficient by using a technique called the sliding window approach.

This involves maintaining a range with a left and a right boundary that dynamically adjusts as we move through the sorted array. Starting with both boundaries at the beginning of the array, we extend the right boundary to include as many numbers as possible while ensuring the condition holds — specifically, that the difference between the largest and smallest numbers in the range does not exceed `2⋅k`. If the condition is violated, we adjust the left boundary to restore the range. The maximum length of this range across all positions gives us the desired result.

## Algorithm

- Sort the input array `nums` in ascending order.
- Initialize a variable `ans` to 0 to track the maximum beauty possible.
- Initialize a variable `left` to 0 to serve as the `left` pointer of our window.
- For each index `right` from 0 to length of nums:
  While `left` is less than `right` and the difference between elements at `right` and `left` indices is less than or equal to `2 * k`.
- Increment `left` pointer by 1.
- Update `ans` to be the maximum of current `ans` and `(right - left + 1)`.
  Return `ans` as our answer.

## Complexity

- Time complexity: $O(NLogN)$ with `N` is the length of input array `nums` where:
  - $O(NLogN)$ is for sorting the input array `nums`.
  - $O(N)$ is for finding the maximum beauty possible with sliding windows technique.
- Space complexity: $O(N)$ with space of the input array `nums` and without some constants space for `left`, `right`, and `ans`.

## Code

### Go

```Go
import "sort"

func maximumBeauty(nums []int, k int) int {
    sort.Ints(nums)
    left, n, ans := 0, len(nums), 0
    for right := 0; right < n; right++ {
        for nums[right] - nums[left] > 2 * k {
            left++
        }
        ans = max(ans, right - left + 1)
    }
    return ans
}
```

# Approach 2: Binary search

## Intuition

- The intuition for the binary search approach is not that we can sort the input array as we do not apply binary search onto the `nums` vector itself, but it is that the possible results of the algorithm is a monotonic increasing solution range. In Layman term it means that if beauty of range `x` is valid, then range `y < x` must be valid, so we memo the `x` and check if there is any range bigger than `x`: `[x+1...n]` using binary search. Result <= x is valid, so we check whether there might be another result > x (monotonic increase)

## Algorithm

- Similar to the sliding window approach, we need to sort first
- We will do a binary search on the **possible valid range** instead of the input `nums` itself. For each possible beauty range, we apply binary search insde the `helper()` function to see if it is valid.

## Complexity

- Time complexity: $O(NLogN)$ as we need to sort the `nums` array
- Space complexity: $O(1)$ for extra memory and $O(N)$ if we factor in the input array

## Code

### Cpp

```cpp
class Solution {
public:
    int maximumBeauty(vector<int>& nums, int k) {
        int n = nums.size(), res = 0;
        sort(nums.begin(), nums.end());
        int left = 0, right = n;
        while(left < right) {
            int mid = left + (right-left)/2;
            if(!helper(nums, k, n, mid)) {
                res = max(res, mid);
                left = mid+1;
            } else right = mid;
        }
        res++;
        return res;
    }

    bool helper(vector<int>& nums, int k, int n, int mid) {
        int start = 0, l = 0;
        for(int i = 0; i < n; i++) {
            while(start < n && nums[i]-nums[start] > 2*k) {
                start++;
            }
            l = max(l, i-start+1);
        }
        return l <= mid;
    }
};
```

# Approach 3: Prefix sum

## Intuition

- This is the optimized solution of the problem as it does not require sorting the input array `nums`
- If we think of each element `nums[i]` as a range of `[i-k, i+k]`, then the result is the **point** in which it has the most overlapped range.

## Algorithm

- First we create a `pref` vector with a size of the biggest element increased by 1 inside `nums`: `vector<int> pref(*max_element(nums.begin(), nums.end())+1, 0);`
- Then for each element `nums[i]`, we update the range `[i-k, i+k]`, after that we just need to return the largest element `pref[i]` as our result.
- Because repeatedly updating `pref[i]` as we iterate `nums` will be costly and likely resulted with TLE, we can use mutable prefix sum to lazily update our `prefix`, then do a final update before getting our result.

## Complexity

- Time complexity: $O(N + M)$ with M is the value of the max element inside `nums` array, as we dont need to sort but need to populate the `pref` array of size `max_element+1`
- Space complexity: $O(M)$ it is actually $O(M+1)$ asymptote to $O(M)$

## Code

```cpp
class Solution {
public:
    int maximumBeauty(vector<int>& nums, int k) {
        int n = nums.size(), res = 0, size = *max_element(nums.begin(), nums.end())+1;
        if(n == 1) return 1;
        vector<int> pref(size, 0);
        for(int i : nums) {
            if(i-k < 0) pref[0]++;
            else pref[i-k]++;
            if(i+k+1 >= size) pref[size-1]--;
            else pref[i+k+1]--;
        }
        res = pref[0];
        for(int i = 1; i < size; i++) {
            pref[i] += pref[i-1];
            res = max(res, pref[i]);
        }
        return res;
    }
};
```