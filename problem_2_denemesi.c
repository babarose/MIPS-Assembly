   	.data
str:  .space 40		# space for 10 integers (assuming each integer takes 4 bytes)
array: .space 100	#
arrayForMultipleChars: .space 10    
    	.text
    	.globl main

main:
	li $v0, 8
	la $a0, str
	la $a1, 40
	syscall
	
iterationThroughStr:
	
	la $s4, arrayForMultipleChars
	la $s3, array
	la $s1, str	# s1 = address of first element in str
	
	lb $s2, 0($s1)	# s2 = first element of str
	li $t2, 32	# ascii for space ' '
	
	addi $s1,$s1,-1
loop:
	addi $s1,$s1,1
	addi $t3,$t3,0 # counter initialized to zero, this counter will be used for digits 10th power. i.e. 320 first digit will be 3*10^2 so counter will be 2
	lbu $s2, 0($s1)
	
	move $a0, $s2
	li $v0, 11
	syscall
	
	sb $s4, -30($s2)
	addi $t3, $t3, 1
	
	
	beq $s2, $t2 charToInt
	
	addi $t3, $t3, 1
	jal charToInt	# for the final integer that not end with 0
	
	addi $t1, $t1, 0
	beq $s2, $t1, exit
	
	j loop
	
charToInt:	# s5 is result if integers are multiple digit
	addi $s4, $s4, -4
	addi $t5, $t3, -1
	
jumpForDigitCalculations:
	addi $t5,$t5, -1
	sgt $t6, $t5, 0
	beq $t6, 1, L1
	
L1:
	lw $t4, 4($s4)	# t4 = s4 (arrayformultiplechars'ýn ilk elemaný)
	mul $s3, $t4, 10
	
	addi $t5,$t5, -1	#this this discrementation is done becuase counter is 3 and every loop we get power of 10 by one
	sgt $t6, $t3, 0
	beq $t6, 1, L1
	
	addi $t5,$t5, -1	#this discrementation is done becuase every digit from RHS should be have 1 less power of 10
	add $s5, $s5, $s3
	
	beq $t4, 32, # it's all over now so we can leave the charToInt part but ýdk where to jump
	
	j jumpForDigitCalculations
		
exit:
	li $v0, 10
	syscall