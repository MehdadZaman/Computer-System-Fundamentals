# Mehdad Zaman
# mezaman
# 112323211

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
royal_flush_str: .asciiz "ROYAL_FLUSH\n"
straight_flush_str: .asciiz "STRAIGHT_FLUSH\n"
four_of_a_kind_str: .asciiz "FOUR_OF_A_KIND\n"
full_house_str: .asciiz "FULL_HOUSE\n"	
simple_flush_str: .asciiz "SIMPLE_FLUSH\n"
simple_straight_str: .asciiz "SIMPLE_STRAIGHT\n"
high_card_str: .asciiz "HIGH_CARD\n"

zero_str: .asciiz "ZERO\n"
neg_infinity_str: .asciiz "-INF\n"
pos_infinity_str: .asciiz "+INF\n"
NaN_str: .asciiz "NAN\n"
floating_point_str: .asciiz "_2*2^"

# Put your additional .data declarations here, if any.
print_before_fraction : .asciiz "1."

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    	# Start the assignment by writing your code here
	
    	###Check_1_precheck
    	lw $t0, addr_arg0 #$t0 = address of first arg 
    	lbu $t1, 0($t0)  #$t1 = first argument
    	
    	li $t2, '\0' #$t2 = the null termination character 
    	lbu $t3, 1($t0) #t3 = second character in first arg
    	bne $t2, $t3, invalid_operation_error_function #if second arg is not '\0', prints error message
    	
    	li $t2, 'F' #t2 = 'F'
    	beq $t1, $t2, start_coding_1 #jump to case F if arg0 is F
    	
    	li $t2, 'M' #t2 = 'M'
    	beq $t1, $t2, start_coding_1 #jump to case M if arg0 is M
    	
    	li $t2, 'P' #t2 = 'P'
    	beq $t1, $t2, start_coding_1 #jump to case P if arg0 is P
    	
    	j invalid_operation_error_function
    	###Check_1_precheck
    	
    	start_coding_1:
    	lw $t0, num_args #$t0 = num_args
    	li $t1, 2 #$t1 = 2
    	bne $t0, $t1, invalid_args_error_function #if not args not equal to 2, sent to the invalid_args_printer
    	
    	lw $t0, addr_arg0 #$t0 = address of first arg 
    	lbu $t1, 0($t0)  #$t1 = first argument
    	
    	li $t2, '\0' #$t2 = the null termination character 
    	lbu $t3, 1($t0) #t3 = second character in first arg
    	bne $t2, $t3, invalid_operation_error_function #if second arg is not '\0', prints error message
   
    	li $t2, 'F' #t2 = 'F'
    	beq $t1, $t2, case_F #jump to case F if arg0 is F
    	
    	li $t2, 'M' #t2 = 'M'
    	beq $t1, $t2, case_M #jump to case M if arg0 is M
    	
    	li $t2, 'P' #t2 = 'P'
    	beq $t1, $t2, case_P #jump to case P if arg0 is P
    	
    	j invalid_operation_error_function
    
case_M:
	lw, $t0, addr_arg1 #$t0 = address of argument 1
	li $t1, 0 #$t1 = 0 (beginning of loop)
	li $t2, 8 #$t2 = 8 (end of loop)
	li $t7, 0
	string_process_loop: #process each character
		lbu $t4, 0($t0) #$t4 = current character of arg1
		li $t5, 65 #$t5 = ASCII VALUE OF A
		bge $t4, $t5, A_OR_GREATER #IF char > A go to label 
		LESS_THAN_A:
			addi $t6, $t4, -48 #$t6 = char's hex value
			j Loop_Process_Continue #jump to loop process continue
		A_OR_GREATER:
			addi $t6, $t4, -55 #$t6 = char's hex value
		Loop_Process_Continue:
			sll $t7, $t7, 4 #shift $t7 left four bits
			add $t7, $t7, $t6 #add binary digits to $t7
			addi $t0, $t0, 1 #increment $t0 (memory address)
			addi $t1, $t1, 1 #increment $t1 (loop counter)
			bge $t1, $t2, loop_endM #if reached 8, then end loop
		j string_process_loop#restart loop
		
	loop_endM:
		#$t7 = undiced binary value
		srl $t3, $t7, 26 #shift 26 bits right
		andi $t4, $t3, 0x3F #and with bitmask (6 one bits)
		bnez $t4, invalid_args_error_function #if opcode is not = 0, print args error
		
		#Print opcode
		li $v0, 1
		move $a0, $t4
		syscall
		#Print space
		li $v0, 11
		li $a0, ' ' 
		syscall
		
		srl $t3, $t7, 21 #shift 21 bits right
		andi $t4, $t3, 0x1F #and with bitmask (5 one bits)
		#Print rs
		li $v0, 1
		move $a0, $t4
		syscall
		#Print space
		li $v0, 11
		li $a0, ' ' 
		syscall
		
		srl $t3, $t7, 16 #shift 16 bits right
		andi $t4, $t3, 0x1F #and with bitmask (5 one bits)
		#Print rt
		li $v0, 1
		move $a0, $t4 
		syscall
		#Print space
		li $v0, 11
		li $a0, ' ' 
		syscall
		
		srl $t3, $t7, 11 #shift 11 bits right
		andi $t4, $t3, 0x1F #and with bitmask (5 one bits)
		#Print rd
		li $v0, 1
		move $a0, $t4 
		syscall
		#Print space
		li $v0, 11
		li $a0, ' ' 
		syscall
		
		srl $t3, $t7, 6 #shift 6 bits right
		andi $t4, $t3, 0x1F #and with bitmask (6 one bits)
		#Print shamt
		li $v0, 1
		move $a0, $t4 
		syscall
		#Print space
		li $v0, 11
		li $a0, ' ' 
		syscall
		
		andi $t4, $t7, 0x3F #and with bitmask (6 one bits)
		#Print funct
		li $v0, 1
		move $a0, $t4 
		syscall
		j exit
