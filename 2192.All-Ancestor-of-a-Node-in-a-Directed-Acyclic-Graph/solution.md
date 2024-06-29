
# Intuition
# Approach
## 1.Graph Representation:
- Represent the graph using an adjacency list. Use a vector of vectors `adj` where `adj[i]` contains all nodes that can be reached directly from node `i`.
## 2.Track Ancestors:
- Use a vector of vectors `ans` where `ans[i]` will store the ancestors of node `i`.
## 3.Depth First Search (DFS):
- For each node `i`, we call the `dfs` function starting from `i`. The `dfs` function traverses all reachable nodes from `i` and updates their ancestors list to include `i`.
- The DFS function iterates over all children of the current node `child`. For each child, it checks if the parent node is already in the ancestor list. If not, it adds the parent and recursively calls `dfs` for the child node.
## 4.Avoiding Duplicates:
- The condition `ans[ch].size() == 0 || ans[ch].back() != parent` ensures that duplicates are avoided when adding ancestors to the list. This condition checks if the ancestors list of the child node is either empty or the last added ancestor is not the current parent.

# Complexity

- Time complexity: `O(N^2 + N*M).`

- Space complexity: `O(N + M).`

# Code
```cpp
class Solution {
public:
    vector<vector<int>> getAncestors(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n), ans(n);
        for (auto& edge: edges) {
            adj[edge[0]].push_back(edge[1]);
        }
        for (int i = 0; i < n; i++) {
            dfs(adj,ans,i,i);
        }
        return ans;
    }
    void dfs(vector<vector<int>>& adj, vector<vector<int>>& ans, int& parent, int& child) {
        for (auto& ch: adj[child]) {
            if (ans[ch].size() == 0 || ans[ch].back() != parent) {
                ans[ch].push_back(parent);
                dfs(adj,ans,parent,ch);
            }
        }
    }
};
```