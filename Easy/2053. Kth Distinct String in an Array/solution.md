# Intuition

- First, we need someway to sort out all the distinct strings. We can either use 2 hash sets (never store dupplicates) or a hash map (store the frequency).
- Now that we have our list of distinct strings, we can compare it back with the original input and find out the k-th indexed distinct string.

# Complexity

- Time complexity: $O(N)$.
- Space complexity: $O(N)$.

# Code

## Go

```go
func kthDistinct(arr []string, k int) string {
    freq := make(map[string]int)
    for _, val := range arr {
        if _, ok := freq[val]; !ok {
            freq[val] = 0
        }
        freq[val]++
    }

    for _, val := range arr {
        if freq[val] == 1 {
            k--
            if k == 0 {
                return val
            }
        }
    }
    return ""
}
```

## C++

```C++
class Solution {
public:
    string kthDistinct(vector<string>& arr, int k) {
        int n = arr.size();
        unordered_map<string, int> freq;
        for(string s : arr) freq[s]++;
        for(string s : arr) {
            if(freq[s] > 1) continue;
            k--;
            if(k == 0) return s;
        }
        return "";
    }
};
```
