# Intuition

Nothing about this game needs to be simulated. Only two facts about `num` matter:
how far apart the two halves' digit sums are, and how the `'?'` blanks are split
between them. Everything else — which blank a player picks, in what order — turns
out to be irrelevant under optimal play, so the answer collapses to a
constant-size arithmetic test after one pass over the string.

The reason is that Bob only wins on a knife edge. He needs the final sums to be
*exactly* equal, while Alice wins on every other outcome. A single target against
everything else is a fragile position, and it survives only when the blanks let Bob
mirror every move Alice makes.

Both quantities can be tracked as **signed running differences**: add for the left
half, subtract for the right. One number then carries the digit gap and another
carries the blank imbalance, with no need to keep the two halves apart.

# Approach: Parity and the Balance Point

Walk the string once, treating the left half as positive and the right half as
negative:

- `sumDiff` — digit sum of the left half minus digit sum of the right half.
- `cntDiff` — number of `'?'` in the left half minus the number in the right half.

Two rules then decide the game.

## Rule 1: an odd blank imbalance means Alice wins

`cntDiff` and the total blank count `qLeft + qRight` always share the same parity,
because they differ by `2 * qRight`. So testing `cntDiff % 2 != 0` is exactly a test
for an odd *total* number of blanks.

When that total is odd the players alternate `A, B, A, ... , A`, so **Alice takes
the final move**. At that point one blank remains and the rest of the board is
fixed, meaning the two sums are already determined up to her single digit. Of the
ten digits available, at most one makes the sums equal; she writes any of the other
nine and wins.

## Rule 2: otherwise Bob needs one exact value

With an even blank count, Bob wins **iff**

$$2 \cdot \text{sumDiff} + 9 \cdot \text{cntDiff} = 0$$

so Alice wins whenever that expression is non-zero — which is precisely the second
half of the returned condition.

### Where the 9 comes from

Group the blanks into pairs, which is possible because there is an even number of
them. Writing `a` for the left blank count and `b` for the right, and
taking $$a \le b$$ for concreteness:

- **`a` cross pairs**, each holding one blank in the left half and one in the right.
- **`(b - a) / 2` same-side pairs**, each holding two blanks in the right half —
  the surplus that `cntDiff` measures.

Bob's strategy is simply *to close whatever pair Alice opens*:

- Alice writes `d` into a cross pair → Bob writes the **same `d`** into that pair's
  other blank, in the opposite half. Both sums rise by `d`, so `sumDiff` is
  unchanged.
- Alice writes `d` into a same-side pair → Bob writes **`9 - d`** into that pair's
  other blank. The pair contributes exactly `9` to the right half whatever Alice
  chose.

Alice always moves first within a pair and Bob always answers inside that same
pair, so every pair resolves this way. Cross pairs move `sumDiff` by `0`; each of
the `(b - a) / 2` same-side pairs drives it down by `9`. The final difference is
therefore forced to

$$\text{sumDiff} - \frac{9 \cdot (b - a)}{2} = \text{sumDiff} + \frac{9 \cdot \text{cntDiff}}{2}$$

since $$\text{cntDiff} = a - b$$. Bob wins exactly when that lands on zero.

### Why the formula is doubled

Setting the expression above to zero gives the balance point

$$\text{sumDiff} = -\frac{9 \cdot \text{cntDiff}}{2}$$

which involves a division by two. Multiplying both sides through by `2` clears it:

$$2 \cdot \text{sumDiff} + 9 \cdot \text{cntDiff} = 0$$

This is the form the code uses, and it is strictly better than dividing. `cntDiff`
is even on this branch so the division would be exact — but writing it as a
multiplication means there is no truncation to reason about at all, and in
particular no need to think about how each language rounds negative integer
division. The test stays pure integer arithmetic.

### Why anything else loses for Bob

