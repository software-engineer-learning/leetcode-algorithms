# Boolean Array Approach

## Intuition

- The key idea is to use a boolean array to mark which characters are allowed. Since we're only dealing with lowercase English letters, we need an array of size 26. Each index in the array will correspond to a character based on its ASCII value.

- Each character has an integer representation called its ASCII value. For example, a has an ASCII value of 97, b is 98, and so on until z, which is 122. We can map each character to an index from 0 to 25 by subtracting the ASCII value of a from the character's ASCII value. For example, c maps to index 2 because the difference between the ASCII values of c (99) and a (97) is 2.

- With this setup, we can loop through each character in every word and check in constant time whether that character is allowed. If any character's index in our boolean array is false, the word isn't consistent. If all characters are marked true, we increase our counter of consistent words.

## Approach

### Hash set

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

### Bitset

- This follow the same principle with the hash set approach, you hash all valid characters into 1 "bucket", but this time instead of an array we use a single variable `mask`.
- This approach works because the problem don't ask for the frequency and only want us to check the existence of a character. So we can set the position of bits inside `mask` based on the valid character's ASCII value minus `'a'` (see above for detailed explaination). Also, because there is only 26 lower-case alphabet characters and an int have 32 bits, we can easily fit all characters inside an int variable.
- Start with initialize our "bucket" `mask = 0` which is an empty bucket with all bit unset.
- Iterate the allowed characters list and set the i-th bit of `mask` based on the position of the character in alphabet. Now we have our bucket filled.
- Iterate the string list, check every characters of each string and doing comparision:
  - `(mask >> (c-'a'))` this code basically move the bits at position (c-'a') to the right most side.
  - `(mask >> (c-'a')) & 1` this check if the right most side exist or not, if it isn't the result will be 0, otherwise it will be 1
  - `bits = (mask >> (c-'a')) & 1` will either be 1 or 0 (true or false)

## Complexity

- Time Complexity: $O(N * M)$, where `N` is the length of `words` array, M is maximum length of all words
- Space Complexity: $O(26)$ where 26 is the number of English lowercase characters.
- Space Complexity (bitmask): O(1) as the valid chars are hashed into `mask` variable

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
### Java

```java
class Solution {
    public int countConsistentStrings(String allowed, String[] words) {
        boolean[] allowedFreq = new boolean[26];

        for (Character c : allowed.toCharArray()) {
            allowedFreq[c - 'a'] = true;
        }
        int result = 0;
        for (String word : words) {
            if (isConsistent(word, allowedFreq)) {
                result += 1;
            }
        }

        return result;
    }

    private boolean isConsistent(String word, boolean[] allowedFreq) {
        for (int i = 0; i < word.length(); ++i) {
            if (!allowedFreq[word.charAt(i) - 'a']) {
                return false;
            }
        }
        return true;
    }
}
```
### C++
```cpp
class Solution {
public:
    int countConsistentStrings(string allowed, vector<string>& words) {
        int mask = 0;
        for(char c : allowed) mask |= 1 << (c - 'a');
        int res = 0;
        for(auto s : words) {
            if(is_valid(s, mask)) res++;
        }
        return res;
    }

    bool is_valid(string s, int mask) {
        for(char c : s) {
            int bit = (mask >> (c - 'a')) & 1;
            if(!bit) return false;
        }
        return true;
    }
};
```