# CSE 220 Programming Project #2
# Mehdad Zaman
# mezaman
# 112323211

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

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
    	
index_of:
	addi $sp, $sp, -4 #allocate 4 extra bytes in memory
	sw $s0, 0($sp) #stor $s0 register
	#$a0 has string and $a1 has char
	li $v0, -1 #store -1 into $v0
	move $s0, $a0 #moves string address into $s0
	li $t0, 0 #counter
	loop_index_of: #loop
		lbu $t1, 0($s0) #$t1 = current char
		beqz $t1, done_loop_index_of
		bne $t1, $a1, continue_loop_index_of 
		move $v0, $t0 #if passes test move index and jump back
		j done_loop_index_of
		continue_loop_index_of:
			addi $t0, $t0, 1 #inc counter
			addi $s0, $s0, 1 #inc memory address
			j loop_index_of #jumo back
	done_loop_index_of:
		lw $s0, 0($sp)  #restore $s0
    	addi $sp, $sp, 4  #restore stack pointer
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
		sw $t0, 0($sp) #stor length back into stack
		jr $ra
			
scramble_encrypt:
	move $t0, $a0 #t0 = cipher
	move $t1, $a1 #t1 = plain
	move $t2, $a2 #$t2 = alphabet
	li $v0, 0 #counter
	loop_scramble_encrypt:
		lbu $t3, 0($t1) #lb of plaintext
		beqz $t3, done_scramble_encrypt #if 0, end
		li $t4, 'a' #$t4 'a'
		bge $t3, $t4, lower_case_scramble_encrypt #if greater or equal, jump to lower
		upper_case_scramble_encrypt: #if upper
			li $t4, 'A'
			blt, $t3, $t4 not_alpha_scramble_encrypt #if less than A, not alpha
			li $t4, 'Z'
			bgt, $t3, $t4 not_alpha_scramble_encrypt #if greater than Z, not alpha
			addi $t5, $t3, -65 #brings down to index value
			add $t6, $t2, $t5 #goes to index in alphabet
			lbu $t7, 0($t6) #lb into $t7
			sb $t7, 0($t0) #sb into cipher text
			addi $v0, $v0, 1 #inc counter
			j continue_count_scramble_encrypt
		lower_case_scramble_encrypt: #if lower
			li $t4, 'z'
			bgt, $t3, $t4 not_alpha_scramble_encrypt #if greater than z, not alpha
			addi $t5, $t3, -97 #brings down to index value
			addi $t5, $t5, 26 #brings up to second half of array
			add $t6, $t2, $t5 #goes to array in memory address
			lbu $t7, 0($t6) #lb into $t7
			sb $t7, 0($t0) #sb into cipher text
			addi $v0, $v0, 1 #inc counter
			j continue_count_scramble_encrypt
		not_alpha_scramble_encrypt: #if non-alpha
			sb $t3, 0($t0) #store non-alpha into cipher
		continue_count_scramble_encrypt:
			addi $t0, $t0, 1 #inc cipher
			addi $t1, $t1, 1 #inc plain text
			j loop_scramble_encrypt #jump back
		done_scramble_encrypt:
			li $t8, '\0' #load null terminator
			sb $t8, 0($t0) #store null terminator into end of cipher
			jr $ra
						
