/*	sum.s		Zach Dubinsky		3/14/22
	Elementary program to add three numbers and store and print the sum.
	Register use:
		r0: temporary storage for data to be summed
		r1: accumulates the sum

Remark: Elements of the .data section cannot be directly accessed due to 
	dynamic allocation. Rather, we use pointers defined outside. In
	this code, and all subsequent labs, mine are located at the bottom.
*/

	.data 		//.data section
	.balign 4	//data is word aligned
num1_raw: 	.word	17
num2_raw: 	.word 	-35
num3_raw: 	.word 	276
sum_raw: 	.space 	4 //.space allocates (a word here) memory downward/
to_str_raw: .asciz "%d\n"	//printer helper for integers

	.text
	.globl main
main:
	ldr r0, num1		//Load address of num1
	ldr r0, [r0]		//temp = num1
	add r1, r0, #0		//accum = temp
	ldr r0, num2		
	ldr r0, [r0]		//temp = num2
	add r1, r1, r0		//accum += temp
	ldr r0, num3		
	ldr r0, [r0]		//temp = num3
	add r1, r1, r0		//accum += temp
	ldr r0, sum		
	str r1, [r0]		//r1 = sum (for printing)
		
	ldr r0, to_str		//printing helper, r1 = sum already		
	push {lr}
	bl printf		//printf("%d\n",sum)
	pop {lr}

	bx lr

//Pointers make accessing data memory (.data) safer. Include
//pointers of this form in your code.
num1: .word num1_raw
num2: .word num2_raw
num3: .word num3_raw
sum: .word sum_raw
to_str: .word to_str_raw
