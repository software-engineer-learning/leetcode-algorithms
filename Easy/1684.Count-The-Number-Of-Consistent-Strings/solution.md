# Boolean Array Approach

## Intuition

- The key idea is to use a boolean array to mark which characters are allowed. Since we're only dealing with lowercase English letters, we need an array of size 26. Each index in the array will correspond to a character based on its ASCII value.

- Each character has an integer representation called its ASCII value. For example, a has an ASCII value of 97, b is 98, and so on until z, which is 122. We can map each character to an index from 0 to 25 by subtracting the ASCII value of a from the character's ASCII value. For example, c maps to index 2 because the difference between the ASCII values of c (99) and a (97) is 2.

- With this setup, we can loop through each character in every word and check in constant time whether that character is allowed. If any character's index in our boolean array is false, the word isn't consistent. If all characters are marked true, we increase our counter of consistent words.

## Approach

- Initialize a boolean array `seen` of size `26` to store which characters are allowed.
- Iterate through each character in the `allowed` string:

  - Mark the corresponding index in `seen` as true.

- Initialize a variable `count` to store the number of consistent strings.
- Initialize a function which named `isConsistent` with `word` is parameters and return a `boolean` variable:
  - Iterate through each character in `word`:
    - Check if the current character is allowed by accessing the corresponding index in `seen`:
      - If not allowed, return `false` otherwise we continue to iterate.
  - return `true` when meet end of iteration.
- Iterate through each `word` in the `words` array:
  - if `isConsitent(word)` return `true`, increment `count`.
- Return the final value of `count` as the result.

## Complexity

- Time Complexity: $O(N * M)$, where `N` is the length of `words` array, M is maximum length of all words
- Space Complexity: $O(26)$ where 26 is the number of English lowercase characters.

## Code

### Go

```go
func countConsistentStrings(allowed string, words []string) int {
    seen := make([]bool, 26)
    for _, ch := range allowed {
        seen[ch - 'a'] = true
    }
    count := 0
    var isConsistent func(string) bool
    isConsistent = func(word string) bool {
        for _, ch := range word {
        if !seen[ch-'a'] {
            return false
        }
    }
        return true
    };
    for _, word := range words {
        if isConsistent(word) {
            count++
        }
    }
    return count
}
```
