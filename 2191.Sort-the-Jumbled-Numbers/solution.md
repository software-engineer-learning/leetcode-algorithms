# Intuition

The task requires us to sort an array of integers based on a custom mapping of their digits. This can be approached by first transforming each number using the provided mapping and then sorting the transformed numbers while maintaining the original order of elements with identical transformed values.

<p>&nbsp;</p>

# Approach: Transform and Sort
We will create a helper function to convert each number in the array based on the given mapping. Then, we'll pair the transformed numbers with their original indices to maintain stability while sorting. Finally, we sort these pairs and construct the result based on the sorted order of the transformed values.

## Explanation:

1. **Helper Function `convert`**:
    - If `x` is `0`, return `mapping[0]`.
    - Initialize `res` to store the result and `expo` to track the place value (units, tens, etc.).
    - Iterate through each digit of `x`:
    - Replace the digit with its mapped value.
    - Accumulate the transformed value in `res`.
    - Update the place value (`expo`) by multiplying it by 10.
    - Return the transformed value `res`.

2. **Main Function `sortJumbled`**:
    - Initialize `res` to store the sorted result and `pairs` to store the pairs of transformed values and their original indices.
    - Convert each number in `nums` using the `convert` function and store the pair of the converted value and its index in `pairs`.
    - Sort `pairs` based on the transformed values.
    - Transform the sorted pairs back to the original values in `res` using their stored indices.

## Complexity
- Time complexity: $O(n \log n)$, where $n$ is the length of `nums`.
- Space complexity: $O(n)$

## Code 
```cpp
class Solution {
public:
    int convert(int x, vector<int>& mapping) {
        if (x == 0) return mapping[0];
        
        int res = 0, expo = 1;
        while (x) {
            res += mapping[x % 10] * expo;
            expo *= 10;
            x /= 10;
        }

        return res;
    }

    vector<int> sortJumbled(vector<int>& mapping, vector<int>& nums) {
        int n = nums.size();

        vector<int> res(n);
        vector<pair<int, int>> pairs(n);

        for (int i = 0; i < n; i++) {
            pairs[i] = make_pair(convert(nums[i], mapping), i);
        }

        ranges::sort(pairs);
        ranges::transform(pairs, res.begin(), [&](auto& p) {
            return nums[p.second];
        });

        return res;
    }
};
```