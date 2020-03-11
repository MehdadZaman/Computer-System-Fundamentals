.data
plaintext: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!!!!!!!!"
ciphertext: .asciiz "ZHFwS/xOoH-C*7$C"
key_square: .asciiz "68*be/x!1uSvE0t?U;$l-ci(4nak=)2CW5\'ZOHPDAwf7qIXs#mjF\"VrLN@3p:BRJzdygGhTYMoQ9 %.,K"
period: .word 2
index_buffer: .ascii "This is raw, memory - it could have any contents! Go SBU!!"
trash: .ascii "random garbage"
block_buffer: .ascii "RandomTrashYea"
junk: .ascii "More random garbage"

.text
.globl main
main:
la $a0, plaintext
la $a1, ciphertext
la $a2, key_square
lw $a3, period
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_decrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "proj2.asm"
