# Intuition

This is a standard backtracking problem, it is advised you should do Combination Sum I and preferably Subset and Permutation first to get comfortable with the concept.

<p>&nbsp;</p>

# Approach: Backtracking

- Similar to combination sum 1, we can recursively try every combinations using elements from the input array, but the problem is it would be very inefficient and will definitely get us a TLE.
- We will need a way to "prune" unecessary combination, we can observe that if we sort the input array, we can easily prune the algorithm as soon as the current sum of our tries exceed $target$
- As the question forbid we use duplicates index, we will need a way to cover that. We can see that after sort for example $candidates = [2,2,2,2,3,6,7]; target = 4$, we will run the algo about 7 times this is pretty inefficient so we need someway to work around that.

## Complexity
- Time complexity: $O(2^n)$ as in worst case, the combination will run for every element inside the input array.
- Space complexity: $O(n)$ in worse case, our inner array length can go up to n elements.

## Code 

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
        sort(candidates.begin(), candidates.end());
        int n = candidates.size();
        vector<vector<int>> res;
        vector<int> inner;
        helper(candidates, n, 0, target, inner, res);
        return res;
    }

    void helper(vector<int>& candidates, int n, int index, int target, vector<int>& inner, vector<vector<int>>& res) {
        if(target == 0) {
            res.push_back(inner);
            return;
        }
        for(int i = index; i < n; i++) {
            int curr = candidates[i];
            // prune duplicates "inner" combinations
            if(i > index && curr == candidates[i-1]) continue;
            // prune invalid combination
            if(target - curr < 0) return;
            inner.push_back(curr);
            helper(candidates, n, i+1, target-curr, inner, res);
            if(!inner.empty())
                inner.pop_back();
        }
    }
};
```