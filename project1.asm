	.data
coefficientPrompt: .asciiz "Please enter the coefficients: "
twoNumberPrompt: .asciiz "Please enter the first two numbers of the sequence: "
calculatePrompt: .asciiz "Enter the number you want to calculate: "
output1: .asciiz "Output: "
output2: .asciiz ". element of the sequence is "
output3: .asciiz "."

invalidInputMessage: .asciiz "Number you want to calculate is less than 1. Please enter a number that greater than 1"
	.text
	
main:
	li $v0, 4 
	la $a0, coefficientPrompt
	syscall 

	#reading coefficient
	li $v0, 5
	syscall
	move $s0, $v0	# s0 = a
	li $v0, 5
	syscall
	move $s1, $v0   # s1 = b
	
	li $v0, 4 
	la $a0, twoNumberPrompt
	syscall 
	
	li $v0, 5
	syscall
	move $s2, $v0	# s2 = f(0)
	li $v0, 5
	syscall
	move $s3, $v0	# s2 = f(1)
	
	li $v0, 4 
	la $a0, calculatePrompt
	syscall 
	
	li $v0, 5
	syscall
	move $s4, $v0 # $s4 = calculation amount
	
	slti $t0, $s4, 1
	beq $t0, 1, invalidInput
	
	j loopStart
	
	
	loopStart:
		li $t0, 3        # Initialize t0 = i to 3
		li $t1, -2       # Load immediate value -2 into $t1
		jal loopCondition
	
	loopCondition:
		slt $t4, $t0, $s4   # Exit loop if i < n
		beq $t0, $s4, loop
		beq $t4, 1, loop
		j endLoop
		
	loop: 
		mul $t2, $s0, $s3         # a * f1
		mul $t3, $s1, $s2         # b * f0
 		add $s5, $t2, $t3         # result = a * f1 + b * f0
		add $s5, $s5, $t1         # result = a * f1 + b * f0 - 2
		move $s2, $s3             # f0 = f1
		move $s3, $s5             # f1 = result
		addi $t0, $t0, 1          # Increment i
   		j loopCondition
   	endLoop:
   		li $v0, 4
		la $a0, output1
		syscall
		
		li $v0, 1
		move $a0, $s4
		syscall
		
		li $v0, 4 
		la $a0, output2 
		syscall 

		li $v0, 1
		move $a0, $s5
		syscall
		
		li $v0, 4 
		la $a0, output3 
		syscall 
invalidInput:
	li $v0, 4
	la $a0, invalidInputMessage
	syscall