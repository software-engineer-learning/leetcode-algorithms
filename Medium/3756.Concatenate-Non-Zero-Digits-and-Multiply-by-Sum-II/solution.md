# Intuition

Each query asks for `x * sum` on a substring, where `x` is the non-zero digits
concatenated and `sum` is the digit sum of `x`. Zeros never affect `sum` (they
contribute 0) and are skipped when building `x`, so we can preprocess three
prefix arrays over `s`:

- digit sum (all digits),
- count of non-zero digits,
- concatenated non-zero value modulo $$10^9 + 7$$.

For a query `[l, r]`, the substring's `x` is recovered from the prefix
concatenation by stripping the prefix before `l` via
`prefix[r + 1] - prefix[l] * 10^{count}`.

# Approach: Prefix Arrays + Range Queries

1. Precompute `pow10[i] = 10^i mod MOD` up to the string length.
2. Scan `s` once to build prefix arrays:
   - `sum[i]` — total digit sum of `s[0..i - 1]`
   - `count[i]` — number of non-zero digits in `s[0..i - 1]`
   - `prefix[i]` — concatenation of non-zero digits in `s[0..i - 1]`, modulo
     `MOD` (unchanged when the current digit is `0`)
3. For each query `[l, r]`:
   - `length = count[r + 1] - count[l]`; if `length == 0`, answer is `0`
   - `sumDigit = sum[r + 1] - sum[l]`
   - `x = (prefix[r + 1] - prefix[l] * pow10[length]) mod MOD`
   - answer = `(x * sumDigit) mod MOD`

# Complexity

- Time complexity: $$O(m + q)$$, where `m` is `s.length` and `q` is the number of
  queries — one linear preprocessing pass plus $$O(1)$$ work per query.
- Space complexity: $$O(m)$$ for the prefix and power-of-ten tables.

# Code

## Go

```go
const (
    MOD = 1_000_000_007
    MAX_N = 100_000
)

var pow10 [MAX_N + 1]int

func init() {
    pow10[0] = 1
    for i := 1; i <= MAX_N; i++ {
        pow10[i] = (pow10[i-1] * 10) % MOD
    }
}

func sumAndMultiply(s string, queries [][]int) []int {
    n := len(s)
    countDigit, sumDigit, prefix := make([]int, n+1), make([]int, n+1), make([]int, n+1)

    for i := range n {
        digit := int(s[i] - '0')
        sumDigit[i+1] = sumDigit[i] + digit
        if digit > 0 {
            countDigit[i+1] = countDigit[i] + 1
            prefix[i+1] = (prefix[i]*10 + digit) % MOD
        } else {
            countDigit[i+1] = countDigit[i]
            prefix[i+1] = prefix[i]
        }
    }
    ans := make([]int, len(queries))
    for i, q := range queries {
        l, r := q[0], q[1]+1
        length := countDigit[r] - countDigit[l]
        if length == 0 {
            continue
        }
        sum := sumDigit[r] - sumDigit[l]
        x := (prefix[r] - (prefix[l]*pow10[length])%MOD + MOD) % MOD
        ans[i] = (x * sum) % MOD
    }
    return ans
}
```

## Rust

```rust
const MOD: i64 = 1_000_000_007;

impl Solution {
    pub fn sum_and_multiply(s: String, queries: Vec<Vec<i32>>) -> Vec<i32> {
        let mut pow10 = [1_i64; 100_001];
        for i in 1..100_001 {
            pow10[i] = (pow10[i - 1] * 10) % MOD;
        }
        let s = s.as_bytes();
        let n = s.len();
        let mut sum = vec![0i32; n + 1];
        let mut count = vec![0i32; n + 1];
        let mut prefix = vec![0i64; n + 1];
        for i in 0..n {
            let digit = (s[i] - b'0') as i32;
            sum[i + 1] = sum[i] + digit;
            prefix[i + 1] = if digit > 0 {
                (prefix[i] * 10 + digit as i64) % MOD
            } else {
                prefix[i]
            };
            count[i + 1] = count[i] + if digit > 0 { 1 } else { 0 };
        }
        queries
            .into_iter()
            .map(|q| {
                let (l, r) = (q[0] as usize, q[1] as usize + 1);
                let length = (count[r] - count[l]) as usize;
                if length == 0 {
                    return 0;
                }
                let sum_digit = (sum[r] - sum[l]) as i64;
                let x = (prefix[r] - (pow10[length] * prefix[l]) % MOD + MOD) % MOD;
                ((sum_digit * x) % MOD) as i32
            })
            .collect()
    }
}
```