The pairing argument is what Bob's win *depends on*: mirroring drives the
difference to exactly one reachable value. If the doubled expression starts
non-zero, that forced landing point is not zero either, and Alice — who opens every
pair — can hold it away from zero by playing the extreme digits `0` and `9`, which
Bob's single reply cannot fully absorb.

So the entire game reduces to:

```text
cntDiff is odd                    -> Alice wins
even, 2*sumDiff + 9*cntDiff == 0  -> Bob wins
even, 2*sumDiff + 9*cntDiff != 0  -> Alice wins
```

## Reading the sign of `cntDiff`

The signed convention keeps working in both directions with no special cases:

- `cntDiff < 0` — the right half holds surplus blanks, so those pairs will add to
  the right. Bob needs the left half to start *ahead*, and the required
  value $$-9 \cdot \text{cntDiff} / 2$$ is then positive.
- `cntDiff > 0` — the surplus is on the left, so Bob needs the left half to start
  *behind*, and the required `sumDiff` is negative.
- `cntDiff == 0` — the blanks pair up across the halves and cancel, so Bob simply
  needs `sumDiff == 0`.

# Worked examples

## `num = "5023"` → `false`

| position | char | half  | effect            |
| -------- | ---- | ----- | ----------------- |
| 0        | `5`  | left  | `sumDiff += 5` → 5 |
| 1        | `0`  | left  | `sumDiff += 0` → 5 |
| 2        | `2`  | right | `sumDiff -= 2` → 3 |
| 3        | `3`  | right | `sumDiff -= 3` → 0 |

Final `sumDiff = 0`, `cntDiff = 0`. The count is even, and
`2 * 0 + 9 * 0 = 0`, so Bob wins and the answer is `false`. This is the degenerate
case: no moves exist and the halves are already equal.

## `num = "25??"` → `true`

| position | char | half  | effect              |
| -------- | ---- | ----- | ------------------- |
| 0        | `2`  | left  | `sumDiff += 2` → 2  |
| 1        | `5`  | left  | `sumDiff += 5` → 7  |
| 2        | `?`  | right | `cntDiff -= 1` → -1 |
| 3        | `?`  | right | `cntDiff -= 1` → -2 |

Final `sumDiff = 7`, `cntDiff = -2`, which is even, so Rule 2 applies:
`2 * 7 + 9 * (-2) = 14 - 18 = -4`, non-zero, so Alice wins.

Concretely: both blanks form one same-side pair in the right half. Whatever Alice
writes, Bob's best reply makes that pair total `9`, giving `9` on the right against
`7` on the left. Bob would need a left half of exactly `9` to survive.

## `num = "?3295???"` → `false`

| position | char | half  | effect               |
| -------- | ---- | ----- | -------------------- |
| 0        | `?`  | left  | `cntDiff += 1` → 1   |
| 1        | `3`  | left  | `sumDiff += 3` → 3   |
| 2        | `2`  | left  | `sumDiff += 2` → 5   |
| 3        | `9`  | left  | `sumDiff += 9` → 14  |
| 4        | `5`  | right | `sumDiff -= 5` → 9   |
| 5        | `?`  | right | `cntDiff -= 1` → 0   |
| 6        | `?`  | right | `cntDiff -= 1` → -1  |
| 7        | `?`  | right | `cntDiff -= 1` → -2  |

Final `sumDiff = 9`, `cntDiff = -2`, even, and
`2 * 9 + 9 * (-2) = 18 - 18 = 0`, so Bob wins and the answer is `false`.

Reading Bob's play off the decomposition: the four blanks split into one cross pair
(the left `?` with one right `?`) and one same-side pair (the last two right `?`).
The cross pair leaves `sumDiff` at `9`; the same-side pair adds exactly `9` to the
right. Final sums are `14 + d` on the left and `5 + d + 9` on the right for
whatever `d` Alice played in the cross pair — equal for every choice. That matches
the walkthrough in the statement, which ends `9+3+2+9 = 5+9+2+7`.

# Implementation notes

