# Intuition

Each shift moves every element one step right, wrapping the last column of a row
into the next row and the bottom-right cell back to `(0, 0)`. That is a single
circular shift on the grid read row by row. After `k` shifts, cell `(i, j)` lands
at a new row/column computed from `j + k` with carry into the row index.

# Approach: Direct Position Mapping

1. Let `m` and `n` be the grid dimensions; use `k %= m * n`.
2. For each `(i, j)`, compute:
   - `newY = (j + k) % n`
   - `count = (j + k) / n` (how many rows the shift carries)
   - `newX = (i + count) % m`
3. Place `grid[i][j]` at `newGrid[newX][newY]`.
4. Return `newGrid`.

# Complexity

- Time complexity: $$O(m \cdot n)$$ — visit each cell once.
- Space complexity: $$O(m \cdot n)$$ for the output grid.

# Code

## Go

```go
func shiftGrid(grid [][]int, k int) [][]int {
    m, n := len(grid), len(grid[0])
    newGrid := make([][]int, m)
    for i := range newGrid {
        newGrid[i] = make([]int, n)
    }
    k %= (m * n)
    for i := range m {
        for j := range n {
            newY := (j + k) % n
            count := (j + k) / n
            newX := (i + count) % m
            newGrid[newX][newY] = grid[i][j]
        }
    }
    return newGrid
}
```

## Rust

```rust
impl Solution {
    pub fn shift_grid(grid: Vec<Vec<i32>>, k: i32) -> Vec<Vec<i32>> {
        let (m, n) = (grid.len(), grid[0].len());

        let mut new_grid = vec![vec![0; n]; m];
        let k = (k as usize) % (m * n);
        for i in 0..m {
            for j in 0..n {
                let new_y = (j + k) % n;
                let count = (j + k) / n;
                let new_x = (i + count) % m;
                new_grid[new_x][new_y] = grid[i][j];
            }
        }
        new_grid
    }
}
```