scramble_decrypt:
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp) 
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	move $s0, $a0 #t0 = plain
	move $s1, $a1 #t1 = cipher
	move $s2, $a2 #$t2 = alphabet
	li $s3, 0 #number of decrypted letters
	li $s5, 0 #decrypt counter
	loop_scramble_decrypt:
		lbu $s4, 0($s1) #lb of plaintext
		beqz $s4, done_scramble_decrypt #if 0, end
		li $t4, 'a' #$t4 'a'
		bge $s4, $t4, lower_case_scramble_decrypt #if greater or equal, jump to lower
		upper_case_scramble_decrypt: #if upper
			li $t4, 'A'
			blt, $s4, $t4 not_alpha_scramble_decrypt #if less than A, not alpha
			li $t4, 'Z'
			bgt, $s4, $t4 not_alpha_scramble_decrypt #if greater than Z, not alpha
			j process_in_cipher_scramble_decrypt
		lower_case_scramble_decrypt: #if lower
			li $t4, 'z'
			bgt, $s4, $t4 not_alpha_scramble_decrypt #if greater than z, not alpha
			j process_in_cipher_scramble_decrypt		
		process_in_cipher_scramble_decrypt:
			loop_process_letters_scramble_decrypt:
				move $a0, $s2
				move $a1, $s4
				jal index_of
				move $s6, $v0
				addi $s5, $s5, 1
				li $t8, 25
				bgt $s6, $t8, lower_case_process_letters_scramble_decrypt #second part of array (lowercase)
				upper_case_process_letters_scramble_decrypt:
					addi $t8, $s6, 65 #index + 'A'
					sb $t8, 0($s0) #sb in cipher
					j continue_count_scramble_decrypt
				lower_case_process_letters_scramble_decrypt:
					addi $t8, $s6, 97 #index + 'a'
					addi $t8, $t8, -26 #brings index back down
					sb $t8, 0($s0) #sb in cipher
					j continue_count_scramble_decrypt
		not_alpha_scramble_decrypt: #if non-alpha
			sb $s4, 0($s0) #store non-alpha into cipher
		continue_count_scramble_decrypt:
			addi $s0, $s0, 1 #inc cipher
			addi $s1, $s1, 1 #inc plain text
			j loop_scramble_decrypt #jump back
		done_scramble_decrypt:
			li $t8, '\0' #load null terminator
			sb $t8, 0($s0) #store null terminator into end of cipher
			move $v0, $s5
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
																			
