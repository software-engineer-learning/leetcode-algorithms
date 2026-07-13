# Intuition

A sequential number is built from a starting digit `d` (1–9) by repeatedly
appending `d+1`, `d+2`, … while digits stay ≤ 9. There are only finitely many
such numbers (at most 36), so we can either generate them on the fly or filter a
fixed precomputed list.

# Approach: Digit Generation

1. For each start digit `i` from 1 to 9, initialize `number = i`.
2. Append the next digit `j` (`i+1` … 9), forming `number = number * 10 + j`.
3. If `low <= number <= high`, collect it.
4. Sort the results and return.

# Approach: Precomputed Lookup

There are only 36 sequential-digit integers in total (from `12` to `123456789`).
Store them in a constant array and return those falling in `[low, high]` — already
sorted, so no extra sort step.

# Complexity

- **Generation:** $$O(1)$$ time — at most 36 candidates; sorting is
  $$O(k \log k)$$ with tiny `k`. $$O(k)$$ space for the answer.
- **Precomputed:** $$O(1)$$ time and $$O(k)$$ space — scan a fixed list of 36
  values.

# Code

## Go (Generation)

```go
import "sort"

func sequentialDigits(low int, high int) []int {
    // digits := []int{1,2,3,4,5,6,7,8,9}
    ans := []int{}
    for i := 1; i < 10; i++ {
        number := i
        for j := i + 1; j < 10; j++ {
            number = number*10 + j
            if low <= number && number <= high {
                ans = append(ans, number)
            }
        }
    }
    sort.Ints(ans)
    return ans
}
```

## Go (Precomputed)

```go
func sequentialDigits(low int, high int) []int {
    results := []int{
        12, 23, 34, 45, 56, 67, 78, 89,
        123, 234, 345, 456, 567, 678, 789,
        1234, 2345, 3456, 4567, 5678, 6789,
        12345, 23456, 34567, 45678, 56789,
        123456, 234567, 345678, 456789,
        1234567, 2345678, 3456789,
        12345678, 23456789,
        123456789,
    }
    ans := []int{}
    for _, result := range results {
        if low <= result && result <= high {
            ans = append(ans, result)
        }
    }
    return ans
}
```

## Rust (Generation)

```rust
impl Solution {
    pub fn sequential_digits(low: i32, high: i32) -> Vec<i32> {
        let mut ans = vec![];
        for i in 1..10 {
            let mut number = i as i32;
            for j in i + 1..10 {
                number = number * 10 + j as i32;
                if low <= number && number <= high {
                    ans.push(number);
                }
            }
        }
        ans.sort_unstable();
        ans
    }
}
```

## Rust (Precomputed)

```rust
impl Solution {
    pub fn sequential_digits(low: i32, high: i32) -> Vec<i32> {
        let results = [
            12i32, 23, 34, 45, 56, 67, 78, 89,
            123, 234, 345, 456, 567, 678, 789,
            1234, 2345, 3456, 4567, 5678, 6789,
            12345, 23456, 34567, 45678, 56789,
            123456, 234567, 345678, 456789,
            1234567, 2345678, 3456789,
            12345678, 23456789,
            123456789,
        ];

        let mut ans: Vec<i32> = Vec::new();
        for x in results.into_iter() {
            if low <= x && x <= high {
                ans.push(x);
            }
        }
        ans
    }
}
```