case_F:
	lw, $t0, addr_arg1 #$t0 = address of argument 1
	li $t1, 0 #$t1 = 0 (beginning of loop)
	li $t2, 4 #$t2 = 4 (end of loop)
	li $t7, 0 #t7 = 0
	string_process_loop2: #process each character
		lbu $t4, 0($t0) #$t4 = current character of arg1
		li $t5, 70 #$t5 = ASCII VALUE OF of (F+1)
		bgt $t4, $t5, invalid_args_error_function #if $t4 > $t5, go to label
		
		li $t5, 48 #$t5 = 48
		blt $t4, $t5, invalid_args_error_function #if $t4 < $t5, go to label
		
		li $t5, 64 #$t5 = 64
		bgt $t4, $t5, Valid_Letter #if $t4 > $t5, go to label
		
		li $t5, 58 #$t5 = 58
		blt $t4, $t5, Valid_Number #if $t4 < $t5, go to label
		
		j invalid_args_error_function #all else, go to invalid argument
		
		Valid_Number:
			addi $t6, $t4, -48 #$t6 = char's hex value			
			j Loop_Process_Continue2 #jump to loop process continue
		Valid_Letter:
			addi $t6, $t4, -55 #$t6 = char's hex value
			
		Loop_Process_Continue2:
			sll $t7, $t7, 4 #shift $t7 left four bits
			add $t7, $t7, $t6 #add binary digits to $t7
			addi $t0, $t0, 1 #increment $t0 (memory address)
			addi $t1, $t1, 1 #increment $t1 (loop counter)
			bge $t1, $t2, loop_endF #if reached 4, then end loop
			
		j string_process_loop2 #restart loop
		
	loop_endF:
		#$t7 = undiced binary value
		li $t6, 0x0000 
		beq $t6, $t7, print_zero_str #if $t7 = 0000, print Zero
		
		li $t6, 0x8000
		beq $t6, $t7, print_zero_str #if $t7 = 8000, print Zero
		
		li $t6, 0xFC00
		beq $t6, $t7, print_neg_infinity_str #if $t7 = FC00, print neg_infinity
		
		li $t6, 0x7C00
		beq $t6, $t7, print_pos_infinity_str #if $t7 = 7C00, print pos_infinity
		
		li $t6, 0xFC01
		bge $t7, $t6, greater_than_FC00 #if $t7 >= FC01, print NaN
		
		li $t6, 0x7C01
		bge $t7, $t6, greater_than_7C00 #if $t7 >= 7C01, go to print NaN
		
		continue_to_process_sign:
			li $t6, 0x8000 #$t6 = all ones except first digit
			and $t8, $t7, $t6 #$t8 = $t7 and $t6 to get MSB
			
			bnez $t8, print_negative_sign #if MSB is 1, jump to print neg sign
			j continue_to_process_fraction #all else continue to process exponent
			
			print_negative_sign: #print negative sign
				li $v0, 11
				li $a0, '-'
				syscall
			
			continue_to_process_fraction:
				la $a0 print_before_fraction #a0 = 1.
				li $v0, 4
				syscall
				
				print_fraction:
					#print 9th bit in fraction
					srl $t4, $t7, 9
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 8th bit in fraction
					srl $t4, $t7, 8
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 7th bit in fraction
					srl $t4, $t7, 7
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 6th bit in fraction
					srl $t4, $t7, 6
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 5th bit in fraction
					srl $t4, $t7, 5
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 4th bit in fraction
					srl $t4, $t7, 4
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 3rd bit in fraction
					srl $t4, $t7, 3
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 2nd bit in fraction
					srl $t4, $t7, 2
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 1st bit in fraction
					srl $t4, $t7, 1
					andi $t5, $t4, 1
					move $a0, $t5
					li $v0, 1
					syscall
					#print 0th bit in fraction
					andi $t5, $t7, 1
					move $a0, $t5
					li $v0, 1
					syscall
				#print 2.2
				la $a0, floating_point_str
				li $v0, 4
				syscall
				#prints the exponent in excess-15
				srl $t4, $t7, 10
				andi $t5, $t4, 0x001F
				li $t3, -15
				add $t6, $t5, $t3
				move $a0, $t6
				li $v0, 1
				syscall	
		j exit
		
		greater_than_7C00: 
		
			li $t6, 0x7FFF
			bgt $t7, $t6, continue_to_process_sign
			
			li $v0, 4
			la $a0, NaN_str
			syscall
			j exit
			
		greater_than_FC00: #if $t7 >= FC01, print NaN
			li $v0, 4
			la $a0, NaN_str
			syscall
			j exit
			
		print_pos_infinity_str: #if $t7 = 7C00, print pos_infinity
			li $v0, 4
			la $a0, pos_infinity_str
			syscall
			j exit
		
		print_neg_infinity_str: #if $t7 = FC00, print neg_infinity
			li $v0, 4
			la $a0, neg_infinity_str
			syscall
			j exit
		
		print_zero_str: #if $t7 = 0000 or if $t7 = 8000, print Zero
			li $v0, 4
			la $a0, zero_str
			syscall
			j exit

