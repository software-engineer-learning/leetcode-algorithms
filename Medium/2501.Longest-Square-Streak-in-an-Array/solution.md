# Intuition
To solve this problem, the goal is to find the longest streak of squares within a given array of numbers. Initially, the idea is to check if each number can form a square streak by repeatedly squaring it, counting each step where the squared value exists in the input array. The maximum streak found would be the answer.

# Approach
1. **Mark Valid Numbers**: We create a boolean array `valid` where each index represents a number in the range up to 100,000. If a number exists in the input array, it is marked as `true`.
2. **Track Maximum Range**: We track the maximum number in the input array (`maxRange`) to avoid unnecessary calculations.
3. **Square Streak Calculation**: For each number in the array:
   - Start counting from that number and keep squaring it to find if it exists in the array (using the `valid` array).
   - If it does, continue the streak by squaring again; otherwise, break the loop.
4. **Result**: Keep track of the maximum streak found for any number, and return this as the result.

# Complexity
- **Time Complexity**: 
  - The time complexity is approximately $O(n \log k)$, where `n` is the number of elements in the input array and `k` is the maximum value in the array. This is due to iterating over each element and potentially squaring it until it exceeds `maxRange`.
  
- **Space Complexity**: 
  - The space complexity is $O(m)$, where `m = 100001`, to store the boolean array `valid`.

# Code
```java
class Solution {
    public int longestSquareStreak(int[] nums) {
        boolean[] valid = new boolean[100001];
        int maxRange = Integer.MIN_VALUE;
        for (int num : nums) {
            maxRange = Math.max(maxRange, num);
            valid[num] = true;
        }

        int result = -1;

        for (int num : nums) {
            int count = 1;
            long current = num;
            while (current * current <= maxRange && current * current < 100001) {
                current = current * current;
                if (valid[(int)current]) {
                    count++;
                    result = Math.max(result, count);
                } else {
                    break;
                }
            }
        }

        return result;
    }
}
```