base64_encode:
	#loading values into stack
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	move $s0, $a0 #encoded_str
	move $s1, $a1 #str
	move $s2, $a2 #base64_table
	li $t0, 0 #midway-form
	li $t1, 0 #counter
	li $t2, 3 #max-bit-counter
	li $v0, 0 #string counter
	loop_process1_base64_encode:
		beq $t1, $t2, loop_process2_base64_encode #if three characters have been processed, jump to process 2
		lbu $t3, 0($s1) #load byte of str
		beqz $t3, loop_process2_base64_encode #if $t3 is null terminator, jump to process 2
		sll $t0, $t0, 8 #shift byte left 8 bits for next char
		add $t0, $t0, $t3 #add byte to t0
		addi $t1, $t1, 1 #inc counter
		addi $s1, $s1, 1 #inc str memory address
		j loop_process1_base64_encode
		loop_process2_base64_encode:	
			beqz $t1, finished_processing_base64_encode #if zero chars are there
			li $t4, 1
			beq $t1, $t4, one_code_base64_encode #if only one char processed
			li $t4, 2
			beq $t1, $t4, two_code_base64_encode #if only two chars processed
			li $t4, 3
			beq $t1, $t4, three_code_base64_encode #if three chars processed
			three_code_base64_encode:
				li $t8, 0 #counter
				li $t9, 4 #number of sets of 6 bits
				li $t4, 18 #number to shift
				loop_three_code_base64_encode:
					beq $t8, $t9, done_three_code_base64_encode #when done, jump
					srlv  $t5, $t0, $t4 #shift right to get 6 bits
					andi $t5, $t5, 0x3F #and it to get 6 bits only
					add $t6, $s2, $t5 #add number to table memory address
					lbu $t7, 0($t6) #lb at index of table
					sb $t7, 0($s0) #sb at correct place in memory
					addi $s0, $s0, 1 #add to cipher place in memory
					addi $t8, $t8, 1 #add to incrementer
					addi $t4, $t4, -6 #decrease shifter by 6 bits
					addi $v0, $v0, 1 #inc string length
					j loop_three_code_base64_encode
				done_three_code_base64_encode:
					beqz $t3, finished_processing_base64_encode #if null, end
					li $t1, 0 # reset counter
					li $t0, 0 # reset sum
					j loop_process1_base64_encode #jump back to continue processing
			two_code_base64_encode:
				sll $t0, $t0, 8 #shift left 8 bits for padding
				li $t8, 0 #counter
				li $t9, 4 #number of sets of 6 bits
				li $t4, 18 #number to shift
				loop_two_code_base64_encode:
					beq $t8, $t9, done_two_code_base64_encode #if four sets of six bits counted, move on
					srlv  $t5, $t0, $t4 #shift for desired six bits
					andi $t5, $t5, 0x3F #and to separate six bits
					li $t1, 3 #if on third argument, set to = sign
					beq $t8, $t1, set_equal_two_code_base64_encode
					add $t6, $s2, $t5 #set $t6 equal to $t5 index plus $s2 memory address
					lbu $t7, 0($t6) #lb to $t7 at correct index
					sb $t7, 0($s0) #store found byte into encoded string
					j continue_increment_two_code_base64_encode #skip over set to equal
					set_equal_two_code_base64_encode: #set and load char = to encoded string
						li $t7, '='
						sb $t7, 0($s0)
					continue_increment_two_code_base64_encode: 
						addi $v0, $v0, 1 #inc string length
						addi $s0, $s0, 1 #inc encoded string memory address
						addi $t8, $t8, 1 #inc loop byte counter
						addi $t4, $t4, -6 #decrease shifter by 6
					j loop_two_code_base64_encode #jump back
				done_two_code_base64_encode:
					li $t1, 0 # reset counter
					li $t0, 0 # reset sum  
					j finished_processing_base64_encode #processing completed
			one_code_base64_encode:
				sll $t0, $t0, 16 #shift word 8 because only one char processed
				li $t8, 0 #counter
				li $t9, 4 #number of sets of 6 bits
				li $t4, 18 #number to shift
				loop_one_code_base64_encode: 
					beq $t8, $t9, done_one_code_base64_encode #if $t8 has counted four bits, move along
					srlv  $t5, $t0, $t4 #shift right to get 6 desired bits
					andi $t5, $t5, 0x3F #and operation to indivdualize bits
					li $t1, 2 #set char to = if on third set of bits
					beq $t8, $t1, set_equal_one_code_base64_encode
					li $t1, 3 #set char to = if on fourth set of bits
					beq $t8, $t1, set_equal_one_code_base64_encode
					add $t6, $s2, $t5 #add index and memory address
					lbu $t7, 0($t6) #lb to $t7 at memory address
					sb $t7, 0($s0) #sb at endcoded string
					j continue_increment_one_code_base64_encode
					set_equal_one_code_base64_encode: #set to = if on last two sets of six bits
						li $t7, '='
						sb $t7, 0($s0)
					continue_increment_one_code_base64_encode:
						addi $v0, $v0, 1 #inc string length
						addi $s0, $s0, 1 #inc memory address
						addi $t8, $t8, 1 #inc counter
						addi $t4, $t4, -6 #decrease bit shifter
					j loop_one_code_base64_encode #jump back
				done_one_code_base64_encode:
					li $t1, 0 # reset counter
					li $t0, 0 # reset sum  
					j finished_processing_base64_encode #finished processing
		finished_processing_base64_encode: #set last char to \0
			li $t8, '\0'
			sb $t8, 0($s0)
			#loading values into register
			lw $s2, 0($sp)
			lw $s1, 4($sp)
			lw $s0, 8($sp)
			addi $sp, $sp 12
			jr $ra	
									
