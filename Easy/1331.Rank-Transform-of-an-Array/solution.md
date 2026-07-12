# Intuition

Each element's rank is its position among the **distinct** sorted values (smallest
gets 1). Sort a copy of the array, assign ranks to unique values in order, then map
each original element to its rank.

# Approach: Sort + Rank Map

1. Copy and sort `arr` to get values in ascending order.
2. Walk the sorted values, assigning rank 1 to the smallest unique value and
   incrementing only when the value changes.
3. Build a map from value to rank.
4. Replace each element of the original array with its rank from the map.

# Complexity

- Time complexity: $$O(n \log n)$$, where `n` is `arr.length` — dominated by
  sorting; map lookups are $$O(1)$$ on average.
- Space complexity: $$O(n)$$ for the sorted copy and rank map.

# Code

## Go

```go
import "sort"

func arrayRankTransform(arr []int) []int {
	sortedVals := make([]int, len(arr))
	copy(sortedVals, arr)
	sort.Ints(sortedVals)

	sortedUnique := make([]int, 0, len(sortedVals))
	for i, v := range sortedVals {
		if i == 0 || v != sortedVals[i-1] {
			sortedUnique = append(sortedUnique, v)
		}
	}

	rankMap := make(map[int]int, len(sortedUnique))
	for i, v := range sortedUnique {
		rankMap[v] = i + 1
	}

	res := make([]int, len(arr))
	for i, v := range arr {
		res[i] = rankMap[v]
	}
	return res
}
```

## Rust

```rust
use std::collections::HashMap;

impl Solution {
    pub fn array_rank_transform(mut arr: Vec<i32>) -> Vec<i32> {
        let mut sorted_arr: Vec<i32> = arr.iter().cloned().collect();
        sorted_arr.sort();
        let mut rank_map = HashMap::new();
        let mut rank = 1;
        for val in sorted_arr.iter() {
            if !rank_map.contains_key(&val) {
                rank_map.insert(val, rank);
                rank += 1;
            }
        }
        for i in 0..arr.len() {
            match rank_map.get(&arr[i]) {
                Some(&value) => arr[i] = value,
                None => break,
            }
        }
        arr
    }
}
```
