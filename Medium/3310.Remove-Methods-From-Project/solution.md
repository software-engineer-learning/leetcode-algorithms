# Intuition

The set of **suspicious** methods is exactly everything reachable from `k` in the
invocation graph, so a single BFS/DFS from `k` identifies them. The group can be
removed only if it is "closed" against outside callers: no method outside the
suspicious set may invoke a method inside it. If any such external edge exists,
nothing can be removed and we return all methods; otherwise we return every
non-suspicious method.

# Approach: BFS Reachability + Boundary Check

1. Build a directed adjacency list from the invocations (`u -> v` means `u`
   invokes `v`).
2. BFS from `k`, marking every reachable method as `visited` (suspicious).
3. Scan all methods `u` that are **not** suspicious:
   - If any neighbor `v` of `u` **is** suspicious, an outside method invokes the
     group, so removal is impossible — return all methods `0..n-1`.
   - Otherwise `u` survives; add it to the answer.
4. If no boundary edge is found, the collected non-suspicious methods are the
   remaining ones.

# Complexity

- Time complexity: $$O(n + E)$$, where `n` is the number of methods and `E` is the
  number of invocations — each node and edge is processed a constant number of
  times.
- Space complexity: $$O(n + E)$$ for the adjacency list, the `visited` array, and
  the BFS queue.

# Code

## Go

```go
func remainingMethods(n int, k int, edges [][]int) []int {
    visited := make([]bool, n)
    adj := make([][]int, n)
    for _, edge := range edges {
        u, v := edge[0], edge[1]
        adj[u] = append(adj[u], v)
    }
    queue := []int{k}
    visited[k] = true
    for len(queue) > 0 {
        u := queue[0]
        queue = queue[1:]
        for _, v := range adj[u] {
            if !visited[v] {
                queue = append(queue, v)
                visited[v] = true
            }
        }
    }
    ans := []int{}
    for u := range n {
        if !visited[u] {
            for _, v := range adj[u] {
                if visited[v] {
                    alls := make([]int, n)
                    for i := range n {
                        alls[i] = i
                    }
                    return alls
                }
            }
            ans = append(ans, u)
        }
    }
    return ans
}
```

## Rust

```rust
use std::collections::VecDeque;
impl Solution {
    pub fn remaining_methods(n: i32, k: i32, edges: Vec<Vec<i32>>) -> Vec<i32> {
        let n_u32 = n as usize;
        let mut visited = vec![false; n_u32];
        let mut graph: Vec<Vec<usize>> = vec![Vec::new(); n_u32];
        for edge in &edges {
            let (u, v) = (edge[0] as usize, edge[1] as usize);
            graph[u].push(v);
        }
        let mut queue = VecDeque::new();
        queue.push_back(k as usize);
        visited[k as usize] = true;
        while let Some(u) = queue.pop_front() {
            for &v in &graph[u] {
                if !visited[v] {
                    queue.push_back(v);
                    visited[v] = true;
                }
            }
        }
        let mut ans = vec![];
        for u in 0..n_u32 {
            if !visited[u] {
                for &v in &graph[u] {
                    if visited[v] {
                        return (0..n).collect();
                    }
                }
                ans.push(u as i32);
            }
        }

        ans
    }
}
```
