# Intuition
The goal is to divide players into teams where each team's total skill is equal. For the chemistry of each team, we multiply the skills of the two players. We aim to pair players in such a way that the sum of their skills remains constant for all teams and add the chemistry of each team to the result. If it's impossible to create equal-skill teams, we return -1.

<p>&nbsp;</p>

# Approach 2: Counting + Two Pointers

## Explanation:

1. **Frequency Counting**:
   - We start by initializing a frequency array (`freq[1001]`) to count how many players have each skill, since skill values range from 1 to 1000.
   - We then iterate over the `skill` array, updating the frequency of each skill. During this process, we track the smallest (`left`) and largest (`right`) skill values to guide our pairing process.

2. **Two Pointers Team Matching**:
   - The idea is to pair the smallest and largest available skill values (using two pointers, `left` and `right`).
   - For each pair of `left` and `right`:
     - If the number of players with skill `left` is not equal to the number of players with skill `right`, it is impossible to form teams with equal skill totals, so we return `-1`.
     - Otherwise, we calculate the total chemistry for all teams formed by pairing these skills, adding the result to the sum of chemistry.
   - We then move the `left` pointer forward and the `right` pointer backward, repeating this process until they meet.

3. **Handling Players with the Same Skill**:
   - If `left` equals `right` (i.e., when we only have players with the same skill left), we can only form teams if the number of these players is even. In that case, we calculate the chemistry for these players and add it to the result.

4. **Return the Result**:
   - Once all pairs have been processed, we return the total sum of chemistry.

## Complexity
- Time complexity: $O(n)$, where `n` is the length of the `skill` array.
- Space complexity: $O(n)$.

## Code 

```cpp
int freq[1001];

class Solution {
public:
    long long dividePlayers(vector<int>& skill) {
        memset(freq, 0, sizeof(freq));
        int left = 1001, right = 0;

        for (auto& x: skill) {
            ++freq[x];
            left = min(left, x);
            right = max(right, x);
        }

        long long res = 0;

        while (left < right) {
            if (freq[left] != freq[right]) return -1;
            res += 1LL * freq[left] * left++ * right--;
        }

        if (left == right) {
            res += 1LL * left * left * (freq[left] / 2);
        }

        return res;
    }
};
```

## Java Solution

```java
class Solution {
    public long dividePlayers(int[] skill) {
        Arrays.sort(skill);
        int N = skill.length;
        int teamSkill = skill[0] + skill[N-1];
        long totalChemistry = 0;
        int l = 0, r = N - 1;

        while (l < r) {
            if (skill[l] + skill[r] != teamSkill) {
                return -1; 
            }
            totalChemistry += (long) skill[l] * skill[r];  
            l++;
            r--;
        }
        
        return totalChemistry;
    }
}
