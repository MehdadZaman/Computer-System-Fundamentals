# CSE 220 Programming Project #3
# Mehdad Zaman
# mezaman
# 112323211

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text
initialize:
	#loading values into stack
	addi $sp, $sp, -16
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	move $s0, $a0 #struct
	move $s1, $a1 #num_rows
	move $s2, $a2 #num_columns
	move $s3, $a3 #character
	blez $s1, invalid_args_initialize #if rows < 0, jump to invalid
	blez $s2, invalid_args_initialize #if columns < 0, jump to invalid
	j valid_args_initialize #jump to valid
	invalid_args_initialize: #invalid args, loads negative values and jumps out
		li $v0, -1
		li $v1, -1
		#reallocating stack
		lw $s3, 0($sp)
		lw $s2, 4($sp)
		lw $s1, 8($sp)
		lw $s0, 12($sp)
		addi $sp, $sp, 16
		jr $ra
	valid_args_initialize: #args are valid, so processes
		sb $s1, 0($s0) #store rows into first byte of struct
		sb $s2, 1($s0) #store columns into second byte of struct
		addi $s0, $s0, 2 #add memory address of struct to store etc.
		li $t0, 0 #outer loop counter
		outer_loop_initialize:
			beq $t0, $s1, done_outer_loop_initialize #if outer loop counter, reaches rows, jump
			li $t1, 0 #inner loop counter
			inner_loop_initialize:
				beq $t1, $s2, done_inner_loop_initialize #if inner loop counter, reaches columns, jump
				sb $s3, 0($s0) #store character into struct location
				addi $s0, $s0, 1 #add to location in struct
				addi $t1, $t1, 1 #inc column counter
				j inner_loop_initialize
			done_inner_loop_initialize:
			addi $t0, $t0, 1 #inc row counter
			j outer_loop_initialize
		done_outer_loop_initialize:
			move $v0, $s1 #move rows to $v0
			move $v1, $s2 #move columns to $v1
			#reallocating stack
			lw $s3, 0($sp)
			lw $s2, 4($sp)
			lw $s1, 8($sp)
			lw $s0, 12($sp)
			addi $sp, $sp, 16
			jr $ra
			
load_game:
	#loading values into stack
	addi $sp, $sp, -28
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	move $s0, $a0 #gamestate
	move $s1, $a1 #filename
	#process of flagging stuff out
	li $v0, 13
	move $a0, $s1
	li $a1, 0
	syscall
	move $s2, $v0
	#checks if file is invalid
	bgez $s2, valid_file_load_game
		li $v0, -1
		li $v1, -1
		#reallocating stack
		lw $s6, 0($sp)
		lw $s5, 4($sp)
		lw $s4, 8($sp)
		lw $s3, 12($sp)
		lw $s2, 16($sp)
		lw $s1, 20($sp)
		lw $s0, 24($sp)
		addi $sp, $sp, 28
		jr $ra
	#processing valid row
	valid_file_load_game:
		#reads first alphanumeric
		li $v0, 14
		move $a0, $s2
		addi $sp, $sp, -4
		move $a1, $sp
		li $a2, 1
		syscall
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		#reads first alphanumeric
		li $v0, 14
		move $a0, $s2
		addi $sp, $sp, -4
		move $a1, $sp
		li $a2, 1
		syscall
		lw $t1, 0($sp)
		addi $sp, $sp, 4
		#if it is a next line char, jump to only add one digit
		li $t2, '\n'
		beq $t1, $t2, row_isnextline__load_game
			#else process both chars and make into a two digit byte
			addi $t0, $t0, -48
			addi $t1, $t1, -48
			li $t2, 10
			mul $t3, $t0, $t2
			add $t3, $t3, $t1
			move $s3, $t3
			#store it into gamestate and inc gamestate memory
			sb $t3, 0($s0)
			addi $s0, $s0, 1	
			#just reads of the next \n to go to the next line
			li $v0, 14
			move $a0, $s2
			addi $sp, $sp, -4
			move $a1, $sp
			li $a2, 1
			syscall
			lw $t1, 0($sp)
			addi $sp, $sp, 4	
			#jump to process column
			j process_col_num_load_game
		#processes one digit only and stores it and incs memory
		row_isnextline__load_game:
			addi $t0, $t0, -48
			move $s3, $t0
			sb $t0, 0($s0)
			addi $s0, $s0, 1
		process_col_num_load_game:
			#process first column digit
			li $v0, 14
			move $a0, $s2
			addi $sp, $sp, -4
			move $a1, $sp
			li $a2, 1
			syscall
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			#process second column digit
			li $v0, 14
			move $a0, $s2
			addi $sp, $sp, -4
			move $a1, $sp
			li $a2, 1
			syscall
			lw $t1, 0($sp)
			addi $sp, $sp, 4
		#if second column digit is '\n', jump to only process one
		li $t2, '\n'
		beq $t1, $t2, col_isnextline__load_game
			#process two and convert into a byte
			addi $t0, $t0, -48
			addi $t1, $t1, -48
			li $t2, 10
			mul $t3, $t0, $t2
			add $t3, $t3, $t1
			move $s4, $t3
			#store into gamestate and inc gamestate
			sb $t3, 0($s0)
			addi $s0, $s0, 1
			#just reads of the next \n to go to the next line
			li $v0, 14
			move $a0, $s2
			addi $sp, $sp, -4
			move $a1, $sp
			li $a2, 1
			syscall
			lw $t1, 0($sp)
			addi $sp, $sp, 4	
			j process_game_board_load_game
		col_isnextline__load_game:
			#process only if one char and inc memory address
			addi $t0, $t0, -48
			move $s4, $t0
			sb $t0, 0($s0)
			addi $s0, $s0, 1
		#start processing rest of tetris board
		process_game_board_load_game:
			mul $t0, $s3, $s4
			li $t1, 0 #loop process counter
			li $s5, 0 #O counter
			li $s6, 0 #invalid char counter
		loop_read_each_byte_load_game:
			beq $t1, $t0, done_process_state_load_game #branch if counter is eqaul to row * col
			#load each char into $t2
			li $v0, 14
			move $a0, $s2
			addi $sp, $sp, -4
			move $a1, $sp
			li $a2, 1
			syscall
			lw $t2, 0($sp)
			addi $sp, $sp, 4
			#if processed char is next line char, skip upcount
			li $t3, '\n'
			beq $t2 ,$t3, next_line_char_load_game
			#if not equal to O, then jump to process other char
			li $t3, 'O'
			bne $t2 ,$t3, not_placed_char_load_game
				#if is 'O', then put into game state
				li $t3, 'O'
				sb $t3, 0($s0)
				#inc mem address and counter
				addi $s0, $s0, 1
				addi $t1, $t1, 1
				#adds to O counter
				addi $s5, $s5, 1
				#jump to go around
				j next_line_char_load_game
			not_placed_char_load_game:
				#store . into gamestate andinc counter and mem address
				li $t3, '.'
				sb $t3, 0($s0)
				addi $s0, $s0, 1
				addi $t1, $t1, 1
				li $t3, '.'
				beq $t2, $t3, valid_period_counter_load_game
					#inc invalid char counter
					addi $s6, $s6, 1
				valid_period_counter_load_game:
			#continue process
			next_line_char_load_game:
			j loop_read_each_byte_load_game
			done_process_state_load_game:
		 	move $v0, $s5
		 	move $v1, $s6
		 	#reallocating stack
			lw $s6, 0($sp)
			lw $s5, 4($sp)
			lw $s4, 8($sp)
			lw $s3, 12($sp)
			lw $s2, 16($sp)
			lw $s1, 20($sp)
			lw $s0, 24($sp)
			addi $sp, $sp, 28
    		jr $ra

