# Intuition

The answer set is tiny and fixed: every 3-digit even number without a leading zero
lies in `100, 102, 104, ..., 998` — exactly 450 candidates, regardless of how long
the input is. Rather than permuting the input and deduplicating, **enumerate the
candidates and ask which ones the input can build.**

That inversion pays three times over:

- **Uniqueness is free.** Each candidate is visited once, so no set is needed.
- **Sortedness is free.** Counting upward emits the answers in ascending order,
  which is exactly what the problem asks for — no `sort` call anywhere.
- **Leading zeros and evenness are free.** Starting at `100` and stepping by `2`
  encodes both rules in the loop header.

All that remains is a feasibility test against a digit-frequency table.

# Approach: Enumerate Candidates, Test Against a Frequency Table

1. Tally the input into `freq[0..9]`.
2. For each candidate `i` from `100` to `998` stepping by `2`, split it into
   `d1 = i / 100`, `d2 = (i / 10) % 10`, `d3 = i % 10`.
3. Decrement `freq[d1]`, `freq[d2]`, `freq[d3]`.
4. If all three are still `>= 0`, the input holds enough copies — keep `i`.
5. Restore the three counts before the next candidate.

## Why decrement-then-check handles repeated digits correctly

The three decrements happen **before** any test, which is what makes repeats work
without a special case. When a candidate reuses a digit, the decrements stack on
the same slot:

- `888` drives `freq[8]` down by `3`, so it survives only with three copies of `8`.
- `828` drives `freq[8]` down by `2` and `freq[2]` by `1`.

Checking after each individual decrement would accept `888` whenever a single `8`
existed. Verified: with `digits = [8,8,2]`, `888` is rejected while `828` and `882`
are accepted; with `digits = [8,8,8]` the verdicts invert.

## The counters must be signed

`freq` genuinely goes negative during a rejected test — for `digits = [1,1,1]` the
candidate `222` drives `freq[2]` to `-3` before the check runs. Rust's
`let mut freq = [0; 10];` infers `i32` from the literal, which is what makes this
safe; an unsigned element type would underflow and panic in a debug build rather
than returning `false`. Confirmed by running the whole corpus through an
unoptimised build, where such a panic would abort.

Go's `make([]int, 10)` is signed by definition, so the same concern does not
arise there.

## Two ways to restore the table

The two implementations differ only in how they undo step 3, and it is a genuine
trade-off:

- **Rust** mutates `freq` in place and adds the three counts back — $$O(1)$$ work
  per candidate, no allocation.
- **Go** calls `slices.Clone(counts)` inside `isValid`, testing a throwaway copy
  and leaving the original untouched — a 10-element allocation per candidate, so
  450 of them per call.

The Go form is easier to reason about because `isValid` is pure, and at ten
elements the copy is trivial. The Rust form is what you would reach for if the
alphabet were large.

# Worked example

`digits = [2,2,8,8,2]` → `[222,228,282,288,822,828,882]`. Frequency table:
`{2: 3, 8: 2}`.

| candidate | digits needed | available? | kept? |
| --- | --- | --- | --- |
| `222` | three `2` | `freq[2] = 3` | **yes** |
| `228` | two `2`, one `8` | both present | **yes** |
| `282` | two `2`, one `8` | both present | **yes** |
| `288` | one `2`, two `8` | both present | **yes** |
| `822` | one `8`, two `2` | both present | **yes** |
| `828` | two `8`, one `2` | both present | **yes** |
| `882` | two `8`, one `2` | both present | **yes** |
| `888` | three `8` | only two `8` | no |

Everything else is rejected for containing a digit the input lacks. `888` is the
instructive case: it is the only arrangement of the available digit *values* that
fails, and it fails purely on multiplicity.

For `digits = [3,7,5]` every candidate needs an even units digit, and none of
`3, 7, 5` is even, so the result is empty. For `digits = [2,1,3,0]` the ten
outputs come back already ascending, since `102 < 120 < 130 < ...` is the order
the loop visits them in.

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `digits` — one pass to
  build the table, then a fixed sweep of 450 candidates doing constant work each.
