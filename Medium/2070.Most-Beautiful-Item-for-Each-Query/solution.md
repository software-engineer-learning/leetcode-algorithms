# Intuition
<!-- Describe your first thoughts on how to solve this problem. -->
For each query price, we need to find the maximum beauty among all items with prices less than or equal to the query price. Since we need to search for prices efficiently, sorting the items by price and using binary search is a natural approach. To make it more efficient, we can preprocess the beauty values to maintain running maximums.

# Approach
<!-- Describe your approach to solving the problem. -->
1. Sort items array by price to enable binary search
2. Process beauty values in-place:
   - Keep track of maximum beauty seen so far
   - Update each item's beauty to be the maximum beauty up to that price point
3. For each query:
   - Use binary search to find the rightmost item with price <= query price
   - Return the corresponding maximum beauty (which we preprocessed)
4. Handle edge cases:
   - Empty items array
   - Query price less than smallest item price
   - No items with price <= query price

# Complexity
- Time complexity: $O(n\log n + m\log n)$
  - n log n for sorting items array
  - O(n) for preprocessing beauty values
  - m log n for performing binary search for m queries
  where n is the length of items array and m is the length of queries array

- Space complexity: $O(1)$ (not counting output array)
  - We modify items array in-place for beauty values
  - Binary search uses constant extra space
  - Only extra space used is for the output array

# Code
```java []
class Solution {
    public int[] maximumBeauty(int[][] items, int[] queries) {
        Arrays.sort(items, (a, b) -> a[0] - b[0]);
        
        int maxBeauty = 0;
        for (int[] item : items) {
            maxBeauty = Math.max(maxBeauty, item[1]);
            item[1] = maxBeauty;
        }
        
        int[] result = new int[queries.length];
        for (int i = 0; i < queries.length; i++) {
            result[i] = binarySearch(items, queries[i]);
        }
        
        return result;
    }
    
    private int binarySearch(int[][] items, int target) {
        if (items.length == 0 || target < items[0][0]) return 0;
        
        int left = 0, right = items.length;
        while (left < right) {
            int mid = (left + right) / 2;
            if (items[mid][0] > target) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return items[left - 1][1];
    }
}
```