get_slot:
	#allocate stack
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	move $s0, $a0 #struct
	move $s1, $a1 #row
	move $s2, $a2 #col
	#load row and columns
	lb $t0, 0($s0)
	lb $t1, 1($s0)
	#inc memory address by 2
	addi $s0, $s0, 2
	#jump for invalid args
	bltz $s1, invalid_args_get_slot
	bltz $s2, invalid_args_get_slot
	bge $s1, $t0, invalid_args_get_slot
	bge $s2, $t1, invalid_args_get_slot
	#all else, jumps if valid
	j valid_args_get_slot
		#invalid arg process
		invalid_args_get_slot:
		#load in -1 because invalid
		li $v0, -1
		#deallocate stack
		lw $s2, 0($sp)
		lw $s1, 4($sp)
		lw $s0, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		valid_args_get_slot:
			#go down by rows
			mul $t3, $s1, $t1
			#add by colums
			add $t3, $t3, $s2
			#go to correct place in memory
			add $s0, $s0, $t3
			#load byte into $v0
			lb $v0, 0($s0)
			#deallocate stack
			lw $s2, 0($sp)
			lw $s1, 4($sp)
			lw $s0, 8($sp)
			addi $sp, $sp, 12
    		jr $ra

set_slot:
	#allocate stack
	addi $sp, $sp, -16
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	move $s0, $a0 #struct
	move $s1, $a1 #row
	move $s2, $a2 #col
	move $s3, $a3 #character
	#load row and columns
	lb $t0, 0($s0)
	lb $t1, 1($s0)
	#inc memory address by 2
	addi $s0, $s0, 2
	#jump for invalid args
	bltz $s1, invalid_args_set_slot
	bltz $s2, invalid_args_set_slot
	bge $s1, $t0, invalid_args_set_slot
	bge $s2, $t1, invalid_args_set_slot
	#all else, jumps if valid
	j valid_args_set_slot
		#invalid arg process
		invalid_args_set_slot:
		#load in -1 because invalid
		li $v0, -1
		#deallocate stack
		lw $s3, 0($sp)
		lw $s2, 4($sp)
		lw $s1, 8($sp)
		lw $s0, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		valid_args_set_slot:
			#go down by rows
			mul $t3, $s1, $t1
			#add by colums
			add $t3, $t3, $s2
			#go to correct place in memory
			add $s0, $s0, $t3
			#stores char into correct memory address
			sb $s3, 0($s0)
			#puts correct char into return
			move $v0, $s3
			#deallocate stack
			lw $s3, 0($sp)
			lw $s2, 4($sp)
			lw $s1, 8($sp)
			lw $s0, 12($sp)
			addi $sp, $sp, 16
    		jr $ra

