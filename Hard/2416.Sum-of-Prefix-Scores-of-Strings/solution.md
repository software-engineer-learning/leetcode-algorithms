# Intuition

- Doing #208.Implement-trie-prefix-tree question before this is necessary.
- A key insight is that if we can build both the prefixes and their frequency, we can easily query those data to construct our result. A data structure to build prefixes from word/s is a trie.
- Now normally, a trie's node only consists of 2 attributes: a pointer to child nodes and is_word flag for end of word. So we need to modify the trie node to store the frequency of the prefix/es.
- Why this work:
  - A trie build up prefixes by iterate through every characters inside a words and append those into the child node to make up a prefix tree.
  - A trie prefix will use existing word node and only create new child node only when the current character has not yet been added into the trie.
  - From those 2 points, we can check for the frequencies of the prefixes by the time a node is visited.
  - The question ask for the total prefix score for the words, we can just query the frequencies of all prefixes that this word is made of. we can do that by just traverse the trie using the word and add up all the `node->freq` value.

## Approach

### Trie

- Implement your TrieNode class and Trie class.
- We need to modify our TrieNode to add an `int freq` to count the frequencies of current prefixes.
- For this question, we don't really need the `bool is_word`, the cpp implementation only include it for completeness.
- Build the trie from the input `words` array, then traverse the trie using each word, calculate that current word's score to build the result array.

## Complexity

- **Time complexity**: $O(n)$ where n is length of input array.
- **Space complexity**: $O(n)$ where n is length of input array.

## Implementation

```cpp
class Solution {
public:
    class TrieNode {
    public:
        TrieNode* child[26] = {nullptr};
        int freq = 0;
        bool is_word = false;
        TrieNode() {}
    };

    class Trie {
    public:
        TrieNode* root;
        Trie() {
            this->root = new TrieNode();
        }

        void add(string &word) {
            TrieNode* curr = root;
            for(char c : word) {
                if(!curr->child[c-'a']) curr->child[c-'a'] = new TrieNode();
                curr = curr->child[c-'a'];
                curr->freq++;
            }
            curr->is_word = true;
        }
        
        int query(string &word) {
            TrieNode* curr = root;
            int count = 0;
            for(char c : word) {
                if(!curr->child[c-'a']) continue;
                curr = curr->child[c-'a'];
                count += curr->freq;
            }
            return count;
        }

    };

    vector<int> sumPrefixScores(vector<string>& words) {
        Trie tree;
        int n = words.size();
        for(string s : words) {
            tree.add(s);
        }
        vector<int> res;
        for(string s : words) {
            res.push_back(tree.query(s));
        }
        return res;
    }
};
```

```java
// Author: Thomas Luu
class TrieNode {
    TrieNode[] children;
    int wordCount;

    public TrieNode() {
        children = new TrieNode[26]; 
        wordCount = 0;
    }
}

class Trie {
    TrieNode root;

    public Trie() {
        root = new TrieNode();
    }

    public void insert(String word) {
        TrieNode curr = root;
        for (char c : word.toCharArray()) {
            int index = c - 'a';
            if (curr.children[index] == null) {
                curr.children[index] = new TrieNode();
            }
            curr = curr.children[index];
            curr.wordCount++;
        }
    }

    public int search(String word) {
        int score = 0;
        TrieNode curr = root;
        for (char c : word.toCharArray()) {
            int index = c - 'a';
            curr = curr.children[index];
            if (curr == null) {
                return score;
            }
            score += curr.wordCount;
        }
        return score;
    }
}

class Solution {
    public int[] sumPrefixScores(String[] words) {
        int N = words.length;
        int[] ans = new int[N];
        Trie trie = new Trie();
        
        for (String word : words) {
            trie.insert(word);
        }

        for (int i = 0; i < N; i++) {
            ans[i] = trie.search(words[i]);
        }

        return ans;
    }
}
```