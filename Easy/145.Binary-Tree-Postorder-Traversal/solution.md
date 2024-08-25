# Intuition
The problem asks for the postorder traversal of a binary tree, where we visit the left subtree, the right subtree, and then the root node. My initial thought is to use a depth-first search (DFS) approach, which naturally aligns with the postorder traversal's recursive nature.

# Approach
I will implement the postorder traversal using a recursive DFS approach. The DFS function will recursively visit the left and right children of a node before adding the node's value to the result list. This ensures that the traversal order is left-right-root, which is characteristic of postorder traversal.

# Complexity
- Time complexity:  
$O(n)$
The algorithm visits each node exactly once, where `n` is the number of nodes in the binary tree.

- Space complexity:  
$O(n)$
In the worst case, the recursion stack could be as deep as the height of the tree, which can be $O(n)$ for a skewed tree. Additionally, the result list will store `n` elements.

# Code
```java 
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> result = new ArrayList();
        dfs(root, result);
        return result;
    }

    public void dfs(TreeNode root, List<Integer> result) {
        if (root == null) {
            return;
        }

        dfs(root.left, result);
        dfs(root.right, result);
        result.add(root.val);
    }
}
```