rotate:
	#reallocate stack
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp) 
	sw $s5, 8($sp)
	sw $s6, 4($sp) 
	sw $s7, 0($sp)
	move $s0, $a0 #piece*
	move $s1, $a1 #rotation
	move $s7, $s1 #copy of number of rotations
	move $s2, $a2 #rotated_piece*
	#using the stack to store my original piece* bytes
	addi $sp, $sp, -8
	move $a0, $s0 #src
	li $a1, 0 #src_pos
	move $a2, $sp #dest
	li $a3, 0 #dest_pos
	li $t0, 8 #length
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal bytecopy
	addi $sp, $sp, 4
	#if rotation is less than 0, jump to invalid
	bltz $s1, invalid_process_rotate
	lb $s3, 0($s0) #rows
	lb $s4, 1($s0) #columns
	#if the piece is an I block, jump to process I block
	li $t2, 4
	beq $s3, $t2, I_block_case_rotate
	li $t2, 4
	beq $s4, $t2, I_block_case_rotate
	#if the sum of rows and columns is 4 (O block), jump there
	add $t2, $s3, $s4
	li $t3, 4
	beq $t2, $t3, O_block_case_rotate
	#all other blocks which are three and two
	li $t3, 5
	beq $t2, $t3, Twoby3or3by2_case_rotate
	#all other cases are wrong
	j invalid_process_rotate
	Twoby3or3by2_case_rotate:
	#copy piece to rotated_piece in case $s1 is 0
	move $a0, $s0 #src
	li $a1, 0 #src_pos
	move $a2, $s2 #dest
	li $a3, 0 #dest_pos
	li $t0, 8 #length
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal bytecopy
	addi $sp, $sp, 4
	#$s1 has number of rotations
		#loop to rotate block $s1 times
		loop_rotate_2332_block_case_rotate:
			#if $s1 is 0, jump out (finished processing)
			beqz $s1, done_loop_rotate_2332_block_case_rotate
			#$s0: piece*
			#$s2: rotated_piece*
			lb $s3, 0($s0) #rows of first piece
			lb $s4, 1($s0) #columns of first piece
			#initialize the new rotated brick (switch around rows and cols)
			move $a0, $s2 #struct
			move $a1, $s4 #num_rows
			move $a2, $s3 #num_cols
			li $t0, '.'
			move $a3, $t0 #character
			jal initialize
    		#$s3 has rows, $s4 has cols of original block
    		#sb $s4, 0($s2) #store row into byte 0
    		#sb $s3, 1($s2) #store col into byte 1
    		li $s5, 0 #row counter (outer)
    		outerloop_2332_block_case_rotate:
    			#if row count has been reached, jump
    			beq $s5, $s3, done_outerloop_2332_block_case_rotate
    			li $s6, 0 #col counter (inner)
    			innerloop_2332_block_case_rotate:
    				#if col count has been reached, jump
    				beq $s6, $s4, done_innerloop_2332_block_case_rotate
    				#load byte from previous piece
    				move $a0, $s0 #struct
					move $a1, $s5 #row 
					move $a2, $s6 #col
					jal get_slot
					#store into correct location in new piece
					#adjusts value to find column of next rotated block
					sub $t1, $s3, $s5
					addi $t1, $t1, -1
					move $a0, $s2 #rotated piece
					move $a1, $s6 #row (same as previous blocks column)
					move $a2, $t1 #the adjusted piece
					move $a3, $v0 #the copied character
					jal set_slot
					addi $s6, $s6, 1 #inc col counter
					#jump back
					j innerloop_2332_block_case_rotate
    				done_innerloop_2332_block_case_rotate:
    			#inc row counter
    			addi $s5, $s5, 1
    			#jump back
    			j outerloop_2332_block_case_rotate
    		#done process
    		done_outerloop_2332_block_case_rotate:
    		#$s2 has new block
			#moving new block to original
			#$s0: piece*
			#$s2: rotated_piece*
			move $a0, $s2 #src
			li $a1, 0 #src_pos
			move $a2, $s0 #dest
			li $a3, 0 #dest_pos
			li $t0, 8 #length
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			jal bytecopy
			addi $sp, $sp, 4
			#decrease number of rotations
			addi $s1, $s1, -1
			#jump back to rotate another time
			j loop_rotate_2332_block_case_rotate
		done_loop_rotate_2332_block_case_rotate:
		#jump to end
		j done_rotation_rotate
	#process I block
	I_block_case_rotate:
	#copy piece to rotated_piece in case $s1 is 0
	move $a0, $s0 #src
	li $a1, 0 #src_pos
	move $a2, $s2 #dest
	li $a3, 0 #dest_pos
	li $t0, 8 #length
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal bytecopy
	addi $sp, $sp, 4
		#$s1 has number of rotations
		loop_rotate_I_block_case_rotate:
			#if rotations reach 0, done rotating
			beqz $s1, done_loop_rotate_I_block_case_rotate
			#$s0: piece*
			#$s2: rotated_piece*
			lb $s3, 0($s0)
			lb $s4, 1($s0)
			#$s0: piece*
			#$s2: rotated_piece*
			#copy original piece into rotated piece
			move $a0, $s0 #src
			li $a1, 0 #src_pos
			move $a2, $s2 #dest
			li $a3, 0 #dest_pos
			li $t0, 8 #length
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			jal bytecopy
			addi $sp, $sp, 4
    		#$s3 has rows, $s4 has cols
    		#store in oppostie order as original
    		sb $s4, 0($s2) #store row into byte 0
    		sb $s3, 1($s2) #store col into byte 1
    		#switch new with original to keep rotating
    		#$s3 has rows
    		#$s4 has cols
    		move $a0, $s2 #src
			li $a1, 0 #src_pos
			move $a2, $s0 #dest
			li $a3, 0 #dest_pos
			li $t0, 8 #length
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			jal bytecopy
			addi $sp, $sp, 4
			#decrease number of rotations
			addi $s1, $s1, -1
			#jump back to continue rotating
			j loop_rotate_I_block_case_rotate
		done_loop_rotate_I_block_case_rotate:
			#jump out
			j done_rotation_rotate
	#process O block	
	O_block_case_rotate:
	#copy piece to rotated_piece in case $s1 is 0
	move $a0, $s0 #src
	li $a1, 0 #src_pos
	move $a2, $s2 #dest
	li $a3, 0 #dest_pos
	li $t0, 8 #length
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal bytecopy
	addi $sp, $sp, 4
		#just byte copy in this case and jump out
		#$s0: piece*
		#$s2: rotated_piece*
		move $a0, $s0 #src
		li $a1, 0 #src_pos
		move $a2, $s2 #dest
		li $a3, 0 #dest_pos
		li $t0, 8 #length
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal bytecopy
		addi $sp, $sp, 4
    #jump out
    j done_rotation_rotate
    #invalid processing
    invalid_process_rotate:
    li $s7, -1
    done_rotation_rotate:
	#using the stack to restore my original piece* bytes
	move $a0, $sp #src
	li $a1, 0 #src_pos
	move $a2, $s0 #dest
	li $a3, 0 #dest_pos
	li $t0, 8 #length
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal bytecopy
	addi $sp, $sp, 4
    addi $sp, $sp, 8
    #return value
    move $v0, $s7
    #reallocate values
    lw $s7, 0($sp) 
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp) 
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    jr $ra

