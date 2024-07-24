# Intuition

Sort with comparator.

# Complexity

- Time complexity: $O(NlogN)$.
- Space complexity: $O(N)$.

# Code

## Go

```go
import "sort"

func frequencySort(nums []int) []int {
    freq := make([]int, 201)
    for _, num := range nums {
        freq[num+100]++
    }
    sort.SliceStable(nums, func(i, j int) bool {
        return (freq[nums[i] + 100] < freq[nums[j] + 100]) || (freq[nums[i] + 100] == freq[nums[j] + 100] && nums[i] > nums[j])
    })
    return nums
}
```

## Rust

```rust
impl Solution {
    pub fn frequency_sort(mut nums: Vec<i32>) -> Vec<i32> {
        let mut freq = vec![0; 201];
        nums.iter().for_each(|num| {
            freq[(num + 100) as usize] += 1;
        });
        nums.sort_unstable_by(|a, b| freq[(a+100) as usize].cmp(&freq[(b+100) as usize]).then(b.cmp(&a)));
        nums
    }
}
```
