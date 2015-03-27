    .data
	prompt: .asciiz "Enter a number to convert: ";
	char: .space 2
	array: .space 17
	str2: .asciiz "Length is : ";
	
	error: .asciiz "\nerror!";
	null: .asciiz ""
	space: .ascii " "
	newline: .asciiz "\n";

theString:
    .space 64

    .text
main:
	la $a0, prompt 	# put the address of the string to display in register $a0
	li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
	syscall 		# System call to output our string str.
	j		readInt				# jump to readInt
	
gets:
	la		$s1, array		# 
loop:		
	jal getc
	lb		$t0, char		# 
	sb		$t0, 0($s1)		# 
	lb		$t1, newline		# 
	beq		$t0, $t1, done	# if $t0 == $t1 then target
	addi	$s1, $s1, 1			# $s1 = $t1 + 0
	j		loop				# jump to loop
	
getc:
	li		$v0, 8		# $v0 = 
	la		$a0, char		# 
	li		$a1, 2		# $a1 = 
	syscall	
	jr      $ra
	
	
	
readInt:
	j		gets				# jump to gets
done:

	
	#move $t0, $a0
	move $t1, $a1
	
	la $a0, str2	# put the address of the string to display in register $a0
	li $v0, 4 		# Move 4 to register $v0. This is the system service to display string messages
	syscall 		# System call to output our string str.
	
	li $v0, 1 		#Loads System service to print integer
	move $a0, $t1 	#Move value of $t0 into argument register $a0
	syscall
	
	
	
	
	
	# Now we need to exit our program
	li $v0, 10 		# Move 10 to register $v0. This is the system service to exit the program.
	syscall 		# exit (Pass control back to the operating system.)