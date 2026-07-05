# Intuition

We need the maximum sum of digits collected on any valid path from `'S'` (bottom
right) to `'E'` (top left), and the number of paths achieving that sum. Moves are
up, left, or up-left, so every forward path corresponds to a reverse walk from
`'S'` toward `'E'` that only steps down, right, or down-right.

Run DP backward from `'S'`: at each reachable cell, propagate the best score and
path count to its three predecessors. When several paths tie on the maximum
score, add their counts modulo $$10^9 + 7$$.

# Approach: Reverse DP on the Grid

1. Parse the board and initialize `dp[i][j] = (max_score, path_count)` with
   `(-1, 0)` everywhere unreachable.
2. Seed `dp[n - 1][n - 1] = (0, 1)` at `'S'`.
3. Scan cells from bottom-right to top-left. Skip obstacles and unreachable
   cells. For each cell, add its digit (0 for `'S'` and `'E'`) to the score when
   pushing to neighbors at offsets `(-1, 0)`, `(0, -1)`, and `(-1, -1)`.
4. On a strictly larger score, replace the neighbor's count; on a tie, add to
   the count modulo $$10^9 + 7$$.
5. If `dp[0][0]` is unreachable, return `[0, 0]`; otherwise return
   `[max_score, path_count]`.

# Complexity

- Time complexity: $$O(n^2)$$, where `n` is the board side length — each cell
  is processed once with three neighbor updates.
- Space complexity: $$O(n^2)$$ for the DP table.

# Code

## Go

```go
const MOD = 1_000_000_007

func pathsWithMaxScore(board []string) []int {
    n := len(board)
    dp := make([][][]int, 2) // 0: max_sum, 1: count
    dp[0] = make([][]int, n)
    dp[1] = make([][]int, n)
    for i := range n {
        dp[0][i] = make([]int, n)
        dp[1][i] = make([]int, n)
        for j := range n {
            dp[0][i][j] = -1
        }
    }
    dp[0][n-1][n-1] = 0
    dp[1][n-1][n-1] = 1
    dirs := [3][2]int{{-1, 0}, {0, -1}, {-1, -1}}
    for i := n - 1; i >= 0; i-- {
        for j := n - 1; j >= 0; j-- {
            if dp[0][i][j] == -1 || board[i][j] == 'X' {
                continue
            }

            currentVal := 0
            if board[i][j] != 'S' && board[i][j] != 'E' {
                currentVal = int(board[i][j] - '0')
            }

            for _, dir := range dirs {
                newR, newC := i+dir[0], j+dir[1]
                if newR < 0 || newR >= n || newC < 0 || newC >= n {
                    continue
                }
                sum := dp[0][i][j] + currentVal
                if sum > dp[0][newR][newC] {
                    dp[0][newR][newC] = sum
                    dp[1][newR][newC] = dp[1][i][j]
                } else if sum == dp[0][newR][newC] {
                    dp[1][newR][newC] = (dp[1][newR][newC] + dp[1][i][j]) % MOD
                }
            }
        }
    }
    if dp[0][0][0] == -1 {
        return []int{0, 0}
    }
    return []int{dp[0][0][0], dp[1][0][0]}
}
```

## Rust

```rust
const DIRS: [(i32, i32); 3] = [(-1, 0), (0, -1), (-1, -1)];
const MOD: i32 = 1_000_000_007;

impl Solution {
    pub fn paths_with_max_score(board: Vec<String>) -> Vec<i32> {
        let board: Vec<Vec<u8>> = board.iter().map(|s| s.bytes().collect()).collect();
        let n = board.len();
        let mut dp = vec![vec![(-1, 0); n]; n];
        dp[n - 1][n - 1] = (0, 1);
        for i in (0..n).rev() {
            for j in (0..n).rev() {
                if dp[i][j].0 == -1 || board[i][j] == b'X' {
                    continue;
                }
                let current_val = if board[i][j] != b'S' && board[i][j] != b'E' {
                    (board[i][j] - b'0') as i32
                } else {
                    0
                };

                for &dir in &DIRS {
                    let (new_r, new_c) = (i as i32 + dir.0, j as i32 + dir.1);
                    if new_r < 0 || new_r >= n as i32 || new_c < 0 || new_c >= n as i32 {
                        continue;
                    }

                    let (new_r_u32, new_c_u32) = (new_r as usize, new_c as usize);
                    if board[new_r_u32][new_c_u32] == b'X' {
                        continue;
                    }
                    let sum = dp[i][j].0 + current_val;
                    if dp[new_r_u32][new_c_u32].0 < sum {
                        dp[new_r_u32][new_c_u32].0 = sum;
                        dp[new_r_u32][new_c_u32].1 = dp[i][j].1;
                    } else if dp[new_r_u32][new_c_u32].0 == sum {
                        dp[new_r_u32][new_c_u32].1 =
                            (dp[new_r_u32][new_c_u32].1 + dp[i][j].1) % MOD;
                    }
                }
            }
        }
        if dp[0][0].0 == -1 {
            vec![0, 0]
        } else {
            vec![dp[0][0].0, dp[0][0].1]
        }
    }
}
```
