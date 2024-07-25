# Intuition

The problem requires merging nodes between zeros in a linked list and returning the modified list without zeros. The solution takes advantage of two pointers: `slow` to track the current node for merging and `fast` to traverse the list. By summing values between zeros and connecting nodes appropriately, we can achieve the desired result efficiently.

<p>&nbsp;</p>

# Approach: Two Pointers
Using two pointers, `slow` and `fast`, we can traverse the list while merging the values between zeros and adjusting the pointers to form the new linked list.

## Explanation:

1. **Initialization**:
   - `slow` is initialized to the head of the list.
   - `fast` is initialized to the next node after `head`.

2. **Traverse the List**:
   - Iterate through the list using the `fast` pointer until `fast->next` is `nullptr`.

3. **Sum Values and Adjust Pointers**:
   - **Summing Values**:
     - If `fast->val` is not 0, add `fast->val` to `slow->val`.
   - **Adjusting Pointers**:
     - If `fast->val` is 0, it means we've reached the end of a segment to merge. Update `slow->next` to point to `fast` and move `slow` to `fast`.
   - Move the `fast` pointer to the next node.

4. **Finalize the List**:
   - Set `slow->next` to `nullptr` to ensure the new list terminates correctly.
   - Return the modified list starting from the head.

## Complexity
- Time complexity: $O(n)$
- Space complexity: $O(1)$

## Code 

```cpp []
class Solution {
public:
    ListNode* mergeNodes(ListNode* head) {
        ListNode* slow = head;
        ListNode* fast = head->next;

        while (fast->next) {
            if (fast->val != 0) {
                slow->val += fast->val;
            }
            else {
                slow->next = fast;
                slow = slow->next;
            }

            fast = fast->next;
        }

        slow->next = nullptr;
        return head;
    }
};
```