# Intuition

The check is a direct restatement of the definition: compute the digit sum $$S$$ and
the digit product $$P$$ of `n`, then test whether `n` is divisible by $$P + S$$. Both
quantities are folds over the same sequence of decimal digits, so a single scan that
updates two accumulators is enough — there is no need to store the digits.

# Approach: Digit Extraction

1. Initialize `product = 1` and `sum = 0`, and copy `n` into a working variable `temp`.
2. While `temp > 0`, take `digit = temp % 10`, multiply it into `product`, add it to
   `sum`, then drop it with `temp /= 10`.
3. Return whether `n % (product + sum) == 0`.

The peel relies on two standard identities: `temp % 10` is the last digit of `temp`,
and integer division `temp /= 10` removes it. The loop ends exactly when every digit
has been consumed. The seed values are the respective identities — `product = 1`
(seeding it with `0` would zero out every result) and `sum = 0`. Digits are visited
right-to-left, which is harmless because both addition and multiplication are
commutative.

## Worked example: `n = 99` → `true`

| iter | digit | sum | product | temp after |
| ---- | ----- | --- | ------- | ---------- |
| 1    | 9     | 9   | 9       | 9          |
| 2    | 9     | 18  | 81      | 0          |

Divisor `= 81 + 18 = 99`, and `99 % 99 == 0`, so the answer is `true`.

## Worked example: `n = 23` → `false`

| iter | digit | sum | product | temp after |
| ---- | ----- | --- | ------- | ---------- |
| 1    | 3     | 3   | 3       | 2          |
| 2    | 2     | 5   | 6       | 0          |

Divisor `= 6 + 5 = 11`, and `23 % 11 == 1`, so the answer is `false`.

## Worked example: `n = 105` → `false`

| iter | digit | sum | product | temp after |
| ---- | ----- | --- | ------- | ---------- |
| 1    | 5     | 5   | 5       | 10         |
| 2    | 0     | 5   | 0       | 1          |
| 3    | 1     | 6   | 0       | 0          |

The zero digit collapses `product` to `0` permanently. Divisor `= 0 + 6 = 6`, and
`105 % 6 == 3`, so the answer is `false`.

## Consequences worth noting

- **A zero digit removes the product entirely.** For any `n` containing a `0`, the
  test degenerates to "is `n` divisible by its digit sum?".
- **Digit sum `1` always returns `true`.** For `10`, `100`, ..., `1000000` the divisor
  is `1`, and every integer is divisible by `1`.
- **No single-digit `n` ever returns `true`.** A lone digit `d` gives divisor
  $$d + d = 2d$$, and $$d \bmod 2d = d \ne 0$$ for every $$d \ge 1$$. So `1`, `5`,
  and `9` all return `false`.
- **The divisor is never zero.** Since $$n \ge 1$$ the leading digit is at least `1`,
  hence $$S \ge 1$$; with $$P \ge 0$$ this gives $$P + S \ge 1$$ and the modulo is
  always well defined.
- **No 32-bit overflow.** Under $$n \le 10^6$$ the digit product peaks at
  $$9^6 = 531441$$ (at `999999`), far below the `i32` limit, so Rust's `i32`
  arithmetic is safe without widening.

# Complexity

- Time complexity: $$O(\log_{10} n)$$ — one iteration per decimal digit, at most 7
  iterations for $$n \le 10^6$$.
- Space complexity: $$O(1)$$ — three scalar accumulators, no digit buffer.

Converting `n` to a string and folding over its characters is equally correct but
allocates; the arithmetic peel avoids that allocation entirely.

# Code

## Go

```go
func checkDivisibility(n int) bool {
    temp := n
    product, sum := 1, 0
    for temp > 0 {
        digit := temp % 10
        product *= digit
        sum += digit
        temp /= 10
    }
    return n % (product + sum) == 0
}
```

## Rust

```rust
impl Solution {
    pub fn check_divisibility(n: i32) -> bool {
        let (mut product, mut sum, mut temp) = (1, 0, n);
        while temp > 0 {
            let digit = temp % 10;
            product *= digit;
            sum += digit;
            temp /= 10;
        }
        n % (product + sum) == 0
    }
}
```

# Test cases

| `n`       | product | sum | divisor | `n % divisor` | result  |
| --------- | ------- | --- | ------- | ------------- | ------- |
| `99`      | 81      | 18  | 99      | 0             | `true`  |
| `23`      | 6       | 5   | 11      | 1             | `false` |
| `1`       | 1       | 1   | 2       | 1             | `false` |
| `9`       | 9       | 9   | 18      | 9             | `false` |
| `10`      | 0       | 1   | 1       | 0             | `true`  |
| `20`      | 0       | 2   | 2       | 0             | `true`  |
| `12`      | 2       | 3   | 5       | 2             | `false` |
| `36`      | 18      | 9   | 27      | 9             | `false` |
| `105`     | 0       | 6   | 6       | 3             | `false` |
| `1000000` | 0       | 1   | 1       | 0             | `true`  |

Sweeping the full constraint range, 54669 of the 1000000 values in
$$[1, 10^6]$$ return `true`.
