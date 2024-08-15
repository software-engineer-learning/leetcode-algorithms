# Intuition
This solution calculates the product of all array elements except the current one without division by using a two-pass approach:
# Approach:
Be careful with Time Limit Exceeded (TLE) errors, as this problem has lengthy test cases. If you don't have a solution, please follow the three steps outlined below:
1.  Left Products Calculation: The first pass computes the product of elements to the left of each index. This is stored in an array r, where r[i] holds the product of all elements before the i-th element.

2.  Right Products Calculation: The second pass computes the product of elements to the right of each index. It updates the array r by multiplying each element r[i] by the product of all elements after the i-th element.

By multiplying these two products, we obtain the desired result array, where each element is the product of all other elements in the original array.
## Complexity
- Time complexity: O(n)
- Space complexity: $O(1)$

## Code 

Java

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int len = nums.length;
        int[] r = new int[len];
        int l = 1;
        r[0] = l;
        int i = 1;
        for (; i < len; i++) {
            l = l * nums[i -1];
            r[i] = l;
        }

        int rg = 1;
        int j = len -2;
        for (; j >= 0; j--) {
            rg = rg * nums[j+1];
            r[j] = r[j] * rg;
        }
        return r;
    }
}
```

Happy coding