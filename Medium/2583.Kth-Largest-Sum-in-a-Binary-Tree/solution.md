# Intuition
The goal is to find the k-th largest level sum in a binary tree. Since the tree has multiple levels, we can traverse it level by level (BFS) and calculate the sum of node values at each level. We use a min-heap to keep track of the largest k sums, ensuring that we maintain the k largest level sums at any point.

# Approach
1. Use Breadth-First Search (BFS) to traverse the tree level by level.
2. For each level, calculate the sum of node values.
3. Use a min-heap (priority queue) to store the largest k sums. If the heap exceeds k elements, remove the smallest one.
4. At the end of the traversal, the top element of the heap will be the k-th largest level sum. If there are fewer than k levels, return -1.

# Complexity
- Time complexity:  
  The time complexity is $O(n \log k)$, where n is the number of nodes in the tree. Each node is processed once, and inserting/removing elements from the min-heap takes $O(\log k)$ time.

- Space complexity:  
  The space complexity is $O(k + m)$, where k is the number of level sums we are tracking and m is the maximum number of nodes at any level, which determines the size of the queue used in BFS.

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
    public long kthLargestLevelSum(TreeNode root, int k) {
        if (root == null) {
            return -1;
        }

        PriorityQueue<Long> minHeap = new PriorityQueue<>();

        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);

        while (!queue.isEmpty()) {
            int size = queue.size();
            long currentLevelSum = 0;

            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                currentLevelSum += node.val;

                if (node.left != null) {
                    queue.add(node.left);
                }

                if (node.right != null) {
                    queue.add(node.right);
                }
            }

            minHeap.add(currentLevelSum);
            if (minHeap.size() > k) {
                minHeap.poll();
            }
        }

        return minHeap.size() == k ? minHeap.peek() : -1;
    }
}
```