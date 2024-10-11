# Intuition
The problem requires finding which chair the target friend will sit in when they arrive at a party. Each person occupies a chair as they arrive and leaves it when their time is up. The lowest-numbered available chair is always assigned first. Therefore, the goal is to manage the process of chair assignments and releases efficiently to determine which chair the target friend will sit in.

# Approach
1. **Sort the times array** by the arrival times of the friends. This allows processing the events in chronological order.
2. Use two **priority queues**:
   - `availSeats`: Keeps track of the available chairs in ascending order, ensuring that the lowest-numbered available chair is assigned first.
   - `inUseSeats`: Keeps track of which chairs are currently occupied and when they will become available (departure time). The queue is sorted by leave time.
3. **Simulate the process**:
   - For each friend's arrival, release chairs that have become available.
   - If there are available chairs, assign the lowest-numbered one; otherwise, assign a new chair.
   - Check if the current friend is the target friend. If so, return the assigned chair number immediately.

# Complexity
- Time complexity:  
  Sorting the array takes $O(n \log n)$, and processing each friend's arrival and departure with priority queue operations also takes $O(\log n)$. Thus, the overall time complexity is $O(n \log n)$.

- Space complexity:  
  We are using two priority queues, each storing at most `n` elements, leading to a space complexity of $O(n)$.

# Code
```java
class Solution {
    public int smallestChair(int[][] times, int targetFriend) {
        int n = times.length;
        int targetArrivalTime = times[targetFriend][0]; 
        
        Arrays.sort(times, (a, b) -> a[0] - b[0]);
        
        Queue<Integer> availSeats = new PriorityQueue<>();  
        Queue<int[]> inUseSeats = new PriorityQueue<>((a, b) -> a[1] - b[1]);  
        
        int nextSeat = 0;
        
        for (int i = 0; i < n; i++) {
            int arrival = times[i][0];
            int leave = times[i][1];
            
            while (!inUseSeats.isEmpty() && inUseSeats.peek()[1] <= arrival) {
                availSeats.offer(inUseSeats.poll()[2]);
            }
            
            int assignedSeat;
            if (availSeats.isEmpty()) {
                assignedSeat = nextSeat++;
            } else {
                assignedSeat = availSeats.poll(); 
            }
            
            if (arrival == targetArrivalTime) {
                return assignedSeat;
            }
            
            inUseSeats.offer(new int[] { arrival, leave, assignedSeat });
        }
        
        return -1;
    }
}
```