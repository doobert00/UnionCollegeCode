/*	
		Array Summer 		Zach Dubinsky		3/14/22
	A program that sums the contents of an array in data memory
*/
	.data
	.balign
arr_raw: .word -123, 548, 923, 431, 560, -348, 961
endarr_raw: .skip 28 	//Allocate 28 bytes ahead of arr_raw
len_raw: .word (endarr_raw - arr_raw)>>2 //Length of the array

//Strings for printing
to_str_raw: .asciz "%d "
sum_raw: .asciz "Sum: "
nl_raw: .asciz "\n"

	.text
	.globl main
main:	
	str lr, [sp, #-4]!	
	str r0, [sp, #-4]! 	
	
	ldr r0, arr		//r0 points into array
	ldr r1, len		//r1 points to the array length
	ldr r1, [r1]		//r1 contains the array length
	bl arrsum
	mov r4, r0		//Put sum in proect register so we can print after
				//printing our descriptive message
	ldr r0, sum_str		//The descriptive message in question
	bl printf
	
	mov r1, r4		//Put sum back in r1 to print it
	ldr r0, to_str		//String to printf an integer
	bl printf
	
	ldr r0, nl		//Print a new line for the look :)
	bl printf
	
	add sp, sp, #4		//r0 was empty when stored so just increment sp
	ldr lr, [sp], #4	//loads with no offset, then increments sp by offset
	
	bx lr 

/*
		Array Summing Subrouting
	Inputs:
r0: pointer to array
r1: number of elements in the array
	Outputs:
r0: sum of integers in the array
*/
sum:	
	push {r4}		//r4 is a protected register, but we need a fifth
	ldr r4, [r0], #4	//Get next element and then point to next word
	add r2, r2, r4		//Add it to the sum
	add r3, r3, #1		//Increment the counter
	pop {r4}		
	cmp r3, r1
	blt sum
	b done
arrsum: 
	mov r2, #0		//Sum register
	mov r3, #0		//Counter register
	cmp r3, r1
	bne sum			//if(array size != 0): branch to sum
done:
	mov r0, r2		//move r2 into r0, our chosen return register
	bx lr

//Pointers
arr: .word arr_raw
endarr: .word endarr_raw
len: .word len_raw

//Strings
to_str: .word to_str_raw
sum_str: .word sum_raw
nl: .word nl_raw
