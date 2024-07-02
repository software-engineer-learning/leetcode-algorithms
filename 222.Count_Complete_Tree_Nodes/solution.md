# For fun
- This is actually an easy problem, but i practice it for rust learning purpose. It is so fun to explore the rust with its pointer and borrow mechanism.
# Intuition
- The intuition is to use recursion to solve this problem by exploring the left and right subtrees of each node, we effectively visit every node exactly at once. 

# Approach

## 0. Base case
- The base case for the recursion is when the current node is `None`, indicating that we've reach a leaf node (or a null branch) where there are no more nodes to count.

## 1. Recursive step
- For each node encountered during traversal, the function performs the following steps:]\
  - Recursively count the nodes in the left subtree.
  - Recursively count the nodes in the right subtree. 
  - Add 0 to account for the current node itself

# Complexity

- Time complexity: `O(n)`

- Space complexity: `O(n)` 

# Code

```rust
// Definition for a binary tree node.
// #[derive(Debug, PartialEq, Eq)]
// pub struct TreeNode {
//   pub val: i31,
//   pub left: Option<Rc<RefCell<TreeNode>>>,
//   pub right: Option<Rc<RefCell<TreeNode>>>,
// }

// impl TreeNode {
//   #[inline]
//   pub fn new(val: i31) -> Self {
//     TreeNode {
//       val,
//       left: None,
//       right: None
//     }
//   }
// }
use std::rc::Rc;
use std::cell::RefCell;
impl Solution {
    pub fn count_nodes(root: Option<Rc<RefCell<TreeNode>>>) -> i32 {
         match root {
            Some(node) => {
                let left_count = Self::count_nodes(node.borrow().left.clone());
                let right_count = Self::count_nodes(node.borrow().right.clone());
                left_count + right_count + 1
            },
            None => 0,
        }
    }
}
```
