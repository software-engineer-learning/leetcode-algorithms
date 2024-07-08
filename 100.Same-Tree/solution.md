# Intuition

The goal is to determine if two binary trees are identical. Two trees are considered the same if they have the same structure and their corresponding nodes have the same values.

<p>&nbsp;</p>

# Approach: Depth-First Search (DFS)

The recursive approach is straightforward for this problem. We will traverse both trees simultaneously, comparing their nodes at each step.

## Explanation:

1. **Base Cases**:
   - **Both Nodes are `null`**: If both nodes are `null`, they are structurally identical up to this point, so we return `true`.
   - **One Node is `null` and the Other is Not**: If only one of the nodes is `null`, the trees are not structurally identical, so we return `false`.
   - **Node Values Differ**: If the values of the nodes differ, the trees are not identical, so we return `false`.

2. **Recursive Case**:
   - If the current nodes are the same, recursively check their left and right children to ensure the entire subtrees are identical.

## Complexity
- Time complexity: $O(n)$, where $n$ is the number of nodes in the trees.
- Space complexity: $O(h)$, where $h$ is the height of the trees.

## Code

```cpp
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (!p && !q) return true;
        if (!p || !q) return false;

        return (p->val == q->val)
            && isSameTree(p->left, q->left)
            && isSameTree(p->right, q->right);
    }
};
```