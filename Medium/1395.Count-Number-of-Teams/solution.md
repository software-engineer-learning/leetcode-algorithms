# Intuition

To count the number of valid teams, we need an efficient way to keep track of the number of elements that are less than or greater than a given element as we iterate through the list of ratings.

<p>&nbsp;</p>

# Approach 1: Dynamic Programming

Please contribute, I'm lazy.

<p>&nbsp;</p>

# Approach 2: BIT (Binary Indexed Tree)

We use two BITs to keep track of the counts of elements that are less than the current element (leftBIT) and greater than the current element (rightBIT) as we iterate through the ratings.

## Explanation:

1. **Initialization**:
   - Create a BIT class that supports `update` and `getSum` operations.
   - Initialize two BIT instances, `leftBIT` and `rightBIT`, each with the size of the ratings list.
   - Initialize `rightBIT` by updating it with 1 for each index, indicating that all elements are initially considered on the right of any element.

2. **Sorting by Rating**:
   - Create an index array and sort it based on the ratings to map the ratings to their indices.
   
3. **Iterating Through Ratings**:
   - For each rating (in the sorted order), perform the following:
     - Update `rightBIT` to exclude the current rating.
     - Calculate the number of elements less than the current rating using `leftBIT`.
     - Calculate the number of elements greater than the current rating using `rightBIT`.
     - Update `leftBIT` to include the current rating.
     - Calculate the number of valid teams by combining the counts from `leftBIT` and `rightBIT`.

## Complexity
- Time complexity: $O(n \log n)$
- Space complexity: $O(n)$

## Code 
### C++
```cpp
class BIT {
private:
    int* _bit;
    int n;

public:
    BIT(int n): n(n) {
        _bit = new int[n + 1];
        fill_n(_bit, n + 1, 0);
    }

    ~BIT() {
        delete[] _bit;
    }

    void update(int i, int val) {
        while (i <= n) {
            _bit[i] += val;
            i += i & -i;
        }
    }

    int getSum(int i) {
        int res = 0;
        while (i > 0) {
            res += _bit[i];
            i -= i & -i;
        }
        return res;
    }
};

class Solution {
public:
    int numTeams(vector<int>& rating) {
        int n = rating.size();
        vector<int> indexes(n);
        iota(indexes.begin(), indexes.end(), 0);
        sort(indexes.begin(), indexes.end(), [&](auto& i, auto& j) {
            return rating[i] < rating[j];
        });

        int res = 0;
        BIT leftBIT(n), rightBIT(n);

        for (int i = 0; i < n; i++) {
            rightBIT.update(i + 1, 1);
        }

        for (int i = 0; i < n; i++) {
            int rank = indexes[i] + 1;
            
            rightBIT.update(rank, -1);

            int leftSum = leftBIT.getSum(rank);
            int rightSum = rightBIT.getSum(rank);

            leftBIT.update(rank, 1);

            res += leftSum * (n - i - 1 - rightSum);
            res += rightSum * (i - leftSum);
        }

        return res;
    }
};
```