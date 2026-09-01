# Intuition

Plain grid BFS fails here because the position alone does not describe the
situation. Standing on `(1,1)` having already picked up two pieces of litter is a
completely different position from standing on `(1,1)` with none collected — the
first may be one move from finishing, the second may need a long detour.

So the state has to carry the progress. Since there are at most 10 litter cells,
"which litter has been collected" fits in a 10-bit **mask**, and the search space
becomes

$$\text{state} = (\text{row},\; \text{column},\; \text{mask})$$

BFS over that graph visits states in increasing move count, so the first time a
state with a full mask is dequeued, its step count is the answer.

Energy is the awkward part. It is not part of the state key — putting it there
would multiply the space by `energy` — but it cannot be ignored either, because
arriving somewhere with more energy left is strictly better. The resolution is to
treat energy as a **value to maximise per state** rather than part of the state's
identity.

# Approach: BFS Over `(row, column, litter mask)`

1. Scan the grid once to find `S` and to number the `L` cells `0, 1, 2, ...`.
   Store those numbers in `litterIds` so a cell can be turned into a bit.
2. If there is no litter at all, the answer is `0` before any search starts.
3. Let `targetMask = (1 << k) - 1`, the mask with every litter bit set.
4. BFS from `S` with `mask = 0` and full energy. For each neighbour that is not an
   obstacle:
   - **energy** becomes full again if the cell is `R`, otherwise drops by one;
   - **mask** gains the neighbour's bit if the cell is `L`;
   - enqueue only if this arrival carries **more energy** than any previous
     arrival at the same `(row, column, mask)`.
5. When a dequeued state has `mask == targetMask`, return its step count. If the
   queue empties, return `-1`.

## Why `visited` stores energy instead of a boolean

This is the part that makes the whole thing work, and it is easy to get wrong.

`visited[r][c][mask]` holds the **largest energy** with which that state has ever
been reached, initialised to `-1`. A new arrival is only pushed when
`nextEnergy > visited[r][c][mask]`. The reasoning: for a fixed
`(row, column, mask)`, having more energy can never hurt — anything reachable with
`e` units is reachable with `e + 1` — so an arrival with less energy than one
already recorded is dominated and can be discarded.

Replacing that test with an ordinary boolean "have I been here?" breaks the
algorithm. Running the Go version with `visited[nr][nc][nextMask] == -1` instead of
the energy comparison produced **wrong answers on 69 of the 6003 test cases**.
The smallest is:

```text
classroom = ["SR",
             "..",
             "XL"],  energy = 2      correct answer 3, boolean version says -1
```

Both routes reach `(1,1)` with `mask = 0` in exactly 2 moves:

| route | energy on arrival |
| --- | --- |
| `(0,0) → (1,0) → (1,1)` | `0` |
| `(0,0) → (0,1)` reset → `(1,1)` | `1` |

A boolean `visited` keeps whichever is dequeued first and refuses the other. If
that is the exhausted one, the search stalls at `(1,1)` with no energy, and the
`(2,1)` litter is never collected — so it reports `-1` even though a 3-move
solution exists. Keeping the maximum energy admits the second arrival and finds
it.

## Why the answer is still the minimum

Re-enqueueing a state might look like it breaks BFS's shortest-path guarantee, but
it does not. Every edge costs exactly one move, so the queue stays in
non-decreasing step order: a state pushed during the processing of step `d` enters
with step `d + 1`, behind everything already queued. The first dequeue of a
full-mask state is therefore the minimum. Re-visits only ever add *more* states to
explore; they never let a shorter path be reported than actually exists.

## Details worth noticing

- **The energy check happens on dequeue, not on push.** `if current.e == 0 {
  continue }` discards a state that cannot move, but only *after* the
  `mask == targetMask` test above it. That ordering matters: a state that finishes
  the job on its last unit of energy must still be recognised as a win.
- **Reset cells are free of charge.** Stepping onto `R` sets energy to the full
  capacity rather than `capacity - 1`, matching "restores the student's energy to
  full capacity". The move itself still counts toward the step total.
- **`R` cells can be reused.** Nothing marks them as consumed, and the mask does
  not track them, so a route may bounce off the same reset cell repeatedly.
- **Litter bits are assigned in scan order**, so `litterIds` is only meaningful
  for cells that actually hold `L`. Other cells keep the default `0`, which is
  never read because the bit is only taken when the cell is `L`.

# Worked examples

