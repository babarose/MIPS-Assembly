.data
array: .space 100      # 100 integer yer kaplayacak bir dizi oluşturuyoruz
input_message: .asciiz "Enter the integer array separated by spaces: "
result_message: .asciiz "Modified array with least common multiples: "

.text
.globl main

main:
    # Kullanıcıdan dizi girişini isteme
    li $v0, 4
    la $a0, input_message
    syscall
    
    # Kullanıcıdan dizi girişini al
    li $v0, 8
    la $a0, array
    li $a1, 100        # En fazla 100 karakter al
    syscall

    # Diziyi işlemek için işaretçi tanımla
    la $t0, array

    # İşlemler başlangıcında işaretçiyi artır
    loop:
        lb $t1, 0($t0)      # Diziden bir eleman oku
        beqz $t1, end_loop  # Eğer eleman 0 ise döngüden çık

        # İkinci elemanı almak için bir sonraki adrese geç
        addi $t0, $t0, 2    # Çünkü her bir eleman arasında bir boşluk var

        lb $t2, 0($t0)      # İkinci elemanı oku
        beqz $t2, end_loop  # Eğer eleman 0 ise döngüden çık

        # İki elemanın ortak katını hesapla
        move $a0, $t1       # İlk elemanı argüman olarak ayarla
        li $v0, 1
        move $a0, $t1
        syscall
        
        move $a1, $t2       # İkinci elemanı argüman olarak ayarla
        li $v0, 1
        move $a0, $t2
        syscall
        jal calculate_gcd   # En büyük ortak böleni hesaplamak için alt programı çağır

        # Eğer iki elemanın asal olmayan bir ortak katı varsa
        bnez $v0, modify_array  # Diziyi değiştirmek için alt programa git

        # İki eleman da birbirinden farklıysa, işaretçiyi bir geri al
        subi $t0, $t0, 2

        # İşaretçiyi bir sonraki elemana hareket ettir
        addi $t0, $t0, 2

        j loop  # Döngüyü yeniden başlat

    modify_array:
        # Dizideki elemanları değiştir
        sb $v0, 0($t0)      # En büyük ortak böleni yeni eleman olarak atar

        # İşaretçiyi bir sonraki elemana hareket ettir
        addi $t0, $t0, 2

        j loop  # Döngüyü yeniden başlat

    end_loop:
        # Sonuçları yazdır
        li $v0, 4
        la $a0, result_message
        syscall

        # Diziyi yazdır
        la $a0, array
        jal print_array

        # Programı sonlandır
        li $v0, 10
        syscall

# En büyük ortak böleni hesaplamak için bir alt program
calculate_gcd:
    move $t0, $a0
    move $t1, $a1

    gcd_loop:
        beq $t1, $zero, gcd_done
        div $t0, $t1
        move $t0, $t1
        move $t1, $v0
        j gcd_loop

    gcd_done:
        move $v0, $t0
        jr $ra

# Diziyi yazdırmak için bir alt program
print_array:
    # Elemanları tek tek yazdır
    loop2:
        lb $t1, 0($a0)      # Bir elemanı al

        # Eğer eleman 0 ise dizinin sonuna gelinmiştir
        beqz $t1, end_print

        # Eğer eleman sıfır değilse, yazdır
        li $v0, 1
        move $a0, $t1
        syscall

        # Bir sonraki elemana geç
        addi $a0, $a0, 1


        j loop2  # Döngüyü yeniden başlat

    end_print:
       

        jr $ra
