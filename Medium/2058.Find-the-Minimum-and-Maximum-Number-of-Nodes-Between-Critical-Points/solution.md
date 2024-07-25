# Intuition
<!-- Describe your first thoughts on how to solve this problem. -->
# Approach

## 1.Edge Case Handling:
- If the linked list is too short to have any critical points (less than three nodes), return `[-1, -1]` immediately.
## 2.Traverse the Linked List:
- Start from the second node and check each node to see if it is a critical point. A node is a critical point if:
    - It is a local maxima (greater than both its previous and next nodes).
    - It is a local minima (smaller than both its previous and next nodes).
## 3.Store Critical Points:
- Keep a list to store the indices of all critical points found during traversal.
## 4.Compute Distances:
- If there are fewer than two critical points, return `[-1, -1]` as it's impossible to calculate any distances.
- Otherwise, calculate:
    - The minimum distance between any two consecutive critical points.
    - The maximum distance between the first and the last critical points in the list.
## 5.Return Results:
- Return the computed minimum and maximum distances.
# Complexity
- Time complexity: `O(N).`
- Space complexity: `O(1).`
# Code
```cpp
class Solution {
public:
    vector<int> nodesBetweenCriticalPoints(ListNode* head) {
        if(head==NULL || head->next==NULL ||head->next->next==NULL){
            return {-1,-1};
        }
        ListNode* tmp=head->next;
        ListNode* tmp1=head->next->next;
        vector<int>v;
        int i=2;
        while(tmp1){
            if((head->val<tmp->val)&&(tmp1->val<tmp->val))v.push_back(i);
            else if((head->val>tmp->val)&&(tmp1->val>tmp->val))v.push_back(i);
            i++;
            head=tmp;
            tmp=tmp1;
            tmp1=tmp1->next;
        }
        if(v.size()<2){
            return {-1,-1};
        }
        int _min=INT_MAX;
        for(int i=1;i<v.size();i++){
            _min=min(_min,(v[i]-v[i-1]));
        }
        return {_min,(v[v.size()-1]-v[0])};
    }
};
```
