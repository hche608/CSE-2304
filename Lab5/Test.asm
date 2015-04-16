#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 5
#Part1


		.data	# Data declaration section
prompt:				.asciiz "Please Enter A Number:"
displayResult:		.asciiz "After QuickSort: "
space:				.asciiz ", "
newline:			.asciiz "\n"

					.align 2 # Make sure that our input data is well aligned
array: 				.space 40 # Reserved storage of 40 bytes, to store 10 fractions (4 bytes each)
					.text
		
main: # Start of code section 
		la 		$t0, array
		add 	$t1, $zero, $zero 		# Initialize $t1 to zero
		addi 	$t2, $zero, 10			# Initialize $t2 to ten. This will be our counter

#read singles.
inputloop: 
		la 		$a0, prompt 
		add 	$v0, $zero, 4
		syscall

        li      $v0, 6               	# read single
        syscall                     	# $f0 <-- x
		
		s.s 	$f0, 0($t0) 
		add 	$t0, $t0, 4
		
		addi 	$t2, $t2, -1			# counter for input loop
		addi 	$t1, $t1, 1 			# size of the array
		bgtz 	$t2, inputloop
		
		#la		$a0, array				# $a0 = array
		#add		$a1, $zero, $zero		# $a1 = 0
		#addi	$a2, $zero, 9		# $a2 = 9
		#jal		QuickSort				# jump to QUICKSORT
		
		jal		printArray				# jump to printArray and save position to $ra
		
		
end: 
		li 		$v0, 10 
		syscall	
		
#----------------------------------------------------------------------
#    QUICKSORT Function
#
#    # $a0 = array, $a1 = left, $a2 = right
#----------------------------------------------------------------------
QuickSort:
    	bgt     $a1, $a2, QuickSortEnd    

    	subu    $sp, $sp, 16
    	sw      $ra, 16($sp)
    	sw      $a0, 12($sp)
    	sw      $a1, 8($sp)
    	sw      $a2, 4($sp)   		#save a0, a1, a2, ra
    	jal 	Partition       	#partition(v, a, b) 

    	subu    $sp, $sp, 4
    	sw      $v0, 4($sp)   
    	lw      $a0, 16($sp)      	#a0 = v
    	lw      $a1, 12($sp)      	#a1 = a
    	addi    $a2, $v0, -1      	#a2 = k - 1 
    	jal 	QuickSort

    	lw      $a0, 16($sp)  		#a0 = v
    	lw      $t0, 4($sp)
    	addi    $a1, $t0, 1   		#a1 = k + 1
    	lw      $a2, 8($sp)   		#a2 = b
    	jal 	QuickSort

    	addu 	$sp, $sp, 20
    	lw 		$ra, 0($sp)    

QuickSortEnd: 
		jr 		$ra
	
	
	
Partition:
    	add 	$t1, $a1, $a1
    	add 	$t1, $t1, $t1
    	add 	$t1, $t1, $a0      	#t2 = pivot
    	lw  	$t2, 0($t1)       	#v[a]
    
    	addi 	$t3, $a1, 1      	#t3 = lower = a + 1
    	addi 	$t4, $a2, 0      	#t4 = upper = b

Do:
		blt 	$t4, $t3, PartitionEnd
		
W1:
   		add     $t8, $t3, $t3
    	add     $t8, $t8, $t8
    	add     $t8, $t8, $a0      
    	lw      $t5, 0($t8)       	#t5 = v[lower]
    
    	ble     $t5, $t2, W12
    
    	beq 	$zero, $zero, W2
W12:
    	ble     $t3, $t4, W1_Op
    
    	beq 	$zero, $zero, W2
W1_Op:
    	addi    $t3, $t3, 1
    	beq 	$zero, $zero, W1

W2:
    	add     $t8, $t4, $t4
    	add     $t8, $t8, $t8
    	add     $t8, $t8, $a0      
    	lw      $t5, 0($t8)       	#t5 = v[upper]
    
    	bgt     $t5, $t2, W22
    
    	beq 	$zero, $zero, f
W22:
    	ble     $t3, $t4, W2_Op
    
   	 	beq 	$zero, $zero, f
W2_Op:
    	addi    $t4, $t4, -1
    	beq 	$zero, $zero, W2

f:
    	bgt     $t3, $t4, Do
    
    	add     $t8, $t3, $t3
    	add     $t8, $t8, $t8
    	add     $t8, $t8, $a0      
    	lw      $t6, 0($t8)       	#temp = v[lower]
    

    	add     $t9, $t4, $t4
    	add     $t9, $t9, $t9
    	add     $t9, $t9, $a0      
    	lw      $t7, 0($t9)       	#v[upper]
    

    	sw      $t7, 0($t8)       	#v[lower] = v[upper]
    	sw      $t6, 0($t9)       	#v[upper] = temp

    	addi    $t3, $t3, 1
    	addi    $t4, $t4, -1

		j 		Do

PartitionEnd:
    	add     $t8, $t4, $t4
    	add     $t8, $t8, $t8
    	add     $t8, $t8, $a0      
    	lw      $t2, 0($t8)       	#temp = v[upper]
    

    	add     $t9, $a1, $a1
    	add     $t9, $t9, $t9
    	add     $t9, $t9, $a0      
    	lw      $t3, 0($t9)       	#v[a]
    

    	sw      $t3, 0($t8)       # v[upper] = v[a]
    	sw      $t2, 0($t9)       # v[a] = temp

    	addi    $v0, $t4, 0       #return upper(k)
    	jr      $ra
    	
	
printArray:
		addi		$t2, $zero, 10		# $t2 = $t1 + $t2	
		la 			$t0, array
		la 			$a0, displayResult 
		add 		$v0, $zero, 4
		syscall
outputloop: 
		
		l.s		$f12, 0($t0)
		li 		$v0, 2
		syscall
	
		add 	$t0, $t0, 4
			
		addi 	$t2, $t2, -1			# counter for input loop
		beqz 	$t2, skipspace
		
		la 		$a0, space 
		add 	$v0, $zero, 4
		syscall
skipspace:
			
		bgtz 	$t2, outputloop
		jr		$ra					# jump to $ra
		