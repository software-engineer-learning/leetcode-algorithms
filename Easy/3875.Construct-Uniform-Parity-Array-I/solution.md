# Intuition

Only parity matters, and the two moves have fixed parity effects: keeping
`nums1[i]` preserves its parity, while `nums1[i] - nums1[j]` flips it when
`nums1[j]` is odd and preserves it when `nums1[j]` is even. So the whole problem
is "can every element be pushed to one common parity?".

Aiming for **all odd** answers that immediately. Odd elements are already odd and
just stay put; an even element becomes odd by subtracting any odd element. A
single odd element in the array serves as the donor for *every* even element,
because the constraint on `j` is only `j != i` — nothing stops one index from
being reused. And if the array has no odd element at all, it is already all even.

Either way the construction succeeds, so the answer is always `true` and the input
never has to be inspected.

# Approach: Parity Argument (Always Possible)

Let `k` be the number of odd values in `nums1`.

- **`k = 0`.** Every element is even. Choose `nums2[i] = nums1[i]` for all `i`;
  `nums2` is all even.
- **`k >= 1`.** Fix any index `p` with `nums1[p]` odd. For each `i`:
  - if `nums1[i]` is odd, choose `nums2[i] = nums1[i]`;
  - if `nums1[i]` is even, then `i != p` (the two have different parity, so they
    cannot be the same index), and `nums2[i] = nums1[i] - nums1[p]` is
    `even - odd = odd`.

  Every entry is odd, so `nums2` is all odd.

Both cases produce a valid `nums2`, so `return true` unconditionally.

## Why aim for odd and not even

The symmetric attempt — force everything even — genuinely fails, which is worth
seeing because it is the only place the problem has any tension. An odd element
can only be made even by subtracting *another odd* element, so an array with
exactly one odd value has no way to neutralise it. Example 1, `nums1 = [2,3]`, is
exactly that shape: `3` cannot become even, but `2 - 3 = -1` makes the array all
odd instead.

The odd target has no such dependency: an even element needs an odd donor, and by
definition of the case `k >= 1` at least one exists, and it is never the element
being converted. Conversions never consume the donor, so one odd value is enough
no matter how many evens there are.

## What the constraints do not matter for

- **Distinctness.** The proof only needs "an odd index differs from an even
  index", which follows from parity alone. The answer stays `true` with
  duplicates.
- **Positivity.** Nothing depends on `1 <= nums1[i] <= 100`; the differences may
  be negative — `-1` in Example 1 is — and parity is unaffected by sign.
- **`n = 1`.** The branch taken for a single element only ever uses
  `nums2[0] = nums1[0]`, which is the sole legal move when no `j != i` exists. A
  one-element array is trivially uniform.

# Worked examples

## `nums1 = [2,3]` → `true`

`k = 1`, so take `p = 1` (the odd `3`).

| `i` | `nums1[i]` | parity | choice              | `nums2[i]` |
| --- | ---------- | ------ | ------------------- | ---------- |
| `0` | `2`        | even   | subtract `nums1[1]` | `-1`       |
| `1` | `3`        | odd    | keep                | `3`        |

`nums2 = [-1, 3]` — all odd. This matches the official explanation.

## `nums1 = [4,6]` → `true`

`k = 0`, so keep both: `nums2 = [4, 6]`, all even. No subtraction is needed.

## `nums1 = [5,8,12,20]` → `true`

`k = 1` again, with the lone odd `5` at index `0` acting as donor for all three
evens: `nums2 = [5, 3, 7, 15]`, all odd. One donor, reused three times.

# Complexity

- Time complexity: $$O(1)$$ — the answer is a constant, so no element of `nums1`
  is read. Even a version that counted odds first would be $$O(n)$$, where `n` is
  the length of `nums1`.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
func uniformArray(nums1 []int) bool {
    return true
}
```

## Rust

```rust
impl Solution {
    pub fn uniform_array(nums1: Vec<i32>) -> bool {
        true
    }
}
```

## Python

```python
class Solution:
    def uniformArray(self, nums1: list[int]) -> bool:
        return True
```

# Test cases

| `nums1`            | answer | why                                            |
| ------------------ | ------ | ---------------------------------------------- |
| `[2,3]`            | `true` | Example 1 — all odd via `2 - 3 = -1`           |
| `[4,6]`            | `true` | Example 2 — already all even, `k = 0`          |
| `[7]`              | `true` | single element, no `j` available               |
| `[2,4,6,8]`        | `true` | `k = 0`, keep everything                       |
| `[1,3,5,7]`        | `true` | already all odd, keep everything               |
| `[5,8,12,20]`      | `true` | one odd donor reused by every even             |
| `[1..100]`         | `true` | maximal input, both parities present           |

An exhaustive check confirmed the constant answer: for every distinct-valued array
drawn from `1..10` with length `1` to `6` (847 arrays), a brute force over all
$$\prod_i |\text{choices}_i|$$ assignments found a uniform-parity `nums2` in every
case.
