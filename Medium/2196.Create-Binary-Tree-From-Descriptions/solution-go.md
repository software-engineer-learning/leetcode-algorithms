# Intuition

# Approach

1. Node Map:

- We use a map (nodeMap) to store references to each TreeNode created. This allows us to efficiently access and connect parent and child nodes.

2. Child Set:

- We use a set (childSet) to keep track of all nodes that are designated as children. This helps us determine the root of the tree later.

3. Creating Nodes and Building Tree:

- For each description, we ensure both parent and child nodes exist in nodeMap.
- We then connect the child to the parent node as either a left or right child based on isLeft.

4. Determining the Root:

- The root of the tree will be a node that is never a child of any other node. We find such a node by checking against childSet.

# Complexity

- Time complexity: `O(N).`

- Space complexity: `O(N).`

# Code

## Go

```golang
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func createBinaryTree(descriptions [][]int) *TreeNode {
    nodeMap := make(map[int]*TreeNode)
    childNode := make(map[int]bool)
    for _, desc := range descriptions {
        parent, child, isLeft := desc[0],desc[1], desc[2]
        if _, ok := nodeMap[parent]; !ok {
            nodeMap[parent] = &TreeNode{Val: parent}
        }

        if _, ok := nodeMap[child]; !ok {
            nodeMap[child] = &TreeNode{Val: child}
        }
        if isLeft > 0 {
            nodeMap[parent].Left = nodeMap[child];
        } else {
            nodeMap[parent].Right = nodeMap[child];
        }
        childNode[child] = true
    }

    for node := range nodeMap {
        if !childNode[node] {
            return nodeMap[node]
        }
    }
    return nil
}
```
