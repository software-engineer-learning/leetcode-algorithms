# Approach 1 - Dynamic Programming + Trie

## Intuition

To solve this problem, we can use dynamic programming + trie to break down the string s optimally and minimize the number of extra characters.

## Approach

**Trie Construction**

- First, we’ll build a Trie from the given dictionary of words.

**Dynamic Programming(DP)**

- We define `dp[i]` as the minimum number of extra characters when breaking the substring `s[i:n]` into valid `dictionary` words.
- We will traverse the string `s` and for each index `i`, attempt to match as many valid words as possible from the Trie, updating the `dp` array based on the number of extra characters required.

**Base Case**

- The base case is when `i == n` (end of the string), where `dp[n] = 0` because no extra characters are left.

**Final Result**

- The value dp[0] will give us the minimum number of extra characters when breaking the string optimally.

## Complexity

Let N be the total characters in the string.
Let M be the average length of the strings in dictionary.
Let K be the length of the dictionary.

- **Time complexity**: $O(N^2 +M.K)$. The two nested for loops that are being used for the dynamic programming operation cost $O(N^2)$. Building the trie costs $O(M.K)$.
- **Space comlexity**: $O(N + M.K)$ The Trie used to store the strings in dictionary will incur a cost of $O(M.K)$. The dp array will incur a cost of $O(N)$.

## Solution

### Go

```go
type TrieNode struct {
    children [26]*TrieNode
    isWord bool
}

type Trie struct {
    root *TrieNode
}

func NewTrie() *Trie {
    return &Trie {
        root: &TrieNode{},
    }
}

func (t *Trie) Insert(word string) {
    node := t.root
    for _, ch := range word {
        pos := ch - 'a'
        if node.children[pos] == nil {
            node.children[pos] = &TrieNode{}
        }
        node = node.children[pos]
    }
    node.isWord = true
}

func (t *Trie) SearchPrefix(s string, start int) []int {
    node := t.root
    matches := make([]int, 0)
    for i := start; i < len(s); i++ {
        pos := s[i] - 'a'
        if node.children[pos] == nil {
            break
        }
        node = node.children[pos]
        if node.isWord {
            matches = append(matches, i)
        }
    }
    return matches
}
func minExtraChar(s string, dictionary []string) int {
    trie := NewTrie()
    for _, word := range dictionary {
        trie.Insert(word)
    }
    n := len(s)
    dp := make([]int, n + 1)
    dp[n] = 0
    for i := n - 1; i >= 0; i-- {
        dp[i] = dp[i + 1] + 1
        for _, j := range trie.SearchPrefix(s, i) {
            dp[i] = min(dp[i], dp[j + 1])
        }

    }
    return dp[0]
}
```
