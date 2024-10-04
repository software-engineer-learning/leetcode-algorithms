# Intuition
The problem asks us to determine the maximum number of tasks that can be assigned to workers given that we have a limited number of pills to boost some workers' strength. The goal is to maximize task completion using these pills strategically.

- **Key Insight:** The hardest tasks should be matched with the strongest workers whenever possible. For tasks that are too difficult for available workers, we can use pills to temporarily boost weaker workers' strength. The problem can be viewed as an assignment problem where we need to decide how many tasks can be feasibly completed with the given constraints.

- **Why Binary Search?** Since the number of tasks we can complete depends on how we allocate workers (with or without pills), it's not immediately clear how many tasks can be handled. By using a binary search over the number of tasks, we can efficiently explore the maximum number of tasks that can be assigned. Each midpoint of the binary search represents a hypothesis about the number of tasks we can complete, and we check its feasibility by assigning workers and pills.

# Approach
1. **Sort the tasks and workers:**
   - We sort the `tasks` and `workers` arrays in ascending order. Sorting is crucial because it allows us to easily match the most difficult tasks with the strongest available workers. It also helps us identify where the use of pills becomes necessary (i.e., when a task is too hard for a worker but can still be completed with the pill boost).

2. **Binary search on task count:**
   - The binary search will run over the possible range of tasks, from `0` to `min(tasks.length, workers.length)`. The midpoint `mid` in each iteration represents the number of tasks we’re checking for feasibility. The goal is to find the maximum value of `mid` where it's possible to complete `mid` tasks with the given constraints.

3. **Helper function `canComplete`:**
   - For each midpoint `mid` during the binary search, we call the helper function `canComplete`. This function checks if it's possible to assign exactly `mid` tasks to workers, making use of pills if necessary.

   The function works by:
   - Assigning the `mid` hardest tasks to the `mid` strongest workers.
   - If a worker is strong enough for a task without help, they complete it directly.
   - If the worker is too weak, we use a pill (if available) to boost their strength by `strength` units so that they can handle the task.
   - If the worker cannot complete the task even with a pill, the assignment for that number of tasks fails.

4. **Efficient task-worker matching with deque:**
   - We use a **deque** to efficiently manage workers and pills. The deque keeps track of which workers are still available to handle tasks.
   - For each task (starting from the hardest), we try to assign the strongest available worker:
     - If the worker is strong enough for the task, they complete it.
     - If not, but can handle it with a pill, we use the pill.
     - If neither is possible, the task cannot be completed, and we reduce the number of tasks in the binary search.

   This process continues until the maximum number of tasks that can be assigned is found.

# Complexity

- **Time Complexity:**
  - Sorting the `tasks` and `workers` arrays takes $O(n \log n)$, where `n` is the number of tasks (or workers, whichever is larger).
  - The binary search over the number of tasks requires checking the feasibility of $O(\log n)$ values of `mid`.
  - For each binary search step, the `canComplete` function processes up to `n` tasks and `n` workers, making it $O(n)$ per check.

  Overall, the time complexity is $O(n \log n)$.

- **Space Complexity:**
  - The space complexity is $O(n)$, as we use a deque to track worker assignments, which stores up to `n` workers in the worst case.

# Code

```java
class Solution {
    public int maxTaskAssign(int[] tasks, int[] workers, int pills, int strength) {
        Arrays.sort(tasks);  // Sort tasks in ascending order
        Arrays.sort(workers);  // Sort workers in ascending order
        int l = 0;  // Lower bound of binary search (no tasks assigned)
        int h = Math.min(tasks.length, workers.length);  // Upper bound (all tasks assigned)

        // Binary search for the maximum number of tasks that can be completed
        while (l < h) {
            int mid = (l + h + 1) / 2;  // Midpoint hypothesis of task count

            // Check if we can complete 'mid' number of tasks
            if (canComplete(tasks, workers, pills, strength, mid)) {
                l = mid;  // If feasible, move the lower bound up
            } else {
                h = mid - 1;  // Otherwise, reduce the upper bound
            }
        }

        return l;  // Return the maximum number of tasks that can be completed
    }

    private boolean canComplete(int[] tasks, int[] workers, int pills, int strength, int mid) {
        Deque<Integer> queue = new LinkedList<>();
        int j = workers.length - 1;  // Start with the strongest worker

        // Loop over the hardest 'mid' tasks
        for (int i = mid - 1; i >= 0; i--) {
            // Try to find a worker that can handle this task (either naturally or with a pill)
            while (j >= workers.length - mid && (workers[j] >= tasks[i] || workers[j] + strength >= tasks[i])) {
                queue.addFirst(workers[j]);  // Add suitable workers to the deque
                j--;
            }

            if (queue.isEmpty()) {
                return false;  // No worker available for this task
            }

            if (queue.getLast() >= tasks[i]) {
                queue.pollLast();  // Strong enough worker found, assign task
            } else if (pills <= 0) {
                return false;  // No pills left to boost a weaker worker
            } else {
                queue.pollFirst();  // Use a pill for the weaker worker
                pills--;
            }
        }

        return true;  // All tasks can be completed
    }
}
```