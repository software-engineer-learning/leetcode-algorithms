# Intuition

This problem can be solved by splitting the sentence into words, iterating through each word to check if the given searchWord is a prefix, and returning the index of the first occurrence where this is true.

# Approach

## Splitting the Sentence:

- Use `strings.Fields(sentence)` to split the input sentence into words.

## Iterating Through Words:

- Use `strings.HasPrefix(word, searchWord)` to check if the searchWord is a prefix of the current word.

## Indexing:

- Return the 1-indexed position `(i + 1)` of the first word where searchWord is a prefix.
- If no such word exists, return `-1`.

# Complexity

- Time Complexity: $O(n \cdot m)$ where:
  - `n` is the number of words in the sentence.
  - `m` is the average length of words in the sentence.
- Space Complexity: $O(n)$ where:
  - Splitting the sentence into words requires O(n) additional space.

# Code

## Go

```go []
import "strings"

func isPrefixOfWord(sentence string, searchWord string) int {
    words := strings.Fields(sentence)
    for index, word := range words {
        if strings.HasPrefix(word, searchWord) {
            return index + 1
        }
    }
    return -1
}
```

## Java

```java []
class Solution {
    public int isPrefixOfWord(String sentence, String searchWord) {
        String[] splitted = sentence.split(" ");
        for (int i = 0; i < splitted.length; i++) {
            if (splitted[i].startsWith(searchWord)) {
                return i+1;
            }
        }
        return -1;
    }
}

```
