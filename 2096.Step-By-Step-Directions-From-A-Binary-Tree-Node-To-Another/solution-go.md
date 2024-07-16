# Approach

1. findPath Function:

- This function is used to find the path from the root to a target node. It appends “L” to the path if it goes to the left child and “R” if it goes to the right child.
  • If the target node is found, it returns true; otherwise, it backtracks and returns false.

2. getDirections Function:

- This function finds the paths from the root to both the start node (startValue) and the destination node (destValue) using the findPath function.
- It then determines the first point where the paths diverge.
- It constructs the steps required to move up to the common ancestor by appending “U” for each step up.
- Finally, it appends the remaining steps required to reach the destination node.

# Complexity:

- Time complexity: $O(N)$.
- Space complexity: $O(N)$.

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

func findPath(root *TreeNode, target int, path []byte) ([]byte, bool) {
    if root == nil {
        return nil, false
    }
    if root.Val == target {
        return path, true
    }

    if res, ok := findPath(root.Left, target, append(path, 'L')); ok {
        return res, true
    }
    return findPath(root.Right, target, append(path, 'R'))
}


func getDirections(root *TreeNode, startValue int, destValue int) string {
    startPath, _ := findPath(root, startValue, []byte{})
    destPath, _ := findPath(root, destValue, []byte{})


    for len(startPath) > 0 && len(destPath) > 0 && startPath[0] == destPath[0] {
        startPath = startPath[1:]
        destPath = destPath[1:]
    }

    return strings.Repeat("U", len(startPath)) + string(destPath)
}
```
