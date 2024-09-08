# Intuition

The initial thought is to split the linked list into `k` parts, ensuring each part is as evenly distributed as possible. If the number of nodes in the list isn’t evenly divisible by `k`, the first few parts should contain one additional node.

# Approach

1. **Calculate Length**: Begin by calculating the total length of the linked list.
2. **Determine Part Sizes**: Divide the length by `k` to determine the base size of each part. The remainder will help in distributing extra nodes to the first few parts.
3. **Split the List**: Iterate through the linked list, assigning the appropriate number of nodes to each part while making sure to sever the connections between parts properly.

# Complexity

- **Time complexity**:  
  The time complexity is $O(n)$, where `n` is the total number of nodes in the linked list. This accounts for traversing the entire list to determine its length and then splitting the list.

- **Space complexity**:  
  The space complexity is $O(k)$ for storing the resulting array of linked list parts.

# Code

## Java

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
        int N = getLength(head);

        int lengthPerPart = N / k;
        int leftOver = N % k;

        ListNode[] result = new ListNode[k];
        ListNode current = head;

        for (int i = 0; i < k; i++) {
            result[i] = current;
            int partSize = lengthPerPart + (i < leftOver ? 1 : 0);

            for (int j = 0; j < partSize - 1; j++) {
                if (current != null) {
                    current = current.next;
                }
            }

            if (current != null) {
                ListNode next = current.next;
                current.next = null;
                current = next;
            }
        }

        return result;
    }

    private int getLength(ListNode head) {
        int count = 0;
        ListNode current = head;
        while (current != null) {
            count++;
            current = current.next;
        }
        return count;
    }
}
```

## Go

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func splitListToParts(head *ListNode, k int) []*ListNode {
    current, n := head, 0
    for current != nil {
        n++
        current = current.Next
    }
    remain, size := n % k, n / k
    ans := make([]*ListNode, k)
    current = head
    for index := 0; index < k && current != nil; index++ {
        dummy := &ListNode{}
        first := dummy
        partSize := size
        if remain > 0 {
            partSize++
            remain--
        }
        for i := 0;  i < partSize; i++ {
            first.Next = &ListNode{Val: current.Val}
            first = first.Next
            current = current.Next
        }
        ans[index] = dummy.Next
    }
    return ans
}
```
