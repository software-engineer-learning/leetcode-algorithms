# Initialization
The solution initializes an integer variable count to 0, which will keep track of the current directory level.
# Base Cases
The solution handles two base cases within the loop:
    If the log is "../", it checks if the count is greater than 0 and decrements it if true.
    If the log is "./", it does nothing as it represents staying in the current directory.
# State Transition
For each log entry:
    If the log is "../", decrement the count if it is greater than 0.
    If the log is "./", do nothing.
    For any other log entry, increment the count.

# Complexity
Time complexity: O(n).
Space complexity: O(1).

```c++
class Solution {
public:
    int minOperations(vector<string>& logs) {
        std::ios_base::sync_with_stdio(false);
        std::cin.tie(NULL);
        int count = 0;
        for(int i = 0; i < logs.size(); ++i) {
            if (logs[i] == "../") {
                if (count > 0) {
                    --count;
                }
            } else if (logs[i] != "./") {
                ++count;
            }
        }
        return count;
    }
};

```
