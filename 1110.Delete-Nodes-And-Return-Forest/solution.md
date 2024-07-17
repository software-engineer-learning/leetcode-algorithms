# Intuition

The task involves deleting specified nodes from a binary tree and returning the roots of the resulting forest. The main idea is to traverse the tree, check each node against the `to_delete` list, and manage the disconnection of nodes efficiently.

<p>&nbsp;</p>

# Approach 1: Depth-First Search (DFS) + Bitset

We use a depth-first search (DFS) approach to traverse the tree. A bitset is employed to efficiently check if a node needs to be deleted. During the traversal, if a node is marked for deletion, its children are added to the result list as new roots, and the node itself is removed by setting its reference to `nullptr`.

## Explanation:

1. **DFS Traversal**:
   - The `dfs` function is used to traverse the tree recursively.
   - We visit left and right children before processing the current node (post-order traversal).

2. **Deletion Check**:
   - If the current node's value is in the `to_delete` list (checked using the bitset), we consider it for deletion.

3. **Handling Children**:
   - If a node marked for deletion has children, these children become new roots and are added to the result list.

4. **Nullifying Deleted Nodes**:
   - The node marked for deletion is effectively removed by setting its reference to `nullptr`.

## Complexity
- Time complexity: $O(n)$, where `n` is the number of nodes in the tree. Each node is visited once.
- Space complexity: $O(n)$ for the recursion stack and the result list.

## Code 
```cpp
class Solution {
public:
    void dfs(TreeNode*& root, vector<TreeNode*>& res, bitset<1001>& bs) {
        if (!root) return;

        dfs(root->left, res, bs);
        dfs(root->right, res, bs);

        if (bs.test(root->val) == false) return;

        if (root->left) res.push_back(root->left);
        if (root->right) res.push_back(root->right);

        root = nullptr;
    }

    vector<TreeNode*> delNodes(TreeNode* root, vector<int>& to_delete) {
        vector<TreeNode*> res;

        bitset<1001> bs;
        for (int& x: to_delete) {
            bs.set(x);
        }

        dfs(root, res, bs);
        if (root) res.push_back(root);

        return res;
    }
};
```