# Intuition

Collecting every critical point into a list and then scanning that list works, and
is what the C++ version below does. But two facts let the same answer fall out of a
single walk with no storage at all:

- **The maximum distance is always between the first and the last critical
  point.** Indices arrive in increasing order, so the widest span is
  `last - first`; no other pair can beat it.
- **The minimum distance is always between two *adjacent* critical points.** If
  two critical points have a third between them, splitting at that third gives a
  strictly smaller gap. So only consecutive pairs matter.

Both are enough to keep just three running values: the first index seen, the most
recent index, and the smallest adjacent gap so far.

# Approach: Single Pass With a Three-Node Window

Walk the list looking at previous, current and next, and test the current node:

$$\text{critical} \iff (v_{cur} > v_{prev} \wedge v_{cur} > v_{next}) \lor (v_{cur} < v_{prev} \wedge v_{cur} < v_{next})$$

Both comparisons are **strict**, which is why a plateau like `2,2,2` contains no
critical point — the middle of a flat run is neither strictly greater nor strictly
smaller than its neighbours.

When the current node is critical:

1. If it is the **first** one, record its index and stop there — a single point
   has no gap to measure.
2. Otherwise compare `index - last` against the best gap so far and keep the
   smaller.
3. Either way, update `last` to this index.

If fewer than two critical points were found, return `[-1, -1]`. Otherwise the
answer is `[minGap, last - first]`.

## The head and tail can never be critical

A critical point needs a neighbour on both sides, so index `0` and index `n - 1`
are excluded by definition. Each implementation enforces this structurally rather
than with a bounds check:

- **Rust** guards with `if let (Some(p), Some(next)) = (prev, &node.next)`. At the
  head `prev` is `None`; at the tail `node.next` is `None`. Either way the pattern
  fails and the node is skipped.
- **Go** starts `cur` at `head.Next` so the head is never tested, and loops
  `for cur.Next != nil` so it stops before the tail.
- **Python** does the same as Go: `cur_node` starts at `head.next` and the loop
  runs `while cur_node.next is not None`.
- **C++** starts its window at `head->next` and ends when `tmp1` becomes null,
  which is the same bracketing.

Example 3 punishes getting this wrong: the trailing `7` is larger than everything
before it, but has no successor, so it is not a maxima.

## Why the Rust `[-1, -1]` guard has three clauses

The check reads `first_idx == -1 || last_idx == -1 || last_idx == first_idx`. The
third clause is the one doing real work: it fires when exactly **one** critical
point was found, where `first_idx == last_idx` and `min_distance` is still
`i32::MAX`. Without it, that sentinel would be returned as if it were a distance.

The first two clauses are redundant — if `first_idx` is `-1` then nothing was ever
found and `last_idx` is `-1` as well, so the third clause already covers it.

## The Go and Python versions count from a shifted origin

Both initialise their counter at `0` while the cursor already points at the
**second** node, so it runs one behind the true 0-based index. For
`[5,3,1,2,5,1,2]` the critical points sit at true indices `2, 4, 5` but Go and
Python both record them as `1, 3, 4`.

That is harmless because every reported value is a **difference**, and a constant
offset cancels: the gaps are `2, 1` either way and the span is `3` either way. The
Rust and C++ versions track absolute indices instead, and all three agree on every
output.

## The Go and Python versions rely on the list having two or more nodes

Both dereference the second node before the loop starts, so a single-node list
breaks them: Go sets `cur` to `nil` and panics on `cur.Next`, and Python sets
`cur_node` to `None` and raises
`AttributeError: 'NoneType' object has no attribute 'next'`. Both were confirmed
by running them. The constraints guarantee at least two nodes so neither triggers,
but it is a genuine dependency on the input promise rather than a defensive
implementation. The C++ version instead returns `[-1, -1]` up front for any list
shorter than three nodes.

Rust's `while let Some(node) = head` copes with any length, including an empty
list, because the loop simply never runs.

