#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 3
#Part2
			.data 			# Data declaration section
str1: 				.asciiz "Please Enter an Integer for a: "
str2: 				.asciiz "Please Enter an Integer for b: "
str3: 				.asciiz "Output: "
			.text
main: 						# Start of code section
			li $v0, 4 		# system call code for printing string = 4
			la $a0, str1 	# load address of string to be printed into $a0
			syscall 		# call operating system to perform print operation
			
			li $v0, 5 		# read in integers
			syscall
			add $t0, $v0, $zero # save t0 = a;
			
			li $v0, 4
			la $a0, str2
			syscall
			li $v0, 5 		# read in integers
			syscall
			move $t1, $v0	# save t1 = b;
			
			addi $sp, $sp, -8
			sw $t0,	0($sp)	# save a in the stack
			sw $t1, 4($sp)	# save b in the stack
			
			mul $t1, $t0, $t1	# t1 = ab
			mul $t0, $t0, $t0	# t0 = a*a
			sub	$t0, $t0, $t1	# t0 = a*a - ab
			
			lw $t1, 0($sp)		# t1 = a
			sll $t1, $t1, 3		# a*8
			add $t0, $t0, $t1	
			
			lw $t1, 4($sp)		# t1 = b
			mul $t1, $t1, 10	# b*10
			sub $t0, $t0, $t1
			
			addi $t0, $t0, 19
			

			
			li $v0, 4
			la $a0, str3
			syscall 
			li $v0, 1 		# system call code for print_int
			move $a0, $t0
			syscall
			
			li $v0, 10	 	# exits program
			syscall
			

# END OF PROGRAM