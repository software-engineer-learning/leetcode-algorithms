# Intuition

The maximum product of three numbers has only two possible forms:

- the three largest numbers, or
- the largest number multiplied by the two smallest numbers, which may both be
  negative.

We can track the three largest and two smallest values in one pass.

# Approach: Track Five Extreme Values

1. Maintain `max1 >= max2 >= max3`, the three largest values seen.
2. Maintain `min1 <= min2`, the two smallest values seen.
3. For each number, update both groups of extremes.
4. Return the larger of `max1 * max2 * max3` and `min1 * min2 * max1`.

# Complexity

- Time complexity: $$O(n)$$, where `n` is `nums.length`.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
import "math"

func maximumProduct(nums []int) int {
    max1, max2, max3, min1, min2 := math.MinInt32, math.MinInt32, math.MinInt32, math.MaxInt32, math.MaxInt32
	for _, i := range nums {
		if i > max1 {
			max3 = max2
			max2 = max1
			max1 = i
		} else if i > max2 {
			max3 = max2
			max2 = i
		} else if i > max3 {
			max3 = i
		}

		if i < min1 {
			min2 = min1
			min1 = i
		} else if i < min2 {
			min2 = i
		}
	}
    return max(max1 * max2 * max3, min1 * min2 * max1)
}
```

## Rust

```rust
impl Solution {
    pub fn maximum_product(nums: Vec<i32>) -> i32 {
        let (mut max1, mut max2, mut max3, mut min1, mut min2) = (i32::MIN, i32::MIN, i32::MIN, i32::MAX, i32::MAX);
        for num in nums {
            if num > max1 {
                max3 = max2;
                max2 = max1;
                max1 = num;
            } else if num > max2 {
                max3 = max2;
                max2 = num;
            } else if num > max3 {
                max3 = num;
            }

            if num < min1 {
                min2 = min1;
                min1 = num;
            } else if num < min2 {
                min2 = num;
            }
        }
        (max1 * max2 * max3).max(min1 * min2 * max1)
    }
}
```