case_P:
	lw, $t0, addr_arg1 #$t0 = address of argument 1
	
	li $t1, 0 #$t1 = 0 (beginning of loop)
	li $t2, 5 #$t2 = 5 (end of loop)
	li $t7, 0 #t7 = 0
	string_process_loop3: #process each character
	
		lbu $t4, 0($t0) #$t4 = current character of arg1 (first letter)
		lbu $t5, 1($t0) #$t5 = current second character of arg1 (second letter)
		
		li $t8, 90 #$t5 = ASCII VALUE OF of Z
		
		bgt $t4, $t8, invalid_args_error_function #if $t4 > $t5, go to label
		
		li $t8, 48 #$t8 = 48
		blt $t4, $t8, invalid_args_error_function #if $t4 < $t5, go to label
		
		li $t8, 64 #$t8 = 64
		bgt $t4, $t8, Valid_Letter_First_Byte #if $t4 > $t5, go to label
		
		li $t8, 58 #$t8 = 58
		blt $t4, $t8, Valid_Number_First_Byte #if $t4 < $t5, go to label
		
		j invalid_args_error_function #all else, go to invalid argument
		
		Valid_Number_First_Byte:
			#addi $t4, $t4, -48 #$t4 = char's hex value
			li $t8, 48
			beq $t4, $t8, invalid_args_error_function 
			li $t8, 49
			beq $t4, $t8, invalid_args_error_function 					
			j process_second_byte #jump to loop process continue
			
		Valid_Letter_First_Byte:
			#addi $t4, $t4, -55 #$t6 = char's hex value
			li $t8, 84 
			beq, $t4, $t8, process_second_byte
			li $t8, 74
			beq, $t4, $t8, process_second_byte
			li $t8, 81
			beq, $t4, $t8, process_second_byte
			li $t8, 75 
			beq, $t4, $t8, process_second_byte
			li $t8, 65    
			beq, $t4, $t8, process_second_byte
			
			j invalid_args_error_function 
			
		process_second_byte:
			#SCHD
			li $t8, 83 
			beq, $t5, $t8, process_successful
			li $t8, 67
			beq, $t5, $t8, process_successful
			li $t8, 72
			beq, $t5, $t8, process_successful
			li $t8, 68 
			beq, $t5, $t8, process_successful
		
			j invalid_args_error_function 
	
		process_successful:
			
			#sll $t7, $t7, 4 #shift $t7 left four bits
			#add $t7, $t7, $t6 #add binary digits to $t7
			addi $t0, $t0, 2 #increment $t0 (memory address)
			addi $t1, $t1, 1 #increment $t1 (loop counter)
			bge $t1, $t2, loop_endP #if reached 5, then end loop
			
		j string_process_loop3 #restart loop
		
		
	loop_endP:
		lw, $t0, addr_arg1 
		lbu $t1, 1($t0)
		lbu $t2, 3($t0)
		lbu $t3, 5($t0)
		lbu $t4, 7($t0)
		lbu $t5, 9($t0)
		
		ROYAL_FLUSH_CHECK:
			#checks if all suites are equal. If not, goes to straight_flush_check
			beq $t1, $t2, first_second_suit_eq_1.0 
			j STRAIGHT_FLUSH_CHECK
			first_second_suit_eq_1.0:
				beq $t2, $t3, second_third_suit_eq_1.0
				j STRAIGHT_FLUSH_CHECK
			second_third_suit_eq_1.0:
				beq $t3, $t4, third_fourth_suit_eq_1.0
				j STRAIGHT_FLUSH_CHECK
			third_fourth_suit_eq_1.0:
				beq $t4, $t5, fourth_fifth_suit_eq_1.0
				j STRAIGHT_FLUSH_CHECK
			fourth_fifth_suit_eq_1.0:
				check_royal_flush:
					lbu $t1, 0($t0)
					lbu $t2, 2($t0)
					lbu $t3, 4($t0)
					lbu $t4, 6($t0)
					lbu $t5, 8($t0)
					move $s0, $t1
					loop_check_min_1.0:
						#if($t2 < $s0), set $s0 to $t2
						blt $t2, $s0, set_$t2_min_$s0_1.0
						j continue_min_1_1.0
						set_$t2_min_$s0_1.0:
							move $s0, $t2 		
						continue_min_1_1.0:
						#if($t3 < $s0), set $s0 to $t2
						blt $t3, $s0, set_$t3_min_$s0_1.0
						j continue_min_2_1.0
						set_$t3_min_$s0_1.0:
							move $s0, $t3 		
						continue_min_2_1.0:
						#if($t4 < $s0), set $s0 to $t2
						blt $t4, $s0, set_$t4_min_$s0_1.0
						j continue_min_3_1.0
						set_$t4_min_$s0_1.0:
							move $s0, $t4 		
						continue_min_3_1.0:
						#if($t5 < $s0), set $s0 to $t2
						blt $t5, $s0, set_$t5_min_$s0_1.0
						j continue_min_4_1.0
						set_$t5_min_$s0_1.0:
							move $s0, $t5 		
						continue_min_4_1.0:
			
						#if lowest char is not A, go to straight flush
						li $t6, 'A'
						bne $s0, $t6, STRAIGHT_FLUSH_CHECK
					
						li $s1, 0 #number_counter
						li $t6, 'A'
					
						li $t9, 0 #loop_counter
					
					loop_check_royals2:
						#if $t1, contains desired char, increment
						beq $t1, $t6, inc_$s0_1.0.0
						j continue_search_0_1.0
							inc_$s0_1.0.0:
								addi $s1, $s1, 1
								j continue_count_1.0		
						continue_search_0_1.0:
						#if $t2, contains desired char, increment
						beq $t2, $t6, inc_$s0_1.1.0
						j continue_search_1.0
							inc_$s0_1.1.0:
								addi $s1, $s1, 1
								j continue_count_1.0		
						continue_search_1.0:
						#if $t3, contains desired char, increment
						beq $t3, $t6, inc_$s0_1.2.0
						j continue_search_2.0
							inc_$s0_1.2.0:
								addi $s1, $s1, 1
								j continue_count_1.0		
						continue_search_2.0:
						#if $t4, contains desired char, increment
						beq $t4, $t6, inc_$s0_1.3.0
						j continue_search_3.0
							inc_$s0_1.3.0:
								addi $s1, $s1, 1
								j continue_count_1.0		
						continue_search_3.0:
						#if $t5, contains desired char, increment
						beq $t5, $t6, inc_$s0_1.4.0
						j continue_search_4.0
							inc_$s0_1.4.0:
								addi $s1, $s1, 1
								j continue_count_1.0		
						continue_search_4.0:
						continue_count_1.0:
							#if char is = A, change to J
							li $t7, 'A'
							beq $t7, $t6, set_next_to_J
							j continue_to_set_other_0
							set_next_to_J:
								li $t6, 'J'
								j continue_to_loop_to_find		
							continue_to_set_other_0:
							#if char is = J, change to K
							li $t7, 'J'
							beq $t7, $t6, set_next_to_K
							j continue_to_set_other_1
							set_next_to_K:
								li $t6, 'K'
								j continue_to_loop_to_find		
							continue_to_set_other_1:
							#if char is = K, change to Q
							li $t7, 'K'
							beq $t7, $t6, set_next_to_Q
							j continue_to_set_other_2
							set_next_to_Q:
								li $t6, 'Q'
								j continue_to_loop_to_find		
							continue_to_set_other_2:
							#if char is = Q, change to T
							li $t7, 'Q'
							beq $t7, $t6, set_next_to_T
							j continue_to_set_other_3
							set_next_to_T:
								li $t6, 'T'
								j continue_to_loop_to_find		
							continue_to_set_other_3:
							#if char is = T, end checks
							li $t7, 'T'
							beq $t7, $t6, set_next_to_OUT
							j continue_to_set_other_4
							set_next_to_OUT:
								j continue_to_loop_to_find		
							continue_to_set_other_4:
							
							continue_to_loop_to_find:
								
								addi $t9, $t9, 1
								li $t8, 5
								bne $t9, $t8, loop_check_royals2	
					jump_to_compare_1.0:
					
					li $t8, 5
					beq $t8, $s1, print_royal_flush_str		
		
		#straight_flush_check_1:
		STRAIGHT_FLUSH_CHECK:
			#RESETS ORIGINAL STRING
			FIRST_MANIPULATE:
				lw $t4, addr_arg1
				li $t1, 0
				li $t2, 5
				
				
				manipulate_loop:	
					lbu $t3, 0($t4)
					
					li $t9, '2'
					beq $t3, $t9, set_2_to_A
					j continue_to_set_char_1
					set_2_to_A:
						li $t9, 'A'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_1:
					
					li $t9, '3'
					beq $t3, $t9, set_3_to_B
					j continue_to_set_char_2
					set_3_to_B:
						li $t9, 'B'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_2:
					
					li $t9, '4'
					beq $t3, $t9, set_4_to_C
					j continue_to_set_char_3
					set_4_to_C:
						li $t9, 'C'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_3:
					
					li $t9, '5'
					beq $t3, $t9, set_5_to_D
					j continue_to_set_char_4
					set_5_to_D:
						li $t9, 'D'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_4:
					
					li $t9, '6'
					beq $t3, $t9, set_6_to_E
					j continue_to_set_char_5
					set_6_to_E:
						li $t9, 'E'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_5:
					
					li $t9, '7'
					beq $t3, $t9, set_7_to_F
					j continue_to_set_char_6
					set_7_to_F:
						li $t9, 'F'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_6:
					
					li $t9, '8'
					beq $t3, $t9, set_8_to_G
					j continue_to_set_char_7
					set_8_to_G:
						li $t9, 'G'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_7:
					
					li $t9, '9'
					beq $t3, $t9, set_9_to_H
					j continue_to_set_char_8
					set_9_to_H:
						li $t9, 'H'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_8:
					
					li $t9, 'T'
					beq $t3, $t9, set_T_to_I
					j continue_to_set_char_9
					set_T_to_I:
						li $t9, 'I'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_9:
					
					li $t9, 'J'
					beq $t3, $t9, set_J_to_J
					j continue_to_set_char_10
					set_J_to_J:
						li $t9, 'J'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_10:
					
					li $t9, 'Q'
					beq $t3, $t9, set_Q_to_K
					j continue_to_set_char_11
					set_Q_to_K:
						li $t9, 'K'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_11:
					
					li $t9, 'K'
					beq $t3, $t9, set_K_to_L
					j continue_to_set_char_12
					set_K_to_L:
						li $t9, 'L'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_12:
					
					li $t9, 'A'
					beq $t3, $t9, set_A_to_M
					j continue_to_set_char_13
					set_A_to_M:
						li $t9, 'M'
						sb $t9, 0($t4)
						j continue_to_alter_string		
					continue_to_set_char_13:
						
				continue_to_alter_string:
					
					addi $t4 $t4, 2
					addi $t1, $t1, 1
					bge, $t1, $t2, finished_manipulating
					
					j manipulate_loop
		
		finished_manipulating:
		STRAIGHT_FLUSH_CHECK_1:
			
			lw, $t0, addr_arg1 
			lbu $t1, 1($t0)
			lbu $t2, 3($t0)
			lbu $t3, 5($t0)
			lbu $t4, 7($t0)
			lbu $t5, 9($t0)
		
			#checks if all suites are equal. If not, goes to straight_flush_check
			beq $t1, $t2, first_second_suit_eq_1.1 
			j FOUR_OF_A_KIND_CHECK
			first_second_suit_eq_1.1:
				beq $t2, $t3, second_third_suit_eq_1.1
				j FOUR_OF_A_KIND_CHECK
			second_third_suit_eq_1.1:
				beq $t3, $t4, third_fourth_suit_eq_1.1
				j FOUR_OF_A_KIND_CHECK
			third_fourth_suit_eq_1.1:
				beq $t4, $t5, fourth_fifth_suit_eq_1.1
				j FOUR_OF_A_KIND_CHECK
			fourth_fifth_suit_eq_1.1:
			
				check_straight_flush:
					lbu $t1, 0($t0)
					lbu $t2, 2($t0)
					lbu $t3, 4($t0)
					lbu $t4, 6($t0)
					lbu $t5, 8($t0)
					move $s0, $t1
					loop_check_min_1.1:
						#if($t2 < $s0), set $s0 to $t2
						blt $t2, $s0, set_$t2_min_$s0_1.1
						j continue_min_1_1.1
						set_$t2_min_$s0_1.1:
							move $s0, $t2 		
						continue_min_1_1.1:
						#if($t3 < $s0), set $s0 to $t2
						blt $t3, $s0, set_$t3_min_$s0_1.1
						j continue_min_2_1.1
						set_$t3_min_$s0_1.1:
							move $s0, $t3 		
						continue_min_2_1.1:
						#if($t4 < $s0), set $s0 to $t2
						blt $t4, $s0, set_$t4_min_$s0_1.1
						j continue_min_3_1.1
						set_$t4_min_$s0_1.1:
							move $s0, $t4 		
						continue_min_3_1.1:
						#if($t5 < $s0), set $s0 to $t2
						blt $t5, $s0, set_$t5_min_$s0_1.1
						j continue_min_4_1.1
						set_$t5_min_$s0_1.1:
							move $s0, $t5 		
						continue_min_4_1.1:
			
						#$S0 CONTAINS MIN
					
						li $s1, 0 #number_counter
						move $t6, $s0
						li $t9, 0 #loop_counter
					
					loop_check_straight_flush_2:
						#if $t1, contains desired char, increment
						beq $t1, $t6, inc_$s0_1.0.1
						j continue_search_0_1.1
							inc_$s0_1.0.1:
								addi $s1, $s1, 1
								j continue_count_1.1		
						continue_search_0_1.1:
						#if $t2, contains desired char, increment
						beq $t2, $t6, inc_$s0_1.1.1
						j continue_search_1.1
							inc_$s0_1.1.1:
								addi $s1, $s1, 1
								j continue_count_1.1		
						continue_search_1.1:
						#if $t3, contains desired char, increment
						beq $t3, $t6, inc_$s0_1.2.1
						j continue_search_2.1
							inc_$s0_1.2.1:
								addi $s1, $s1, 1
								j continue_count_1.1		
						continue_search_2.1:
						#if $t4, contains desired char, increment
						beq $t4, $t6, inc_$s0_1.3.1
						j continue_search_3.1
							inc_$s0_1.3.1:
								addi $s1, $s1, 1
								j continue_count_1.1		
						continue_search_3.1:
						#if $t5, contains desired char, increment
						beq $t5, $t6, inc_$s0_1.4.1
						j continue_search_4.1
							inc_$s0_1.4.1:
								addi $s1, $s1, 1
								j continue_count_1.1		
						continue_search_4.1:
						
						continue_count_1.1:
						
						addi $t9, $t9, 1
						addi $t6, $t6, 1
						li $t8, 5
						bge $t9, $t8, jump_to_compare_1.1
						
						j loop_check_straight_flush_2
					
					jump_to_compare_1.1:
					
					li $t8, 5
					beq $t8, $s1, print_straight_flush_str
		
		FOUR_OF_A_KIND_CHECK:
		
			lw, $t0, addr_arg1 
			lbu $s0, 0($t0)	
			li $s1, 'Z'
			li $t1, 0
			li $t2, 5
				
				find_others_loop_1.0:	
					lbu $t3, 0($t0)
					
					bne $t3, $s0, set_$s1_to_new_1.0
						j continue_search_for_new_1.0
							set_$s1_to_new_1.0:
								move $s1, $t3
								j other_letter_found_1.0		
						continue_search_for_new_1.0:
					
					addi $t0, $t0, 2
					addi $t1, $t1, 1
					bge, $t1, $t2, finished_searching_for_others_1.0
					j find_others_loop_1.0
		
			finished_searching_for_others_1.0:
		
			other_letter_found_1.0:
		
				lw, $t0, addr_arg1
		
				li $t1, 0
				li $t2, 5 
			
				li $s2, 0
				li $s3, 0
		
				loop_count_match_1.0:
		
					lbu $t3, 0($t0)
					
					beq $t3, $s0, add_found_$s0_1.0
					j continue_to_add_other_1.0.0
					add_found_$s0_1.0:
						addi $s2, $s2, 1
					j continue_adding_1.0		
					continue_to_add_other_1.0.0:
			
			
					beq $t3, $s1, add_found_$s1_1.0
					j continue_to_add_other_1.1.0
					add_found_$s1_1.0:
						addi $s3, $s3, 1
					j continue_adding_1.0		
					continue_to_add_other_1.1.0:
				
					continue_adding_1.0:
				
					addi $t0, $t0, 2
					addi $t1, $t1, 1
					bge, $t1, $t2, finished_adding_all_1.0
				
					j loop_count_match_1.0
					
					#$s2 AND $S3 CONTAIN NUMBERS 
					
					finished_adding_all_1.0:
					
					li $s4, 0
					li $s5, 0
					
					bgt $s2, $s3, store_larger_1.0
					move $s5, $s3
					move $s4, $s2
					j continue_to_operate_1.0
					store_larger_1.0:
						move $s5, $s2
						move $s4, $s3 	
					continue_to_operate_1.0:
					
					#$s6 contans sum
					#s7 contains difference
					
					add $s6, $s5, $s4
					li $t9, -1
					mul $s4, $s4, $t9 
					add $s7, $s5, $s4
					
					li $t8, 5
					li $t9, 3
					
					beq $s6, $t8, check_difference_1.0
					
					j FULL_HOUSE_CHECK
					
					check_difference_1.0:	
						beq $s7, $t9, print_four_of_a_kind_str
						j FULL_HOUSE_CHECK
					
							
		FULL_HOUSE_CHECK:

			lw, $t0, addr_arg1 
			lbu $s0, 0($t0)	
			li $s1, 'Z'
			li $t1, 0
			li $t2, 5
				
				find_others_loop_1.1:	
					lbu $t3, 0($t0)
					
					bne $t3, $s0, set_$s1_to_new_1.1
						j continue_search_for_new_1.1
							set_$s1_to_new_1.1:
								move $s1, $t3
								j other_letter_found_1.1		
						continue_search_for_new_1.1:
					
					addi $t0, $t0, 2
					addi $t1, $t1, 1
					bge, $t1, $t2, finished_searching_for_others_1.1
					j find_others_loop_1.1
		
			finished_searching_for_others_1.1:
		
			other_letter_found_1.1:
		
				lw, $t0, addr_arg1
		
				li $t1, 0
				li $t2, 5 
			
				li $s2, 0
				li $s3, 0
		
				loop_count_match_1.1:
		
					lbu $t3, 0($t0)
					
					beq $t3, $s0, add_found_$s0_1.1
					j continue_to_add_other_1.0.1
					add_found_$s0_1.1:
						addi $s2, $s2, 1
					j continue_adding_1.1		
					continue_to_add_other_1.0.1:
			
			
					beq $t3, $s1, add_found_$s1_1.1
					j continue_to_add_other_1.1.1
					add_found_$s1_1.1:
						addi $s3, $s3, 1
					j continue_adding_1.1		
					continue_to_add_other_1.1.1:
				
					continue_adding_1.1:
				
					addi $t0, $t0, 2
					addi $t1, $t1, 1
					bge, $t1, $t2, finished_adding_all_1.1
				
					j loop_count_match_1.1
					
					#$s2 AND $S3 CONTAIN NUMBERS 
					
					finished_adding_all_1.1:
					
					li $s4, 0
					li $s5, 0
					
					bgt $s2, $s3, store_larger_1.1
					move $s5, $s3
					move $s4, $s2
					j continue_to_operate_1.1
					store_larger_1.1:
						move $s5, $s2
						move $s4, $s3 	
					continue_to_operate_1.1:
					
					#$s6 contans sum
					#s7 contains difference
					
					add $s6, $s5, $s4
					li $t9, -1
					mul $s4, $s4, $t9
					add $s7, $s5, $s4
					
					li $t8, 5
					li $t9, 1
					beq $s6, $t8, check_difference_1.1
					j SIMPLE_FLUSH_CHECK
					
					check_difference_1.1:	
						beq $s7, $t9, print_full_house_str
						j SIMPLE_FLUSH_CHECK
		
		SIMPLE_FLUSH_CHECK:
		
			lw, $t0, addr_arg1 
			lbu $t1, 1($t0)
			lbu $t2, 3($t0)
			lbu $t3, 5($t0)
			lbu $t4, 7($t0)
			lbu $t5, 9($t0)
		
			#checks if all suites are equal. If not, goes to straight_flush_check
			beq $t1, $t2, first_second_suit_eq_1.2 
			j STRAIGHT_CHECK
			first_second_suit_eq_1.2:
				beq $t2, $t3, second_third_suit_eq_1.2
				j STRAIGHT_CHECK
			second_third_suit_eq_1.2:
				beq $t3, $t4, third_fourth_suit_eq_1.2
				j STRAIGHT_CHECK
			third_fourth_suit_eq_1.2:
				beq $t4, $t5, fourth_fifth_suit_eq_1.2
				j STRAIGHT_CHECK
			fourth_fifth_suit_eq_1.2:
				
				j print_simple_flush_str
		
		STRAIGHT_CHECK:
		
				lw, $t0, addr_arg1
				lbu $t1, 0($t0)
				lbu $t2, 2($t0)
				lbu $t3, 4($t0)
				lbu $t4, 6($t0)
				lbu $t5, 8($t0)
				move $s0, $t1
				loop_check_min_1.2:
					#if($t2 < $s0), set $s0 to $t2
					blt $t2, $s0, set_$t2_min_$s0_1.2
					j continue_min_1_1.2
					set_$t2_min_$s0_1.2:
						move $s0, $t2 		
					continue_min_1_1.2:
					#if($t3 < $s0), set $s0 to $t2
					blt $t3, $s0, set_$t3_min_$s0_1.2
					j continue_min_2_1.2
					set_$t3_min_$s0_1.2:
						move $s0, $t3 		
					continue_min_2_1.2:
					#if($t4 < $s0), set $s0 to $t2
					blt $t4, $s0, set_$t4_min_$s0_1.2
					j continue_min_3_1.2
					set_$t4_min_$s0_1.2:
						move $s0, $t4 		
					continue_min_3_1.2:
					#if($t5 < $s0), set $s0 to $t2
					blt $t5, $s0, set_$t5_min_$s0_1.2
					j continue_min_4_1.2
					set_$t5_min_$s0_1.2:
						move $s0, $t5 		
					continue_min_4_1.2:
		
					#$S0 CONTAINS MIN
				
					li $s1, 0 #number_counter
					move $t6, $s0
					li $t9, 0 #loop_counter
				
				loop_check_straight_2:
					#if $t1, contains desired char, increment
					beq $t1, $t6, inc_$s0_1.0.2
					j continue_search_0_1.2
						inc_$s0_1.0.2:
							addi $s1, $s1, 1
							j continue_count_1.2		
					continue_search_0_1.2:
					#if $t2, contains desired char, increment
					beq $t2, $t6, inc_$s0_1.1.2
					j continue_search_1.2
						inc_$s0_1.1.2:
							addi $s1, $s1, 1
							j continue_count_1.2		
					continue_search_1.2:
					#if $t3, contains desired char, increment
					beq $t3, $t6, inc_$s0_1.2.2
					j continue_search_2.2
						inc_$s0_1.2.2:
							addi $s1, $s1, 1
							j continue_count_1.2		
					continue_search_2.2:
					#if $t4, contains desired char, increment
					beq $t4, $t6, inc_$s0_1.3.2
					j continue_search_3.2
						inc_$s0_1.3.2:
							addi $s1, $s1, 1
							j continue_count_1.2		
					continue_search_3.2:
					#if $t5, contains desired char, increment
					beq $t5, $t6, inc_$s0_1.4.2
					j continue_search_4.2
						inc_$s0_1.4.2:
							addi $s1, $s1, 1
							j continue_count_1.2		
					continue_search_4.2:
					
					continue_count_1.2:
					
					addi $t9, $t9, 1
					addi $t6, $t6, 1
					li $t8, 5
					bge $t9, $t8, jump_to_compare_1.2
					
					j loop_check_straight_2
				
				jump_to_compare_1.2:
				
				li $t8, 5
				beq $t8, $s1, print_simple_straight_str
				
				j EVERYTHING_ELSE
				
		EVERYTHING_ELSE:
			
			j print_high_card_str
			
		j exit
		
