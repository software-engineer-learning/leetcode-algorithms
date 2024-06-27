# Intuition
- As we know that the potential speed that Koko eating bananas at `k` is going to between 1 that's the minimum possible
- The maximum possible eating speed is the largest size of largest pile, as eating faster than that number is unnecessary
- We use the **Binary Search** approach because it effectively narrows down the possible values for eating speed `k` to find the minimum speed
# Approach

## 1. Determine the search range
- Initial `left` pointer to 1 and the `right` pointer to the size of the largest pile

## 2. Binary Search
- While the `left` < `right`
  - Compute the middle point (mid) of the current range as the potential eating speed. 
  - Check if Koko can eat all the bananas with this eating speed (mid) using the helper function checkKoKoCanEat. 
  - If she can eat all the bananas within h hours, then try a smaller eating speed by moving the right pointer to mid - 1. 
  - If she cannot eat all the bananas within h hours, then increase the eating speed by moving the left pointer to mid + 1.
## 3. Helper Function (`checkKoKoCanEat`):
- Return true if the total hours required are less than or equal to h, otherwise return false.

# Complexity

- Time complexity: `O(nlog(m))`

- Space complexity: `O(1)`

# Code

```java
 public int minEatingSpeed(int[] piles, int h) {
  int right = piles[0];
  int left = 1;
  for (int i = 1; i < piles.length; i++) {
    right = Math.max(piles[i], right);
  }

  System.out.println(right);

  while (left <= right) {
    int mid = left + ((right - left) / 2);

    if (checkKoKoCanEat(piles, mid, h)) right = mid - 1;
    else left = mid + 1;
  }

  return left;
}

private boolean checkKoKoCanEat(int[] piles, int k, int h) {
  int hours = 0;

  for (int pile : piles) {
    int div = pile / k;
    hours += div;
    if (pile % k != 0) {
      hours += 1;
    }
  }

  return hours <= h && hours > 0;
}
```
