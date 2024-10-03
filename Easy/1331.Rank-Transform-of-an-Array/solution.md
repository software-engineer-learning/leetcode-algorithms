# Intuition
The problem asks to transform an array such that each element is replaced with its rank when the array is sorted. The rank of an element is determined by its position in the sorted array, with the smallest element getting rank 1. The goal is to assign ranks efficiently by leveraging sorting and a map for lookup.

# Approach
1. First, create a sorted copy of the original array. This will allow us to determine the rank of each element based on its position in the sorted order.
2. Use a hash map to store the ranks for each unique element as we iterate through the sorted array. The rank starts at 1 and increases as we encounter new elements.
3. Finally, iterate through the original array, replacing each element with its corresponding rank from the map.
4. Return the transformed array with ranks.

# Complexity
- Time complexity:
  $O(N \log N)$, where `N` is the length of the array. This is due to the sorting step, while the map operations and final array transformation take linear time $O(N)$.

- Space complexity:  
  $O(N)$, for storing the sorted array and the rank map.

# Code
```java
class Solution {
    public int[] arrayRankTransform(int[] arr) {
        int N = arr.length;
        if (N == 0) {
            return arr;
        }

        int[] sortedArr = arr.clone();
        Arrays.sort(sortedArr);

        Map<Integer, Integer> rankMap = new HashMap<>();
        int rank = 1;

        for (int num : sortedArr) {
            if (!rankMap.containsKey(num)) {
                rankMap.put(num, rank++);
            }
        }

        for (int i = 0; i < N; i++) {
            arr[i] = rankMap.get(arr[i]);
        }

        return arr;
    }
}
```