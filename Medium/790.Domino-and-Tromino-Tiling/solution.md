# Intuition

This problem involves dynamic programming. We aim to count how many ways we can tile a `2 x n` board using **dominos** (`2 x 1`) and **trominos** (L-shaped tiles covering 3 squares). The tricky part is handling the additional configurations created by trominos and their rotations.

<p>&nbsp;</p>

# Approach 1: Dynamic Programming

We define two arrays:

* `f[i]`: Number of ways to completely tile a `2 x i` board.
* `g[i]`: Number of ways to tile a `2 x i` board **with one square missing in the corner**, which helps us model tromino transitions.

## Explanation:

1. **Base Cases**:

   * `f[1] = 1`: Only one way using a vertical domino.
   * `f[2] = 2`: Either two vertical dominos or two horizontal dominos.
   * `g[1] = 1`: Only one way using a tromino.
   * `g[2] = 2`: Either one vertical dominos + one tromino or one tromino + one horizontal dominos.

2. **Transition for `f[i]`**:

   * `f[i - 1]`: Add a vertical domino to a `2 x (i - 1)` board.
   * `f[i - 2]`: Add two horizontal dominos to a `2 x (i - 2)` board.
   * `2 * g[i - 2]`: Add a tromino in either of two orientations to extend a partial board of size `i - 2`.

   So:

   ```cpp
   f[i] = f[i - 1] + f[i - 2] + 2 * g[i - 2];
   ```

3. **Transition for `g[i]`**:

   * We derive `g[i]` from previously complete (`f[i - 1]`) or incomplete (`g[i - 1]`) states:

   ```cpp
   g[i] = f[i - 1] + g[i - 1];
   ```

4. **Modulo Operation**:
   Since the result can be large, all operations are done modulo $10^9 + 7$.

## Complexity

* Time complexity: $O(n)$ — We compute each state up to `n`.
* Space complexity: $O(n)$ — Arrays `f` and `g` are of size `n + 1`.

## Code

```cpp
const int MOD = 1e9 + 7;

class Solution {
public:
    int numTilings(int n) {
        if (n == 1) return 1;

        int f[1001] = {0, 1, 2}, g[1001] = {0, 1, 2};

        for (int i = 3; i <= n; i++) {
            f[i] = ((f[i - 1] + f[i - 2]) % MOD + 2 * g[i - 2] % MOD) % MOD;
            g[i] = (f[i - 1] + g[i - 1]) % MOD;
        }

        return f[n];
    }
};
```

<p>&nbsp;</p>

# Approach 2: Space-Optimized Dynamic Programming

Instead of storing full arrays `f[0..n]` and `g[0..n]`, we only keep the **last three values** needed to compute the current state — using rotating indices or just reassigning variables in place.

## Explanation:

We keep:

* `f[0] = f[i - 2]`, `f[1] = f[i - 1]`, `f[2] = f[i]`
* `g[0] = g[i - 2]`, `g[1] = g[i - 1]`, `g[2] = g[i]`

Then, in each iteration from `i = 3` to `n`, we:

1. Shift values:

   * Move `f[1] → f[0]`, `f[2] → f[1]`, and compute new `f[2]`
   * Similarly for `g`

2. Use the same recurrence formulas:

   * `f[i] = f[i - 1] + f[i - 2] + 2 * g[i - 2]`
   * `g[i] = f[i - 1] + g[i - 1]`

   So:

   ```cpp
   f[2] = ((f[1] + f[0]) % MOD + 2 * g[0] % MOD) % MOD;
   g[2] = (f[1] + g[1]) % MOD;
   ```

3. After the loop, `f[2]` holds the result `f[n]`.

## Complexity

* Time complexity: $O(n)$ — Still iterating from 3 to `n`.
* Space complexity: $O(1)$ — We only use constant space (`f[3]` and `g[3]`).

## Code

```cpp
const int MOD = 1e9 + 7;

class Solution {
public:
    int numTilings(int n) {
        if (n == 1) return 1;

        int f[] = {0, 1, 2}, g[] = {0, 1, 2};

        for (int i = 3; i <= n; i++) {
            f[0] = f[1]; f[1] = f[2];
            g[0] = g[1]; g[1] = g[2];

            f[2] = ((f[1] + f[0]) % MOD + 2 * g[0] % MOD) % MOD;
            g[2] = (f[1] + g[1]) % MOD;
        }

        return f[2];
    }
};
```

