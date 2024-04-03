.data
matrix: .byte 5, 6, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0,
        1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0
row: .word 0
col: .word 0

.text
.globl main

main:
    # Load row and column values from matrix
    lbu $t0, matrix     # Load first byte (row)
    lbu $t1, matrix+1   # Load second byte (column)
    sw $t0, row         # Store row value
    sw $t1, col         # Store column value

    # Calculate total number of elements in the matrix
    mul $t2, $t0, $t1   # $t2 = row * col

    # Print matrix
    la $t3, matrix      # Load address of matrix
    move $a0, $t0       # Row counter
    li $v0, 4           # Print integer syscall
print_matrix_loop:
    beq $a0, $zero, print_matrix_exit # If row counter is 0, exit loop
    move $a1, $t1       # Column counter
print_column_loop:
    beq $a1, $zero, print_newline # If column counter is 0, print newline
    lb $a0, ($t3)       # Load byte from matrix
    li $v0, 11          # Print character syscall
    syscall
    addi $t3, $t3, 1    # Move to next element in matrix
    subi $a1, $a1, 1    # Decrement column counter
    j print_column_loop
print_newline:
    li $v0, 11          # Print newline character syscall
    li $a0, '\n'        # Newline character
    syscall
    subi $a0, $a0, 1    # Decrement row counter
    j print_matrix_loop
print_matrix_exit:

    # Initialize variables
    li $t4, 0           # Initialize cnt to 0
    li $t5, 0           # Initialize max_growth to 0

    # Initialize loop variables
    li $t6, 0           # Initialize i to 0