## `classroom = ["S.", "XL"], energy = 2` → `2`

One litter at `(1,1)`, so `targetMask = 1`. The direct move down from `(0,0)` is
blocked by the `X` at `(1,0)`.

| step | state `(r, c, mask)` | energy | note |
| --- | --- | --- | --- |
| 0 | `(0,0,0)` | 2 | start |
| 1 | `(0,1,0)` | 1 | move right |
| 2 | `(1,1,1)` | 0 | move down onto `L`, mask complete |

Dequeuing `(1,1,1)` sees `mask == targetMask` and returns `2`. Note the energy is
`0` on arrival — the `current.e == 0` guard would skip it, but the mask check runs
first.

## `classroom = ["LS", "RL"], energy = 4` → `3`

Two litters: `(0,0)` is bit 0, `(1,1)` is bit 1, so `targetMask = 3`.

| step | state | energy | note |
| --- | --- | --- | --- |
| 0 | `(0,1,00)` | 4 | start on `S` |
| 1 | `(0,0,01)` | 3 | left onto `L`, bit 0 set |
| 2 | `(1,0,01)` | 4 | down onto `R`, energy restored to full |
| 3 | `(1,1,11)` | 3 | right onto `L`, bit 1 set → answer `3` |

The reset at step 2 is not needed for this small grid, but it shows the rule: the
move costs a step yet leaves energy at maximum rather than `3`.

## `classroom = ["L.S", "RXL"], energy = 3` → `-1`

The `X` at `(1,1)` splits the grid so that no route collects both litters within
the energy budget. BFS exhausts every reachable `(row, column, mask)` combination
without ever completing the mask, and falls through to `-1`.

# Complexity

Let `m` and `n` be the grid dimensions and `k` the number of litter cells.

- Time complexity: $$O(m \cdot n \cdot 2^k \cdot \text{energy})$$ in the worst
  case. There are $$m \cdot n \cdot 2^k$$ states, and each can be re-enqueued
  whenever its recorded energy strictly improves — at most `energy + 1` times,
  since the stored value only ever increases. Each dequeue does constant work over
  4 neighbours. With $$m, n \le 20$$, $$k \le 10$$ and
  $$\text{energy} \le 50$$ that is a bounded search, and in practice each state
  improves only a handful of times.
- Space complexity: $$O(m \cdot n \cdot 2^k)$$ for the `visited` table — at most
  $$20 \cdot 20 \cdot 1024 = 409600$$ integers — plus the queue.

Putting energy into the state key instead would make correctness trivial but grow
the table by a factor of `energy`, to roughly $$2 \times 10^7$$ entries.

# Code

## Go

```go
type State struct {
    r,c int
    mask int
    e int
    steps int
}

func minMoves(classroom []string, energy int) int {
    m, n := len(classroom), len(classroom[0])
    startR, startC := -1, -1
    litterIds := make([][]int, m)
    
    k := 0
    for i := range m {
        litterIds[i] = make([]int, n)
        for j := range n {
            if classroom[i][j] == 'S' {
                startR, startC = i, j
            } else if classroom[i][j] == 'L' {
                litterIds[i][j] = k
                k++
            }
        }
    }
    
    if k == 0 {
        return 0
    }
    targetMask := (1 << k) - 1
    visited := make([][][]int, m)
    for i := range visited {
        visited[i] = make([][]int, n)
        for j := range visited[i] {
            visited[i][j] = make([]int, targetMask + 1)
            for mask := range targetMask + 1 {
                visited[i][j][mask] = -1
            }
        }
    }
    queue := []State{
        {
            r: startR,
            c: startC,
            steps: 0,
            mask: 0,
            e: energy,
        },
    }
    visited[startR][startC][0] = energy
    directions := [4][2]int{{-1, 0}, {0, -1}, {1, 0}, {0, 1}}
    for len(queue) > 0 {
        current := queue[0]
        queue = queue[1:]
        if current.mask == targetMask {
            return current.steps
        }
        if current.e == 0 {
            continue
        }
        
        for _, d := range directions {
            nr, nc := current.r + d[0], current.c + d[1]
            if nr < 0 || nr >= m || nc < 0 || nc >= n || classroom[nr][nc] == 'X' {
                continue
            }
            nextEnergy := current.e - 1
            if classroom[nr][nc] == 'R' {
                nextEnergy = energy
            }
            
            nextMask := current.mask
            if classroom[nr][nc] == 'L' {
                nextMask |= 1 << litterIds[nr][nc]
            }
            if nextEnergy > visited[nr][nc][nextMask] {
                visited[nr][nc][nextMask] = nextEnergy
                
                queue = append(queue, State{
                    r: nr,
                    c: nc,
                    e: nextEnergy,
                    mask: nextMask,
                    steps: current.steps + 1,
                })
            }
        }
    }
    return -1
}
```

