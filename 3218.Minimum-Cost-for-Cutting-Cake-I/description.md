# <a class="no-underline hover:text-blue-s dark:hover:text-dark-blue-s truncate cursor-text whitespace-normal hover:!text-[inherit]" href="https://leetcode.com/problems/minimum-cost-for-cutting-cake-i/" target="_blank">3218. Minimum Cost for Cutting Cake I</a>

<p>&nbsp;</p><p>There is an <code>m x n</code> cake that needs to be cut into <code>1 x 1</code> pieces.</p>

<p>You are given integers <code>m</code>, <code>n</code>, and two arrays:</p>

<ul>
	<li><code>horizontalCut</code> of size <code>m - 1</code>, where <code>horizontalCut[i]</code> represents the cost to cut along the horizontal line <code>i</code>.</li>
	<li><code>verticalCut</code> of size <code>n - 1</code>, where <code>verticalCut[j]</code> represents the cost to cut along the vertical line <code>j</code>.</li>
</ul>

<p>In one operation, you can choose any piece of cake that is not yet a <code>1 x 1</code> square and perform one of the following cuts:</p>

<ol>
	<li>Cut along a horizontal line <code>i</code> at a cost of <code>horizontalCut[i]</code>.</li>
	<li>Cut along a vertical line <code>j</code> at a cost of <code>verticalCut[j]</code>.</li>
</ol>

<p>After the cut, the piece of cake is divided into two distinct pieces.</p>

<p>The cost of a cut depends only on the initial cost of the line and does not change.</p>

<p>Return the <strong>minimum</strong> total cost to cut the entire cake into <code>1 x 1</code> pieces.</p>

<p>&nbsp;</p>
<p><strong class="example">Example 1:</strong></p>

> <strong>Input:</strong> <span class="example-io">m = 3, n = 2, horizontalCut = [1,3], verticalCut = [5]</span>
> 
> <strong>Output:</strong> <span class="example-io">13</span>
> 
> <strong>Explanation:</strong>
> 
> <img alt="" src="https://assets.leetcode.com/uploads/2024/06/04/ezgifcom-animated-gif-maker-1.gif" style="width: 280px; height: 320px;">
> 
> <ul>
> 	<li>Perform a cut on the vertical line 0 with cost 5, current total cost is 5.</li>
> 	<li>Perform a cut on the horizontal line 0 on <code>3 x 1</code> subgrid with cost 1.</li>
> 	<li>Perform a cut on the horizontal line 0 on <code>3 x 1</code> subgrid with cost 1.</li>
> 	<li>Perform a cut on the horizontal line 1 on <code>2 x 1</code> subgrid with cost 3.</li>
> 	<li>Perform a cut on the horizontal line 1 on <code>2 x 1</code> subgrid with cost 3.</li>
> </ul>
> 
> The total cost is <code>5 + 1 + 1 + 3 + 3 = 13</code>.

<p><strong class="example">Example 2:</strong></p>

> <strong>Input:</strong> <span class="example-io">m = 2, n = 2, horizontalCut = [7], verticalCut = [4]</span>
> 
> <strong>Output:</strong> <span class="example-io">15</span>
> 
> <strong>Explanation:</strong>
> 
> <ul>
> 	<li>Perform a cut on the horizontal line 0 with cost 7.</li>
> 	<li>Perform a cut on the vertical line 0 on <code>1 x 2</code> subgrid with cost 4.</li>
> 	<li>Perform a cut on the vertical line 0 on <code>1 x 2</code> subgrid with cost 4.</li>
> </ul>
> 
> The total cost is <code>7 + 4 + 4 = 15</code>.

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= m, n &lt;= 20</code></li>
	<li><code>horizontalCut.length == m - 1</code></li>
	<li><code>verticalCut.length == n - 1</code></li>
	<li><code>1 &lt;= horizontalCut[i], verticalCut[i] &lt;= 10<sup>3</sup></code></li>
</ul>
