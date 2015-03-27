#CSE 2304 Lab Assignment 1
#Part1
# This is a simple Hello World Program.

.text 			# The text section of our program
main: 			# the main label should be the first label where our program instructions begin.
la $a0, str 	# put the address of the string to display in register $a0
li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
syscall 		# System call to output our string str.

# Now we need to exit our program
li $v0, 10 		# Move 10 to register $v0. This is the system service to exit the program.
syscall 		# exit (Pass control back to the operating system.)

# data section of our program.
.data 			# .data directive indicates the beginning of the data section of our program.
str: .asciiz "Hello World! \n"; 	# The '\n' indicates to move the cursor to a new line.