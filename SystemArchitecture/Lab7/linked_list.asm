#  Linked structures in assembler       Zach Dubinsky  2 February 2022
#  Linked structures in assembler       J. Rieffel 15 February 2011
# (removed dependance on in-line constant definitions)
#  This program builds a heap as a singly-linked list of nodes that
#  are then used to build a singly-linked list of numbers.
#       mknodes: builds a linked list of free nodes from an 
#                 unstructured heap space. 
#       new:    (you complete it) returns a node from the free list
#       insert: (you write) inserts an integer into a linked list, in order.
#       print:  (you write) traverses a list and prints its contents neatly

## System calls
PR_INT = 1
PR_STR = 4

## Node structure
NEXT     = 0                    ## offset to next pointer
DATA     = 4                    ## offset to data
DATASIZE = 4
NODESIZE = 8    ##DATA + DATASIZE       bytes per node
NUMNODES = 15           
HEAPSIZE = 120  ##NODESIZE*NUMNODES
NIL      = 0                    ## for null pointer

        .data
comma: .asciiz ","
input: .word 17, 29, -3, 2, 5, 2, 3994, 10, -1
inp_end:
INSIZE = 1 #(inp_end - input)/4    # number of input array elements

heap:   .space  HEAPSIZE           # storage for nodes 
spce:   .asciiz "  "
nofree: .asciiz "Out of free nodes; terminating program\n"

        .align 2
        .text
main:   
	addi $sp, $sp, -4
        sw $ra, 0($sp)
        li $s7, NIL             # global variable holding the NIL value
        la $a0, heap            # pass the heap address to mknodes
        li $a1, HEAPSIZE	#      and its size
        li $a2, NODESIZE 	#      and the size of a node
        jal mknodes
        
	move $a2, $v0           #v0 contains first free node in the heap
	move $a1, $s7
	
	la $s0, input
	la $s1, inp_end
add_elems:	
	bge $s0, $s1, print_elems
	lw $a0, 0($s0)
	jal insert
	move $a2, $v1
	move $a1, $v0
	addi $s0, $s0, 4
	j add_elems 
print_elems:
	move $a0, $v0
	jal print
	
	lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

# mknodes takes a heap address in a0, its byte-size in a1, and node size in a2
#  and partitions it into a singly-linked list of nodesize
# (NODESIZE-byte) nodes, pointed to by free.  
# NOTE:  the list is built with free pointing to the last node in the
#    heap area, which points to the previous one, etc.  The reason for
#    this construction is to be sure that you get nodes by calling
#    "new" rather than by rebuilding the heap yourself!  
# Register usage:
# inputs:
# $a0 contains a pointer to the heap
# $a1 contains the heapsize
# $a2 contains the nodesize

# used registers
# $t0: pointer to block that will become a node
# $t1: pointer to previous block (will become next node)

# $v0: points to the first free node in the heap
mknodes:
        add $t0, $a0, $a1       # t0 starts by pointing to the last
        sub $t0, $t0, $a2       #   node-sized block in the heap
        move  $v0, $t0          # set output v0 to point to that first node
mkloop: sub $t1, $t0, $a2       # t1 points to previous node-sized block
        sw  $t1, NEXT($t0)      # link the t0->node to point to t1 node
        move $t0, $t1           # back up t0 by one node
        bne $t0, $a0, mkloop    # repeat if not at heap-start
        sw $s7, NEXT($t1)       # ground node (first block in heap)
        jr $ra

# Removes a node from free (passed in via $a0), returning a pointer to the node in $v0,
# and a pointer to the new free in $v1
#  ( returns NIL if none available)
# inputs:
#    $a0: points to the first "free" node in the heap
# outputs:
#    $v0: the node we have "created" (pulled off the stack from free)
#    $v1: the new value of free (we don't want to clobber $a0 when we change free, right? right?)
new:
        beq $a0, $s7, index_out_of_bounds_exception     #if($a0 == NIL): error, return NIL 
        move $v0, $a0                                   #$v0 contains pointer to new node
	lw $v1, NEXT($a0)
	sw $0, NEXT($v0)
        jr $ra
index_out_of_bounds_exception:
        move $v0, $s7                                   #return NIL
        move $v1, $s7                                   #return NIL
        jr $ra

#insert behaves as described in the lab text
# inputs:
#	 $a0: should contain N
#	 $a1: should contain a pointer to our linked list
#	 $a2: should contain a pointer to free
#
# outputs:
# 	$v0 should contain the new pointer to our linked list
#	$v1 should contain the new pointer to free
#
# local vars (allows for subroutines):
#       $s0: N
#       $s1: iterable pointer to linked list
#	$t0: pointer to new node
#	$t1: value of current node/adress of next node when inserting

insert:
	beq $a1, $s7, ins_if			# (listptr == NULL) => go to if
	lw $t0, DATA($a1)			# t0 = listptr->data
	slt $t1, $t0, $a0			# (t1 = 1) iff (listptr->data < N)
	bge $a0, $t0, ins_else			# => (listptr->data < N) =>  go to else
ins_if:
	addi $sp, $sp, -8			#
	sw $a0, 4($sp)				#
	sw $ra, 0($sp)				#
	move $a0, $a2				#
	jal new					# $v0 = new node; $v1 = updated free node
	lw $a0, 4($sp)				#
	lw $ra, 0($sp)				#
	addi $sp, $sp, 8			#
	beq $v0, $s7, out_of_nodes_error	# if(v0 == NIL) throw out_of_nodes exception
	sw $a0, DATA($v0)			# tempptr->data = N
	sw $a1, NEXT($v0)			# tempptr->next = listptr 
	jr $ra					#
ins_else:					#
	addi $sp, $sp, -12			#
	sw $a1, 8($sp)				#
	sw $a0, 4($sp)				#
	sw $ra, 0($sp)				#
	lw $a1, NEXT($a1)			# a1 = listptr->next
	jal insert				# new_node = insert(a1,N); $v1 = updated free nodes
	lw $a1, 8($sp)				#
	lw $a0, 4($sp)				#
	lw $ra, 0($sp)				#
	addi $sp, $sp, 12			#
	beq $v0, $s7, out_of_nodes_error	# if (new_node == 0) throw out_of_nodes exception
	sw $v0, NEXT($a1)			# new_node->next = listptr
	move $v0, $a1				# return new_node
	jr $ra					#
out_of_nodes_error:				#
	la $a0, nofree				#
	li $v0, PR_STR				#
	syscall 				#
	addi $a0, $0, 17			#
	syscall					#

# print: prints each element of the linked list in order
# inputs:
#	 $a0: contains the pointer to our linked list
# outputs: 
#	N/A
#
# local vars:
#	$t0: holds our pointer to the linked list
print:
	move $t0, $a0
prloop:
	beq $t0, $s7, prdone
	li $v0, PR_INT
	lw $a0, DATA($t0)
	syscall
	li $v0, PR_STR
	la $a0, comma
	syscall
	lw $t0, NEXT($t0)
	j prloop
prdone:
	move $v0, $0
	jr $ra
	










