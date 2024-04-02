    .data
arr:    .word 6, 4, 3, 2, 7, 13
size:   .word 6
newline: .asciiz "\n"
msg:    .asciiz "The new array is: "

    .text
    .globl main

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

lcm:
    # $a0 = a, $a1 = b
    # Return value: lcm(a, b)
    addi $sp, $sp, -8         # reserve space on stack
    sw $ra, 4($sp)            # save return address

    # calculate (a * b) / gcd(a, b)
    mul $t0, $a0, $a1         # $t0 = a * b
    jal gcd                   # call gcd function
    div $t0, $v0
    mflo $v0                  # store result in $v0

    lw $ra, 4($sp)            # restore return address
    addi $sp, $sp, 8          # deallocate stack space
    jr $ra                    # return

areCoprime:
    # $a0 = a, $a1 = b
    # Return value: 1 if a and b are coprime, 0 otherwise
    jal gcd                   # call gcd function
    li $v0, 1                 # set return value to 1
    bne $v0, 1, areCoprime_exit # if gcd(a, b) != 1, return 0
    li $v0, 0                 # otherwise set return value to 0

areCoprime_exit:
    jr $ra                    # return

switchElements:
    # $a0 = address of arr, $a1 = size
    addi $sp, $sp, -32        # reserve space on stack
    sw $ra, 28($sp)           # save return address
    sw $s0, 24($sp)           # save $s0
    sw $s1, 20($sp)           # save $s1
    sw $s2, 16($sp)           # save $s2
    sw $s3, 12($sp)           # save $s3
    sw $s4, 8($sp)            # save $s4
    sw $s5, 4($sp)            # save $s5

    move $s0, $a0             # $s0 = address of arr
    move $s1, $a1             # $s1 = size
    li $s2, 0                 # $s2 = new_size
    li $s3, 0                 # $s3 = changed

    switchElements_outer_loop:
        bnez $s3, switchElements_inner_loop # if changed != 0, go to inner loop
        li $s3, 0                         # reset changed to 0

        li $s4, 0                         # $s4 = i
        li $s5, 0                         # $s5 = j

        switchElements_process:
            blt $s4, $s1, switchElements_process_continue
            j switchElements_end

        switchElements_process_continue:
            lw $t0, 0($s0)            # load arr[i] into $t0
            lw $t1, 4($s0)            # load arr[i+1] into $t1
            addi $s4, $s4, 1          # increment i

            jal areCoprime            # call areCoprime function
            bnez $v0, switchElements_process_coprime # if areCoprime(arr[i], arr[i+1]), go to switchElements_process_coprime

            jal lcm                   # call lcm function
            sw $v0, 0($s0)            # store lcm(arr[i], arr[i+1]) in arr[i]
            addi $s3, $s3, 1          # set changed to 1
            addi $s4, $s4, 1          # skip the next element
            j switchElements_process_continue

        switchElements_process_coprime:
            sw $t0, 0($s0)            # store arr[i] in arr[j]
            addi $s5, $s5, 1          # increment j

        switchElements_process_end:
            addi $s0, $s0, 4          # increment address of arr
            j switchElements_process

        switchElements_inner_loop:
            li $s4, 0
            li $s5, 0

            switchElements_inner_loop_continue:
                blt $s4, $s2, switchElements_inner_loop_continue_end
                j switchElements_outer_loop_end

            switchElements_inner_loop_continue_end:
                lw $t0, 0($s0)            # load new_arr[i] into $t0
                lw $t1, 4($s0)            # load new_arr[i+1] into $t1
                addi $s4, $s4, 1          # increment i

                jal areCoprime            # call areCoprime function
                bnez $v0, switchElements_inner_loop_coprime # if areCoprime(new_arr[i], new_arr[i+1]), go to switchElements_inner_loop_coprime

                jal lcm                   # call lcm function
                sw $v0, 0($s0)            # store lcm(new_arr[i], new_arr[i+1]) in new_arr[i]
                addi $s3, $s3, 1          # set changed to 1
                addi $s4, $s4, 1          # skip the next element
                j switchElements_inner_loop_continue

            switchElements_inner_loop_coprime:
                sw $t0, 0($s0)            # store new_arr[i] in new_arr[j]
                addi $s5, $s5, 1          # increment j

            switchElements_inner_loop_end:
                addi $s0, $s0, 4          # increment address of new_arr
                j switchElements_inner_loop_continue

    switchElements_outer_loop_end:
        lw $ra, 28($sp)           # restore return address
        lw $s0, 24($sp)           # restore $s0
        lw $s1, 20($sp)           # restore $s1
        lw $s2, 16($sp)           # restore $s2
        lw $s3, 12($sp)           # restore $s3
        lw $s4, 8($sp)            # restore $s4
        lw $s5, 4($sp)            # restore $s5
        addi $sp, $sp, 32         # deallocate stack space
        jr $ra                    # return

switchElements_end:

main:
    # load address of arr into $a0
    la $a0, arr
    lw $a1, size              # load size of arr into $a1
    jal switchElements       # call switchElements function

    # print newline
    li $v0, 4
    la $a0, newline
    syscall

    # print message
    li $v0, 4
    la $a0, msg
    syscall

    # print the new array
    li $v0, 4
    la $a0, arr
    lw $a1, size
print_loop:
    lw $t0, 0($a0)
    li $v0, 1
    move $a0, $t0
    syscall



    addi $a0, $a0, 4
    addi $a1, $a1, -1
    bnez $a1, print_loop

    # print newline
    li $v0, 4
    la $a0, newline
    syscall

    # exit program
    li $v0, 10
    syscall
