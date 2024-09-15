# Intuition
The problem asks for the longest substring with an even count of vowels. Each vowel can either appear an odd or even number of times in the substring. This leads to the idea of using a bitmask to track the parity (odd/even count) of each vowel. By XORing the bitmask when encountering a vowel, we can toggle its state between odd and even. If the same bitmask reappears at a later index, it means that the substring between these two indices has an even count of vowels.

# Approach
1. Create a map that assigns a unique bit to each vowel. For example, `a` is assigned 1, `e` is assigned 2, and so on.
2. Traverse the string, and for each character:
   - If it's a vowel, toggle the corresponding bit in a mask using XOR.
   - Track the first occurrence of each unique mask using a hashmap.
   - If the current mask has been seen before, calculate the length of the substring between the first occurrence of this mask and the current index.
   - Keep track of the maximum such length.
3. Return the maximum length of the substring found.

# Complexity
- Time complexity:
$O(n)$, where `n` is the length of the string. We traverse the string once, and all operations (map lookups and updates) are $O(1)$.

- Space complexity:
$O(n)$, as we use a hashmap to store the first occurrence of each unique mask, which could potentially have up to $$n$$ entries in the worst case.

# Code
```java
public class Solution {
    public int findTheLongestSubstring(String s) {
        Map<Character, Integer> vowelToBit = new HashMap<>();
        vowelToBit.put('a', 1);
        vowelToBit.put('e', 2);
        vowelToBit.put('i', 4);
        vowelToBit.put('o', 8);
        vowelToBit.put('u', 16);
        
        int mask = 0; 
        int maxLength = 0;
        
        Map<Integer, Integer> firstOccurrence = new HashMap<>();
        firstOccurrence.put(0, -1);
        
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            
            if (vowelToBit.containsKey(ch)) {
                mask ^= vowelToBit.get(ch);
            }
            
            if (firstOccurrence.containsKey(mask)) {
                maxLength = Math.max(maxLength, i - firstOccurrence.get(mask));
            } else {
                firstOccurrence.put(mask, i);
            }
        }
        
        return maxLength;
    }
}
```