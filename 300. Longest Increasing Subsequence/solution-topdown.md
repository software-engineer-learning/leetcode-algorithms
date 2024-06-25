
## 1. Initial idea
- We can see that the problem requires us to make decision at each step/position of nums[i], we either "take" (*if possible*) or **"not_take"** the current nums[i] to find the longest subsequence, so we can do exactly that, for every position. After seeing this this problem devolves into the typical House Robber problem
- Solving the House Robber and House Robber II is strongly recommend to easier understand this problem

## 2. Approach
### BRUTEFORCE:
- Recursively **take** and then **not_take** at each steps
- Compares it at every step to get the longest subsequence possible

### Top-down (memoization):
- Setup is the same as above approach, only this time we need to have a memo array.
- What we need to memo is the problem, we can see that at every step, we need to compare both **take** and **not_take**, so dp[index] is no brainer, but it is not enough.
- We can see that, because the subsequence is strictly increasing, with every **take** decision, we need to have to check if the current value is valid for taking (increasing). So we need to compare value at current index i-th with the **last index** we have taken -> dp[index][last_index] is our memoized array.
- There is an edge case where we begin the process, the last_index is supposed to be null/invalid -> we can handle it by init the **last_index** = -1, then memoize the solution by saving it into dp[index][last_index+1] instead, this way, if **last_index** == -1 we can always **take**.

## 3. Implementation

- Note: save every recursive-call's results into a variable is more readable and easier to dry-run/mind-debugging than directly call the recursive inside the check max function, but YMMV.

```class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size(), res = 0;
        vector<vector<int>> dp(n, vector<int>(n + 1, -1));
        for (int index = 0; index < n; index++) {
            res = max(res, helper(nums, index, n, -1, dp));
        }
        return res;
    }

    int helper(vector<int>& nums, int index, int n, int prev_index, vector<vector<int>>& dp) {
        if (index >= n) return 0;
        if (dp[index][prev_index + 1] != -1) return dp[index][prev_index + 1];
        
        // take can either be 0 or result of helper()
        int take = 0;
        if (prev_index == -1 || nums[prev_index] < nums[index]) take = helper(nums, index + 1, n, index, dp) + 1;
        // not_take will always be the last taken result
        int not_take = helper(nums, index + 1, n, prev_index, dp);
        
        dp[index][prev_index + 1] = max(take, not_take);
        
        return dp[index][prev_index + 1];
    }
};
```