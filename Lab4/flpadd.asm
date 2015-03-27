

# The numbers below are loaded into memory (the Data Segment)
# before your program runs.  You can use a lw instruction to
# load these numbers into a register for use by your code.

        .data
newline:.asciiz "\n"
value:	.asciiz "ACSII VALUE: "		
atest:  .word 0x40000000 # you can change this to anything you want
btest:  .word 0x40000000 # you can change this to anything you want
smask:  .word 0x007FFFFF
emask:  .word 0x7F800000
ibit:   .word 0x00800000
obit:   .word 0x01000000
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
        
main:   li 		$s0,1            # load constant 1
        mtc1 	$s0,$f0          # copy 1 into $f0
        cvt.s.w $f0,$f0          # convert 1 to float
        mtc1 	$0,$f1           # zero out result accumulator
        li 		$s1,0            # initialize loop index
tloop:  addi 	$s2,$s1,-11      # Have we summed the first 11 terms?
        beq 	$s2,$0,end       # If so, terminate loop
        bnez 	$s1,fact         # If this is not the first time, skip init
        mov.s 	$f3,$f0          # Initialize 0! = 1
        j dfact                  # bypass fact
fact:   mtc1 	$s1,$f4          # copy i into $f4
        cvt.s.w $f4,$f4			 # convert i to float
        mul.s 	$f3,$f3,$f4      # update running fact
dfact:  div.s 	$f2,$f0,$f3      # compute 1/i!
        #add.s	$f1,$f1,$f2      # we use your flpadd function instead!
        mfc1 	$a0,$f1          #\  These lines should do the same thing
        mfc1 	$a1,$f2          # \ as the commented out line above.
        jal flpadd               # / This is where we call your function.
        mtc1 	$v0,$f1          #/
        addi 	$s1,$s1,1        # increment i
	
		add 	$a0, $zero, $v0	 # Print the bits from the returned value $v0
		jal print_bit			 #
	
        j tloop                  #
		j end                    #

end:    
		li $v0, 10
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

#Enter your code here

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
	
	blt		$t1, $t4, a0isBig	# if $t1 < $t4 then a0isBig
	
# Shift a0
a1isBig:	
	sub		$t6, $t1, $t4		# $t6 = $t4 - $t1
	li		$t7, 0x00800000		# $t7 = 0x00800000
	or		$t2, $t2, $t7
		
	srlv	$t2, $t2, $t6			
				
	j		completedShift				# jump to completedShift
		
# Shift a1
a0isBig:
	sub		$t6, $t4, $t1		# $t6 = $t4 - $t1
		
	li		$t7, 0x00800000		# $t7 = 0x00800000
	or		$t5, $t5, $t7
	
	srlv	$t5, $t5, $t6
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
		
	jr 		$ra


#implement print_bit procedure
print_bit:

#Enter your code here

# mask	
	li		$t6, 0x80000000 			# $t0 = 32
	li		$t7, 0 		
	li		$t8, 0 
# save the target value	into $t1   	
	move 	$t7, $v0		# $t7 = $v0

	la 		$a0, value
	li 		$v0, 4
	syscall	

	move 	$a0, $t7
    li 		$v0, 1
    syscall	

#newline    
	la 		$a0, newline
	li 		$v0, 4
	syscall	

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
