# Intuition

To understand how the pillow moves among the people in line, let's understand the pattern of its movement. The pillow completes a full round when it travels from the first person to the last or vice versa. Each complete round takes $n - 1$ seconds, where n is the total number of people.

To determine how many complete rounds the pillow makes within a given time time, we divide $time$ by $n - 1$. This gives us $fullRounds$, representing the number of times the pillow moves from one end of the line to the other. The remainder of this division, $extraTime = time % (n - 1)$, indicates the extra time left after completing these full rounds.

Now, let's consider the direction of the pillow's movement:

- If $fullRounds$ is even, the pillow moves forward along the line.
- If $fullRounds$ is odd, the pillow moves backward. This directional change occurs after each complete round.
  In the case of forward movement ($fullRounds$ is even), the person holding the pillow after the extra time will be positioned at $extraTime + 1$ (since we start counting positions from one). Conversely, during backward movement ($fullRounds$ is odd), the person holding the pillow will be at position $n - extraTime$.

# Complexity

- Time complexity: $O(1)$.

- Space complexity: $O(1)$.

# Solution

## Rust

```rust
impl Solution {
    pub fn pass_the_pillow(n: i32, time: i32) -> i32 {
        let full_rounds = time / (n - 1);
        let extra_time = time % (n - 1);
        if full_rounds & 1 == 0 {
            extra_time + 1
        } else {
            n - extra_time
        }
    }
}
```
