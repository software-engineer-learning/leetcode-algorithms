# Intuition

The instability score at index `i` is built from two one-sided aggregates: the
maximum over the prefix `nums[0..i]` and the minimum over the suffix
`nums[i..n-1]`. Recomputing either from scratch at every index would be
$$O(n^2)$$, but both are trivially incremental:

- the **prefix maximum** grows left to right — `maxLeft = max(maxLeft, nums[i])`;
- the **suffix minimum** grows right to left — `minRight = min(minRight, nums[i])`.

They run in opposite directions, so one of them has to be computed and stored
before the other can sweep. That single observation is the whole solution: one
backward pass to fix the suffix minima, one forward pass that maintains the prefix
maximum and returns at the first index whose score fits within `k`.

## The scan cannot be replaced by a binary search

Both aggregates are non-decreasing in `i`, but their *difference* is not monotone,
so there is no threshold to bisect on. A counterexample found by exhaustive search:
`nums = [0,1,0,1]` gives scores `[0, 1, 1, 0]`, which rises and then falls. The
first stable index therefore has to be found by scanning from the left.

# Approach 1: Explicit Suffix-Minimum Array

1. Build `minRight` where `minRight[i] = min(nums[i..n-1])`, filling it from the
   right.
2. Sweep left to right maintaining `maxLeft`, and return the first `i` where
   `maxLeft - minRight[i] <= k`.
3. Return `-1` if the sweep finishes.

Returning on the first hit is what makes the answer the *smallest* stable index —
no comparison across candidates is needed.

Two initialisation details matter:

- `maxLeft` starts at `0`, which is safe only because $$nums[i] \ge 0$$ is
  guaranteed. With negative values allowed it would have to start at the first
  element or at negative infinity.
- The Python version pads `min_right` with a sentinel of `1_000_000_000 + 1`, one
  past the largest permitted value, so the `min` at index `n-1` resolves to
  `nums[n-1]` without a special case. The Rust version instead seeds
  `min_right[n-1]` directly and iterates `(0..n-1).rev()`, which is empty when
  `n == 1`.

# Approach 2: Pack the Suffix Minimum Into the Spare Bits

The second array exists only to carry one number per index. Since
$$nums[i] \le 10^9 < 2^{30}$$, every value occupies at most 30 bits, leaving the
upper half of a 64-bit word free. So the suffix minimum can ride along inside the
array itself:

- **write**: `nums[i] |= minRight << 32` — the value keeps the low 32 bits, the
  suffix minimum takes the high bits.
- **read back**: `nums[i] & 0xFFFFFFFF` recovers the original value, and
  `nums[i] >> 32` recovers the suffix minimum.

The `|=` never corrupts the value because the two fields cannot overlap: the value
is below $$2^{32}$$ and the minimum is shifted entirely above it. The worst packed
word is $$10^9 + (10^9 \cdot 2^{32})$$, about $$4.3 \times 10^{18}$$, still inside
a signed 64-bit integer.

Ordering matters in the backward pass. `minRight` is updated from `nums[i]`
*before* that slot is overwritten, so every read sees a pristine value:

```text
minRight = min(minRight, nums[i])   // nums[i] still clean
nums[i] |= minRight << 32           // only now is it packed
```

## What this actually costs in each language

The point of the trick is to drop the auxiliary array, and it does not succeed
everywhere:

| | extra space | why |
| --- | --- | --- |
| **Go** | $$O(1)$$ | `[]int` is 64-bit, so packing happens in the caller's slice |
| **Python** | $$O(1)$$ | ints are arbitrary precision, packed in place |
| **Rust** | $$O(n)$$ | the input is `Vec<i32>`, which cannot hold a packed 64-bit word, so a new `Vec<i64>` is allocated |

So the Rust version of approach 2 is **not** constant space — and at 8 bytes per
element it uses more memory than approach 1's `vec![0; n]` of `i32`. Reaching
genuine $$O(1)$$ in Rust would mean taking `nums` as `&mut [i64]`, which the
signature does not allow. It is included as a faithful port of the idea, not as a
space win.

## Two side effects worth knowing

- **The in-place versions mutate the caller's data.** Over the test corpus the Go
  and Python versions left the input modified in 5278 of 5707 cases (the rest are
  inputs where the suffix minimum is `0` throughout, making the `|=` a no-op).
  LeetCode does not care, but this would be surprising in library code.
- **The Go version assumes a 64-bit `int`.** On a 32-bit target it does not merely
  misbehave, it fails to build: compiling for `GOARCH=386` gives
  `0xFFFFFFFF (untyped int constant 4294967295) overflows int`. The Rust and Python
  versions are explicit about their widths and are unaffected.

# Worked example

`nums = [5,0,1,4]`, `k = 3`. The backward pass gives `minRight = [0, 0, 1, 4]`.

| `i` | prefix max | suffix min | score | verdict |
| --- | --- | --- | --- | --- |
| 0 | `5` | `0` | `5` | unstable |
| 1 | `5` | `0` | `5` | unstable |
| 2 | `5` | `1` | `4` | unstable |
| 3 | `5` | `4` | `1` | **stable → return 3** |

Note the prefix maximum is pinned at `5` by the very first element, so progress
comes entirely from the suffix minimum rising as the window shrinks.

