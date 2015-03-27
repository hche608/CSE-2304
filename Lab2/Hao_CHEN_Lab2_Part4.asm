#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 2
#Part4


		.data	# Data declaration section
strInMsg:		.asciiz "Please Enter An Integer:"
sum:			.asciiz "Sum of ten numbers: "
max:			.asciiz "\nMaximum: "
min:			.asciiz "\nMinimum: "
numOfN:			.asciiz "\nNumber of Negative numbers: "
numOfZ:			.asciiz "\nNumber of Zeros: "
numOfP:			.asciiz "\nNumber of Positive Numbers: "


.align 2 #Make sure that our input data is well aligned
memAddr: .space 40 #Reserved storage of 40 bytes, to store 10 integers (4 bytes each)

		.text
		
main: # Start of code section 
		la $t0, memAddr
		add $t3, $zero, $zero 		#Initialize $t3 to zero
		addi $t1, $zero, 10			#Initialize $t1 to ten. This will be our counter

#read Integers.
loop: 
		la $a0,strInMsg 
		add $v0, $zero, 4
		syscall

		add $v0, $zero, 5 
		syscall
		
		sw $v0, 0($t0) 
		add $t0, $t0, 4
		
		sub $t1, $t1, 1 
		bgtz $t1, loop

loopadd:				# t0 is pointer, t1 is current value, t2 is counter, t3 is sum
		sub $t0, $t0, 4 
		lw $t2, 0($t0)
		add $t3, $t3, $t2 
		
		add $t1, $t1, 1
		
		jal checkMaxValue
		jal checkMinValue

		bgtz	$t2, greatZero
		bltz 	$t2, lessZero
		j increment
greatZero:
		addi	$t7, $t7, 1
		j increment
		
lessZero:
		addi	$t6, $t6, 1
		j increment

increment:		
		blt $t1, 10, loopadd
		
#sum		
		la $a0, sum 
		li $v0, 4 
		syscall
		
		li $v0, 1
		add $a0, $zero, $t3 
		syscall
		
#maximum number $t4
		la $a0, max 
		li $v0, 4 
		syscall

		li $v0, 1
		add $a0, $zero, $t4 
		syscall
		
#minimum number $t5
		la $a0, min 
		li $v0, 4 
		syscall

		li $v0, 1
		add $a0, $zero, $t5 
		syscall

#number of negative $t6
		la $a0, numOfN 
		li $v0, 4 
		syscall

		li $v0, 1
		add $a0, $zero, $t6
		syscall
		
#number of zeros $t8 = 10 - $t6 - $t7
		la $a0, numOfZ 
		li $v0, 4 
		syscall

		li $v0, 1
		addi	$t8, $t8, 10			# $t0 = $t0 + 0
		sub		$t8, $t8, $t6		# $t0 = $t6 + $t7		
		sub		$t8, $t8, $t7 		# $t0 = 10 - $t0
		
		add $a0, $zero, $t8
		syscall
		
#number of positive $t7
		la $a0, numOfP 
		li $v0, 4 
		syscall

		li $v0, 1
		add $a0, $zero, $t7
		syscall

#Done the job		
		j end
		
checkMaxValue:
		bgt $t2, $t4, setMaxValue	
		jr $ra
		
	setMaxValue:		
		addi $t4, $t4, 0	
		addi $t4, $t2, 0

		j checkMaxValue

checkMinValue:	
		bgt $t5, $t2, setMinValue	
		jr $ra
		
	setMinValue:		
		addi $t5, $t5, 0	
		addi $t5, $t2, 0

		j checkMinValue

		
end: 
		li $v0, 10 
		syscall
		
# END OF PROGRAM