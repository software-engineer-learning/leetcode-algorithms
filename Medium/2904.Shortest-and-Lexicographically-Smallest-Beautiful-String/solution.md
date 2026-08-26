# Intuition

There are $$O(n^2)$$ substrings, but almost none of them can be the answer. Two
observations shrink the search dramatically, and both approaches below rest on
them.

**A winning substring must begin and end with `1`.** If it began with `0`,
deleting that leading `0` would leave the same number of ones in a strictly
shorter substring — so the original was never the shortest. The same argument
applies to a trailing `0`.

**Therefore a candidate is pinned by a run of `k` consecutive ones.** Take the
`i`-th one and the `(i + k - 1)`-th one; the substring spanning exactly those two
positions is the only candidate for that group. There are at most
$$n - k + 1$$ such groups.

The two approaches differ only in how they enumerate those candidates: the first
rescans forward from every `1`, the second slides a window across the string in a
single pass.

# Approach 1: Expand From Each `1`

For every index `i`:

1. Skip it unless `s[i] == '1'`.
2. Walk forward, appending characters, until `k` ones have been collected.
3. If the walk ran off the end with fewer than `k` ones, discard this start.
4. Otherwise compare the candidate against the best so far.

## The comparison is on two keys

The answer is ranked first by length, then lexicographically:

- **Strictly shorter** than the best so far — take it, and record the new length.
- **Equal length** — keep whichever is lexicographically smaller.
- **Longer** — ignore it.

Because all candidates of the minimal length start with `1` and end with `1`, the
lexicographic tie-break is decided purely by the zeros and ones in between.

## The detail that makes it correct: where the count is checked

The `k`-reached test sits at the **top** of the inner loop — `if count == k break`
in Rust and Python, and `count < k` in the Go loop condition. That is what makes
the candidate end exactly on the `k`-th `1`.

Moving that test to the bottom would append trailing zeros before noticing the
quota was met, producing longer candidates and a wrong answer.

## Why `minLength = n + 1`, and why `ans` is never empty when compared

The sentinel is one past the longest possible substring, so the first valid
candidate always satisfies `minLength > len(sub)` and lands in the first branch —
which sets `ans` as well as `minLength`.

That matters for the tie branch. Reaching `minLength == len(sub)` requires
`minLength ≤ n`, which can only be true if the first branch already ran, so `ans`
holds a real candidate by then. The `min(ans, sub)` and `sub_str < ans`
comparisons therefore never see the initial empty string — which would otherwise
win every comparison and force an empty result.

# Approach 2: One-Pass Sliding Window

Approach 1 rescans forward from every `1`, so a character can be read many times.
A window with two pointers reads each character a bounded number of times instead.

The Rust and Go versions keep a window `[l, r]` and maintain two invariants after
each step:

- **at most `k` ones inside** — shrink from the left while `count > k`;
- **the window starts on a `1`** — shrink while `s[l] == '0'`.

The second invariant is the sliding-window spelling of "a winning substring begins
with `1`". Both live in the same `while` loop, so a single condition maintains
both. Whenever `count == k` after shrinking, the window is a candidate, compared
on the same `(length, lexicographic)` keys as before.

The Python version enumerates the same candidates from the other direction: it
records the index of every `1` first, then reads off consecutive groups of `k` of
them. `ones[i]` and `ones[i + k - 1]` give the candidate's endpoints directly, so
its length is available in $$O(1)$$ with no window bookkeeping at all.

## Why `s[l]` can never run off the end

The Rust loop indexes `s[l]` with no bounds guard, which deserves justification.

`l` only advances while `count > k` **or** `s[l] == '0'`. For `l` to move past the
*last* `1` in the string, the condition would have to hold while `l` sits on it.
At that moment `s[l] == '1'`, so the second clause is false, and the window
`[l, r]` contains exactly that single one — meaning `count == 1`. Advancing would
then require `1 > k`, impossible because $$k \ge 1$$.

So `l` always halts on a `1` at or before the last one, and the index stays in
range. The Go version adds an explicit `l < len(s)` guard, which is defensive
rather than necessary — the invariant makes it unreachable either way.

## Why `ans` starts as the whole string

Both window versions return early when `s` holds fewer than `k` ones, so by the
time the scan begins a beautiful substring is guaranteed to exist. Seeding `ans`
with all of `s` therefore acts as a sentinel of maximal length: every candidate is
at most `n` characters, so the first one wins on length.

The one case where it does not win is when the answer *is* the whole string — then
`sub.len() == ans.len()` and `sub < ans` is false, so `ans` keeps a value already
equal to the candidate. Verified on `s = "101", k = 2` and
`s = "100000001", k = 2`, both of which return the entire string.

Python needs no such sentinel: if fewer than `k` ones exist then
`range(len(ones) - k + 1)` is empty, the loop never runs, and the initial `""`
falls through as the answer.

