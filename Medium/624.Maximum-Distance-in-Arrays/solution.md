## Intuition

The problem likely asks to find the maximum distance between elements in different sub-arrays within a list of arrays. The goal is to maximize the difference between the largest element in one array and the smallest element in another array. The intuition is to track the minimum and maximum values seen so far and use them to calculate potential distances as we iterate through the arrays.

## Approach

1. **Initialize** `minSoFar` and `maxSoFar` with the first and last elements of the first array, respectively. This sets a baseline for comparison as you process subsequent arrays.
2. **Iterate** over the arrays starting from the second one. For each array:
   - Calculate the maximum possible distance between any element of the current array and the extremes (`minSoFar`, `maxSoFar`) from previous arrays.
   - Update the result with the maximum distance found so far.
   - Update `minSoFar` and `maxSoFar` with the smallest and largest elements of the current array.
3. **Return** the maximum distance found after processing all arrays.

## Complexity

- **Time Complexity**: The algorithm processes each element in each array exactly once. So, if there are `n` arrays, each of length `m`, the time complexity is $O(n)$ (assuming the length of each array is constant or negligible compared to the number of arrays).
- **Space Complexity**: The space complexity is $O(1)$ since only a few variables are used to keep track of the minimum, maximum, and the result.

## Code

````java
class Solution {
    public int maxDistance(List<List<Integer>> arrays) {
        int minSoFar = arrays.get(0).get(0);
        int maxSoFar = arrays.get(0).get(arrays.get(0).size() - 1);
        int result = Integer.MIN_VALUE;

        for (int i = 1; i < arrays.size(); i++) {
            int first = arrays.get(i).get(0);
            int last = arrays.get(i).get(arrays.get(i).size() - 1);

            int tempResult = Math.max(Math.abs(last - minSoFar),
                                      Math.abs(maxSoFar - first));
            result = Math.max(result, tempResult);

            maxSoFar = Math.max(last, maxSoFar);
            minSoFar = Math.min(first, minSoFar);
        }

        return result;
    }
}
## Intuition

The problem likely asks to find the maximum distance between elements in different sub-arrays within a list of arrays. The goal is to maximize the difference between the largest element in one array and the smallest element in another array. The intuition is to track the minimum and maximum values seen so far and use them to calculate potential distances as we iterate through the arrays.

## Approach

1. **Initialize** `minSoFar` and `maxSoFar` with the first and last elements of the first array, respectively. This sets a baseline for comparison as you process subsequent arrays.
2. **Iterate** over the arrays starting from the second one. For each array:
   - Calculate the maximum possible distance between any element of the current array and the extremes (`minSoFar`, `maxSoFar`) from previous arrays.
   - Update the result with the maximum distance found so far.
   - Update `minSoFar` and `maxSoFar` with the smallest and largest elements of the current array.
3. **Return** the maximum distance found after processing all arrays.

## Complexity

- **Time Complexity**: The algorithm processes each element in each array exactly once. So, if there are `n` arrays, each of length `m`, the time complexity is $O(n)$ (assuming the length of each array is constant or negligible compared to the number of arrays).
- **Space Complexity**: The space complexity is $O(1)$ since only a few variables are used to keep track of the minimum, maximum, and the result.

## Code

### Java

```java
class Solution {
    public int maxDistance(List<List<Integer>> arrays) {
        int minSoFar = arrays.get(0).get(0);
        int maxSoFar = arrays.get(0).get(arrays.get(0).size() - 1);
        int result = Integer.MIN_VALUE;

        for (int i = 1; i < arrays.size(); i++) {
            int first = arrays.get(i).get(0);
            int last = arrays.get(i).get(arrays.get(i).size() - 1);

            int tempResult = Math.max(Math.abs(last - minSoFar),
                                      Math.abs(maxSoFar - first));
            result = Math.max(result, tempResult);

            maxSoFar = Math.max(last, maxSoFar);
            minSoFar = Math.min(first, minSoFar);
        }

        return result;
    }
}
````

### Go

```go
func maxDistance(arrays [][]int) int {
    min_val, max_val := arrays[0][0], arrays[0][len(arrays[0]) - 1]
    res := 0
    for i := 1; i < len(arrays); i++ {
        arr := arrays[i]
        res = max(res, max(abs(arr[len(arr) - 1] - min_val), abs(max_val - arr[0])))
        max_val = max(max_val, arr[len(arr) - 1])
        min_val = min(min_val, arr[0])
    }
    return res
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

### Rust

```rust
impl Solution {
    pub fn max_distance(arrays: Vec<Vec<i32>>) -> i32 {
        let (mut min_val, mut max_val) = (arrays[0][0], arrays[0][arrays[0].len() - 1]);
        let mut res = 0;
        for i in 1..arrays.len() {
            let diff_one = (max_val - arrays[i][0]).abs();
            let diff_two = (arrays[i][arrays[i].len() - 1] - min_val).abs();
            res = res.max(diff_one.max(diff_two));
            max_val = max_val.max(arrays[i][arrays[i].len() - 1]);
            min_val = min_val.min(arrays[i][0]);
        }
        res
    }
}
```
