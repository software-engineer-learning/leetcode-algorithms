# Intuition
The problem involves booking events in a calendar without overlapping intervals. My first thought is to use a binary search tree (BST) approach, where each node represents a booked interval. The idea is to insert a new interval in such a way that it does not overlap with any existing intervals, maintaining the BST properties.

# Approach
1. We represent the calendar as a binary search tree (`CalendarNode`), where each node holds a time interval (`start`, `end`).
2. Each time an event is booked, we attempt to insert the interval into the tree.
3. If the new interval lies completely to the left of the current interval (`end <= this.start`), it should be placed in the left subtree.
4. If it lies completely to the right (`start >= this.end`), it should be placed in the right subtree.
5. If the new interval overlaps with the current interval, we return `false` indicating a conflict.
6. The `MyCalendar` class acts as a wrapper that manages the root of the calendar tree.

# Complexity
- **Time complexity:**  
  The time complexity for inserting a new interval depends on the height of the binary tree. In the worst case, the tree becomes skewed (i.e., all intervals lie either to the left or the right), leading to a time complexity of $O(n)$, where `n` is the number of booked intervals.

- **Space complexity:**  
  Each node in the tree represents an interval, so the space complexity is also $O(n)$, where `n` is the number of nodes (intervals).

# Code
```java
class CalendarNode {
    int start, end;
    CalendarNode left, right;

    public CalendarNode(int start, int end) {
        this.start = start;
        this.end = end;
        this.left = null;
        this.right = null;
    }

    public boolean add(int start, int end) {
        if (start >= this.end) {
            if (this.right != null) {
                return this.right.add(start, end);
            } else {
                this.right = new CalendarNode(start, end);
                return true;
            }
        } else if (end <= this.start) {
            if (this.left != null) {
                return this.left.add(start, end);
            } else {
                this.left = new CalendarNode(start, end);
                return true;
            }
        }
        return false;  // Overlap case
    }
}

class MyCalendar {
    private CalendarNode root;

    public MyCalendar() {
        this.root = new CalendarNode(0, 0);  // Initial dummy node
    }

    public boolean book(int start, int end) {
        return root.add(start, end);
    }
}


/**
 * Your MyCalendar object will be instantiated and called as such:
 * MyCalendar obj = new MyCalendar();
 * boolean param_1 = obj.book(start,end);
 */
