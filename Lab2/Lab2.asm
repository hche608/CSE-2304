# Lab Assignment 2


		.data	# Data declaration section
strInMsg:		.asciiz "Please Enter An Integer:"
strOut:			.asciiz "The sum is: "
 

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

loopadd:
		sub $t0, $t0, 4 
		lw $t2, 0($t0)
		add $t3, $t3, $t2 
		
		add $t1, $t1, 1
		blt $t1, 10, loopadd
		
		la $a0, strOut 
		li $v0, 4 
		syscall
		
		li $v0, 1
		add $a0, $zero, $t3 
		syscall
		
end: 
		li $v0, 10 
		syscall
		
# END OF PROGRAM