count_overlaps:
	#reallocate stack
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp) 
	sw $s5, 8($sp)
	sw $s6, 4($sp) 
	sw $s7, 0($sp)
	move $s0, $a0 #state
	move $s1, $a1 #row
	move $s2, $a2 #col
	move $s3, $a3 #piece
	#if $s1 or $$s2 are invalid numbers for row and col jump out, 
	bltz $s1, invalid_placement_count_overlaps
	bltz $s2, invalid_placement_count_overlaps
	li $s7, 0 #overlap counter
	li $s5, 0 #row counter
	outer_row_loop_count_overlaps:
		lb $t0, 0($s3) #compares row number
		beq $s5, $t0, done_outer_row_loop_count_overlaps #if reached, jump out
		li $s6, 0 #col counter
		inner_row_loop_count_overlaps:
			lb $t0, 1($s3) #compares col number
			beq $s6, $t0, done_inner_row_loop_count_overlaps #if reached, jump out
			move $a0, $s3 #piece struct
			move $a1, $s5 #row
			move $a2, $s6 #column
			jal get_slot
			li $t0, '.' #if no O, then doesn't matter
			beq $v0, $t0, continue_search_process_count_overlaps
				#check same location in gameboard
				move $a0, $s0 #gamestate
				add $a1, $s5, $s1 #adds row counter to original row
				add $a2, $s6, $s2 #adds col counter to original col
				jal get_slot
				li $t0, -1 #if invalid, then jump
				beq $v0, $t0, invalid_placement_count_overlaps
				li $t0, '.' #if . then doesn't matter
				beq $v0, $t0, continue_search_process_count_overlaps
				addi $s7, $s7, 1 #all else, add to the counter
			continue_search_process_count_overlaps:
			addi $s6, $s6, 1 #inc col counter
			j inner_row_loop_count_overlaps #jump back col
		done_inner_row_loop_count_overlaps:
		addi $s5, $s5, 1 #inc row counter
		j outer_row_loop_count_overlaps #jump back to row
	done_outer_row_loop_count_overlaps: #done row counting
		j valid_process_count_overlaps #jump to valid because process valid
	invalid_placement_count_overlaps:	#process invalid
		li $s7, -1
	valid_process_count_overlaps: 
		move $v0, $s7 #return value
	#reallocate values
    lw $s7, 0($sp) 
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp) 
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    jr $ra

