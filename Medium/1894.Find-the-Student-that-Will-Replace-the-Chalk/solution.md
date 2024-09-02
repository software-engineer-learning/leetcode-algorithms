# Intuition

When given the problem, the first thought is that the large value of `k` may exceed the total amount of chalk available across all students. Therefore, it's intuitive to reduce `k` by taking the modulo of the sum of all chalk, as this would give us the effective amount of chalk `k` remaining after potentially multiple full rounds of chalk usage.

# Approach

1. **Calculate Total Chalk**: First, sum up the total amount of chalk that would be used in one complete round.
2. **Reduce k**: Take `k % total` to reduce `k` to a value that represents the remaining chalk after several full rounds.
3. **Determine the Student**: Iterate through the array of chalk. Subtract each student's chalk usage from `k` until `k` becomes less than the chalk needed by a student, which indicates that the current student will be the one who runs out of chalk.

# Complexity

- Time complexity:

  - $O(n)$, where `n` is the number of students. This is because we traverse the array twice, once to calculate the total chalk and once to find the student.

- Space complexity:
  - $O(1)$, as no extra space is used other than a few variables.

# Code

## Java

```java
class Solution {
    public int chalkReplacer(int[] chalk, int k) {
        long total = 0;
        for (int c : chalk) {
            total += c;
        }

        k %= total;

        for (int i = 0; i < chalk.length; i++) {
            if (k < chalk[i]) {
                return i;
            }
            k -= chalk[i];
        }

        return 0;
    }
}
```

## Rust

```rust
impl Solution {
    pub fn chalk_replacer(chalk: Vec<i32>, k: i32) -> i32 {
        let sum:usize = chalk.iter().fold(0usize, |acc, &num| acc + (num as usize));
        let mut k = (k as usize) % sum;
        for i in 0..chalk.len() {
            if k < chalk[i] as usize {
                return i as i32;
            }
            k-= chalk[i] as usize;
        }
        0
    }
}
```

## Go
```go
func chalkReplacer(chalk []int, k int) int {
	var sumChalk = 0
	for i := 0; i < len(chalk); i++ {
		sumChalk += chalk[i]
	}
	if k % sumChalk == 0 {
		return 0
	}
	var remain = k % sumChalk
	for i := 0; i < len(chalk); i++ {
		if remain < chalk[i] {
			return i
		}
		remain -= chalk[i]
	}
	return 0
}
```