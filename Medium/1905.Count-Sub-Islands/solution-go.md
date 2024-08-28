# Intuition

The goal is to determine the number of islands in `grid2` that are considered `sub-islands`. To tackle with this problem, we can consider to use `Depth-first search(DFS)` or `Breath-first search(BFS)` to identity and mark islands in `grid2`. While identifying an island in grid2, simultaneously check if the corresponding cells in grid1 also contain land (`1`). If all corresponding cells in grid1 are 1, then this island in grid2 is a sub-island.

# Approach: Depth-First Search (DFS)

- Iterate over all cells in `grid2`.
- When you find an unvisited land cell (1), start a DFS to traverse the entire island.
- During the traversal, check if every cell in the current island in `grid2` corresponds to a `1` in `grid1`.
- If all cells correspond, increment the sub-island count.
- Mark visited cells in grid2 to avoid counting the same island multiple times.

## Complexity

- Time complexity: $O(m * n)$, where $m$ is the number of rows, and $n$ is the number of columns in the grids. Each cell is visited at most once.
- Space complexity: $O(m * n)$.

## Code

### Go

```go
func countSubIslands(grid1 [][]int, grid2 [][]int) int {
    m, n := len(grid2), len(grid2[0])
    var dfs func(int, int) bool
    dfs = func(i, j int) bool {
        if i < 0 || i >= m || j < 0 || j >= n || grid2[i][j] == 0 {
            return true
        }
        isSubIsLand := grid1[i][j] == 1
        grid2[i][j] = 0
        isSubIsLand = dfs(i + 1, j) && isSubIsLand
        isSubIsLand = dfs(i - 1, j) && isSubIsLand
        isSubIsLand = dfs(i, j + 1) && isSubIsLand
        isSubIsLand = dfs(i, j - 1) && isSubIsLand
        return isSubIsLand
    }
    ans := 0
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if grid2[i][j] == 1 {
                if dfs(i, j) {
                    ans++
                }
            }
        }
    }
    return ans
}

```
