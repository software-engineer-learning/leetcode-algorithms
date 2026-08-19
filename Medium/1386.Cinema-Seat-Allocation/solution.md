# Intuition

Each row has 10 seats, but a four-person block can only ever use seats among
`2..9` — seats `1` and `10` are on the aisle ends and belong to no block. There are
exactly three candidate blocks in a row:

- **Left**: seats `2, 3, 4, 5`
- **Middle**: seats `4, 5, 6, 7`
- **Right**: seats `6, 7, 8, 9`

Two key observations make the problem easy:

1. **Rows are independent.** A group must sit in one row, and no block spans two
   rows, so we can maximize each row separately and sum the results.
2. **Left and Right don't overlap** (seats `2-5` vs `6-9`), but **Middle overlaps
   both**. So per row the best we can do is:
   - `2` groups if *both* Left and Right are fully free (they occupy disjoint
     seats),
   - otherwise `1` group if *any single* block (Left, Middle, or Right) is fully
     free,
   - otherwise `0`.

Because `n` can be up to `10^9` but at most `10^4` seats are reserved, we must avoid
iterating over all `n` rows. The trick: **a row with no reservation in seats `2..9`
always yields 2 groups.** Only rows that actually appear in `reservedSeats` (in the
relevant columns) can yield fewer, so we handle those explicitly and give every
other row the full `2`.

# Approach: Bitmask per Row + Hash Map of Affected Rows

**Step 1 — Encode each affected row as an 8-bit mask.**
For every reservation `[row, col]` with `2 <= col <= 9`, set bit `col - 2` in that
row's mask. Seats `2..9` map to bits `0..7`:

```text
seat:  2  3  4  5  6  7  8  9
bit:   0  1  2  3  4  5  6  7
```

Reservations in seats `1` or `10` are ignored — they can never block a group. We
store `row -> mask` in a hash map, so only rows touched by a relevant reservation
appear.

**Step 2 — Give every untouched row 2 groups.**
There are `n` rows total and `len(map)` rows with a relevant reservation. Every
other row is completely open in seats `2..9`, so it contributes `2` groups:

```text
ans = (n - number_of_affected_rows) * 2
```

**Step 3 — Score each affected row from its mask.**
Define three block masks over bits `0..7`:

- Left block (seats `2-5`) → bits `0,1,2,3` → `0x0F`
- Right block (seats `6-9`) → bits `4,5,6,7` → `0xF0`
- Middle block (seats `4-7`) → bits `2,3,4,5` → `0x3C`

A block is free exactly when the row's mask has **no** bits set inside that block's
mask, i.e. `mask & blockMask == 0`. Then:

- If Left **and** Right are both free → add `2` (two disjoint groups).
- Else if Left **or** Right **or** Middle is free → add `1`.
- Else → add `0`.

Note the Middle block only matters when neither Left nor Right is free on its own
but a reservation pattern like a booked seat `2` (or `3`) plus a booked seat `8`
(or `9`) still leaves seats `4-7` open — that central window rescues one group.

Summing Step 2 and Step 3 gives the answer.

## Worked example

`n = 3, reservedSeats = [[1,2],[1,3],[1,8],[2,6],[3,1],[3,10]]`

- Row 1: seats `2,3,8` reserved → bits `0,1,6` → mask `0b01000011 = 0x43`.
  Left `0x43 & 0x0F = 0x03 ≠ 0` (blocked), Right `0x43 & 0xF0 = 0x40 ≠ 0`
  (blocked), Middle `0x43 & 0x3C = 0x00 = 0` (free) → **1 group**.
- Row 2: seat `6` reserved → bit `4` → mask `0x10`. Left `0x10 & 0x0F = 0` (free),
  Right `0x10 & 0xF0 = 0x10 ≠ 0` (blocked) → not both free, but Left free →
  **1 group**.
- Row 3: seats `1` and `10` reserved → both outside `2..9`, so this row never
  enters the map.

Affected rows in the map: `{1, 2}` (row 3 was filtered out). Untouched rows =
`n - 2 = 1` (row 3), contributing `1 * 2 = 2`. Rows 1 and 2 contribute `1 + 1 = 2`.
Total = `2 + 2 = 4`. ✓

# Complexity

- Time complexity: $$O(r)$$, where `r` is `reservedSeats.length` — one pass to
  build the masks and one pass over the affected rows (at most `r` of them). The
  huge row count `n` is handled arithmetically, never iterated.
- Space complexity: $$O(r)$$ for the hash map of affected rows.

# Code

## Go

```go
func maxNumberOfFamilies(n int, reservedSeats [][]int) int {
    reversed := make(map[int]int)
    for _, seat := range reservedSeats {
        row, col := seat[0], seat[1]
        if col >= 2 && col <= 9 {
            reversed[row] |= 1 << (col - 2)
        }
    }
    
    ans := (n - len(reversed)) * 2
    for _, reverse := range reversed {
        left := (reverse & 0x0F) == 0
        right := (reverse & 0xF0) == 0
        middle := (reverse & 0x3C) == 0
        if left && right {
            ans += 2
        } else if left || right || middle {
            ans += 1
        }
    }
    return ans
}
```

## Rust

```rust
use std::collections::HashMap;
impl Solution {
    pub fn max_number_of_families(n: i32, reserved_seats: Vec<Vec<i32>>) -> i32 {
        let mut reverse_map: HashMap<i32, i32> = HashMap::new();
        for seat in reserved_seats {
            let (row, col) = (seat[0], seat[1]);
            if col >= 2 && col <= 9 {
                *reverse_map.entry(row).or_insert(0) |= 1 << (col - 2);
            }
        }
        let mut ans = (n - reverse_map.len() as i32) * 2;
        for seat in reverse_map.values() {
            let (left, right, mid) = (seat & 0x0F == 0, seat & 0xF0 == 0, seat & 0x3C == 0);
            if left && right {
                ans += 2;
            } else if left || right || mid {
                ans += 1;
            }
        }
        ans
    }
}
```
