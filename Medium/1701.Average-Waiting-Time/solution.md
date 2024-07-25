# Intuition

The goal is to calculate the average waiting time for customers in a restaurant where the chef can only handle one customer at a time. The key observation is that the chef starts preparing an order either when a customer arrives or when he finishes the previous order, whichever is later. By keeping track of the finish time of the chef and iterating through each customer's arrival and preparation time, we can accumulate the total waiting time and then calculate the average.

<p>&nbsp;</p>

# Approach: Iterative Calculation

We iterate through the list of customers, updating the finish time for each order and calculating the waiting time for each customer. The total waiting time is accumulated and divided by the number of customers to get the average waiting time.

## Explanation:

1. **Initialize Variables**:
   - `finishTime` is initialized to a very small value (`INT_MIN`) to represent the time when the chef will finish the current order.
   - `totalWaitingTime` is initialized to 0 to accumulate the total waiting time of all customers.

2. **Iterate Through Customers**:
   - For each customer `i`:
     - Update `finishTime` to the maximum of the current finish time and the customer's arrival time (`customers[i][0]`), then add the customer's preparation time (`customers[i][1]`). This ensures the chef starts the next order either when he finishes the previous one or when the next customer arrives, whichever is later.
     - Calculate the waiting time for the current customer as `finishTime - customers[i][0]` and add it to `totalWaitingTime`.

3. **Calculate Average Waiting Time**:
   - Return the total waiting time divided by the number of customers.

## Complexity
- Time complexity: $O(n)$, where n is the number of customers. We only iterate through the list once.
- Space complexity: $O(1)$, as we use a constant amount of extra space.

## Code 
```cpp
class Solution {
public:
    double averageWaitingTime(vector<vector<int>>& customers) {
        int finishTime = INT_MIN;
        double totalWaitingTime = 0;

        for (int i = 0; i < customers.size(); i++) {
            finishTime = max(finishTime, customers[i][0]) + customers[i][1];
            totalWaitingTime += finishTime - customers[i][0];
        }

        return totalWaitingTime / customers.size();
    }
};
```