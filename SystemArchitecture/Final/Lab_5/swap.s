/*
	swap.s			Zach Dubinsky		3/14/22
	Swaps two elements of an integer array specified at indices
	index1, and index2.

Remark: See remark in sum2.s for information on .data section.
*/

	.data 			//.data section
	.balign 4		//data is word aligned
arr_raw: .word  0, 1, 2, 3, 4	//Array elements
endarr_raw: .skip 20		//Allocates 20 bytes (5 words) for arr
index1_raw: .word 0		//Swap index 
index2_raw: .word 2		//Swap index
to_str_raw: .asciz "%d "	//Printer helper
	.text
	.globl main
main:
	
	ldr r0, index1		//		
	ldr r0, [r0]		//r0 = index1
	ldr r1, index2		//	
	ldr r1, [r1]		//r1 = index2
	ldr r2, arr		//r2 -> arr
	ldr r3, [r2,r0,lsl#2] 	//r3 = arr[index1*4] (word adressable)
	ldr r4, [r2,r1,lsl#2]	//r4 = arr[index2*4] (word adressable)
	str r3, [r2,r1,lsl#2]	//arr[index2*4] = r3
	str r4, [r2,r0,lsl#2]	//arr[index1*4] = r4
	
	push {lr}		//Push the link register to the stack
	mov r5, r2		//r5 = *A[0]
	ldr r4, endarr		//r4 = *A[-1] 
print_loop:
	cmp  r5, r4
	beq end			//if(*A[0] + increment == *A[-1]): done printing
	
	ldr r0, to_str		
	ldr r1, [r5], #4 	//r1 = A[i] and increment i for next elem
	bl printf		//printf("%d ",A[i])

	b print_loop		
end:
	pop {lr}		//Pop the link register
	bx lr			

//Pointer section
arr: .word arr_raw
endarr: .word endarr_raw
index1: .word index1_raw
index2: .word index2_raw
to_str: .word to_str_raw
