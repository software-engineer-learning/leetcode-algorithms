# Intuition

- The goal is to find the number of days one has to wait until a warmer day for each given day's temperature. This can
  be efficiently solved using a stack.

# Approach

## 1. Initialize an array results

- Create an array result of the same length as the input temperatures array to store the answer.
- Use a stack to keep track of the indices of temperatures.

## 2. Iterate Over Temperatures

- For each temperature, pop indices from the stack while the current temperature is greater than the temperature at the
  index stored at the top of the stack. This means we have found a warmer day for the indices being popped.
- For each popped index, calculate the difference between the current index and the popped index, and store it in the
  result array.
- Push the current index onto the stack.

# Complexity

- Time complexity: `O(1)`

- Space complexity: `O(1).`

# Code

```java
  public int[] dailyTemperatures(int[] temperatures) {
    int[] warmer = new int[temperatures.length];
    Stack<Integer> stack = new Stack<>();

    for (int i = 0; i < temperatures.length; i++) {
        while (!stack.isEmpty() && temperatures[stack.peek()] < temperatures[i]) {
            warmer[stack.peek()] = i - stack.pop();
        }

        stack.push(i);
    }

    return warmer;
}
```

