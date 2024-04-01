.data
array: .space 400    # 100 integer (4 bytes each) array to hold the input
length: .word 0      # Variable to hold the length of the array
# Data section
prompt: .asciiz "Enter the elements of the array separated by spaces: "
new_array_prompt: .asciiz "\nThe new array is: "
space: .asciiz " "

.text
.globl main


    
main:
	li $v0, 4 
	la $a0, prompt
	syscall 

	#reading array elements
	li $v0, 5
	syscall
	move $s0, $v0	# s0 = a 0
	li $v0, 5
	syscall
	move $s1, $v0   # s1 = a 1
	li $v0, 5
	syscall
	move $s2, $v0	# s2 = a 2
	li $v0, 5
	syscall
	move $s3, $v0  # s3 = a 3
	li $v0, 5
	syscall
	move $s4, $v0	# s4 = a 4
	li $v0, 5
	syscall
	move $s5, $v0  # s5 = a 5
	
	jal switch_elements

print_loop:
    lw $a0, 0($s0)          # load integer from array
    li $v0, 1               # syscall 1: print integer
    syscall
    li $v0, 4               # syscall 4: print string
    la $a0, space           # load address of the space character
    syscall

    addiu $s0, $s0, 4       # move to the next element in the array
    addi $t1, $t1, -1       # decrement index counter
    bgtz $t1, print_loop    # if index counter > 0, continue printing

    # Free dynamically allocated memory
    li $v0, 10              # syscall 10: exit
    syscall

switch_elements:
    # Function prologue
    addi $sp, $sp, -4       # allocate space on stack
    sw $ra, 0($sp)          # save return address

    lw $t0, 0($a1)          # load length of the array
    move $t1, $a0           # move array pointer to $t1

    # Outer loop for checking and removing non-coprime elements
outer_loop:
    li $t2, 0               # initialize flag for change detection
    li $t3, 0               # initialize loop counter
inner_loop:
    beq $t3, $t0, end_inner_loop # if loop counter equals array length, exit inner loop
    lw $t4, 0($t1)          # load current element
    lw $t5, 4($t1)          # load next element
    jal gcd                 # call gcd function
    move $a0, $t4           # pass current element to gcd function
    move $a1, $t5           # pass next element to gcd function
    move $t6, $v0           # save gcd result
    li $t7, 1               # set flag to 1 (true)
    bne $t6, $t7, not_coprime  # if gcd != 1, go to not_coprime
    addiu $t1, $t1, 4       # move to next pair of elements
    addi $t3, $t3, 1        # increment loop counter
    j inner_loop            # repeat inner loop
not_coprime:
    mul $t8, $t4, $t5       # multiply current and next element
    div $t8, $t6            # divide by gcd
    mflo $t9                # store result in $t9
    sw $t9, 0($t1)          # store lcm in current element position
    addiu $t1, $t1, 4       # move to next pair of elements
    addi $t3, $t3, 1        # increment loop counter
    li $t2, 1               # set change flag to 1 (true)
    j inner_loop            # repeat inner loop
end_inner_loop:
    bnez $t2, outer_loop    # if change flag != 0, repeat outer loop

    # Function epilogue
    lw $ra, 0($sp)          # restore return address
    addi $sp, $sp, 4        # deallocate space on stack
    jr $ra                  # return to caller

gcd:
    # $a0 = a, $a1 = b
    # Return value: gcd(a, b)
    addi $sp, $sp, -8         # reserve space on stack
    sw $a0, 0($sp)            # save a
    sw $ra, 4($sp)            # save return address

    bne $a1, $zero, gcd_loop  # if b != 0, continue loop
    move $v0, $a0             # return a if b is 0
    j gcd_exit

gcd_loop:
    # calculate (a % b) and store the result in $t0
    div $a0, $a1
    mfhi $t0

    # set a = b, b = a % b (remainder)
    move $a0, $a1
    move $a1, $t0

    # repeat until b becomes 0
    bne $a1, $zero, gcd_loop

gcd_exit:
    lw $a0, 0($sp)            # restore a
    lw $ra, 4($sp)            # restore return address
    addi $sp, $sp, 8          # deallocate stack space
    jr $ra                    # return