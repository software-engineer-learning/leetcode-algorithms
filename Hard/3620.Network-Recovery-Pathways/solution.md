# Intuition

Each valid path has a **score** equal to the minimum edge weight on that path.
We want the largest such score among paths whose total cost is at most `k`.

If every edge on a path has weight at least `x`, then that path's score is at
least `x`. So we can binary search on the answer: for a candidate minimum edge
weight `mid`, keep only edges with `cost >= mid` and ask whether a path from
0 to `n - 1` exists with total cost `<= k`.

# Approach: Binary Search + Topological Shortest Path

1. Build an adjacency list from edges whose endpoints are both online. Track
   the minimum and maximum edge weights for the binary-search range.
2. Topologically sort the graph once (Kahn's algorithm) and save each node's
   remaining in-degree. That order is reused inside every feasibility check.
3. For a candidate `mid`, run DP in topological order on edges with
   `cost >= mid`: `dp[v] = min(dp[v], dp[u] + cost)`. If `dp[n - 1] <= k`, then
   some valid path has score at least `mid`.
4. Binary search on `mid` to maximize the feasible minimum edge weight. Return
   `-1` if no candidate works.

# Complexity

- Time complexity: $$O((n + m) \log W)$$, where `m` is the number of edges and
  `W` is the maximum edge cost (up to $$10^9$$). Each of the $$O(\log W)$$
  binary-search steps runs one $$O(n + m)$$ topological shortest-path check.
- Space complexity: $$O(n + m)$$ for the adjacency list, in-degrees, and DP
  array.

# Code

## Go

```go
func findMaxPathScore(edges [][]int, online []bool, k int64) int {
    n := len(online)
    graph := make([][][2]int, n)
    degree := make([]int, n)
    queue := make([]int, 0, n)
    l, r := 1_000_000_000, 0
    for _, edge := range edges {
        u, v, w := edge[0], edge[1], edge[2]
        if !online[u] || !online[v] {
            continue
        }
        graph[u] = append(graph[u], [2]int{v, w})
        l = min(l, w)
        r = max(r, w)
        degree[v]++
    }
    for i := 1; i < n; i++ {
        if degree[i] == 0 {
            queue = append(queue, i)
        }
    }
    for len(queue) > 0 {
        u := queue[0]
        queue = queue[1:]
        for _, edge := range graph[u] {
            v := edge[0]
            degree[v]--
            if v != 0 && degree[v] == 0 {
                queue = append(queue, v)
            }
        }
    }

    isPossible := func(minEdge int) bool {
        dp := make([]int, n)
        for i := range dp {
            dp[i] = 1 << 62
        }
        val := int(k)
        cdegree := make([]int, n)
        copy(cdegree, degree)
        dp[0] = 0
        queue := []int{0}
        for len(queue) > 0 {
            u := queue[0]
            queue = queue[1:]
            if u == n-1 {
                return dp[u] <= val
            }
            for _, edge := range graph[u] {
                v, w := edge[0], edge[1]
                if w >= minEdge {
                    if dp[v]-dp[u] > w {
                        dp[v] = dp[u] + w
                    }
                }
                cdegree[v]--
                if cdegree[v] == 0 {
                    queue = append(queue, v)
                }
            }
        }
        return false
    }

    res := -1
    for l <= r {
        mid := l + (r-l)/2
        if isPossible(mid) {
            res = mid
            l = mid + 1
        } else {
            r = mid - 1
        }
    }
    return res
}
```

## Rust

```rust
use std::collections::VecDeque;
impl Solution {
    fn is_possible(min_edge: i32, k: i64, graph: &[Vec<(usize, i32)>], deg: &[i32], n: usize) -> bool {
        let mut c_degree = deg.to_vec();
        let mut dp = vec![1 << 62; n];
        let mut queue = VecDeque::new();
        dp[0] = 0;
        queue.push_back(0);
        while let Some(u) = queue.pop_front() {
            if u == n - 1 {
                return dp[u] <= k;
            }
            for &(v, w) in &graph[u] {
                if w >= min_edge {
                    if dp[v] - dp[u] > w as i64 {
                        dp[v] = dp[u] + (w as i64);
                    }
                }
                c_degree[v] -= 1;
                if c_degree[v] == 0 {
                    queue.push_back(v);
                }
            }
        }
        false
    }

    pub fn find_max_path_score(edges: Vec<Vec<i32>>, online: Vec<bool>, k: i64) -> i32 {
        let n = online.len();
        let mut graph: Vec<Vec<(usize, i32)>> = vec![Vec::new(); n];
        let mut degree = vec![0; n];
        let (mut l, mut r) = (1_000_000_000, 0);
        for edge in &edges {
            let (u, v, w) = (edge[0] as usize, edge[1] as usize, edge[2]);
            if !online[u] || !online[v] {
                continue;
            }
            graph[u].push((v, w));
            degree[v] += 1;
            l = l.min(w);
            r = r.max(w);
        }
        let mut queue = VecDeque::new();
        for i in 1..n {
            if degree[i] == 0 {
                queue.push_back(i);
            }
        }
        while let Some(u) = queue.pop_front() {
            for &(v, _) in &graph[u] {
                degree[v] -= 1;
                if v != 0 && degree[v] == 0 {
                    queue.push_back(v);
                }
            }
        }

        let mut res = -1;
        while l <= r {
            let mid = l + (r - l) / 2;
            if Self::is_possible(mid, k, &graph, &degree, n) {
                res = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        res
    }
}
```
