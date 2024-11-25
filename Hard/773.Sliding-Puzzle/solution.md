# Intuition

The problem can be solved using BFS (Breadth-first search) because it involves finding the shortest path to the target state:
The board state can be represented as a single string.
The position of 0 determines the possible moves (up, down, left, right). Each move swaps 0 with one of its adjacent tiles.
The goal is to transform the given state to the target 123450.

BFS is ideal because it explores all states level by level, ensuring the minimum number of moves to reach the solution.
Use a set to keep track of visited states to avoid revisiting the same state.
# Approach

Initialize BFS
Represent the board as a string and store the initial state in a queue along with the position of 0 and the current move count.
Explore States
For each state, generate all possible states by swapping 0 with its adjacent tiles.
If a state matches the target, return the move count.
Return -1 if unreachable.

If the queue is empty and the target state is not reached, return -1.
Mapping moves
Use a precomputed mapping of valid moves for each position of 0 in the 2x3 board to simplify calculations.
# Complexity

Time complexity: O(N!) where N is the number of unique states for a 2 x 3 board is 6! (720 state).

Space complexity: O(N!) for the visited set and queue.


# Code

Golang
```go
import (
        "fmt"
        "strings"
        )

func findShortestPath(start, target string) int {
  if  target == start {
    return 0
  }
  moves := [6][]int{
    {1, 3},
    {0, 2, 4},
    {1, 5},
    {0, 4},
    {1, 3, 5},
    {2, 4},
  }
  queue := make([]string, 0)
  nMoves := 0
  queue = append(queue, start)
  visited := map[string]bool{start: true}
  for len(queue) > 0 {
    length := len(queue)

    for length > 0 {
      current := queue[0]
      queue = queue[1:]

      if current == target {
        return nMoves
      }
      zeroPos := strings.IndexRune(current, '0')
      for _, next := range moves[zeroPos] {
        state := []byte(current)
                state[zeroPos], state[next] = state[next], state[zeroPos]
        nextState := string(state)
        if !visited[nextState] {
          visited[nextState] = true
          queue = append(queue, nextState)
        }
      }
      length--
    }

    nMoves++
  }
  return -1
}

func slidingPuzzle(board [][]int) int {
  target := "123450"
  start := ""

  for _, row := range board {
    for _, val := range row {
      start = start + fmt.Sprintf("%d", val)
    }
  }
  return findShortestPath(start, target)
}
```

Rust

```rust
use std::collections::{HashSet, VecDeque};

impl Solution {
    fn find_shortest_path(start: Vec<u8>, target: Vec<u8>) -> i32{
        if start == target {
            return 0;
        }
        
        let moves = vec![
            vec![1, 3],      
            vec![0, 2, 4],   
            vec![1, 5],      
            vec![0, 4],      
            vec![1, 3, 5],   
            vec![2, 4],
        ];

        let mut queue: VecDeque<Vec<u8>> = VecDeque::new();
        queue.push_back(start.to_vec());

        let mut visited:HashSet<Vec<u8>> = HashSet::new();
        visited.insert(start);
        let mut n_moves = 0;
        while !queue.is_empty() {
            let size = queue.len();
            for _ in 0..size {
                if let Some(current) = queue.pop_front() {
                    if current == target {
                        return n_moves;
                    }
                    let zero_pos = current.iter().position(|&x| x == 0).unwrap();
                    for &next_pos in &moves[zero_pos] {
                        let mut new_state = current.clone();
                        new_state.swap(zero_pos, next_pos);
                        
        
                        if visited.insert(new_state.clone()) {
                            queue.push_back(new_state);
                        }
                    }
                    
                }
            }
            n_moves += 1;
        }
        -1
    }
    pub fn sliding_puzzle(board: Vec<Vec<i32>>) -> i32 {
        let mut target:Vec<u8> = vec![1,2,3,4,5,0];
        let mut start:Vec<u8> = Vec::new();
        for row in board {
            for val in row {
                start.push(val as u8);
            }
        }
        Self::find_shortest_path(start, target)
    }
}

```
