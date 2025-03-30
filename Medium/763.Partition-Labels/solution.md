# Intuition
The problem requires partitioning a string into the maximum number of contiguous substrings where each character appears in at most one part. This means each partition should contain all occurrences of a character before moving to the next partition.

The key observation is that for each partition, we must ensure that all occurrences of any character within that partition are fully contained within it. This allows us to use a `greedy approach` to maximize the number of partitions while ensuring each character appears only once.

# Approach
## 1. Determine the last occurrence of each character
- First, we create a dictionary last that stores the last index of each character in the string.
- This helps in knowing where the partition should at least extend to, in order to fully include a character.
## 2. Traverse the string and form partitions
- Maintain two variables:
    - end: Tracks the farthest last occurrence of characters seen so far in the current partition.
    - size: Tracks the size of the current partition.
- For each character, update end to the farthest last occurrence of any character in the current partition.
- If the current index reaches end, it means we have a complete partition.
    - Store its size in the result list.
    - Reset size for the next partition.

# Complexity
- **Time complexity:**  
    - Building the last dictionary takes O(N), where N is the length of the string.
    - The traversal of the string takes O(N).
    - Overall, the solution runs in O(N) time.

- **Space complexity:**  
    - The last dictionary stores at most 26 keys (for lowercase English letters), which is O(1).
    - The result list stores partition sizes, which takes O(N) in the worst case.
    - Overall, the solution uses O(N) space.
# Code
## Python3
```python3
class Solution:
    def partitionLabels(self, s: str) -> List[int]:
        last = {ch: i for i, ch in enumerate(s)}

        res = []
        size, end = 0, 0
        for i, ch in enumerate(s):
            end = max(end, last[ch])
            size += 1
            if i == end:
                res.append(size)
                size = 0
        return res
```
## C++
```c++
class Solution {
public:
    vector<int> partitionLabels(string s) {
        unordered_map<char, int> last;
        for (int i = 0; i < s.size(); i++) {
            last[s[i]] = i;
        }
        vector<int> res;
        int size = 0, end = 0;
        for (int i = 0; i < s.size(); i++) {
            end = max(end, last[s[i]]);
            size++;
            if (i == end) {
                res.push_back(size);
                size = 0;
            }
        }
        return res;
    }
};
```