drop_piece:
	lw $t0, 0($sp)
	#reallocate stack
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp) 
	sw $s5, 4($sp)
	sw $s6, 0($sp) 
	move $s0, $a0 #state
	move $s1, $a1 #col
	move $s2, $a2 #piece
	move $s3, $a3 #rotation
	move $s4, $t0 #rotated_piece
	#if rotation is negative, jump to -2
	bltz $s3, invalid_process_neg2_drop_piece
	#if col is negative, jump to -2
	bltz $s1, invalid_process_neg2_drop_piece
	#load column of game state and if col is greater than gamestate, jump to -2
	lb $t0, 1($s0)
	bge $s1, $t0, invalid_process_neg2_drop_piece
		#calling the rotate function to rotate piece
		move $a0, $s2 #piece
		move $a1, $s3 #rotation
		move $a2, $s4 #rotated_piece
		jal rotate
		#now $s4 has the new rotated piece
		#count overalps at row 0
		move $a0, $s0 #state
		li $a1, 0 #row
		move $a2, $s1 #col
		move $a3, $s4 #rotated-piece
		jal count_overlaps
		#if not in boundaries, jump to -3
		bltz $v0, invalid_process_neg3_drop_piece
		#if has overlaps , game end, and jump to -1
		bgtz $v0, invalid_process_neg1_drop_piece
		#start traversing down rows
		li $s5, 0 #column counter
		loop_traversing_column_drop_piece:
			#count overlaps at each row
			#now use counter_overlaps to find accurate placement
			move $a0, $s0 #state
			move $a1, $s5 #row
			move $a2, $s1 #col
			move $a3, $s4 #rotated-piece
			jal count_overlaps
			#if greater than 0, jump out
			bgtz $v0, set_piece_drop_piece
			#if less than 0, jump out
			bltz $v0, set_piece_drop_piece
			#inc row counter
			addi $s5, $s5, 1
			#jump back
			j loop_traversing_column_drop_piece
		#now complete
		set_piece_drop_piece:
			#add -1 to find previous valid row
			#load function and place piece
			addi $s6, $s5, -1 #$s6 has the correct row number
			#call new place piece function
			move $a0, $s0 #state
			move $a1, $s6 #row
			move $a2, $s1 #col
			move $a3, $s4 #piece
			jal place_piece
			#return col value
			move $v0, $s6 #return value of correct row
		#jump to end
		j process_complete_valid_or_invalid_drop_piece
	invalid_process_neg2_drop_piece:
		li $v0, -2
		j process_complete_valid_or_invalid_drop_piece
	invalid_process_neg3_drop_piece:
		li $v0, -3
		j process_complete_valid_or_invalid_drop_piece
	invalid_process_neg1_drop_piece:
		li $v0, -1
		j process_complete_valid_or_invalid_drop_piece
		#process complete
	process_complete_valid_or_invalid_drop_piece:
		#reallocate values
		lw $s6, 0($sp)
		lw $s5, 4($sp)
		lw $s4, 8($sp)
		lw $s3, 12($sp) 
		lw $s2, 16($sp)
		lw $s1, 20($sp)
		lw $s0, 24($sp)
		lw $ra, 28($sp)
		addi $sp, $sp, 32
		jr $ra

check_row_clear:
	#reallocate stack
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp) 
	move $s0, $a0 #state
	move $s1, $a1 #row
	#if row is less than 0, jump to invalid
	bltz $s1, process_fail_invalid_row_clear
	#if it is greater than or eqaul to number of rows in state, invalid
	lb $t0, 0($s0)
	bge $s1, $t0, process_fail_invalid_row_clear
	lb $s2, 1($s0) #num of columns
	li $s3, 0 #column counter
	#runs through the row and sees if it is ready to be cleared
	loop_col_iterator_check_row_clear:
		#if all elements have been checked, then successful
		beq $s3, $s2, process_sucess_check_row_clear
		#get the character at the rowth col spot
		move $a0, $s0 #struct
		move $a1, $s1 #row
		move $a2, $s3 #col
		jal get_slot
		#if it is ., then cannot be cleard, so jump
		li $t0, '.'
		beq $v0, $t0, process_fail_check_row_clear
		#inc col count
		addi $s3, $s3, 1
		#jump back to process next
		j loop_col_iterator_check_row_clear
	process_sucess_check_row_clear:
		#$s2 has number of columns
		#$s3 now is always one row above $s1
		addi $s3, $s1, -1
		#$s1 has the number of rows
		#$s0 has state
		outer_loop_move_rows_down_check_row_clear:
			#if $s3 is less than 0, done processing
			bltz $s3, done_outer_loop_move_rows_down_check_row_clear
			li $s4, 0 #col counter
			inner_loop_move_rows_down_check_row_clear:
				#if col counter == number of cols, jump
				beq $s4, $s2, done_inner_loop_move_rows_down_check_row_clear
				#get byte at  row above
				move $a0, $s0 #struct
				move $a1, $s3 #row
				move $a2, $s4 #col
				jal get_slot
				#put it one row down
				move $a0, $s0 #struct
				move $a1, $s1 #row
				move $a2, $s4 #col
				move $a3, $v0 #character
				jal set_slot
				#add to col counter
				addi $s4, $s4, 1
				j inner_loop_move_rows_down_check_row_clear
			done_inner_loop_move_rows_down_check_row_clear:
			#decrement row copied from and row copied to
			addi $s1, $s1, -1
			addi $s3, $s3, -1
				j outer_loop_move_rows_down_check_row_clear
		done_outer_loop_move_rows_down_check_row_clear:
			#now put . chars in all of row 0
			#$s2 has number of columns
			li $s4, 0
			loop_set_row0_to_empty_check_row_clear:
				#if col counter == number of cols, jump
				beq $s4, $s2, done_loop_set_row0_to_empty_check_row_clear
				#set each char in the col of first row to.
				move $a0, $s0 #struct
				li $a1, 0 #row
				move $a2, $s4 #col
				li $a3, '.' #character
				jal set_slot
				#inc col counter
				addi $s4, $s4, 1
				j loop_set_row0_to_empty_check_row_clear
			done_loop_set_row0_to_empty_check_row_clear:
				#now load that process is valid
				li $v0, 1
				j end_process_invalid_or_invalid_row_clear
	#invalid processes
	process_fail_invalid_row_clear:
		li $v0, -1
		j end_process_invalid_or_invalid_row_clear
	#invalid processes
	process_fail_check_row_clear:
		li $v0, 0
		j end_process_invalid_or_invalid_row_clear
	#all processes end up here
	end_process_invalid_or_invalid_row_clear:
		lw $s4, 0($sp)
		lw $s3, 4($sp) 
		lw $s2, 8($sp)
		lw $s1, 12($sp)
		lw $s0, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24	
	jr $ra

