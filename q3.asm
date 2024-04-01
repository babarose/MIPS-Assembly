.data
Input_string: .space 1024
Input_prompt: .asciiz "Input: "
Output_prompt: .asciiz "Output: "
.text
.globl main

main:
    # Prompt
    li $v0, 4
    la $a0, Input_prompt
    syscall
    
    # Input string
    li $v0, 8
    la $a0, Input_string
    li $a1, 1024
    syscall 
    
    # Find string length and assign to $t0
    jal strlength
    
    # Remove '\n' char
    addi $t0, $t0, -1
    
    # n assign into t1
    li $v0, 5
    syscall
    move $t1, $v0  
    
    # shuffle
    move $a0, $t0  
    move $a1, $t1  
    jal shuffle
    
    # Prompt
    li $v0, 4
    la $a0, Output_prompt
    syscall
    
    # Print
    li $v0, 4
    la $a0, Input_string
    syscall

    # Exit
    li $v0, 10
    syscall

shuffle:
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    # if n = 0 exit
    beqz $a1, end_shuffle
    
    
    move $a2, $a0   
    srl $a2, $a2, 1 
    
    jal swap
    
    # Decrement n
    addi $a1, $a1, -1

    jal shuffle

end_shuffle:
    lw $ra, ($sp)
    addi $sp, $sp, 4
    jr $ra

swap:
    addi $sp, $sp, -4
    sw $ra, ($sp)
    
    la $t3, Input_string
    
    move $t4, $a2  
    add $t4, $t3, $t4  

    move $t5, $a0  
    add $t5, $t3, $t5  
    
#swap char by char
swap_loop:
    lb $t6, ($t3)  # Load 1
    lb $t7, ($t5)  # Load 2
    sb $t7, ($t3)  # Store 1
    sb $t6, ($t5)  # Store 2
    
    addi $t3, $t3, 1  #inc index
    subi $t5, $t5, 1  #inx index
    blt $t3, $t4, swap_loop  
    

    lw $ra, ($sp)
    addi $sp, $sp, 4
    jr $ra


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