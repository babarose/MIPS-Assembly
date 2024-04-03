.data
matrix: .byte 5, 6, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0,
        1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0
        # 32 elemanlık bir byte dizisi olan matrix. İkili bir matrisin temsili için kullanılır.

output_string: .asciiz "The number of the 1s on the largest island is "
        # Çıktı dizesi. "The number of the 1s on the largest island is " ifadesini içerir.

newline: .asciiz "\n"
        # Yeni satır karakterini içeren bir dize.

.text
.globl main

main:

        lb $t0, matrix
        lb $t1, matrix+1
        jal printing
        # matrix'in ilk iki elemanını $t0 ve $t1'e yükle, ardından printing altprogramını çağır.

print_matrix:
        # Matrisi yazdırmak için altprogram.

        move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        li $t0, 0
        li $t1, 0
        j matrix_outer_loop
        # Gerekli kayıtlara (registers) matrisin başlangıç adresini ve boyutunu yükler, ardından döngüyü başlatır.

printing:
        # Yazdırma altprogramını çağırmak için ana kontrol akışı.

        la $a0, matrix+2
        move $a1, $t0
        move $a2, $t1
        jal print_matrix
        j exit
        # Matrisin 2. elemanının adresini ve boyutlarını argümanlar olarak belirler, 
        # ardından print_matrix altprogramını çağırır ve son olarak programı sonlandırır.

matrix_outer_loop:
        # Dış döngü. Matrisin satırlarını tarar.

        bge $t0, $s1, print_matrix_exit
        # Satır sayısı $s1'den büyük veya eşitse print_matrix_exit'e atla.

        li $t2, 0
        j matrix_inner_loop
        # $t2'yi sıfırla ve iç döngüye geç.

matrix_inner_loop:
        # İç döngü. Matrisin sütunlarını tarar.

        bge $t2, $s2, print_matrix_newline
        # Sütun sayısı $s2'den büyük veya eşitse print_matrix_newline'a atla.

        lb $t3, ($s0)
        j print_matrix_element
        # $s0'nın gösterdiği adresin içeriğini $t3'e yükle ve print_matrix_element'e atla.

print_matrix_element:
        # Matrisin bir elemanını yazdırmak için altprogram.

        li $v0, 1
        move $a0, $t3
        syscall
        j print_space
        # $t3'teki değeri yazdır, ardından bir boşluk yazdırmak için print_space'e atla.

print_space:
        # Boşluk yazdırmak için altprogram.

        li $v0, 11
        li $a0, 32
        syscall
        j move_next
        # Boşluk yazdır ve sonraki işleme geçmek için move_next'e atla.

move_next:
        # Matrisin bir sonraki elemanına geçmek için altprogram.

        addi $s0, $s0, 1
        addi $t2, $t2, 1
        j matrix_inner_loop
        # Adresi bir sonraki elemana taşı ve sütun sayacını artır, ardından iç döngüye geri dön.

print_matrix_newline:
        # Yeni satır yazdırmak için altprogram.

        li $v0, 4
        la $a0, newline
        syscall
        j move_next_row
        # Yeni satır karakterini yazdır ve bir sonraki satıra geçmek için move_next_row'a atla.

move_next_row:
        # Bir sonraki satıra geçmek için altprogram.

        addi $t0, $t0, 1
        j matrix_outer_loop
        # Satır sayacını artır ve dış döngüye geri dön.

print_matrix_exit:
        jr $ra
        # Yazdırma işlemini sonlandır ve geri dön.

exit:
	j calcualte
	
calcualte:
        mul $t0 , $a2, $a1
        div $t1, $t0 , 3
        # Sonucu hesapla: (satır sayısı * sütun sayısı) / 3
	j printoutputString

printoutputString:
        li $v0, 4
        la $a0, output_string
        syscall
  	j printoutputResult
 printoutputResult:
 
        li $v0, 1
        move $a0, $t1
        syscall
        # Sonucu ve çıktı dizesini yazdır.
        j realExit
realExit:
        li $v0, 10
        syscall
        # Programı sonlandır.