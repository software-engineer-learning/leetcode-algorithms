# Intuition
- This is a pretty straightforward problem where you just follow the requirements and simulate the process.
- You can get the last digit of a number in base ten by modding it with 10
- Then you repeatedly divide it by 10 and then modding it to get last digits in each steps.
- You can store the sum of each number inside a hashmap or array for efficient query.

# Complexity
- Time complexity:
  $O(N \log N)$, where `N` is the length of the array. 

- Space complexity:  
  $O(N)$, for storing the sum of each group.

# Code
```cpp
class Solution {
public:
    int countLargestGroup(int n) {
        vector<int> bucket(1e4+1, 0);
        for(int i = 1; i <= n; i++) {
            bucket[helper(i)]++;
        }
        int large = -1, count = 0;
        for(int i : bucket) {
            if(i < large) continue;
            if(i > large) {
                count = 0;
                large = i;
            }
            count++;
        }
        return count;
    }

    int helper(int x) {
        int sum = 0;
        while(x > 0) {
            sum += x%10;
            x /= 10;
        }
        return sum;
    }
};
```                                                                                                                                                                                                                                                                     