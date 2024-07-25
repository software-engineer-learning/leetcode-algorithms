# Intuition

- To solve the problem of counting atoms in a chemical formula string and returning the result in a specified format, we can use a stack-based approach to handle nested parentheses and multiplication factors

# Approach

1. _Parse the String_: We will traverse the string character by character.
2. _Use a Stack_: A stack will help us manage nested parentheses.
3. _Store Counts in a Map_: A map will be used to store the counts of each atom.
4. _Handle Multipliers_: After encountering a closing parenthesis, we will multiply the counts of the atoms within the parentheses by the following number.
5. _Sorting and Formatting_: Finally, we will sort the atoms alphabetically and format the result according to the specified format.

# Complexity

- Time complexity: $O(N + MLogM)$.
- Space complexity: $O(N + M * D)$.

Where:

- N is the length of the formula.
- M is the number of unique atoms (M is much smaller than N).
- D is the maximum depth of nested structures in the formula.

# Code

## Go

```go
import (
    "sort"
    "fmt"
)
func countOfAtoms(formula string) string {
    stack := []map[string]int{}
	stack = append(stack, map[string]int{})
	n := len(formula)

	for i := 0; i < n; {
		if formula[i] == '(' {
			// Push a new map onto the stack
			stack = append(stack, map[string]int{})
			i++
		} else if formula[i] == ')' {
			// Pop the top map from the stack
			top := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			i++

			// Get the number (multiplier)
			multiplier := 0
			for i < n && unicode.IsDigit(rune(formula[i])) {
				multiplier = multiplier*10 + int(formula[i]-'0')
				i++
			}
			if multiplier == 0 {
				multiplier = 1
			}

			// Apply the multiplier to the popped map and add it to the new top map
			for atom, count := range top {
				stack[len(stack)-1][atom] += count * multiplier
			}
		} else {
			// Parse the atom name
			start := i
			i++ // First character is guaranteed to be uppercase
			for i < n && unicode.IsLower(rune(formula[i])) {
				i++
			}
			atom := formula[start:i]

			// Parse the number
			start = i
			count := 0
			for i < n && unicode.IsDigit(rune(formula[i])) {
				count = (count * 10) + int(formula[i]-'0')
				i++
			}
			if count == 0 {
				count = 1
			}

			// Add the atom and its count to the top map
			stack[len(stack)-1][atom] += count
		}
	}

	// The final counts are in the bottom map of the stack
	finalCounts := stack[len(stack) - 1]
	atoms := make([]string, 0, len(finalCounts))
	for atom := range finalCounts {
		atoms = append(atoms, atom)
	}

	// Sort the atoms alphabetically
	sort.Slice(atoms, func(i, j int) bool {
		return atoms[i] < atoms[j]
	})

	// Build the result string
	var result bytes.Buffer
	for _, atom := range atoms {
		result.WriteString(atom)
		if freq := finalCounts[atom];  freq > 1 {
			result.WriteString(fmt.Sprintf("%d", freq))
		}
	}

	return result.String()
}
```
