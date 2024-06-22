
## 1. Initial idea
We can see that we need to prioritize which job gain the most profit. By assigning those jobs to the groups ever can carry, the profit will be the most -> Sort the jobs following the profit

If two workers with different ability (`workers[i] < workers[j]`), we will save the `workers[j]` and assign the job for the `workers[i]` first -> sort workers low to high

## 2. Approach

Make the jobs' information into pairs (or any data structures can be used for sort) and sort the value following the profit.
Sort the `workers` array from low to high.

Go through the `jobs` (array of int-int pairs) and assign the job to the weakest workers that can do the job (if can not, then ignore). Using binary search (lower_bound in `C++`)


## 3. Implementation

```c++
class Solution {
public:
    int maxProfitAssignment(vector<int>& difficulty, vector<int>& profit, vector<int>& worker) {
        int res = 0;
        int n = worker.size();
        vector<pair<int, int>> prof_diff;
        for(int i = 0; i < profit.size(); ++i) {
            prof_diff.push_back(make_pair(profit[i], difficulty[i]));
        }
        sort(worker.begin(), worker.end());
        sort(prof_diff.begin(), prof_diff.end(), greater<pair<int, int>>());
        auto start = worker.end();
        for (int i = 0; i < prof_diff.size(); ++i) {
            if (start < worker.begin()) {
                break;
            }
            auto lb = lower_bound(worker.begin(), start , prof_diff[i].second);
            int num = int(start - lb);
            start = lb;
            res += num * prof_diff[i].first;
        }
        return res;
    }
};
```


## 4. Complexity
Time: `O( n log (n) + m log (m) + n log (m))`
    * `O(n log n)` for sorting
    * `O(m log n)` for sorting
    * `O(n log m)` for iterated and search through jobs

Space: O(1)
