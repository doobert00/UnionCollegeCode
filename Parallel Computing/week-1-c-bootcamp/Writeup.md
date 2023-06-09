
<center>Zach Dubinsky</center>

# Task List
- [ ] Complete Setup (clone repos)
- [ ] Assignment 1: Factorization

# Assignment 1
- Part 3: 
  - 1283661 in 8.85 ms
  - 2349239839 in 16408.337 ms
  - 837351894 in 5782.482 ms
- Part 4
  - 1283661 in 0.006 ms
  - 2349239839 in 0.376000 ms
  - 837351894 in 0.11 ms
  - 21 in 0.003 ms (and it got primality correct!)
- An Explanation of the Primality Testing Strategy
  - To show that a number $n$ is prime, we only have to check odd numbers and 2. This is because if $n$ has any even factors, two will divide them. We can check if 2 divides $n$ in place of checking all even numbers along with checking if the number itself is 2. Then, we only have to show that $n$ has no odd factors greater than $\sqrt{n}$ to show that it is prime. This is because for any positive integer $n = p * q$, at least one of $p,q \leq \sqrt{n}$. The proof of this result is below. 
  - Let $n$ be a positive integer with $n = p*q$. We proceed by contradiction, assuming that $\sqrt{n} < p,q$. But if $\sqrt{n} < p$ and $\sqrt{n} < q$ then $\sqrt{n}^2 < p*q \implies n < p*q$. This is a contradiction since we had assumed that $n = p*q$. So it cannot be that both $p$ and $q$ are strictly greater than $\sqrt{n}$. It must be that $p \leq \sqrt{n}$, $q \leq \sqrt{n}$, or both. 

# Assignment 2
  - Part 4:
    - If the size argument passed to the printing function is greater than the length of the vector, no error will be thrown. This is because a vector is a pointer, so we are indexing by memory locations. This is a feature (or a bug to some) of C that allows users to reference the heap as they please.
  - Part 7:
    - There doesn't seem to be a reasonable limit on the size of a vector. Vectors are just pointers to subsequent memory addresses, so as long as the heap has room I don't know why C would stop allocation. I went as high as 90,010 elements. The addition and dot product operations do slow down as the vector sizes get larger, but somewhat inconsistently. I ran a script (never done that before by the way) and found that a vector of size 40,010 took 1.1 ms for both operations, while a vector of size 90,010 took 0.6 ms for both operations. I'm not sure why. With that in mind, I can't really draw conclusions for vectors of size less than 1000. Also, the amount of time taken to perform operations on vectors of these sizes was so small that I'd be willing to accept weirdness from C. 

# Assignment 3
  - The recursive insert function was basically the same as the iterative insert function. Instead of while-looping the function just recurses. The base case is the only time that the we would add a node to the list, so we only allocate a new node when we are adding it to avoid wasting memory. The print function was straightforward.
