# Intuition

To find the number of good leaf node pairs in a binary tree, we can use Depth-First Search (DFS) to explore the tree. By tracking the distance of leaf nodes from the current node, we can determine if two leaf nodes form a good pair. A key insight is that we only need to check pairs of leaf nodes from different subtrees because pairs from the same subtree are not good by definition.

<p>&nbsp;</p>

# Approach: DFS

## Explanation:

1. **Base Case for Leaf Nodes**:
   - If a node is null, return an empty vector as there are no distances to track.
   - If a node is a leaf (no children), return a vector containing a single element 1, which represents the distance from this leaf node to itself.

2. **DFS on Left and Right Subtrees**:
   - Recursively perform DFS on the left and right subtrees of the current node.
   - Obtain vectors `left` and `right` which contain the distances of leaf nodes in the left and right subtrees from the current node.

3. **Count Good Pairs**:
   - For each pair of distances from the `left` and `right` vectors, check if their sum is less than or equal to the given `distance`. If it is, increment the result counter `res`.

4. **Update Distances and Return**:
   - Create a new vector `distanceList` to store updated distances.
   - Increment each distance from the `left` vector by 1 (to account for the current node) and add it to `distanceList` if it is less than the given `distance`.
   - Similarly, increment each distance from the `right` vector by 1 and add it to `distanceList`.
   - Return `distanceList` for use in the parent node's computations.

## Complexity
- Time complexity: $O(n^2)$, where `n` is the number of nodes in the tree.
- Space complexity: $O(n)$

## Code 
```cpp
class Solution {
private:
    vector<int> dfs(TreeNode* root, int& distance, int& res) {
        if (!root) return {};
        if (!root->left && !root->right) return {1};

        auto left = dfs(root->left, distance, res);
        auto right = dfs(root->right, distance, res);

        for (const auto& distanceLeft: left) {
            for (const auto& distanceRight: right) {
                if (distanceLeft + distanceRight <= distance) {
                    ++res;
                }
            }
        }

        vector<int> distanceList;
        for (auto& distanceLeft: left) {
            if (++distanceLeft < distance)
                distanceList.push_back(distanceLeft);
        }
        for (auto& distanceRight: right) {
            if (++distanceRight < distance)
                distanceList.push_back(distanceRight);
        }

        return distanceList;
    }

public:
    int countPairs(TreeNode* root, int distance) {
        int res = 0;
        dfs(root, distance, res);
        return res;
    }
};
```