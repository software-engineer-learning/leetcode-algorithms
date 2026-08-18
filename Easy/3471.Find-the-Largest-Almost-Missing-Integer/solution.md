# Intuition

An integer `x` is "almost missing" if it lies in **exactly one** window of size `k`.
How many size-`k` windows a position belongs to depends only on where it sits, so we
can reason by cases instead of enumerating every window:

- If `k == n`, there is a single window (the whole array), so *every* value appears
  in exactly one window — the answer is just the maximum element.
- If `k == 1`, each element is its own window, so `x` appears in exactly one window
  iff it is globally unique (frequency 1). Return the largest such value.
- If `1 < k < n`, only the two endpoints `nums[0]` and `nums[n-1]` are covered by
  exactly one window; every interior position is covered by at least two. An
  endpoint qualifies only if its value is globally unique. Return the larger
  qualifying endpoint, or `-1`.

# Approach: Frequency Count + Case Analysis

1. Handle `k == n` directly by returning the maximum element.
2. Otherwise build a frequency table (`nums[i] <= 50`, so a fixed 51-size array
   works).
3. For `k == 1`, scan values high to low and return the first with frequency 1.
4. For `1 < k < n`, consider `nums[0]` and `nums[n-1]`; keep whichever is larger
   among those with frequency 1, else `-1`.

# Complexity

- Time complexity: $$O(n + M)$$, where `n` is the array length and `M = 51` is the
  value range scanned — effectively $$O(n)$$.
- Space complexity: $$O(1)$$ — a fixed 51-element frequency array.

# Code

## Go

```go
func largestInteger(nums []int, k int) int {
    n := len(nums)
    if k == n {
        res := -1
        for _, num := range nums {
            res = max(res, num)
        }
        return res
    }
    freq := [51]int{}
    for _, num := range nums {
        freq[num]++
    }
    if k == 1 {
        for i := 50; i >= 0; i-- {
            if freq[i] == 1 {
                return i
            }
        }
        return -1
    }
    res := -1
    if freq[nums[0]] == 1 {
        res = max(res, nums[0])
    }
    if freq[nums[n-1]] == 1 {
        res = max(res, nums[n-1])
    }
    return res
}
```

## Rust

```rust
impl Solution {
    pub fn largest_integer(nums: Vec<i32>, k: i32) -> i32 {
        let n = nums.len();
        let k = k as usize;
        if k == n {
            return nums.into_iter().max().unwrap_or(-1);
        };
        let mut freq = [0; 51];
        for &num in &nums {
            freq[num as usize] += 1;
        }
        if k == 1 {
            return freq
                .iter()
                .enumerate()
                .rev()
                .find_map(|(i, &c)| if c == 1 { Some(i as i32) } else { None })
                .unwrap_or(-1);
        }
        let mut res = -1;
        let (first, last) = (nums[0], nums[n - 1]);
        if freq[first as usize] == 1 {
            res = res.max(first);
        }
        if freq[last as usize] == 1 {
            res = res.max(last);
        }
        res
    }
}
```
