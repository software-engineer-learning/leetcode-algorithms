```rust
struct UnionFind {
    parent: Vec<usize>,
    rank: Vec<usize>,
    count: usize,
}

impl UnionFind {
    fn new(n: usize) -> Self {
        Self {
            parent: (0..n).collect(),
            rank: vec![1; n],
            count: n,
        }
    }

    fn find(&mut self, u: usize) -> usize {
        if self.parent[u] != u {
            self.parent[u] = self.find(self.parent[u]);
        }
        self.parent[u]
    }

    fn union(&mut self, u: usize, v: usize) -> bool {
        let root_u = self.find(u);
        let root_v = self.find(v);

        if root_u != root_v {
            if self.rank[root_u] > self.rank[root_v] {
                self.parent[root_v] = root_u;
            } else if self.rank[root_u] < self.rank[root_v] {
                self.parent[root_u] = root_v;
            } else {
                self.parent[root_v] = root_u;
                self.rank[root_u] += 1;
            }
            self.count -= 1;
            return true;
        }
        false
    }
}



impl Solution {
    fn max_num_edges_to_remove(n: i32, edges: Vec<Vec<i32>>) -> i32 {
    let mut edges = edges.clone();
    edges.sort_by_key(|edge| -edge[0]);

    let mut uf_shared = UnionFind::new(n as usize);
    let mut uf_alice = UnionFind::new(n as usize);
    let mut uf_bob = UnionFind::new(n as usize);

    let mut total_edges_used = 0;

    for edge in edges.iter() {
        let (typei, u, v) = (edge[0] as usize, (edge[1] - 1) as usize, (edge[2] - 1) as usize);

        match typei {
            3 => {
                if uf_shared.union(u, v) {
                    uf_alice.union(u, v);
                    uf_bob.union(u, v);
                    total_edges_used += 1;
                }
            }
            1 => {
                if uf_alice.union(u, v) {
                    total_edges_used += 1;
                }
            }
            2 => {
                if uf_bob.union(u, v) {
                    total_edges_used += 1;
                }
            }
            _ => {}
        }
    }

    let is_connected = |uf: &mut UnionFind| -> bool {
        uf.count == 1
    };

    if !is_connected(&mut uf_alice) || !is_connected(&mut uf_bob) {
        return -1;
    }

    (edges.len() as i32) - total_edges_used
}
}
```