base64_decode:
	#save saved values into stack
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp) 
	sw $s5, 0($sp)
	move $s0, $a0 #decoded_str
	move $s1, $a1 #encoded_str
	move $s2, $a2 #base64_table
	li $s3, 0 #midway-form
	li $s4, 0 #counter
	li $s5, 0 #string counter
	loop_process1_base64_decode:
		li $t0, 4 #max-bit-counter
		beq $s4, $t0, loop_process2_base64_decode #if three characters have been processed, jump to process 2
		lbu $a1, 0($s1) #load byte of str
		beqz $a1, finished_processing_base64_decode #if $t3 is null terminator, jump to process 2
		sll $s3, $s3, 6 #shift byte left 6 bits for next char
		li $t6, '=' #if byte is an equal sign, skip arithmetic
		beq $t6, $a1, equal_and_others_base64_decode
		move $a0, $s2
		jal index_of # $v0 now has contents of index 
		add $s3, $s3, $v0 #add byte to $s3
		equal_and_others_base64_decode:
			addi $s4, $s4, 1 #inc counter
			addi $s1, $s1, 1 #inc str memory address
			j loop_process1_base64_decode
		loop_process2_base64_decode:
				li $t8, 0 #counter
				li $t9, 3 #number of sets of 6 bits
				li $t4, 16 #number to shift
				loop_code_base64_decode:
					beq $t8, $t9, done_code_base64_decode #when done, jump
					srlv  $t5, $s3, $t4 #shift right to get 6 bits
					andi $t5, $t5, 0xFF #and it to get 6 bits only
					sb $t5, 0($s0) #sb at correct place in memory
					beqz $t5,continue_count_base64_decode #if byte is 0, doesn't count
					addi $s5, $s5, 1 #inc string length
					continue_count_base64_decode:
						addi $s0, $s0, 1 #add to cipher place in memory
						addi $t8, $t8, 1 #add to incrementer
						addi $t4, $t4, -8 #decrease shifter by 8 bits
					j loop_code_base64_decode
				done_code_base64_decode:
					#beqz $t3, finished_processing_base64_decode #if null, end
					li $s3, 0 # reset counter
					li $s4, 0 # reset sum
					j loop_process1_base64_decode #jump back to continue processing
		finished_processing_base64_decode: #set last char to \0
			li $t8, '\0'
			sb $t8, 0($s0)
			move $v0, $s5 #move number of chars to argument
	#reload saved values and reset stack pointer
	lw $s5, 0($sp)
	lw $s4, 4($sp)
	lw $s3, 8($sp) 
	lw $s2, 12($sp)
	lw $s1, 16($sp)
	lw $s0, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
	jr $ra
	
