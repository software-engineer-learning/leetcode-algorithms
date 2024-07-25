# Intuition

- To solve this problem, we need to simulate the movements and collisions of the robots. The key idea is to use a stack to keep track of robots moving to the right and process collisions as robots moving to the left encounter them.

# Approach

Here’s a step-by-step explanation and the corresponding solution:

1. Sort robots by position: Since the positions are given in an unsorted manner, we sort them to process collisions correctly.

2. Use a stack to simulate collisions: We’ll use a stack to track robots moving to the right (‘R’). When a robot moving to the left (‘L’) is encountered, we check for collisions with the robots in the stack.

3. Process collisions:

- If a robot moving to the left encounters a robot moving to the right, we compare their healths.
- The robot with lower health is removed, and the other robot’s health is decreased by one.
- If both robots have the same health, both are removed.

4. Maintain the order of survivors: After processing all robots, we need to maintain the order of surviving robots as given in the input. We use the original indices to achieve this.

# Complexity

- Time Complexity: $O(NLogN)$.
- Space Complexity: $O(N)$.

# Code

## Go

```golang
import "sort"

type Robot struct {
	index     int
	position  int
	health    int
	direction byte
}

func survivedRobotsHealths(positions []int, healths []int, directions string) []int {
    n := len(positions)
	robots := make([]Robot, n)

	for i := 0; i < n; i++ {
		robots[i] = Robot{i, positions[i], healths[i], directions[i]}
	}

	// Sort robots by position
	sort.Slice(robots, func(i, j int) bool {
		return robots[i].position < robots[j].position
	})

	stack := []Robot{}
	survivors := make([]Robot, 0)

	for _, robot := range robots {
		if robot.direction == 'R' {
			stack = append(stack, robot)
		} else {
			for len(stack) > 0 && stack[len(stack)-1].direction == 'R' {
				top := stack[len(stack)-1]
				if top.health < robot.health {
					robot.health--
					stack = stack[:len(stack)-1]
				} else if top.health > robot.health {
					stack[len(stack)-1].health--
					robot.health = 0
					break
				} else {
					stack = stack[:len(stack)-1]
					robot.health = 0
					break
				}
			}
			if robot.health > 0 {
				survivors = append(survivors, robot)
			}
		}
	}

	// Remaining robots in the stack are survivors
	for _, robot := range stack {
		survivors = append(survivors, robot)
	}

	// Sort survivors by their original index
	sort.Slice(survivors, func(i, j int) bool {
		return survivors[i].index < survivors[j].index
	})

	// Extract the health of survivors in the order of their original indices
	result := make([]int, len(survivors))
	for i, robot := range survivors {
		result[i] = robot.health
	}

	return result
}
```

## Rust

```rust
#[derive(Clone, Debug)]
struct Robot {
    index: usize,
    position: i32,
    health: i32,
    direction: u8,
}

impl Robot {
    fn new(index: usize, position: i32, health: i32, direction: u8) -> Self {
        Self { index, position, health, direction }
    }
}

impl Solution {
    pub fn survived_robots_healths(positions: Vec<i32>, healths: Vec<i32>, directions: String) -> Vec<i32> {
        let n = positions.len();
        let directions:Vec<u8> = directions.into_bytes();
        let mut robots:Vec<Robot> = (0..n)
            .map(|i| Robot::new(i, positions[i], healths[i], directions[i]))
            .collect();

        robots.sort_unstable_by_key(|robot| robot.position);
        let mut stack:Vec<Robot> = Vec::new();
        let mut survivors:Vec<Robot> = Vec::new();
        for mut robot in robots {
            if robot.direction == b'R' {
                stack.push(robot);
            } else {
                while let Some(mut right_robot) = stack.pop() {
                    if right_robot.health < robot.health {
                        robot.health -= 1;
                    } else if right_robot.health > robot.health {
                        right_robot.health -= 1;
                        stack.push(right_robot);
                        robot.health = 0;
                        break;
                    } else {
                        robot.health = 0;
                        break;
                    }
                }
                if robot.health > 0 {
                   survivors.push(robot);
                }
            }
        }

        survivors.extend(stack);
        survivors.sort_unstable_by_key(|robot| robot.index);
        survivors.into_iter().map(|robot| robot.health).collect()
    }
}
```
