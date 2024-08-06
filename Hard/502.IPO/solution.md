# Intuition

- We need a way to pair capital and profit together so we can process both efficiently -> use pair<T,T> and store them in vector in-order, lets call that `vector<pair<int, int>> project.
- Example 1: project = [(0,1),(1,2),(1,3)], w = 0, k = 2
  - We can see that there are 2 things we need to be mindful of:
    - The project we can work on with **current w**, int the example, with starting w = 0, we can only take the project[0] to increase w to 1. This mean that for every w, we need to choose the project[i] with the maximize profit -> we need someway to efficiently store and retrieve this information (heap) and to efficiently calculate this, we need to somehow group projects with capital cost together and in an increasing order if possible (sorting).
    - The number of times we can **choose** a project k; We can do at most k project, so we **should** always only get the project with highest ROI (return on investment) on every decision.

# Approach 

## Explanation:

- Make a `vector<pair<int,int>> project` to store the paired capital:profit, then sort it ascending so we can efficiently choose the highest ROI one.
- Iterate through the project list, when we encounter the project that we can't choose with current w -> time to choose from the current batch. We can use a max_heap to store the previous batch, and get the highest ROI project from it to increase current w, decrease our k everytime we do this.
- If k == 0 -> return w, if heap is empty -> we can't increase w anymore so current w is max -> return w

## Complexity

- Time complexity: $O(n \log n)$ as we need to sort the `project` to group out possible decisions together.
- Space complexity: $O(n)$

## Code

```cpp
class Solution {
public:
    int findMaximizedCapital(int k, int w, vector<int>& profits, vector<int>& capital) {

        int n = profits.size();
        vector<pair<int, int>> project;
        priority_queue<int> heap;

        for(int i = 0; i < n; i++) {
            int p = profits[i], c = capital[i];
            project.push_back(make_pair(c, p));
        }

        sort(project.begin(), project.end());
        
        int i = 0;
        while(k > 0) {
            while(i < n && project[i].first <= w) {
                heap.emplace(project[i].second);
                i++;
            }
            if(heap.empty()) break;
            w += heap.top();
            heap.pop();
            k--;
        }
        return w;
    }
};
```