- **`% 2 != 0`, never `% 2 == 1`.** `cntDiff` is a signed difference and is
  routinely negative. Go and Rust take the sign of the dividend, so `-3 % 2` is
  `-1` there, while Python floors and yields `1`. Comparing against `0` is correct
  in all three languages; comparing against `1` would silently break the Go and
  Rust versions on any input whose left half holds more blanks.
- **Short-circuit ordering.** The parity test comes first, so the arithmetic check
  is only reached when the blank count is even — exactly the case the pairing
  argument covers.
- **The Go loop needs Go 1.22+.** `for i := range n / 2` uses range-over-integer,
  added in Go 1.22; on older toolchains write `for i := 0; i < n/2; i++`.
- **No overflow.** With $$n \le 10^5$$ the digit sums stay below $$9 \cdot 10^5$$,
  and doubling keeps the expression under $$2 \cdot 10^6$$ — comfortably inside
  32-bit range, so Rust's `i32` is safe.

# Complexity

- Time complexity: $$O(n)$$ — one pass over `num`, where `n` is its length.
- Space complexity: $$O(1)$$ — two integer accumulators.

# Code

## Go

```go
func sumGame(num string) bool {
    n := len(num)
    sumDiff, cntDiff := 0, 0
    for i := range n / 2 {
        if num[i] == '?' {
            cntDiff++
        } else {
            sumDiff += int(num[i] - '0')
        }
    }
    for i := n/2; i < n; i++ {
        if num[i] == '?' {
            cntDiff--
        } else {
            sumDiff -= int(num[i] - '0')
        }
    }
    return cntDiff % 2 != 0 || 2 * sumDiff + 9 * cntDiff != 0
}
```

## Rust

```rust
impl Solution {
    pub fn sum_game(num: String) -> bool {
        let num = num.as_bytes();
        let n = num.len();
        let (mut sum_diff, mut cnt_diff) = (0, 0i32);
        for i in 0..n/2 {
            if num[i] == b'?' {
                cnt_diff += 1;
            } else {
                sum_diff += (num[i] - b'0') as i32;
            }
        }
        for i in n/2..n {
            if num[i] == b'?' {
                cnt_diff -= 1;
            } else {
                sum_diff -= (num[i] - b'0') as i32;
            }
        }
        cnt_diff % 2 != 0 || 2 * sum_diff + 9 * cnt_diff != 0
    }
}
```

## Python

```python
class Solution:
    def sumGame(self, num: str) -> bool:
        sum_diff, cnt_diff = 0, 0
        n = len(num)
        for i in range(0, n//2):
            if num[i] == '?':
                cnt_diff += 1
            else:
                sum_diff += int(num[i])

        for i in range(n//2,n):
            if num[i] == '?':
                cnt_diff -= 1
            else:
                sum_diff -= int(num[i])
        return cnt_diff % 2 != 0 or (2 * sum_diff + 9 * cnt_diff != 0)
```

# Test cases

| `num`        | `sumDiff` | `cntDiff` | parity | `2*sumDiff + 9*cntDiff` | result  |
| ------------ | --------- | --------- | ------ | ----------------------- | ------- |
| `"5023"`     | 0         | 0         | even   | 0                       | `false` |
| `"25??"`     | 7         | -2        | even   | -4                      | `true`  |
| `"?3295???"` | 9         | -2        | even   | 0                       | `false` |
| `"99"`       | 0         | 0         | even   | 0                       | `false` |
| `"9?7?"`     | 2         | 0         | even   | 4                       | `true`  |
| `"??00"`     | 0         | 2         | even   | 18                      | `true`  |
| `"?0"`       | 0         | 1         | odd    | (short-circuited)       | `true`  |

The characterisation was checked against an exhaustive memoised minimax over the
full game tree: all 121 strings of length 2 and all 14641 of length 4 agree, as do
3000 random strings of length 6 and 8. The Go, Rust and Python versions were run
independently and return identical verdicts on every one of those inputs.
