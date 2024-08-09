# Intuition

The problem requires us to traverse a grid in a spiral order starting from a specific cell. The key challenge is to correctly move in a spiral pattern while ensuring that the movement is handled properly when the traversal extends beyond the grid boundaries. We must also ensure that we visit every cell in the grid.

<p>&nbsp;</p>

# Approach: Simulating

The idea is to simulate the spiral traversal by following a specific order of directions: right, down, left, and up. By moving in this sequence, we can achieve the spiral pattern. The simulation continues until we have visited all the cells in the grid.

## Explanation:

1. **Direction Array**:
   - `dirs[] = {0, 1, 0, -1, 0}` is used to manage movement in the four cardinal directions. The sequence of directions is:
     - Right: `(0, 1)`
     - Down: `(1, 0)`
     - Left: `(0, -1)`
     - Up: `(-1, 0)`
   - This array allows us to handle direction changes seamlessly during the spiral traversal.

2. **Initialization**:
   - We initialize the result vector `res` with a size of `rows * cols` to store the coordinates of the cells we visit.
   - `d = 0`: The direction index, starting with moving right.
   - `p = 0`: The index to fill in the `res` vector.
   - `steps = 1`: This represents the number of steps to move in the current direction. It starts at 1 and increases as we complete two directions (i.e., right and down, left and up).

3. **Traversal**:
   - The outer `while` loop continues until we have visited all the grid cells (`p < rows * cols`).
   - The inner loop structure ensures that we move in the current direction for the required number of `steps`.
   - For every step, if the current position `(x, y)` is within the grid boundaries, we store the coordinate in `res[p++]`.
   - After moving `steps` times in one direction, we update `x` and `y` accordingly and switch to the next direction using `d = (d + 1) % 4` to cycle through the four directions.

4. **Increasing Steps**:
   - After completing a pair of directions (right and down, or left and up), we increase `steps` by 1. This ensures that the spiral expands correctly.

## Complexity

- Time complexity: $O(\text{rows} \times \text{cols})$
  - We visit each cell in the grid exactly once.

- Space complexity: $O(\text{rows} \times \text{cols})$
  - We store the coordinates of all cells in the `res` vector.

## Code

```cpp
int dirs[] = {0, 1, 0, -1, 0};

class Solution {
public:
    vector<vector<int>> spiralMatrixIII(int rows, int cols, int x, int y) {
        vector<vector<int>> res(rows * cols);
        int d = 0, p = 0, steps = 1;

        while (p < rows * cols) {
            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < steps; j++) {
                    if (x >= 0 && x < rows && y >= 0 && y < cols) {
                        res[p++] = {x, y};
                    }
                    x += dirs[d];
                    y += dirs[d + 1];
                }

                d = (d + 1) % 4;
            }

            ++steps;
        }

        return res;
    }
};
```