# Approach 2: Trie with Optimizations
This solution uses a Trie (prefix tree) to efficiently find the longest common prefix between integers from two arrays. The core idea is to insert each number from the first array (`arr1`) into a Trie, and then check for the longest common prefix with each number from the second array (`arr2`).

## Explanation:

### **TrieNode Structure**
- `TrieNode* children[10];`: Each node in the Trie has 10 children, corresponding to digits `0-9`. This structure helps store digit-based paths as numbers are inserted into the Trie.
- `pool[100001];`: This is a **memory pool** used to pre-allocate Trie nodes. Instead of dynamically allocating new nodes during runtime (which is slower), a large block of memory is pre-allocated and used as needed. This avoids performance overhead from memory allocation.

   - **Why use a memory pool?**  
     - In competitive programming or situations with strict performance requirements, frequent memory allocation (using `new`) can be slow. By pre-allocating memory, the program runs faster and uses less system overhead for memory management.

### **Trie Class**
#### **`newNode()` Function**
- This function returns a pointer to a new TrieNode from the pre-allocated `pool`.
- `TrieNode* res = &pool[k++];`: Each call returns a node from the `pool`, incrementing `k` to track the next available node. This eliminates the need for dynamic allocation using `new` and ensures we don’t exceed the memory limit.

- **Initialization of `children`:**  
  - After allocating a new node from the pool, all child pointers (`children[0]` to `children[9]`) are initialized to `nullptr` to indicate there are no children for that node yet.

#### **`insert(int x)` Function**
- **Reversing the Number (`y = y * 10 + x % 10`)**:
  - This part of the code reverses the digits of the number `x` before inserting it into the Trie.
  - `x % 10` extracts the least significant digit of `x`.
  - `y = y * 10 + x % 10;`: Rebuilds `y` in reversed order by moving the current value of `y` one digit to the left (`y * 10`) and adding the current least significant digit (`x % 10`).
  
  - **Why reverse the digits?**  
    - The problem requires comparing the **leftmost** digits of the numbers (i.e., the most significant digits). By reversing the digits before insertion, we process these digits first, making it easier to find common prefixes.

  - **Why initialize `y = 1` and not `y = 0`?**
    - This initialization ensures that the digits of `x` are reversed and processed correctly, particularly when `x` has trailing zeros, which would turn into leading zeros after reversal. If we had initialized `y = 0`, for instance, when `x = 123000`, the result would be `y = 321` instead of `000321`, leading to incorrect results.


#### **`getMaxPrefixLength(int x)` Function**
- This function finds the longest common prefix between `x` and any number in the Trie.
  
  - **Reversing the Number (`y = y * 10 + x % 10`)**:
    - Similar to `insert()`, the digits of `x` are reversed. The reversed `y` is used to traverse the Trie, following the path of common digits from the most significant to the least significant.
  
  - **Trie Traversal**:  
    - We start from the root node and traverse the Trie as long as the corresponding child node exists for the current digit (`y % 10`). Each step down the Trie represents a match in the prefix between `x` and one or more numbers in the Trie.

  - **Why initialize `res = -1`?**:  
    - We start with `res = -1` because, even if there's no match, we will increment it once in the first iteration, then `res = 0`. When the first match is found, the result becomes `1` for one-digit matches, and so on.

### **Solution Class**
- **Inserting all numbers from `arr1` to the Trie**:  
  - Each number in `arr1` is inserted into the Trie.
  
- **Querying the longest common prefix with `arr2`**:  
  - For each number in `arr2`, the function checks the maximum common prefix length between it and all numbers in the Trie using `getMaxPrefixLength()`.

  - The result is updated with the maximum prefix length found for any number in `arr2`.

## Complexity

- **Time complexity**: $O(n \cdot \log_{10}(x) + m \cdot \log_{10}(x))$, where `n` is the size of `arr1` and `m` is the size of `arr2`. 
  - Inserting each number into the Trie takes $O(log_{10}(x))$, where `x` is the number of digits in the number (since `x` is at most `10^8`, it has at most 9 digits).
  - Querying the longest prefix also takes $O(log_{10}(x))$.

- **Space complexity**: $O(n \cdot \log_{10}(x))$, due to the space needed to store the digits of the numbers in the Trie.

## Code

```cpp
struct TrieNode {
    TrieNode* children[10];
};

TrieNode pool[100001];

class Trie {
private:
    int k = 0;
    TrieNode* root = newNode();

    TrieNode* newNode() {
        TrieNode* res = &pool[k++];

        for (int i = 0; i < 10; i++) {
            res->children[i] = nullptr;
        }

        return res;
    }

public:
    void insert(int x) {
        int y = 1;
        while (x) {
            y = y * 10 + x % 10;
            x /= 10;
        }

        TrieNode* curr = root;

        while (y > 1) {
            x = y % 10;
            y /= 10;

            curr->children[x] = curr->children[x] ?: newNode();
            curr = curr->children[x];
        }
    }

    int getMaxPrefixLength(int x) {
        int y = 1;
        while (x) {
            y = y * 10 + x % 10;
            x /= 10;
        }

        TrieNode* curr = root;
        int res = -1;

        while (y > 0 && curr) {
            ++res;
            curr = curr->children[y % 10];
            y /= 10;
        }

        return res;
    }
};

class Solution {
public:
    int longestCommonPrefix(vector<int>& arr1, vector<int>& arr2) {
        Trie tr;
        int res = 0;

        for (auto& x: arr1) tr.insert(x);
        for (auto& x: arr2) res = max(res, tr.getMaxPrefixLength(x));

        return res;
    }
};
```
