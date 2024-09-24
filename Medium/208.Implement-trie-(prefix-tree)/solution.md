# Intuition

- This question is asking you to implement a trie data structure, so you should learn about it before trying to do this question
- Trie is a data structure for words/pattern searching in a string. The ideal is that you store each characters inside the string in an independent node, each prefix will point to the next characters.
- At each node, there is a boolean element `is_word` to determine if the current node is the end of a words. For example: apple will be made into `a->p->p->l->e` tree, then when you access the element `is_word` of node `e` it will return true
- You can refer to the below image for better understanding:

![Image taken from cp-algorithms.com/string/aho_corasick.html](image.png)

## Approach

### Build node

- We start by creating our `TrieNode` class, it has 2 elements:
  - A pointer to the next child node, or nullptr if the characters do not exist
  - Boolean `is_word` to determine the current node is the end of a word
- Our trie will always start with a root node of empty string, then it will have pointers to the first character of the input string/s

```cpp
class TrieNode {
public:
    TrieNode* node[26];
    bool is_word = false;

    TrieNode() {
        for(int i = 0; i < 26; i++) node[i] = nullptr;
    }
};
```

- As you can see in the image at the above section, for words "Ran", "Raum", "Rose" they reuse the same "R" node, that is how we save space and simplify our trie data structure. You can either use a **hash bucket int** if the criterias is small enough or use a **HashMap for general case**. A hash bucket int is sufficient for this question.

### Build trie

- A prefix trie has the following functions: add, query (whole words, prefix) and sometime delete. We will only do search and insert for this problem.
- A trie data structure will always start with a root node of empty string, so we will create an attribute root and initialize it as an empty node.

```cpp
TrieNode* root;    
Trie() {
    this->root = new TrieNode();
}
```

- For the insertion, we iterate the trie from root node, and insert the character into its corresponding prefix nodes as a child node.
- After we done creating a tree of the input word, mark the current node as the end of word

```cpp
void insert(string word) {
    TrieNode* curr = root;
    for(char c : word) {
        if(!curr->node[c-'a']) curr->node[c-'a'] = new TrieNode(); // create a new child
        curr = curr->node[c-'a']; // keep moving down
    }
    // we iterate through the word
    curr->is_word = true; // mark current node as the end of the words
}
```

- It should be noted that end of word is not necessarily a leaf node, for example **"book" and "bookworm" both have "book" as prefix, so node "k" is end of word but it still has children nodes.**

### Query the trie

- We can check if a word or a prefix exist inside the trie by leverage the child node position and the `is_word` attribute.
  - If the characters of the query word exist inside the trie, we need to check if the last character/node form a complete word or not. For example we insert "bookworm" inside the trie then query the "book" word, then book should not have been inside the trie and we need to return false.
  - If we query a prefix, we can simple ignore the `is_word`

```cpp
// search word
bool search(string word) {
    TrieNode* curr = root;
    for(char c : word) {
        if(!curr->node[c-'a']) return false;
        curr = curr->node[c-'a'];
    }
    return curr->is_word; // check whether or not the last node "is_word" form a complete word or it is only a prefix
}

// search prefix
bool startsWith(string prefix) {
    TrieNode* curr = root;
    for(char c : prefix) {
        if(!curr->node[c-'a']) return false;
        curr = curr->node[c-'a'];
    }
    return true;
}
```

## Complexity

- Time complexity: $O(n)$ where n is length of the input words
- Space complexity: $O(n)$ where n is length of the input words, trie can store multiple words/string

## Code

```cpp
class Trie {
public:
    class TrieNode {
    public:
        TrieNode* node[26];
        bool is_word = false;

        TrieNode() {
            for(int i = 0; i < 26; i++) node[i] = nullptr;
        }
    };

    TrieNode* root;    
    Trie() {
        this->root = new TrieNode();
    }
    
    void insert(string word) {
        TrieNode* curr = root;
        for(char c : word) {
            if(!curr->node[c-'a']) curr->node[c-'a'] = new TrieNode();
            curr = curr->node[c-'a'];
        }
        curr->is_word = true;
    }
    
    bool search(string word) {
        TrieNode* curr = root;
        for(char c : word) {
            if(!curr->node[c-'a']) return false;
            curr = curr->node[c-'a'];
        }
        return curr->is_word;
    }
    
    bool startsWith(string prefix) {
        TrieNode* curr = root;
        for(char c : prefix) {
            if(!curr->node[c-'a']) return false;
            curr = curr->node[c-'a'];
        }
        return true;
    }
};
```
