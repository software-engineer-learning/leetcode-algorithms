# Intuition
Backtracking Approach: The algorithm uses backtracking to solve the Sudoku puzzle. It tries to place each number from '1' to '9' in every empty cell and checks if the number placement is valid. If valid, it proceeds to solve the next cell recursively. If no valid number is found, it backtracks and tries the next possible number.

Validation: The isValid method checks if placing a number in a specific cell adheres to Sudoku rules by ensuring the number does not repeat in the current row, column, or 3x3 sub-grid.

# Complexity

- Time complexity: O(9^m)

- Space complexity: O(1)

# Solution

## Java
```java
class Solution {
    public void solveSudoku(char[][] board) {
        backtracking(board);
    }

    private boolean backtracking(char[][] board) {
        // check row
        for (int row = 0; row < 9; row++) {
            // check col
            for (int col = 0; col < 9; col++) {
                if (board[row][col] == '.') {
                    // check nums
                    for (char num = '1'; num <= '9'; num++) {
                        if (isValid(board, row, col, num)) {
                            board[row][col] = num;
                            if (backtracking(board)) {
                                return true;
                            }
                            board[row][col] = '.';
                        }
                    }
                    return false;
                }
            }
        }
        return true;
    }
    
    // check row , col , 3x3 grid
    private boolean isValid(char[][] board, int row, int col, char num) {
        for (int i = 0; i < 9; i++) {
            if (board[row][i] == num || board[i][col] == num ||
                    board[(row / 3) * 3 + i / 3][(col / 3) * 3 + i % 3] == num) {
                return false;
            }
        }
        return true;
    }

}
```
