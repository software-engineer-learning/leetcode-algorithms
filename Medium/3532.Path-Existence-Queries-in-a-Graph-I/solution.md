# Intuition

`nums` is non-decreasing, so any path between nodes must bridge consecutive
indices whose values differ by at most `maxDiff`. If `nums[i] - nums[i - 1] >
maxDiff`, nodes `i - 1` and `i` are disconnected and split the graph into
separate components.

Label each index with a component id in one left-to-right scan; two nodes share a
path iff they share the same id.

# Approach: Component Labeling on Sorted Values

1. Initialize `currentId = 0` and `ids[0] = 0`.
2. For `i` from 1 to `n - 1`, if `nums[i] - nums[i - 1] > maxDiff`, increment
   `currentId`; set `ids[i] = currentId`.
3. For each query `[u, v]`, answer `ids[u] == ids[v]`.

# Complexity

- Time complexity: $$O(n + q)$$, where `q` is `queries.length` — one linear pass
  to label components and $$O(1)$$ per query.
- Space complexity: $$O(n)$$ for the component id array.

# Code

## Go

```go
func pathExistenceQueries(n int, nums []int, maxDiff int, queries [][]int) []bool {
    ids := make([]int, n)
    currentId := 0
    ids[0] = currentId
    for i := 1; i < n; i++ {
        if nums[i]-nums[i-1] > maxDiff {
            currentId++
        }
        ids[i] = currentId
    }
    ans := make([]bool, len(queries))
    for i, q := range queries {
        u, v := q[0], q[1]
        ans[i] = (ids[u] == ids[v])
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn path_existence_queries(n: i32, nums: Vec<i32>, max_diff: i32, queries: Vec<Vec<i32>>) -> Vec<bool> {
        let n = n as usize;
        let mut ids = vec![0; n];
        let mut current_id = 0;
        for i in 1..n {
            if nums[i] - nums[i-1] > max_diff {
                current_id += 1;
            }
            ids[i] = current_id;
        }
        queries.into_iter().map(|q| {
            ids[q[0] as usize] == ids[q[1] as usize]
        }).collect()
    }
}
```
