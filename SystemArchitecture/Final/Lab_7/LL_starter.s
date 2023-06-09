/*
		Linked Structures in ARM Assembly 		Zach Dubinksy 3/17/22
	This program build a heap as a singly-linked list of nodes that are then used to
build a singly linked list of numbers.
	mknodes: Builds a list of free nodes from an unstructured heap space.
	new: (you write) returns a node from the free list
	insert: (you write) inserts an integer into a linked list, in order.
	print: (you write) traverses the list and prints its contents neatly.
*/	
	.data
	.balign 4
arr_raw: .word 5
endarr_raw: .skip 4		//Add more to the array, no bigger than the linked list capacity.
arr_len_raw: .word (endarr_raw - arr_raw)>>2

heap_raw: .space HEAPSIZE	//Storage for the nodes

//Strings
to_str_raw: .asciz "%d"
new_line_raw: .asciz "\n"
space_raw: .asciz " "
comma_raw: .asciz ","
nofree_raw: .asciz "Out of free nodes, terminating program.\n"
	
	.text
	.globl main
main:
	str lr, [sp, #-4]!
	str r0, [sp, #-4]!
	mov r7, #NIL		//Callee protected register containing NILL value
	
	ldr r0, heap		//Get adress for top of heap
	mov r1, #HEAPSIZE	//HEAPSIZE arg
	mov r2, #NODESIZE	//NODESIZE arg
	bl mknodes		//make the heap
	
	
/*	
Insert the values in the input array by calling insert for each one. When
the insertion is done, store the list pointer in the list variable and then 
call a subroutine to traverse the list and print its contents. REMOVE these
comment lines before turning in the program.
*/
	
	add sp, sp, #4		
	ldr lr, [sp], #4
	bx lr

/*		Heap Constructor
mkNodes takes a heap address in r0, it's byte-size in r1, and node size in r2, 
and partitions the space into a singly-linked list of nodesize nodes, pointed to by free.
	NOTE: This list is build with free pointing to the last node in the heap area
which points to the prvious one, etc. The reason for this construction is to be sure 
that you get nodes by calling "new" rather than by rebuilding the heap yourself.
	Register use:
r3: Pointer to the block that will become a node
r4: Pointer to the block that will become the next node
	Inputs:
r0: Pointer to the heap. (FIND OUT IF THIS POINTS TO FIRST OR LAST)
r1: Contains the heapsize.
r2: Contains the nodesize.
	Outputs:
r0: points to the first free node in the heap. 
*/
mknodes:
	str r4, [sp, #-4]! 	//r4 is callee preserved
	str r3, [sp, #-4]!	//stack is 8-byte aligned
	add r3, r0, r1		//r3 points to the last element
	sub r3, r3, r2		//	node sized block
	str r3, [sp]		//First free address on stack
mkloop:
	sub r4, r3, r2		//r4 points to prev. node sized block
	str r4, [r3,#NEXT]	//link r3.next -> r
	mov r3, r4		//back up r3 by one node
	cmp r3, r0		//repeat if not at beginning of heap
	bne mkloop
	str r7, [r4,#NEXT]	//Last node has no next node
	ldr r0, [sp], #4	//Put output in r0
	ldr r4, [sp], #4	//Put r4 where we found it
	bx lr
	
/*		Create Node
Removes a node from free (passed in r0) and returns a pointer to the node in r0,
and a pointer to the updated free list in r1.
	Inputs:
r0: parameter: points to the first free node in the heap.
	Outputs:
r0: the new node we have created.
r1: the new value of free, the first free node in the heap.
*/
new:
	bx lr
	
/*
		Insert Node
Inserts a node into an ordered position in the list. 

	Inputs:
r0: should contain N
r1: should contain the pointer to our linked list
r2: should contain a pointer to free
	Outputs:
r0: should contain the pointer to our linked list
r1: should contain our new pointer to free
*/
insert:
	bx lr
	
/*		
		Print
Prints the contents of our linked list.
	Inputs: 
r0: contains the pointer to our linked list
	Outputs:
r0: contains the pointer to our linked list
*/
print:
	bx lr
	
	
	
	
//Pointers
heap: .word heap_raw		//Pointer to the heap

arr: .word arr_raw		//Array pointers (we've seen this before)
arr_len: .word arr_len_raw

//Constants
.equ NEXT,  0		//Offset to the next pointer
.equ DATA, 4		//Offset to data portion of node
.equ DATASIZE, 4	//Size of data in the node (word)
.equ NODESIZE, 8	//DATASIZE + DATA 
.equ NUMNODES, 15	//
.equ HEAPSIZE, 120	//NUMNODES * NODESIZE
.equ NIL, 0		//For null pointer, we'll keep it in r7 for easy accesss.

//Strings
to_str: .word to_str_raw
nl: .word new_line_raw
space: .word space_raw
comma: .word comma_raw
nofree: .word nofree_raw
