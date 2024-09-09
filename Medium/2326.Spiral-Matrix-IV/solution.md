
# Intuition

- This problem is similar to Spiral Matrix II, it is recommended to do that before doing this.

# Approach

- Changing directions:
  - In a normal graph/matrix DFS traversal, you normally always prioritizing 1 direction, for example always going up if possible. This time, it is required for you to only going in 1 direction, and change it according to a pattern: right -> down -> left -> up.
  - You can do exactly that, keep going in 1 direction and only change direction when encounter boundary.
- Create a result 2d array and fill it with -1 then travese it in spiral direction, at every index fill the value of current node from input linked-list in it. You stop when you reach the end of the linked-list.

# Complexity

- Time complexity: `O(N).` Every node of the linked-list is visited only once
- Space complexity: `O(1).` It actually O(N) if you count the call stack

## Code

### C++

```cpp
class Solution {
public:
    vector<vector<int>> spiralMatrix(int m, int n, ListNode* head) {
        vector<vector<int>> res(m, vector<int>(n, -1));
        vector<pair<int, int>> directions = {
            {0, 1}, {1, 0}, {0, -1}, {-1, 0}
        };
        move(res, m, n, 0, 0, head, 0, directions);
        return res;
    }

    void move(vector<vector<int>> &res, int m, int n, int row, int col, ListNode* head, int dir, vector<pair<int, int>> &directions) {
        if(min(row, col) < 0 || row > m-1 || col > n-1) return;
        if(!head) return;
        res[row][col] = head->val;
        head = head->next;

        int nextRow = row + directions[dir].first;
        int nextCol = col + directions[dir].second;
        bool out_bound_h = (nextRow < 0 || nextRow > m-1);
        bool out_bound_w = nextCol < 0 || nextCol > n-1;
        if (out_bound_h || out_bound_w || res[nextRow][nextCol] != -1) {
            dir = (dir + 1) % 4;
            nextRow = row + directions[dir].first;
            nextCol = col + directions[dir].second;
        }
        move(res, m, n, nextRow, nextCol, head, dir, directions);
    }
};
```

### Go

```Go
func spiralMatrix(m int, n int, head *ListNode) [][]int { 
    matrix := make([][]int, m) 
    for i := range matrix { 
        matrix[i] = make([]int, n) 
        for j := 0; j < n; j++ { 
            matrix[i][j] = -1 
        } 
    } 
    directions := [][]int{{0, 1}, {1, 0}, {0, -1}, {-1, 0}} 
    sx, sy := 0, 0 
    matrix[sx][sy] = head.Val 
    head = head.Next 
    for d := 0; head != nil; d = (d + 1) % 4 { 
        for head != nil { 
            tx, ty := sx + directions[d][0], sy + directions[d][1] 
            if tx < 0 || tx >= m || ty < 0 || ty >= n || matrix[tx][ty] != -1 { 
                break 
            } 
 
            sx, sy = tx, ty 
            matrix[sx][sy] = head.Val 
            head = head.Next 
        } 
    } 
    return matrix 
}
```

### Java

``` Java
class Solution {
    public int[][] spiralMatrix(int m, int n, ListNode head) {
        int[][] result = new int[m][n];
        int top = 0, left = 0, right = n - 1, bottom = m - 1;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                result[i][j] = -1;
            }
        }

        while (left <= right && top <= bottom) {
            for (int i = left; i <= right && head != null; i++) {
                result[top][i] = head.val;
                head = head.next;
            }
            top++;

            for (int i = top; i <= bottom && head != null; i++) {
                result[i][right] = head.val;
                head = head.next;
            }
            right--;

            for (int i = right; i >= left && head != null; i--) {
                result[bottom][i] = head.val;
                head = head.next;
            }
            bottom--;

            for (int i = bottom; i >= top && head != null; i--) {
                result[i][left] = head.val;
                head = head.next;
            }
            left++;
        }

        return result;
    }
}
```
