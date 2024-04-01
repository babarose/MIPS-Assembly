.data 
Input_string: .space 1024
Input_prompt: .asciiz "Input: "


.text
.globl main

main:
	li $v0, 4
	la $a0, Input_prompt
	syscall
	
	#
	li $v0, 8
	la $a0, Input_string
	li $a1, 1024
	syscall 
	
	#
	li $v0, 5
	syscall 
	move $t1, $v0
	
	#string lenght
	jal strlength
	
	#for end string
	addi $t0, $t0, -1
	
	#swap
	jal swap
		
	
swap:
	srl $t2, $t0, 1  #len/2 = k
	li $t3, 0    #i = 0
swap_loop:
	
	add $t4, $t3, $a0 # i + a0
	sll $t4, $t4, 2
	lb $t6, 0($t4)
	li $v0, 1
	move $a0, $t6
	syscall
	
strlength:
	li $t0, 0
strlength_loop:
	lb $t1, 0($a0)
	beqz $t1, strlength_end
    	addi $a0, $a0, 1
    	addi $t0, $t0, 1
	j strlength_loop
strlength_end:
    	jr $ra