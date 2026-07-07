# Intuition

We only care about the non-zero digits of `n`. Concatenating them in order is the
same as rebuilding a number that skips every zero, and the digit sum of that number
equals the sum of those same non-zero digits. So one pass extracting digits from the
least-significant end lets us build `x` and accumulate `sum` simultaneously.

# Approach: Digit Extraction

1. Walk `n` from the last digit to the first via repeated `n % 10` / `n /= 10`.
2. Add every digit to `sumDigit` (zeros contribute nothing anyway).
3. For each **non-zero** digit, place it into `x` at the current power of ten and
   advance the multiplier `pow10`. Since we process digits from least significant to
   most significant and only skip zeros, the non-zero digits keep their original
   relative order in `x`.
4. Return `x * sum` as a 64-bit value.

# Complexity

- Time complexity: $$O(\log n)$$ — one step per digit of `n`.
- Space complexity: $$O(1)$$ extra space.

# Code

## Go

```go
func sumAndMultiply(n int) int64 {
    newN, pow10, sumDigitN := 0, 1, 0
    for n > 0 {
        digit := n % 10
        sumDigitN += digit

        if digit > 0 {
            newN += digit * pow10
            pow10 *= 10
        }
        n /= 10
    }
    return int64(newN * sumDigitN)
}
```

## Rust

```rust
impl Solution {
    pub fn sum_and_multiply(mut n: i32) -> i64 {
        let (mut new_n, mut pow_10, mut sum_digit) = (0, 1, 0);
        while n > 0 {
            let digit = n % 10;
            sum_digit += digit;
            if digit > 0 {
                new_n += digit * pow_10;
                pow_10 *= 10;
            }
            n /= 10;
        }
        (new_n as i64) * (sum_digit as i64)
    }
}
```