<p>&nbsp;</p>

# Approach 3: Matrix Exponentiation

This approach treats the tiling recurrence as a **linear recurrence**, and solves it using **matrix exponentiation**. This is much faster for large `n`, reducing time complexity from linear to logarithmic: $O(\log n)$.

We encode the recurrence:

* `f(n) = f(n-1) + f(n-2) + 2 * g(n-2)`
* `g(n) = f(n-1) + g(n-1)`

into a **4x4 matrix transformation** to move from state `n` to `n+1`.

Let the state vector be:

```
V(n) = [f(n), f(n-1), g(n), g(n-1)]ᵗ
```

Then there's a matrix `A` such that:

```
V(n) = A × V(n - 1)
```

So:

```
V(n) = A^(n - 2) × V(2)
```

Because we know:

* `f(2) = 2`, `f(1) = 1`
* `g(2) = 2`, `g(1) = 1`

## Explanation:

1. **Matrix Definition**:
   The matrix `A` is:

   ```cpp
   { 1, 1, 0, 2 },  // f(i) = f(i-1) + f(i-2) + 2 * g(i-2)
   { 1, 0, 0, 0 },  // shift
   { 1, 0, 1, 0 },  // g(i) = f(i-1) + g(i-1)
   { 0, 0, 1, 0 }   // shift
   ```

2. **Base Vector**:

    ```cpp
    base = {
        2, // f(2)
        1, // f(1)
        2, // g(2)
        1, // g(1)
    }
    ```

3. **Matrix Exponentiation**:
   We compute `A^(n-2)` in $O(\log n)$ time using exponentiation by squaring.

4. **Final Result**:
   Multiply the powered matrix with the base vector:

   ```cpp
   res = A.pow(n - 2) * base;
   return res[0][0]; // which is f(n)
   ```

## Complexity

* Time complexity: $O(\log n)$ — from matrix exponentiation.
* Space complexity: $O(1)$ — constant space for fixed 4x4 matrices.

## Code

```cpp
const int MOD = 1e9 + 7;

template<typename T>
class Matrix {
public:
    vector<vector<T>> data;
    int rows, cols;

    Matrix(int rows, int cols, T val = 0): rows(rows), cols(cols) {
        data.assign(rows, vector<T>(cols, val));
    }

    Matrix(initializer_list<initializer_list<T>> init) {
        rows = init.size();
        cols = init.begin()->size();
        data.reserve(rows);
      
        for (auto& row: init) {
            assert(row.size() == cols);
            data.emplace_back(row);
        }
    }

    static Matrix identity(int n) {
        Matrix res(n, n);

        for (int i = 0; i < n; i++) {
            res[i][i] = 1;
        }

        return res;
    }

    Matrix operator*(const Matrix& other) const {
        assert(cols == other.rows);

        Matrix res(rows, other.cols);
      
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < other.cols; j++) {
                for (int k = 0; k < cols; k++) {
                    res[i][j] = (res[i][j] + 1LL * data[i][k] * other[k][j]) % MOD;
                }
            }
        }

        return res;
    }

    Matrix& operator*=(const Matrix& other) {
        *this = (*this) * other;
        return *this;
    }

    Matrix pow(long long expo) const {
        assert(rows == cols);

        Matrix res = identity(rows);
        Matrix base = *this;

        while (expo > 0) {
            if (expo & 1) res *= base;
            base *= base;
            expo >>= 1;
        }

        return res;
    }

    vector<T>& operator[](int i) {
        return data[i];
    }

    const vector<T>& operator[](int i) const {
        return data[i];
    }
};

class Solution {
public:
    int numTilings(int n) {
        if (n == 1) return 1;

        Matrix<int> base = {
            { 2 }, // f(2)
            { 1 }, // f(1)
            { 2 }, // g(2)
            { 1 }, // g(1)
        };

        Matrix<int> A = {
            { 1, 1, 0, 2 }, // f(i) = f(i - 1) + f(i - 2) + 2 * g(i - 2)
            { 1, 0, 0, 0 },
            { 1, 0, 1, 0 }, // g(i) = f(i - 1) + g(i - 1)
            { 0, 0, 1, 0 },
        };

        auto res = A.pow(n - 2) * base;
        return res[0][0];
    }
};
```
