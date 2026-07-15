# 3658. GCD of Odd and Even Sums

You are given an integer `n`. Your task is to compute the **GCD** (greatest
common divisor) of two values:

- `sumOdd`: the sum of the smallest `n` positive odd numbers.
- `sumEven`: the sum of the smallest `n` positive even numbers.

Return the GCD of `sumOdd` and `sumEven`.

## Example 1

```text
Input: n = 4
Output: 4
Explanation:
- Sum of the first 4 odd numbers sumOdd = 1 + 3 + 5 + 7 = 16
- Sum of the first 4 even numbers sumEven = 2 + 4 + 6 + 8 = 20
Hence, GCD(sumOdd, sumEven) = GCD(16, 20) = 4.
```

## Example 2

```text
Input: n = 5
Output: 5
Explanation:
- Sum of the first 5 odd numbers sumOdd = 1 + 3 + 5 + 7 + 9 = 25
- Sum of the first 5 even numbers sumEven = 2 + 4 + 6 + 8 + 10 = 30
Hence, GCD(sumOdd, sumEven) = GCD(25, 30) = 5.
```

## Constraints

- `1 <= n <= 10^4`
