# Intuition

The problem asks to find the single number in an array where every other number appears twice. The key insight here is to use the XOR operation, which has the property that a number XORed with itself is zero, and a number XORed with zero remains unchanged. By XORing all the elements in the array, the duplicate numbers cancel out, leaving the single number.

<p>&nbsp;</p>

# Approach: Bitwise XOR

## Explanation:

1. **XOR Operation Properties**:
   - `a ^ a = 0`: Any number XORed with itself is zero.
   - `a ^ 0 = a`: Any number XORed with zero remains unchanged.
   - XOR is commutative and associative, meaning the order in which you XOR numbers does not matter.

2. **Iterate Through the Array**:
   - Initialize a variable `res` to zero.
   - Traverse through each element `x` in the array and XOR it with `res`.
   - Since every element except one appears twice, all the duplicate pairs will cancel each other out and the result will be the single number.

3. **Return the Result**:
   - After processing all elements, `res` will hold the value of the single number.

## Complexity
- **Time complexity**: $O(n)$, where `n` is the number of elements in the array. We only make one pass through the array.
- **Space complexity**: $O(1)$, as we only use a single integer variable to store the result.

## Code 
```cpp
class Solution {
public:
    int singleNumber(vector<int>& nums) {
        int res = 0;
        for (auto& x: nums) res ^= x;
        return res;
    }
};
```