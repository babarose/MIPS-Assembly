	.data
inputStr: .asciiz "Input: "
outputStr: .asciiz "Output: "

	.text
main:
	#reading array elements
	li $v0, 5
	syscall
	move $s0, $v0	# s0 = a 0
	li $v0, 5
	syscall
	move $s1, $v0   # s1 = a 1
	li $v0, 5
	syscall
	move $s2, $v0	# s0 = a 0
	li $v0, 5
	syscall
	move $s3, $v0 
	li $v0, 5
	syscall
	move $s4, $v0	# s0 = a 0
	li $v0, 5
	syscall
	move $s5, $v0 
