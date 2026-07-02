# Intuition

We want to know whether some path from `(0, 0)` to `(m-1, n-1)` keeps health
positive the whole way. Stepping onto an unsafe cell (`grid[i][j] == 1`) costs one
health point. So the cheapest path is the one that passes through the fewest
unsafe cells, and the walk is possible exactly when that minimum cost stays below
`health` (we need at least 1 health remaining).

This is a shortest-path problem where edges have weight `0` (moving onto a safe
cell) or `1` (moving onto an unsafe cell) — the classic setting for **0-1 BFS**.

# Approach: 0-1 BFS with a deque

Track `dist[i][j]` = the minimum number of unsafe cells on any path reaching
`(i, j)` (including the cell itself). Process cells with a double-ended queue:

1. Start at `(0, 0)` with `dist[0][0] = grid[0][0]`.
2. Pop a cell; if it is the destination, a safe walk exists — return `true`.
3. For each of the 4 neighbours, the cost to enter it is
   `dist[cur] + grid[neighbour]`. Skip the neighbour if that cost is `>= health`
   (we would run out of health), or if it does not improve the neighbour's best
   known `dist`.
4. Otherwise relax it, and add it to the deque with **0-1 BFS ordering**: push to
   the **front** when the neighbour is safe (weight 0) and to the **back** when it
   is unsafe (weight 1). This keeps the deque monotonic, so the first time we pop
   the destination its distance is minimal.

If the queue empties without reaching the destination, return `false`.

# Complexity

- Time complexity: $$O(m \cdot n)$$ — 0-1 BFS visits each of the `m x n` cells a
  constant number of times, with `O(1)` work per edge.
- Space complexity: $$O(m \cdot n)$$ for the `dist` grid and the deque.

# Code

## Go

```go
import (
    "container/list"
    "math"
)

func findSafeWalk(grid [][]int, health int) bool {
    m, n := len(grid), len(grid[0])
    dirs := [4][2]int{{0, 1}, {0, -1}, {1, 0}, {-1, 0}}
    dist := make([][]int, m)
    for i := range dist {
        dist[i] = make([]int, n)
        for j := range dist[i] {
            dist[i][j] = math.MaxInt32
        }
    }
    queue := list.New()
    queue.PushFront([2]int{0, 0})
    dist[0][0] = grid[0][0]
    for queue.Len() > 0 {
        curr := queue.Remove(queue.Front()).([2]int)
        currRow, currCol := curr[0], curr[1]
        if currRow == m - 1 && currCol == n - 1 {
            return true
        }
        for _, dir := range dirs {
            newRow, newCol := currRow + dir[0], currCol + dir[1]
            if newRow >= 0 && newRow < m && newCol >= 0 && newCol < n {
                cost := dist[currRow][currCol] + grid[newRow][newCol]
                if cost >= health {
                    continue
                }
                if cost < dist[newRow][newCol] {
                    dist[newRow][newCol] = cost
                    if grid[newRow][newCol] == 0 {
                        queue.PushFront([2]int{newRow, newCol})
                    } else {
                        queue.PushBack([2]int{newRow, newCol})
                    }
                }
            }
        }
    }
    return false
}
```

## Rust

```rust
use std::collections::VecDeque;

const DIRS: [(i32, i32); 4] = [(0, 1), (0, -1), (1, 0), (-1, 0)];

impl Solution {
    pub fn find_safe_walk(grid: Vec<Vec<i32>>, health: i32) -> bool {
        let (m,n) = (grid.len(), grid[0].len());
        let mut dist = vec![vec![i32::MAX; n]; m];
        let mut q = VecDeque::new();
        q.push_front((0, 0));
        dist[0][0] = grid[0][0];
        while let Some((cur_x, cur_y)) = q.pop_front() {
            if cur_x == m - 1 && cur_y == n - 1 {
                return true;
            }
            for &dir in &DIRS {
                let (new_x, new_y) = (cur_x as i32 + dir.0, cur_y as i32 + dir.1);
                if new_x < 0 || new_x >= m as i32 || new_y < 0 || new_y >= n as i32 {
                    continue;
                }
                let (new_x_u32, new_y_u32) = (new_x as usize, new_y as usize);
                let cost = dist[cur_x][cur_y] + grid[new_x_u32][new_y_u32];
                if cost >= health {
                    continue;
                }
                if cost < dist[new_x_u32][new_y_u32] {
                    dist[new_x_u32][new_y_u32] = cost;
                    if grid[new_x_u32][new_y_u32] == 0 {
                        q.push_front((new_x_u32, new_y_u32));
                    } else {
                        q.push_back((new_x_u32, new_y_u32));
                    }
                }
            }

        }
        false
    }
}
```
