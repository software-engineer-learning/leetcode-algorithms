# Intuition
When given a mathematical expression containing numbers and operators, one approach is to explore different ways to insert parentheses and evaluate the expression. The key insight is that each operator in the expression can be treated as a "split point," dividing the expression into two parts. By recursively solving the sub-expressions on the left and right of each operator, we can compute all possible outcomes.

# Approach
1. **Parsing the expression**: We first parse the expression into a list of numbers and operators. This allows us to handle the expression in a structured way.
2. **Recursive divide-and-conquer**: For each operator in the expression, recursively calculate the result for the left and right parts of the expression split by the operator. Then, combine the results from both parts using the operator. This ensures that all possible ways to parenthesize the expression are considered.
3. **Base case**: When there are no operators left between the numbers, we return the number as a single-element result.
4. **Combine results**: For each operator, the results from the left and right sub-expressions are combined using the operator. This is done for every possible operator in the expression.

# Complexity
- Time complexity:  
  The time complexity is $O(n \cdot 2^n)$, where `n` is the number of operators. This is because each operator can lead to multiple recursive splits, and each sub-expression has two possible outcomes based on the recursion.
  
- Space complexity:  
  The space complexity is $O(2^n)$ due to the recursion depth and the storage required for storing results of sub-problems.

# Code
```java
class Solution {
    public List<Integer> diffWaysToCompute(String expression) {
        List<String> syntax = new ArrayList<>();
        int num = 0;
        boolean numberFound = false;
        String operators = "*+-";
        
        for (Character c : expression.toCharArray()) {
            if (operators.contains(c.toString())) {
                syntax.add(String.valueOf(num));
                num = 0;
                numberFound = false;
                syntax.add(String.valueOf(c));
            } else {
                num = num * 10 + (c - '0');
                numberFound = true;
            }
        }
        
        if (numberFound) {
            syntax.add(String.valueOf(num));
        }
        
        return calculate(0, syntax.size() - 1, syntax);
    }
    
    private List<Integer> calculate(int left, int right, List<String> syntax) {
        if (left == right) {
            return Collections.singletonList(Integer.valueOf(syntax.get(left)));
        }
        
        List<Integer> ans = new ArrayList<>();
        
        for (int i = left + 1; i < right; i += 2) {
            List<Integer> leftAns = calculate(left, i - 1, syntax);
            List<Integer> rightAns = calculate(i + 1, right, syntax);
            
            String operator = syntax.get(i);
            for (Integer l : leftAns) {
                for (Integer r : rightAns) {
                    if (operator.equals("*")) {
                        ans.add(l * r);
                    } else if (operator.equals("-")) {
                        ans.add(l - r);
                    } else if (operator.equals("+")) {
                        ans.add(l + r);
                    }
                }
            }
        }
        return ans;
    }
}
```