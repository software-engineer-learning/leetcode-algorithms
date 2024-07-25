# Intuition

<!-- Describe your first thoughts on how to solve this problem. -->

# Approach

## 1.Initial check:
- If the number of flowers is less than the total number of flowers needed to make `m` bouquets `m * k` , return `-1` since it's impossible to form the required bouquets

## 2.Binary Search:
- Initialize `l` to `1` (minimum possible day).
- Initialize `r` to the maximum value in bloomDay array.
- Initialize `res` to `-1` (to store the result).
- Compute `mid` as the average of `l` and `r`
- Use the possible function to determine if it's possible to form `m` bouquets by `mid` days.

## 3.possible function:
- This function iterates through bloomDay and counts the number of consecutive flowers that have bloomed by the given day.
- If the count of consecutive flowers reaches `k`, it increments the bouquet count and resets the consecutive flower count.
- Finally, it return a boolean indicating whether the number of formed bouquets is at least `m`

## 4.Adjust Binary Search Boundaries:
- If it's possible to form `m` bouquets by `mid` days, update res to `mid` and move the `r` boundary to `mid - 1` to search for a smaller possible day.
- If it's not possible , move the `l` boundary to `mid + 1` to search for a lager day.

## 5.Return result:
- After exiting the loop, return `res`, which will be the minimum number of days required to form the bouquets.

## Notice:
- Instead of using `mid = (l + r)/2` could causes overflow , you should using `mid = l + (r-l)/2` , i ensure that the midpoint is safe from overflow.

# Complexity

- Time complexity: `O(N * log(max(bloomDay))).`

- Space complexity: `O(N).`

# Code

```golang
func possible(bloomDay []int, day int, m, k int) bool {
    n, len, nBloom := len(bloomDay), 0, 0
    for i := 0; i < n; i++ {
        if bloomDay[i] <= day {
            len++
            if len == k { // can make a bouquet
                nBloom++
                len = 0
            }
        } else {
            len = 0 // just reset
        }
    }
    return nBloom >= m
}

func minDays(bloomDay []int, m int, k int) int {
    l, r := 1, int(1e9)
    n := len(bloomDay)
    if m * k > n {
        return -1
    }
    for l <= r {
        mid := l + (r-l) / 2
        if possible(bloomDay, mid, m, k) {
            r = mid - 1
        } else {
            l = mid + 1
        }
    }
    return l
}
```
```c++
class Solution {
public:
    bool possible(vector<int>& bloomDay, int day,int m,int k){
        int cnt = 0 , ans = 0;
        for(int i = 0; i < bloomDay.size(); ++i){
            if(bloomDay[i] <= day) cnt++;
            else{
                ans += (cnt/k);
                cnt = 0;
            }
        }
        ans += (cnt/k);
        return ans >= m;
    }
    int minDays(vector<int>& bloomDay, int m, int k) {
        std::ios::sync_with_stdio(false);
        std::cin.tie(nullptr);
        if(m * k > bloomDay.size())return -1;
        int l = 1,r = *max_element(bloomDay.begin(), bloomDay.end()), res = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (possible(bloomDay, mid,m, k)) {
                res = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return res;
    }
};
```
