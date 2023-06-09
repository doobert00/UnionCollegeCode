/*
	Insertion Sort 			Zach Dubinsky			3/14/22
	A program that implements insertion sort on an array stored in data memory.
*/
	.data
	.balign 4
arr_raw: .word 2, 8, -9, 4, 10, 17, 32, 1009, -112, 30
endarr_raw: .skip 40				//Clear 40 bytes of space ahead of arr_raw
len_raw: .word (endarr_raw - arr_raw)>>2 	//Length of the array

//Strings for printing
to_str_raw: .asciz "%d"
comma_raw: .asciz ","
new_line_raw: .asciz "\n"
unsorted_raw: .asciz "Unsorted List: "
sorted_raw: .asciz "Sorted List: "

	.text
	.globl main
main:
	str lr, [sp,#-4]!	//ARM requires the stack be 8-byte aligned
	str r0, [sp, #-4]!
				
				//r4 = *A, r5 = A.length
	ldr r4, arr		//r4 and r5 let us use mov instead
	ldr r5, len		//of retrieving from memory every time.
	ldr r5, [r5]		//Safe because they are protected by callee.
		
	ldr r0, unsorted	
	bl printf		//printf("Unsorted List: ")
	
	mov r0, r4
	mov r1, r5
	bl pr_arr		//print(arr)

	mov r0, r4		//r0 -> arr[0]
	mov r1, r5		//r1 = arr.size
	bl i_sort		//insertion_sort(arr)

	ldr r0, sorted		
	bl printf		//printf("Sorted List: ")
	
	mov r0, r4
	mov r1, r5
	bl pr_arr		//print(arr)

	add sp, sp, #4
	ldr lr, [sp], #4
	bx lr

/*
		print-array
	Inputs:
r0: base address of array
r1: array length
	Outputs: N/A
*/
pr_arr:
	str r5, [sp, #-4]!
	str r4, [sp, #-4]!
	str lr, [sp, #-4]!
	str r0, [sp, #-4]!
	mov r4, r0		//i = &arr
	mov r5, r1		
	lsl r5, r5, #2		//index by word
	add r5, r5, r4		//r5 = &arr[-1]
	add r5, r5, #-4		//r5 = &arr[-1]
	
pr_loop:
	cmp r4, r5
	bge pr_done		//for(i = arr; i < &arr[-1];i++)

	ldr r0, to_str		
	ldr r1, [r4], #4	//r1 = *i and i++	
	bl printf		//printf("%d",*i)	

	ldr r0, comma		
	bl printf		//printf(",")

	b pr_loop
pr_done:
	ldr r0, to_str
	ldr r1, [r5]		//r1 = *i
	bl printf		//printf("%d",*i)
	ldr r0, new_line	
	bl printf		//printf("\n")
	add sp, sp, #4
	ldr lr, [sp], #4
	ldr r4, [sp], #4
	ldr r5, [sp], #4
	bx lr



/*
		Insertion sort subroutine
	Inputs:
r0: parameter: base address of array
r1: parameter: number of elements
	Outputs: N/A
	Locals:
r1: address of endarr
r2: *p
r3: tmp
r4: *(q-1)
r5: *q
*/
i_sort:
	str r4, [sp,#-4]!	//Store protected registers
	str r5, [sp,#-4]!	//8-byte alignment
	add r2, r0, #4		//*p = arr++
	lsl r1, r1, #2		//
	add r1, r1, r0		//r1 = arr.length
for:
	cmp r2, r1		//for (!(p >= a+size))
	bge sort_done		//
	mov r5, r2		//*q = p
	ldr r3, [r2], #4	//tmp = *p and p++ after ldr
while:
	cmp r0, r5		//while (!(a >= q))
	bge done_while		//
	ldr r4, [r5, #-4]	//r4 = *(q-1)
	cmp r3, r4		//while (!(tmp >= *(q-1)))
	bge done_while		//
	str r4, [r5]		//*q = *(q-1)
	add r5, r5, #-4		//q--
	b while			//
done_while:			
	str r3, [r5]		//*q = tmp
	b for			//
sort_done:			
	ldr r5, [sp], #4
	ldr r4, [sp], #4
	bx lr			


//Pointer Section
arr: .word arr_raw
len: .word len_raw
//String Stuff
to_str: .word to_str_raw
comma: .word comma_raw
new_line: .word new_line_raw
sorted: .word sorted_raw
unsorted: .word unsorted_raw
