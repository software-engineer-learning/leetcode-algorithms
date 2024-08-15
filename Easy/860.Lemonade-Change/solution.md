## Intuition
The problem requires determining if we can provide the correct change for each customer in a line, given that customers will pay with a $5, $10, or $20 bill. The key is to ensure that for each $10 or $20 bill received, we have enough smaller bills (preferably $5 bills) to give back the correct change.

## Approach
- Initialize two counters, `five` and `ten`, to keep track of the number of $5 and $10 bills we have.
- Iterate through the array of bills:
  - If the bill is $5, increment the `five` counter.
  - If the bill is $10, check if we have at least one $5 bill to give as change. If so, decrement the `five` counter and increment the `ten` counter. If not, return `false`.
  - If the bill is $20, prioritize giving one $10 and one $5 as change (if possible). If not, try to give three $5 bills. If neither is possible, return `false`.
- If we can successfully provide change for all customers, return `true`.

## Complexity
- **Time complexity:** $O(n)$
  - We only loop through the array of bills once.
  
- **Space complexity:** $O(1)$
  - Only a constant amount of extra space is used for the `five` and `ten` counters.

## Code
```java
class Solution {
    public boolean lemonadeChange(int[] bills) {
        int five = 0, ten = 0;
        
        for (int bill : bills) {
            if (bill == 5) {
                five++;
            } else if (bill == 10) {
                if (five == 0) return false;
                five--;
                ten++;
            } else { // bill == 20
                if (ten > 0 && five > 0) {
                    ten--;
                    five--;
                } else if (five >= 3) {
                    five -= 3;
                } else {
                    return false;
                }
            }
        }
        return true;
    }
}