- Space complexity: $$O(1)$$ auxiliary for Rust. Go allocates a 10-element clone
  per candidate, which is still $$O(1)$$ at any instant but performs 450 small
  allocations per call. The output array is not counted; it holds at most 450
  entries.

Permuting the input positions instead would be $$O(n^3)$$ — up to $$10^6$$
triples at the constraint ceiling of `n = 100` — plus a hash set to deduplicate
and a final sort. Enumerating candidates is independent of `n` after the tally.

This is the same enumerate-by-value idea as
[3483. Unique 3-Digit Even Numbers](../3483.Unique-3-Digit-Even-Numbers/solution.md),
which asks only for the count; there the candidates are built digit by digit in
nested loops, here the integer is split apart instead.

# Code

## Go

```go
import "slices"

func isValid(num int, counts []int) bool {
    digit1, digit2, digit3 := num / 100, (num / 10) % 10, num % 10
    freq := slices.Clone(counts)
    freq[digit1]--
    freq[digit2]--
    freq[digit3]--
    return freq[digit1] >= 0 && freq[digit2] >= 0 && freq[digit3] >= 0
}
func findEvenNumbers(digits []int) []int {
    countDigits := make([]int, 10)
    for _, digit := range digits {
        countDigits[digit]++
    }
    ans := make([]int, 0)
    for i := 100; i < 1_000; i += 2 {
        if isValid(i, countDigits) {
            ans = append(ans, i)
        }
    }
    return ans
}
```

`slices.Clone` needs **Go 1.21**. Note `ans := make([]int, 0)` rather than
`var ans []int`: the former returns an empty non-nil slice, which marshals as `[]`
instead of `null` — the right shape for Example 3's empty answer.

## Rust

```rust
impl Solution {
    pub fn find_even_numbers(digits: Vec<i32>) -> Vec<i32> {
        let mut freq = [0; 10];
        for digit in digits {
            freq[digit as usize] += 1;
        }
        let mut ans = vec![];
        for i in (100..1000).step_by(2) {
            let (d1, d2, d3) = (i / 100, (i / 10) % 10, i % 10);
            freq[d1] -= 1;
            freq[d2] -= 1;
            freq[d3] -= 1;
            if freq[d1] >= 0 && freq[d2] >= 0 && freq[d3] >= 0 {
                ans.push(i as i32);
            }
            freq[d1] += 1;
            freq[d2] += 1;
            freq[d3] += 1;
        }
        ans
    }
}
```

`i` is inferred as `usize` because `d1`, `d2` and `d3` index the array, which is
why the push needs `i as i32` to match the declared return type.

# Test cases

| `digits` | answer | what it exercises |
| --- | --- | --- |
| `[2,1,3,0]` | `[102,120,130,132,210,230,302,310,312,320]` | Example 1 — zero usable as a non-leading digit |
| `[2,2,8,8,2]` | `[222,228,282,288,822,828,882]` | Example 2 — traced above; `888` fails on multiplicity |
| `[3,7,5]` | `[]` | Example 3 — no even digit at all |
| `[0,0,0]` | `[]` | only zeros, so every candidate leads with `0` |
| `[0,1,0]` | `[100]` | the two zeros fill tens and units |
| `[8] * 100` | `[888]` | one distinct answer from a long input |
| `[0..9] * 10` | 450 entries | every candidate formable — the ceiling |

Both implementations were checked against a brute force that permutes array
*positions*, discards leading zeros and odd endings, and returns the distinct
results sorted. The corpus was **5946** cases: the three examples, every multiset
of size 3 and size 4 over `0..9` (exhaustive), 5000 random inputs at every allowed
length up to 100, and adversarial inputs such as all-zeros, 100 copies of one
digit, and ten copies of every digit. Go and Rust matched the reference on every
case, every output came back already sorted with no sort call, and the Rust build
was unoptimised so an unsigned underflow would have panicked — it did not.
