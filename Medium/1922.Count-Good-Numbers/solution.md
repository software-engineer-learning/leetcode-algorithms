# Approach

1. **Pattern Analysis**:

   - At even positions (0,2,4...), digits must be even: 0,2,4,6,8 (5 possibilities)
   - At odd positions (1,3,5...), digits must be prime: 2,3,5,7 (4 possibilities)

2. **Mathematical Formula**:

   - For length n, we need to calculate:
     - Number of even positions: `(n + 1) / 2` (ceiling division)
     - Number of odd positions: `n / 2` (floor division)
   - Result
     = $5^{(n+1)/2} * 4^{n/2}$

3. **Modular Exponentiation**:
   - Since numbers can be very large, we use modular exponentiation
   - Implemented using recursive divide-and-conquer approach

# Complexity

- Time complexity: O(log n) due to the efficient modular exponentiation
- Space complexity: O(log n) due to recursion stack in modular exponentiation

# Code

## Rust

```rust
impl Solution {
    const MOD: i64 = 1_000_000_000 + 7;

    // Efficient modular exponentiation
    fn mod_pow(x: i64, y: i64) -> i64 {
        if y == 0 { return 1; }
        if y == 1 { return x % Self::MOD; }

        if y % 2 == 0 {
            let temp = Self::mod_pow(x, y / 2);
            return (temp * temp) % Self::MOD;
        }

        return (Self::mod_pow(x, y - 1) * x) % Self::MOD;
    }

    pub fn count_good_numbers(n: i64) -> i32 {
        (Self::mod_pow(5, (n + 1) / 2) * Self::mod_pow(4, n / 2) % Self::MOD) as i32
    }
}
```

## Go

```go
const MOD int64 = 1_000_000_000 + 7

func modPow(x, y int64) int64 {
    if y == 0 {
        return 1
    }
    if y == 1 {
        return x % MOD
    }
    if y % 2 == 0 {
        temp := modPow(x, y / 2)
        return (temp * temp) % MOD
    }
    temp := modPow(x, y - 1)
    return (temp * x) % MOD
}

func countGoodNumbers(n int64) int {
    return int(modPow(5, (n + 1) / 2) * modPow(4, n / 2) % MOD)
}
```
