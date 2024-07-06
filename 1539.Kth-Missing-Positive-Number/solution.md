# Intuition
- We leverage the `Binary Search` to find the `kth` missing positive integer because the BS will help us reduce the search space efficiently.
- The idea behind my solution is that we identify if a number is `kth` missing or not. Since the array is strictly increasing, the number of missing positive integers of any array element `arr[i]` can be found as `arr[i] - i - 1` 
# Approach

## 1. Initialization
- Define `start` and `end` pointers for the binary search
## 2. Early return check
- If `k` is smaller than the first element in the array, the k-th missing number is simply `k`.
- If `k` is greater than the total number of missing numbers up to the last element, the k-th missing number is beyond the last element. This can be calculated by `k + len`.
## 3. Binary Search
- Perform a binary search to find the position where the k-th missing number lies.
- Calculate the middle index `mid` and the count of missing numbers up to `mid`. 
- Adjust the search range based on whether the count is greater than or equal to `k` or less than `k`.
# Complexity

- Time complexity: `O(logn)`

- Space complexity: `O(1)` 

# Code

```rust
impl Solution {
    pub fn find_kth_positive(arr: Vec<i32>, k: i32) -> i32 {
        let len = arr.len() as i32;
        let mut start: i32 = 0;
        let mut end: i32 = len - 1;

        if (k < arr[0]){
            return k;
        }

        if k > arr[arr.len() - 1] - len {
            return k + len;
        }

        while (start < end) {
            let mid = start + (end - start) / 2;

            let count = arr[mid as usize] - mid - 1;

            if (count >= k){
                end = mid;
            } else {
                start = mid + 1;
            }
        }

        start + k
    }
}
```
