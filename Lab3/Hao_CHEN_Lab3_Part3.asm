#Name: Hao CHEN,  
#Class: CSE 2304
#Section Number: 001L 
#CSE 2304 Lab Assignment 3
#Part3
# $t0 --- character pushed or popped
# $t1 --- index into string buffer str
# $t2 --- max element in the stack
# $t4 --- address of stack


        .text
        .globl  main

main:   
input:
		la 		$a0, prompt
		li 		$v0, 4
		syscall

		li $v0, 5 		# read in integers
		syscall
		add $t2, $v0, $zero # save t0 = a;		
		bltz	$t2, input		# if the input integer is < 0, then goto input:
				
		jal		initialStack	# jump to initial and save position to $ra
		
		la 		$a0, str1
		li 		$v0, 4
		syscall
		
        li      $t1,0           # index of first char in str buffer				
					
        # push 20 integes onto the stack
pushl:
		
		beq		$t1, $t2, stend	# if $t1 == $t2 then stend
				
		addi	$t3, $t1, 1		# $t3 = $t1 + 1

		add		$a0, $t3, $0	# $t0 = $t1 + $t2
		li		$v0,1	 		# $v0 = 0
		syscall
		
		la 		$a0, space
		li 		$v0, 4
		syscall
	
		subu    $sp,$sp,4       # push the full word
		sw      $t3,($sp)       # holding the char
        
		addu    $t1,1           # inc the index

		j       pushl           # loop
        
		# pop chars from stack back into the buffer
stend:  
		
		li      $t1,0           # index of first byte of str buffer
		
		la 		$a0, newline
		li 		$v0, 4
		syscall
		
		la 		$a0, str2
		li 		$v0, 4
		syscall
		
		# check if it is empty
		lw      $t0,($sp)       # pop a char off the stack
		beq		$t0, $t4, isEmpty	# if $t0 == $t1 then isEmpty

popl:
        		
		lw      $t0,($sp)       # pop a char off the stack
        addu    $sp,$sp,4
		
		beq     $t0, $t4, done       # null means empty stack
		
		add		$a0, $t0, $0	# $t0 = $t1 + $t2
		li		$v0,1	 		# $v0 = 0
		syscall
		
		la 		$a0, space
		li 		$v0, 4
		syscall
				
        j       popl            # loop
			
        # print the result
isEmpty:  
		la 		$a0, isEmt
		li 		$v0, 4
		syscall
		
		la 		$a0, newline
		li 		$v0, 4
		syscall
		
		li 	    $a0,1
		li		$v0,1	 		# $v0 = 0
		syscall
		
        li      $v0,10          # exit
        syscall   

done:  
		la 		$a0, notEmt
		li 		$v0, 4
		syscall
		
		la 		$a0, newline
		li 		$v0, 4
		syscall
		
		li 	    $a0,0
		li		$v0,1	 		# $v0 = 0
		syscall
		
		li      $v0,10          # exit
		syscall

		# initial Stack
initialStack:
    	add     $t4,$sp,$zero   # push a null 
    	subu    $sp,$sp,4       # onto the stack
    	sw      $t4,($sp)       # to signal its bottom
		jr		$ra				# jump to $ra
		
		
        .data
str:    			.space  80            # character buffer
prompt: 			.asciiz "Give an interger which is >= 0: "
str1: 				.asciiz "Push to the Stack: "
str2: 				.asciiz "Pop from the Stack: "
space: 				.asciiz " "
newline: 			.asciiz "\n"
isEmt:				.asciiz "The Stack is empty."
notEmt:				.asciiz "\nThe Stack is not empty."