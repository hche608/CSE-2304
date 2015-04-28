#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 5
#Part1


		.data	# Data declaration section
prompt:				.asciiz "Please Enter An Integer:"
displayResult:		.asciiz "After QuickSort: \n"
space:				.asciiz ", "
newline:			.asciiz "\n"

					.align 2 # Make sure that our input data is well aligned
array: 				.space 40 # Reserved storage of 40 bytes, to store 10 fractions (4 bytes each)
					.text
		
main: # Start of code section 
		la 		$t0, array
		addi 	$t1, $zero, 10			# Initialize $t1 to ten. This will be size of array

#read singles.
inputloop: 
		la 		$a0, prompt 
		add 	$v0, $zero, 4
		syscall

        li      $v0, 5               	# read integer
        syscall                     	# input --> $v0
		
		sw 		$v0, 0($t0) 			# $v0 --> array
		add 	$t0, $t0, 4				# index++
		
		addi 	$t1, $t1, -1 			# counter--
		bgtz 	$t1, inputloop
		
		# initial variables
		la		$a0, array				# $a0 = array
		add		$a1, $zero, $zero		# $a1 = 0
		addi	$a2, $zero, 9			# $a2 = 9
		jal		QuickSort				# jump to QUICKSORT
		
		jal		printArray				# jump to printArray and save position to $ra
		
		
end: 
		li 		$v0, 10 
		syscall	
		
#----------------------------------------------------------------------
#    QUICKSORT Function
#
#    # $a0 = array, $a1 = first, $a2 = last
#----------------------------------------------------------------------
QuickSort:	
		bge     $a1, $a2, QuickSortEnd    
		
		addi 	$sp, $sp, -12
		sw 		$ra, 8($sp)
		sw 		$a1, 4($sp)
		sw 		$a2, 0($sp)			# save ra, a0, a1, a2
		
		# Find pivot and return $v0
    	jal 	Partition       	# partition(a0, a1, a2)
		add		$s0, $v0, $zero		# retuen the index of pivot $v0, $s0 = $v0
			
		# Do left side
		lw 		$a1, 4($sp)
		addi    $a2, $s0, -1      	# a2 = index of the pivot - 1
    	jal 	QuickSort

		# Do Right side
		addi    $a1, $s0, 1    		# a1 = index of the pivot + 1
    	lw		$a2, 0($sp)			# a2 = last
    	jal 	QuickSort
		
		lw 		$a2, 0($sp)
		lw 		$a1, 4($sp)
		lw 		$ra, 8($sp)
		addi 	$sp, $sp, 12		# move SP point to the previous position
QuickSortEnd:	
		jr 		$ra					# jump to $ra

Partition:	
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		
		# load pivot = arr[a2]
		sll 	$t1, $a2, 2			#
		add 	$t1, $t1, $a0		# get &arr[a2]
		lw 		$s3, 0($t1)
			
		addi 	$a3, $a1, -1		# the number of value less than pivot, ndx
		add 	$t6, $a1, $zero		# the index

Loop:	
		sll 	$t2, $t6, 2			#
		add 	$t2, $t2, $a0		# get &arr[index]
		lw 		$s4, 0($t2)
		
		blt		$s3, $s4, Skip		# if $t0 < $t1 then target
		
		addi 	$a3, $a3, 1			# ndx++
		jal		Swap				# Do swap
Skip:			
		addi 	$t6, $t6, 1			# index++
		bgt     $t6, $a2, EndLoop  	# if index > a2 then EndLoop
		b		Loop				# branch to Loop
		
		
EndLoop:	

		add 	$v0, $a3, $zero		# return $v0 = ndx
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4			# move SP point to the previous position
		jr 		$ra					# jump to $ra

Swap:	
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		
		sll 	$t1, $a3, 2			#
		add 	$t1, $t1, $a0		# get &arr[ndx]
		lw 		$s1, 0($t1)	
		

		sll 	$t2, $t6, 2			#
		add 	$t2, $t2, $a0		# get &arr[index]
		lw 		$s2, 0($t2)	
		
		sw 		$s1, 0($t2)			#
		sw 		$s2, 0($t1)			# do swap
		
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4			# move SP point to the previous position
		jr 		$ra					# jump to $ra
	
printArray:
		addi	$t2, $a2, 1			# $t2 = size	
		la 		$t0, array			
		
		la 		$a0, displayResult 
		add 	$v0, $zero, 4
		syscall

outputloop: 		
		lw		$a0, 0($t0)
		li 		$v0, 1
		syscall
	
		add 	$t0, $t0, 4
			
		addi 	$t2, $t2, -1		# check for the last element in the array
		beqz 	$t2, skipspace
		
		la 		$a0, space 
		add 	$v0, $zero, 4
		syscall
		b		outputloop			# branch to outputloop
		
skipspace:			
		#bgtz 	$t2, outputloop
		jr		$ra					# jump to $ra
		