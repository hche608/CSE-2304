#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 5
#Part1


		.data	# Data declaration section
prompt:				.asciiz "Please Enter A Number:"
displayResult:		.asciiz "After QuickSort:"

array: .space 40 # Reserved storage of 40 bytes, to store 10 fractions (4 bytes each)
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
		
		sw 		$v0, 0($t0) 
		add 	$t0, $t0, 4
		
		addi 	$t2, $t2, -1			# counter for input loop
		addi 	$t1, $t1, 1 			# size of the array
		bgtz 	$t2, inputloop
		
end: 
		li 		$v0, 10 
		syscall		

# QuickSort $a0 = array[], $f0 = array[0] (1st number), $f0 = array[9] (Last number)

subi	$sp,$sp,16 	#move to start a new stack frame
sw	$ra,12($sp)	# save return address

lw      $ra,12($sp)	#restore $ra
addi    $sp,$sp,16	#pop stack
jr	$ra	  	#return to previous function


	
swap:	# swap $f20 = v1, $f21 = v2, $f22 = temp
		add.s	$f22,$f20,$zero		# $f22 = $f20
		add.s	$f20,$f21,$zero		# $f20 = $f21
		add.s	$f21,$f22,$zero		# $f21 = $f22
		
		jr	$ra	  	#return to previous function
		