bifid_encrypt:
	#save saved values into stack
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
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
	move $s0, $a0 #ciphertext
	move $s1, $a1 #plaintext
	move $s2, $a2 #key_square
	move $s3, $a3 #period
	move $s4, $t0 #index buffer
	#if period is wrong
	bgtz $s3, greater_than_bifid_encrypt
		li $v0, -1
		jr $ra
	greater_than_bifid_encrypt:
		#storing the initial position in memory of the index buffer into the stack
		addi $sp, $sp, -4
		sw $s4, 0($sp)
		#storing block counter into the stack
		li $t0, 0
		addi $sp, $sp, -4
		sw $t0, 0($sp)
	move $s5, $t1 #block buffer
	li $s6, 0 #counter
	loop_process1_bifid_encrypt:
		beq $s6, $s3, loop_process2_bifid_encrypt #if counter=0, then jump
		move $a0, $s2  #move key into string argument
		lbu $s7, 0($s1) #load byte from plain text into $s7
		move $a1, $s7 #move current letter into argument
		beqz $s7, loop_process2_bifid_encrypt #if null, then jump out
		jal index_of #jump to find the index
		move $t9, $v0 #move index to temp register
		li $t0, 9 #number of rows
		div $t9, $t0 # divide index by 9
		mflo $t1 #$t1 has rows
		mfhi $t2 #$t2 has colums
		addi $t1, $t1, 48 #add to see char number
		addi $t2, $t2, 48 #add to see char number
		move $t3, $s5 #move memory buffer into $t3
		add $t3, $t3, $s6 #add counter to locate exact place
		sb $t1, 0($t3) #store row index into buffer location
		add $t3, $t3, $s3 #add period size to locate exact location
		sb $t2, 0($t3)
		addi $s6, $s6, 1 #inc counter
		addi $s1, $s1, 1 #inc original string memory
		j loop_process1_bifid_encrypt
	loop_process2_bifid_encrypt:
		beqz $s6, equals_period_bifid_encrypt
		beq $s6, $s3, equals_period_bifid_encrypt
			#if count is less than period rearrange the BLOCK buffer
			move $a0, $s5 #src
			move $a1, $s3 #src_pos
			move $a2, $s5 #dest
			move $a3, $s6 #dest_pos
			move $t0, $s6 #length
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			jal bytecopy
			addi $sp, $sp, 4
		equals_period_bifid_encrypt:
		beqz $s6, loop_process3_bifid_encrypt #if no more chars are left than go to next buffer
		#increments the block counter and puts it back into the stack
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		addi $t0, $t0, 1
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		#rearranges block_buffer into index_buffer
		move $a0, $s5 #src
		li $a1, 0 #src_pos
		move $a2, $s4#dest
		li $a3, 0 #dest_pos
		li $t1, 2
		mul $t2, $s6, $t1 #multiplies next index to 2 times count FOR LENGTH
		move $t0, $t2 #length
		addi $sp, $sp, -4 
		sw $t0, 0($sp)
		jal bytecopy
		addi $sp, $sp, 4
		li $t1, 2
		mul $t2, $s6, $t1 #multiplies these numbers to see how much further to go in string
		add $s4, $s4, $t2
		li $s6, 0 #set counter back to 0
		j loop_process1_bifid_encrypt #jump back
	loop_process3_bifid_encrypt:
		#moves counter into $v0
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		move $v0, $t0
		#terminate the index_buffer
		li $t8, '\0'
		sb $t8, 0($s4)
		#reloading original memory of index_buffer into $s4
		lw $t0, 0($sp) 
		move $t1, $t0
		addi $sp, $sp, 4
		loop_encrypt_text_bifid_encrypt:
			#subtract un both because they are the number representations
			lbu $t2, 0($t1) #load first byte
			beqz $t2, finished_cipher_bifid_encrypt
			addi $t2, $t2, -48
			lbu $t3, 1($t1) #load second byte
			addi $t3, $t3, -48
			#2D array arithmetic
			li $t4, 9
			mul $t5, $t2, $t4
			add $t5, $t5, $t3
			#$t5 now has correct index
			move $t6, $s2 #move key square here
			add $t6, $t6, $t5 #find index in key square
			lbu $t7, 0($t6) #load bite and put it into the cipher
			sb $t7, 0($s0)
			addi $s0, $s0, 1 #inc cipher memory count
			addi $t1, $t1, 2 #in memory address
			j loop_encrypt_text_bifid_encrypt
		finished_cipher_bifid_encrypt:
			#terminate the index_buffer
			li $t8, '\0'
			sb $t8, 0($s0)
		#reload saved values and reset stack pointer
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
	
