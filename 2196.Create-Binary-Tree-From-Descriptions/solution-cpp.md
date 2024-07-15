## Code
```cpp
#define MAX 100001

class Solution {
public:
    TreeNode* createBinaryTree(vector<vector<int>>& descriptions) {
        TreeNode* mp[MAX] {};
        bool children[MAX] {};
        
        for (auto& d: descriptions) {
            mp[d[0]] = mp[d[0]] ? mp[d[0]] : new TreeNode(d[0]);
            mp[d[1]] = mp[d[1]] ? mp[d[1]] : new TreeNode(d[1]);

            if (d[2] == 1) {
                mp[d[0]]->left = mp[d[1]];
            }
            else {
                mp[d[0]]->right = mp[d[1]];
            }

            children[d[1]] = true;
        }

        for (auto& d: descriptions) {
            if (children[d[0]] == false) {
                return mp[d[0]];
            }
        }

        return nullptr;
    }
};
```
