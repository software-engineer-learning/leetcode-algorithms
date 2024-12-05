# Intuition

- This is a standard 2 pointers problem, the key insight here is to understand the order of each piece and their traveling pattern really do matters.
- Before jumping right into coding the solution, it really helps stopping a bit and think about some test case to understand the problem better. You should think about cases like `start = "__RL__"` `target = "_LR___"`, `start = "__LR__"` `target = "_LR_R_"`, `start = "__LR__"` `target = "_LLR___"` and so on.
- The key is to understand that the order of each piece affect how far they can be moved, because something like `"__LR_____"` and `"LR"` or `"L____L"` and `"LL"` are exactly the same for this problem.

<p>&nbsp;</p>

# Approach: Two pointers

- Create 2 pointers `i` and `j`
- Traverse both string simultaneously and compare the pieces of both in the order they appear while ignoring the `'_'`
- If there are a mismatch, that mean no mater how you move a piece you are still unable to convert `start` into `target`

## Complexity
- Time complexity: $O(n)$ We only travel both start and target string only once so it technically $O(2*n)$ but after asymptote it is $O(n)$.
- Space complexity: $O(1)$ No extra buffer used, we only utilize 2 pointers to track the progress.

## Code 

### CPP
```cpp
class Solution {
public:
    bool canChange(string start, string target) {
        int n = start.size();
        int i = 0, j = 0;
        
        while(i < n && j < n) {
            while(i < n && start[i] == '_') i++;
            while(j < n && target[j] == '_') j++;
            if(start[i] != target[j]) return false;
            if(start[i] == 'L' && i < j) return false;
            if(start[i] == 'R' && i > j) return false;
            i++;
            j++;
        }
        while(i < n) {
            if(start[i] != '_') return false;
            i++;
        }
        while(j < n) {
            if(target[j] != '_') return false;
            j++;
        }
        return true;
    }
};
```