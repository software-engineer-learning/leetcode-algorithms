# Intuition
- Given
  𝑛
  n non-negative integers
  𝑎
  1
  ,
  𝑎
  2
  ,
  …
  ,
  𝑎
  𝑛
  a
  1
  ​
  ,a
  2
  ​
  ,…,a
  n
  ​
  where each integer represents the height of a vertical line drawn at that point on the x-axis, the task is to find two lines that, together with the x-axis, form a container that holds the most water.
- The amount of water container by any two lines is determined by multiplying the shorter of the two lines and the distance between them.

# Approach



## 1. Initial two pointers
- Start with the pointer at the beginning (`start`) and one at the end (`end`) of the array   
## 2.Calculate the area
- Compute the area formed by the lines these two pointers using formula

                Area = min(a[start], a[end]) * (end - start)
## 3. Move Pointers:
- To potential find a larger area, move the pointer pointing to the short line inward
##  4. Track the Maximum Length
- Keep track of the maximum area found during the iterations.
# Complexity

- Time complexity: `O(N)`

- Space complexity: `O(1).`

# Code
```java
class Solution {
    public int maxArea(int[] height) {
        int start = 0;
        int end = height.length - 1;
        int max = 0;

        while (start < end) {
            if (height[start] < height[end]) {
                max = Math.max(max, height[start] * (end - start));
                start++;
            } else {
                max = Math.max(max, height[end] * (end - start));
                end--;
            }
        }

        return max;
    }
}
```
