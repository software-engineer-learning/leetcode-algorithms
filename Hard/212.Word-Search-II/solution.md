# Intuition

- The problem can be visualized as a grid traversal, where we search for words within the grid by moving in four possible directions (up, down, left, right). The challenge is efficiently finding all the words from a given list on the board, which suggests using a Trie data structure for quick lookups as we traverse the grid.

# Approach

- We can use a Trie to store all the words. For each cell in the board, we perform a depth-first search (DFS), checking whether the current sequence of letters forms a word in the Trie. If a word is found, it is added to the result. The DFS explores all possible paths by moving in four directions from each cell, marking visited cells to prevent cycles and backtracking once all possible paths from a cell are explored.
- The Trie is used to optimize word lookups during the DFS, ensuring that we prune the search when a prefix doesn't match any word. This reduces redundant searches and improves performance.

# Complexity

- Time complexity:  
  The time complexity is $O(m \times n \times 4^l)$, where `m` is the number of rows, `n` is the number of columns, and `l` is the maximum length of a word. The DFS explores up to 4 directions from each cell, and each direction can continue up to `l` steps in the worst case.
  
- Space complexity:  
  The space complexity is $O(n \times k)$, where `n` is the number of words and `k` is the average length of the words in the Trie. Additional space is required for the recursion stack in DFS, which can be up to the maximum word length.

# Code
```java
class Solution {
    class TrieNode {
        Map<Character, TrieNode> children = new HashMap<>();
        String word = null;
        
        public void addWord(String word) {
            TrieNode node = this;
            for (char c : word.toCharArray()) {
                if (!node.children.containsKey(c)) {
                    node.children.put(c, new TrieNode());
                }
                node = node.children.get(c);
            }
            node.word = word;
        }
    }

    public List<String> findWords(char[][] board, String[] words) {
        TrieNode root = new TrieNode();
        for (String word : words) {
            root.addWord(word);
        }

        int ROWS = board.length;
        int COLS = board[0].length;
        Set<String> result = new HashSet<>();
        boolean[][] visit = new boolean[ROWS][COLS];

        for (int r = 0; r < ROWS; r++) {
            for (int c = 0; c < COLS; c++) {
                dfs(r, c, root, board, visit, result);
            }
        }

        return new ArrayList<>(result);
    }

    private void dfs(int r, int c, TrieNode node, char[][] board, boolean[][] visit, Set<String> result) {
        if (r < 0 || c < 0 || r >= board.length || c >= board[0].length || visit[r][c] || !node.children.containsKey(board[r][c])) {
            return;
        }

        visit[r][c] = true;
        node = node.children.get(board[r][c]);

        if (node.word != null) {
            result.add(node.word);
        }

        dfs(r - 1, c, node, board, visit, result); // up
        dfs(r + 1, c, node, board, visit, result); // down
        dfs(r, c - 1, node, board, visit, result); // left
        dfs(r, c + 1, node, board, visit, result); // right

        visit[r][c] = false;
    }
}
```

```Cpp
C++
class Solution {
public:

    class TrieNode {
    public:
        TrieNode* child[26];
        bool word;
        
        TrieNode() {
            word = false;
            for(int i = 0; i < 26; i++) child[i] = nullptr;
        }
    };

    class Trie {
    public:
        TrieNode* root;
        Trie() {
            root = new TrieNode();
        }

        void add(string s) {
            TrieNode* curr = root;
            for(char c : s) {
                int key = c-'a';
                if(!curr->child[key]) curr->child[key] = new TrieNode();
                curr = curr->child[key];
            }
            curr->word = true;
        }

        bool search(string s) {
            TrieNode* curr = root;
            for(char c : s) {
                int key = c-'a';
                if(!curr->child[key]) curr->child[key] = new TrieNode();
                curr = curr->child[key];
            }
            return curr->word;
        }
    };

    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        vector<string> res;
        set<string> set;
        Trie* trie = new Trie();
        
        for(string s : words) trie->add(s);

        int m = board.size(), n = board[0].size();
        for(int row = 0; row < m; row++) {
            for(int col = 0; col < n; col++) {
                vector<vector<bool>> visited(m, vector<bool>(n, false));
                string s;
                move(board, row, col, visited, set, trie->root, s, res);
            }
        }
        return res;
    }

    void move(vector<vector<char>>& board, int row, int col, vector<vector<bool>> &visited, set<string> &set, TrieNode* node, string s, vector<string> &res) {
        bool out_bound = min(row, col) < 0 || row >= board.size() || col >= board[0].size();
        if(out_bound) return;
        if(visited[row][col]) return;
        int key = board[row][col] - 'a';
        if(!node->child[key]) return;
        visited[row][col] = true;
        s += board[row][col];
        node = node->child[key];
        if(node->word && set.count(s) == 0) {
            set.insert(s);
            res.push_back(s);
        }

        move(board, row, col+1, visited, set, node, s, res);
        move(board, row+1, col, visited, set, node, s, res);
        move(board, row, col-1, visited, set, node, s, res);
        move(board, row-1, col, visited, set, node, s, res);
        visited[row][col] = false;
        s.pop_back();
    }
};
```