simulate_game:
	lw $t0, 0($sp) #num_pieces_to_drop
	lw $t1, 4($sp) #pieces_array
	#reallocate stack
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp) 
	sw $s5, 8($sp)
	sw $s6, 4($sp) 
	sw $s7, 0($sp)
	move $s0, $a0 #state
	move $s1, $a1 #filename
	move $s2, $a2 #moves
	move $s3, $a3 #rotated_piece
	move $s4, $t0 #num_pieces_to_drop
	move $s5, $t1 #pieces_array
	#load game from file into state
	move $a0, $s0 #state
	move $a1, $s1 #filename
	jal load_game
	#if load_game(state, filename)[1] == (-1, -1) then return 0, 0
	bgez, $v0, continue_simulate_game 
		li $v0, 0
		li $v1, 0
		j end_simulate_game
	#continue because file is valid
	continue_simulate_game:
	#allocating space to use variables in the stack
	addi $sp, $sp, -20
	li $s6, 0 #num_successful_drops
	li $s7, 0 #move_number
	#moves_length = len(moves = $s2) / 4
	move $a0, $s2
	jal strlen
	li $t0, 4
	div $v0, $t0
	mflo $t0
	sw $t0, 0($sp) #moves_length
	li $t0, 0
	sw $t0, 4($sp) #game_over
	li $t0, 0
	sw $t0, 8($sp) #score
	#while loop to run tetris game
	outer_while_loop_simulate_game:
		#if game_over, jump
		lw $t0, 4($sp)
		bgtz $t0, game_end_simulate_game
		#if num_successful_drops >= num_pieces_to_drop, jump
		bge $s6, $s4, game_end_simulate_game
		#if move_number >= moves_length, jump
		lw $t0, 0($sp)
		bge $s7, $t0, game_end_simulate_game
		#extract the next piece, column and rotation from the string
		li $t0, 4 
		mul $t0, $s7, $t0 #multiply 4 and move number
		add $t0, $t0, $s2 #add move in string to original string value
		#load variables
		lb $t1, 0($t0) #letter (piece type)
		lb $t2, 1($t0) #rotations
		lb $t3, 2($t0) #first digit
		lb $t4, 3($t0) # second digit
		addi $t2, $t2, -48 #$t2 now has "number" of rotations
		addi $t3, $t3, -48 #$t3 now has number first digit
		addi $t4, $t4, -48 #$t4 now has number second digit
		li $t5, 10
		mul $t3, $t3, $t5 #multiply 10s place digit in order to get tens value
		add $t3, $t3, $t4 #now add the one's place
		#$t1 = letter (piece)
		#$t2 = num of rotations
		#$t3 = col number
		#invalid : boolean is needed
		li $t0, 0
		sw $t0, 12($sp) #invalid
		#$s5 has pieces array
		#if piece_type == ’T’ then
		#piece = pieces_array[0]
		li $t4, 'T'
		beq $t1, $t4, letter_found_T_simulate_game
		j continue_search__notT_letter_simulate_game
			letter_found_T_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 0
				j continue_letter_found_complete_simulate_game	
		continue_search__notT_letter_simulate_game:
		#elif piece_type == ’J’ then
		#piece = pieces_array[1]		
		li $t4, 'J'
		beq $t1, $t4, letter_found_J_simulate_game
		j continue_search__notJ_letter_simulate_game
			letter_found_J_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 8
				j continue_letter_found_complete_simulate_game	
		continue_search__notJ_letter_simulate_game:
		#elif piece_type == ’Z’ then
		#piece = pieces_array[2]		
		li $t4, 'Z'
		beq $t1, $t4, letter_found_Z_simulate_game
		j continue_search__notZ_letter_simulate_game
			letter_found_Z_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 16
				j continue_letter_found_complete_simulate_game	
		continue_search__notZ_letter_simulate_game:
		#elif piece_type == ’O’ then
		#piece = pieces_array[3]		
		li $t4, 'O'
		beq $t1, $t4, letter_found_O_simulate_game
		j continue_search__notO_letter_simulate_game
			letter_found_O_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 24
				j continue_letter_found_complete_simulate_game	
		continue_search__notO_letter_simulate_game:
		#elif piece_type == ’S’ then
		#piece = pieces_array[4]	
		li $t4, 'S'
		beq $t1, $t4, letter_found_S_simulate_game
		j continue_search__notS_letter_simulate_game
			letter_found_S_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 32
				j continue_letter_found_complete_simulate_game	
		continue_search__notS_letter_simulate_game:
		#elif piece_type == ’L’ then
		#piece = pieces_array[5]		
		li $t4, 'L'
		beq $t1, $t4, letter_found_L_simulate_game
		j continue_search__notL_letter_simulate_game
			letter_found_L_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 40
				j continue_letter_found_complete_simulate_game	
		continue_search__notL_letter_simulate_game:
		#elif piece_type == ’I’ then
		#piece = pieces_array[6]		
		li $t4, 'I'
		beq $t1, $t4, letter_found_I_simulate_game
		j continue_search__notI_letter_simulate_game
			letter_found_I_simulate_game:
			#put plain piece in $t5
				addi $t5, $s5, 48
				j continue_letter_found_complete_simulate_game	
		continue_search__notI_letter_simulate_game:
		#letter found so continue process
	continue_letter_found_complete_simulate_game:
		#$t5 has piece
		#$t2 = num of rotations
		#$t3 = col number
		#drop piece
		move $a0, $s0 #state
		move $a1, $t3 #col
		move $a2, $t5 #piece
		move $a3, $t2 #rotation	
		move $t0, $s3 #rotated_piece
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal drop_piece
		addi $sp, $sp, 4
		#if drop piece = -1
		li $t0, -1
		beq $v0, $t0, result_neg1_simulate_game
		#if drop piece = -2
		li $t0, -2
		beq $v0, $t0, result_neg2or3_simulate_game
		#if drop piece = -3
		li $t0, -3
		beq $v0, $t0, result_neg2or3_simulate_game
		#if drop piece = valid
		j valid_result_simulate_game
		#else if result == -1 then game_over = True
		result_neg1_simulate_game:
			li $t0, 1
			sw $t0, 4($sp) #game_over
		#if result == -1 then invalid = True
		#if result == -2 or result == -3 then invalid = True
		result_neg2or3_simulate_game:
			li $t0, 1
			sw $t0, 12($sp) #invalid
		#if invalid == True then move_number += 1, and jump back
		lw $t0, 12($sp)
		beqz $t0, continue_process_invalid_false_simulate_game
			addi $s7, $s7, 1
			j outer_while_loop_simulate_game
		#continue process because valid
		continue_process_invalid_false_simulate_game:
		#continue process because valid
		valid_result_simulate_game:
			#process all rows to see if the can be cleared: moving up to down
			lb $s1, 0($s0) #row of gameboard
			addi $s1, $s1, -1 #r
			#8($sp) = score
			li $t0, 0 #count
			sw $t0, 16($sp)
			loop_check_row_clear_simulate_game:
				bltz $s1, done_loop_check_row_clear_simulate_game
				move $a0, $s0 #state
				move $a1, $s1 #row
				jal check_row_clear
				beqz $v0, check_row_equals0_clear_simulate_game
					lw $t0, 16($sp)
					addi $t0, $t0, 1
					sw $t0, 16($sp)
					j loop_check_row_clear_simulate_game
				check_row_equals0_clear_simulate_game:
					addi $s1, $s1, -1
					j loop_check_row_clear_simulate_game
			done_loop_check_row_clear_simulate_game:
				#loading count
				lw $t1, 16($sp)	
		#if count == 1		
		li $t4, 1
		beq $t1, $t4, score_is1_simulate_game
		j continue_search__score_not1_simulate_game
			score_is1_simulate_game:
				#inc score count
				lw $t0, 8($sp) #score
				addi $t0, $t0, 40
				sw $t0, 8($sp) #score
				j continue_score_tracker_simulate_game
		continue_search__score_not1_simulate_game:
		#if count == 2		
		li $t4, 2
		beq $t1, $t4, score_is2_simulate_game
		j continue_search__score_not2_simulate_game
			score_is2_simulate_game:
				#inc score count
				lw $t0, 8($sp) #score
				addi $t0, $t0, 100
				sw $t0, 8($sp) #score
				j continue_score_tracker_simulate_game
		continue_search__score_not2_simulate_game:
		#if count == 3		
		li $t4, 3
		beq $t1, $t4, score_is3_simulate_game
		j continue_search__score_not3_simulate_game
			score_is3_simulate_game:
				#inc score count
				lw $t0, 8($sp) #score
				addi $t0, $t0, 300
				sw $t0, 8($sp) #score
				j continue_score_tracker_simulate_game
		continue_search__score_not3_simulate_game:
		#if count == 4		
		li $t4, 4
		beq $t1, $t4, score_is4_simulate_game
		j continue_search__score_not4_simulate_game
			score_is4_simulate_game:
				#inc score count
				lw $t0, 8($sp) #score
				addi $t0, $t0, 1200
				sw $t0, 8($sp) #score
				j continue_score_tracker_simulate_game
		continue_search__score_not4_simulate_game:
		#continue score tracker
		continue_score_tracker_simulate_game:
			addi $s6, $s6, 1 #num_successful_drops
			addi $s7, $s7, 1 #move_number
			#jump all th way back to process next move
			j outer_while_loop_simulate_game
			#game over or all moves loaded into state
		game_end_simulate_game:
			move $v0, $s6 #num_successful_drops
			lw $t0, 8($sp) #score
			move $v1, $t0
			addi $sp, $sp, 20
	#end game valid or invalid
	end_simulate_game:
	#load memory back into registers
		lw $s7, 0($sp) 
		lw $s6, 4($sp)
		lw $s5, 8($sp)
		lw $s4, 12($sp)
		lw $s3, 16($sp) 
		lw $s2, 20($sp)
		lw $s1, 24($sp)
		lw $s0, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36
		jr $ra

