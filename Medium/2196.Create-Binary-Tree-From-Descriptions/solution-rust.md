# Code

## Rust

```rust
use std::rc::Rc;
use std::cell::RefCell;
use std::collections::{HashMap,HashSet};
impl Solution {
    pub fn create_binary_tree(descriptions: Vec<Vec<i32>>) -> Option<Rc<RefCell<TreeNode>>> {
        let mut node_map:HashMap<i32, Rc<RefCell<TreeNode>>> = HashMap::new();
        let mut child_set:HashSet<i32> = HashSet::new();
        for desc in descriptions {
            let parent = desc[0];
            let child = desc[1];
            let is_left = desc[2];
            node_map.entry(parent).or_insert_with(|| Rc::new(RefCell::new(TreeNode::new(parent))));
            node_map.entry(child).or_insert_with(|| Rc::new(RefCell::new(TreeNode::new(child))));

            let parent_node = node_map.get(&parent).unwrap().clone();
            let child_node = node_map.get(&child).unwrap().clone();

            if is_left > 0 {
                parent_node.borrow_mut().left = Some(child_node);
            } else {
                parent_node.borrow_mut().right = Some(child_node);
            }

            child_set.insert(child);
        }

        for (&parent, _) in &node_map {
            if !child_set.contains(&parent) {
                return node_map.get(&parent).cloned();
            }
        }
        None
    }
}

```
