# 3514. Number of Unique XOR Triplets II

You are given an integer array `nums`.

A **XOR triplet** is defined as the XOR of three elements
`nums[i] XOR nums[j] XOR nums[k]` where `i <= j <= k`.

Return the number of **unique** XOR triplet values from all possible triplets
`(i, j, k)`.

## Example 1

```text
Input: nums = [1,3]
Output: 2
Explanation:
The possible XOR triplet values are:
- (0, 0, 0) -> 1 XOR 1 XOR 1 = 1
- (0, 0, 1) -> 1 XOR 1 XOR 3 = 3
- (0, 1, 1) -> 1 XOR 3 XOR 3 = 1
- (1, 1, 1) -> 3 XOR 3 XOR 3 = 3
The unique XOR values are {1, 3}. Thus, the output is 2.
```

## Example 2

```text
Input: nums = [6,7,8,9]
Output: 4
Explanation:
The possible XOR triplet values are {6, 7, 8, 9}. Thus, the output is 4.
```

## Constraints

- `1 <= nums.length <= 1500`
- `1 <= nums[i] <= 1500`
