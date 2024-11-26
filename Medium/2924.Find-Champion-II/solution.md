# Intuition
The problem revolves around identifying a "champion" in a `Directed Acyclic Graph (DAG)` based on specific rules. 
# Approach
1. **Tracking Defeated Teams**:
   - Use a bitset of size `100` to track teams that have been defeated (i.e., have incoming edges).
   - For every directed edge `[u, v]`, mark v in the losses bitset, as it indicates that `v` has been defeated by `u`.
2. **Identifying the Champion**:
   - Iterate through all n teams.
   - If a team i has not been defeated `(losses[i] == false)`, it is a potential champion.
   - If more than one such team is found, `return -1` immediately, as there is no unique champion.
3. **Return the Result**:
   - If exactly one team has no incoming edges, its index is returned as the champion.
   - If all teams have been defeated, champion remains -1, and the function `returns -1`.

# Complexity
- **Time complexity:**  
  $O(m+n)$ 
  - Marking defeated teams `O(m)`, where `m` is the number of edges (size of edges).
  - Checking all teams `O(n)`, where `n` is the number of teams.

- **Space complexity:**  
  $O(n)$  
# Code
```c++
class Solution {
public:
    int findChampion(int n, vector<vector<int>>& edges) {
        bitset<100> losses; 
        for (const auto& edge : edges) {
            losses.set(edge[1]);
        }
        int champion = -1;
        for (int i = 0; i < n; i++) {
            if (!losses[i]) {
                if (champion != -1) return -1;
                champion = i;
            }
        }
        return champion;
    }
};
```