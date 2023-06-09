##   insertion-sort.asm	Zachary Dubinsky	8 February 2020
## Insertion sort an array.

PR_INT = 1
PR_STR = 4
        .data
unsorted_str: .asciiz "Unsorted Array: "
sorted_str: .asciiz "Sorted Array: "
comma: .asciiz ","
new_line: .asciiz "\n"
array:  .word -1, 0, 5, -9, 12, 13, 1, 4, -5, 2, 8, 8891, -2
endarr:

        .text
        .align 2

main:   addi $sp, $sp, -4    # push 
	sw $ra, 0($sp)       # ret addr on stack
	
	li $v0, PR_STR
	la $a0, unsorted_str
	syscall
        jal print

	la $a0, array        # a0 points into array
        la $a1, endarr       # a1 points to array end
	sub $a1, $a1, $a0
	srl $a1, $a1, 2
        jal isort	     # insertion-sort()
	
	li $v0, PR_STR
	la $a0, sorted_str
	syscall        
        jal print

        lw $ra, 0($sp)       # pop
	addi $sp, $sp, 4     # ret addr

        jr $ra   
	               
## print-array subroutine
print:      
        la $t0, array		# t0 = *A[0]
	la $t1, endarr		#
	addi $t1, $t1, -4	# t1 = *(A[-1] - 1)
loop:
	bge $t0, $t1, exit 	# while(t0 < t1) 
        li $v0, PR_INT		# load print code int
        lw $a0, 0($t0)		# load A[t0]
        syscall			# print(A[t0])
        li $v0, PR_STR		# load print code string
        la $a0, comma		# 
        syscall			# print(",")
        addi $t0, $t0, 4	# increment counter
        j loop			# 
exit:
	li $v0, PR_INT		# load print code int
	lw $a0, 0($t0)		# load A[-1]
        syscall			# print(A[-1])
	li $v0, PR_STR		# load print code string
	la $a0, new_line	#
	syscall			# print("\n")
        jr $ra			#


## insertion-sort subroutine
## $a0: parameter: base address of array
## $a1: parameter: number of elements 
## $t0: p = for loop iterator
## $t1: q = while loop iterator
## $t2: holder for *(q-1)
## $t3: holder for element being sorted (tmp = *p)
## $t4: Endarr = base + (num_elems * 4)
isort:  
        addi $t0, $a0, 4                # *p = a++
	sll $t4, $a1, 2			# Multiply by 4 bytes per element
	add $t4, $a0, $t4		# t4: a + size
for:                                    #
        bge $t0, $t4, done              # for(!(p >= a+size))
        add $t1, $t0, $0                # *q = p
        lw $t3, 0($t0)                  # tmp = *p
while:                                  #
        bge $a0, $t1, done_while        # while(!(a >= q))
        lw $t2, -4($t1)                 # t2 - *(q-1)
        bge $t3, $t2, done_while        # while(!(tmp >= *(q-1))
        sw $t2, 0($t1)                  # *q = *(q-1)
        addi $t1, $t1, -4               # q--        
        j while                         #
done_while:                             #
        sw $t3, 0($t1)                  # *q = tmp
        addi $t0, $t0, 4                # p++
        j for                           #
done:                                   #
        jr $ra                          #