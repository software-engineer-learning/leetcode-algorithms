# Intuition

To ensure that both Alice and Bob can traverse the entire graph, we need to include enough edges such that each of their graphs is fully connected. We can prioritize the edges that both can use and then fill in the gaps with edges specific to Alice or Bob. By doing this, we can maximize the number of edges that can be removed while still maintaining full connectivity for both Alice and Bob.

<p>&nbsp;</p>

# Approach: Union-Find (Disjoint Set Union)

We use a Union-Find data structure to keep track of the connected components as we add edges to the graph. This helps efficiently manage and merge different sets of nodes, ensuring that we maintain connectivity requirements for both Alice and Bob.

## Explaination:

1. **Sort the edges**:

- Start by processing type 3 edges (shared by both Alice and Bob), as they are the most valuable for connectivity. Then process type 1 and type 2 edges.

2. **Union-Find Structure**:

- Use the Union-Find structure to keep track of connected components for Alice and Bob separately. Use one Union-Find structure for the shared edges and individual ones for Alice and Bob.

3. **Count Connections**:

- Keep track of the number of edges used for both Alice and Bob. Ensure that all nodes are connected by checking the number of components.

4. **Check Connectivity**:

- After processing all edges, ensure that both Alice and Bob's graphs are fully connected (i.e., they should have exactly one connected component).

5. **Calculate Removable Edges**:

- The maximum number of removable edges is the total number of edges minus the number of edges used to keep both graphs connected.

## Complexity

- Time complexity: $O((m + n) * \alpha (n))$, where $m$ is the number of edges and $α(n)$ is the inverse Ackermann function (nearly constant time).
- Space complexity: $O(n)$

```go
type UnionFind struct {
    rank []int
    parent []int
	count int
}

func NewUnionFind(n int) *UnionFind {
    uf := &UnionFind{
        rank: make([]int, n),
        parent: make([]int, n),
		count: n,
    }
    for i := range uf.parent {
        uf.rank[i] = 1
        uf.parent[i] = i
    }
    return uf
}

// path compression
func (uf *UnionFind) Find(u int) int {
	if uf.parent[u] != u {
		uf.parent[u] = uf.Find(uf.parent[u])
	}
	return uf.parent[u]
}

// union by rank
func (uf *UnionFind) Union(u, v int) bool {
	rootU := uf.Find(u)
	rootV := uf.Find(v)

	if rootU != rootV {
		if uf.rank[rootU] > uf.rank[rootV] {
			uf.parent[rootV] = rootU
		} else if uf.rank[rootU] < uf.rank[rootV] {
			uf.parent[rootU] = rootV
		} else {
			uf.parent[rootV] = rootU
			uf.rank[rootU]++
		}
		uf.count--
		return true
	}
	return false
}

func (uf *UnionFind) IsConnected() bool {
	return uf.count == 1
}

func maxNumEdgesToRemove(n int, edges [][]int) int {
    sort.Slice((edges), func(i, j int) bool {
		return edges[i][0] > edges[j][0]
	})

	ufShared := NewUnionFind(n)
	ufAlice := NewUnionFind(n)
	ufBob := NewUnionFind(n)

	totalEdgesUsed := 0
	for _, edge := range edges {
		typei, u, v := edge[0], edge[1]-1, edge[2]-1
		switch typei {
		case 3:
			if ufShared.Union(u, v) {
				ufAlice.Union(u, v)
				ufBob.Union(u, v)
				totalEdgesUsed++
			}
		case 1:
			if ufAlice.Union(u, v) {
				totalEdgesUsed++
			}
		case 2:
			if ufBob.Union(u, v) {
				totalEdgesUsed++
			}
		}
	}

	isConnected := func(uf *UnionFind) bool {
		return uf.IsConnected()
	}
	if !isConnected(ufAlice) || !isConnected(ufBob) {
		return -1
	}
	return len(edges) - totalEdgesUsed
}
```
