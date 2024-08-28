# Intuition

The goal is to identify islands in `grid2` that are fully contained within the corresponding islands in `grid1`. This involves using Depth-First Search (DFS) to explore each island in `grid2` and checking whether every part of it exists in `grid1`.

<p>&nbsp;</p>

# Approach: Depth-First Search
This approach uses DFS to explore each cell in `grid2`. When an island (group of connected 1's) is found in `grid2`, the DFS checks whether every cell in that island is also a `1` in the corresponding position in `grid1`. If the entire island is contained within an island in `grid1`, it is counted as a sub-island.

## Explanation:

1. **Initialization**:
   - The `dirs` array defines the four possible directions (right, down, left, up) for moving in the grid.
   - The `n` and `m` variables store the dimensions of the grids.

2. **DFS Function**:
   - The `dfs` function checks whether the current cell `(i, j)` in `grid2` is part of a valid island.
   - If the current cell is out of bounds or contains water (`0`), it returns `true`, meaning this part doesn't invalidate the sub-island condition.
   - The cell is marked as visited by setting `grid2[i][j]` to `0` to prevent revisiting.
   - The result `res` starts as `grid1[i][j]`, meaning if the corresponding cell in `grid1` is water, it’s not a valid sub-island.
   - The DFS then recursively explores all four possible directions. The result is updated by combining the results of these recursive calls with the current `res` using logical `AND` to ensure all parts of the island in `grid2` must match `grid1`.

3. **Counting Sub-Islands**:
   - Iterate through all cells in `grid2`. If a cell is part of an island (`grid2[i][j] == 1`), initiate a DFS from that cell.
   - If the DFS returns `true`, it means this entire island in `grid2` is a sub-island of `grid1`, so increment the result counter.

4. **Final Return**:
   - The function returns the count of sub-islands found.

## Complexity
- Time complexity: $O(n \times m)$, where `n` is the number of rows and `m` is the number of columns in the grids. Every cell is visited once during the DFS.
- Space complexity: $O(n \times m)$ in the worst case due to the recursive stack.

## Code 
### C++
```cpp
const int dirs[] = {0, 1, 0, -1, 0};

class Solution {
public:
    int n, m;

    bool dfs(vector<vector<int>>& grid1, vector<vector<int>>& grid2, int i, int j) {
        if (i < 0 || i == n || j < 0 || j == m || grid2[i][j] == 0) {
            return true;
        }

        grid2[i][j] = 0;
        
        bool res = grid1[i][j];

        for (int d = 0; d < 4; d++) {
            res = dfs(grid1, grid2, i + dirs[d], j + dirs[d + 1]) && res;
        }

        return res;
    }

    int countSubIslands(vector<vector<int>>& grid1, vector<vector<int>>& grid2) {
        n = grid1.size();
        m = grid1[0].size();

        int res = 0;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid2[i][j] == 1 && dfs(grid1, grid2, i, j) == true) {
                    ++res;
                }
            }
        }

        return res;
    }
};
```
