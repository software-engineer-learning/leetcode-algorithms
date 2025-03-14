# Intuition

- This question is similar to [Koko eating banana](..\875.KoKo-Eating-Bananas\solution.md) problem, it is highly recommended to study that problem as it is a pretty popular pattern in interview
- The key insight to solve this problem is finding out that the **possible answer is in a range of allocating 1 candy for each child, or at most all candies from the largest pile to each children**. This might sound confusing at firts, but lets observe this testcase:
  - `candies = {8,8,8,8}, k = 4` You can see that the smallest amount of candies you can share is 1 for each child in total of 4 candies, but you **can take the largest which is 8 from a pile and allocate it for 1 child**, with 4 piles like that, you got the result. This mean you have a **range of 1 to 8 candies for each child**
  - Now that you have a range, you can easily use binary search in that range, for example you try giving 4 candies to each child:
    - 1st pile can be shared to 2 kids, 2nd pile can be shared with the rest -> 4 is a valid answer.
  - Now that you know you can share 4, **you should ask yourself if there could be more than 4**, from this you **got a new range [4,8]**. Again do binary search and try 6 candies:
    - 1st pile you take 6 and see that the remaining 2 candies are less than 6, you move to next pile, remaining children waiting for candies are k = 3
    - 2nd pile you again take 6 and got 2 leftover, k = 2 move to next pile
    - Do the same for 3rd and 4th, you see that again 6 candies/child is valid answer. Now you got a new range [6,8]
  - Repeat until you find the answer
- The tricky part of this problem is usually not the coding, but the intuition to come up with the binary approach. Because this time you do not use binary search on the array itself but in a range you predefined and then try to see if it passes as a valid answer.

# Complexity

- Time complexity: `O(NlogM)` where N is the length of the given array. M is the range from `[1, largest_pile]`, the constrain of candies[i] is 10,000,000 so in worst case log(M) = 26 round to integer. So the timecomplexity is basically asymtote O(N).

- Space complexity: `O(1)` for extra space.

# Code

## C++

```cpp
class Solution {
public:
    int maximumCandies(vector<int>& candies, long long k) {
        int n = candies.size(), res = 0;
        int left = 1, right = *max_element(candies.begin(), candies.end());
        while(left <= right) {
            int mid = left + (right-left)/2;
            if(!check(candies, k, mid)) {
                right = mid-1;
            } else {
                left = mid+1;
                res = max(res, mid);
            }
        }
        return res;
    }

    bool check(vector<int> &candies, long long k, int mid) {
        long long alloc = 0;
        for(int i = 0; i < candies.size(); i++) {
            int can = candies[i];
            if(can >= mid) {
                alloc += can/mid;
                can /= mid;
            }
        }
        return alloc >= k;
    }
};
```

## Go - Contributed by Shawnlies

```go
func maximumCandies(candies []int, k int64) int {
    if k == 0 {
        return 0
    }

    left, right := 1, 0
    for _, candy := range candies {
        right = max(right, candy)
    }

    var canDistribute func(int64, int) bool
    canDistribute = func(k int64, val int) bool {
        if val == 0 {
            return true
        }
        count := int64(0)
        for _, candy := range candies {
            count += int64(candy / val)
            if count >= k {
                return true
            }
        }
        return false
    }

    ans := 0
    for left <= right {
        mid := left + (right - left) / 2
        if canDistribute(k, mid) {
            ans = mid
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return ans
}
```

## Rust - Contributed by Shawnlies

```rust
func maximumCandies(candies []int, k int64) int {
    if k == 0 {
        return 0
    }

    left, right := 1, 0
    for _, candy := range candies {
        right = max(right, candy)
    }

    var canDistribute func(int64, int) bool
    canDistribute = func(k int64, val int) bool {
        if val == 0 {
            return true
        }
        
        for _, candy := range candies {
            k -= int64(candy / val)
            if k <= 0 {
                return true
            }
        }
        return false
    }

    ans := 0
    for left <= right {
        mid := left + (right - left) / 2
        if canDistribute(k, mid) {
            ans = mid
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return ans
}
```