# Worked examples

## `head = [3,1]` → `[-1,-1]`

Only two nodes, so no node has both a predecessor and a successor. The loop body
never executes and the initial `[-1, -1]` stands.

## `head = [5,3,1,2,5,1,2]` → `[1,3]`

| index | value | classification | running state |
| --- | --- | --- | --- |
| 2 | `1` | local minima (`1 < 3`, `1 < 2`) | first critical point → `first = 2` |
| 4 | `5` | local maxima (`5 > 2`, `5 > 1`) | gap `4 - 2 = 2` → min = `2` |
| 5 | `1` | local minima (`1 < 5`, `1 < 2`) | gap `5 - 4 = 1` → min = `1` |

Answer `[1, 5 - 2] = [1, 3]`. The minimum comes from the *last* adjacent pair, so
the running comparison really does have to keep improving.

## `head = [1,3,2,2,3,2,2,2,7]` → `[3,3]`

| index | value | classification | running state |
| --- | --- | --- | --- |
| 1 | `3` | local maxima (`3 > 1`, `3 > 2`) | first critical point → `first = 1` |
| 4 | `3` | local maxima (`3 > 2`, `3 > 2`) | gap `4 - 1 = 3` → min = `3` |

Answer `[3, 4 - 1] = [3, 3]`. Two things this pins down: the `2,2` runs yield no
critical points because the comparisons are strict, and the trailing `7` is
skipped for lack of a successor. With only two critical points the minimum and
maximum necessarily coincide.

## `head = [1,2,1,2,1]` → `[1,2]`

| index | value | classification | running state |
| --- | --- | --- | --- |
| 1 | `2` | local maxima | first critical point → `first = 1` |
| 2 | `1` | local minima | gap `1` → min = `1` |
| 3 | `2` | local maxima | gap `1` → min = `1` |

A fully alternating list: every interior node is critical, so the minimum gap is
`1` and the span is `3 - 1 = 2`.

# Complexity

- Time complexity: $$O(n)$$ — one traversal, constant work per node, where `n` is
  the number of nodes.
- Space complexity: $$O(1)$$ for the Go, Rust and Python versions, which keep only
  a few indices. The C++ version stores every critical index, so it is $$O(c)$$
  where `c` is the number of critical points — up to $$O(n)$$ on an alternating
  list.

# Code

