# Feedback

- [P] CP.1.P	C Programming (editing, compiling)
- [P] CP.2.P	C Debugging (your code, other's code)
- [P] PP.3.A	Parallelization of Serial Programs
- [P] PP.3.P	Parallelization of Serial Programs
- [r] MPI.2.A	Collective Communication (Broadcast, Scatter, Gather)
- [r] MPI.2.P	Collective Communication (Broadcast, Scatter, Gather)

## Notes

Your vector normalization code is a pile of spaghetti, which may be delicious, but is overly redundant and therefore hard to read.  You *should* be seeing speedups for large enough vectors.

Similarly your Sort has vicious slowdowns for large N and P - but correct code should have speedups.  Trying to get to the bottom of this myself.  Also - your big-O argument may be correct, but you're neglecting the fact that much of the portion of the merge-sort takes place *in parallel on smaller arrays*, hence the speedups.


## Revisions
- [P] MPI.2.A	Collective Communication (Broadcast, Scatter, Gather)
- [P] MPI.2.P	Collective Communication (Broadcast, Scatter, Gather)


