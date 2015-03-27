    .data
newline:	.asciiz "\n"
value:		.asciiz "Testing value: "		
    .text
    .globl main

main:
# Task $v0 = $a0 + $a1, registers $t0-$t9 free to use

#	Explain your registers here
#	$t0 = sign of $a0 or $t0 = $a0
#	$t1 = exponent of $a0
#	$t2 = fraction of $a0
#	$t3 = sign of $a1 or $t3 = $a1
#	$t4 = exponent of $a1
#	$t5 = fraction of $a1
#	$t6 = temp
#	$t7 = temp
#	$t8 = temp
#	$t9 = temp
#	$v0 = return value
#	test value #
#	0x3F800000
#	0x40000000
#	0x40200000
#	0x402AAAAA
#	0x402D5554
#	0x402DDDDC
#	0x402DF49D
#	0x402DF7DD
#	0x402DF834
#	0x402DF850
#	0x402DF851
#
#	0x3FFFFFFF
#	0x3F800001
#
#
#
	
	li		$a0, 0x3FFFFFFF		# target 0x402DF851
	add		$v0, $a0, $zero		# $v0 = $t1 + $t2	
	jal print_bit
	
	li		$a1, 0x3F800001		# target 0x402DF851
	add		$v0, $a1, $zero		# $v0 = $t1 + $t2	
	jal print_bit

	li		$a0, 0x3F800000		# target 0x402DF851
	li		$a1, 0x40000000		# target 0x402DF851
#extract sign of $a0 ==> $t0
	li		$t6, 0x80000000				# $t6 = smask
	and		$t0, $a0, $t6
#extract exponent of $a0 ==> $t1
	li		$t6, 0x7F800000				# $t7 = emask
	and		$t1, $a0, $t6
#extract fraction of $a0 ==> $t2
	li		$t6, 0x007FFFFF				# $t8 = fmask
	and		$t2, $a0, $t6

##################################
#extract sign of $a1 ==> $t3
	li		$t6, 0x80000000				# $t6 = smask
	and		$t3, $a1, $t6
#extract exponent of $a0 ==> $t4
	li		$t6, 0x7F800000				# $t7 = emask
	and		$t4, $a1, $t6
#extract fraction of $a0 ==> $t5
	li		$t6, 0x007FFFFF				# $t8 = fmask
	and		$t5, $a1, $t6

##################################
# Calculation
##################################

# Compare sign
# (+ + +) or (- + -)
	beq		$t0, $t3, Cexponent	# if $t0 == $t3 then Cexponent
	j		signNotEq				# jump to signNotEq


# Compare exponent
Cexponent:
	srl		$t1, $t1, 23
	srl		$t4, $t4, 23		
	
	beq		$t1, $t4, addFraction	# if $t1 == $t4 then addFraction
	
	blt		$t1, $t4, a1isBig	# if $t1 < $t4 then a0isBig
	
	#newline    
		la 		$a0, value
		li 		$v0, 4
		syscall
		
	#newline    
		move 		$a0, $t1
		li 		$v0, 1
		syscall
	
	#newline    
		la 		$a0, newline
		li 		$v0, 4
		syscall	

		#newline    
			la 		$a0, value
			li 		$v0, 4
			syscall
		
		#newline    
			move 		$a0, $t4
			li 		$v0, 1
			syscall
	
		#newline    
			la 		$a0, newline
			li 		$v0, 4
			syscall	
						
	
		
# Shift a1
a0isBig:
	sub		$t6, $t4, $t1		# $t6 = $t4 - $t1
		
	li		$t7, 0x00800000		# $t7 = 0x00800000
	or		$t5, $t5, $t7
	
	srlv	$t5, $t5, $t6
	j		completedShift				# jump to completedShift

# Shift a0
a1isBig:	
	sub		$t6, $t1, $t4		# $t6 = $t4 - $t1
	li		$t7, 0x00800000		# $t7 = 0x00800000
	or		$t2, $t2, $t7
		
	srlv	$t2, $t2, $t6	
	move 	$t1, $t4			# $t1 = $t4 use bigger exponent
	
completedShift:			
	
# add fraction a + b or  -a + -b
addFraction:
	add		$t2, $t2, $t5		# $t2 = $t2 + $t5
#overflow check
	li		$t6, 0x00800000				# $t6 = smask	
	bge		$t2, $t6, overflow	# if $t2 >= $t6 then overflow
	j		noOverflow				# jump to noOverflow	
overflow:
	srl		$t2, $t2, 1
	addi	$t1, $t1, 1			# $t1 = $t1 + 1
	
noOverflow:
	j		combine				# jump to combine


#################################################
# (+ + -) or (- + +)
signNotEq:
compExponent:
	srl		$t1, $t1, 23
	srl		$t4, $t4, 23
	
	beq		$t1, $t4, sameExponent	# if $t1 == $t4 then sameExponent	

	blt		$t0, $t1, a0isSmall	# if $t0 < $t1 then a0isBig (|a0| > |a1|)
	
	sub		$t6, $t1, $t4		# $t6 = $t1 - $t4
	srlv	$t2, $t2, $t6
	
	j		sameExponent				# jump to sameExponent
	
a0isSmall:
	sub		$t6, $t4, $t1		# $t6 = $t4 - $t1
	srlv	$t5, $t5, $t6
	
	j		sameExponent				# jump to completedShift



sameExponent:
	bgt		$t0, $t1, FractionOfa0isBiger	# if |$t0| > |$t1| then FractionOfa0isBiger
	j		a1sign				# jump to a1sign

a1sign:	
	move 	$t0, $t4			# $t0 = $t4
	j		subFraction			# jump to subFraction
	
a0sign:
	# $t0 = $t0

subFraction:
	bgt		$t2, $t5, FractionOfa0isBiger	# if $t2 > $t5 then FractionOfa0isBiger
	
	sub		$t2, $t5, $t2		# $t2 = $t5 - $t2 ( $a1 - $a0)
	j		combine				# jump to combine
	
FractionOfa0isBiger:	
	sub		$t2, $t2, $t5		# $t2 = $t2 - $t5 ( $a0 - $a1)


#########################################################
# combine S + E + F
combine:
	sll		$t1, $t1, 23
	add		$t9, $t9, $zero		# $t9 = $zero	
	or		$t9, $t9, $t0		# combine sign
	or		$t9, $t9, $t1		# combine exponent
	or		$t9, $t9, $t2		# combine fraction
### print sum	
	move	$v0, $t9 
	jal print_bit	
	
j end




print_bit:

#Enter your code here

# mask	
	li		$t6, 0x80000000 			# $t0 = 32
	li		$t7, 0 		
	li		$t8, 0 
# save the target value	into $t1   	
	move 	$t7, $v0		# $t7 = $v0

printLoop:	           

	and		$t8, $t7, $t6
# AND == 0	
	li 		$a0, 0
# AND == 1
	beq		$t6, $t8, PrintOne	# if $t6 == $t8 then PrintOne	
	j		Print				# jump to Print

PrintOne:		
	li 		$a0, 1

Print:	
    li 		$v0, 1
    syscall	
		
	srl		$t6, $t6, 1		
	bnez	$t6, printLoop

#newline    
	la 		$a0, newline
	li 		$v0, 4
	syscall	

	jr 		$ra
			
end:	
	li $v0, 10
    syscall