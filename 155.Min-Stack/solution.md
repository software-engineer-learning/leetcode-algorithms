# Intuition
- A stack typically follows a Last In, First Out (LIFO) principle. In addition to the regular stack operations (push, pop, top), the Min Stack must be able to quickly retrieve the minimum element present in the stack at any given time.

# Approach

## 1. Push Operation
- If the value to be pushed is less than or equal to the current minimum:
  - push the current `min` into stack. This saves the previous `min`
  - Assign new minimum value to `min` variable.
- Push the new value to the stack
## 2. Pop Operation
- Pop the top value from the stack
- If the popped value equals the current `min`, it means the current `min` will be removed from stack. To restore the previous `min`:
  - Pop twice and change the current `min` to the last minimum `min` in the stack 
## 3. Top Operation:
- Return the top value of the stack
##  4. Get Minimum Operation
- Return the current minimum value stored in `min`
# Complexity

- Time complexity: `O(1)`

- Space complexity: `O(1).`

# Code
```java
public class MinStack {
  private Stack<Integer> stack;
  private Integer min;

  public MinStack() {
    stack = new Stack<>();
    min = Integer.MAX_VALUE;
  }

  public void push(int val) {
    if (val <= min) {
      stack.push(min);
      min = val;
    }
    stack.push(val);
  }

  public void pop() {
    if (stack.pop().equals(min)) {
      min = stack.pop();
    }
  }

  public int top() {
    return stack.peek();
  }

  public int getMin() {
    return min;
  }
}
```

