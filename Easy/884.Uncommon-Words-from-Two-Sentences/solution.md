# Intuition
The problem asks to find uncommon words from two sentences. An uncommon word is defined as one that appears exactly once in one sentence and does not appear in the other sentence. My first thought is to count the occurrences of each word from both sentences and identify the ones that appear only once.

# Approach
1. Split both sentences into arrays of words.
2. Use a map to store the word frequencies from both sentences combined.
3. Iterate through each word and count its occurrences.
4. Add words that have a frequency of 1 to the result list, as they appear only once across both sentences.
5. Convert the result list to an array and return it.

# Complexity
- Time complexity:  
  The time complexity is $O(n)$, where $$n$$ is the total number of words in both sentences combined. This includes the time for splitting the sentences and traversing them to update the map and filter the result.
  
- Space complexity:  
  The space complexity is $O(n)$, as we need space for the word frequency map and the result list.

# Code
```java
class Solution {
    public String[] uncommonFromSentences(String s1, String s2) {
        String[] s1_new = s1.split(" ");
        String[] s2_new = s2.split(" ");

        Map<String, Integer> word_map = new HashMap<>();

        for (String str : s1_new) {
            word_map.put(str, word_map.getOrDefault(str, 0) + 1);
        }

        for (String str : s2_new) {
            word_map.put(str, word_map.getOrDefault(str, 0) + 1);
        }

        List<String> result = new ArrayList<>();

        for (String key : word_map.keySet()) {
            if (word_map.get(key) == 1) {
                result.add(key);
            }
        }

        return result.toArray(new String[0]);
    }
}
```