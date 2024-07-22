# Intuition

The task is to sort names based on the heights in descending order. The given solution sorts indices based on the heights and then rearranges names according to this sorted order. This approach leverages index manipulation to achieve the required result efficiently.

<p>&nbsp;</p>

# Approach 1: Index-Based Sort

## Explanation:

1. **Create a list of indices**:
   - Create an `indexes` vector that contains indices from 0 to n-1. This helps in sorting and mapping heights to names.

2. **Sort indices based on heights**:
   - Sort the `indexes` vector using a lambda function that compares heights. This function ensures that indices are sorted in descending order of the corresponding heights.

3. **Rearrange names according to sorted indices**:
   - Reorder the `names` array based on the sorted indices. This is achieved by swapping elements to their correct positions according to the sorted order. 

4. **Returning the Result**:
   - Return the reordered `names` vector.

## Complexity
- Time complexity: $O(n \log n)$, where $n$ is the number of people.
- Space complexity: $O(n)$

## Code
```cpp
class Solution {
public:
    vector<string> sortPeople(vector<string>& names, vector<int>& heights) {
        int n = names.size();

        vector<int> indexes(n);
        iota(indexes.begin(), indexes.end(), 0);
        sort(indexes.begin(), indexes.end(), [&](int& i, int& j) {
            return heights[i] > heights[j];
        });

        for (int i = 0; i < n; i++) {
            int idx = indexes[i];
            while (idx != i) {
                swap(names[idx], names[indexes[idx]]);
                swap(idx, indexes[idx]);
            }
        }

        return move(names);
    }
};
```