# Worked examples

## `s = "100011001", k = 3` → `"11001"`

Approach 1, one candidate per starting `1`:

| `i` | candidate  | outcome                                  |
| --- | ---------- | ---------------------------------------- |
| 0   | `"100011"` | first valid, length 6 → best             |
| 1–3 | —          | starts on `'0'`, skipped                 |
| 4   | `"11001"`  | length 5 beats 6 → **new best**          |
| 5   | `"1001"`   | only 2 ones before the end → rejected    |
| 6–7 | —          | starts on `'0'`, skipped                 |
| 8   | `"1"`      | only 1 one before the end → rejected     |

Approach 2 reaches the same two candidates without the rejected starts: the ones
sit at indices `0, 4, 5, 8`, so the groups of three are `(0, 5)` spanning
`"100011"` and `(4, 8)` spanning `"11001"`. The second is shorter, and it wins.

## `s = "1011", k = 2` → `"11"`

| `i` | candidate | outcome                        |
| --- | --------- | ------------------------------ |
| 0   | `"101"`   | first valid, length 3 → best   |
| 1   | —         | starts on `'0'`, skipped       |
| 2   | `"11"`    | length 2 beats 3 → **new best**|
| 3   | `"1"`     | only 1 one → rejected          |

Ones at `0, 2, 3`; groups of two are `(0, 2) = "101"` and `(2, 3) = "11"`.

## `s = "11011", k = 2` → `"11"` (the tie branch)

| `i` | candidate | outcome                                        |
| --- | --------- | ---------------------------------------------- |
| 0   | `"11"`    | first valid, length 2 → best                   |
| 1   | `"101"`   | length 3 > 2 → ignored                         |
| 2   | —         | starts on `'0'`, skipped                       |
| 3   | `"11"`    | ties at length 2 → `min("11", "11")` = `"11"`  |
| 4   | `"1"`     | only 1 one → rejected                          |

This is the case that exercises the equal-length branch in both approaches.

## `s = "000", k = 1` → `""`

Approach 1 skips every start and returns the initial empty `ans`. Approach 2
returns early, because `s` contains fewer than `k` ones.

# Complexity

Let `n` be the length of `s`, and `L` the length of the answer.

| | Approach 1 | Approach 2 |
| --- | --- | --- |
| Candidate enumeration | $$O(n^2)$$ — each `1` rescans forward | $$O(n)$$ — each index enters and leaves the window once |
| Space | $$O(n)$$ | $$O(n)$$ for the answer, plus $$O(n)$$ for the index list in Python |

The headline gain is in enumeration: approach 2 finds the same candidates in one
pass instead of rescanning from every `1`.

Both then materialise and compare candidate strings, which costs $$O(L)$$ each
time a candidate wins or ties, so neither is strictly linear as written — the true
worst case is $$O(n \cdot L)$$. Tracking only the pair `(start, length)` and
slicing once at the very end would make approach 2 genuinely $$O(n)$$. At
$$n \le 100$$ the distinction is academic.

# Code

## Approach 1: expand from each `1`

### Go

```go
func shortestBeautifulSubstring(s string, k int) string {
    ans := ""
    n := len(s)
    minLength := n + 1
    for i := range n {
        if s[i] == '0' {
            continue
        }
        sub, count := []uint8{}, 0
        for j := i; count < k && j < n; j++ {
            if s[j] == '1' {
                count++
            }
            sub = append(sub, s[j])
        }
        if count == k {
            if minLength > len(sub) {
                minLength = len(sub)
                ans = string(sub)
            } else if minLength == len(sub) {
                ans = min(ans, string(sub))
            }
        }
    }
    return ans
}
```

Two version notes: `for i := range n` is range-over-integer, added in **Go 1.22**;
on an older toolchain write `for i := 0; i < n; i++`. The builtin `min` applied to
two strings needs **Go 1.21**, where `min` and `max` became generic over ordered
types — strings included, comparing lexicographically.

### Rust

```rust
impl Solution {
    pub fn shortest_beautiful_substring(s: String, k: i32) -> String {
        let s = s.as_bytes();
        let n = s.len();
        let mut min_length = n + 1;
        let mut ans = String::new();
        for i in 0..n {
            if s[i] == b'0' {
                continue;
            }
            let (mut count, mut sub) = (0, vec![]);
            for j in i..n {
                if count == k {
                    break;
                }
                if s[j] == b'1' {
                    count += 1;
                }
                sub.push(s[j]);
            }
            let sub_str: String = String::from_utf8(sub).expect("");
            if count == k {
                if min_length > sub_str.len() {
                    min_length = sub_str.len();
                    ans = sub_str;
                } else if min_length == sub_str.len() && sub_str < ans {
                    ans = sub_str;
                }
            }
        }
        ans
    }
}
```

