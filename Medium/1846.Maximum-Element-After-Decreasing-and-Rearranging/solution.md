# Intuition

We may rearrange freely and only decrease values, so the best order is non-decreasing. Once sorted, the smallest element becomes `1`, and every later element can be at most one greater than its predecessor. To maximize the final maximum, each position should stay as large as the constraint allows.

# Approach: Sorting + Greedy

1. Sort `arr` in non-decreasing order.
2. Set `arr[0] = 1`.
3. Scan left to right: if `arr[i + 1] > arr[i] + 1`, cap it to `arr[i] + 1`.
4. Return the last element, which is the largest value in the valid rearrangement.

# Complexity

- Time complexity: $O(n \log n)$ for sorting.
- Space complexity: $O(\log n)$ for the sort stack (in-place sort).

# Code

## Go

```go
import "sort"

func maximumElementAfterDecrementingAndRearranging(arr []int) int {
    sort.Ints(arr)

    arr[0] = 1

    for i := range len(arr) - 1 {
        if arr[i+1] > 1+arr[i] {
            arr[i+1] = arr[i] + 1
        }
    }

    return arr[len(arr)-1]
}
```

## Rust

```rust
impl Solution {
    pub fn maximum_element_after_decrementing_and_rearranging(mut arr: Vec<i32>) -> i32 {
        arr.sort_unstable();
        arr[0] = 1;
        for i in 0..arr.len() - 1 {
            if arr[i + 1] > arr[i] + 1 {
                arr[i + 1] = arr[i] + 1;
            }
        }
        arr[arr.len() - 1]
    }
}
```