place_piece:
	#reallocate stack
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp) 
	sw $s5, 4($sp)
	sw $s6, 0($sp) 
	move $s0, $a0 #state
	move $s1, $a1 #row
	move $s2, $a2 #col
	move $s3, $a3 #piece
	li $s5, 0 #row counter
	outer_row_loop_place_piece:
		lb $t0, 0($s3) #compares row number
		beq $s5, $t0, done_outer_row_loop_place_piece #if reached, jump out
		li $s6, 0 #col counter
		inner_row_loop_place_piece:
			lb $t0, 1($s3) #compares col number
			beq $s6, $t0, done_inner_row_loop_place_piece #if reached, jump out
			move $a0, $s3 #piece struct
			move $a1, $s5 #row
			move $a2, $s6 #column
			jal get_slot
			li $t0, '.' #if no O, then doesn't matter
			beq $v0, $t0, continue_search_process_place_piece
				#check same location in gameboard
				move $a0, $s0 #gamestate
				add $a1, $s5, $s1 #adds row counter to original row
				add $a2, $s6, $s2 #adds col counter to original col
				move $a3, $v0 #character to place in new spot
				jal set_slot
			continue_search_process_place_piece:
			addi $s6, $s6, 1 #inc col counter
			j inner_row_loop_place_piece #jump back col
		done_inner_row_loop_place_piece:
		addi $s5, $s5, 1 #inc row counter
		j outer_row_loop_place_piece #jump back to row
	done_outer_row_loop_place_piece: #done row counting
	#reallocate values
	lw $s6, 0($sp)
	lw $s5, 4($sp)
	lw $s4, 8($sp)
	lw $s3, 12($sp) 
	lw $s2, 16($sp)
	lw $s1, 20($sp)
	lw $s0, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	jr $ra