## Go

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func nodesBetweenCriticalPoints(head *ListNode) []int {
    res := []int{-1, -1}    
    pre := head
    cur := head.Next
    prePos, curPos, firstPos, pos := -1, -1, -1, 0
    for cur.Next != nil {
        if (cur.Val < pre.Val && cur.Val < cur.Next.Val) || (cur.Val > pre.Val && cur.Val > cur.Next.Val) {
            // found local 
            prePos = curPos
            curPos = pos

            if firstPos == -1 {
                firstPos = pos
            }

            if prePos != -1 {
                if res[0] == -1 {
                    // find min distance
                    res[0] = curPos-prePos
                } else {
                    if curPos - prePos < res[0] {
                        res[0] = curPos - prePos
                    }
                }
                res[1] = pos - firstPos
            }
        }
        pos++
        pre = cur
        cur = cur.Next
    }   
    return res
}
```

Writing straight into `res` means the `[-1, -1]` default needs no special-casing
at the end: `res[0]` is only ever assigned once a second critical point exists,
which is exactly the condition for a valid answer.

## Rust

```rust
// Definition for singly-linked list.
// #[derive(PartialEq, Eq, Clone, Debug)]
// pub struct ListNode {
//   pub val: i32,
//   pub next: Option<Box<ListNode>>
// }
// 
// impl ListNode {
//   #[inline]
//   fn new(val: i32) -> Self {
//     ListNode {
//       next: None,
//       val
//     }
//   }
// }
impl Solution {
    pub fn nodes_between_critical_points(head: Option<Box<ListNode>>) -> Vec<i32> {
        let mut head = head;
        let mut prev = None;
        let (mut index, mut first_idx, mut last_idx) = (0, -1, -1);
        let (mut min_distance, mut max_distance) = (i32::MAX, 0);    
        while let Some(node) = head {
            if let (Some(p), Some(next)) = (prev, &node.next) {
                if (node.val > p && node.val > next.val) || (node.val < p && node.val < next.val) {
                    if first_idx == -1 {
                        first_idx = index;
                    } else {
                        if last_idx != -1 {
                            min_distance = min_distance.min(index - last_idx);  
                        }
                    }
                    last_idx = index;
                }
            }
            prev = Some(node.val);
            head = node.next;
            index += 1;
        }
        
        if first_idx == -1 || last_idx == -1 || last_idx == first_idx {
            return vec![-1, -1];
        }

        return vec![min_distance, last_idx - first_idx];
    }    
}
```

The ownership handling is worth reading closely. `while let Some(node) = head`
moves the node out of `head`, which is what allows `node.next` to be moved back
into `head` to advance — a borrow would not permit that. Because the node is
consumed, `prev` stores the **value** (`Some(node.val)`) rather than a reference,
sidestepping lifetimes entirely.

`max_distance` is declared but never read; the maximum is computed directly as
`last_idx - first_idx`. The compiler emits an unused-variable warning for it, so
dropping it and its `mut` is a harmless cleanup.

## Python

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def nodesBetweenCriticalPoints(self, head: Optional[ListNode]) -> List[int]:
        ans = [-1, -1]
        prev_node, cur_node = head, head.next
        prev_index, first_index = -1, -1
        index = 0
        while cur_node.next is not None:
            if (
                (cur_node.val < prev_node.val and cur_node.val < cur_node.next.val)
                or (cur_node.val > prev_node.val and cur_node.val > cur_node.next.val)
            ):
                if first_index == -1:
                    first_index = index
                    prev_index = index
                else:
                    if ans[0] == -1:
                        ans[0] = index - prev_index
                    else:
                        ans[0] = min(ans[0], index - prev_index)
                    ans[1] = index - first_index
                    prev_index = index
            index += 1
            prev_node = cur_node
            cur_node = cur_node.next

        return ans
```

Structurally this is the Go version in Python: the same shifted `index`, the same
write-into-`ans` trick that makes the `[-1, -1]` default fall out for free, and the
same reliance on the list having at least two nodes. It keeps a single
`prev_index` rather than Go's `prePos`/`curPos` pair, updating it at the end of
each branch, which is a little easier to follow — there is only ever one "previous
critical point" to remember.

## C++

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

This is the store-then-scan form: `v` accumulates every critical index, then one
loop finds the smallest adjacent gap and the endpoints give the span. It reads
closer to the definition at the cost of holding the indices.

# Test cases

| list | critical indices | answer | what it exercises |
| --- | --- | --- | --- |
| `[3,1]` | none | `[-1,-1]` | Example 1 — too short for any critical point |
| `[5,3,1,2,5,1,2]` | `2, 4, 5` | `[1,3]` | Example 2 — min comes from the last pair |
| `[1,3,2,2,3,2,2,2,7]` | `1, 4` | `[3,3]` | Example 3 — plateaus and the excluded tail |
| `[1,2,1,2,1]` | `1, 2, 3` | `[1,2]` | every interior node critical |
| `[1,2,1]` | `1` | `[-1,-1]` | exactly one critical point |
| `[2,2,2,2]` | none | `[-1,-1]` | a flat run has no strict extremes |

The Go, Rust and Python implementations were checked against a reference that
collects every critical index from the definition, then takes the minimum adjacent
gap and the total span. The corpus was **15840** cases: the three examples, every list of
length 2 to 8 over the alphabet `{1,2,3}` (exhaustive, so plateaus and ties are
covered densely), 4000 random lists over `{1,2,3,4}`, and 2000 random lists over
the full value range. All three matched the reference on every case.
