# Intuition

The sum of the first `n` odd numbers is `n^2`, and the sum of the first `n`
even numbers is `n(n + 1)`. So we need `gcd(n^2, n(n + 1))`. Since `gcd(n, n + 1) = 1`,
this simplifies to `n`.

# Approach: Math

Return `n` directly — the GCD of `n^2` and `n(n + 1)` is always `n`.

# Approach: Euclidean GCD

1. Compute `oddSum = n * n` and `evenSum = n * (n + 1)`.
2. Return `gcd(oddSum, evenSum)` using the Euclidean algorithm.

# Complexity

- **Math:** $$O(1)$$ time and space.
- **Euclidean GCD:** $$O(\log n)$$ time (Euclid on values up to $$n^2$$), $$O(1)$$
  space.

# Code

## Go (Math)

```go
func gcdOfOddEvenSums(n int) int {
    return n
}
```

## Go (Euclidean GCD)

```go
func gcdOfOddEvenSums(n int) int {
    oddSum := n * n
    evenSum := (n + 1) * n
    return gcd(oddSum, evenSum)
}

func gcd(a, b int) int {
    for b != 0 {
        a, b = b, a%b
    }
    return a
}
```

## Rust (Math)

```rust
impl Solution {
    pub fn gcd_of_odd_even_sums(n: i32) -> i32 {
        n
    }
}
```

## Rust (Euclidean GCD)

```rust
impl Solution {
    pub fn gcd_of_odd_even_sums(n: i32) -> i32 {
        let even_sum = n * (n + 1);
        let odd_sum = n * n;
        Self::gcd(even_sum, odd_sum)
    }
    pub fn gcd(mut a: i32, mut b: i32) -> i32 {
        while b != 0 {
            let r = a % b;
            (a, b) = (b, r);
        }
        a
    }
}
```
