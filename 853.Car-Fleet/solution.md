# Intuition
- The main intuition behind this solution is to use a stack to keep track of the times it takes for cars to reach the target, starting from the cars closest to the target and moving backwards. 
- The idea:
  1. The position give is nearer to destination . eg: if position = 8 it is just 4 unit away from destination ie 12. and time taken can be calculated by (float)(target - position)/speed. 
  2. Whether 2 car will collide or not . It can be found by comparing a time taken by cars to reach a destination. 
  3. You should sort the cars on the basis of their position but NOTE: that you need both the speed and position to calculate the time taken by each car to reach destination. 
  4. Last thing which you will be needing is the stack so that you can compare the time taken by the cars and perform some operations based your requirement.
# Approach

## 1. Initialize Position-Time Array
- Create an array `positionTime` of size `target` to store the time of each car at specific position will take to the reach target.


## 2. Calculate Time to Target:

- Calculate the time it takes for each car to reach target using this formula:
  - time = (target - position[i]) / speed[i]
## 3. Use a Stack to Track Fleets
- For each valid position, check if the stack is not empty and the current car’s time is greater than or equal to the time on the stack’s top. If so, pop the stack (as this car will merge into the fleet represented by the stack’s top).

# Complexity

- Time complexity: `O(n)`

- Space complexity: `O(n).`

# Code

```java
 public int carFleet(int target, int[] position, int[] speed) {

  float[] positionTime= new float[target];

  for (int i = 0; i < position.length; i++) {
    float time = (target - position[i]) / (float) speed[i];
    positionTime[position[i]] = time;
  }

  Stack<Float> stackFleet = new Stack<>();

  for (int i = 0; i < target; i++) {
    if(positionTime[i] == 0) continue;
    while (!stackFleet.isEmpty() && stackFleet.peek() <= positionTime[i]) {
      stackFleet.pop();
    }

    stackFleet.push(positionTime[i]);
  }

  return stackFleet.size();
```

