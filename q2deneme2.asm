	.data
	.align 2
input_message: .asciiz "Enter integers: "
outputStr: .asciiz "Output: "
inputArray: .space 400
outputArray: .space 400
inputBuffer: .space 200


	.text
main:

    #input message
    li $v0, 4
    la $a0, input_message
    syscall

    # read string
    li $v0, 8
    la $a0, inputBuffer
    li $a1, 200
    syscall

    # parse string
    la $t0, inputBuffer # get addresses
    la $t1, inputArray
    add $t2, $zero, $zero # current integer
    add $t3, $zero, $zero # check if more than a digit
    add $t5, $zero, $zero # count length


string_loop:
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
    j string_loop
    
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
    j string_loop
    
end_string:
    # store last int
    sw $t2, 0($t1)
    addi $t5, $t5, 1

    # Print the array
    la $t1, inputArray           # Load the base address of the array
    li $t2, 0               # Initialize counter for number of elements printed
	
main_continue:
 # find_gcd fonksiyonunu çağır
    move $a0, $t0
    jal find_gcd
    



	
	
    # GCD'yi yazdır
    li $v0, 1
    move $a0, $v0
    syscall

    # Programı sonlandır
    li $v0, 10
    syscall

find_gcd:
    move $a0, $t0  # $t0'daki değer $a0'ye kopyalanır
    move $a1, $zero

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

   