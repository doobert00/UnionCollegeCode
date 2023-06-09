# <center> MPI Assignments</center>



--- 
- [ ] CL.1	Navigate the command line interface 
- [ ] CL.2	create/move/delete files and folders
- [ ] CL.3	SSH and SSH keys
	
- [ ] G.1	create/pull repository
- [ ] G.2	commit and push to a repository
- [ ] G.4	Markdown
- [ ] CP.1	C Programming (editing, compiling)
- [ ] CP.2	C Debugging (your code, other's code)
- [ ] CP.5	Memory Management (Allocation and Segmentation Faults)
---
- [ ] MPI.1 Point-to-Point Communication (Send/Recv)
---

# Description 

The purpose of this assignment is to give you an opportunity to read and write code that uses the MPI framework to send and receive data across distributed memory tasks.  Most of the testing you'll be doing will be on a single machine, but later in week 3 you'll have an opportunity to run it on a cluster.

---
# Setup

For starters :
* You need a computer with `git` and `mpicc`.  -- `mpicc` is the compiler-tool for MPI.  *All* CS department machines have these installed.  Installations of MPI such as MPICH aren't too difficult to install on MacOS or a personal Linux machine.  I have no expertise installing it on Windows.
* that you have `git clone`d both the class repo and your personal repo onto this computer.

Begin by:
*  pulling the latest version of the class repo
*  copying the contents of `week-2-mpi` into your personal repo (via drag and drop or `cp -R`). Be sure to copy `Writeup.md`
* copy the contents of `demos/MPI/` into your personal repo
* `git add` these new files.

---

## Running MPI Hello
*  compile your copy of `mpi_hello.c` via:
    * `mpicc -g -Wall -std=c99 -o mpi_hello mpi_hello.c`
*  run it via:
    * `mpirun -np 4 ./mpi_hello`
* Try changing the number of processes by modifying the number after `-np`
---
## Running Array Sum
*  compile `MPI_array_sum.c` via:
    * `mpicc -std=c99 -Wall MPI_array_sum.c -o array_sum`
*  run it via:
    * `mpirun -np 4 ./array_sum`
* Try changing the number of processes by modifying the number after `-np`
---
# Part 1: Array Sum (Target for Wednesday)

* Modify your copy of `MPI_array_sum.c` so that it distributes the data block-wise, rather than cyclically, using the algorithm you developed in class.  Write it scalably so that it works regardless of the number of processes (including just 1).
* This should mostly require writing a little bit of code before the `for` loop that calculates `localsum`, and then modifying the parameters of the `for` loop.
* You will need to acccount for situations when N%p!=0 (that is to say the size of the array is not evenly divisible by the number of processsors, you  )

## Submit Part 1 
* git add/commit/push your modified `MPI_array_sum.c`
* a Writeup.md describing your algorithm and results


# Part 2: Vectorized Vector Operations (Target Friday)

## Setup
* pull the class repo
* create a new MPI file, `MPI_vector_dot.c`.  I recommend you start with the template file in `demos/MPI`.
* add it to your repo in the `week-2-mpi` directory


## Implementation

* Now implement vector vector dot product in the corresponding `.c` file.  You can choose either a cyclic or block-based approach. (hint: use cyclic)
* The program should take as a command-line argument the size of the vectors to be using.
* The algorithm to follow is as follows:
    1. only the root task should generate the random vectors, and send them to the non-root tasks.
    2. the non-root tasks should receive the vectors from the root task
    3. then all tasks should perform their partial solutions
    4. then all non-root tasks send the result back to the root task.
    5. the root task should then receive the partial dot product solutions from the non-root tasks, and add them together.
    6. the root task should print the answer
* you can re-use the function from Week 2 that generates random arrays by cutting/pasting it into the `.c` files above `main()`
* Measure speedup for different vector sizes and numbers of processors. Make a note in `Writeup.md`

## Submit Part 2: 
* git add/commit/push `MPI_Vector_dot.c`
* and your `Writeup.md`, addressing all questions above.


# Vectorizing Vector Addition (Challenge): 

## Setup
* pull the class repo
* create a new MPI file, `MPI_vector_add.c` in your personal repo .  I recommend you start with the template file in `demos/MPI`.
* add it to your repo in the `week-2-mpi` director


 ## Description

* Now implement vector vector addition in the corresponding `.c` files.  You *must* use a block-based approach.  

This is tricky to parallelize, but essentially each task will be responsible for the addition of only a slice of the big vectors.  The root task will be responsible for distributing slices to each task, and then gathering back each task's slice of the result.  

The steps are as follows:

* The program should take as a command-line argument the size of the vectors to be using.
* The algorithm to follow is as follows:
    1. only the root task should generate the random vectors. The root task should also allocate a result vector.
    2. all tasks should allocate three arrays for their "slice" of each vector (the two vectors to add and the result vector)
    3. the root task should send a slice to the corresponding tasks (but not itself)
    4. the non-root tasks should receive their slice from the root task
    5. all tasks should perform their partial solutions
    6. then all non-root tasks send their result slice back to the root task.
    7. the root task should then receive the result slices from the non-root tasks, and add them to the final result vecotr.
    8. the root task should print the answer

* Note that there are several ways to do task 7 above.  You can either receive each slice into a separately array allocated in the root node and then use `memcpy()` to copy the contents over to the full-size result array, or else pass a pointer to the address in the root node's result array where the "slice" belongs directly into `MPI_Recv`.   Because, either way you have to do pointer arithmetic to know where the slice belongs in the result array, the second approach is probably easier (but not without hazards)
* you can re-use the function from Week 1 that generates random arrays by cutting/pasting it into the `.c` files above `main()`
* Note that much like problem `1.1` of the homework, not all slices will be equal!  Each task will need to calculate how big its slice is.
* Measure speedup for different vector sizes and numbers of processors. Make a note in `Writeup.md` 

## Submit Part 3: 
* git add/commit/push `MPI_Vector_add.c`
* and your `Writeup.md`, addressing all questions above.