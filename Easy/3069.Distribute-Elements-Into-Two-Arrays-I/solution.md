# Intuition

The problem is a direct simulation: seed `arr1` with `nums[1]` and `arr2` with
`nums[2]`, then for every later element compare the **last** element of each array
and append to whichever currently has the larger tail. The final answer is
`arr1 ++ arr2`.

The naive way keeps two growing lists and concatenates them at the end. The elegant
trick used here avoids the second list and the final concatenation entirely by
building both halves inside **one** output array of size `n`:

- `arr1` grows **left-to-right** from index `0`.
- `arr2` grows **right-to-left** from index `n - 1`.

Because the two halves grow toward each other, they never collide (there are
exactly `n` elements total), and when the loop ends they meet in the middle — so
`arr1` already sits in the front and `arr2` sits in the back. No concatenation
step is needed; the array *is* the concatenation.

The one subtlety: since `arr2` is filled from the back, it ends up stored in
**reverse** order. We simply reverse that tail segment once at the end to restore
the true append order.

# Approach: Two Pointers Into a Single Output Array

Let `ans` be the size-`n` result. Use two write cursors:

- `idx` — the index of the **last** element written to `arr1` (front region).
- `idx2` — the index of the **last** element written to `arr2` (back region).

**Initialization** (the two seed operations):

- `ans[0] = nums[0]` → `arr1 = [nums[1]]`, cursor `idx = 0`.
- `ans[n-1] = nums[1]` → `arr2 = [nums[2]]`, cursor `idx2 = n-1`.

(The code is 0-indexed, so `nums[0]`/`nums[1]` here are the problem's
`nums[1]`/`nums[2]`.)

**Main loop** over the remaining elements `nums[2..]`:

At any moment the last element of `arr1` is `ans[idx]`, and the last element of
`arr2` is `ans[idx2]` — this is exactly why the trick works. Even though `arr2` is
laid out reversed, its *most recently appended* value is the one nearest the middle,
which is precisely `ans[idx2]`. So the comparison rule maps cleanly:

- If `ans[idx] > ans[idx2]` (arr1's tail is larger), advance the front cursor:
  `idx += 1; ans[idx] = number`.
- Otherwise, advance the back cursor: `idx2 -= 1; ans[idx2] = number`.

**Finalize:** the back region `ans[idx2..n]` holds `arr2` in reverse order, so
reverse that slice in place. Now `ans` reads as `arr1` followed by `arr2` in the
correct order.

## Why the halves never overlap

Each of the `n` elements advances exactly one cursor by one step: `idx` starts at
`0` and only increases, `idx2` starts at `n-1` and only decreases. After all `n`
writes, `idx + (n-1 - idx2)` positions are used from the front and back plus the two
seeds — they tile the whole array with no gap and no overlap, so `idx2 = idx + 1`
when the loop finishes.

## Worked example

`nums = [5,4,3,8]`, `n = 4`, `ans = [_,_,_,_]`.

- Seeds: `ans[0] = 5`, `ans[3] = 4` → `ans = [5,_,_,4]`, `idx=0`, `idx2=3`.
- `number = 3`: `ans[idx]=5 > ans[idx2]=4` → `idx=1`, `ans[1]=3` →
  `ans = [5,3,_,4]`.
- `number = 8`: `ans[idx]=3 > ans[idx2]=4`? No → `idx2=2`, `ans[2]=8` →
  `ans = [5,3,8,4]`.
- Reverse `ans[2..4]` = `[8,4]` → `[4,8]` → `ans = [5,3,4,8]`. ✓

Here `arr1 = [5,3]` (front) and `arr2 = [4,8]` (back, after the reversal).

# Complexity

- Time complexity: $$O(n)$$, where `n` is the length of `nums` — a single pass to
  place every element, plus one reversal of a sub-array (also $$O(n)$$).
- Space complexity: $$O(1)$$ extra (ignoring the required `n`-sized output) — no
  auxiliary lists beyond the result and two cursors.

# Code

## Go

```go
import "slices"

func resultArray(nums []int) []int {
    n := len(nums)
    ans := make([]int, n)
    ans[0], ans[n-1] = nums[0], nums[1]
    idx, idx2 := 0, n-1
    for i := 2; i < n; i++ {
        if ans[idx] > ans[idx2] {
            idx++
            ans[idx] = nums[i]
        } else {
            idx2--
            ans[idx2] = nums[i]
        }
    }
    slices.Reverse(ans[idx2:])
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn result_array(nums: Vec<i32>) -> Vec<i32> {
        let n = nums.len();
        let mut ans = vec![0; n];
        let (mut idx, mut rev_idx2) = (0, n - 1);
        ans[0] = nums[0];
        ans[n-1] = nums[1];
        for number in nums.into_iter().skip(2) {
            if ans[idx] > ans[rev_idx2] {
                idx += 1;
                ans[idx] = number;
            } else {
                rev_idx2 -= 1;
                ans[rev_idx2] = number;
            }
        }
        ans[rev_idx2..n].reverse();
        ans
    }
}
```
