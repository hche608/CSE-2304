

# The numbers below are loaded into memory (the Data Segment)
# before your program runs.  You can use a lw instruction to
# load these numbers into a register for use by your code.

        .data
newline:	.asciiz "\n"
str:		.asciiz "Testing value: "
space:		.asciiz " "
A:			.asciiz "A"
B:			.asciiz "B"
C:			.asciiz "C"
D:			.asciiz "D"
E:			.asciiz "E"
F:			.asciiz "F"
PreStr:		.asciiz "\n0x"
atest:  	.word 0x40000000 # you can change this to anything you want
btest:  	.word 0x40000000 # you can change this to anything you want
smask:  	.word 0x007FFFFF
emask:  	.word 0x7F800000
ibit:   	.word 0x00800000
obit:   	.word 0x01000000
        .text

# The main program computes e using the infinite series, and
# calls your flpadd function (below).
#
# PLEASE DO NOT CHANGE THIS PART OF THE CODE
#
# The code uses the registers as follows:
#    $s0 - 1 (constant integer)
#    $s1 - i (loop index variable)
#    $s2 - temp
#    $f0 - 1 (constant single precision float)
#    $f1 - e (result accumulator)
#    $f2 - 1/i!
#    $f3 - i!
#    $f4 - temp
        
main:	
	li $s0,1		# load constant 1
	mtc1 $s0,$f0		# copy 1 into $f0
	cvt.s.w $f0,$f0		# convert 1 to float
	mtc1 $0,$f1		# zero out result accumulator
	li $s1,0		# initialize loop index
tloop:	
	addi $s2,$s1,-11	# Have we summed the first 11 terms?
	beq $s2,$0,end		# If so, terminate loop
	bnez $s1,fact		# If this is not the first time, skip init
	mov.s $f3,$f0		# Initialize 0! = 1
	j dfact			# bypass fact
fact:	
	mtc1 $s1,$f4		# copy i into $f4
	cvt.s.w $f4,$f4		# convert i to float
	mul.s $f3,$f3,$f4	# update running fact
dfact:	
	div.s $f2,$f0,$f3	# compute 1/i!
	#add.s $f1,$f1,$f2	# we use your flpadd function instead!
	mfc1 $a0,$f1		#\  These lines should do the same thing
	mfc1 $a1,$f2		# \ as the commented out line above.
	jal flpadd		# / This is where we call your function.
	mtc1 $v0,$f1		#/
	addi $s1,$s1,1		# increment i
	add $a0, $zero, $v0	# Print the bits from the returned value $v0
	jal print_bit		# Call print_bit

	j tloop			# Continue calculating e
end:	
	li $v0, 10		# End the program
	syscall


# If you have trouble getting the right values from the program
# above, you can comment it out and do some simpler tests using
# the following program instead.  It allows you to add two numbers
# (specified as atest and btest, above), leaving the result in $v0.

#main:   lw $a0,atest
#        lw $a1,btest
#        jal flpadd
#end:    j end



# Here is the function that performs floating point addition of
# single-precision numbers.  It accepts its arguments from
# registers $a0 and $a1, and leaves the sum in register $v0
# before returning.
#
# Make sure not to use any of the registers $s0-$s7, or any
# floating point registers, because these registers are used
# by the main program.  All of the registers $t0-$t9, however,
# are okay to use.
#
# YOU SHOULD NOT USE ANY OF THE MIPS BUILT-IN FLOATING POINT
# INSTRUCTIONS.  Also, don't forget to add comments to each line
# of code that you write.
#
# Remember the single precision format:
#          bit 31 = sign (1 bit)
#      bits 30-23 = exponent (8 bits)
#       bits 22-0 = significand (23 bits)
#
#
#
#	Explain your registers here
#	$t0 = sign of $a0
#	$t1 = exponent of $a0
#	$t2 = fraction of $a0
#	$t3 = sign of $a1
#	$t4 = exponent of $a1
#	$t5 = fraction of $a1
#	$t6 = temp
#	$t7 = temp
#	$t8 = temp
#	$t9 = temp
#	$v0 = return value


# Task $v0 = $a0 + $a1, registers $t0-$t9 free to use

#Implement flpadd procedure
flpadd:
#####################################################################
#extract sign of $a0 ==> $t0 and $a1 ==> $t1
	li		$t6, 0x80000000				# $t6 = smask
	and		$t0, $a0, $t6				
	and		$t1, $a1, $t6
#extract exponent of $a0 ==> $t2 and $a1 ==> $t3
	li		$t6, 0x7F800000				# $t6 = emask
	and		$t2, $a0, $t6
	and		$t3, $a1, $t6
