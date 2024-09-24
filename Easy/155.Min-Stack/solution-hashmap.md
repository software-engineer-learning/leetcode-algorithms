# Intuition

- Implement a stack is easy enough, the problem is to access/update the min value when necessary. If the popped value is equal min value, you need some way to update it with the next minimun value.
- The trick is to use 2 stack, one as the main stack and the other only push the next minimum values. So the minimum value will always stay at the top of the minStack.

## Approach

- Top solutions use stack to implement stack, I find that kinda cheating so I designed the solutions using ArrayList. that it is any harder of fancier.

## Complexity

- Time complexity: $O(1)$ as all the operation is performed on the last element of the array list
- Space complexity: $O(n)$ because in the worst case, every new val put into the stack can be the new minimum i.e **minStack.length == stack.length == 2n**

## Code

```java
class MinStack {
    private ArrayList<Integer> stack;
    private int stackSize;
    private ArrayList<Integer> minStack;
    private int minSize;

    public MinStack() {
        stack = new ArrayList<>();
        stackSize = 0;
        minStack = new ArrayList<>();
        minSize = 0;
    }
    
    public void push(int val) {
        if(minSize > 0 && minStack.get(minSize - 1) >= val) {
            minStack.add(val);
            minSize++;
        }
        if(minSize == 0) {
            minStack.add(val);
            minSize++;
        }
        stack.add(val);
        stackSize++;
    }
    
    public void pop() {
        if(top() == minStack.get(minSize - 1)) {
            minStack.remove(minSize - 1);
            minSize--;
        }
        stack.remove(stackSize - 1);
        stackSize--;
    }
    
    public int top() {
        return stack.get(stackSize - 1);
    }
    
    public int getMin() {
        return minStack.get(minSize - 1);
    }
}
```
