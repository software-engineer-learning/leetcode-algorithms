# Intuition

Every triplet XOR is of the form `(a XOR b) XOR c`. First collect all pairwise
XORs with `i <= j`, then XOR each of those with every array element. Values are
at most 1500, so pairwise XORs fit in `[0, 2047]` and a fixed boolean array
works.

# Approach: Pair XOR Set + Triple Extension

1. Mark all `nums[i] XOR nums[j]` for `0 <= i <= j < n` in `pairXorSet`.
2. For each marked pair XOR `x`, mark `x XOR num` for every `num` in `nums` in
   `tripleXorSet`.
3. Return the number of `true` entries in `tripleXorSet`.

# Complexity

- Time complexity: $$O(n^2 + n \cdot U)$$, where `n` is `nums.length` and
  `U = 2048` is the XOR value universe — pairwise enumeration plus one pass over
  marked pair XORs times `n`.
- Space complexity: $$O(U)$$ for the two boolean arrays.

# Code

## Go

```go
func uniqueXorTriplets(nums []int) int {
    n := len(nums)
    pairXorSet := [2048]bool{}
    for i := range n {
        for j := i; j < n; j++ {
            pairXorSet[nums[i]^nums[j]] = true
        }
    }
    tripleXorSet := [2048]bool{}
    for i := range 2048 {
        if !pairXorSet[i] {
            continue
        }
        for _, num := range nums {
            tripleXorSet[i^num] = true
        }
    }
    ans := 0
    for _, seen := range tripleXorSet {
        if seen {
            ans++
        }
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn unique_xor_triplets(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        let mut pair_xor_set = [false; 2048];
        for i in 0..n {
            for j in i..n {
                pair_xor_set[(nums[i] ^ nums[j]) as usize] = true;
            }
        }
        let mut triple_xor_set = [false; 2048];
        let mut ans = 0;
        for i in 0..2048 {
            if !pair_xor_set[i] {
                continue;
            }
            for &num in &nums {
                triple_xor_set[i ^ (num as usize)] = true;
            }
        }
        triple_xor_set.iter().filter(|&&num| num).count() as i32
    }
}
```
