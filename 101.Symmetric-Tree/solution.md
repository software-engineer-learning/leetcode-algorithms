# Intuition

To determine if a binary tree is symmetric, we need to check if it is a mirror of itself. This means that the left subtree should be a mirror reflection of the right subtree.

<p>&nbsp;</p>

# Approach 1: Depth-First Search (DFS), Recursive

## Explanation:

1. **Check Base Cases**:
   - If both nodes `p` and `q` are `null`, return `true`.
   - If one is `null` or their values do not match, return `false`.

2. **Recursive Check**:
   - Call the `isMirrorTree` function recursively to check if `p->left` is a mirror of `q->right` and if `p->right` is a mirror of `q->left`.

## Complexity
- Time complexity: $O(n)$, where $n$ is the number of nodes in the tree.
- Space complexity: $O(h)$, where $h$ is the height of the tree.

## Code

```cpp
class Solution {
public:
    bool isMirrorTree(TreeNode* p, TreeNode* q) {
        if (!p && !q) return true;
        if (!p || !q || p->val != q->val) return false;

        return isMirrorTree(p->left, q->right) && isMirrorTree(p->right, q->left);
    }

    bool isSymmetric(TreeNode* root) {
        return isMirrorTree(root->left, root->right);
    }
};
```

<p>&nbsp;</p>

# Approach 2: Breadth-First Search (BFS), Iterative

## Explanation:

1. **Initialization**:
   - Create a queue to keep pairs of nodes to be compared for symmetry.
   - Add the left and right children of the root as a pair to the queue.

2. **Iterative Process**:
   - For each pair of nodes:
     - If both nodes are `null`, continue.
     - If only one is `null` or their values differ, return `false` because the tree is not symmetric.
     - Add their children to the queue in the correct order to maintain the mirror check.

## Complexity
- Time complexity: $O(n)$, where $n$ is the number of nodes in the tree.
- Space complexity: $O(n)$

## Code

```cpp
class Solution {
public:
    bool isSymmetric(TreeNode* root) {
        queue<pair<TreeNode*, TreeNode*>> q;
        q.emplace(root->left, root->right);

        while (!q.empty()) {
            auto p = q.front();
            q.pop();

            if (!p.first && !p.second) continue;
            
            if (!p.first || !p.second || p.first->val != p.second->val) {
                return false;
            }

            q.emplace(p.first->left, p.second->right);
            q.emplace(p.first->right, p.second->left);
        }

        return true;
    }
};
```