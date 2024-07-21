# Intuition

The goal is to construct a $k \times k$ matrix that satisfies given row and column conditions. These conditions dictate the relative ordering of elements in rows and columns. We can achieve this by performing topological sorts on the conditions to determine a valid sequence for both rows and columns. If a valid topological ordering exists for both conditions, we can then place the elements accordingly in the matrix.

<p>&nbsp;</p>

# Approach: Topological Sort

## Explanation:

1. **Building the Graph**:
   - Use the conditions to build a directed graph and calculate the indegree of each node.
   - `buildGraph` function does this for both row and column conditions.

2. **Topological Sort**:
   - Perform topological sort on the constructed graph to determine the order of elements.
   - `topoSort` function achieves this using Kahn's algorithm (BFS-based topological sort).

3. **Constructing the Matrix**:
   - Use the row and column orderings obtained from the topological sorts to place the elements in the matrix.
   - Ensure each number is placed according to its row and column indices derived from the sorted orders.

## Complexity
- **Time complexity**: $O(k^2)$
- **Space complexity**: $O(k^2)$

## Code 
```cpp
class Solution {
public:
    auto buildGraph(vector<vector<int>>& edges, int k) {
        vector<vector<int>> graph(k + 1);
        vector<int> indegree(k + 1);

        for (auto& e: edges) {
            graph[e[0]].push_back(e[1]);
            ++indegree[e[1]];
        }

        return make_pair(graph, indegree);
    }

    vector<int> topoSort(vector<vector<int>>& conditions, int k) {
        auto [graph, indegree] = buildGraph(conditions, k);

        vector<int> res;
        queue<int> q;

        for (int i = 1; i <= k; i++) {
            if (indegree[i] == 0) {
                q.push(i);
            }
        }

        while (!q.empty()) {
            int curr = q.front();
            q.pop();
            res.push_back(curr);

            for (auto& next: graph[curr]) {
                if (--indegree[next] == 0) {
                    q.push(next);
                }
            }
        }

        return res;
    }

    vector<vector<int>> buildMatrix(int k, vector<vector<int>>& rowConditions, vector<vector<int>>& colConditions) {
        vector<int> row = topoSort(rowConditions, k);
        if (row.size() < k) return {};

        vector<int> col = topoSort(colConditions, k);
        if (col.size() < k) return {};

        vector<int> indexes(k + 1);
        for (int j = 0; j < k; j++) {
            indexes[col[j]] = j;
        }

        vector<vector<int>> res(k, vector<int>(k, 0));
        for (int i = 0; i < k; i++){
            res[i][indexes[row[i]]] = row[i];
        }

        return res;
    }
};
```