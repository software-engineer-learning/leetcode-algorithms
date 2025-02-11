# Intuition


- We will want to hold the smallest value of stock and sell at largest value as possible. And we just have 1 stock at 1 time. 


The below example give us a better looking as this problem
- [3 1 2 3 4 5 100 50 25 1]

If you buy a stock at the first day (price=3) and sell any other day (T), your total benefit still be less than you wait 1 more day to buy stock at the second day (price=1) and sell at the day T, give more optimal solution. Apply the ssame idea, if you hold the second day stock and sell as any thay other than 100, you do not have best benefit. So this problem just find a all longest increasing adjacent subsequence and get the largest minus the smallest and sum them.



- [3 1 2 3 4 5 100 50 25 1]
Will be come
- [[3] [1,2,3,4,5,100] [50] [25] [1]]


Then our results is $99$ for this case.

# Pseudo code

```
Input: price[1..N]

Initialize: sum=0,left=0,right=0

while left < N and right < N:
    if price[right] < price[right + 1]:
        price++
    else:
        sum += a[right] - a[left]
        left = ++right

return sum
```


# Solution (C++)


```c++
int maxProfit(vector<int>& prices) {
    int sum = 0, left = 0, right = 0, n = prices.size();
    if (prices.size() == 1) {
        return 0;
    }
    prices.push_back(0);
    while(left < n && right < n) {
        if (prices[right] < prices[right + 1] && right < n - 1) {
            right += 1;
        }
        else {
            sum += prices[right] - prices[left];
            left = ++right;
        }
    }
    return sum;
}
```


