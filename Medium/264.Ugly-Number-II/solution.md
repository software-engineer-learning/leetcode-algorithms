# Brute Force Approach

## Intuition
The problem is to find the nth ugly number, where ugly numbers are positive integers whose prime factors are limited to 2, 3, and 5. To solve this problem, the idea is to use a priority queue (min-heap) to generate the ugly numbers in order.

## Approach
1. **Use a Min-Heap**:
   - Start with the smallest ugly number, which is 1. 
   - Use a min-heap to keep track of the next possible ugly numbers by multiplying the current smallest ugly number with 2, 3, and 5.
   - Maintain a set to ensure no duplicate numbers are added to the heap.

2. **Generate Ugly Numbers**:
   - Pop the smallest number from the heap and consider it as the next ugly number.
   - Multiply this number by 2, 3, and 5 to generate potential new ugly numbers and add them to the heap if they haven't been added already.
   - Repeat this process `n` times, where the nth popped number from the heap will be the nth ugly number.

3. **Return the nth Ugly Number**:
   - After looping `n` times, the last number popped from the heap is the nth ugly number.

## Complexity
- **Time Complexity**:
  - The time complexity is $O(n log n)$ because each insertion and removal operation in the heap takes $O(log n)$ time, and this operation is repeated `n` times.

- **Space Complexity**:
  - The space complexity is $O(n)$ because the heap and set can grow up to the size of `n` in the worst case.

## Code
```java
class Solution {
    public int nthUglyNumber(int n) {
        PriorityQueue<Long> minHeap = new PriorityQueue<>();
        minHeap.add(1L);
        int[] factors = new int[] {2, 3, 5};
        Set<Long> visit = new HashSet<>();
        visit.add(1L);

        long currentUglyNumber = 1;
        for (int i = 0; i < n; i++) {
            currentUglyNumber = minHeap.poll();
            for (int factor : factors) {
                long nextUglyNumber = currentUglyNumber * factor;
                if (!visit.contains(nextUglyNumber)) {
                    visit.add(nextUglyNumber);
                    minHeap.add(nextUglyNumber);
                }
            }
        }
        return (int) currentUglyNumber;
    }
}
```
# DP Approach

## Intuition
Ugly numbers are numbers that only have prime factors of 2, 3, and 5. The sequence starts with 1, and each subsequent number is formed by multiplying the previous ugly numbers by 2, 3, or 5, ensuring the sequence is in increasing order. The problem is to find the nth number in this sequence.

## Approach
1. **Initialize Arrays and Variables**: 
   - Create an array `uglyNumbers` to store the first `n` ugly numbers, initialized with 1 as the first ugly number.
   - Maintain three pointers (`i2`, `i3`, `i5`) for multiples of 2, 3, and 5, starting at 0.
   - Calculate the next multiples of 2, 3, and 5.

2. **Generate Ugly Numbers**:
   - Loop from 1 to `n-1`, each time selecting the smallest number from the next multiples of 2, 3, and 5 as the next ugly number.
   - Update the corresponding pointer and calculate the next multiple for the chosen factor.

3. **Return the nth Ugly Number**:
   - After filling the array, return the nth ugly number from the array.

## Complexity
- **Time Complexity**: 
  - The time complexity is $O(n)$ since we are iterating `n` times to generate the first `n` ugly numbers.

- **Space Complexity**: 
  - The space complexity is $O(n)$ because we are storing the first `n` ugly numbers in an array.

## Code
```java
class Solution {
    public int nthUglyNumber(int n) {
        int[] uglyNumbers = new int[n];
        uglyNumbers[0] = 1;
        
        int i2 = 0, i3 = 0, i5 = 0;
        int nextMultipleOf2 = 2;
        int nextMultipleOf3 = 3;
        int nextMultipleOf5 = 5;

        for (int i = 1; i < n; i++) {
            int nextUglyNumber = Math.min(nextMultipleOf2, Math.min(nextMultipleOf3, nextMultipleOf5));
            uglyNumbers[i] = nextUglyNumber;

            if (nextUglyNumber == nextMultipleOf2) {
                i2++;
                nextMultipleOf2 = uglyNumbers[i2] * 2;
            }
            if (nextUglyNumber == nextMultipleOf3) {
                i3++;
                nextMultipleOf3 = uglyNumbers[i3] * 3;
            }
            if (nextUglyNumber == nextMultipleOf5) {
                i5++;
                nextMultipleOf5 = uglyNumbers[i5] * 5;
            }
        }

        return uglyNumbers[n - 1];
    }
}
```