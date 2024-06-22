
# Intuition
- Finding the length of the longest consecutive elements sequence in an unsorted array of integers

# Approach

## 1. Using a Set for O(1) Lookups
- First, insert all the elements of the array into a set. This allows for O(1) average-time complexity for lookups, which is crucial for maintaining the overall time complexity of O(n).
## 2.Finding the Start of a Sequence
- The idea is to look for the beginning of a sequence. A number can only be the start of a sequence if there is no preceding number in the set (i.e., num - 1 is not in the set). 
- This ensures we are only counting from the start of each sequence and not redundantly counting from the middle of a sequence.
## 3. Counting the Length of the Sequence
- Once a starting number is identified, count the length of the consecutive sequence starting from that number. This is done by continuously checking for the next number in the set (num + 1, num + 2, etc.) and counting until the next number is not found.
##  4. Track the Maximum Length
- Keep track of the maximum length of all sequences found during this process.
# Complexity

- Time complexity: `O(N).`

- Space complexity: `O(N).`

# Code
```java
class Solution {
    public int longestConsecutive(int[] nums) {
        Set<Integer> uniqueNumber = new HashSet<>();
        for (int num : nums) {
            uniqueNumber.add(num);
        }

        int max = 0;
        int count = 1;
        for (Integer num : uniqueNumber) {
            if (!uniqueNumber.contains(num - 1)) {
                int flag = num + 1;
                while (uniqueNumber.contains(flag++)) {
                    count++;
                }
                max = Math.max(max, count);
            }
            count = 1;
        }
        return max;
    }
}
```
