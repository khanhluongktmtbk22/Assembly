#Chuong trinh: THAP HA NOI
.macro puts(%str_name)
la $a0,%str_name
addiu	$v0,$zero,4
syscall
.end_macro
#Data segment
.data
#Cac dinh nghia bien
buoc: .asciiz "Buoc "
sang: .asciiz "==>"
end_line: .asciiz "\n"
A: .asciiz "A"
B: .asciiz "B"	
C: .asciiz "C"	
tenfile:	.asciiz	"THAP_HN.TXT"
fdescr:	.word	0	
haicham: .asciiz ": "	
# Cac cau nhac nhap/xuat du lieu
how_many_disks: .asciiz "Enter how many disk you would like to use for the tower of hanoi: "
str_tc:	.asciiz	"Thanh cong."
str_loi: .asciiz "Mo file bi loi."
#Code segment
.text
.globl main
main:	addi $a3, $zero, 0 	# $a3 = so thu tu buoc
	
	la	$a0,tenfile
	addi	$a1,$zero,1	# open with a1=1 (write-only)
	addi	$v0,$zero,13
	syscall
	
	bgez	$v0,tiep
	puts	str_loi		# mo file khong duoc
tiep:	sw	$v0,fdescr	#luu file descriptor
	
	la $a0, how_many_disks  #nhap so disk
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	
	or $a0, $v0, $zero	# $a0 = so dia
	addi $a1, $zero, 1	# $a1 = 1 (cot A)
	addi $a2, $zero, 3	# $a2 = 2 (cot C)
	jal hanoi
	
	addi	$v0,$zero,16	# dong file
	syscall
	
	la $a0, str_tc		# thanh cong
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 10         # exit
        syscall
hanoi:
	# a0 = so disk
	# a1 = start
	# a2 = end
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)	# s0 = number of disks
	sw $s1, 8($sp)	# s1 = start
	sw $s2, 12($sp)	# s2 = endPos
	sw $s3, 16($sp) # s3 = helper
	
	or $s0, $a0, $zero	
	or $s1, $a1, $zero
	or $s2, $a2, $zero
	
	# number of disks > 1
	addi $t0, $zero, 1
	slt $t1, $t0, $s0
	beq $t0, $t1, disks_greater_than_one 
	
	or $a0, $s1, $zero
	or $a1, $s2, $zero
	jal move_disk
	j end_hanoi
	
disks_greater_than_one:
	addi $s0, $s0, -1
	ori $t0, $zero, 6
	sub $t0, $t0, $s1
	sub $s3, $t0, $s2
	
	or $a0, $s0, $zero
	or $a1, $s1, $zero
	or $a2, $s3, $zero
	jal hanoi
	
	or $a0, $s1, $zero
	or $a1, $s2, $zero
	jal move_disk
	
	or $a0, $s0, $zero
	or $a1, $s3, $zero
	or $a2, $s2, $zero
	jal hanoi
	
end_hanoi:
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
	
#move_disk(from, endPos)
move_disk:
	addi $a3, $a3, 1	# tang so thu tu 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	or $t0, $a0, $zero 	# from variable
	or $t1, $a1, $zero 	# endPos variable
	
	puts buoc		# xuat ket qua ra man hinh
	add $a0, $zero, $a3
	addi $v0, $zero, 1
	syscall
	puts haicham
	

	lw	$a0,fdescr	# file descriptor
	
	la $a1, buoc		# xuat vao file
	addi $a2, $zero, 5
	addi $v0, $zero,15
	syscall
	
	addi $a1, $zero, 10	# xu ly so thu tu 
  	ori $t3, $a3, 0
  	addi $t2, $zero, 0
whloop1: beqz $t3, endwh1
	addi $t2, $t2, 1
	div $t3, $a1
	mflo $t3
	mfhi $a2
	addi $a2, $a2, 48
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	j whloop1
endwh1:
whloop2: beqz $t2, endwh2
	addi $t2, $t2, -1
	la $a1, 0($sp)
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	addi $sp, $sp, 4
	j whloop2
endwh2:	
	la $a1, haicham
	addi $a2, $zero, 2
	addi $v0, $zero, 15
	syscall
	
	ori $t2, $zero, 1	# chuyen doi so sang ki tu 1-->A; 2-->B; 3-->C
	beq $t2, $t0, then1
	ori $t2, $zero, 2
	beq $t2, $t0, then2
	la $a1, C 
	puts C
	j endif1
then2:
	la $a1, B
	puts B
	j endif1
then1:
	la $a1, A
	puts A
endif1:
	puts sang
	lw	$a0,fdescr	# file descriptor 
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	
	la $a1, sang
	addi $a2, $zero, 3
	addi $v0, $zero, 15
	syscall
	
	ori $t2, $zero, 1	# chuyen doi so sang ki tu 1-->A; 2-->B; 3-->C
	beq $t2, $t1, then3
	ori $t2, $zero, 2
	beq $t2, $t1, then4
	la $a1, C 
	puts C
	j endif2
then4:
	la $a1, B
	puts B
	j endif2
then3:
	la $a1, A
	puts A
endif2:
	puts end_line
	lw	$a0,fdescr	# file descriptor
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	
	la $a1, end_line
	addi $a2, $zero, 1
	addi $v0, $zero, 15
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
