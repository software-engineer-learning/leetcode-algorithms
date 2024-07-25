# Intuition

The problem requires constructing a matrix where the sum of each row matches the given `rowSum` array and the sum of each column matches the given `colSum` array. The approach leverages a greedy strategy to fill in the matrix by iterating over the rows and columns, setting each element to the minimum value possible without violating the row and column sum constraints.

<p>&nbsp;</p>

# Approach: Greedy
The idea is to construct the matrix by filling in the smallest possible value at each step and then adjusting the row and column sums accordingly. This ensures that we maintain the required row and column sums as we proceed.

## Explanation:

1. **Initialization**:
   - Determine the number of rows `n` and columns `m` from the sizes of `rowSum` and `colSum`.
   - Initialize an empty matrix `res` of size `n x m` filled with zeros.
   
2. **Greedy Filling**:
   - Start with the first row and the first column (`i = 0`, `j = 0`).
   - For each element `res[i][j]`, set it to the minimum of the current `rowSum[i]` and `colSum[j]`.
   - Update `rowSum[i]` and `colSum[j]` by subtracting the value just assigned to `res[i][j]`.
   - Move to the next row if `rowSum[i]` becomes zero, and to the next column if `colSum[j]` becomes zero.
   - Continue this process until all elements of the matrix are filled.

3. **Return the Result**:
   - After filling all elements, return the constructed matrix `res`.

## Complexity
- Time complexity: $O(n \cdot m)$ where `n` is the number of rows and `m` is the number of columns.
- Space complexity: $O(n \cdot m)$ for storing the result matrix.

## Code 
```cpp
class Solution {
public:
    vector<vector<int>> restoreMatrix(vector<int>& rowSum, vector<int>& colSum) {
        int n = rowSum.size(), m = colSum.size();
        vector<vector<int>> res(n, vector<int>(m));

        int i = 0, j = 0;
        while (i < n && j < m) {
            res[i][j] = min(rowSum[i], colSum[j]);

            rowSum[i] -= res[i][j];
            colSum[j] -= res[i][j];

            if (rowSum[i] == 0) ++i;
            if (colSum[j] == 0) ++j;
        }

        return res;
    }
};
```