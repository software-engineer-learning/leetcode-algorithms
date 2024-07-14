# <a class="no-underline hover:text-blue-s dark:hover:text-dark-blue-s truncate cursor-text whitespace-normal hover:!text-[inherit]" href="https://leetcode.com/problems/lexicographically-smallest-string-after-a-swap/" target="_blank">3216. Lexicographically Smallest String After a Swap</a>

<p>&nbsp;</p><p>Given a string <code>s</code> containing only digits, return the <strong>lexicographically</strong> smallest string that can be obtained after swapping <strong>adjacent</strong> digits in <code>s</code> with the same <strong>parity</strong> at most <strong>once</strong>.</p>

<p>Digits have the same parity if both are odd or both are even. For example, 5 and 9, as well as 2 and 4, have the same parity, while 6 and 9 do not.</p>

<p>&nbsp;</p>
<p><strong class="example">Example 1:</strong></p>

<pre>
<strong>Input:</strong> <span class="example-io">s = "45320"</span>
<strong>Output:</strong> <span class="example-io">"43520"</span>

<strong>Explanation: </strong>
<code>s[1] == '5'</code> and <code>s[2] == '3'</code> both have the same parity, and swapping them results in the lexicographically smallest string.
</pre>

<p><strong class="example">Example 2:</strong></p>

<pre>
<strong>Input:</strong> <span class="example-io">s = "001"</span>
<strong>Output:</strong> <span class="example-io">"001"</span>

<strong>Explanation:</strong>
There is no need to perform a swap because <code>s</code> is already the lexicographically smallest.
</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>2 &lt;= s.length &lt;= 100</code></li>
	<li><code>s</code> consists only of digits.</li>
</ul>
