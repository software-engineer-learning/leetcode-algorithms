## Explanation

An array is **trionic** if we can split it into three contiguous segments with indices **0 < p < q < n − 1** such that:

- **nums[0...p]** is strictly increasing (peak at index `p`)
- **nums[p...q]** is strictly decreasing (valley at index `q`)
- **nums[q...n − 1]** is strictly increasing

So we need one “mountain” in the middle: the array goes up to a peak `p`, then down to a valley `q`, then up again to the end.

**Approach:**

1. **Find `p` (peak of the first hill)**
   Scan from the left and stop at the first index `i` where `nums[i] <= nums[i-1]`. Then set `p = i - 1`. So `nums[0] < nums[1] < ... < nums[p]`. We require `p > 0`, so the first increasing segment must have at least two elements; if we never break (entire array increasing), there is no valid `p` and we return `false`.

2. **Find `q` (valley between the two hills)**
   From `p + 1`, scan until the first index `i` where `nums[i] >= nums[i-1]`. Then set `q = i - 1`. So `nums[p] > nums[p+1] > ... > nums[q]`. We require `q > p` (at least one element in the decreasing segment) and `q < n - 1` (so there is at least one element in the final increasing segment). If the array keeps decreasing until the end, we never set `q > p` and return `false`.

3. **Check the third segment**
   From `q + 1` to `n - 1`, verify that `nums[q] < nums[q+1] < ... < nums[n-1]`. If any step is non-increasing, return `false`.

**Time complexity:** O(n) — single pass for each phase.
**Space complexity:** O(1).

---

## Code

### Go Solution

```go
func isTrionic(nums []int) bool {
    n := len(nums)
    p := 0
    for i := 1; i < n; i++ {
        if nums[i] <= nums[i-1] {
            p = i - 1
            break
        }
    }
    if p == 0 {
        return false
    }
    q := p
    for i := p + 1; i < n; i++ {
        if nums[i] >= nums[i-1] {
            q = i - 1
            break
        }
    }
    if q == p {
        return false
    }

    for i := q + 1; i < n; i++ {
        if nums[i] <= nums[i-1] {
            return false
        }
    }

    return true
}
```

### Rust Solution

```rust
impl Solution {
    pub fn is_trionic(nums: Vec<i32>) -> bool {
        let n = nums.len();
        let mut p = 0;
        for i in 1..n {
            if nums[i] <= nums[i-1] {
                p = i - 1;
                break;
            }
        }
        if p == 0 {
            return false;
        }
        let mut q = p;
        for i in p + 1..n {
            if nums[i] >= nums[i-1] {
                q = i - 1;
                break;
            }
        }
        if p == q {
            return false;
        }
        for i in q + 1..n {
            if nums[i] <= nums[i-1] {
                return false;
            }
        }
        true
    }
}
```
