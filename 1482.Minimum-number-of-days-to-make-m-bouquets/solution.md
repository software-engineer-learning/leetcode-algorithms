# Intuition

<!-- Describe your first thoughts on how to solve this problem. -->

# Approach

<!-- Describe your approach to solving the problem. -->

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
