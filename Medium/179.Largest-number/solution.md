# Intuition

- At first glance, your intuition will be to try solving this using math, like divide by 10 to get the first value or trying to compare the remainders. Which seems to work but it will quickly fails you.
- Soon, you will realize that you can only go the bruteforce-y way by converting the list of `nums` into list of strings, then comparing each char individually to sort the list.
- There are edge cases like `nums = [0,0]` or `nums = [9,34,3,30]` where you have to be careful of when writing your custom comparator. To compare `3` and `30`, you can concatenate them into `3->30` and `30->3` then compare.

# Approach

- Convert the input list into a string list.
- Sort the list using a custom comparator, concate 2 input string then compare them.

# Complexity

- Time complexity: $O(nlogn)$ standard sorting complexity
- Space complexity: $O(n)$ using 1 extra vector to store the converted string list

# Code

```java
// Author: Thomas Luu
class Solution {
    public String largestNumber(int[] nums) {
        String[] arr = new String[nums.length];
        for (int i = 0; i < nums.length; i++) {
            arr[i] = String.valueOf(nums[i]);
        }
        Arrays.sort(arr, new Comparator<String>() {
            public int compare(String a, String b) {
                return (b + a).compareTo(a + b);
            }
        });
        StringBuilder sb = new StringBuilder();
        for (String s : arr) {
            sb.append(s);
        }
        while (sb.charAt(0) == '0' && sb.length() > 1)
            sb.deleteCharAt(0);
        return sb.toString();
    }
}
```

``` Cpp
class Solution {
public:
    string largestNumber(vector<int>& nums) {
        string res;
        vector<string> list;
        for(int i : nums)
            list.push_back(to_string(i));
        
        sort(list.begin(), list.end(), [](string a, string b) {
            return a+b > b+a;
        } );
        if(list[0] == "0") return "0";
        for(string s : list) res += s;
        return res;
    }
};
```