#extract fraction of $a0 ==> $t4 and $a0 ==> $t5
	li		$t6, 0x007FFFFF				# $t6 = fmask
	and		$t4, $a0, $t6
	and		$t5, $a1, $t6
	li		$t6, 0x00800000	# add leading bit 1
	or		$t4, $t4, $t6
	or		$t5, $t5, $t6	
#####################################################################
# Calculation
#####################################################################
# Compare sign bit
# (+ + +) or (- + -)
	bne		$t0, $t1, signNotEq	# if $t0 != $t1 then signNotEq
								# if $t0 == $t1 then add two fractions
#####################################################################
# Compare exponents
	srl		$t2, $t2, 23
	srl		$t3, $t3, 23		
#	If e0 == e1
	beq		$t2, $t3, completedShift	# if $t2 == $t3 then completedShift
	bgt		$t2, $t3, a0isBig			# if $t2 > $t3 then a0isBig

# a1 is bigger, Shift a0  
a1isBig:	
	sub		$t2, $t3, $t2		# $t2 = $t3 - $t2
	srlv	$t4, $t4, $t2		# Shift fraction of a0 as amount of $t2
	add 	$t2, $t3, $zero		# $t2 = $t3	Use a1's exponent
	j		completedShift				# jump to afterShift
# a0 is bigger, Shift a1
a0isBig:
	sub		$t3, $t2, $t3		# $t3 = $t2 - $t3
	#shift fraction
	srlv	$t5, $t5, $t3	#Shift fraction of a0 as amount of $t3

completedShift:			
#####################################################################
# add fraction a + b or  -a + -b
	add		$t4, $t4, $t5		# $t4 = $t4 + $t5
	
#overflow check
	srl		$t6, $t4, 24		# check the leading bit == or != 1	
	bnez	$t6, overflow		# if $t6 != 0 then overflow
	j		noOverflow			# jump to noOverflow	
overflow:	
	srl		$t4, $t4, 1
	addi	$t2, $t2, 1			# $t2 = $t2 + 1 exponent
noOverflow:
	j		combine				# jump to combine
#####################################################################
# (+ + -) or (- + +)
signNotEq:
#####################################################################
# Compare exponents
	srl		$t2, $t2, 23
	srl		$t3, $t3, 23		

	sll		$t4, $t4, 7
	sll		$t5, $t5, 7
#####################################################################
#	If e0 == e1	
	beq		$t2, $t3, completedShiftSub	# if $t2 == $t3 then completedShift
	bgt		$t2, $t3, a0isBigSub			# if $t2 > $t3 then a0isBig

# a1 is bigger, Shift a0  
a1isBigSub:	
	sub		$t2, $t3, $t2		# $t2 = $t3 - $t2
	srlv	$t4, $t4, $t2		# Shift fraction of a0 as amount of $t2
	add 	$t2, $t3, $zero		# $t2 = $t3	Use a1's exponent
	j		completedShiftSub				# jump to afterShift
# a0 is bigger, Shift a1
a0isBigSub:
	sub		$t3, $t2, $t3		# $t3 = $t2 - $t3
	#shift fraction
	srlv	$t5, $t5, $t3	#Shift fraction of a0 as amount of $t3
completedShiftSub:		
#####################################################################	
#Compare Fraction
		# Call print_bit
	bge		$t4, $t5, a0gea1	# if $t4 >= $t5 then a0gea1(a1 > a0)
# a0 < a1
	sub		$t4, $t5, $t4		# $t4 = $t5 - $t4
			
# set sign as the sign of a1
	move	$t0, $t1			# $t0 = $t1
	j		underflowCheck		# jump to underflowCheck

a0gea1:	
	sub		$t4, $t4, $t5		# $t4 = $t4 - $t5
	
	
#underflow check
underflowCheck:
	li		$t7, 31					# $t7 = 31	
underflowloop:
	srlv	$t6, $t4, $t7
		
	bnez	$t6, findNewExponent		# if $t6 != 0 then overflow ==> 
	addi	$t7, $t7, -1			# $t7 = $t1 + 0
	bnez	$t7, underflowloop
findNewExponent:	
	addi	$t6, $zero, 23			# $t6 = $t1 + 0
	sub		$t6, $t7, $t6		# $t0 = $t1 - $t2
		
	bgez	$t6, shiftRight
	j		shiftLeft				# jump to shiftLeft
		
