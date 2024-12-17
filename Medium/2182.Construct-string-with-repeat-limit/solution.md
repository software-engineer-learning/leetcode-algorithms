# Intuition

- Key insight to solve this problem is you can greedily take the lexicographically largest character until reaching limit, at that point there are 2 possible cases:
  - The current char is exhausted (`count` is 0) -> we just proceed to the next char
  - The current char can still be use (`count` > 0) but you reached limit -> you can take 1 from the next lexicographically largest character as padding then keep taking current char, repeat until you can't.
  - One thing to note is that if there are no "next char", that mean you have exhausted all options so just return the result string

<p>&nbsp;</p>

# Approach: Max-heap

- For this kind of problem, you would intuitively think about using a frequency map/array to store the `count` of each characters in string, but the problem would be how to correctly access characters.
- As we discussed above in the intuition section, we can greedily take the lexicographically largest char until reaching limit, so we need a way to access the largest available char quickly. For this we can use a max heap to store a `pair<int, int>` with the first element the ASCII value of the character, that way the largest char will always bubble top.

## Explanation:
starting from the head.

## Complexity
- Time complexity: $O(nlog(k))$ with `k` is the number of unique characters (at most 26), each push/pop operation takes $log(k)$ time and can repeat at most `n` times
- Space complexity: $O(26)$ without counting the return `res` string the size of the heap and frequency array can be at worse 26.

## Code

### C++
```cpp
class Solution {
public:
    string repeatLimitedString(string s, int repeatLimit) {
        int n = s.size();
        priority_queue<pair<int, int>> heap;
        int bucket[26];
        for(char c : s) {
            bucket[c-'a']++;
        }

        for(int i = 0; i < 26; i++) {
            if(bucket[i] == 0) continue;
            heap.push({i, bucket[i]});
        } 
        string res;
        while(!heap.empty()) {
            auto top = heap.top();
            heap.pop();
            int count = top.second;
            char c = top.first + 'a';
            if(res.empty() || res.back() != c) {
                int k = repeatLimit;
                while(k > 0 && count > 0) {
                    res += c;
                    count--;
                    k--;
                }
                if(count > 0) {
                    if(heap.empty()) return res;
                    // if reaching limit but current char can still be reuse
                    // pad with next char so we can keep using current char
                    auto top2 = heap.top();
                    heap.pop();
                    res += top2.first+'a';
                    top2.second--;
                    if(top2.second > 0) heap.push(top2);
                    heap.push({c-'a', count});
                }
            }
        }
        return res;
    }
};
```