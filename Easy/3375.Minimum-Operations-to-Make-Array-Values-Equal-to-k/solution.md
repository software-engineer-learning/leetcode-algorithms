# Intuition

- The description of this problem is kind of confusing I must admit, you have to look really close to the first example of the explanation where input array is ` nums = [10,8,10,8]` and why only 9 is a valid number, not **less than 8**. They said that an operation is to choose a valid number, lets call it x, where all the numbers > x is *identical*, which mean all indicies i where nums[i] > x **have the same value**.
- Now that you understood the question, lets take a look back at the first example in description `nums = [10,8,10,8]` and ask yourself, "if 9 is valid, what about 8?". Yes, 8 is valid because all the values in `nums` which bigger than 8 is 10. Now replace all 10 to 8, we got a result array of `nums = [8,8,8,8]`

- Okay now that you understand the requirement for choosing a valid number `x`, the question asked us to find the number of operation to **reduce** all values inside `nums` to be equal to k, if it is impossible return -1. The key insight here is that we **have to reduce**, never increase so if you ever encounter a value in `nums` that is less than k, then it is impossible to satisfy the requirement.
<p>&nbsp;</p>

# Approach

- The example in description helps us a lot:
  - First, it shows that we dont care how many `nums[i] > x` (again, lets call the valid value as x), we only care about there are only 1 value > x
  - Next, we now that we can only reduce, so if pushes come to shoves we can just sort the arrays lexicographically and count from the back
  - Also, in the example `nums[10,8,10,8]`, both `x = 9` and `x = 8` are a valid numbers, then should we ever choose 9 over 8? We know that we need to return the minimum number of operations so we can safely and greedily choose the next largest value in `nums`, which is 8 in this case.
- With all the intuitions above, we can safely come up with the approach of using a hash array to **hash the occurence** of the value inside `nums` and just count how many steps does it takes to go from largest value to the input `k`. If there is any value less than `k` insisde `nums` then we return -1.
<p>&nbsp;</p>

## Complexity
- Time complexity: $O(n + 101)$, where `n` is the length of the string as we have to iterate the string to hash the occurences into bitset.
- Space complexity: $O(1)$, we only use a bitset of size 101, so its basically constant space.
<p>&nbsp;</p>

## Code 
- This implementation uses bitset for optimization, but you can use a bool array or hash map for simplicity sake
```cpp
class Solution {
public:
    int minOperations(vector<int>& nums, int k) {
        int n = nums.size(), res = -1;
        bitset<101> bs;
        for(int i : nums) bs.set(i);
        for(int i = 0; i < 101; i++) {
            if(i == k) {
                res++;
                continue;
            } 
            if(!bs.test(i)) continue;
            if(i < k) return -1;
            res++;
        }
        return res;
    }
};
```