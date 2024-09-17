# Intuition
The problem can be visualized as a grid traversal, where we search for words within the grid by moving in four possible directions (up, down, left, right). The challenge is efficiently finding all the words from a given list on the board, which suggests using a Trie data structure for quick lookups as we traverse the grid.

# Approach
We can use a Trie to store all the words. For each cell in the board, we perform a depth-first search (DFS), checking whether the current sequence of letters forms a word in the Trie. If a word is found, it is added to the result. The DFS explores all possible paths by moving in four directions from each cell, marking visited cells to prevent cycles and backtracking once all possible paths from a cell are explored.

The Trie is used to optimize word lookups during the DFS, ensuring that we prune the search when a prefix doesn't match any word. This reduces redundant searches and improves performance.

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