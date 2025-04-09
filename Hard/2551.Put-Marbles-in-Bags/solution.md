# Intuition
The problem involves dividing marbles into exactly `k` groups, with the cost defined by the sum of the first and last marble weights in each group. The key insight is that the difference between the maximum and minimum total costs depends entirely on the adjacent marble pairs at the partition points. Sorting these adjacent pairs allows efficient calculation of this difference.

# Approach
- Compute the sums of every adjacent pair `(weights[i] + weights[i + 1])`.
- Sort these pair sums to easily identify the largest and smallest values.
- Calculate the difference by subtracting the sum of the smallest `(k-1)` pairs from the sum of the largest `(k-1)` pairs.

# Complexity
- **Time complexity**:  
  $$O(n \log n)$$ due to sorting `(n - 1)` adjacent pair sums.

- **Space complexity**:  
  $$O(n)$$ required for storing adjacent pair sums.

# Code
```py
class Solution:
    def putMarbles(self, weights: List[int], k: int) -> int:
        if k == 1 or len(weights) == 1:
            return 0

        weightPair = sorted(weights[i] + weights[i + 1] for i in range(len(weights) - 1))

        return sum(weightPair[-(k - 1):]) - sum(weightPair[:k - 1])
```