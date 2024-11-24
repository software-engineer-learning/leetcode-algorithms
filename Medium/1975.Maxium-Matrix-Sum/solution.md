# Maximum Matrix sum

## Intuition

- Multiplying two adjacent elements by -1 effectively flips their signs.
- This operation can convert negative values into positive ones, which increases the total sum.
- If the total number of negative values in the matrix is even, we can flip all negatives into positives.
- If the total number of negative values is odd, one negative will remain after maximizing positive contributions.
- If one negative value must remain (odd negatives), it’s optimal to minimize its absolute value by keeping the smallest absolute value as negative.
<!-- Describe your first thoughts on how to solve this problem. -->

## Approach

- Count the total number of negative values.
- Compute the smallest absolute value in the matrix.
- Compute the sum of the absolute values of all elements in the matrix.
<!-- Describe your approach to solving the problem. -->

## Complexity

- Time complexity: $O(N^2)$ where $N$ is matrix length.
<!-- Add your time complexity here, e.g. $$O(n)$$ -->

- Space complexity: $O(1)$ with a few calculation for `sum`, `min_abs` and `count_neg`.
<!-- Add your space complexity here, e.g. $$O(n)$$ -->

## Code

```rust []
impl Solution {
    pub fn max_matrix_sum(matrix: Vec<Vec<i32>>) -> i64 {
        let (mut sum, mut min_abs, mut count_neg) = (0i64, i32::MAX, 0);
        for row in matrix.iter() {
            for &val in row.iter() {
                if val < 0 {
                    count_neg += 1;
                }
                min_abs = min_abs.min(val.abs());
                sum += val.abs() as i64;
            }
        }
        if count_neg % 2 == 1 {
            sum -= (2 * min_abs) as i64;
        }
        sum
    }
}
```

```go []

import "math"
func maxMatrixSum(matrix [][]int) int64 {
    sum := int64(0)
    minValue, nNeg := math.MaxInt32, 0
    for i := range matrix {
        for j := range matrix[i] {
            if matrix[i][j] < 0 {
                nNeg++
                sum -= int64(matrix[i][j])
                minValue = min(minValue, -matrix[i][j])
            } else {
                sum += int64(matrix[i][j])
                minValue = min(minValue, matrix[i][j])
            }
        }
    }
    if nNeg % 2 == 1 {
        sum -= int64(2*minValue)
    }

    return sum
}
```
