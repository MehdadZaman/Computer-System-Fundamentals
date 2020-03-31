.data
struct:
.byte 6
.byte 10
.asciiz "....................OOO.......OOOO.....OOOOOO....OOOOOOO..OO" # not null-terminated during grading!
row: .word 0
col: .word -1
character: .byte 'X'

.text
main:
la $a0, struct
lw $a1, row
lw $a2, col
lbu $a3, character
jal set_slot

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# report the contents of the struct
la $t0, struct
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

lb $a0, 1($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

# replace this syscall 4 with some of your own code that prints the game field in 2D
move $a0, $t0
addi $a0, $a0, 2
li $v0, 4
syscall

li $v0, 11
li $a0, '\n'
syscall

la $t3, struct
lb $t0, 0($t3) #rows
lb $t1, 1($t3) #cols
addi $t6, $t3, 2
li $t4, 0
outer_loop_print:
	beq $t4, $t0, done_outer_loop_print
	li $t5, 0 
	inner_loop_print:
		beq $t5, $t1, done_inner_loop_print
		li $v0, 11
		mul $t7, $t4, $t1
		add $t7, $t7, $t5
		add $t7, $t7, $t6
		lbu $a0, 0($t7)
		syscall
		addi $t5, $t5, 1
		j inner_loop_print
	done_inner_loop_print:
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t4, $t4, 1
	j outer_loop_print
done_outer_loop_print:

li $v0, 10
syscall

.include "proj3.asm"
