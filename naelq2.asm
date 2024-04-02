.data
.align 2
array: .space 1024
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
    la $t0, input_buf # get addresses
    la $t1, array
    add $t2, $zero, $zero # current integer
    add $t3, $zero, $zero # check if more than a digit
    add $t5, $zero, $zero # count length
    
input_loop:
    # load char
    lb $t4, 0($t0)
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
    addi $t0, $t0, 1
    j input_loop
    
next_int:
    # store int
    sw $t2, 0($t1)
    addi $t5, $t5, 1 
    addi $t1, $t1, 4
    # reset check and integer
    add $t2, $zero, $zero
    add $t3, $zero, $zero
    # get next char
    addi $t0, $t0, 1
    j input_loop
    
end_string:
    # store last int
    sw $t2, 0($t1)
    addi $t5, $t5, 1

 
   # algorithm
   la $a0, array
   move $a1, $t5 # length
   jal replace_elements


    # Print the array
    la $t1, array           # Load the base address of the array
    li $t2, 0               # Initialize counter for number of elements printed
    
print_loop:
    lw $a0, 0($t1)          # Load integer from array
    li $v0, 1 # print int
    syscall
    li $v0, 11
    la $a0, 32              # ASCII for space
    syscall
    addi $t1, $t1, 4        # Move to next index in array
    addi $t2, $t2, 1        # Increment counter
    blt $t2, $t5, print_loop # Check if end of array
    li $v0, 10              # Exit program
    syscall

replace_elements:
    # replace when not coprime
    addi $t4, $zero, 1 # check if replacement occurerd
    add $t6, $a1, $zero # temp length that will be subtracted
    
    # array address is in a0, length is in a1
    
    # check temp length 
    add $s0, $zero, $zero
    
check_loop:
    # length -1
    # t6 isnt updated???????????????????
    addi $s0, $t6, -1
    beq $t4, $zero, exit_replacement
    move $t4, $zero # reset check
    move $t0, $zero # loop iterator
    
inner_loop:
    # if i >= length - 1 exit
    bge $t0, $s0, check_loop
    
    # calculate GCD
    lw $s1, ($a0) # load first int
    lw $s2, 4($a0) # load second int
    jal gcd
    
    
    # burdan devam ******************************
    move $t7, $v0 # gcd stored into t7
    beq $t7, 1, compare_next
    # calculate least common factor LCF
    lw $s1, ($a0) # load arr[i]
    lw $s2, 4($a0) # load arr[i+1]
    mult $s1, $s2
    mflo $v0 # move low result 32bit
    
    # store LCF to arr[i]
    sw $v0, ($a0)
    addi $t2, $t0, 1 # loop iterator for shift loop j
    move $t1, $a0
    
shift_loop:
    addi $t1, $t1, 4 # next element
    lw $t3, ($t1)
    sw $t3, -4($t1)
    addi $t2, $t2, 1
    blt $t2, $s0, shift_loop
    
    # decrement length
    addi $t6, $t6, -1
    # changed flag reset to 1
    addi $t4, $zero, 1
    # addi $t0, $t0, -1
    j inner_loop
    
compare_next:
    addi $t0, $t0, 1
    j inner_loop
        
exit_replacement:
    jr $ra
    
gcd: 
    # get gcd to compare if coprime
    move $t2, $s1 # copy two int
    move $t3, $s2
gcd_loop:
    beq $t3, $zero, gcd_end # Exit loop if num2 is 0
    move $t4, $t3           # Copy num2 to $t4
    div $t2, $t3            # Divide num1 by num2
    mfhi $t2                # Store remainder in $t2
    move $t3, $t2           # Copy remainder to num2
    move $t2, $t4           # Copy previous num2 to num1
    j gcd_loop              # Repeat loop   
gcd_end:
    move $v0, $t2
    jr $ra
        
