# Intuition

This is a pretty straight forward problem, as the timestamp is strictly increasing it means when we store values with the same key it will be in sorted order. Hence we can use binary search when query

&nbsp;

## Approach: Use hashmap for keys and array to store pairs of value-timestamp

- Use a hashmap/unordered_map to store keys for efficient lookup, return empty when key not exists
- Use a vector<pair<string,int>> to store values and their timestamp. As the timestamp is strictly increasing, we can use binary search when lookup the correct pair. Some caveat:
  - When lookup with binari search, we need to use timestamp, not index
  - Take care of edge-case where repeated querying for out of bound values
  - If query value is out of left bound, we need to return empty string (stated in the description but might still throw people up when implementing code)

## Complexity
- Time complexity: $O(log{n})$
- Space complexity: $O(n)$

## Code
```cpp []
class TimeMap {
public:

    unordered_map<string, vector<pair<string,int>> > map;
    TimeMap() {

    }
    
    void set(string key, string value, int timestamp) {
        map[key].push_back(make_pair(value, timestamp));
    }
    
    string get(string key, int timestamp) {
        if(map.count(key) < 1) return ""; // if key not exist

        int n = map[key].size(), left = 0, right = n-1;
        // if timestamp out of right bound return last value
        if(timestamp > map[key][n-1].second) return map[key][n-1].first; 

        // vectorize for readability
        vector<pair<string, int>> nums = map[key];
        while(left <= right) {
            int mid = left + (right-left)/2;
            int l = nums[left].second, r = nums[right].second, m = l + (r-l)/2;
            // edge case checking:
            if(timestamp < l) return ""; // out of left bound
            if(timestamp >= r) return nums[right].first; // out of right bound
            if(timestamp == l) return nums[left].first;

            if(timestamp > m) {
                left = mid+1;
                continue;
            }
            if(timestamp < m) {
                right = mid-1;
                continue;
            }
            if(timestamp == m) return nums[left].first;
        }
        return nums[left].first;
    }
};

/**
 * Your TimeMap object will be instantiated and called as such:
 * TimeMap* obj = new TimeMap();
 * obj->set(key,value,timestamp);
 * string param_2 = obj->get(key,timestamp);
 */
```
