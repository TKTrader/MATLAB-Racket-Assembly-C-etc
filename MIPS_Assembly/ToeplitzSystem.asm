	.data
Matrix: .word 5,1,2,3,4
Vector: .word 1,2,3
newline: .asciiz    "\n"
	.text
	.globl main
	# Thomson Kneeland
	# Toeplitz System
main:
	la $t0, Matrix
	la $t1, Vector
	 #  load elements of Matrix into registers   
	lw $t2, 0($t0)  # a(0)  
	lw $t3, 4($t0)  # a(1)  
	lw $t4, 8($t0)  # a(2)  
	lw $t5, 12($t0)  # a(3)
	lw $t6, 16($t0)  # a(4)
	 #load elements of Vector into registers
	lw $t7, 0($t1)  #x(0)
	lw $t8, 4($t1)  #x(1)
	lw $t9, 8($t1)  #x(2)
	#y(0)
	mult $t2,$t7 #multiply a(0) X  x(0)
	mflo $s0 #store product 
	mult $t5,$t8 #multiply a(3) X  x(1)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	mult $t6,$t9 #multiply a(4) X  x(2)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	move $a0, $s0 # move first element of array for output
	li $v0, 1  # output to console 
	syscall
	la $a0, newline       # print blank line
	li $v0, 4       # you can call it your way as well with addi 
	syscall
	#y(1)
	mult $t3,$t7 #multiply a(1) X  x(0)
	mflo $s0 #store producta
	mult $t2,$t8 #multiply a(0) X  x(1)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	mult $t5,$t9 #multiply a(3) X  x(2)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	move $a0, $s0 # move first element of array for output
	li $v0, 1  # output to console 
	syscall
	la $a0, newline       # print blank line
	li $v0, 4       # you can call it your way as well with addi 
	syscall
	#y(2)
	mult $t4,$t7 #multiply a(2) X  x(0)
	mflo $s0 #store product 
	mult $t3,$t8 #multiply a(1) X  x(1)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	mult $t2,$t9 #multiply a(0) X  x(2)
	mflo $s1 #store product 
	add $s0, $s0, $s1
	move $a0, $s0 # move first element of array for output
	li $v0, 1  # output to console 
	syscall
	la $a0, newline       # print blank line
	li $v0, 4       # you can call it your way as well with addi 
	syscall
	
	
	li $v0, 10  # exit program
	syscall	