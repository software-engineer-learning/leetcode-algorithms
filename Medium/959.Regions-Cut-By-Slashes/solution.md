# Intuition

The problem involves counting the number of distinct regions formed by slashes (`'/'` and `'\'`) in a grid. This can be approached in two ways: using DFS on an expanded grid or using the Union-Find (DSU) data structure.

1. **DFS on an Expanded Grid**:  
   This approach visualizes each cell in the grid as a `3x3` sub-grid. The slashes within each cell are represented by filling specific cells in this expanded grid. DFS is then used to explore and count the number of connected components (regions) in the expanded grid. Each connected component represents a distinct region.

2. **Union-Find (DSU)**:  
   Instead of expanding the grid, this approach treats the grid points as nodes in a graph. The Union-Find structure helps manage the connections between these nodes based on the slashes that separate them. By tracking these connections, the algorithm identifies cycles or separations in the grid, which correspond to distinct regions. Each time a new region is formed, the count is incremented.

Both methods ultimately aim to detect and count the distinct regions formed by the slashes, but they differ in how they model the grid and how they detect these regions.

<p>&nbsp;</p>

# Approach 1: Grid Expansion and DFS
The approach involves two main steps: first, expanding the grid into a finer grid where slashes are represented as filled cells, and second, using DFS to count the number of distinct regions in this finer grid.

## Explanation:

1. **Grid Expansion**:
   - Each `1x1` cell in the original grid is expanded into a `3x3` block in the expanded grid. This expansion helps to clearly represent the slashes (`'/'` and `'\'`) within each cell.
   - For a `'/'`, the middle cell and the two diagonal cells from top-right to bottom-left are marked as filled (`true`).
   - For a `'\'`, the middle cell and the two diagonal cells from top-left to bottom-right are marked as filled (`true`).
   - The rest of the cells in the `3x3` block remain unfilled (`false`).

2. **DFS to Count Regions**:
   - After building the expanded grid, we perform DFS on each unfilled (`false`) cell to mark all connected unfilled cells as filled (`true`).
   - Each time a new DFS is initiated from an unfilled cell, it signifies the discovery of a new region, so the region count is incremented.
   - The DFS proceeds in four possible directions (up, down, left, right), checking and marking connected cells.

3. **Returning the Result**:
   - After traversing the entire expanded grid and counting all connected regions, the total number of regions is returned.

## Complexity
- **Time complexity**: $O(n^2)$, where `n` is the size of the original grid. The expansion creates a grid of size `3n x 3n`, and DFS explores each cell once.
- **Space complexity**: $O(n^2)$ for the expanded grid.

## Code 
```cpp
int dirs[] = {0, 1, 0, -1, 0};

class Solution {
public:
    vector<vector<bool>> buildExpandedGrid(vector<string>& grid) {
        int n = grid.size();

        vector<vector<bool>> expanded(n * 3, vector<bool>(n * 3, false));

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                int x = i * 3 + 1;
                int y = j * 3 + 1;

                if (grid[i][j] == '/') {
                    expanded[x][y] = true;
                    expanded[x - 1][y + 1] = true;
                    expanded[x + 1][y - 1] = true;
                }
                else if (grid[i][j] == '\\') {
                    expanded[x][y] = true;
                    expanded[x - 1][y - 1] = true;
                    expanded[x + 1][y + 1] = true;
                }
            }
        }

        return expanded;
    }

    void dfs(vector<vector<bool>>& grid, int x, int y) {
        if (min(x, y) < 0 || max(x, y) == grid.size() || grid[x][y] == true) {
            return;
        }

        grid[x][y] = true;

        for (int d = 0; d < 4; d++) {
            dfs(grid, x + dirs[d], y + dirs[d + 1]);
        }
    }

    int regionsBySlashes(vector<string>& grid) {
        vector<vector<bool>> expanded = buildExpandedGrid(grid);

        int res = 0;

        for (int i = 0; i < expanded.size(); i++) {
            for (int j = 0; j < expanded.size(); j++) {
                if (expanded[i][j] == false) {
                    ++res;
                    dfs(expanded, i, j);
                }
            }
        }

        return res;
    }
};
```

<p>&nbsp;</p>

# Approach 2: Union-Find
Instead of treating each cell as being divided into smaller sub-cells, this approach considers the grid points themselves as nodes in a graph. The Union-Find structure is used to manage connections between these nodes, effectively tracking how slashes separate different regions.

## Explanation:

1. **Union-Find Initialization**:
   - We create a Union-Find structure for an `(n+1) x (n+1)` grid, which corresponds to the intersections of the cells and the boundaries of the original grid.
   - This grid is larger by one unit in both dimensions to handle boundary connections properly.

2. **Connecting Boundary Points**:
   - All the boundary points of this grid are unified into a single region. This step ensures that any region touching the boundary is considered as part of a single outer region.

3. **Processing Slashes**:
   - For each cell in the original grid, depending on whether it contains a `'/'` or `'\'`, we unify specific adjacent nodes in the grid:
     - `'/'`: Connects the top-right point to the bottom-left point.
     - `'\'`: Connects the top-left point to the bottom-right point.
   - If a union operation fails (i.e., the nodes were already connected), it indicates that the current connection forms a cycle, meaning a new region is formed, so the region count is incremented.

4. **Returning the Result**:
   - After processing all cells, the total count of distinct regions is returned.

## Complexity
- **Time complexity**: $O(n^2 \cdot \alpha(n^2))$, where $\alpha(n^2)$ is the inverse Ackermann function, which is nearly constant.
- **Space complexity**: $O(n^2)$

## Code 
```cpp
class UnionFind {
private:
    int* root;
    int* rootSize;

public:
    UnionFind(int n) {
        root = new int[n];
        iota(root, root + n, 0);

        rootSize = new int[n];
        fill(rootSize, rootSize + n, 1);
    }

    ~UnionFind() {
        delete[] root;
        delete[] rootSize;
    }

    int find(int x) {
        if (root[x] != x) {
            root[x] = find(root[x]);
        }
        return root[x];
    }

    bool unite(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX == rootY) return false;

        if (rootSize[rootX] < rootSize[rootY]) {
            swap(rootX, rootY);
        }

        root[rootY] = rootX;
        rootSize[rootX] += rootSize[rootY];
        return true;
    }
};

class Solution {
public:
    int regionsBySlashes(vector<string>& grid) {
        int n = grid.size();
        UnionFind uf((n + 1) * (n + 1));

        for (int i = 0; i <= n; ++i) {
            uf.unite(0, i);
            uf.unite(0, i * (n + 1));
            uf.unite(i * (n + 1) + n, 0);
            uf.unite(n * (n + 1) + i, 0);
        }

        int res = 1;

        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                int topLeft = i * (n + 1) + j;
                int bottomLeft = (i + 1) * (n + 1) + j;

                if (grid[i][j] == '/') {
                    res += !uf.unite(topLeft + 1, bottomLeft);
                }
                else if (grid[i][j] == '\\') {
                    res += !uf.unite(topLeft, bottomLeft + 1);
                }
            }
        }

        return res;
    }
};
```