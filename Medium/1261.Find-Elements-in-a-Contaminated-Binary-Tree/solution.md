# Intuition:
- This question is kinda wordy so lets break it down into intructions. Basically the input is a contaminated tree with all nodes value equal -1 and you have to do 2 things:
  - Recover the tree to its original form using the provided instructions
  - Find out if there is any node has value of `target`

- From that, the question become pretty straight forward. You can just do DFS to recover the tree to its former glory, while doing so keep track of the nodes value using a set/map so you can find the target in O(1)

# Complexity

- Time complexity: $O(N)$ as we need to travel all nodes to recover the tree to its original form
- Space complexity: $O(N)$ as the additional set can contain at most all the node values

## Code 
```cpp
class FindElements {
public:
    unordered_set<int> set;    
    FindElements(TreeNode* root) {
        root->val = 0;
        recover(root);
    }

    void recover(TreeNode* node) {
        if(!node) return;
        set.insert(node->val);
        if(node->left && node->left->val == -1) node->left->val = node->val * 2 + 1;
        if(node->right && node->right->val == -1) node->right->val = node->val * 2 + 2;
        recover(node->left);
        recover(node->right);
    }
    
    bool find(int target) {
        return set.find(target) != set.end();
    }
};
```