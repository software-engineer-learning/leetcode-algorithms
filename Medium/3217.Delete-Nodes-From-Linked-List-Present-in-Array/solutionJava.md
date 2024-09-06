# Intuition
The task requires modifying a linked list by removing nodes that contain certain values specified in an array. This hints at a two-step approach: first, identifying the values to remove, and second, iterating through the linked list to remove those nodes. To ensure efficient lookup of values to remove, using a set seems ideal because of its constant-time average lookup complexity.

# Approach
1. **Step 1: Store values in a set:** Iterate through the array `nums` and store all the values in a `Set`. This allows for O(1) average time complexity when checking if a value should be removed.
  
2. **Step 2: Iterate through the linked list:** Use a dummy node to handle edge cases like removing the head node. Traverse the linked list, and for each node, check if its value exists in the set. If it does, skip the node by adjusting pointers.

3. **Step 3: Return the modified list:** Once the traversal is complete, return the linked list starting from `dummy.next`.

# Complexity
- **Time complexity:**  
  The time complexity is $$O(n + m)$$ where:
  - `n` is the length of the input array `nums`.
  - `m` is the number of nodes in the linked list.
  - Building the set takes O(n) time, and traversing the linked list takes O(m) time.

- **Space complexity:**  
  The space complexity is $O(n)$ because we store all elements of `nums` in a set, which can take up to `n` space.

# Code
```java []
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode modifiedList(int[] nums, ListNode head) {
        Set<Integer> lookUpSet = new HashSet<>();
        for (int num : nums) {
            lookUpSet.add(num);
        }

        ListNode dummy = new ListNode(0, head);
        ListNode current = dummy;

        while (current.next != null) {
            if (lookUpSet.contains(current.next.val)) {
                current.next = current.next.next;
            } else {
                current = current.next;
            }
        }

        return dummy.next;
    }
}
```