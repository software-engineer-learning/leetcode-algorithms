# Intuition
- We need to maximize the number of satisfied customers in a bookstore. The owner can keep themselves from being grumpy for a certain number of minutes continuously (minutes). The arrays `customers` and `grumpy` represent the number of customers in each minute and whether the owner is grumpy at that minute, respectively.

# Approach

## 1.Identify Always Satisfied Customers:
- First, we count customers who are satisfied regardless of owner mood. This happen when `grumpy[i]` is 0.
- Simultaneously, we reset the value of `customers[i]` to `0` for these always satisfied customers because their contribution is already counted and we want to focus on the additional we can satisfy by using the non-grumpy minutes.

## 2.Sliding Window Technique:
- Use a sliding window of size `minutes` to find the maximum number of additional customers that can be satisfied by using the non-grumpy minutes.
- Initially calculate the sum for the first `minutes` window.
- Slide the window across the customers array to keep track of the maximum sum of `customers` that can be satisfied by converting grumpy minutes to non-grumpy.

## 3.Combine results:
- Add the always satisfied customers to the maximum additional customers that can be satisfied by using the non-grumpy minutes.

# Complexity

- Time complexity: `O(N).`

- Space complexity: `O(1).`

# Code
```c++
class Solution {
public:
    int maxSatisfied(vector<int>& customers, vector<int>& grumpy, int minutes) {
        int n = customers.size(), satisfied = 0;
        // Calculate the number of always satisfied customers and zero out their count in customers array.
        for(int i = 0; i < n; i++) {
            if(grumpy[i] == 0) {
                satisfied += customers[i];
                customers[i] = 0;
            }
        }
        int i = 0, sum = 0, _max = 0;
        // Calculate the initial sum for the first 'minutes' window
        while(i < minutes) {
            sum += customers[i];
            i++;
        }
        _max = sum;
        // Slide the window across the array
        while(i < n) {
            sum -= customers[i - minutes];  // Subtract the element going out of the window
            sum += customers[i];            // Add the new element coming into the window
            _max = max(_max, sum);          // Update max sum if current window's sum is greater
            i++;
        }
        // Return the total of always satisfied customers and the maximum additional satisfied customers
        return _max + satisfied;
    }
};
```
