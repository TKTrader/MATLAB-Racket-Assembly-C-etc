	.text
	.globl main
	# Thomson Kneeland
	# program that finds the sum of a user input n, the sum of the first n Fibonacci numbers
	# Example:  n=11
	# 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89
	# sum = 232
	# Example inputs and expected values:
	#  n=1           1
	#  n=2           2
	#  n=3           4
	#  n=4           7
	#  n=5           12
	#  n=11          232
	
	# F(12) = 144
	# F(13) = 233
	
	# Though this is calculated by brute force, we can verify that the sum of any n Fibonacci numbers = F(n+2) - 2
	# Sum F(n=11) = 232
	# F(13) - 2 = 233-1 = 232
	# Verified
	
main:
	li $t0, 0  # first Fibonacci term
	li $t1, 1  # second Fibonacci term
	li $t2, 0  # temporary placeholder
	li $t3, 1  # counter
	li $t4, 1  # final sum
	li $t5, 0  # boundary for loop iteration
	
	la $a0, msg # output message to console
	li $v0, 4
	syscall
	
	li $v0, 5 #Read user input integer 
	syscall
	
	move $t6, $v0 # store user input n
	sub $t5,$t6, 1 #subtract one for iteration
	
loop:
	bgt  $t3, $t5, exit  # loop up to user input number
	add $t2, $t0, $t1    # add previous two terms and store
	add $t4, $t4, $t2    # add new term to final sum
	move $t0, $t1        # store two terms for next iteration   
	move $t1, $t2
	addi $t3, $t3, 1     # increment counter    
	j loop
	
exit:		
	la $a0, msg1 # output message to console
	li $v0, 4
	syscall
	
	move $a0, $t6  # output user input n to console
	li $v0, 1
	syscall
	
	la $a0, msg2 # output second part of message
	li $v0, 4
	syscall
			
	move $a0, $t4   # print final sum to console
	li $v0, 1
	syscall
	
	li $v0, 10       # exit
	syscall
	
	.data
msg:    .asciiz "Enter the number of Fibonacci numbers you would like to find the sum of: "
msg1:   .asciiz "The sum of the first "	
msg2:   .asciiz " Fibonacci numbers is : "