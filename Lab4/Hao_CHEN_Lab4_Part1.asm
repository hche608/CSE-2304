#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 4
#Part1


		.data	# Data declaration section
strInMsg:		.asciiz "Please Enter a number:"
sum:			.asciiz "Sum of ten numbers: "
avg:			.asciiz "\nAverage: "
max:			.asciiz "\nMaximum: "
min:			.asciiz "\nMinimum: "
numOfN:			.asciiz "\nNumber of Negative numbers: "
numOfZ:			.asciiz "\nNumber of Zeros: "
numOfP:			.asciiz "\nNumber of Positive Numbers: "


.align 2 #Make sure that our input data is well aligned
		.text

# Start of code section 
	
main: 
#	read 10 numbers.
#	$f0 = current fp
#	$f1 = sum
#	$f2 = max
#	$f3 = min
#	$t1 = counter
#	$t3 = number of P
#	$t4 = number of N
#	$f5 = temp variable
#
		li 		$t3, 0 			#Initialize $t3 to zero
		li 		$t4, 0 			#Initialize $t4 to zero
		li 		$t1, 10			#Initialize $t1 to ten. This will be our counter
		li.s 	$f0, 0.0
		li.s 	$f1, 0.0
		li.s 	$f2, 0.0
		li.s 	$f3, 0.0
		li.s 	$f4, 0.0 # Zero
		
loop: 
		la 		$a0,strInMsg 
		li 		$v0, 4
		syscall

		li 		$v0, 6 
		syscall

#max	current > pervious ==> set new max
		c.lt.s	$f0, $f2
		bc1t skipMax
		mov.s	$f2, $f0
skipMax:		

#min	current < pervious ==> set new min	
		c.lt.s	$f3, $f0
		bc1t skipMin
		mov.s	$f3, $f0
skipMin:

#isZero		current == 0, Jump
		c.eq.s	$f0, $f4
		bc1t counterPlus

#isPositive		current > 0, $t3++
		c.lt.s	$f0, $f4
		bc1t skipPositive
		addi 	$t3, $t3, 1
		j counterPlus

skipPositive:		

#isNegative		current < 0, $t4++
		addi 	$t4, $t4, 1
		
#sum
counterPlus:		
		add.s	$f1, $f1, $f0
		sub 	$t1, $t1, 1 
		bgtz 	$t1, loop


#Print out		
#sum	$f1	
		la 		$a0, sum 
		li 		$v0, 4 
		syscall
		
		li 		$v0, 2
		mov.s 	$f12, $f1
		syscall
		
#avg	$f1/10	
		la 		$a0, avg 
		li 		$v0, 4 
		syscall
		
		li.s	$f5, 10.0		# $f5 = 10
		
		li 		$v0, 2
		div.s 	$f12, $f1, $f5
		syscall		
		
#maximum number $f2
		la 		$a0, max 
		li 		$v0, 4 
		syscall

		li 		$v0, 2
		mov.s 	$f12, $f2 
		syscall
		
#minimum number $f3
		la 		$a0, min 
		li 		$v0, 4 
		syscall

		li 		$v0, 2
		mov.s 	$f12, $f3 
		syscall

#number of positive $t3
		la 		$a0, numOfP 
		li 		$v0, 4 
		syscall

		li 		$v0, 1
		add 	$a0, $zero, $t3
		syscall

#number of negative $t4
		la 		$a0, numOfN 
		li 		$v0, 4 
		syscall

		li 		$v0, 1
		add 	$a0, $zero, $t4
		syscall
		
#number of zeros $t8 = 10 - $t3 - $t4
		la 		$a0, numOfZ 
		li 		$v0, 4 
		syscall

		li 		$v0, 1
		li		$t5, 10				# $t5 = 10
		sub		$t5, $t5, $t3		# $t5 = $t5 - $t3		
		sub		$t5, $t5, $t4 		# $t5 = $t5 - $t4
		
		add 	$a0, $zero, $t5
		syscall

#Done				
end: 
		li 		$v0, 10 
		syscall
		
# END OF PROGRAM