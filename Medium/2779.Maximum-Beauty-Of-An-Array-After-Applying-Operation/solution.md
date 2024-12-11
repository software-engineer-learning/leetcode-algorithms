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
  - $O(N)$ for find the maximum beauty possible with sliding windows technique.
  -
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