shiftRight:
	srlv	$t4, $t4, $t6
	addi	$t7, $zero, 8			# $t6 = $t1 + 0
	sub		$t6, $t7, $t6		# $t6 = $t1 - $t2	
	sub		$t2, $t2, $t6		# $t2 = $t1 + $t2	
	j		combine				# jump to combine
		
shiftLeft:
	sllv	$t4, $t4, $t6	
	addi	$t7, $zero, 9			# $t6 = $t1 + 0
	sub		$t6, $t7, $t6		# $t0 = $t1 - $t2						
	sub		$t2, $t2, $t6		# $t2 = $t1 + $t2	

#####################################################################
# combine (S or E or F)
combine:
	sll		$t2, $t2, 23	
	li		$t6, 0x007FFFFF		#
	bnez	$t4, notZero
	li		$t2, 0x7F800000		# Zero
notZero:	 
	and		$t4, $t4, $t6		# Remove the leading bit 1.		
	add		$v0, $zero, $zero	# $v0 = 0
		
	or		$v0, $v0, $t0		# combine sign
	or		$v0, $v0, $t2		# combine exponent
	or		$v0, $v0, $t4		# combine fraction
	jr 		$ra	

#implement print_bit procedure
#####################################################################
# Debug print out
# print every bit in $v0,
# $t6 = testing value
# $t7 = target value
# $t8 = result and print value
#
#####################################################################

print_bit:
# initial	
	li		$t6, 0x80000000 			# $t6 = 1000 0000 0000 0000 0000 0000 0000 0000
# save the target value	into $t7   	
	move 	$t7, $a0		# $t7 = $v0

printLoop:	           
	and		$t8, $t6, $t7
# AND is false ==> 0	
	li 		$a0, 0
# AND is true ==> 1
	beq		$t8, $t6, PrintOne	# if $t6 == $t8 then PrintOne	
	j		Print				# jump to Print

PrintOne:		
	li 		$a0, 1

Print:	
    li 		$v0, 1
    syscall	
#####################################################################
# format oupput	
	li		$v0, 0x80000000		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00800000		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00100000		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00010000		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00001000		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00000100		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space
	li		$v0, 0x00000010		# $t8 = 	
	beq		$t6, $v0, print_space	# if $t6 != $t8 then print_space	
	j		no_space				# jump to no_space
	
print_space:	
	la 		$a0, space
	li 		$v0, 4
	syscall

no_space:	
				
	# check if it is the last bit	
	srl		$t6, $t6, 1		
	bnez	$t6, printLoop
#####################################################################
	 
#newline    
	la 		$a0, PreStr
	li 		$v0, 4
	syscall
	
	li		$t6, 0xF0000000 		# $t6 = 
	li		$t9, 28		# $t9 = 
	
hexloop:
	and		$t8, $t7, $t6	# read 4 bits each time
	srlv	$t8, $t8, $t9

	li		$a1, 10		# $t0 = 
	beq		$a1, $t8, HexA	# if $t0 == $t1 then target
	li		$a1, 11		# $t0 = 
	beq		$a1, $t8, HexB	# if $t0 == $t1 then target
	li		$a1, 12		# $t0 = 
	beq		$a1, $t8, HexC	# if $t0 == $t1 then target
	li		$a1, 13		# $t0 = 
	beq		$a1, $t8, HexD	# if $t0 == $t1 then target
	li		$a1, 14		# $t0 = 
	beq		$a1, $t8, HexE	# if $t0 == $t1 then target
	li		$a1, 15		# $t0 = 
	beq		$a1, $t8, HexF	# if $t0 == $t1 then target					
one2nine:		
	move 	$a0, $t8
    li 		$v0, 1
    syscall	
	j		Done
HexA:
	la 		$a0, A
    li 		$v0, 4
    syscall
	j		Done				# jump to Done
HexB:	
	la 		$a0, B
    li 		$v0, 4
    syscall
	j		Done				# jump to Done
HexC:
	la 		$a0, C
    li 		$v0, 4
    syscall
	j		Done				# jump to Done
HexD:	
	la 		$a0, D
    li 		$v0, 4
    syscall
	j		Done				# jump to Done
HexE:	
	la 		$a0, E
    li 		$v0, 4
    syscall
	j		Done				# jump to Done
HexF:	
	la 		$a0, F
    li 		$v0, 4
    syscall
	j		Done				# jump to Done		
Done:						
	srl		$t6, $t6, 4	
	addi	$t9, $t9, -4			# $t9 = $t1 + 0		
	bnez	$t6, hexloop			
#newline    
	la 		$a0, newline
	li 		$v0, 4
	syscall			
	jr 		$ra
#####################################################################