bifid_decrypt:
	#save saved values into stack
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
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
	move $s0, $a0 #plaintext
	move $s1, $a1 #ciphertext
	move $s2, $a2 #key_square
	move $s3, $a3 #period
	move $s4, $t0 #index buffer
	bgtz $s3, greater_than_bifid_decrypt
		li $v0, -1
		jr $ra
	greater_than_bifid_decrypt:
	move $s5, $t1 #block buffer
	move $s6, $s4 #counter
	li $v0, 0
	#loads block counter into memory
	li $t0, 0
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	loop_process1_bifid_decrypt:
		lbu $s7, 0($s1) #load byte from plain text into $s7
		beqz $s7, loop_process2_bifid_decrypt #if null, then jump out
		move $a0, $s2  #move key into string argument
		move $a1, $s7 #move current letter into argument
		jal index_of #jump to find the index
		move $t9, $v0 #move index to temp register
		li $t0, 9 #number of rows
		div $t9, $t0 # divide index by 9
		mflo $t1 #$t1 has rows
		mfhi $t2 #$t2 has columns
		addi $t1, $t1, 48 #add to see char number
		addi $t2, $t2, 48 #add to see char number
		sb $t1, 0($s6) #store row index into buffer location
		sb $t2, 1($s6) #store column index into buffer location
		addi $s6, $s6, 2 #inc counter
		addi $s1, $s1, 1 #inc original string memory
		addi $v0, $v0, 1
		j loop_process1_bifid_decrypt
	loop_process2_bifid_decrypt:
		li $t8, '\0' #puts a null terminator on the end of the index_buffer
		sb $t8, 0($s6)
		move $a0, $s4 #calculates the string length
		jal strlen
		move $s6, $v0 #$s6 has string length of the index buffer
		li $s7, 0 #index of the index buffer
		loop_process2.2_bifid_decrypt:
			beq $s7, $s6, loop_process3_bifid_decrypt #once completley iterated through string, terminate
			li $t1, 2
			mult $t1, $s3 #$t1 has double the period to get the row index and and column index
			mflo $t1
			move $a0, $s4 #src
			move $a1, $s7 #src_pos
			move $a2, $s5 #dest
			li $a3, 0 #dest_pos
			move $t0, $t1 #length
			addi $sp, $sp, -4 #copied the current desired portion of index buffer to block_buffer
			sw $t0, 0($sp) 
			jal bytecopyv2
			addi $sp, $sp, 4
			#increments the block counter and puts it back into the stack
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $t0, 1
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			move $s1, $v0 #copy number of letters copied
			add $s7, $s7, $v0 # stored the number of bytes copied to the block buffer in $s7
			li $t0, 0 #instantiantes char counter
			li $t9, 2
			div $s1, $t9
			mflo $t9 #stored the number of sets of characters into $t9 by dividing by two
			loop_process2.3_bifid_decrypt:
				#if number of counted letters is the same as the processed, jump back to get another block
				beq $t0, $t9, loop_process2.2_bifid_decrypt
				#load first byte (row index)
				add $t1, $s5, $t0
				lbu $t2, 0($t1)
				#load second byte (column index) by adding the number of sets of chars
				add $t3, $t1, $t9
				lbu $t4, 0($t3)
				addi $t2, $t2, -48
				addi $t4, $t4, -48
				#2D array arithmetic
				li $t5, 9
				mul $t6, $t2, $t5
				add $t6, $t6, $t4
				#$t6 now has correct index
				move $t7, $s2 #move key square here
				add $t7, $t7, $t6 #find index in key square
				lbu $t8, 0($t7) #load bite and put it into the cipher
				sb $t8, 0($s0)
				addi $t0, $t0, 1 #inc char counter
				addi $s0, $s0, 1 #inc plain text address
				j loop_process2.3_bifid_decrypt
	loop_process3_bifid_decrypt:
		#moves counter into $v0
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		move $v0, $t0
		#puts a null terminator at the end of the plaintext
		li $t8, '\0'
		sb $t8, 0($s0)
		move $v1, $s6
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

#THIS FUNCTION IS A HELPER FUNCTION ONLY FOR BIFID_DECRYPT
bytecopyv2:
	lw $t0, 0($sp) #$t0 = the length from stack
	addi $sp, $sp, 4 #push stack pointer after value loaded
	#$a0 contains src
	#$a1 contains src_pos
	#$a2 contains dest
	#$a3 contains dest_pos
	#$t0 contains length
	li $t1, 0
	li $v0, -1
	ble $t0, $t1, done_bytecopyv2 #jump if length <= 0
	blt $a1, $t1, done_bytecopyv2 #jump if src_pos < 0
	blt $a3, $t1, done_bytecopyv2 #jump if dst_pos < 0
	li $v0, 0 #return counter
	add $t2, $a0, $a1 #$t2 = src_pos in src
	add $t3, $a2, $a3 #$t3 = dest_pos in dest
	move $t4, $t0 #value of length
	#t5 will contain letter being copied
	loop_bytecopyv2:
		lbu $t5, 0($t2) #load char in src
		beqz, $t5, done_bytecopy #if null terminated then end
		sb $t5, 0($t3) #store char into dst
		addi $t2, $t2, 1 #inc memory for src
		addi $t3, $t3, 1 #inc memory for dst
		addi $v0, $v0, 1 #inc reture counter
		addi $t4, $t4, -1 #decrease length value
		beqz $t4, done_bytecopyv2 #once length = 0, end
		j loop_bytecopyv2 #jump back to loop
	done_bytecopyv2:
		addi $sp, $sp, -4 #move stack pointer down
		sw $t0, 0($sp) #stor length back into stack
		jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
