# Intuition
- The key solving this problem is to use `Sliding Window` technique to find the smallest subarray whose sum is at least the given target
# Approach

## 1. Initialization
- `min_length`: Set to i32::MAX to store the length of the smallest valid subarray found.
- `curr_sum`: Set to 0 to store the sum of the current window.
- `start`: Set to 0 to mark the beginning of the window.
## 2. Expand and Shrink the Window
- Iterate through the array using an index `end`, adding the current element to `curr_sum`.
- When `curr_sum` is greater than or equal to target, calculate the window's length and update `min_length` if this window is smaller.
- Shrink the window from the left by subtracting the element at `start` from `curr_sum` and incrementing `start`. 

## 3. Result
- After processing the entire array, check if `min_length` was updated. If not, return `0` indicating no valid subarray was found.
- Otherwise, return `min_length`, which contains the length of the smallest valid subarray.
# Complexity

- Time complexity: `O(n)`

- Space complexity: `O(1)` 

# Code

```rust
impl Solution{
    pub fn intersection(nums1: Vec<i32>, nums2: Vec<i32>){
        let mut set1 = HashSet::new();
        let mut set2 = HashSet::new();

        for num in nums1.into_iter(){
            set1.insert(num);
        }

        for num in nums2.into_iter(){
            if(set1.contains(&num)){
                set2.insert(num);
            }
        }

        set2.into_iter().collect()
    }
}
```
