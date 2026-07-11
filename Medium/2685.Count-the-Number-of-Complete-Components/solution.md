# Intuition

A connected component is **complete** (a clique) iff it has every possible edge.
For `k` vertices, a complete graph has `k * (k - 1) / 2` undirected edges. During
BFS we traverse each adjacency-list entry once, so each edge is counted twice —
giving `k * (k - 1)` total adjacency visits.

So a component is complete exactly when `edgeCount == vertexCount * (vertexCount - 1)`.

# Approach: BFS per Connected Component

1. Build an undirected adjacency list from `edges`.
2. For each unvisited vertex, run BFS to explore its connected component.
3. Track `vertexCount` (nodes discovered) and `edgeCount` (adjacency entries
   visited during BFS).
4. If `edgeCount == vertexCount * (vertexCount - 1)`, increment the answer.
5. Return the total count of complete components.

# Complexity

- Time complexity: $$O(n + m)$$, where `n` is the number of vertices and `m` is
  `edges.length` — each vertex and edge is processed once across all BFS runs.
- Space complexity: $$O(n + m)$$ for the adjacency list and visited array.

# Code

## Go

```go
func isCompeleteComponent(source int, visited []bool, adj [][]int) bool {
    queue := []int{source}
    visited[source] = true
    nVertices, nEdge := 1, 0
    for len(queue) > 0 {
        u := queue[0]
        queue = queue[1:]
        for _, v := range adj[u] {
            if !visited[v] {
                nVertices++
                visited[v] = true
                queue = append(queue, v)
            }
            nEdge++
        }
    }
    return nEdge == (nVertices-1)*nVertices
}
func countCompleteComponents(n int, edges [][]int) int {
    visited := make([]bool, n)
    ans := 0
    adj := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        adj[u] = append(adj[u], v)
        adj[v] = append(adj[v], u)
    }
    for u := 0; u < n; u++ {
        if !visited[u] && isCompeleteComponent(u, visited, adj) {
            ans++
        }
    }
    return ans
}
```

## Rust

```rust
use std::collections::VecDeque;
impl Solution {
    pub fn count_complete_components(n: i32, edges: Vec<Vec<i32>>) -> i32 {
        let n = n as usize;
        let mut visited = vec![false; n];
        let mut ans = 0;
        let mut adj: Vec<Vec<usize>> = vec![Vec::new(); n];
        for edge in edges {
            let (u, v) = (edge[0] as usize, edge[1] as usize);
            adj[u].push(v);
            adj[v].push(u);
        }
        for u in 0..n {
            if visited[u] {
                continue;
            }
            let mut queue: VecDeque<usize> = VecDeque::new();
            let (mut count, mut n_edge) = (1, 0);
            queue.push_back(u);
            visited[u] = true;
            while let Some(curr) = queue.pop_front() {
                for &v in &adj[curr] {
                    if !visited[v] {
                        count += 1;
                        visited[v] = true;
                        queue.push_back(v);
                    }
                    n_edge += 1;
                }
            }
            if n_edge == (count - 1) * count {
                ans += 1;
            }
        }
        ans
    }
}
```
