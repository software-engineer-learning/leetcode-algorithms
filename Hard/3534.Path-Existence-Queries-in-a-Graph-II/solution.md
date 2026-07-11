# Intuition

Edges connect nodes whose values differ by at most `maxDiff`. After sorting nodes
by `nums`, any two nodes within `maxDiff` in value lie in a contiguous window of
the sorted array, so connectivity reduces to jumps along that sorted order.

For each sorted position `i`, define one-step reach `st[i][0]` as the farthest
index `r` with `values[r] - values[i] <= maxDiff` (two pointers on the sorted
array). Binary lifting on this jump table answers each query in
$$O(\log n)$$ hops.

# Approach: Sort + Two Pointers + Binary Lifting

1. Sort `(nums[i], i)` by value; build `posIndex` mapping each original node to
   its sorted rank.
2. With a sliding right pointer, set `st[i][0]` = farthest sorted index reachable
   from `i` in one graph hop (value gap `<= maxDiff`).
3. Build binary lifting table: `st[i][j] = st[st[i][j-1]][j-1]`.
4. For each query `[u, v]`:
   - Map to sorted ranks `l, r` (swap so `l <= r`); if `l == r`, answer `0`.
   - Greedily jump the largest power-of-two steps while `st[current][p] < r`.
   - If one more hop reaches `>= r`, answer is `dist + 1`; otherwise `-1`.

# Complexity

- Time complexity: $$O(n \log n + q \log n)$$ — sorting plus $$O(n \log n)$$ to
  build the jump table and $$O(\log n)$$ per query.
- Space complexity: $$O(n \log n)$$ for the binary-lifting table and sorted
  arrays.

# Code

## Go

```go
import "sort"

type Pair struct {
    first, second int
}

func pathExistenceQueries(n int, nums []int, maxDiff int, queries [][]int) []int {
    values := make([]Pair, n)
    for i := range n {
        values[i] = Pair{nums[i], i}
    }
    sort.Slice(values, func(i, j int) bool {
        return values[i].first < values[j].first
    })
    posIndex := make([]int, n)
    for i := range n {
        posIndex[values[i].second] = i
    }
    st := make([][]int, n)
    for i := range n {
        st[i] = make([]int, 18)
    }
    for i, r := 0, 0; i < n; i++ {
        if r < i {
            r = i
        }
        for r+1 < n && values[r+1].first-values[i].first <= maxDiff {
            r++
        }
        st[i][0] = r
    }
    for j := 1; j < 18; j++ {
        for i := range n {
            st[i][j] = st[st[i][j-1]][j-1]
        }
    }
    ans := make([]int, len(queries))
    for i, q := range queries {
        l, r := posIndex[q[0]], posIndex[q[1]]
        if l > r {
            l, r = r, l
        }
        if l == r {
            ans[i] = 0
            continue
        }

        current := l
        d := 0
        for p := 17; p >= 0; p-- {
            if st[current][p] < r {
                current = st[current][p]
                d += (1 << p)
            }
        }
        if st[current][0] >= r {
            ans[i] = d + 1
        } else {
            ans[i] = -1
        }

    }
    return ans
}
```

## Rust

```rust
const LOG: usize = 18;
impl Solution {
    pub fn path_existence_queries(n: i32, nums: Vec<i32>, max_diff: i32, queries: Vec<Vec<i32>>) -> Vec<i32> {
        let n = n as usize;
        let mut values: Vec<(i32, usize)> = vec![(0, 0); n];
        for i in 0..n {
            values[i] = (nums[i], i);
        }
        values.sort_unstable_by_key(|num| num.0);
        let mut pos_index = vec![0; n];
        for i in 0..n {
            pos_index[values[i].1] = i;
        }
        let mut st = vec![vec![0; LOG]; n];
        let mut r = 0;
        for i in 0..n {
            if r < i {
                r = i;
            }
            while r + 1 < n && values[r + 1].0 - values[i].0 <= max_diff {
                r += 1;
            }
            st[i][0] = r;
        }
        for j in 1..LOG {
            for i in 0..n {
                st[i][j] = st[st[i][j-1]][j-1];
            }
        }
        queries.into_iter().map(|q| {
            let (mut l, mut r) = (pos_index[q[0] as usize], pos_index[q[1] as usize]);
            if l > r {
                (l, r) = (r, l);
            }
            if l == r {
                return 0;
            }
            let mut current = l;
            let mut dist = 0;
            for p in (0..18).rev() {
                if st[current][p] < r {
                    current = st[current][p];
                    dist += (1 << p) as i32;
                }
            }
            if st[current][0] >= r {
                dist + 1
            } else {
                -1
            }
        }).collect()
    }
}
```
