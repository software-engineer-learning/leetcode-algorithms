# Intuition
The problem asks to find missing dice rolls such that the overall average remains the same. The given rolls and the target mean provide enough information to calculate the total sum that the missing rolls must contribute. The challenge is to determine if it's possible to distribute this sum among the missing rolls and to do so within the constraints of dice rolls (values between 1 and 6).

# Approach
1. First, we calculate the sum of the given rolls.
2. We then compute the remaining sum needed to achieve the target mean across all rolls (given and missing).
3. If the remaining sum cannot be distributed among the missing rolls (i.e., it is too small or too large), we return an empty array, indicating that it’s impossible to achieve the mean.
4. If it’s possible, we distribute the remaining sum as evenly as possible across the missing rolls, ensuring each roll is between 1 and 6.
5. We handle any remainder by incrementing some of the rolls to balance out the total.

# Complexity
- **Time complexity**:  
  The time complexity is $O(m + n)$ where `m` is the length of the given `rolls` array and $$n$$ is the number of missing rolls. Calculating the total sum of `rolls` takes $O(m)$ and distributing the remaining sum among the missing rolls takes $O(n)$.

- **Space complexity**:  
  The space complexity is $O(n)$ because we need an array to store the missing rolls.

# Code
```java
class Solution {
    public int[] missingRolls(int[] rolls, int mean, int n) {
        int m = rolls.length;

        int total = 0;
        for (int roll : rolls) {
            total += roll;
        }

        int remain = mean * (m + n) - total;
        
        if (remain < n || remain > 6 * n) {
            return new int[0]; // Not possible
        }

        int[] result = new int[n];

        int quotient = remain / n;
        int remainder = remain % n;

        for (int i = 0; i < n; i++) {
            result[i] = quotient + (i < remainder ? 1 : 0);
        }

        return result;
    }
}
```