bytecopy:
	lw $t0, 0($sp) #$t0 = the length from stack
	addi $sp, $sp, 4 #push stack pointer after value loaded
	#$a0 contains src
	#$a1 contains src_pos
	#$a2 contains dest
	#$a3 contains dest_pos
	#$t0 contains length
	li $t1, 0
	li $v0, -1
	ble $t0, $t1, done_bytecopy #jump if length <= 0
	blt $a1, $t1, done_bytecopy #jump if src_pos < 0
	blt $a3, $t1, done_bytecopy #jump if dst_pos < 0
	li $v0, 0 #return counter
	add $t2, $a0, $a1 #$t2 = src_pos in src
	add $t3, $a2, $a3 #$t3 = dest_pos in dest
	move $t4, $t0 #value of length
	#t5 will contain letter being copied
	loop_bytecopy:
		lbu $t5, 0($t2) #load char in src
		sb $t5, 0($t3) #store char into dst
		addi $t2, $t2, 1 #inc memory for src
		addi $t3, $t3, 1 #inc memory for dst
		addi $v0, $v0, 1 #inc reture counter
		addi $t4, $t4, -1 #decrease length value
		beqz $t4, done_bytecopy #once length = 0, end
		j loop_bytecopy #jump back to loop
	done_bytecopy:
		addi $sp, $sp, -4 #move stack pointer down
		sw $t0, 0($sp) #store length back into stack
		jr $ra

strlen:
	addi $sp, $sp, -4 #allocate 4 extra bytes in memory
	sw $s0, 0($sp) #store $s0 register
	move $s0, $a0 #$s0 = argument
	li $v0, 0 #return counter
	loop_strlen_count:
		lbu $t0, 0($s0) #lb into $t0
		beqz $t0, done_loop_strlen_count #if 0, jump
		addi $s0, $s0, 1 #increment address
		addi $v0, $v0, 1 #increment counter
		j loop_strlen_count  #jump back loop
	done_loop_strlen_count:  #loop done
    	lw $s0, 0($sp)  #restore $s0
    	addi $sp, $sp, 4  #restore stack pointer
    	jr $ra   #jump back	

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
