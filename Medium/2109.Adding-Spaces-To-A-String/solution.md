## Intuition

To solve this problem, we can process the input string and insert spaces at the specified indices efficiently

## Approach: Two Pointers

Using two pointers, we can:

- Use one pointer to iterate over the input string `s`.
- Use another pointer to keep track of the current position in the `spaces` array.
- If the current character index matches the current space index from `spaces`, append a space to the result string and move the pointer in the `spaces` array. Otherwise, append the character to the result.
- Append the remaining characters in s after processing all indices in spaces.

## Explanation:

1. **Initialization**:

- Use `ans` to store the resulting string after inserting spaces.
- Keep a pointer `currSpace` to track which space index to process next.

2. **Iterate Through the String**:

- For each character in s, check if the current index matches the next space index in spaces.
- If it does, append a space to `ans` and move the `currSpace` pointer.
- Append the current character to `ans`.

3. **Return result**::

- Convert the `ans` slice of bytes to a string and return it.

## Complexity

- Time complexity: $O(n + m)$ where:
  - n is the length of the string `s`.
  - m is the length of the `spaces` array.
- Space complexity: $O(n + m)$ where `n + m` is the length of `ans` array.

## Code

```go []
func addSpaces(s string, spaces []int) string {
    a := make([]uint8, 0, len(s) + len(spaces))
    for i, j := 0, 0; i < len(s); i++ {
        if j < len(spaces) && spaces[j] == i {
            a = append(a, ' ')
            j++
        }
        a = append(a, s[i])
    }
    return string(a)
}
```
