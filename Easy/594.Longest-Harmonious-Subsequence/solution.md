# Intuition
- The goal is to find the longest subsequence subarray where the difference between the maximum and minimum elements is exactly 1 
- This can be achieved by counting the occurrences of number and then checking the pairs of consecutive number(`num` and `num + 1`) to see if they form harmonious subsequence. 
# Approach

## 1. Count Occurrences
- Use `HashMap` to count the occurrences of each element in the array 

## 2. Check Consecutive Numbers
- Iterate through the keys in the `HashMap`. 
- For each key, check if the `HashMap` contains the key + 1. 
- If it does, calculate the length of the harmonious subsequence formed by the key and key + 1. 
- Keep track of the maximum length found.
## 3. Return Result
- Return the maximum length of the harmonious subsequence
# Complexity

- Time complexity: `O(n))`

- Space complexity: `O(k)`

# Code

```java
public class LongestHarmoniousSubsequence {
  public int findLHS(int[] nums) {
    HashMap<Integer, Integer> map = new HashMap<>();
    int max_length = Integer.MIN_VALUE;

    for (Integer num : nums) {
      map.put(num, map.getOrDefault(num, 0) + 1);
    }

    for (Map.Entry<Integer, Integer> num : map.entrySet()) {
      if (map.get(num.getKey() + 1) != null) {
        max_length = Math.max(max_length, num.getValue() + map.get(num.getKey() + 1));
      }
    }

    return max_length == Integer.MIN_VALUE ? 0 : max_length;
  }
}
```
