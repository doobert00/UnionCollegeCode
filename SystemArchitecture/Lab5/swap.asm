#   swap.asm	Zach Dubinsky	7 February 2020
#   Elementary program to add three numbers and store and print the sum.
#   Register use:
#	$t0: base address of array ar
#	$t1, $t2: address of elements of ar at indices index1 and index 2 resp.
#	$t3, $t4: holds contents of ar[index1] and ar[index2] resp.

        .data                           # FYI: start of data section
ar:     .word    0, 1, 2, 3, 4, 5       # A 6-element integer array
index1:      .word    0			# Index to swap
index2:      .word    3			# Index to swap

        .text                   # FYI: start of code section
        .align 2                # FYI: align to start code on a word boundary
        .globl main             # FYI: make 'main' visible to the simulator
main:                           # main() {
        la   $t0, ar            # 	temp  = base address of array 
        lw   $t1, index1        # 	
        lw   $t2, index2        #
        sll  $t1, $t1, 2        #	
        sll  $t2, $t2, 2        #	
        add  $t1, $t1, $t0      #	t1 = address of ar[index1]
        add  $t2, $t2, $t0      #	t2 = address of ar[index2]
        lw   $t3, 0($t1)        #	t3 = ar[index1]
        lw   $t4, 0($t2)        #	t4 = ar[index2]
        sw   $t3, 0($t2)        #	ar[index2] = t3
        sw   $t4, 0($t1)        #	ar[index1] = t4
        jr   $ra                #    return control to the simulator
                                # }