# Intuition

- A key insight to solve this problem is that we can safely ignore the already valid square brackets. So we can build a newer string that only contains the invalid square brackets to make a more simple question.
- Another key insight we need to come up with is that its always better if we always choose to swap the right most with the left most square brackets to form the valid one. Hence the number of swap will always be the size of the newly formed invalid string above - `int n = stack.size()`, increase it by 1 and divide it by 2. Which is `return (n+1)/2`.

## Approach

- Use a stack to build the new string that only contains invalid square brackets.
- We can always see that for an incomplete string, for example stack = "]]][[[" with n = 6, there are n/2 = 3 pairs of square brackets. We will need to swap **at least** 3/2 times to complete it, and in this case where there are odds number of square brackets, we need to swap 1 more times. From this we can get the formula to calculate `result = (pairs/2)` if pairs is even, and `result = (pairs+1)/2` if pairs is odd.

- For the optimization, we can op-out of using the stack and use a variable `open`
  - We will increase the `open` when encounter an open square bracket and decrease it when we encounter close square bracket if `open > 0`. This will effectively remove the valid brackets and only leave the invalid string length for us to use.
  - The value of `open` is the size of the invalid string, again we can use the formula `result = (pairs/2)` if pairs is even, and `result = (pairs+1)/2` if pairs is odd.


## Complexity

- **Time complexity**: $O(n)$ as we iterate the whole input string

- **Space complexity**: $O(n)$ for stack impl and $O(1)$ for count impl. In worst case, stack size will equal input size

## Code

```java
// Author: Thomas Luu
class Solution {
    public int minSwaps(String s) {
        int closed = 0;
        int max = Integer.MIN_VALUE;

        for (var c : s.getBytes()) {
            if (c == ']') {
                closed++;
            } else {
                closed--;
            }
            max = Math.max(max, closed);
        }

        return (int) Math.ceil(max / 2.0);
    }
}
```

```rust
// Author: shawnlines
impl Solution {
    pub fn min_swaps(s: String) -> i32 {
        let (mut open_count, mut imbalance)= (0, 0);
        for ch in s.bytes() {
            if ch == b'[' {
                open_count += 1;
            } else {
                if open_count > 0 {
                    open_count -= 1;
                } else {
                    imbalance += 1;
                }
            }
        }
        (imbalance + 1) / 2
    }
}

// optimized
impl Solution {
    pub fn min_swaps(s: String) -> i32 {
        let mut open_count = 0;
        for ch in s.bytes() {
            if ch == b'[' {
                open_count += 1;
            } else {
                if open_count > 0 {
                    open_count -= 1;
                }
            }
        }
        (open_count + 1) / 2
    }
}
```

```cpp
// optmized cpp
// Author Hth4nh
class Solution {
public:
    int minSwaps(const string& s) {
        int openCount = 0;
        int res = 0;

        for (int i = 0; i < s.size(); i++) {
            openCount += '[' - s[i] + 1;

            if (openCount == -1) {
                openCount = 1;
            }
        }

        return openCount / 2;
    }
};

// stack impl
// Author: vietnguyenquoc.2307
class Solution {
public:
    int minSwaps(string s) {
        int n = s.size(), res = 0;
        stack<char> stack;
        for(char c : s) {
            bool open = (!stack.empty() && stack.top() == '[') && c == ']';
            if(open) {
                stack.pop();
                continue;
            }
            stack.push(c);
        }
        res = stack.size() >> 1;
        res = (res >> 1) + (res%2);
        return res;
    }
};
```
