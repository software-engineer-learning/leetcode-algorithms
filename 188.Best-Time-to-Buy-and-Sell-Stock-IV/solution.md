
# Intuition 1
# Approach 1
## 1.Initialization:
- The `dp` array is initialized with `-1` to indicate  states.
## 2.Dynamic Programming Table (3D DP array):
The solution uses a 3D DP array `dp[i][canBuy][trans]` where:
- `i` is the current day.
- `canBuy` indicates whether we can buy a stock on the current day (1 if we can buy, 0 if we can sell).
- `trans` is the number of transactions (buy + sell pairs) completed so far.
## 3.Base Cases:
- If `i` is equal to the length of the prices array `(i == n)`, we cannot make any transactions, so the profit is `0`.
- If `trans` reaches `k`, we cannot make more than `k` transactions, so the profit is `0`.
## 4.State Transition:
- If `canBuy == 1`, we have two choices:
    - 1.Buy the stock at price `v[i]` and move to the next day with `canBuy` set to `0` (indicating the next action should be sell).
    - 2.Skip the current day without buying and move to the next day with `canBuy` still set to `1`.
- If `canBuy == 0`, we also have two choices:
    - 1.Sell the stock at price `v[i]` and move to the next day with `canBuy` set to `1` (indicating the next action should be buy), and increment the trans by `1`.
    - 2.Skip the current day without selling and move to the next day with `canBuy` still set to `0`.
## 5.Memoization:
- The results of sub-problems are stored in the DP array to avoid redundant calculations.
## 6.Recursive Function:
- The recursive function `f` computes the maximum profit for each state using the defined state transitions and memoization.
# Complexity

- Time complexity: `O(N2*K).`

- Space complexity: `O(N*K).`

# Code
```cpp
class Solution {
public:
    int dp[1005][2][105];
    int f(int i,int canBuy,vector<int>&v,int trans,int k){
        int n=v.size();
        if(i==n||trans>=k)return 0;
        if(dp[i][canBuy][trans]!=-1)return dp[i][canBuy][trans];
        if(canBuy) dp[i][canBuy][trans]=max(-v[i]+f(i+1,0,v,trans,k),f(i+1,1,v,trans,k));
        else  dp[i][canBuy][trans]=max(v[i]+f(i+1,1,v,trans+1,k),f(i+1,0,v,trans,k));
        return dp[i][canBuy][trans];
    }
    int maxProfit(int k, vector<int>& prices) {
        std::ios_base::sync_with_stdio(false);
        std::cin.tie(NULL);
        memset(dp,-1,sizeof dp);
        return f(0,1,prices,0,k);
    }
};
```

# Intuition 2
- If I use greedy thinking to buy all trades, how can I optimize them further to fit within k trades?
# Approach 2
## 1.Initial Setup:
- The function takes the number of allowed transactions `k` and a vector of stock prices `prices`.
- Initialize `n` as the size of the `prices` vector.
- Initialize `b` to `INT_MAX` to track the lowest buying price.
- Initialize a vector of pairs `bs` to store all potential buy-sell pairs.
## 2.Identify Buy-Sell Pairs:
Iterate through the `prices` array to identify all potential buy-sell pairs:
- If the current price is less than or equal to `b`, update `b` to the current price.
- If the current price is greater than `b`, iterate through consecutive days where the price is non-decreasing to find the peak price.
- Store the buy-sell pair `(b, prices[i])` in the `bs` vector and update `b` to the current price.
## 3.Reduce Transactions:
If the number of identified buy-sell pairs exceeds `k`, reduce the number of transactions by either merging two consecutive trades or deleting a single trade:
- Merge Consecutive Trades: Find the pair of consecutive trades where merging them results in the minimum loss and merge these trades.
- Delete a Trade: Find the trade with the smallest profit and delete it.
- Continue reducing until the number of transactions is less than or equal to `k`.
## 4.Calculate Maximum Profit:
- Initialize `ans` to store the total profit.
- Sum up the profits of all remaining buy-sell pairs in the `bs` vector.
- Return the total profit as the result.
# Complexity

- Time complexity: `O(N).`

- Space complexity: `O(N).`

# Code
```cpp
class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        int n = prices.size();
        int b = INT_MAX;
        vector<pair<int, int>> bs;
        for(int i=0;i<n;i++){
            if(prices[i]<=b) b = prices[i];
            else{
                while(i<n-1 && prices[i+1]>=prices[i]){
                    i++;
                }
                bs.push_back({b, prices[i]});
                b = prices[i];
            }
        }
        while(bs.size()>k){
            int mergeIdx = -1, _min = INT_MAX;
            for(int i=1;i<bs.size();i++){
                if(bs[i].second >= bs[i-1].second && bs[i-1].second-bs[i].first < _min){
                    mergeIdx = i;
                    _min = bs[i-1].second-bs[i].first;
                }
            }
            int minIdx = 0;
            for(int i=1;i<bs.size();i++){
                if((bs[i].second-bs[i].first)<(bs[minIdx].second-bs[minIdx].first)) minIdx = i;
            }
            if(bs[minIdx].second-bs[minIdx].first < _min) bs.erase(bs.begin()+minIdx);
            else{
                bs[mergeIdx-1].second = bs[mergeIdx].second;
                bs.erase(bs.begin()+mergeIdx);
            }            
        }
        long int ans = 0;
        for(auto p:bs)ans+=p.second-p.first;
        return ans;
    }
};
```