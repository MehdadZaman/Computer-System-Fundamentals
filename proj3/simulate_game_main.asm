# This is example 4 from the PDF. You will need to adjust the size of the memory buffer
# to store the game state struct.
.data
state:
.byte 99
.byte 77
.asciiz "PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP" # not null-terminated during grading!
filename: .asciiz "game.txt"
moves: .asciiz "O500I212S916L508L310J607L609Z503S309Z719L418O619O806J511L506I610O101O520Z514S512"
rotated_piece: .asciiz "????????" # not null-terminated during testing!
num_pieces_to_drop: .word 20
pieces_array:
# T piece
.byte 2
.byte 3
.ascii "OOO.O."
# J piece
.byte 2
.byte 3
.ascii "OOO..O"
# Z piece
.byte 2
.byte 3
.ascii "OO..OO"
# O piece
.byte 2
.byte 2
.ascii "OOOO.."
# S piece
.byte 2
.byte 3
.ascii ".OOOO."
# L piece
.byte 2
.byte 3
.ascii "OOOO.."
# I piece
.byte 1
.byte 4
.ascii "OOOO.."


.text
main:

la $a0, state
la $a1, filename
la $a2, moves
la $a3, rotated_piece
addi $sp, $sp, -8
lw $t0, num_pieces_to_drop
sw $t0, 0($sp)
la $t0, pieces_array
sw $t0, 4($sp)
li $t0, 28132 # trashing $t0
jal simulate_game
addi $sp, $sp, 8

# report return values
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

move $a0, $v1
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# report the contents of the game state struct
la $t0, state
lb $a0, 0($t0)
li $v0, 1
#syscall

li $v0, 11
li $a0, ' '
#syscall

lb $a0, 1($t0)
li $v0, 1
#syscall

li $v0, 11
li $a0, ' '
#syscall

# replace this syscall 4 with some of your own code that prints the game field in 2D
move $a0, $t0
addi $a0, $a0, 2
li $v0, 4
#syscall

li $v0, 11
li $a0, '\n'
#syscall


la $t3, state
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

exit:
li $v0, 10
syscall

.include "proj3.asm"
