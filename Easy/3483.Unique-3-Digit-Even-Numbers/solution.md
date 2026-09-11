# Intuition

The word **distinct** is what shapes the whole solution. Permuting array
*positions* would produce `202` twice when the input holds two copies of `2`, so
that route needs a hash set to deduplicate.

Enumerating by **digit value** instead of by position removes the problem
entirely. There are only 450 candidate numbers — 9 choices for the hundreds digit
(no leading zero), 10 for the tens, 5 for the units (even) — so walk all of them
and ask a single question about each: *does the multiset contain enough copies to
build it?* Each candidate is visited exactly once, so each distinct number is
counted at most once and no deduplication is needed.

The only bookkeeping required is a frequency table, and a digit is "used" by
decrementing its count before descending to the next position.

# Approach: Frequency Table With Borrow and Restore

1. Tally the input into `freq[0..9]`.
2. For each hundreds digit `i` in `1..9` — skipping `0` enforces "no leading
   zeros" structurally — require `freq[i] > 0`, then **borrow** it with
   `freq[i] -= 1`.
3. For each tens digit `j` in `0..9`, require `freq[j] > 0` and borrow it too.
4. For each units digit `k` in `0, 2, 4, 6, 8` — stepping by two enforces
   "even" structurally — count the number if `freq[k] > 0`.
5. **Restore** each borrowed count on the way back out, so the table is unchanged
   for the next branch.

The borrow-and-restore is what enforces "each copy can only be used once per
number". If the input has a single `2`, then choosing `i = 2` drives `freq[2]` to
zero, so the tens loop skips `j = 2` and the units loop rejects `k = 2`. With two
copies of `2`, one borrow still leaves one available — which is exactly why
`[0,2,2]` yields `202`.

## Why the innermost loop does not borrow

The units digit is the last one chosen, so nothing downstream depends on it. It is
enough to *test* `freq[k] > 0` and move on — there is no deeper level that could
mistakenly reuse the same copy. That asymmetry is deliberate, not an oversight:
adding a decrement and restore there would be correct but pointless work.

## The two constraints are encoded in the loop bounds

Neither rule needs an `if`:

- **No leading zeros** — the hundreds loop starts at `1`.
- **Even** — the units loop steps by `2` from `0`.

The result is that every iteration of the innermost body corresponds to a genuine
candidate number, so the counter increments without any further filtering.

# Worked examples

## `digits = [0,2,2]` → `2`

Frequency table: `{0: 1, 2: 2}`.

| hundreds | tens | units | number | why it is available |
| --- | --- | --- | --- | --- |
| `2` | `0` | `2` | `202` | two copies of `2`, so one remains after borrowing |
| `2` | `2` | `0` | `220` | both copies of `2` borrowed, `0` still free |

`i = 0` is never tried (the loop starts at `1`), and no other hundreds digit has a
non-zero count. The answer is `2`.

## `digits = [6,6,6]` → `1`

Only `666` is formable, and it needs all three copies: `i = 6` borrows one,
`j = 6` borrows the second, and `k = 6` finds the third still available. Had the
input been `[6,6]`-worth of copies, the innermost test would have failed.

## `digits = [1,3,5]` → `0`

Every digit is odd, so `freq[k]` is zero for all five even values of `k` and the
innermost `if` never fires. The outer loops still run — the work is done, it just
never counts anything.

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `digits` — one pass to
  build the frequency table, then a fixed enumeration.
- Space complexity: $$O(1)$$ — a ten-element table regardless of input.

The triple loop is constant, not cubic: it executes at most
$$9 \times 10 \times 5 = 450$$ times whatever the input. Since $$n \le 10$$, the
tally is the only part that scales at all. The answer is bounded by the same `450`
— the largest value observed across the test corpus was `328`, from a permutation
of all ten digits.

A position-based permutation approach would instead be $$O(n^3)$$ with a hash set
for deduplication; enumerating by value makes the set unnecessary.

# Code

## Go

```go
func totalNumbers(digits []int) int {
    freq := [10]int{}
    for _, digit := range digits {
        freq[digit]++
    }
    ans := 0
    for i := 1; i <= 9; i++ {
        if freq[i] == 0 {
            continue
        }
        freq[i]--
        for j := range 10 {
            if freq[j] == 0 {
                continue
            }
            freq[j]--
            for k := 0; k < 10; k += 2 {
                if freq[k] > 0 {
                    ans++
                }
            }
            freq[j]++
        }
        freq[i]++
    }
    return ans
}
```

`for j := range 10` is range-over-integer, added in **Go 1.22**; on an older
toolchain write `for j := 0; j < 10; j++`. Note `freq` is `[10]int`, a value-type
array rather than a slice, so it lives on the stack with no allocation.

## Rust

```rust
impl Solution {
    pub fn total_numbers(digits: Vec<i32>) -> i32 {
        let mut freq = [0; 10];
        for digit in digits {
            freq[digit as usize] += 1;
        }
        let mut ans = 0;
        for i in 1..10 {
            if freq[i] == 0 {
                continue;
            }
            freq[i] -= 1;
            for j in 0..10 {
                if freq[j] == 0 {
                    continue;
                }
                freq[j] -= 1;
                for k in (0..10).step_by(2) {
                    if freq[k] > 0 {
                        ans += 1;
                    }
                }
                freq[j] += 1;
            }
            freq[i] += 1;
        }
        ans 
    }
}
```

`for digit in digits` consumes the `Vec` by value, so no `iter()` or dereference
is needed. The loop variables `i`, `j` and `k` are inferred as `usize` from their
use as array indices, which is why only the input digits need the explicit
`as usize` cast.

## Python

```python
class Solution:
    def totalNumbers(self, digits: List[int]) -> int:
        freq = [0] * 10
        for digit in digits:
            freq[digit] += 1
        ans = 0
        for i in range(1, 10):
            if freq[i] == 0:
                continue
            freq[i] -= 1
            for j in range(10):
                if freq[j] == 0:
                    continue
                freq[j] -= 1
                for k in range(0, 10, 2):
                    if freq[k] > 0:
                        ans += 1
                freq[j] += 1
            freq[i] += 1

        return ans
```

`range(0, 10, 2)` is the direct spelling of the units constraint, matching Rust's
`(0..10).step_by(2)` and Go's `k += 2`.

# Test cases

| `digits` | answer | what it exercises |
| --- | --- | --- |
| `[1,2,3,4]` | `12` | Example 1 — all digits distinct |
| `[0,2,2]` | `2` | Example 2 — repeated digit, traced above |
| `[6,6,6]` | `1` | Example 3 — all three copies needed |
| `[1,3,5]` | `0` | Example 4 — no even digit at all |
| `[0,0,0]` | `0` | only zeros, so every candidate has a leading zero |
| `[0,1,0]` | `1` | just `100`; the two zeros fill tens and units |
| `[2]*10` | `1` | ten copies of one digit still gives one number |

All three implementations were checked against a brute force that forms every
3-digit arrangement of array *positions*, discards leading zeros and odd endings,
and counts the distinct results in a set. The corpus was **6944** cases: the four
examples, every multiset of size 3 and size 4 over `0..9` (exhaustive), 6000
random inputs at every allowed length, and adversarial cases such as all-zeros and
ten copies of a single digit. Go, Rust and Python agreed with the reference on
every case.
