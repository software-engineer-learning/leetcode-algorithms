# Approach 1: Brute Force -> Top Down memoization

- A key intuition for this problem is to realize that you dont need to keep track of max_stones of Bob, but instead you need to minimize Alice's max_stones in Bob's turn. The reason why this work is because if we reduce the number of stones Alice can take, the more stones remain for Bob to hoard.
- This realization will make implementing bruteforce much more simple, and from that, we can apply memoization for the top down approach. The implementation will becomes:
    - If its Alice's turns, find max(alice_stone)
    - If its Bob's turns, find min(alice_stone)
    - We need to repeat the process for every possible M, we can do a simple for loop from 1 to M*2, remember to cover out of bound
    - The state transition depends on 3 elements:
        - Is it currently Alice's turns? (is_alice)
        - Position of i and M (index, M)


# Complexity

- Time complexity: $O(N^3)$. At worst case, M can go up to N in size `(N = piles.size())`, at every index we need to loop 2*M times at worst  and there are N work at every state.
- Space complexity: $O(N^3)$. N recursive call stack and N^2 for memoi table

# Solution

## Code 
```cpp
class Solution {
public:
    int stoneGameII(vector<int>& piles) {
        int n = piles.size();
        if(n == 1) return piles[0];
        vector<vector<vector<int>>> memo(n, vector<vector<int>>(n, vector<int>(2, -1)));
        return helper(piles, 1, 0, true, memo);
    }

    int helper(vector<int>& piles, int M, int index, bool is_alice, vector<vector<vector<int>>>& memo) {
        if (index >= piles.size()) return 0;
        if (memo[index][M][is_alice] != -1) return memo[index][M][is_alice];

        int maxStones = is_alice ? 0 : INT_MAX, currentStones = 0;
        for (int i = 1; i <= 2 * M && index + i <= piles.size(); i++) {
            currentStones += piles[index + i - 1];
            if (is_alice) {
                maxStones = max(maxStones, currentStones + helper(piles, max(M, i), index + i, false, memo));
            } else {
                maxStones = min(maxStones, helper(piles, max(M, i), index + i, true, memo));
            }
        }

        memo[index][M][is_alice] = maxStones;
        return maxStones;
    }
};
```