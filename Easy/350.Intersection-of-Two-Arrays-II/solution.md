# Intuition

To find the intersection of two arrays where each element in the result must appear as many times as it shows in both arrays, we can utilize a counting mechanism to track the occurrences of elements. By counting the elements in one array and then checking these counts against the elements in the other array, we can efficiently determine which elements are common and how many times they appear in both arrays.

<p>&nbsp;</p>

# Approach 1: HashMap + Counting

We use an array to count the occurrences of each element in the first array. Then, we iterate over the second array to build the result by checking and updating these counts.

## Explanation:

1. **Count Elements in the First Array**:

   - Use an array `mp` to count occurrences of each element in `nums1`.
   - Iterate through `nums1` and increment the count for each element.

2. **Check Elements in the Second Array**:

   - Iterate through `nums2`.
   - For each element in `nums2`, check if it exists in the count array `mp`.
   - If the count is greater than zero, add the element to the result and decrement its count in `mp`.

3. **Build the Result Array**:
   - Resize `nums1` to the size of the result to store the intersection elements.
   - Return the modified `nums1` as the result.

## Complexity

- Time complexity: $O(n + m)$
- Space complexity: $O(min(n, m))$

## Code

### C++

```cpp []
class Solution {
public:
    vector<int> intersect(vector<int>& nums1, vector<int>& nums2) {
        int mp[1001] {};
        for (int i = 0; i < nums1.size(); i++) {
            ++mp[nums1[i]];
        }

        int k = 0;

        for (int i = 0; i < nums2.size(); i++) {
            if (mp[nums2[i]] > 0) {
                --mp[nums2[i]];
                nums1[k++] = nums2[i];
            }
        }

        nums1.resize(k);
        return move(nums1);
    }
};
```

### Go

```go
func intersect(nums1 []int, nums2 []int) []int {
    mp := make([]int, 1001)
    for _, val := range nums1 {
        mp[val]++
    }
    res := []int{}
    for _, val := range nums2 {
        if mp[val] > 0 {
            mp[val]--
            res = append(res,val)
        }
    }
    return res
}
```

&nbsp;

---

&nbsp;

# What if the given array is already sorted? How would you optimize your algorithm?

If the given arrays are already sorted, we can optimize our algorithm by using two pointers technique. This technique is efficient for sorted arrays and allows us to find the intersection without the need for additional space for counting elements.

<p>&nbsp;</p>

# Intuition

For sorted arrays, we can leverage their order to efficiently find the intersection. By using two pointers to traverse the arrays, we can simultaneously compare elements and collect the common ones, moving the pointers appropriately to maintain the sorted order.

<p>&nbsp;</p>

# Approach 2: Two Pointers

The two pointers technique allows us to traverse both sorted arrays in linear time, comparing elements and collecting the common ones.

## Explanation:

1. **Initialize Two Pointers**:

   - Initialize two pointers, `i` for `nums1` and `j` for `nums2`, both starting at the beginning of their respective arrays.

2. **Traverse Both Arrays**:

   - While neither pointer has reached the end of the array, compare the elements pointed to by `i` and `j`.
   - If the elements are equal, add the element to the result and move both pointers forward.
   - If the element in `nums1` is smaller, move the pointer `i` forward.
   - If the element in `nums2` is smaller, move the pointer `j` forward.

3. **Build the Result Array**:
   - The result array contains the intersection elements, collected as we traverse the arrays.

## Complexity

- Time complexity: $O(n + m)$
- Space complexity: $O(1)$

## Code

```cpp
class Solution {
public:
    vector<int> intersect(vector<int>& nums1, vector<int>& nums2) {
        ranges::sort(nums1);
        ranges::sort(nums2);

        vector<int> result;
        int i = 0, j = 0;

        while (i < nums1.size() && j < nums2.size()) {
            if (nums1[i] == nums2[j]) {
                result.push_back(nums1[i]);
                ++i;
                ++j;
            } else if (nums1[i] < nums2[j]) {
                ++i;
            } else {
                ++j;
            }
        }

        return result;
    }
};
```
