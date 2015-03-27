# Reverse and output a user-supplied string
#
# Settings: Load delays OFF; Branch delays OFF,
#           Trap file    ON; Pseudoinstructions ON   
#
# $t0 --- character pushed or popped
# $t1 --- index into string buffer str
# $t2 --- the char will be tested


        .text
        .globl  main

main:   
		la 		$a0, prompt
		li 		$v0, 4
		syscall
	
		# input the string
        li      $v0,8           # service code
        la      $a0,str         # address of buffer
        li      $a1,80          # buffer length 
        syscall
        
        li      $t0,0           # push a null 
        subu    $sp,$sp,1       # onto the stack
        sb      $t0,($sp)       # to signal its bottom
        li      $t1,0           # index of first char in str buffer
        
        # push each character onto the stack
pushl:
		lbu     $t0,str($t1)    # get current char into
		                               # a full word
		beqz    $t0,stend       # null byte: end of string
        
		subu    $sp,$sp,1       # push the full word
		sb      $t0,($sp)       # holding the char
        
		addu    $t1,1           # inc the index
		j       pushl           # loop
        
		# pop chars from stack back into the buffer
stend:  
		
		li      $t1,0           # index of first byte of str buffer

popl:
        lb      $t0,($sp)       # pop a char off the stack
        addu    $sp,$sp,1
        beqz    $t0,equal       # null means empty stack
		
		li		$t2, 10			# $t3 = 10 newline
		
		beq		$t0, $t2, popl	# if $t0 == $t2 then popl
		
		add		$t2, $t1, $zero		# $t2 = $t1 + $0
		
		lbu     $t2,str($t1)    # get current char into $t2
				
		
		bne		$t0, $t2, notEqual	# if $t0 != $t2 then target
		
        addu    $t1,1           # inc the index
        j       popl            # loop

			
        # print the result
equal:   la 		$a0, isPal
		li 		$v0, 4
		syscall
        li      $v0,10          # exit
        syscall   


notEqual:      
		la 		$a0, notPal
		li 		$v0, 4
		syscall
	    li      $v0,10          # exit
	    syscall   
		
		
        .data
str:    			.space  80            # character buffer
prompt: 			.asciiz "Please give a string within 80 chars: "
notPal:				.asciiz "The string is not a palindrome."
isPal:				.asciiz "The string is a palindrome."