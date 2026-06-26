# Intuition

`target` is the majority of a subarray iff it appears strictly more than half the
time. Replace every `target` with `+1` and every other value with `-1`. Then a
subarray has `target` as its majority element exactly when the sum of its `±1`
values is **strictly positive** (more `+1`s than `-1`s).

Using prefix sums $P_0, P_1, \dots, P_n$ (with $P_0 = 0$), the subarray
`(i, j]` is valid iff $P_j - P_i > 0$, i.e. $P_i < P_j$. So the answer is the
number of index pairs $i < j$ with $P_i < P_j$.

# Approach: Prefix Sum + Running Count of Smaller Prefixes

We sweep `j` from left to right and, for each `j`, add the number of earlier
prefixes (including the empty prefix $P_0$) that are strictly smaller than the
current prefix $P_j$.

Naively counting "how many earlier prefixes are smaller" looks like it needs a
Fenwick tree, but the prefix sum changes by exactly `±1` at each step, so we can
maintain that count incrementally in $O(1)$:

- Shift prefix values by `n` so they fit into an array of size `2n + 1`.
  `count` tracks the current prefix sum (shifted), starting at `n` (value `0`).
- `prefix[v]` = how many prefixes seen so far equal the value `v`.
  Seed `prefix[n] = 1` for the empty prefix $P_0 = 0$.
- `sum` = how many earlier prefixes are strictly smaller than the current one.

Transitions when the prefix value moves:

- `num == target` → value goes up by 1. Everything that equalled the old value
  is now strictly smaller, so `sum += prefix[count]`, then `count++`.
- `num != target` → value goes down by 1. After `count--`, everything that
  equals this new value is no longer strictly smaller, so `sum -= prefix[count]`.

After updating, record the current prefix with `prefix[count]++` and accumulate
`ans += sum`. Because `sum` already counts how many strictly-smaller prefixes
precede `j`, this directly sums the valid `(i, j]` subarrays ending at each `j`.

# Complexity

- Time complexity: $O(n)$ — one pass with $O(1)$ work per element.
- Space complexity: $O(n)$ — the `prefix` frequency array of size $2n + 1$.

# Code

## Go

```go
func countMajoritySubarrays(nums []int, target int) int64 {
    n := len(nums)
    prefix := make([]int, 2*n+1)
    prefix[n] = 1
    count := n
    ans, sum := 0, 0
    for _, num := range nums {
        if num == target {
            sum += prefix[count]
            count++
        } else {
            count--
            sum -= prefix[count]
        }
        prefix[count]++
        ans += sum
    }
    return int64(ans)
}
```

## Rust

```rust
impl Solution {
    pub fn count_majority_subarrays(nums: Vec<i32>, target: i32) -> i64 {
        let n = nums.len();
        let mut prefix = vec![0; 2 * n + 1];
        prefix[n] = 1;
        let mut count = n;
        let (mut ans, mut sum) = (0_i64, 0_i64);
        for num in nums.into_iter() {
            if num == target {
                sum += prefix[count] as i64;
                count += 1;
            } else {
                count -= 1;
                sum -= prefix[count] as i64;
            }
            prefix[count] += 1;
            ans += sum;
        }
        ans
    }
}
```
