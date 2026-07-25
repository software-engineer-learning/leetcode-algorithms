# Intuition

The largest product of two digits is the product of the two largest digits in
`n` (allowing the same digit twice if it appears twice). Track the top two
digits while extracting them one by one.

# Approach: Track Top Two Digits

1. Initialize `firstMax` and `secondMax` to 0.
2. While `n > 0`, take `digit = n % 10`:
   - If `digit > firstMax`, shift `firstMax` into `secondMax` and update
     `firstMax`.
   - Else if `digit > secondMax`, update `secondMax`.
3. Return `firstMax * secondMax`.

# Complexity

- Time complexity: $$O(\log n)$$ — one step per digit of `n`.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func maxProduct(n int) int {
    firstMax, secondMax := 0, 0
    for n > 0 {
        digit := n % 10
        if digit > firstMax {
            firstMax, secondMax = digit, firstMax
        } else if digit > secondMax {
            secondMax = digit
        }
        n /= 10
    }
    return firstMax * secondMax
}
```

## Rust

```rust
impl Solution {
    pub fn max_product(mut n: i32) -> i32 {
        let (mut first_max, mut second_max) = (0, 0);
        while n > 0 {
            let digit = n % 10;
            if first_max < digit {
                second_max = first_max;
                first_max = digit;
            } else if second_max < digit {
                second_max = digit;
            }
            n /= 10;
        }
        first_max * second_max
    }
}
```
