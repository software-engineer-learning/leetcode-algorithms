# Intuition

A valid subset arranged as `[x, x^2, x^4, ..., x^k, ..., x^4, x^2, x]` is a
palindrome built by repeatedly squaring the base `x`. To keep walking the chain
`x -> x^2 -> x^4 -> ...` we need **at least two** copies of each intermediate
value (one for each symmetric side); the single peak value `x^k` only needs one
copy. So the problem reduces to: for each candidate base, follow the squaring
chain as long as the value appears at least twice, then add whatever the peak
value contributes.

The value `1` is special: `1^anything == 1`, so its chain never grows. The best
we can do with ones is take an **odd** count of them (a palindrome `[1, 1, ..., 1]`
of odd length).

# Approach: Frequency map + squaring chain

1. Count occurrences of every number in a frequency map.
2. Handle `1` separately: take the largest odd number `<= freq[1]`. This is
   `freq[1] - ((freq[1] & 1) ^ 1)` (subtract 1 when the count is even).
3. Remove `1` from the map. For every remaining base `num`, walk
   `temp = num, num^2, num^4, ...` while `freq[temp] > 1`, counting how many
   such levels we pass (`count`).
4. When the chain stops at `temp`, the peak contributes `min(freq[temp], 1)`
   extra elements — but the formula `(count + freq[temp]) << 1 - 1` already
   accounts for this: the two symmetric arms give `2 * count` elements, the peak
   adds one more if present, hence `2 * (count) + (peak present ? 1 : 0)`.
   Concretely the answer for a chain is `(count + min(freq[temp],1)) * 2 - 1`;
   the implementations use `(count + freq[temp]) << 1 - 1`, which is valid
   because the loop exits exactly when `freq[temp] <= 1`, so `freq[temp]` is
   `0` or `1`.
5. The global answer is the max over all chains and the ones case.

# Complexity

- Time complexity: O(n log log V) — each element is counted once, and each
  squaring chain has at most O(log log V) levels since the value squares
  every step.
- Space complexity: O(n) for the frequency map.

# Code

## Go

```go
func maximumLength(nums []int) int {
    freq := map[int]int{}
    for _, num := range nums {
        freq[num]++
    }
    ans := freq[1] - ((freq[1] & 1) ^ 1)
    delete(freq, 1)
    for num := range freq {
        count, temp := 0, num
        for freq[temp] > 1 {
            count++
            temp *= temp
        }
        ans = max(ans,  (count + freq[temp]) << 1 - 1)
    }
    return ans
}
```

## Rust

```rust
use std::collections::HashMap;

impl Solution {
    pub fn maximum_length(nums: Vec<i32>) -> i32 {
        let mut freq: HashMap<i32, i32> = HashMap::new();
        for num in nums.into_iter() {
            *freq.entry(num).or_insert(0) += 1;
        }

        let count_ones = freq.get(&1).unwrap_or(&0);
        let mut ans = count_ones - (((count_ones) & 1) ^ 1);

        freq.remove(&1);
        for &num in freq.keys() {
            let (mut length, mut temp) = (0, num);
            while let Some(&count) = freq.get(&temp) {
                if count > 1 {
                    length += 1;
                    if let Some(next) = temp.checked_mul(temp) {
                        temp = next;
                    } else {
                        temp = i32::MAX;
                        break;
                    }
                } else {
                    break;
                }
            }
            let count_temp = freq.get(&temp).unwrap_or(&0);
            ans = ans.max(((length + count_temp) << 1) - 1);
        }
        ans
    }
}
```
