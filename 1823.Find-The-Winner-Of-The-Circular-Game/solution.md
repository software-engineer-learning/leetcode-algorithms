# Intuition

The problem you’re describing is a classic example of the Josephus problem, a well-known theoretical problem in mathematics and computer science. The Josephus problem is defined as follows: given a number of people standing in a circle and a fixed step count, you eliminate every k-th person until only one person remains. The task is to find the position of that person.

# Approach

To solve this problem, you can use a mathematical approach with recursive or iterative methods to determine the winner’s position.

# Complexity

- Time complexity: `O(N).`
- Space complexity: `O(1).`

# Code

## Rust

### Recursive solution

```rust
impl Solution {
    fn recursive(n: i32, k: i32) -> i32 {
        if n == 1 {
            0
        } else {
            (Self::recursive(n-1, k) + k) % n
        }

    }
    pub fn find_the_winner(n: i32, k: i32) -> i32 {
        Self::recursive(n, k) + 1
    }

}
```

### Non-recursive solution

```rust
impl Solution {
    pub fn find_the_winner(n: i32, k: i32) -> i32 {
        let mut winner = 0;
        for i in 1..=n {
            winner = (winner + k) % i
        }
        winner + 1
    }
}
```
