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

	.text
	.globl main
main:	
	//You will need these ldr and str strategies for the future.			
	//! increments the base register by the offset for ldr's and str's.
	str lr, [sp, #-4]!	//A new way to push to the stack. ARM aligns by
	str r0, [sp, #-4]! 	//8 bytes so we push two words to avoid issues.
	
	ldr r0, arr		//r0 points into array
	ldr r1, endarr		//r1 points to the end of the array
	bl arrsum
	
	mov r1, r0		//For printing
	ldr r0, to_str		//String to printf an integer
	bl printf
	
	add sp, sp, #4		//r0 was empty when stored so just increment sp
	ldr lr, [sp], #4	//loads with no offset, then increments sp by offset
	
	bx lr 

/*
		Array Summing Subrouting
	Inputs:
r0: pointer to array
r1: pointer to the end of the array
	Outputs:
r0: sum of integers in the array
*/
arrsum: 
	mov r2, #0		//Holds the sum
sum:	
	cmp r0, r1		
	bge done		//while(r0 < endarr) do:
	ldr r3, [r0], #4	//get next array element and increment array ptr	
	add r2, r2, r3		//add the element to the sum
	b sum			//loop
done:
	mov r0, r2		//move r2 into r0, our chosen return register
	bx lr

//Pointers
arr: .word arr_raw
endarr: .word endarr_raw

//Strings
to_str: .word to_str_raw
