# Intuition

- The question do not ask you to check if the tree is already balanced or not, only wants you to create a balanced BST so you can skip ahead the check and directly build the result, even if the tree was already balanced BST
- A BST can easily be build from a sorted array -> need to convert current tree to sorted array

## Approach

### In-order traversal + binary search

- Traverse the tree to build a sorted array
- Recursively build the balanced BST using the above array and binary search

### Complexity analysis

- Time complexity: *O(n)* - The traverse() function perform in-order traversal which takes *O(n)*, the build() function is called *O(n)* times at worst. So the final time complexity is *O(2n)* which simplifies to *O(n)*
- Space complexity: *O(n)* - The additional list contains at worst n-nodes, the call stack depth is *O(n)* space, as build() function is called n-times recursively.

## Code

```C++
class Solution {
public:
    TreeNode* balanceBST(TreeNode* root) {
        std::ios_base::sync_with_stdio(false);
        std::cin.tie(NULL);
        if(root == NULL || root->left == NULL && root->right == NULL) return root; 
        vector<int> list;
        traverse(root, list);
        int n = list.size();
        return build(list, 0, n-1);
    }

    void traverse(TreeNode* node, vector<int> &list) {
        if(node == NULL) return;
        traverse(node->left, list);
        list.push_back(node->val);
        traverse(node->right, list);
    }

    TreeNode* build(vector<int> &list, int left, int right) {
        if (left > right) return nullptr;
        int mid = left+(right-left)/2; 
        TreeNode* node = new TreeNode(list[mid]);
        node->left = build(list, left, mid - 1);
        node->right = build(list, mid + 1, right);
        return node;
    }
};
```
