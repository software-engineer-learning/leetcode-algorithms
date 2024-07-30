
# 1. Initial idea

## 2. Approach

### Top-down (memoization)

- See "solution-topdown.md" for details

### Bottom-up (iterative)

- From the topdown approach, we can see that the state of the subproblem is depended on the *prev_index* and *index* as we building up the original 2d memoi table. We **calculate the LIS for every index** using the first loop to pass *index* into the recursive function. The following code is from the solution-topdown.md:

```C++
    for (int index = 0; index < n; index++) {
        res = max(res, helper(nums, index, n, -1, dp));
    }
```

- For every *index* we passed in, we build a small 1d array memoi table for it, and from that we only use the longest length to calculate the next *index*. The following lines of code are from solution-topdown.md:

```C++
    dp[index][prev_index + 1] = max(take, not_take); // we only update the longest length of the current index into dp
    return dp[index][prev_index+1]; // result of the index passed into recursive function
```

- We can also see that, **for each current *index***, the LIS is either the previous LIS+1 (if we can include current value at *index*) or just LIS if current value do not satisfy the requirement (not_take). For example:
  - With the following testcase: `nums = [2,5,3,4]`
  - We can see that at `index = 0`, the LIS = 1; but take a look at `index = 1`, now we can see that LIS is 2, because we can include 5 into our subsequence
  - Now take a look at `index = 2`, value = 3 which is smaller than 5, so the LIS at `index = 2` is still LIS = 2, which is equal the last LIS before `index = 2`
  - Now look at `index= 3`, **we can see that before it the LIS is 2 at `index = 1` and `index = 2`, but with the subsequence built upon `index = 2` we can include itself to create LIS = 3**
- From all of that, we found the recursive formula, which is **`LIS(index) = max(LIS(prev_index)) + 1`** **where nums[prev_index] < nums[index]**

### Complexity analysis

- Time complexity: *O(n^2)* - calculate LIS for every element of the input array
- Space complexity: *O(n)* - `vector<int> dp` is of length *n*.

## 3. Implementation

``` C++
class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        vector<int> dp(n, 1);

        for(int index = 1; index < n; index++) {
            for(int prev_index = 0; prev_index < index; prev_index++) {
                if(nums[index] > nums[prev_index]) {// We can consider this LIS(prev_index) to build upon for our LIS(index)
                    dp[index] = max(dp[index], dp[prev_index]+1); // ensure only get the longest LIS(prev_index)
                    // LIS(index) = max(LIS(prev_index)) + 1
                }
            }
        }
        return *max_element(dp.begin(), dp.end());
    }
};
```