For `nums = [3,2,1], k = 1` the suffix minimum is `1` everywhere and the prefix
maximum `3` everywhere, so every score is `2` and the sweep falls through to `-1`.
For `nums = [0], k = 0` the single index scores `0 - 0 = 0` and returns
immediately.

# Complexity

- Time complexity: $$O(n)$$ for both approaches — one backward pass and one
  forward pass, where `n` is the length of `nums`.
- Space complexity: $$O(n)$$ for approach 1. For approach 2, $$O(1)$$ in Go and
  Python, but $$O(n)$$ in Rust for the reason given above.

At $$n \le 100$$ none of this is load-bearing; the packing is an exercise in
squeezing out the auxiliary array rather than a necessary optimisation.

# Code

## Approach 1: suffix-minimum array

### Rust

```rust
impl Solution {
    pub fn first_stable_index(nums: Vec<i32>, k: i32) -> i32 {
        let n = nums.len();
        let mut min_right = vec![0; n];
        min_right[n-1] = nums[n-1];
        for i in (0..n-1).rev() {
            min_right[i] = min_right[i+1].min(nums[i]);
        }
        let mut max_left = 0;
        for (i, &num) in nums.iter().enumerate() {
            max_left = max_left.max(num);
            if max_left - min_right[i] <= k {
                return i as i32;
            }
        }
        -1
    }
}
```

### Python

```python
class Solution:
    def firstStableIndex(self, nums: list[int], k: int) -> int:
        n = len(nums)
        min_right = [1_000_000_000 + 1] * (n+1)
        for i in range(n-1, -1, -1):
           min_right[i] = min(min_right[i+1], nums[i])
        max_left = 0
        for i in range(0, n):
            max_left = max(max_left, nums[i])
            if max_left - min_right[i] <= k:
                return i
        return -1
```

The extra slot at `min_right[n]` holds the sentinel, so the loop body needs no
boundary check at `i == n-1`.

## Approach 2: suffix minimum packed into the high bits

### Go

```go
func firstStableIndex(nums []int, k int) int {
    n := len(nums)
    minRight := nums[n - 1]
    for i := n - 1; i >= 0; i-- {
        minRight = min(minRight, nums[i])
        nums[i] |= minRight << 32
    }
    maxLeft := 0
    for i := range n {
        maxLeft = max(maxLeft, nums[i] & 0xFFFFFFFF)
        if maxLeft - (nums[i] >> 32) <= k {
            return i
        }
    }
    return -1
}
```

`for i := range n` is range-over-integer, added in **Go 1.22**; on an older
toolchain write `for i := 0; i < n; i++`. The builtin `min` and `max` need
**Go 1.21**.

### Rust

```rust
impl Solution {
    pub fn first_stable_index(nums: Vec<i32>, k: i32) -> i32 {
        let n = nums.len();
        let mut nums: Vec<i64> = nums.iter().map(|&num| num as i64).collect();
        let mut min_right = i64::MAX;
        for i in (0..n).rev() {
            min_right = min_right.min(nums[i]);
            nums[i] |= min_right << 32;
        }
        let mut max_left = 0_i64;
        for (i, &num) in nums.iter().enumerate() {
            max_left = max_left.max(num & 0xFFFFFFFF);
            if max_left - (num >> 32) <= k as i64 {
                return i as i32;
            }
        }
        -1
    }
}
```

Seeding `min_right` with `i64::MAX` removes the need to special-case the last
index — the first `min` immediately replaces it with `nums[n-1]`.

### Python

```python
class Solution:
    def firstStableIndex(self, nums: list[int], k: int) -> int:
        n = len(nums)
        min_right = nums[n-1]
        for i in range(n-1, -1, -1):
           min_right = min(min_right, nums[i])
           nums[i] |= min_right << 32
        max_left = 0
        for i in range(0, n):
            max_left = max(max_left, nums[i] & 0xFFFFFFFF)
            if max_left - (nums[i] >> 32) <= k:
                return i
        return -1
```

Python integers are unbounded, so the shift can never overflow — the `32` here is
a convention shared with the other two versions rather than a hardware limit.

# Test cases

| `nums` | `k` | suffix min | answer | what it exercises |
| --- | --- | --- | --- | --- |
| `[5,0,1,4]` | `3` | `[0,0,1,4]` | `3` | Example 1 |
| `[3,2,1]` | `1` | `[1,1,1]` | `-1` | Example 2 — no stable index |
| `[0]` | `0` | `[0]` | `0` | Example 3 — single element |
| `[0,1,0,1]` | `0` | `[0,0,0,1]` | `0` | non-monotone score sequence |
| `[10^9] * 100` | `0` | all `10^9` | `0` | value ceiling, packing at full width |
| `[10^9, 0]` | `0` | `[0,0]` | `-1` | widest possible spread |

All five implementations were checked against a brute force that recomputes
`max(nums[0..i]) - min(nums[i..])` directly at every index. The corpus was **5707**
cases: the three examples, every array of length 1 to 4 over `0..3` paired with
every `k` in `0..4` (exhaustive), 4000 random arrays at full length and full value
range, and adversarial inputs pinned at `10^9`. All five agreed with the reference
on every case, and the Rust versions were built in debug mode, where an arithmetic
overflow would panic — none occurred.
