# <center>Week 2 Assignments</center>

# Tasks

- [ ] Array Sum
- [ ] Vector Dot
- [ ] Vector Add

# Observations and Measures
- Part 1 : Array Sum
  - The algorithm is inspired but the one we submitted for homework, but I realize now that my submission was incorrect. The functions f(n,p,id) and l(n,p,id) calculate the first and last indices of the block. Here, n denotes the size of the array, p denotes the number of processors, and id denotes the rank of the current processor. The only change made was to l(n,p,id) which had not been accounting for situations when n is not divisible by p. This was a quick fix. The following is a LaTeX closed-form expression for the algorithm.

  \begin{equation}
    f(n,p,id) =
    \left\{
    \begin{array}{lr}
         \frac{id(n-(n\;\textrm{mod p}))}{p} + (n\;\textrm{mod p}), &  \text{if}\; n\;\textrm{mod p}\leq id \;\textrm{or}\; n\equiv 0 \;\textrm{mod p}\\
         \frac{id(n-(n\;\textrm{mod p}))}{p} + id, & \text{otherwise}
     \end{array}
     \right\}
     \end{equation}
     The following function, $l(n,p,id)$, gives the value for my\_last\_i with the same arguments as $f(n,p,id).$
     \begin{equation}
     l(n,p,id) =
     \left\{
     \begin{array}{lr}
          f(n,p,id) + \frac{n-(n\;\textrm{mod p})}{p}, &  \text{if}\; n\;\textrm{mod p}\leq  id \;\textrm{or}\; n\equiv 0 \;\textrm{mod p}\\
          f(n,p,id) + \frac{n-(n\;\textrm{mod p})}{p} + 1, & \text{otherwise}
     \end{array}
     \right\}
  \end{equation}

- Part 2 : Vector Dot Product
    - I used a block-based approach for my implementation. The root core passed both vectors to all non-root cores. The non-root cores calculated first and last indices of their blocks using the same algorithm as above. A change was made to the equation to account for core 0 not doing any work. This amounted to subtracting 1 from the core's id number, and subtracting 1 from the number of cores. Then the root core receives the partial product from each non-root core and sums them to produce the full dot product.  

    | Processors | Vector Size | Time   |
    |------------|-------------|--------|
    | 2          |  10010      | 0.254  |
    | 2          |  20010      | 0.504  |
    | 2          |  30010      | 0.673  |
    | 2          |  40010      | 0.862  |
    | 2          |  50010      | 1.058  |
    | 3          |  10010      | 0.766  |
    | 3          |  20010      | 0.797  |
    | 3          |  30010      | 0.995  |
    | 3          |  40010      | 0.511  |
    | 3          |  50010      | 0.967  |
    | 4          |  10010      | 0.309  |
    | 4          |  20010      | 18.70  |
    | 4          |  30010      | 23.72  |
    | 4          |  40010      | 2.333  |
    | 4          |  50010      | 0.897  |
-Revised Table
    | Processors | Vector Size | Time   (ms)|
    |------------|-------------|------------|
    | 2          | 100000      | 0.000002   |
    | 2          | 200000      | 0.000002   |
    | 2          | 300000      | 0.000003   |   
    | 2          | 400000      | 0.000003   |
    | 2          | 500000      | 0.000004   |
    | 3          | 100000      | 0.000002   |
    | 3          | 200000      | 0.000003   |
    | 3          | 300000      | 0.000004   |
    | 3          | 400000      | 0.000005   |
    | 3          | 500000      | 0.000006   |
    | 4          | 100000      | 0.000005   |
    | 4          | 200000      | 0.000003   |
    | 4          | 300000      | 0.000009   |
    | 4          | 400000      | 0.000009   |
    | 4          | 500000      | 0.000013   |


- Vector Addition
  - Since my dot product used a block-based approach, this algorithm was very similar. The algorithm for finding indices was the same, but I did it in the root node instead of the non-root nodes. I then calculated the size of the array and gave it to the non-root nodes to allocate their arrays. Then the root node sent subsets of the arrays to have vector addition performed. The root node received each subset of the arrays and put the values into their respective positions in the output arrays.

  | Processors | Vector Size | Time   |
  |------------|-------------|--------|
  | 2          |  10010      | 0.236  |
  | 2          |  20010      | 0.174  |
  | 2          |  30010      | 0.225  |
  | 2          |  40010      | 0.327  |
  | 2          |  50010      | 1.084  |
  | 3          |  10010      | 0.363  |
  | 3          |  20010      | 0.218  |
  | 3          |  30010      | 0.484  |
  | 3          |  40010      | 0.991  |
  | 3          |  50010      | 1.018  |
  | 4          |  10010      | 6.344  |
  | 4          |  20010      | 1.082  |
  | 4          |  30010      | 2.329  |
  | 4          |  40010      | 1.312  |
  | 4          |  50010      | 2.322  |
  
-Revised Table
  | Processors | Vector Size | Time (s) |
  |------------|-------------|----------|
  | 1          | 100000      | 0.000000 |
  | 1          | 200000      | 0.000000 |
  | 1          | 300000      | 0.000000 |
  | 1          | 400000      | 0.000000 |
  | 1          | 500000      | 0.000000 |
  | 2          | 100000      | 0.001734 |
  | 2          | 200000      | 0.007216 |
  | 2          | 300000      | 0.005253 |
  | 2          | 400000      | 0.007189 |
  | 2          | 500000      | 0.008668 |
  | 3          | 100000      | 0.001971 |
  | 3          | 200000      | 0.003370 |
  | 3          | 300000      | 0.003669 |
  | 3          | 400000      | 0.004886 |
  | 3          | 500000      | 0.012227 |
  | 4          | 100000      | 0.004945 |
  | 4          | 200000      | 0.004270 |
  | 4          | 300000      | 0.009063 |
  | 4          | 400000      | 0.014322 |
  | 4          | 500000      | 0.016464 |



# Feedback from John

## Array Sum
- [] Code Exists
- [] Code Compiles
- [] Code Runs
- [] Writeup and Analysis
- Notes:

## Vector Dot
- [] Code Exists
- [] Code Compiles
- [] Code Runs
- [] Writeup and Analysis
- Notes:

##  Vector Add
- [] Code Exists
- [] Code Compiles
- [] Code Runs
- [] Writeup and Analysisj
- Notes:
