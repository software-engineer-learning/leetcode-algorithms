# Intuition

The score of a path is the **minimum** road distance on that path. Because a
path may reuse roads and cities, we are not forced to take a shortest route in
the usual sense — we can detour to include a cheaper edge if it helps lower the
bottleneck.

Any road reachable from city 1 can be folded into a path to city `n` (the input
guarantees such a path exists). So the answer is simply the smallest edge
weight in the connected component containing cities 1 and `n`.

# Approach: BFS on the Connected Component

1. Build an undirected adjacency list from `roads` (convert 1-indexed cities to
   0-indexed nodes).
2. BFS from city 1 (node 0), tracking the minimum edge weight seen while
   visiting every reachable node.
3. Return that minimum. Every edge in the component can appear on some valid
   1-to-`n` path, so the global minimum edge in the component is achievable.

# Complexity

- Time complexity: $$O(n + m)$$, where `m` is `roads.length` — each node and
  edge is visited once during BFS.
- Space complexity: $$O(n + m)$$ for the adjacency list and visited array.

# Code

## Go

```go
func minScore(n int, roads [][]int) int {
    graph := make([][][2]int, n)
    for _, road := range roads {
        u, v, w := road[0]-1, road[1]-1, road[2]
        graph[u] = append(graph[u], [2]int{v, w})
        graph[v] = append(graph[v], [2]int{u, w})
    }
    visited := make([]bool, n)
    queue := []int{0}
    ans := 1_000_000_000
    for len(queue) > 0 {
        u := queue[0]
        queue = queue[1:]
        for _, edge := range graph[u] {
            v, w := edge[0], edge[1]
            ans = min(ans, w)
            if !visited[v] {
                visited[v] = true
                queue = append(queue, v)
            }
        }
    }
    return ans
}
```

## Rust

```rust
use std::collections::VecDeque;
impl Solution {
    pub fn min_score(n: i32, roads: Vec<Vec<i32>>) -> i32 {
        let n = n as usize;
        let mut graph: Vec<Vec<(usize, i32)>> = vec![Vec::new(); n];
        for road in roads {
            let (u, v, cost) = (road[0] as usize - 1, road[1] as usize - 1, road[2]);
            graph[u].push((v, cost));
            graph[v].push((u, cost));
        }
        let mut queue = VecDeque::new();
        queue.push_back(0);
        let mut visited = vec![false; n];
        visited[0] = true;
        let mut ans = i32::MAX;
        while let Some(u) = queue.pop_front() {
            for &(v, cost) in &graph[u] {
                ans = ans.min(cost);
                if !visited[v] {
                    visited[v] = true;
                    queue.push_back(v);
                }
            }
        }
        ans
    }
}
```
