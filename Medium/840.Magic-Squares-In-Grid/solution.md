# Intuition

The problem requires us to find how many 3x3 subgrids within a given grid are magic squares. A 3x3 magic square has distinct numbers from 1 to 9, and the sum of the numbers in each row, column, and both diagonals must be the same (which is 15 for this case). The key challenge is to efficiently check whether each 3x3 subgrid meets these criteria.

<p>&nbsp;</p>

# Approach

The solution involves scanning every possible 3x3 subgrid in the grid and verifying whether it forms a magic square. The `isMagic` function performs this check by ensuring the sum of rows, columns, and diagonals equals 15, and that the subgrid contains distinct numbers from 1 to 9.

## Explanation:

1. **`isMagic` Function**:
   - **Check Center Value**:
     - The center of a 3x3 magic square must be 5. If `grid[i][j]` (the center value of the subgrid) is not 5, the function returns `false`.
   - **Initialize Bits and Sum Arrays**:
     - `bits` tracks which numbers from 1 to 9 are present in the subgrid. If all numbers from 1 to 9 are present, `bits` will equal 1022 (since `1022` in binary is `1111111110`).
     - `sum` is an array of size 8, where the first three elements store the sum of rows, the next three store the sum of columns, and the last two store the sum of diagonals.
   - **Populate Bits and Sum**:
     - The function iterates through each cell of the 3x3 subgrid. For each cell, it updates `bits` and the corresponding sums in the `sum` array.
   - **Check for Magic Square**:
     - The function checks if `bits` equals 1022 and if all values in the `sum` array are 15. If both conditions are met, the subgrid is a magic square.

2. **`numMagicSquaresInside` Function**:
   - **Scan the Grid**:
     - The function scans every possible 3x3 subgrid within the grid by iterating over all valid center cells `(i, j)`.
   - **Count Magic Squares**:
     - For each subgrid, the function calls `isMagic`. If the subgrid is a magic square, the result count (`res`) is incremented.
   - **Return the Result**:
     - Finally, the function returns the total count of magic squares found.

## Complexity
- **Time complexity**: $O(n \times m)$, where `n` and `m` are the dimensions of the grid. The function checks each 3x3 subgrid, and there are $(n-2) \times (m-2)$ such subgrids.
- **Space complexity**: $O(1)$, since the additional space used by the function is constant.

## Code 
cpp
```cpp
class Solution {
public:
    bool isMagic(vector<vector<int>>& grid, int i, int j) {
        if (grid[i][j] != 5) return false;

        int bits = 0;
        array<int, 8> sum {};

        for (int dx = -1; dx <= 1; dx++) {
            for (int dy = -1; dy <= 1; dy++) {
                bits ^= 1 << grid[i + dx][j + dy];
                sum[dx + 1] += grid[i + dx][j + dy];
                sum[dx + 4] += grid[i + dy][j + dx];
            }
        }

        sum[6] = grid[i - 1][j - 1] + grid[i][j] + grid[i + 1][j + 1];
        sum[7] = grid[i - 1][j + 1] + grid[i][j] + grid[i + 1][j - 1];

        return bits == 1022 && ranges::all_of(sum, [&](int x) {
            return x == 15;
        });
    }

    int numMagicSquaresInside(vector<vector<int>>& grid) {
        int n = grid.size();
        int m = grid[0].size();
        int res = 0;

        for (int i = 1; i < n - 1; i++) {
            for (int j = 1; j < m - 1; j++) {
                res += isMagic(grid, i, j);
            }
        }

        return res;
    }
};
```