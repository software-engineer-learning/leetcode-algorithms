# Intuition

The goal is to find the number of unique paths from the top-left corner to the bottom-right corner in a grid with obstacles. By using dynamic programming, we can efficiently compute the number of paths while considering the obstacles.

<p>&nbsp;</p>

# Approach: Dynamic Programming with In-Place Modification
We use a dynamic programming approach where we update the grid itself to store the number of ways to reach each cell. This method is space efficient as it doesn't require extra space for a DP table.

## Explanation:

1. **Convert Obstacles**:
   - Iterate through the grid and convert obstacles (1s) to 0s and empty spaces (0s) to 1s. This allows us to use the grid for path counting directly.

2. **Initialize the First Row and Column**:
   - For the first row, if there is an obstacle, all cells to the right are unreachable, so their values remain 0.
   - For the first column, if there is an obstacle, all cells below are unreachable, so their values remain 0.

3. **Dynamic Programming Transition**:
   - For each cell (i, j), if it's not an obstacle, update its value to be the sum of the paths from the cell above (`grid[i-1][j]`) and the cell to the left (`grid[i][j-1]`).

4. **Return Result**:
   - The value at the bottom-right corner of the grid (`grid[n-1][m-1]`) will contain the number of unique paths from the top-left to the bottom-right.

## Complexity
- Time complexity: $O(m \times n)$, where `m` is the number of rows and `n` is the number of columns.
- Space complexity: $O(1)$, since we modify the grid in place and do not use extra space.

## Code 

```cpp
class Solution {
public:
    int uniquePathsWithObstacles(vector<vector<int>>& grid) {
        int n = grid.size();
        int m = grid[0].size();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                grid[i][j] ^= 1;
            }
        }

        for (int j = 1; j < m; j++) {
            grid[0][j] *= grid[0][j - 1];
        }

        for (int i = 1; i < n; i++) {
            grid[i][0] *= grid[i - 1][0];

            for (int j = 1; j < m; j++) {
                grid[i][j] *= grid[i - 1][j] + grid[i][j - 1];
            }
        }

        return grid.back().back();
    }
};
```