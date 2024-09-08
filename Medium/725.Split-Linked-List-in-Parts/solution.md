# Intuition
The first thought is to divide the linked list into `k` parts, ensuring that the parts are as equal as possible in size. If the total number of nodes is not perfectly divisible by `k`, the first few parts should have one more node than the others.

# Approach
1. **Calculate the Length**: First, determine the length of the linked list.
2. **Determine Size per Part**: Divide the total length by `k` to get the base size of each part. The remainder will tell us how many of the initial parts should have one extra node.
3. **Split the List**: Traverse the list and split it into parts according to the calculated sizes, ensuring the correct distribution of nodes across the parts.

# Complexity
- **Time complexity**:  
  The time complexity is $O(n)$, where `n` is the total number of nodes in the linked list. This is because we traverse the entire list to calculate the length and then again to split the list.

- **Space complexity**:  
  The space complexity is $O(k)$ for storing the resulting array of linked list parts.

# Code
```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 * int val;
 * ListNode next;
 * ListNode() {}
 * ListNode(int val) { this.val = val; }
 * ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode[] splitListToParts(ListNode head, int k) {
        ListNode cloneHead = new ListNode(-1, head);
        int N = getLength(cloneHead);

        int lengthPerPart = N / k;
        int leftOver = N % k;

        ListNode[] result = new ListNode[k];

        ListNode current = cloneHead;

        for (int i = 0; i < k; i++) {
            result[i] = current.next;

            ListNode prev = current;

            for (int j = 0; j < lengthPerPart; j++) {
                current = current.next;
            }

            if (i < leftOver) {
                current = current.next;
            }
            prev.next = null;
        }
        return result;
    }

    private int getLength(ListNode head) {
        int count = 0;
        ListNode current = head;
        while (current.next != null) {
            count++;
            current = current.next;
        }

        return count;
    }
}
```