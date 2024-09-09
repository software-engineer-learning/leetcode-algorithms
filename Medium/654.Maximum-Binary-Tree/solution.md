# Intuition

- This is a simple divide and conquer problem, you can easily solve this using recursive for $O(n^2)$ time and $O(1)$ space.
- Another solution can be achieved in $O(n)$ time with a trade off of $O(n)$ space.  key insight is that you need to find out the `peak` of a consecutive elements inside the input array.

## Approach

### Using extra space for $O(n) time complexity$

- We can use a monotonic stack to keep track of consecutively increasing elements (choosing an increasing or decreasing monotonic stack is up to you, this implementation use a monotonic decreasing stack).
- If the current `node->val` is bigger than the top of the stack, we found that the current `node->val` a root node and all the elements inside the stack is its left childs. We can start building the tree then.
- After the array traversal is completed, there might be some node left inside of the stack, which is the right portions of the result tree.
- There are 2 things you need to keep track of:
  - The root node, you can keep an independent variable `head` to hold this, it is the biggest value in the array.
  - In case of using monotonic decreasing stack, you have to beware of edge case where input array is strictly increasing, which - based on your implementation - will need to return the `prev` node instead of `curr`.

## Complexity

- **Time complexity**: $O(n)$ - Every node is guaranteed to be added to the stack only once. 
- **Space complexity**: $O(n)$ - The stack can be as big as the input tree.

## Code

```Cpp
class Solution {
public:
    TreeNode* constructMaximumBinaryTree(vector<int>& nums) {
        stack<TreeNode*> stack;
        TreeNode* head = nullptr;
        TreeNode* prev = nullptr;
        for(int val : nums) {
            TreeNode* curr = new TreeNode(val);
            if(!head || val > head->val) head = curr;
            
            // New head found, create tree
            while(!stack.empty() && val > stack.top()->val) {
                if(!prev) {
                    prev = stack.top();
                    stack.pop();
                    continue;
                }
                curr = stack.top();
                TreeNode* temp = prev;
                curr->right = prev;
                prev = curr;
                stack.pop();
            }
            if(prev) {
                head->left = prev;
                curr = head;
            }
            stack.push(curr);
            prev = nullptr;
            head = nullptr;
        }
        while(!stack.empty()) {
            if(!prev) {
                prev = stack.top();
                stack.pop();
                continue;
            }
            head = stack.top();
            TreeNode* temp = prev;
            head->right = prev;
            prev = head;
            stack.pop();
        }
        if(!head) return prev;
        return head;
    }
};
```