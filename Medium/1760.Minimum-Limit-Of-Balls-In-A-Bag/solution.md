## Intuition

- The idea is to minimize the maximum size of a bag of balls (x) by repeatedly dividing larger bags into smaller ones, constrained by the number of allowed operations. It can be solved using `binary search` to determine the minimum possible penalty.

<p>&nbsp;</p>

## Approach

### 1. Binary Search

- The penalty (`x`) can range between 1 (minimum) and the maximum value in nums (maximum size of a bag).
- Use binary search to find the smallest `x` such that the total number of operations required to ensure no bag has more than `x` balls is less than or equal to `maxOperations`.

### 2. Helper Function

- Write a function to calculate the number of operations required to ensure no bag exceeds a given size `x`.
- If a bag has `k` balls, and `k > x`, the number of splits needed is: $operations = \lceil\frac{k}{x}\rceil - 1$

### 3. Optimal `x`:

- Perform binary search over the range $\lceil 1, \max(\text{nums}) \rceil$.
- For each `x`, calculate the total operations needed using the helper function.
- If the total operations are within `maxOperations`, update the result and try smaller `x`.

## Explanation:

### 1. Binary Search

- Start with the range $[1, \max(\text{nums})]$.
- For each midpoint (`x`), check if it is possible to split the bags such that no bag exceeds size `x` within `maxOperations`.

### 2. Helper function

- For each bag, calculate the required operations:
  - If k > x, the number of splits needed is:
    $\lceil \frac{k}{x} \rceil - 1 = (k-1) / x$
- If the total operations exceed `maxOperations`, `x` is invalid.

### 3. Result update

- If `x` is valid, update the result and try smaller penalties.
- Otherwise, increase `x`.

## Complexity

- Time complexity: $O(n \cdot \log(\max(\text{nums}))).$, where `n` is the length of the array nums.
- Space complexity: $O(1)$,

## Code

```go []
func possible(nums []int, x int, maxOperations int) bool {
    for _, num := range nums {
        count := (num - 1) / x
        if maxOperations < count {
            return false
        }
        maxOperations -= count
    }
    return true
}

func minimumSize(nums []int, maxOperations int) int {
    left, right := 1, 0
    for _, num := range nums {
        right = max(right, num)
    }

    for left <= right {
        mid := left + (right - left) / 2
        if possible(nums, mid, maxOperations) {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return left
}
```

```rust []
impl Solution {
    fn possible(nums: &Vec<i32>, x: i32, max_operations: i32) -> bool {
        let mut max_operations = max_operations;
        for &num in nums {
            let count = (num - 1) / x;
            if count > max_operations {
                return false;
            }
            max_operations -= count;
        }
        true
    }

    pub fn minimum_size(nums: Vec<i32>, max_operations: i32) -> i32 {
        let (mut left, mut right) = (1, 0);
        for &num in &nums {
            right = right.max(num);
        }
        while left <= right {
            let mid = left + (right - left) / 2;
            if Self::possible(&nums, mid, max_operations) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        left
    }
}
```
