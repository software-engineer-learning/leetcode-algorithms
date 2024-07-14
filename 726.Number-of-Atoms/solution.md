# Intuition

To solve the problem of counting atoms in a chemical formula, we can use a stack to manage the multiplicative effects of parentheses and a map to keep track of the count of each atom. By traversing the formula from right to left, we handle digits, elements, and parentheses in a way that ensures correct multiplication and aggregation of atom counts.

<p>&nbsp;</p>

# Approach 1: Stack + Map

## Explanation:

1. **Initialization**:
   - Use a **TreeMap** to store the frequency of each element.
   - Use a **stack** to manage the multiplicative effects of nested parentheses, initializing it with 1.
   - Initialize variables to manage current count (`curr`), exponent (`expo`), and length of the current element (`elemLen`).

2. **Traverse the formula from right to left**:
   - **Handling closing parentheses ')'**:
     - Push the product of the current count (or 1 if none) and the top of the stack onto the stack.
     - Reset `curr` to 0 and `expo` to 1.
   - **Handling opening parentheses '('**:
     - Pop the top of the stack to remove the effect of the last closing parenthesis.
   - **Handling digits**:
     - Accumulate the digit into `curr` using `expo` to account for the position of the digit.
     - Update `expo` to handle the next digit position.
   - **Handling lowercase letters**:
     - Increment `elemLen` to account for multi-character element names.
   - **Handling uppercase letters (element names)**:
     - Use `elemLen` to determine the full element name.
     - Update the count of the element in the map by multiplying with the top of the stack.
     - Reset `curr`, `expo`, and `elemLen` for the next element.

3. **Construct the result string**:
   - Iterate through the map in sorted order of element names.
   - Append each element and its count (if greater than 1) to the result string.

## Complexity
- Time complexity: $O(n \log n)$, where `n` is the length of the formula.
- Space complexity: $O(n)$

## Code 
```cpp
class Solution {
public:
    string countOfAtoms(string& s) {
        map<string, int> freq;
        stack<int> st({1});

        int elemLen = 0;
        int curr = 0, expo = 1;

        for (int i = (int)s.size() - 1; i >= 0; i--) {
            if (s[i] == ')') {
                st.push((curr ? curr : 1) * st.top());
                curr = 0;
                expo = 1;
            }
            else if (s[i] == '(') {
                st.pop();
            }
            else if (s[i] <= '9') {
                curr += (s[i] - '0') * expo;
                expo *= 10;
            }
            else if (s[i] >= 'a') {
                ++elemLen;
            }
            else {
                freq[s.substr(i, ++elemLen)] += (curr ? curr : 1) * st.top();
                
                curr = 0;
                expo = 1;
                elemLen = 0;
            }
        }

        string res;
        for (auto& [elem, count]: freq) {
            res += elem;
            if (count > 1) res += to_string(count);
        }

        return res;
    }
};
```