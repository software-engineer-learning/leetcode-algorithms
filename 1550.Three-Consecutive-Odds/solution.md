# Intuition

# Approach

- Iterate through this array and check if 3 consecutive odds element in array exists or not

# Complexity

- Time complexity: `O(N)`

- Space complexity: `O(1)`

# Code

## C++

```cpp
class Solution {
public:
    bool threeConsecutiveOdds(vector<int>& arr) {
        ios_base::sync_with_stdio(false);
        cin.tie(nullptr);
        if(arr.size() < 3) return false;
        for(int i = 0; i < arr.size() - 2; i++) {
            if ((arr[i] % 2 == 1) && (arr[i+1] % 2 == 1) && (arr[i+2] % 2 == 1)) {
                return true;
            }
        }
        return false;
    }
};
```

## Go

```go
func threeConsecutiveOdds(arr []int) bool {
    n := len(arr)
    for i := 0; i < n-2; i++ {
        if arr[i] % 2 != 0 && arr[i+1] % 2 != 0 && arr[i+2] % 2 != 0 {
            return true
        }
    }
    return false
}
```
