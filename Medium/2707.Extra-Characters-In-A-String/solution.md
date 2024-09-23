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

# Approach 2 - Dynamic Programming + HashSet

# Intuition
The problem is about minimizing the number of extra characters needed to form a string from a given dictionary of words. My first thought was to approach it using dynamic programming, where we try to partition the string into substrings that are either in the dictionary or minimize the number of unmatched characters.

# Approach
We use dynamic programming to solve this problem. The idea is to traverse the string and for each index, try all possible substrings starting from that index. If a substring exists in the dictionary, we recursively check the next index and update our result. Otherwise, we move to the next character and increment the count of extra characters. To avoid redundant calculations, we use a DP array to store results for subproblems (i.e., starting from a given index). The recursion ensures we explore all valid substring partitions, while the DP array optimizes performance by avoiding recomputation.

# Complexity
- Time complexity:  
  The time complexity is $O(n^2)$, where $$n$$ is the length of the string. This is because for each starting index, we check all possible substrings and perform dictionary lookups in constant time.

- Space complexity:  
  The space complexity is $O(n)$, where $$n$$ is the length of the string. We store the DP array of size `n+1` and a dictionary, but the dictionary size is constant for any input.

# Code
```java
class Solution {
    private int N;
    private String s;
    private Set<String> dictionary;
    private int[] dp;
    private static final int INF = Integer.MAX_VALUE;

    public int minExtraChar(String s, String[] dictionary) {
        N = s.length();
        this.s = s;
        this.dictionary = new HashSet<>();
        for (String word : dictionary) {
            this.dictionary.add(word);
        }
        dp = new int[N + 1]; 
        
        for (int i = 0; i <= N; i++) {
            dp[i] = -1;
        }

        return calculateMinLength(0);
    }

    private int calculateMinLength(int index) {
        if (index >= N) {
            return 0;
        }
        
        if (dp[index] != -1) {
            return dp[index]; 
        }

        int best = INF;
        
        for (int i = index + 1; i <= N; i++) {
            String substring = s.substring(index, i);
            if (dictionary.contains(substring)) {
                best = Math.min(best, calculateMinLength(i)); 
            }
        }

        best = Math.min(best, calculateMinLength(index + 1) + 1);

        dp[index] = best;
        return best;
    }
}
```