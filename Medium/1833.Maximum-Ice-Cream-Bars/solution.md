# Intuition

To maximize the number of ice cream bars the boy can buy, we should always purchase the cheapest bars first. If we ever bought a more expensive bar while a cheaper one was still available, we could swap them and afford at least as many bars in total.

Since the order of purchase does not matter, we only need to know how many bars exist at each price—not which index each bar came from.

# Approach: Counting Sort + Greedy

1. **Build a frequency array** `costFreq` of size `100_001` (costs are in `[1, 10^5]`) and track `maxCost`.
2. **Iterate prices from lowest to highest** (`1` to `maxCost`).
3. For each price `cost`, buy `min(costFreq[cost], coins / cost)` bars, subtract the spent coins, and add to the answer.
4. Stop implicitly when `coins` is no longer enough for the current price; cheaper prices are already fully processed.

This is counting sort in spirit: we sort by price without an explicit comparison sort.

# Complexity

- Time complexity: O(n + C), where n is the length of `costs` and C = 10⁵ is the maximum cost.
- Space complexity: O(C) for the frequency array.

# Code

## Go

```go
func maxIceCream(costs []int, coins int) int {
    costFreq := make([]int, 100_000+1)
    maxCost := 0
    for _, cost := range costs {
        costFreq[cost]++
        maxCost = max(maxCost, cost)
    }
    ans := 0
    for cost := range maxCost + 1 {
        if costFreq[cost] == 0 {
            continue
        }
        count := min(costFreq[cost], coins/cost)
        coins -= count * cost
        ans += count
    }
    return ans
}
```

## Rust

```rust
impl Solution {
    pub fn max_ice_cream(costs: Vec<i32>, mut coins: i32) -> i32 {
        let mut cost_freq = [0; 100_000 + 1];
        let mut max_cost = 0;
        for &cost in &costs {
            cost_freq[cost as usize] += 1;
            max_cost = max_cost.max(cost as usize);
        }
        let mut ans = 0;
        for cost in 1..=max_cost {
            if cost_freq[cost] == 0 {
                continue;
            }
            let cost_i32 = cost as i32;
            let count = cost_freq[cost].min(coins / cost_i32);
            coins -= count * cost_i32;
            ans += count;
        }
        ans as i32
    }
}
```