`String::from_utf8` cannot fail here: the bytes are copied out of a binary string,
so they are always ASCII `0` and `1`. Rust's `<` on `String` is a byte-wise
lexicographic comparison, which matches the problem's definition for this
alphabet.

### Python

```python
class Solution:
    def shortestBeautifulSubstring(self, s: str, k: int) -> str:
        ans = ""
        n = len(s)
        minLength = n + 1
        for i in range(n):
            if s[i] == '0':
                continue
            sub, count = "", 0
            for j in range(i, n):
                if count == k:
                    break
                if s[j] == '1':
                    count += 1
                sub += s[j]
            if count == k:
                if minLength > len(sub):
                    minLength, ans = len(sub), sub
                elif minLength == len(sub):
                    ans = min(ans, sub)

        return ans
```

Building `sub` with repeated `+=` allocates a fresh string on each step in the
general case, so the inner loop is quadratic in its own right. At $$n \le 100$$
that is immaterial; `"".join(...)` over a list would avoid it.

## Approach 2: one pass

### Go

```go
import "strings"

func shortestBeautifulSubstring(s string, k int) string {
    if strings.Count(s, "1") < k {
        return ""
    }
    ans := s
    count, l := 0, 0
    for r := range len(s) {
        count += int(s[r] - '0')
        for count > k || (l < len(s) && s[l] == '0') {
            count -= int(s[l] - '0')
            l++
        }
        if count == k {
            sub := s[l: r + 1]
            if len(sub) < len(ans) || len(sub) == len(ans) && sub < ans {
                ans = sub
            }
        }
    }
    return ans
}
```

`s[l:r+1]` is a slice header into the original string, not a copy, so Go's version
allocates nothing per candidate — only the comparison costs anything.

### Rust

```rust
impl Solution {
    pub fn shortest_beautiful_substring(s: String, k: i32) -> String {
        if s.as_bytes().iter().filter(|&&b| b == b'1').count() < k as usize {
            return String::new();
        }
        
        let mut ans = s.clone();
        let s = s.as_bytes();
        let (mut count, mut l) = (0, 0);
        for r in 0..s.len() {
            count += (s[r] - b'0') as i32;
            while count > k || s[l] == b'0' {
                count -= (s[l] - b'0') as i32;
                l += 1;
            }
            if count == k {
                let sub = String::from_utf8(s[l..=r].to_vec()).expect("");
                if sub.len() < ans.len() || sub.len() == ans.len() && sub < ans {
                    ans = sub;
                }
            }
        }
        ans
    }
}
```

`count += (s[r] - b'0') as i32` exploits the alphabet: `'0'` and `'1'` map to `0`
and `1`, so the same expression both tests and counts, with no branch.

### Python

```python
class Solution:
    def shortestBeautifulSubstring(self, s: str, k: int) -> str:
        ones = []
        n = len(s)
        for i, ch in enumerate(s):
            if ch == '1':
                ones.append(i)
        res, min_length = "", n + 1
        for i in range(len(ones) - k + 1):
            first, last = ones[i], ones[i+k-1]
            length = last - first + 1
            if length < min_length:
                min_length = length
                res = s[first:(last+1)]
            elif length == min_length and res > s[first:(last+1)]:
                res = s[first:(last + 1)]
        return res
```

This is the most direct statement of the key observation: a candidate *is* a group
of `k` consecutive ones, and `ones[i]` with `ones[i + k - 1]` are its endpoints.
The "must start and end with `1`" rule is not enforced by a check — it is built
into how the candidates are constructed.

# Test cases

| `s`           | `k` | answer        | what it exercises                      |
| ------------- | --- | ------------- | -------------------------------------- |
| `"100011001"` | `3` | `"11001"`     | Example 1                              |
| `"1011"`      | `2` | `"11"`        | Example 2                              |
| `"000"`       | `1` | `""`          | Example 3 — no beautiful substring     |
| `"11011"`     | `2` | `"11"`        | equal-length tie-break branch           |
| `"101"`       | `2` | `"101"`       | answer is the whole string (sentinel)  |
| `"100000001"` | `2` | `"100000001"` | same, with a long zero run             |
| `"1"`         | `2` | `""`          | fewer ones than `k`                    |
| `"0110"`      | `2` | `"11"`        | leading and trailing zeros trimmed     |

All six implementations were checked against a brute force that enumerates every
substring and picks the minimum by `(length, text)`. The corpus was **94117**
cases: the three examples, every binary string of length 1 through 12 paired with
every valid `k`, and 4000 random strings at the constraint ceiling. All six agreed
on every case, with zero mismatches against the reference. The Rust window version
was built in debug mode, where an out-of-range index panics, and never did —
confirming the `s[l]` argument above.
