# Intuition

Deletions only ever happen at the two ends, so whatever survives is always a
contiguous middle stretch of the original array. That means the *values* in `nums`
are irrelevant beyond one fact: **where the minimum and the maximum sit**. Once
those two positions are known, the array might as well be a row of `n` boxes with
two of them marked.

Removing both marked boxes from the ends can only be done in three shapes, and the
answer is simply the cheapest of the three.

# Approach: Three Cases on Two Positions

Find the index of the minimum and the index of the maximum, then sort them into

- `left` — the earlier of the two positions,
- `right` — the later one.

Every valid deletion plan must reach *both*, and there are only three ways to do
that.

| plan | what it deletes | cost |
| --- | --- | --- |
| **From the front only** | everything up to and including `right` | `right + 1` |
| **From the back only** | everything from `left` to the end | `n - left` |
| **From both ends** | the prefix through `left`, and the suffix from `right` | `(left + 1) + (n - right)` |

The answer is the minimum of the three.

## Why those three exhaust the possibilities

Deleting `f` elements from the front and `b` from the back removes exactly the
index ranges `[0, f)` and `[n - b, n)`. To remove both marked positions, each of
`left` and `right` must fall into one of those ranges. Since `left ≤ right`:

- If both fall in the **front** range, the front must extend past `right`, giving
  `f ≥ right + 1`. Cheapest is the first row.
- If both fall in the **back** range, the back must extend before `left`, giving
  `b ≥ n - left`. Cheapest is the second row.
- Otherwise they are **split**: the only workable split is `left` from the front
  and `right` from the back, because `left ≤ right` — taking `right` from the
  front while `left` came from the back would mean the two ranges overlap and the
  whole array is deleted anyway. That gives `f ≥ left + 1` and `b ≥ n - right`,
  the third row.

No other assignment exists, so the minimum over these three is the true optimum.

## Why the minimum and maximum are found without sorting

Both indices come from one linear scan. The Go and Rust versions carry
`maxIndex` and `minIndex` and update each when a strictly better value appears;
the Python version calls `nums.index(min(nums))` and `nums.index(max(nums))`,
which is three passes but still linear.

Because the problem guarantees **distinct** integers, `nums.index(...)` is
unambiguous — there is exactly one position holding the minimum, and one holding
the maximum. With duplicates allowed, `index` would return the first occurrence,
which is in fact still what you want here, but the guarantee makes it moot.

## The `n <= 2` early return is redundant

Go and Rust return `n` immediately when `n <= 2`; Python has no such guard. Both
are correct, because the general formula already produces the right answer at
those sizes:

- **`n = 1`** — one element is both the minimum and the maximum, so
  `left = right = 0`. The three costs are `1`, `1`, and `2`, and the minimum is
  `1`.
- **`n = 2`** — the two marks land on indices `0` and `1`, so `left = 0`,
  `right = 1`. The costs are `2`, `2`, and `2`, and the answer is `2`.

Removing the guard from the Rust version and re-running the full test corpus
produced identical answers on every case, confirming it is a shortcut rather than
a correctness fix.

## No underflow in the unsigned arithmetic

Rust computes with `usize`, where subtracting past zero panics in debug builds and
wraps in release. Both subtractions are safe:

- `n - left` — since `left ≤ n - 1`, the result is at least `1`.
- `left + 1 + n - right` — evaluated left to right, so the running total reaches
  `left + 1 + n` before anything is subtracted, and that is `≥ right` because
  `right ≤ n - 1`.

The whole corpus was run through a debug build, where an underflow would abort,
and none occurred.

# Worked examples

## `nums = [2,10,7,5,4,1,8,6]` → `5`

Minimum `1` sits at index `5`; maximum `10` sits at index `1`. So `left = 1` and
`right = 5`, with `n = 8`.

| plan | cost | detail |
| --- | --- | --- |
| front only | `5 + 1 = 6` | delete indices `0..5` |
| back only | `8 - 1 = 7` | delete indices `1..7` |
| both ends | `2 + 3 = 5` | front through index `1`, back from index `5` |

The answer is `5`, matching the statement's "2 from the front and 3 from the
back".

## `nums = [0,-4,19,1,8,-2,-3,5]` → `3`

