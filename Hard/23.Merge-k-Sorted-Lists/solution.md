# Intuition

- The question ask us to create a sorted linked-list from a list of provided linked-lists. Take a look at the following example:
```
    list = [
        1->4->5,
        1->3->4,
        2->6
    ]
```

- The key insight here is that as we go building the resulted linked-list, we only need the current lowest value from the provided vector `list` - we don't need to sort everything, only need the `lowest value from the remaining node`. We can easily archieve this with a min heap.

## Approach: Heap-sort

- Initialize a min heap, add all the nodes into this heap.
- Build the result linked-list from the heap.

## Complexity

- Time complexity: $O(nlogn)$ - We use heap sort here
- Space complexity: $O(n)$ - The additional heap is of length n-number of nodes

## Code

```cpp
class Solution {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        if(lists.size() == 0) return nullptr;
        priority_queue<int, vector<int>, greater<int> > heap;
        for(auto ll : lists) {
            while(ll) {
                heap.emplace(ll->val);
                ll = ll->next;
            }
        }
        if(heap.empty()) return nullptr;

        ListNode* dummy = new ListNode(0);
        ListNode* curr = new ListNode(heap.top());
        heap.pop();
        dummy->next = curr;
        while(!heap.empty()) {
            curr->next = new ListNode(heap.top());
            heap.pop();
            curr = curr->next;
        }
        ListNode* head = dummy->next;
        delete dummy;
        return head;
    }
};
```