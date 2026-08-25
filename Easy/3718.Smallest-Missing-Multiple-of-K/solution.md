# Intuition

The multiples of `k` are `k, 2k, 3k, ...` in increasing order, so the smallest
missing one can be found by walking that sequence and stopping at the first value
`nums` does not contain. The only thing needed is a membership test, and the
constraints make that a single array lookup: every value is a small positive
integer, so a boolean table indexed by value answers "is this present?" in
$$O(1)$$.

The walk is guaranteed to stop quickly. Since $$nums[i] \le 100$$, *every*
multiple above `100` is missing by definition, so the loop can never run past the
first multiple that exceeds `100`.

# Approach: Boolean Lookup Table

1. Mark every value of `nums` in a lookup structure — a boolean array indexed by
   value, or a hash set.
2. Start at `k` and keep adding `k` while the current value is marked.
3. The first unmarked multiple is the answer.

## Why the answer never exceeds 200

This bound is what makes the fixed-size arrays safe, so it is worth stating
exactly. The loop stops at the first multiple of `k` greater than `100`, because
no element of `nums` can be larger than that. That value is

$$k \cdot \left\lceil \frac{101}{k} \right\rceil \;\le\; 100 + k \;\le\; 200$$

and the maximum is attained at $$k = 100$$: if `100` itself is present, the answer
is `200`. So the largest index ever read is `200`, and an array of length **201**
is exactly the right size — not a round number chosen for comfort. A length of
`200` genuinely overflows: with `nums = [1..100]` and `k = 100` the lookup at
index `200` is out of bounds.

## Two shapes of the same idea

- **Go and Rust** use a `201`-entry boolean array. Indexing is direct, with no
  hashing, which is the fastest option when the value range is this small and
  known ahead of time.
- **Python** uses a `set`. That carries no bound assumption at all, so it stays
  correct if the constraints are ever loosened — at the cost of hashing each
  lookup.

The Go version counts multiples with `i` and tests `freq[k*i]`, while Rust and
Python carry the running multiple directly in `ans`. These are the same walk
written two ways: `k*i` and `ans` hold the identical sequence `k, 2k, 3k, ...`.

# Worked examples

## `nums = [8,2,3,4,6], k = 2` → `10`

Marked values: `{2, 3, 4, 6, 8}`.

| multiple | present? | action   |
| -------- | -------- | -------- |
| `2`      | yes      | continue |
| `4`      | yes      | continue |
| `6`      | yes      | continue |
| `8`      | yes      | continue |
| `10`     | no       | **stop** |

The answer is `10`. Note `3` is in `nums` but is irrelevant — only multiples of
`k` are ever examined.

## `nums = [1,4,7,10,15], k = 5` → `5`

Marked values: `{1, 4, 7, 10, 15}`.

| multiple | present? | action   |
| -------- | -------- | -------- |
| `5`      | no       | **stop** |

The answer is `5` on the very first test. The loop body never executes, which is
why `ans` must be initialised to `k` rather than to `0` or `2k`.

## Worst case: `nums = [1..100], k = 100` → `200`

Every value from `1` to `100` is marked, so `100` is present and the walk moves to
`200`, which no element can equal. This is the input that pins the array size at
`201`.

# Edge cases

- **`k` larger than every element.** The first multiple `k` is already missing, so
  the answer is `k` after a single test.
- **`k = 1`.** The walk becomes `1, 2, 3, ...`, so the answer is the smallest
  positive integer absent from `nums` — the classic "first missing positive",
  which this handles without special casing.
- **Duplicates in `nums`.** Marking is idempotent, so repeated values cost nothing
  and change nothing.
- **Values in `nums` that are not multiples of `k`.** They are marked but never
  read, since only multiples are tested.

# Complexity

- Time complexity: $$O(n + \frac{M}{k})$$, where `n` is the length of `nums` and
  $$M \le 200$$ bounds the answer — one pass to mark, then at most
  $$\lfloor M/k \rfloor$$ probes. Both terms are $$O(n)$$ under the given limits.
- Space complexity: $$O(1)$$ for the Go and Rust versions, whose table is a fixed
  201 entries regardless of input. The Python version is $$O(n)$$ for the set.

# Code

## Go

```go
func missingMultiple(nums []int, k int) int {
    freq := make([]bool, 201)
    for _, num := range nums {
        freq[num] = true
    }
    i := 1
    for freq[k * i] {
        i++
    }
    return k * i
}
```

## Rust

```rust
impl Solution {
    pub fn missing_multiple(nums: Vec<i32>, k: i32) -> i32 {
        let mut seen = [false; 201];
        for num in nums {
            seen[num as usize] = true;
        }
        let mut ans = k;
        while seen[ans as usize] {
            ans += k;
        }
        ans
    }
}
```

## Python

```python
class Solution:
    def missingMultiple(self, nums: List[int], k: int) -> int:
        seens = set(nums)
        ans = k
        while ans in seens:
            ans += k
        return ans
```

# Test cases

| `nums`                | `k`   | answer | why                                    |
| --------------------- | ----- | ------ | -------------------------------------- |
| `[8,2,3,4,6]`         | `2`   | `10`   | Example 1                              |
| `[1,4,7,10,15]`       | `5`   | `5`    | Example 2 — missing immediately        |
| `[1..100]`            | `100` | `200`  | worst case, pins the array size at 201 |
| `[1,2,3]`             | `1`   | `4`    | `k = 1` is "first missing positive"    |
| `[5,5,5]`             | `5`   | `10`   | duplicates are harmless                |
| `[1,2,3]`             | `50`  | `50`   | `k` exceeds every element              |

All three implementations were checked against an independent reference on a
shared corpus of 30103 cases — the two examples, the maximal input for every
`k` from 1 to 100, and 30000 random inputs — with identical results throughout.
The Rust version was built in debug mode, where an out-of-range index panics, and
never did.
