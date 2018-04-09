	.data
Matrix: .word 1,2,3,4
Vector: .word 5,6
newline: .asciiz    "\n"
	.text
	.globl main
	# Thomson Kneeland
	# Matrix Vector Multiplication
main:
	la $t0, Matrix
	la $t1, Vector
	lw $t2, 0($t0)  # load elements of matrix into registers
	lw $t3, 4($t0)
	lw $t4, 8($t0)
	lw $t5, 12($t0)
	lw $t6, 0($t1) # load elements of vector into registers
	lw $t7, 4($t1)
	mult $t2,$t6 #multiply M11 X V11
	mflo $t8 #store product 
	mult $t3,$t7#multiply M22 X V12
	mflo $t9
	add $t8, $t8, $t9 #add two products for R11
	mult $t4,$t6 #multiply M21 X V11
	mflo $t9 #store product
	mult $t5,$t7 #multiply M21 X V21
	mflo $t2
	add $t9,$t9, $t2 # add two products for R21

	move $a0, $t8 # move first element of array for output
	li $v0, 1  # output to console 
	syscall
	
	la $a0, newline       # print blank line
	li $v0, 4       # you can call it your way as well with addi 
	syscall
	
	move $a0, $t9 # move second element of array for output
	li $v0, 1  # output to console 
	syscall
	
	li $v0, 10  # exit program
	syscall	