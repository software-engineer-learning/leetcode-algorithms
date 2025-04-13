# Intuition

The problem involves determining the maximum number of water bottles you can drink given an initial number of full water bottles `a` and the number of empty bottles `x` required to exchange for one full bottle. The solution can be derived using the concept of the sum of an infinite geometric progression.

<p>&nbsp;</p>

# Approach: Math

## Explanation:

1. **Understanding the Problem**:
   - You start with `a` full water bottles.
   - For every `x` empty bottles, you can exchange them for 1 full bottle.
   - Each time you drink a bottle, it becomes an empty bottle which can potentially be exchanged for another full bottle.

2. **Modeling the Problem as a Geometric Progression**:
   - Every time you drink a bottle, it contributes to the total number of full bottles you can eventually drink.
   - Let's denote:
     - `a` as the initial number of full bottles.
     - `x` as the exchange rate (number of empty bottles needed to get 1 full bottle).

3. **Summing the Bottles**:
   - After drinking the initial `a` bottles, you get `a` empty bottles.
   - These `a` empty bottles can be exchanged for `a/x` full bottles.
   - Those `a/x` full bottles will eventually also become empty and can be exchanged further, forming an infinite sequence.

4. **Using the Sum of an Infinite Geometric Progression**:
   - The sum $S$ of an infinite geometric series where the first term is $a$ and the common ratio $r$ is $\frac{1}{x}$ is given by:
        - ### $S = \frac{a}{1 - r}$
   - In this case, the first term $a$ is the initial number of full bottles, and the common ratio $r$ is $\frac{1}{x}$.

5. **Formula Derivation**:
   - Substitute $r = \frac{1}{x}$ into the geometric series formula:
        - ### $S = \frac{a}{1 - \frac{1}{x} } = \frac{a}{\frac{x-1}{x} } = \frac{a \cdot x}{x - 1}$
   - However, since we are dealing with integer bottles, we adjust the formula to account for integer division:
        - ### $S = \frac{a \cdot x - 1}{x - 1}$

## Complexity
- Time complexity: $O(1)$
- Space complexity: $O(1)$

## Code

```cpp
class Solution {
public:
    int numWaterBottles(int a, int x) {
        return (a * x - 1) / (x - 1);
    }
};
```