# Intuition

This problem can be solved efficiently using a monotonic stack. The stack helps track the indices of the items while iterating through the array, allowing us to determine the discount for each item.

# Approach

## Monotonic Stack:

- Use a stack to store indices of items.
- For each price in the array, check the stack for items that should receive a discount based on the current price.

## Discount Logic:

- The stack ensures that items are processed in non-decreasing price order. For the current price, any item on the stack that satisfies $\text{prices[j]} \leq \text{prices[i]}$ can receive a discount.

## Calculate Final Prices:

- For each item, subtract the discount from the original price.

# Complexity

- Time Complexity: $O(n)$ where n is the length of the array.
- Space Complexity: $O(n)$ for the stack.

# Code

## Go

```go []
func finalPrices(prices []int) []int {
    n := len(prices)
    stack := []int{}
    result := make([]int, n)
    for i := n- 1; i >= 0; i-- {
        for len(stack) > 0 && prices[stack[len(stack) - 1]] > prices[i]  {
            stack = stack[:len(stack) - 1]
        }
        if len(stack) > 0 {
            result[i] = prices[i] - prices[stack[len(stack) - 1]]
        } else {
            result[i] = prices[i]
        }
        stack = append(stack, i)
    }

    return result
}
```

## Rust

```rust []
use std::collections::VecDeque;
impl Solution {
    pub fn final_prices(prices: Vec<i32>) -> Vec<i32> {
        let n = prices.len();
        let mut stack = VecDeque::<usize>::new();
        let mut result:Vec<i32> = vec![0; n];
        for i in (0..n).rev() {
            while stack.back().is_some_and(|&x| prices[x] > prices[i]){
                stack.pop_back();
            }

            result[i] = match stack.back() {
                Some(&top) => prices[i] - prices[top],
                _ => prices[i],
            };
            stack.push_back(i);
        }
        result
    }
}

```
