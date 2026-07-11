# 3532. Path Existence Queries in a Graph I

You are given an integer `n` representing the number of nodes in a graph, labeled
from 0 to `n - 1`.

You are also given an integer array `nums` of length `n` sorted in **non-decreasing**
order, and an integer `maxDiff`.

An **undirected** edge exists between nodes `i` and `j` if the **absolute**
difference between `nums[i]` and `nums[j]` is **at most** `maxDiff` (i.e.,
`|nums[i] - nums[j]| <= maxDiff`).

You are also given a 2D integer array `queries`. For each `queries[i] = [ui, vi]`,
determine whether there exists a path between nodes `ui` and `vi`.

Return a boolean array `answer`, where `answer[i]` is `true` if there exists a
path between `ui` and `vi` in the `i`th query and `false` otherwise.

## Example 1

```text
Input: n = 2, nums = [1,3], maxDiff = 1, queries = [[0,0],[0,1]]
Output: [true,false]
Explanation:
- Query [0,0]: Node 0 has a trivial path to itself.
- Query [0,1]: There is no edge between Node 0 and Node 1 because |nums[0] - nums[1]| = |1 - 3| = 2, which is greater than maxDiff.
- Thus, the final answer after processing all the queries is [true, false].
```

## Example 2

```text
Input: n = 4, nums = [2,5,6,8], maxDiff = 2, queries = [[0,1],[0,2],[1,3],[2,3]]
Output: [false,false,true,true]
Explanation:
- Query [0,1]: No edge; |2 - 5| = 3 > maxDiff.
- Query [0,2]: No path; |2 - 6| = 4 > maxDiff.
- Query [1,3]: Path 1 -> 2 -> 3 via edges with gaps 1 and 2.
- Query [2,3]: Direct edge; |6 - 8| = 2 <= maxDiff.
- Thus, the final answer is [false, false, true, true].
```

## Constraints

- `1 <= n == nums.length <= 10^5`
- `0 <= nums[i] <= 10^5`
- `nums` is sorted in **non-decreasing** order.
- `0 <= maxDiff <= 10^5`
- `1 <= queries.length <= 10^5`
- `queries[i] == [ui, vi]`
- `0 <= ui, vi < n`
