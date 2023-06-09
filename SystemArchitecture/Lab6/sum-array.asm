##   sum-array.asm	Zachary Dubinsky	8 February 2020
## Sum an array with a subroutine.

PR_INT = 1
PR_STR = 4
        .data
string: .asciiz "Sum: "
array:  .word 100, 2, -395, 2993, 2, -400, 203
endarr:

        .text
        .align 2

main:   la $a0, array        # a0 points into array
        la $a1, endarr       # a1 points to array end
        sub $a1, $a1, $a0
        srl $a1, $a1, 2

	addi $sp, $sp, -4        # push 
	sw $ra, 0($sp)           # ret addr on stack
        jal arrsum
	lw $ra, 0($sp)           # pop
        addi $sp, $sp, 4         # ret addr

        add $s0, $v0, $0

        li $v0, PR_STR
        la $a0, string
        syscall

        add $a0, $s0, $0         # copy sum into $a0
        li $v0, PR_INT           # print code in $v0
        syscall
        
        jr $ra                  

## array-summation subroutine
## register use:
##	$a0: parameter: array addr; used as pointer to current element
##	$a1: parameter: number of elements in the array
##	$v0: accumulator and return value
##      $t0: loop counter variable
##	$t2: temporary copy of current array element

sum:    lw $t2, 0($a0)       #    get next array element
        add $v0, $v0, $t2    #    add it in
        addi $a0, $a0, 4     #    point to next word
        addi $t0, $t0, 1     #    increment the counter
        bge $a1, $t0, sum    # do <sum> while(array size > counter)
        j done               # 
arrsum: move $v0, $0         # v0 accumulates sum
        move $t0, $0         # t0 is counter variable
        bne $a1, $0, sum     # if (array size != 0) branch to sum 
done:   jr $ra