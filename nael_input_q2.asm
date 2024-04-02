.data
.align 2
inputArray: .space 1024
outputArray: .space 1024
prompt: .asciiz "Enter integers: "
input_buf: .space 200

.text

main:
    # prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # read string
    li $v0, 8
    la $a0, input_buf
    li $a1, 200
    syscall
    
    # parse string
    la $s0, input_buf # get addresses
    la $s1, inputArray
    la $s2, outputArray
    add $t2, $zero, $zero # current integer
    add $t3, $zero, $zero # check if more than a digit
    add $t5, $zero, $zero # count length

    
string_loop:
    # load char
    lb $t4, 0($s0)
    beq $t4, $zero, end_string
    beq $t4, 10, end_string
    # if encountered a space move on
    beq $t4, 32, next_int
    addi $t3, $zero, 1
    
    # convert ascii to integer
    addi $t4, $t4, -48
    mul $t2, $t2, 10
    add $t2, $t2, $t4
    # get next char
    addi $s0, $s0, 1
    j string_loop
    
next_int:
    # store int
    sw $t2, 0($s1)
    addi $t5, $t5, 1 
    addi $s1, $s1, 4
    # reset check and integer
    add $t2, $zero, $zero
    add $t3, $zero, $zero
    # get next char
    addi $s0, $s0, 1
    j string_loop
    
end_string:
    # store last int
    sw $t2, 0($s1)
    addi $t5, $t5, 1
    move $s3 , $t5
    # Print the array
    la $s1, inputArray           # Load the base address of the array
    li $t2, 0               # Initialize counter for number of elements printed
	addi $s7, $s3, -1
	lw $t4, 0($s1)
	sw $t4, 0($s2)
check:
	addi $t6, $t6, 1 
	beq $t6, $s7, print_output
	jal find_gcd
	
	move $t7, $v0
	beq $t7, 1, outputArray_gcd
	jal find_lcm
	move $t8, $v0
	j outputArray_lcm
find_gcd:
    lw $a0, 0($s2)  # $t0'daki değer $a0'ye kopyalanır
    lw $a1, 4($s1)
    slt $t1, $a0, $a1
    beq $t1 , 1 , swap
    #sonraki adres boş ise sistem kapatmalı kendini bu arada 
    j gcd_loop
swap:
	move $t1, $a0
	move $a0, $a1
	move $a1, $t1
	j gcd_loop
gcd_loop:
    beq $a1, $zero, gcd_done

    div $a0, $a1
    mfhi $t0

    move $a0, $a1
    move $a1, $t0

    j gcd_loop

gcd_done:
    move $v0, $a0
    jr $ra
    
# find_lcm function
# Arguments: $a0 = a, $a1 = b
# Return: $v0 = lcm

find_lcm:
#addi $sp, $sp, -4       # Allocate space on the stack for 1 word
#sw $ra, 0($sp)          # Save return address

    lw $a0, 0($s1)  # $input arrayndedaki değer $a0'ye kopyalanır
    lw $a1, 4($s1)
    
    mul $t9, $a0, $a1
    #jal find_gcd
    move $t8, $v0
    div $v0, $t9,$t8
    addi $s1,$s1, 4

 #lw $ra, 0($sp)          # Restore return address
#addi $sp, $sp, 4        # Deallocate space on the stack
     jr $ra                  # Return to caller
    
    

    
outputArray_gcd:
 	   lw $s6, 0($s1)
 	   j outputArray_write
outputArray_lcm:
	move $s6, $t8
	j outputArray_write
outputArray_write:
	sw $s6, 0($s2)
	addi $s4, $s4, 1 #output array's counter
	addi $s1, $s1 , 4
	addi $s2, $s2 , 4
	j check



print_output:

	move $zero, $t2
	la $s2, outputArray
	j print_loop
	
print_loop:
    lw $a0, 0($s2)          # Load integer from array
    li $v0, 1 # print int
    syscall
    li $v0, 11
    la $a0, 32              # ASCII for space
    syscall
    addi $s2, $s2, 4        # Move to next index in array
    addi $t2, $t2, 1        # Increment counter
    blt $t2, $s4, print_loop # Check if end of array
    li $v0, 10              # Exit program
    syscall