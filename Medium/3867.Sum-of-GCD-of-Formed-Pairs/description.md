# 3867. Sum of GCD of Formed Pairs

You are given an integer array `nums` of length `n`.

Construct an array `prefixGcd` where for each index `i`:

- Let `mxi = max(nums[0], nums[1], ..., nums[i])`.
- `prefixGcd[i] = gcd(nums[i], mxi)`.

After constructing `prefixGcd`:

- Sort `prefixGcd` in **non-decreasing** order.
- Form pairs by taking the **smallest unpaired** element and the **largest unpaired**
  element.
- Repeat this process until no more pairs can be formed.
- For each formed pair, **compute** the `gcd` of the two elements.
- If `n` is odd, the **middle** element in the `prefixGcd` array remains **unpaired**
  and should be ignored.

Return an integer denoting the **sum of the GCD** values of all formed pairs.

The term `gcd(a, b)` denotes the **greatest common divisor** of `a` and `b`.

## Example 1

```text
Input: nums = [2,6,4]
Output: 2
Explanation:
Construct prefixGcd:
- i = 0: nums[0] = 2, mxi = 2, prefixGcd[0] = 2
- i = 1: nums[1] = 6, mxi = 6, prefixGcd[1] = 6
- i = 2: nums[2] = 4, mxi = 6, prefixGcd[2] = 2
prefixGcd = [2, 6, 2]. After sorting: [2, 2, 6].
Pair the smallest and largest: gcd(2, 6) = 2. The middle 2 is ignored.
Thus, the sum is 2.
```

## Example 2

```text
Input: nums = [3,6,2,8]
Output: 5
Explanation:
Construct prefixGcd:
- i = 0: nums[0] = 3, mxi = 3, prefixGcd[0] = 3
- i = 1: nums[1] = 6, mxi = 6, prefixGcd[1] = 6
- i = 2: nums[2] = 2, mxi = 6, prefixGcd[2] = 2
- i = 3: nums[3] = 8, mxi = 8, prefixGcd[3] = 8
prefixGcd = [3, 6, 2, 8]. After sorting: [2, 3, 6, 8].
Pairs: gcd(2, 8) = 2 and gcd(3, 6) = 3. Sum = 2 + 3 = 5.
```

## Constraints

- `1 <= n == nums.length <= 10^5`
- `1 <= nums[i] <= 10^9`