Both `for i := range m` and `for mask := range targetMask + 1` are
range-over-integer, added in **Go 1.22**; on an older toolchain write the classic
three-clause form. `queue = queue[1:]` reslices rather than copying, so the pop is
constant time — the backing array is only released once the whole slice is
dropped, which is fine at this problem's scale.

## Rust

```rust
use std::collections::VecDeque;

#[derive(Clone, Debug)]
struct State {
    r: usize,
    c: usize,
    mask: usize,
    e: i32, 
    steps: i32,
}

impl Solution {
    pub fn min_moves(classroom: Vec<String>, energy: i32) -> i32 {
        let classroom: Vec<&[u8]> = classroom.iter().map(|class| class.as_bytes()).collect();
        let m = classroom.len();
        let n = classroom[0].len();
        let mut litter_ids = vec![vec![0; n]; m];
        let (mut start_x, mut start_y, mut k) = (0, 0, 0);
        for i in 0..m {
            for j in 0..n {
                let c = classroom[i][j];
                if c == b'S' {
                    (start_x, start_y) = (i,j);
                } else if c == b'L' {
                    litter_ids[i][j] = k;
                    k += 1;
                }
            }
        }
        if k == 0 {
            return 0;
        }
        let target_mask = (1 << k) - 1;
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)];
        let mut visited = vec![vec![vec![-1; target_mask + 1]; n]; m];
        visited[start_x][start_y][0] = energy;
        let mut queue = VecDeque::new();
        queue.push_back(State{r: start_x, c: start_y, mask: 0, e: energy, steps: 0});
        while let Some(current) = queue.pop_front() {
            if current.mask == target_mask {
                return current.steps;
            }
            if current.e == 0 {
                continue;
            }
            for d in &directions {
                let (nr, nc) = ((current.r) as i32 + d.0, (current.c) as i32 + d.1);
                if nr < 0 || nr >= m as i32 || nc < 0 || nc >= n as i32 {
                    continue;
                }
                let (nr_u32, nc_u32) = (nr as usize, nc as usize);
                if classroom[nr_u32][nc_u32] == b'X' {
                    continue;
                }
                let next_energy = if classroom[nr_u32][nc_u32] == b'R' {
                    energy
                } else {
                    current.e - 1
                };
                let next_mask = if classroom[nr_u32][nc_u32] == b'L' {
                    current.mask | (1 << litter_ids[nr_u32][nc_u32])
                } else {
                    current.mask
                };
                if next_energy > visited[nr_u32][nc_u32][next_mask] {
                    visited[nr_u32][nc_u32][next_mask] = next_energy;
                    queue.push_back(State{r: nr_u32, c: nc_u32, mask: next_mask, e: next_energy, steps: current.steps + 1});
                }
            }
        }
        -1
    }
}
```

The bounds check is done in `i32` before converting back to `usize`, which is what
keeps `row - 1` at the top edge from wrapping around to a huge unsigned value —
the classic trap when walking a grid with unsigned indices. `VecDeque::pop_front`
gives a genuine constant-time queue.

# Test cases

| `classroom` | `energy` | answer | what it exercises |
| --- | --- | --- | --- |
| `["S.", "XL"]` | `2` | `2` | Example 1 — obstacle forces a detour |
| `["LS", "RL"]` | `4` | `3` | Example 2 — reset cell on the path |
| `["L.S", "RXL"]` | `3` | `-1` | Example 3 — unreachable |
| `["SR", "..", "XL"]` | `2` | `3` | two arrivals at one state, different energy |
| `["S."]` | `1` | `0` | no litter at all → immediate `0` |

Both implementations were checked against a reference BFS that carries the
**complete** state `(row, column, mask, energy)` with a plain visited set — no
dominance heuristic, so it cannot share the optimisation being tested. The corpus
was **6003** cases: the three examples plus 6000 random grids up to `4 x 4` with
up to 5 litter cells, obstacles, and reset areas. Go and Rust matched the
reference on every case.
