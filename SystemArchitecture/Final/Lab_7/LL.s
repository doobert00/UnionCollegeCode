	
	.data
	.balign 4
arr_raw: .word 5, 6, -1, 12, 112, -110, 1102, 2
endarr_raw: .skip 32
arr_len_raw: .word (endarr_raw - arr_raw)>>2
	
heap_raw: .space HEAPSIZE

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

	
	mov r2, r0		//put heap adress into insert arg register
	mov r1, r7		//firstnode = NIL
	
	mov r4, #0		//i = 0
	ldr r5, arr_len		
	ldr r5, [r5]		//j = arr.size
	ldr r6, arr		//*p -> arr
add_loop:
	cmp r4, r5		//if(i >= j): print list, all elemenets inserted
	bge print_elems
	ldr r0, [r6,r4,lsl#2]	//r0 = A[i]
	bl insert		//insert(A[i],r1,r2)
	mov r2, r1		//move for next call
	mov r1, r0		//move for next call
	add r4, r4, #1		//i = i+1
	b add_loop	

print_elems:
	mov r0, r1		//r1 -> linked list
	bl print		//print(r1)
	
	add sp, sp, #4		
	ldr lr, [sp], #4
	bx lr

/*		Heap Constructor
	Inputs:
r0: Pointer to the heap. (FIND OUT IF THIS POINTS TO FIRST OR LAST)
r1: Contains the heapsize.
r2: contains the nodesize.
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
	Inputs:
r0: parameter: points to the first free node in the heap.
	Outputs:
r0: the new node we have created.
r1: the new value of free, the first free node in the heap.
*/
new:
	cmp r0, r7
	beq index_out_of_bounds_exception
	ldr r1, [r0,#NEXT]	//r1 = newnode
	str r7, [r0,#NEXT]	//r1->next = NIL
	bx lr
index_out_of_bounds_exception:
	push {lr}		//push lr to stack (Thumb accounts for alignment)
	ldr r0, nofree		
	bl printf		//print("No free...
	pop {lr}
	mov r0, r7		//return 0
	mov r1, r7		//return 0
	bx lr
	
/*
		Insert Node
	Inputs:
r0: should contain N
r1: should contain the pointer to our linked list
r2: should contain a pointer to free
	Outputs:
r0: should contain the pointer to our linked list
r1: should contain our new pointer to free
*/
insert:
	cmp r1, r7			
	beq ins_if			//if(listptr == NIL) go to if
	ldr r3, [r1, #DATA]		//r3 = listptr->data
	cmp r0, r3		
	bgt ins_else			//if(listptr->data <  N) go to else
ins_if:
	str r0, [sp,#-4]!		
	str r1, [sp,#-4]!
	str lr, [sp,#-4]!
	str r2, [sp,#-4]!		//Have to store 8 byte aligned
	mov r0, r2			//r1 -> free
	bl new				//r0 -> new node; r1 -> heap
	mov r3, r0			//(So we can get out listptr back)
	mov r2, r1			//(So we can get our heap back)
	add sp, sp, #4
	ldr lr, [sp], #4
	ldr r1, [sp], #4
	ldr r0, [sp], #4
	cmp r3, r7			//if(tmpptr == NIL) throw out_of_nodes exception
	beq out_of_nodes_error		
	str r0, [r3,#DATA]		//tmpptr->data = N
	str r1, [r3,#NEXT]		//tmpptr->next = listptr
	mov r0, r3			//listptr = tmpptr (for return purposes)
	mov r1, r2
	bx lr			
ins_else:
	str r1, [sp,#-4]!		//
	str lr, [sp,#-4]! 
	ldr r1, [r1,#NEXT]		//r1 = listptr->next for inersert argument
	bl insert
	mov r2, r1			//r2 holds free nodes to get listptr back
	ldr lr, [sp], #4		
	ldr r1, [sp], #4		//r1 = listptr
	cmp r0, r7			//if(new node == NIL) throw out_of_nodes_exception
	beq out_of_nodes_error		
	str r0, [r1,#NEXT]		//listptr->next = new node
	mov r0, r1			//return listptr
	mov r1, r2			//return free nodes
	bx lr
out_of_nodes_error:
	push {lr}			
	ldr r0, nofree			//Print("Out of free nodes...
	bl printf
	pop {lr}
	mov r7, #0xe0			//Due to number of ARM architectures the system
	swi 0				//call to force termination was really hard to find.
	mov r1, #9			//This is not my own, but it does work to terminate 
	mov r7, #0xee			//The program as desired.
	swi 0
	
/*		
		Print
	Inputs: 
r0: contains the pointer to our linked list
	Outputs:
r0: contains the pointer to our linked list
*/
print:
	str lr, [sp,#-4]!
	str r0, [sp,#-4]!		//Stack requires 8-byte offset
	str r4, [sp,#-4]!		//Callee protected
	str r5, [sp,#-4]!		//Callee protected
	mov r5, r0 			//bl printf won't hurt this
	
prloop:
	cmp r5, r7
	beq prdone			//if(listptr == 0): done 
	ldr r0, to_str			
	ldr r1, [r5,#DATA]		//print(listptr->data)
	bl printf
	ldr r0, comma			//print(",")
	bl printf
	ldr r5, [r5,#NEXT]		//tmpptr = tempptr->next
	b prloop		
prdone:
	ldr r0, nl			//print("\n")
	bl printf
	ldr r5, [sp], #4		//Restore registers
	ldr r4, [sp], #4
	ldr r0, [sp], #4
	ldr lr, [sp], #4
	bx lr
	
	
	
	
//Pointers
heap: .word heap_raw
arr: .word arr_raw
arr_len: .word arr_len_raw

//Constants
.equ NEXT,  0
.equ DATA, 4
.equ DATASIZE, 4
.equ NODESIZE, 8
.equ NUMNODES, 15
.equ HEAPSIZE, 120
.equ NIL, 0

//Strings
to_str: .word to_str_raw
nl: .word new_line_raw
space: .word space_raw
comma: .word comma_raw
nofree: .word nofree_raw
