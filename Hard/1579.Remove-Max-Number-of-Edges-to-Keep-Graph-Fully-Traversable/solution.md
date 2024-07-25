# Intuition

To ensure that both Alice and Bob can traverse the entire graph, we need to include enough edges such that each of their graphs is fully connected. We can prioritize the edges that both can use and then fill in the gaps with edges specific to Alice or Bob. By doing this, we can maximize the number of edges that can be removed while still maintaining full connectivity for both Alice and Bob.

<p>&nbsp;</p>

# Approach: Union-Find (Disjoint Set Union)
We use a Union-Find data structure to keep track of the connected components as we add edges to the graph. This helps efficiently manage and merge different sets of nodes, ensuring that we maintain connectivity requirements for both Alice and Bob.

## Explanation:

1. **Initialize Union-Find Structures**:
   - Create two Union-Find structures: one for Alice and one for Bob.
   - These structures help us manage and merge nodes while adding edges.

2. **Add Common Edges (Type 3) First**:
   - Iterate through the edges and add the common edges (Type 3) to both Alice's and Bob's Union-Find structures.
   - Track the number of edges used by both.

3. **Add Specific Edges (Type 1 and Type 2)**:
   - Iterate through the edges again. This time, add Type 1 edges to Alice's Union-Find structure and Type 2 edges to Bob's Union-Find structure.
   - Track the number of edges used by each individually.

4. **Check Full Connectivity**:
   - Ensure that both Alice's and Bob's graphs are fully connected by checking if the number of edges used in each equals $n-1$ (minimum edges required for a fully connected graph).

5. **Calculate Removable Edges**:
   - If both graphs are fully connected, calculate the number of removable edges by subtracting the number of used edges from the total number of edges.
   - If either graph is not fully connected, return -1 indicating that it's not possible to maintain full connectivity for both.

## Complexity
- Time complexity: $O((m + n) * \alpha (n))$, where $m$ is the number of edges and $α(n)$ is the inverse Ackermann function (nearly constant time).
- Space complexity: $O(n)$

## Code 

```cpp []
class UnionFind {
private:
    int* root;
    int* rootSize;

public:
    UnionFind(int n) {
        root = new int[n];
        iota(root, root + n, 0);

        rootSize = new int[n];
        fill(rootSize, rootSize + n, 1);
    }

    int find(int x) {
        if (root[x] != x) {
            root[x] = find(root[x]);
        }
        return root[x];
    }

    bool unite(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX == rootY) return false;

        if (rootSize[rootX] < rootSize[rootY]) {
            swap(x, y);
        }

        root[rootY] = rootX;
        rootSize[rootX] += rootSize[rootY];
        return true;
    }
};

class Solution {
public:
    int maxNumEdgesToRemove(int n, vector<vector<int>>& edges) {
        UnionFind alice(n + 1), bob(n + 1);
        int edgesUsed[] = {0, 0, 0};

        for (auto& edge: edges) {
            if (edge[0] != 3) continue;

            if (alice.unite(edge[1], edge[2]) && bob.unite(edge[1], edge[2])) {
                ++edgesUsed[2];
            }
        }

        for (auto& edge: edges) {
            if (edge[0] == 1 && alice.unite(edge[1], edge[2])) {
                ++edgesUsed[0];
            }
            else if (edge[0] == 2 && bob.unite(edge[1], edge[2])) {
                ++edgesUsed[1];
            }
        }

        if (edgesUsed[0] + edgesUsed[2] != n - 1) return -1;
        if (edgesUsed[1] + edgesUsed[2] != n - 1) return -1;

        return (int)edges.size() - edgesUsed[0] - edgesUsed[1] - edgesUsed[2];
    }
};
```