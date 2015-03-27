#CSE 2304 Lab Assignment 1
#Part 2

.text
main: 			# the main label.

la $a0, str1 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

li $t0, 4 		# Move 4 to $t0;
addi $t1, $t0, 5 # Perform operation $t1 = $t0 + 5 -> $t1 = 4 + 5
move $a0, $t1 	# put the the number to be displayed in register $a0
li $v0, 1 		# Move 1 to register $v0. This is the system service to display integers.
syscall 		# System call to output our string str.

la $a0, str2 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

addi $t1, $t0, -5 # Perform operation $t1 = $t0 - 5 -> $t1 = 4 - 5
move $a0, $t1 	# put the the number to be displayed in register $a0
li $v0, 1 		# Move 1 to register $v0. This is the system service to display integers.
syscall 		# System call to output our string str.

la $a0, str3 	# put the address of the string to display in register $a0
li $v0, 4
syscall 		# System call to output our string str.

# Now we need to exit our program
li $v0, 10 		# Move 10 to register $v0. This is the system service to exit the program.
syscall 		# exit (Pass control back to the operating system.)

# data section of our program.
.data 			# .data directive indicates the beginning of the data section of our program.
str1: .asciiz "The last time I checked 4 + 5 was: "; # First string
str2: .asciiz ", and 4 - 5 was: "; # Second string
str3: .asciiz ". Is this still true? \n"; # Third string