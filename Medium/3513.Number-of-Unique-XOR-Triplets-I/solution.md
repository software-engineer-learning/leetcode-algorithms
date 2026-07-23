# Intuition

Because `nums` is a permutation of `[1, n]`, the set of attainable XOR values of
three (not necessarily distinct) elements depends only on `n`, not on order.

For `n <= 2` the answer is just `n`. For larger `n`, every integer in
`[0, 2^{ceil(log2(n+1))} - 1]` is achievable as some triplet XOR, so the count
is the next power of two at or above `n + 1` when that is a clean bit-length
bound — equivalently `1 << bit_length(n)`.

# Approach: Bit Length Formula

1. Let `n = nums.length`.
2. If `n <= 2`, return `n`.
3. Otherwise return `1 << bits.Len(n)` (Go) / `1 << (BITS - leading_zeros(n))`
   (Rust) — the size of the complete bit space spanned by values up to `n`.

# Complexity

- Time complexity: $$O(1)$$ — only the array length is used.
- Space complexity: $$O(1)$$.

# Code

## Go

```go
import "math/bits"

func uniqueXorTriplets(nums []int) int {
    n := len(nums)
    if n <= 2 {
        return n
    }
    log := bits.Len(uint(n))
    return 1 << log
}
```

## Rust

```rust
impl Solution {
    pub fn unique_xor_triplets(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        match n {
            1 => 1,
            2 => 2,
            _ => {
                let bit_count = (u32::BITS - n.leading_zeros()) as i32;
                1 << bit_count
            }
        }
    }
}
```
