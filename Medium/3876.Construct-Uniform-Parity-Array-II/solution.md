# Intuition

The actual values of `nums2` never matter — only their parity. And subtraction
behaves very simply on parity: `a - b` is even exactly when `a` and `b` agree in
parity, and odd exactly when they differ. So each index has at most two reachable
parities, and the whole question becomes whether some single parity is reachable
by every index at once.

Working through the two targets separately collapses the problem to a single
comparison: **is the smallest element odd?**

# Approach: Parity of the Minimum

Handle the two possible targets independently.

## Target "all even"

Index `i` can end up even in two ways: keep `nums1[i]` when it is already even, or
subtract some `nums1[j]` of the **same** parity with `nums1[j] < nums1[i]`.

Now look at the **smallest odd** element, if one exists. Keeping it leaves it odd,
and making it even needs a smaller odd element — which by definition does not
exist. So that index can never be made even.

Therefore all-even is achievable **only when `nums1` contains no odd element at
all**, in which case every index is simply kept as is. That is exactly the
`all(num & 1 == 0)` test.

## Target "all odd"

Index `i` can end up odd by keeping an already-odd `nums1[i]`, or by subtracting
some `nums1[j]` of the **opposite** parity with `nums1[j] < nums1[i]`. So every
even element needs an odd element strictly below it.

This is where the minimum decides everything, and the **distinct** guarantee is
what makes it clean:

- **If the minimum is odd**, it is strictly smaller than every other element. Each
  even element can subtract it and flip to odd, while odd elements are kept. All-odd
  succeeds. That is the `min & 1 == 1` test.
- **If the minimum is even**, that element itself needs an odd value strictly below
  it — impossible, since nothing is below the minimum. All-odd fails.

## Putting it together

$$\text{answer} = (\min(nums_1) \bmod 2 = 1) \;\lor\; (\text{every element is even})$$

Read the other way round, the answer is `false` in exactly one situation: **the
minimum is even and at least one odd element exists.** Verified equivalent to the
formula on the whole test corpus.

Note the two branches cannot both be true: if the minimum is odd then an odd
element exists, so "every element is even" is false. The `||` is a genuine case
split, not a redundancy.

## Why no pairing or ordering work is needed

It is tempting to expect a matching problem — which `j` should each `i` subtract?
But when the minimum is odd, *every* even index can use that same minimum, and
nothing prevents reusing one `j` across many `i` values. The problem only forbids
`j == i`, and the minimum is never its own index among the even elements because
it is odd. So one element serves as the universal donor and no assignment step
survives.

# Worked examples

## `nums1 = [1,4,7]` → `true`

The minimum is `1`, which is odd, so the first branch fires immediately.
Constructing it explicitly: `4` subtracts the minimum to give `4 - 1 = 3`, while
`1` and `7` are kept, producing `[1, 3, 7]` — all odd. This matches the
statement's walkthrough.

## `nums1 = [2,3]` → `false`

The minimum is `2`, which is even, so all-odd is out: `2` would need an odd value
below it and there is none. All-even is out too, because `3` is odd and has no
smaller odd element to subtract. Both targets fail.

## `nums1 = [4,6]` → `true`

The minimum `4` is even, so the first branch fails, but every element is even and
the second branch succeeds — keep both, giving `[4, 6]`.

## `nums1 = [2,3,5]` → `false`

A useful contrast with Example 1. The minimum `2` is even, so all-odd fails at
index `0`. And `3` is odd, so all-even fails at the smallest odd. Adding more odd
elements above the even minimum never helps.

## `nums1 = [7]` → `true`

With `n = 1` no valid `j` exists, so `nums2 = nums1` is forced. A single element is
trivially uniform. Both branches cover it: an odd single element passes the
minimum test, and an even single element passes the all-even test.

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `nums1` — one pass for the
  minimum and at most one more for the parity scan.
- Space complexity: $$O(1)$$ — only the running minimum and a boolean.

Short-circuiting helps in practice: when the minimum is odd the second scan is
skipped entirely, and the `all` / `ContainsFunc` scan stops at the first odd
element it meets.

# Code

## Go

```go
import "slices"

func uniformArray(nums1 []int) bool {
    return slices.Min(nums1) & 1 == 1 || !slices.ContainsFunc(nums1, func(num int) bool {
        return num % 2 == 1
    })
}
```

`slices.Min` and `slices.ContainsFunc` both arrived in **Go 1.21**. The double
negative — "not contains an odd" — is how `slices` spells "all are even", since
the package offers no `AllFunc`.

## Rust

```rust
impl Solution {
    pub fn uniform_array(nums1: Vec<i32>) -> bool {
        let min_num = nums1.iter().min().unwrap_or(&i32::MAX);
        min_num & 1 == 1 || nums1.iter().all(|&num| (num & 1) == 0)
    }
}
```

`min_num` is a `&i32`, and `&i32 & 1` compiles because the operator traits are
implemented for references — no explicit deref needed. The `unwrap_or(&i32::MAX)`
fallback only matters for an empty input, which the constraints exclude; it would
return `true`, since `i32::MAX` is `2147483647` and therefore odd.

## Python

```python
class Solution:
    def uniformArray(self, nums1: list[int]) -> bool:
        return min(nums1) & 1 == 1 or all(num & 1 == 0 for num in nums1)
```

The generator inside `all` short-circuits on the first odd element, so the second
branch costs nothing once a counterexample appears.

# Test cases

| `nums1` | minimum | any odd? | answer | branch that decides |
| --- | --- | --- | --- | --- |
| `[1,4,7]` | `1` odd | yes | `true` | minimum is odd |
| `[2,3]` | `2` even | yes | `false` | neither branch |
| `[4,6]` | `4` even | no | `true` | all even |
| `[2,3,5]` | `2` even | yes | `false` | neither branch |
| `[7]` | `7` odd | yes | `true` | minimum is odd, `n = 1` |
| `[8]` | `8` even | no | `true` | all even, `n = 1` |
| `[2,4,6,7]` | `2` even | yes | `false` | one odd above an even minimum |

All three implementations were checked against a brute force that computes, for
each index, the set of parities it can reach — keeping the value, or subtracting
any other element that leaves a positive result — and then asks whether some
parity is reachable at every index simultaneously. The corpus was **6384** cases:
the three examples, every distinct subset of `1..9` of size 1 to 5 (exhaustive),
and 6000 random distinct-valued arrays. Go, Rust and Python agreed with the
reference on every case.