Minimum `-4` at index `1`, maximum `19` at index `2`, so `left = 1`, `right = 2`.

| plan | cost |
| --- | --- |
| front only | `2 + 1 = 3` |
| back only | `8 - 1 = 7` |
| both ends | `2 + 6 = 8` |

Here the two marks sit next to each other near the front, so sweeping in from one
side beats splitting the work — the opposite of the previous example.

## `nums = [1,2,3,4,5]` → `2`

Minimum at index `0`, maximum at index `4` — the two extremes are already at the
two ends, so `left = 0` and `right = 4`.

| plan | cost |
| --- | --- |
| front only | `5` |
| back only | `5` |
| both ends | `1 + 1 = 2` |

This is the case where the split plan wins by the widest margin: one deletion from
each end.

## `nums = [101]` → `1`

A single element is both the minimum and the maximum, so `left = right = 0` and
the costs are `1`, `1`, `2`. One deletion suffices.

# Complexity

- Time complexity: $$O(n)$$ — one pass to locate both extremes, then constant
  work. Python makes three passes (`min`, `max`, and two `index` scans), which is
  still $$O(n)$$.
- Space complexity: $$O(1)$$ — two indices and three candidate costs.

Sorting to find the extremes would cost $$O(n \log n)$$ and also destroy the
positional information the whole approach depends on.

# Code

## Go

```go
func minimumDeletions(nums []int) int {
    n := len(nums)
    if n <= 2 {
        return n
    }
    maxIndex, minIndex := 0, 0
    for i, num := range nums {
        if nums[maxIndex] < num {
            maxIndex = i
        }
        if nums[minIndex] > num {
            minIndex = i
        }
    }
    left, right := min(maxIndex, minIndex), max(maxIndex, minIndex)
    
    return min(right + 1, n - left, left + 1 + n - right)
}
```

The builtin `min` and `max` need **Go 1.21**, where they became generic over
ordered types. `min` is variadic, so the three candidate costs go in one call.

## Rust

```rust
impl Solution {
    pub fn minimum_deletions(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        if n <= 2 {
            return n as i32;
        }
        let (mut max_index, mut min_index) = (0, 0);
        for i in 0..n {
            if nums[max_index] < nums[i] {
                max_index = i;
            }
            if nums[min_index] > nums[i] {
                min_index = i;
            }
        }
        let (left, right) = ((max_index).min(min_index), max_index.max(min_index));
        (right + 1).min(n - left).min(left + 1 + n - right) as i32
    }
}
```

`Ord::min` chains rather than taking a list, so the three-way minimum is written
as two calls. The single `as i32` at the end converts the final `usize`, keeping
all the intermediate arithmetic in the unsigned domain analysed above.

## Python

```python
class Solution:
    def minimumDeletions(self, nums: List[int]) -> int:
        min_index = nums.index(min(nums))
        max_index = nums.index(max(nums))
        left, right = min(max_index, min_index), max(max_index, min_index)
        n = len(nums)
        return min(right + 1, n - left, left + 1 + n - right)
```

Note that `min` is doing two different jobs here: `min(nums)` finds the smallest
*value*, while `min(right + 1, ...)` picks the cheapest *plan*. Python's `min` is
variadic like Go's, so the final line mirrors the Go one exactly.

# Test cases

| `nums` | `left`, `right` | costs (front, back, both) | answer |
| --- | --- | --- | --- |
| `[2,10,7,5,4,1,8,6]` | `1`, `5` | `6`, `7`, `5` | `5` |
| `[0,-4,19,1,8,-2,-3,5]` | `1`, `2` | `3`, `7`, `8` | `3` |
| `[101]` | `0`, `0` | `1`, `1`, `2` | `1` |
| `[1,2,3,4,5]` | `0`, `4` | `5`, `5`, `2` | `2` |
| `[5,9]` | `0`, `1` | `2`, `2`, `2` | `2` |
| `[9,5]` | `0`, `1` | `2`, `2`, `2` | `2` |

All three implementations were checked against a brute force that tries every
`(front, back)` deletion split and keeps the cheapest one that removes both
extremes. The corpus was **8916** cases: the three examples, every permutation of
distinct values for `n` from 1 to 7, and 3000 random arrays of distinct integers.
Go, Rust and Python agreed on every case, with zero mismatches against the
reference.
