	.data
inputStr: .asciiz "Input: "
outputStr: .asciiz "Output: "

	.text
main:
	li $v0, 4 
	la $a0, inputStr
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
	
	li $t0, 0 #initialize to = i to 0
	li $t1, 6 #initialize to = n to 6
loopCondition: 
	slt $t2, $t0, $t1
	beq $t2, 1, loop
	j endLoop
	
loop:
	jal areCoprime
	
endLoop:





# Function to find the greatest common divisor
# $a0 = a, $a1 = b
# Return value: gcd(a, b)
gcd:
    # Function prologue
    addi $sp, $sp, -8       # Reserve space on stack
    sw $a0, 0($sp)          # Save a
    sw $ra, 4($sp)          # Save return address
    
    # Check if b == 0
    beq $a1, $zero, gcd_exit    # If b == 0, return a
    
    # Recursively call gcd(b, a % b)
    div $a0, $a1            # Divide a by b
    mfhi $t0                # Remainder stored in $t0
    move $a0, $a1           # Move b to $a0
    move $a1, $t0           # Move remainder to b
    jal gcd                 # Recursive call to gcd
    j gcd_exit              # Jump to exit
    
gcd_exit:
    # Function epilogue
    lw $a0, 0($sp)          # Restore a
    lw $ra, 4($sp)          # Restore return address
    addi $sp, $sp, 8        # Deallocate stack space
    jr $ra                  # Return

# Function to find the least common multiple
# $a0 = a, $a1 = b
# Return value: lcm(a, b)
lcm:
    # Function prologue
    addi $sp, $sp, -12      # Reserve space on stack
    sw $ra, 8($sp)          # Save return address

    # Compute gcd(a, b)
    jal gcd                 # Call gcd function
    move $t0, $v0           # Save gcd(a, b) to $t0

    # Compute a * b / gcd(a, b)
    mul $t1, $a0, $a1       # Multiply a and b
    div $t1, $t0            # Divide by gcd(a, b)
    mflo $v0                # Remainder stored in $v0

    # Function epilogue
    lw $ra, 8($sp)          # Restore return address
    addi $sp, $sp, 12       # Deallocate stack space
    jr $ra                  # Return

	
# Function to check if two numbers are coprime
# $a0 = a, $a1 = b
# Return value: 1 if a and b are coprime, 0 otherwise
areCoprime:
    # Function prologue
    addi $sp, $sp, -12      # Reserve space on stack
    sw $ra, 8($sp)          # Save return address

    # Compute gcd(a, b)
    jal gcd                 # Call gcd function
    move $t0, $v0           # Save gcd(a, b) to $t0

    # Check if gcd(a, b) == 1
    li $t1, 1               # Load 1 to $t1
    beq $t0, $t1, coprime   # If gcd(a, b) == 1, jump to coprime label

    # gcd(a, b) != 1, so they are not coprime
    li $v0, 0               # Load 0 to $v0 (false)
    j end                   # Jump to end

coprime:
    # gcd(a, b) == 1, so they are coprime
    li $v0, 1               # Load 1 to $v0 (true)

end:
    # Function epilogue
    lw $ra, 8($sp)          # Restore return address
    addi $sp, $sp, 12       # Deallocate stack space
    jr $ra                  # Return
	
	
	
