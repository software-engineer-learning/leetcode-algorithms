# Intuition

<!-- Describe your first thoughts on how to solve this problem. -->

# Approach

## 1.Initial check:
-   We need to sort the `position` to make the placement of ball easier.
## 2.Binary Search:
-   Use binary search to determine the largest minium distance. The search range will be from 1 to the maximum possiable distance between the first and last baskets divided by the number of balls minus one
    (last baskets divided by the number of balls minus one because: the result always greater than or equal to average of distance)
## 3.possible function:
-   The `canPlaceBalls` function check if it's possible to place all m balls with at least `minDist` distance apart.
## 4.Adjust Binary Search Boundaries:
-   Depending on whether it's possible to place the balls with the current middle distance, we adjust the binary search boundaries.
## 5.Return result:
-   The result will be the largest mid value for which the balls can be placed.
## Notice:
-   Instead of using ` mid = left + (right - left) / 2;` could causes overflow , we should using ` mid = left + (right - left) / 2;` , i ensure that the midpoint is safe from overflow.
# Complexity
- Time complexity: `O(N * log(N)).`
- Space complexity: `O(N).`

# Code
```C++
class Solution {
public:
bool canPlaceBalls(const vector<int>& position, int m, int minDist) {
    int count = 1;
    int lastPosition = position[0];

    for (int i = 1; i < position.size(); ++i) {
        if (position[i] - lastPosition >= minDist) {
            count++;
            lastPosition = position[i];
            if (count >= m) {
                return true;
            }
        }
    }

    return count >= m;
}

int maxDistance(vector<int>& position, int m) {
    ios::sync_with_stdio(0);cin.tie(0);cout.tie(0);
    sort(position.begin(), position.end());
    int left = 1;
    int right = (position.back() - position[0]) / (m -  1);
    int result = 0;

    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (canPlaceBalls(position, m, mid)) {
            result = mid;
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return result;
}
};
```
