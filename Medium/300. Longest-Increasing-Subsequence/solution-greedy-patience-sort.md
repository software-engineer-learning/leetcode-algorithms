
# 1. Initial idea

## 2. Approach

### Top-down (memoization)

- See "solution-topdown.md" for details

### Bottom-up (iterative)

- See "solution-bottomup.md" for details

### [Patience-sort](https://en.wikipedia.org/wiki/Patience_sorting)

- This approach uses patience sort algorithm as a foundation to solve this.
- Think of a simple [Solitaire](https://en.wikipedia.org/wiki/Patience_(game)) game where you have to sort cards from a deck in decreasing order, using multiple zone to stack cards.
![Example](image.png)
- Let's call `curr_val` as the value of the i-th index we are currently evaluating, sub[] as the subsequence we will be building. We can see that in solitaire we have 2 choices (note: in Solitaire, only the smaller cards went into the top of the stack):
  - If we cannot add the current card into the stack/pile, we will create a new pile with that card.
  - In the case we have multiple option to add the card to (curr_val > top_val), we will greedily add it to the left-most stack.
  - The only problem we encounter when simulate those behavior into code is how we can keep track of the top of each stack
  - We can see that we only need to consider the length of each pile, not necessary the correct sequence. So what if we replace the smallest element which >= `curr_val`? For example:
    - nums = [10, 5, 8, 3, 9, 4, 12, 11]
    - Add 10 to the 1st stack, current LIS = 1, sub = [10]
    - Encounter 5 < 10; now, try replace 5 with 10, current LIS = 1, sub = [5]
    - Encounter 8 > 5, create the second stack, LIS = 2, sub = [5, 8]
    - Encounter 3; replace it with the smallest element >= 3, which is 5. Current LIS = 2, sub = [3, 8]
    - Encounter 9, create a third stack, LIS = 3
    - Encounter 4, replace it with the smallest element >= 4, which is 8 -> LIS = 3, sub = [3, 8, 9]
    - Encounter 12, LIS = 4, sub = [3, 8, 9, 12]
    - Encounter 11; replace it with the smallest element >= 12, which is 8 -> LIS = 4, sub = [3, 8, 9, 11]
- As we can see, we can simulate the action of topping the stack with replacing the element, as the LIS will always equal the number of stack we create in Solitaire, it won't affect the result.
- For finding the element to replace, we can use Binary search.

### Complexity analysis

- Time complexity: *O(nlog(n))* - standard sorting complexity, in worst case, we have to run the `find_stack()` function for every element, hence nlogn
- Space complexity: *O(n)* - `vector<int> push_back` is of length *n*.

## 3. Implementation

```C++
class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        vector<int> deck;
        deck.push_back(nums[0]);
        for(int i = 1; i < n; i++) {
            int val = nums[i];
            if(deck.back() >= val) find_stack(deck, val);
            else deck.push_back(val);
        }
        return deck.size();
    }

    void find_stack(vector<int> &deck, int val) {
        int n = deck.size(), left = 0, right = n-1;
        while(left <= right) {
            int mid = left+(right-left)/2;
            int m = deck[mid];
            if(m >= val) {
                right = mid-1;
                continue;
            }
            if(m < val) {
                left = mid+1;
                continue;
            }
        }
        deck[left] = val;
    }
};
```
