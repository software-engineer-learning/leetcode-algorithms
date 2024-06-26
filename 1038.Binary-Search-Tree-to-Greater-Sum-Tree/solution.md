# Intuition

To convert a Binary Search Tree (BST) to a Greater Tree, we need to transform each node such that its value becomes the original value plus the sum of all keys greater than the original key in the BST. This can be effectively achieved using a reverse in-order traversal (right -> node -> left) because, in a BST, an in-order traversal gives nodes in ascending order, and a reverse in-order traversal gives nodes in descending order. By traversing the tree in descending order, we can keep a running sum of all the nodes we have visited so far and update each node's value accordingly.

&nbsp;

# Approach 1: Recursive

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(n)$

## Code
```cpp []
class Solution {
public:
    void dfs(TreeNode* root, int& sum) {
        if (!root) return;

        dfs(root->right, sum);
        sum += root->val;
        root->val = sum;
        dfs(root->left, sum);
    }

    TreeNode* bstToGst(TreeNode* root) {
        int sum = 0;
        dfs(root, sum);

        return root;
    }
};
```

&nbsp;

# Approach 2: Morris Traversal

This solution uses a non-recursive approach based on Morris Traversal. This technique allows in-order tree traversal without using additional space for a stack or recursion, making the algorithm efficient in terms of space complexity.

## Explanation

1. **Initialization**:
   - `curr` is a pointer to the current node, starting from the root.
   - `sum` is an integer to keep track of the cumulative sum of node values as we traverse the tree.

2. **Main Loop**:
   - The loop continues until `curr` is `nullptr`.

3. **Right Subtree Check**:
   - If `curr` has no right child, this means there are no nodes with greater values in the right subtree. Therefore:
     - Add `curr->val` to `sum`.
     - Update `curr->val` to `sum`.
     - Move to the left child of `curr`.
   - If `curr` has a right child:
     - Find the inorder predecessor of `curr` in its right subtree. The predecessor is the leftmost node in the right subtree or the node that links back to `curr`.
     - Traverse to the leftmost node in the right subtree (or the node that links back to `curr`).

4. **Thread Creation**:
   - If the left child of the predecessor is `nullptr`, it means we need to create a temporary link (thread) back to `curr` to facilitate the traversal.
     - Set the left child of the predecessor to `curr`.
     - Move `curr` to its right child to continue the traversal.
   - If the left child of the predecessor is already set to `curr`, it means we have visited the right subtree and are now back at `curr`:
     - Remove the temporary link (thread) by setting the left child of the predecessor back to `nullptr`.
     - Add `curr->val` to `sum`.
     - Update `curr->val` to `sum`.
     - Move `curr` to its left child to continue the traversal.

5. **Return the Modified Tree**:
   - After completing the traversal, return the modified root node.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(1)$

## Code
```cpp []
class Solution {
public:
    TreeNode* bstToGst(TreeNode* root) {
        TreeNode* curr = root;
        int sum = 0;

        while (curr != nullptr) {
            if (curr->right == nullptr) {
                sum += curr->val;
                curr->val = sum;
                curr = curr->left;
                continue;
            }
            
            TreeNode* prev = curr->right;
            while (prev->left != nullptr && prev->left != curr) {
                prev = prev->left;
            }

            if (prev->left == nullptr) {
                prev->left = curr;
                curr = curr->right;
            }
            else {
                prev->left = nullptr;
                sum += curr->val;
                curr->val = sum;
                curr = curr->left;
            }
        }

        return root;
    }
};
```
