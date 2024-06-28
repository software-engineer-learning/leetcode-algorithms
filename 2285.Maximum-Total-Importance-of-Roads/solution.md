
# Intuition
# Approach
## 1.Calculate Degree of Each City:
- Create a vector `degree` of size n value `0` to store the degree (number of connected roads) of each city.
- Iterate through the `roads` array and for each road, increment the degree of both cities connected by that road.
## 2.Sort Degrees:
- Sort the `degree` vector. This will help in assigning the highest possible values to cities with the highest degrees.
## 3.Assign Values to Cities:
- After sorting, assign values to the cities based on their degrees. The city with the smallest degree gets the value `1`, the next gets `2`, and so on up to the city with the highest degree which gets the value `n`.
## 4.Calculate Total Importance:
- Iterate through the sorted `degree` vector and calculate the total importance by multiplying the degree by its corresponding value (from 1 to n) and summing up these products.

# Complexity

- Time complexity: `O(NLogN).`

- Space complexity: `O(N).`

# Code
```cpp
class Solution {
public:
    long long maximumImportance(int n, vector<vector<int>>& roads) {
        vector<long long> degree(n, 0);
        for (auto &a : roads) {
            degree[a[0]]++;
            degree[a[1]]++;
        }
        sort(degree.begin(), degree.end());
        long long total = 0;
        for (long long i=0;i<n;i++) {
            total += ((i+1)*degree[i]);
        }
        return total;
    }
};
```