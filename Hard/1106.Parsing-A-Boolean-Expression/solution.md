# Intuition
When parsing a boolean expression consisting of logical operators (`!`, `&`, `|`) and boolean values (`t`, `f`), we need to process nested expressions within parentheses in a structured manner. Using a stack allows us to handle the nested structure, where we can push operators and operands onto the stack and process sub-expressions when we encounter a closing parenthesis.

# Approach
1. **Stack for operators and values**: As we iterate through the expression, we push operators and boolean values onto the stack. We skip commas and opening parentheses since they don’t affect the logical computation.
2. **Processing sub-expressions**: When encountering a closing parenthesis `)`, we pop the stack to gather all operands of the current sub-expression. The operator for this sub-expression is also popped, and we compute the result based on the operator.
3. **Evaluating expressions**: For each operator:
   - `!` (negation) expects one value and flips it.
   - `&` (AND) returns true if all values are `t`; otherwise, it returns false.
   - `|` (OR) returns true if at least one value is `t`; otherwise, it returns false.
4. **Final result**: Once the entire expression is processed, the remaining value on the stack is the result of the boolean expression.

# Complexity
- Time complexity:  
  $O(n)$
  We iterate through each character of the expression once, and stack operations are efficient with a constant time complexity for push and pop operations.

- Space complexity:  
  $O(n)$ 
  The space used by the stack depends on the size of the expression, with at most one stack frame for each character.

# Code
```java
class Solution {
    public boolean parseBoolExpr(String expression) {
        Stack<Character> stack = new Stack<>();

        for (char c : expression.toCharArray()) {
            if (c == ',' || c == '(') {
                continue;
            } else if (c == ')') {
                List<Character> subExpr = new ArrayList<>();
                
                while (stack.peek() != '!' && stack.peek() != '&' && stack.peek() != '|') {
                    subExpr.add(stack.pop());
                }
                
                char operator = stack.pop();
                boolean result = evaluateSubExpr(subExpr, operator);
                
                stack.push(result ? 't' : 'f');
            } else {
                stack.push(c);
            }
        }

        return stack.pop() == 't';
    }

    private boolean evaluateSubExpr(List<Character> subExpr, char operator) {
        if (operator == '!') {
            return subExpr.get(0) == 'f';
        } else if (operator == '&') {
            for (char c : subExpr) {
                if (c == 'f') {
                    return false;
                }
            }
            return true;
        } else if (operator == '|') {
            for (char c : subExpr) {
                if (c == 't') {
                    return true;
                }
            }
            return false;
        }
        return false;
    }
}
```