## Intuition

To solve this problem, we can use a max-heap to efficiently retrieve and modify the pile with the maximum number of gifts in each operation

## Approach

1. **Max-Heap:**

- Use a max-heap (priority queue) to always retrieve the pile with the maximum number of gifts in $O(\log n)$ time.

2. **Simulation:**

- Perform `k` operations:
  - Extract the maximum pile.
  - Calculate the number of gifts to leave behind using the floor of the square root.
  - Push the remaining gifts back into the heap.

3. **Sum Remaining Gifts:**

- After `k` operations, sum all elements in the heap to compute the remaining gifts.

## Complexity

- Time Complexity:
  - Heap initialization: $O(n \log n)$.
  - `k` heap operation: $O(k \log n)$.
  - Total: $O((n + k) \log n)$.
- Space complexity: $O(n)$ for heap.

## Code

### Go

```go

import (
	"container/heap"
	"math"
)

type IntHeap []int

func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] > h[j] }
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *IntHeap) Push(x any) {
	*h = append(*h, x.(int))
}

func (h *IntHeap) Pop() any {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

func pickGifts(gifts []int, k int) int64 {
    maxHeap := &IntHeap{}
    heap.Init(maxHeap)
    for _, gift := range gifts {
        heap.Push(maxHeap, gift)
    }
    for k > 0 {
        top := heap.Pop(maxHeap).(int)
        heap.Push(maxHeap, int(math.Sqrt(float64(top))))
        k--
    }
    sum := int64(0)
    for maxHeap.Len() > 0 {
        sum += int64(heap.Pop(maxHeap).(int))
    }
    return sum
}
```

### Rust

```rust
use std::collections::BinaryHeap;

impl Solution {
    pub fn pick_gifts(gifts: Vec<i32>, k: i32) -> i64 {
        let mut heap: BinaryHeap<i32> = BinaryHeap::from(gifts);
        for _ in 0..k {
            if let Some(top) = heap.pop() {
                let val = f64::sqrt(top as f64) as i32;
                heap.push(val);
            }
        }
        let mut sum = 0i64;

        while let Some(top) = heap.pop() {
            sum += top as i64;
        }
        sum
    }
}
```