invalid_args_error_function: #function to print invalid args message

 	li $v0, 4 #print out
	la $a0, invalid_args_error # sent message to print invalid args message
	syscall
	j exit
	
invalid_operation_error_function: #function to print invalid operation message	
	
	li $v0, 4 #print out
	la $a0, invalid_operation_error # sent message to print invalid operation message
	syscall 
	j exit
	
print_royal_flush_str:
	
	li $v0, 4 #print out
	la $a0, royal_flush_str
	syscall 
	j exit
	
print_straight_flush_str:
	
	li $v0, 4 #print out
	la $a0, straight_flush_str
	syscall 
	j exit
	
print_four_of_a_kind_str:
	
	li $v0, 4 #print out
	la $a0, four_of_a_kind_str
	syscall 
	j exit

print_full_house_str:

	li $v0, 4 #print out
	la $a0, full_house_str
	syscall 
	j exit

print_simple_flush_str:

	li $v0, 4 #print out
	la $a0, simple_flush_str
	syscall 
	j exit

print_simple_straight_str:
	
	li $v0, 4 #print out
	la $a0, simple_straight_str
	syscall 
	j exit

print_high_card_str:

	li $v0, 4 #print out
	la $a0, high_card_str
	syscall 
	j exit

exit:
    li $v0, 10   # terminate program
    syscall
