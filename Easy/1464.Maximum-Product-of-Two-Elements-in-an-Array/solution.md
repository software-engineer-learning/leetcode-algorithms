# Intuition

Since all values are positive, `(a-1)*(b-1)` is maximized by choosing the two
largest numbers in the array. Track those two values in one pass, then return
`(first - 1) * (second - 1)`.

# Approach: Track Top Two Values

1. Initialize `firstMax` and `secondMax` to 0.
2. For each `num` in `nums`:
   - If `num > firstMax`, shift `firstMax` into `secondMax` and update
     `firstMax`.
   - Else if `num > secondMax`, update `secondMax`.
3. Return `(firstMax - 1) * (secondMax - 1)`.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `nums.length`.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func maxProduct(nums []int) int {
    firstMax, secondMax := 0, 0
    for _, num := range nums {
        if num > firstMax {
            secondMax, firstMax = firstMax, num
        } else if num > secondMax {
            secondMax = num
        }
    }
    return (firstMax - 1) * (secondMax - 1)
}
```

## Rust

```rust
impl Solution {
    pub fn max_product(nums: Vec<i32>) -> i32 {
        let (mut first, mut second) = (0, 0);
        for num in nums {
            if num > first {
                second = first;
                first = num;
            } else if num > second {
                second = num;
            }
        }
        (first - 1) * (second - 1)
    }
}
```
