#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 1
#Part3

.text 			# The text section of our program
main: 			# the main label should be the first label where our program instructions begin.

la $a0, str1 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 5		# get an integer.
syscall
move $t0, $v0 	#move value to register to save for later use

la $a0, str2 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $v0, 5		# get an integer.
syscall
move $t1, $v0 #move value to register to save for later use
	
la $a0, str3 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 5		# get an integer.
syscall
move $t2, $v0 #move value to register to save for later use

#X + Y + Z

add $t3, $t0, $t1
add $t3, $t2, $t3

la $a0, str4 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 1 #Loads System service to print integer
move $a0, $t3 #Move value of $t0 into argument register $a0
syscall


#X - (Y + Z)

add $t3, $t1, $t2
sub $t3, $t0, $t3

la $a0, str5 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 1 #Loads System service to print integer
move $a0, $t3 #Move value of $t0 into argument register $a0
syscall


#X - Y x Z

mul $t3, $t1, $t2
sub $t3, $t0, $t3

la $a0, str6 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 1 #Loads System service to print integer
move $a0, $t3 #Move value of $t0 into argument register $a0
syscall


#X - Y / Z

div $t3, $t1, $t2
sub $t3, $t0, $t3

la $a0, str7 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 1 #Loads System service to print integer
move $a0, $t3 #Move value of $t0 into argument register $a0
syscall


#X^3 - Y^3

mul $t3, $t0, $t0
mul $t3, $t3, $t0
mul $t4, $t1, $t1
sub $t3, $t3, $t4

la $a0, str8 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

li $v0, 1 #Loads System service to print integer
move $a0, $t3 #Move value of $t0 into argument register $a0
syscall

# Now we need to exit our program
li $v0, 10 		# Move 10 to register $v0. This is the system service to exit the program.
syscall 		# exit (Pass control back to the operating system.)

# data section of our program.
.data 			# .data directive indicates the beginning of the data section of our program.
	str1: .asciiz "Enter X: "; # First string.
	str2: .asciiz "Enter Y: "; # Second string.
	str3: .asciiz "Enter Z: "; # Third string.
	str4: .asciiz "X + Y + Z = ";
	str5: .asciiz "\nX - (Y + Z) = ";
	str6: .asciiz "\nX - Y x Z = ";								
	str7: .asciiz "\nX - Y / Z = ";
	str8: .asciiz "\nX^3 - Y^2 = ";				