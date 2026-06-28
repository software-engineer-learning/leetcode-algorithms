# Intuition

We need to rearrange `nums` so that all elements less than `pivot` come first, all
elements equal to `pivot` come in the middle, and all elements greater than `pivot`
come last — while preserving the **relative order** of the less-than and
greater-than groups.

The key observation is that the smaller elements should be filled from the **front**
of the answer and the greater elements should be filled from the **back**. Whatever
gap is left in the middle must be filled with `pivot` values.

# Approach (Two pointers)

- Allocate an answer array `ans` of the same length `n`.
- Keep a `left` pointer starting at `0` (next free slot from the front) and a
  `right` pointer starting at `n - 1` (next free slot from the back).
- Scan with two indices simultaneously: `i` moving forward and `j` moving backward.
  - When `nums[i] < pivot`, place it at `ans[left]` and advance `left`. Because we
    scan `i` left-to-right, the less-than group keeps its original order.
  - When `nums[j] > pivot`, place it at `ans[right]` and decrement `right`. Because
    we scan `j` right-to-left while writing from the back, the greater-than group
    also keeps its original order.
- After the scan, every slot in `[left, right]` belongs to elements equal to the
  pivot, so fill that range with `pivot`.

# Complexity

**Time Complexity:** O(N) where N is the number of elements in `nums`. We make a single combined pass
  to place the non-pivot elements and one pass to fill the pivot values.

**Space Complexity:** O(1) extra space, excluding the O(N) output array that we must return.

# Code

## Go

```go
func pivotArray(nums []int, pivot int) []int {
    n := len(nums)
    left, right := 0, n - 1
    ans := make([]int, n)
    for i, j := 0, n - 1; i < n; i, j = i + 1, j - 1 {
        if nums[i] < pivot {
            ans[left] = nums[i]
            left++
        }
        if nums[j] > pivot {
            ans[right] = nums[j]
            right--
        }
    }
    for left <= right {
        ans[left] = pivot
        left++
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn pivot_array(nums: Vec<i32>, pivot: i32) -> Vec<i32> {
        let n = nums.len();
        let (mut left, mut right) = (0, n - 1);
        let mut ans = vec![0; n];
        for i in 0..n {
            let j = n - i - 1;
            if nums[i] < pivot {
                ans[left] = nums[i];
                left += 1;
            }
            if nums[j] > pivot {
                ans[right] = nums[j];
                if right > 0 {
                    right -= 1;
                }
            }
        }
        for i in left..=right {
            ans[i] = pivot;
        }
        ans
    }
}
```
