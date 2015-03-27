#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 2
#Part3


.text 			# The text section of our program
main: 			# the main label should be the first label where our program instructions begin.
# Read an integer
la $a0, str1 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 5		# get an integer.
syscall
move $t0, $v0 	#move value to register to save for later use

# Read the char
la $a0, str2 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 12		# get an char.
syscall
move $t1, $v0 	#move value to register to save for later use


#print out the integer
la $a0, newline 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 1 		#Loads System service to print integer
addi $a0, $t0, 0 	#Move value of $t0 into argument register $a0
syscall



add $t3, $zero, $zero 		#Initialize $t3 to zero
li $t3, 67	#67 = C
beq	$t1, $t3, ctof
add $t3, $zero, $zero 		#Initialize $t3 to zero
li $t3, 70	#70 = F
beq	$t1, $t3, ftoc


ctof:
# C to F
mul $t1, $t0, 9
div $t1, $t1, 5
addi $t1, $t1, 32

#print out F
la $a0, str3 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 1 		#Loads System service to print integer
move $a0, $t1 	#Move value of $t0 into argument register $a0
syscall

la $a0, str4 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

j done

ftoc:
# F to C
add $t1, $t0, -32
mul $t1, $t1, 5
div $t1, $t1, 9

#print out F
la $a0, str5 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 1 		#Loads System service to print integer
move $a0, $t1 	#Move value of $t0 into argument register $a0
syscall

la $a0, str6 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.
j done


done:
# Now we need to exit our program
li $v0, 10 		# Move 10 to register $v0. This is the system service to exit the program.
syscall 		# exit (Pass control back to the operating system.)

# data section of our program.
.data 			# .data directive indicates the beginning of the data section of our program.
	str1: .asciiz "Enter a number to convert: "; # First string.
	str2: .asciiz "Enter the Temperature: "; # Second string.
	str3: .asciiz " C is the same as "; # Third string.
	str4: .asciiz " F\n"; 
	str5: .asciiz " F is the same as ";
	str6: .asciiz " C\n"; 
	newline: .asciiz "\n"