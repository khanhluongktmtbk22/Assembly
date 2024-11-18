#Chuong trinh: kiem tra so nguyen to ngau nhien
#macro
.macro puts(%str_name)
	la 	$a0, %str_name
	addi 	$v0, $zero, 4
	syscall
.end_macro
#Data segment
.data
#Cac dinh nghia bien
fdescr:	.word	0
filename: .asciiz "NGUYENTO.TXT"
so:  	.asciiz "So "
true:	.asciiz " la so nguyen to.\n"
false:	.asciiz " khong la so nguyen to.\n"
# Cac cau nhac nhap/xuat du lieu
str_tc:	.asciiz	"Thanh cong."
str_loi: .asciiz "Mo file bi loi."
#Code segment
.text
.globl	main
main:
#Xu ly
# $s0 luu gia tri so duoc random
# $s1 luu gia tri so nguyen to
# $s2 luu gia tri so khong nguyen to
#set seed
    	addi	$v0, $zero, 30
	syscall
	add	$a1, $a0, $zero				
	addi	$a0, $zero, 1				
	addi	$v0, $zero, 40
	syscall
	
#thiet lap dieu kien goi again	
    	addi 	$s1, $zero, 0 		
    	addi 	$s2, $zero, 0
again:
	addi 	$a1, $zero, 10000	# set upper bound
	jal	random			# Use function
	add	$s0, $v0, $zero	
# check if the number is prime
    	addi 	$t0, $zero, 2
    	addi	$t5, $zero, 1
check_loop:
	addi	$t5, $t5,1
  	div 	$s0, $t0
   	mfhi 	$t1			# $hi = $s0 % $t0
    	beq 	$t1, $zero not_prime
    	addi 	$t0, $t0, 1
    	slt	$t2, $t0, $s0 
    	bne 	$t2, $zero, check_loop
# if we reach here, the number is prime
#Xuat ket qua (syscall)
    	puts(so)			#xuat so nguyen to
	add	$a0, $s0, $zero
	addi 	$v0, $zero, 1
	syscall
    	puts(true)
    	add	$s1, $s0, $zero
    	j 	cond

	not_prime:			#xuat so khong nguyen to
	puts(so)
	add	$a0, $s0, $zero
	addi 	$v0, $zero, 1
	syscall
    	puts(false)
	add	$s2, $s0, $zero

# Kiem tra da co du 2 so (1 so nguyen to - 1 so khong nguyen to) hay chua?
# Neu chua, branch to label again 
cond:
	beq  	$s1, $zero, again
	beq 	$s2, $zero, again
# Tai day ta có 1 so nguyen to ($s1) và mot so khong nguyen to ($s2)
# Mo file
	la	$a0, filename
	addi 	$a1, $zero, 1		# open with a1=1 (write-only)
	addi	$v0, $zero, 13
	syscall
	bgez	$v0,tiep
	puts	str_loi			# mo file khong duoc
	
# Ghi file
	tiep:	sw	$v0,fdescr	# luu file descriptor	
	lw	$a0, fdescr		# file descriptor

# Ghi so nguyen to vao file
	la 	$a1, so			#ghi chuoi trong bien "so"
	addi 	$a2, $zero, 3
	addi 	$v0, $zero,15
	syscall
	
	addi 	$a1, $zero, 10 		# hang so 10
  	ori 	$t3, $s1, 0		# $t3 chua so can in ra file
  	addi 	$t2, $zero, 0 		# so chu so của so luu trong $t3
#xu ly int ve string   	
whloop1: beq $t3, $zero, endwh1
	addi $t2, $t2, 1
	div $t3, $a1
	mflo $t3
	mfhi $a2
	addi $a2, $a2, 48
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	j whloop1
endwh1:
whloop2: beq $t2, $zero endwh2
	addi $t2, $t2, -1
	la $a1, 0($sp)
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	addi $sp, $sp, 4
	j whloop2
endwh2:	  

	la $a1, true		# ghi chuoi trong bien "true"
	addi $a2, $zero, 18
	addi $v0, $zero,15
	syscall

# Ghi so khong nguyen to vao file	
	la $a1, so		# ghi chuoi trong bien "so"
	addi $a2, $zero, 3
	addi $v0, $zero,15
	syscall
				
	addi $a1, $zero, 10	# hang so 10
  	ori $t3, $s2, 0		# $t3 chua so can in ra file
  	addi $t2, $zero, 0	# so chu so của so luu trong $t3
#xu ly int ve string
whloop3: beq $t3, $zero, endwh3
	addi $t2, $t2, 1
	div $t3, $a1
	mflo $t3
	mfhi $a2
	addi $a2, $a2, 48
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	j whloop3
endwh3:
whloop4: beq $t2, $zero, endwh4
	addi $t2, $t2, -1
	la $a1, 0($sp)
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	addi $sp, $sp, 4
	j whloop4
endwh4:	

	la $a1, false		# ghi chuoi trong "false"
	addi $a2, $zero, 24
	addi $v0, $zero,15
	syscall	  	
		
# Dong file (syscall)
    	lw		$a0, fdescr	
	addi		$v0, $zero, 16
	syscall

# Ket thuc chuong trinh (syscall)
	addiu	$v0, $zero, 10
	syscall
	
# Function
random:
	addi		$a0, $zero, 1
	addi		$v0, $zero, 42		
	syscall
	add		$v0, $a0, $zero		# Return v0
	jr 		$ra
