# Intuition

This is a very confusing problem if you try solving it with binary search (per the strict requirement in the description) and have not done the previous version. Even though the solution is 99% the same it is still advisible to solve the original version first.

<p>&nbsp;</p>

# Approach: Binary search

- If you have solved the original version, you will be temped to try implementing the binary search approach. But you will encounter errors with testcase like nums = [2,2,2,1,2,3] where you can't correctly deduce at which side does middle index fall into.
- A key insight is that in those case where `mid == left && mid != target`, we can see that left WILL NOT equal target, so we can safely ignore it and in binary search, we always try to find a way to decrease the search space by moving either end of the indexes. So this is another way to decrease the index: move left to the right.
- The rest of the implimentation is the same as problem #33.

## Complexity
- Time complexity: $O(n)$ The worst case is that every elements inside the array is equal, in which case we need to search the whole arrays.
- Space complexity: $O(1)$

## Code 

```cpp
class Solution {
public:
    bool search(vector<int>& nums, int target) {
        int n = nums.size();
        int left = 0, right = n-1;
        while(left <= right) {
            int mid = left+(right-left)/2;
            int l = nums[left], r = nums[right], m = nums[mid];
            if(m == target || target == l || target == m) return true;
            
            // both m and l != target so we can safely ignore this current left index
            if(l == m) {
                left++;
                continue;
            }
            if(m > l) {
                if(target > l && target < m) {
                    right = mid;
                    continue;
                }
                left = mid+1;
                continue;
            }
            if(target > m) {
                if(target < l) {
                    left = mid+1;
                    continue;
                }
            }
            right = mid;
        }
        return false;
    }
};
```