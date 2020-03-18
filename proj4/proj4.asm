# CSE 220 Programming Project #4
# Mehdad Zaman
# mezaman
# 112323211

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

compute_checksum:
	#(version + msg id + total length + priority + flags + protocol + frag offset + src addr + dest addr) mod 216
	move $t6, $a0 #packet object
	lw $t0, 0($t6) #(word 0)
	lw $t1, 4($t6) #(word 1)
	lw $t2, 8($t6) #(word 2)
	#checksum sum
	li $t3,0
	#version: (word 0)
	srl $t4, $t0, 28
	andi $t4, $t4, 0xF
	add $t3, $t3, $t4
	#msg id: (word 0)
	srl $t4, $t0, 16
	andi $t4, $t4, 0xFFF
	add $t3, $t3, $t4
	#total length: (word 0)
	andi $t4, $t0, 0xFFFF
	add $t3, $t3, $t4
	#priority: (word 1)
	srl $t4, $t1, 24
	andi $t4, $t4, 0xFF
	add $t3, $t3, $t4
	#flags: (word 1)
	srl $t4, $t1, 22
	andi $t4, $t4, 0x3
	add $t3, $t3, $t4
	#protocol: (word 1)
	srl $t4, $t1, 12
	andi $t4, $t4, 0x3FF
	add $t3, $t3, $t4
	#frag offset: (word 1)
	andi $t4, $t1, 0xFFF
	add $t3, $t3, $t4
	#src addr: (word 2)
	srl $t4, $t2, 8
	andi $t4, $t4, 0xFF
	add $t3, $t3, $t4
	#dest addr: (word 2)
	andi $t4, $t2, 0xFF
	add $t3, $t3, $t4
	#divident
	li $t5, 1
	sll $t5, $t5, 16
	#divide operation
	div $t3, $t5
	#remainder
	mfhi $v0	
	jr $ra

compare_to:
	move $t2, $a0 #packet object - 1
	lw $t3, 0($t2) #(word 0) - 1
	lw $t4, 4($t2) #(word 1) - 1
	lw $t5, 8($t2) #(word 2) - 1
	move $t6, $a1 #packet object - 2
	lw $t7, 0($t6) #(word 0) - 2
	lw $t8, 4($t6) #(word 1) - 2
	lw $t9, 8($t6) #(word 2) - 2
	#msg id_1: (word 0 -- packet 1)
	srl $t0, $t3, 16
	andi $t0, $t0, 0xFFF
	#msg id_2: (word 0 -- packet 2)
	srl $t1, $t7, 16
	andi $t1, $t1, 0xFFF
	#if equal
	beq $t0, $t1, msg_id_equal_compare_to
	#elif p1.msg_id > p2.msg_id then
	bgt $t0, $t1, p1.msg_id_greater
		#if p1.msg_id < p2.msg_id then
		li $v0, -1
		j final_return_compare_to
	p1.msg_id_greater:
		#elif p1.msg_id > p2.msg_id then
		li $v0, 1
		j final_return_compare_to
	#else if equal
	msg_id_equal_compare_to:
		#frag offset: (word 1 -- packet 1)
		andi $t0, $t4, 0xFFF
		#frag offset: (word 1 -- packet 2)
		andi $t1, $t8, 0xFFF
		#if equal
		beq $t0, $t1, frag_offset_equal_compare_to
		#if p1.fragment_offset > p2.fragment_offset then
		bgt $t0, $t1, p1.frag_offset_greater
			#if p1.fragment_offset < p2.fragment_offset then
			li $v0, -1
			j final_return_compare_to
		p1.frag_offset_greater:
			#elif p1.fragment_offset > p2.fragment_offset then
			li $v0, 1
			j final_return_compare_to
		#else if equal
		frag_offset_equal_compare_to:
			#src addr: (word 2 -- packet 1)
			srl $t0, $t5, 8
			andi $t0, $t0, 0xFF
			#src addr: (word 2 -- packet 2)
			srl $t1, $t9, 8
			andi $t1, $t1, 0xFF
			#if equal
			beq $t0, $t1, src_addr_equal_compare_to
			#if p1.src_addr > p2.src_addr then
			bgt $t0, $t1, p1.src_addr_greater
				#if p1.src_addr < p2.src_addr then
				li $v0, -1
				j final_return_compare_to
			p1.src_addr_greater:
				#elif p1.src_addr > p2.src_addr then
				li $v0, 1
				j final_return_compare_to
			#else if equal
			src_addr_equal_compare_to:
				li $v0, 0
	#jump to final
	final_return_compare_to:
		jr $ra

packetize:
	#allocating stack
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
	#arguments
	move $s0, $a0 #packet
	move $s1, $a1 #msg
	move $s2, $a2 #payload_size
	move $s3, $a3 #version
	li $s4, 0 #frag_offset
	move $s5, $s0 #previous packet buffer
	move $s6, $s0 #current packet buffer
	#start off with putting payload size, so doesn't have a stopping condition
	move $v0, $s2
	li $s7, 0 #packet_counter
	#loop to load packets
	loop_load_packets_packetize:
		#if number of letters doen't equal payload then last packet, so jump
		bne $v0, $s2, done_loop_load_packets_packetize
		#special case where you should not create an additional packet because of null terminator
		beqz $s7, first_packet_processing_packetize
		#load last loaded bit
		lbu $t0, -1($s6)
		#if 0, then jump
		beqz $t0, done_loop_load_packets_packetize
		first_packet_processing_packetize:
		#move current packet memory place into previous
		move $s5, $s6
		#loading arguments for function call
		lw $t4, 36($sp)  # msg_id
		lw $t5, 40($sp)  # priority
		lw $t6, 44($sp)  # protocol
		lw $t7, 48($sp) # src_addr
		lw $t8, 52($sp) # dest_addr
		addi $sp, $sp, -24
		move $a0, $s6 #current packet buffer
		move $a1, $s1 #msg-string
		move $a2, $s2 #payload_size
		move $a3, $s3 #version
		sw $t4, 0($sp)  # msg_id
		sw $t5, 4($sp)  # priority
		sw $t6, 8($sp)  # protocol
		sw $t7, 12($sp) # src_addr
		sw $t8, 16($sp) # dest_addr
		sw $s4, 20($sp) # frag_offset
		#makes the next packet
		jal make_packet
		addi $sp, $sp, 24
		add $s4, $s4, $v0 #add to frag_offset
		add $s1, $s1, $v0 #add char count to index in string
		move $s6, $v1 #move ended of loaded packet buffer into current
		#jump back to continue
		addi $s7, $s7, 1 #inc packet counter
		j loop_load_packets_packetize
	done_loop_load_packets_packetize:
		#store 0 flag into last packet
		#$s5 has previous packet buffer
		lbu $t0, 6($s5)
		#makes first to bits of byte 6 in last packet 00
		andi $t0, $t0, 0x3F
		sb $t0, 6($s5)
		#update checksum
		move $a0, $s5
		jal compute_checksum
		#$t0 now contains correct checksum value
		move $t0, $v0
		#shift the checksum to the right place
		sll $t0, $t0, 16
		#go to correct place in memory (word 2 of last packet)
		addi $t1, $s5, 8
		#load word at that place
		lw $t2, 0($t1)
		#only keep source and destination part
		andi $t2, $t2, 0xFFFF
		#concatonate the new checksum and old values
		add $t2, $t2, $t0
		#store in the same place
		sw $t2, 0($t1)
		move $v0, $s7 #return packet counter
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

clear_queue:
	move $t0, $a0 #queue
	move $t1, $a1 #max_queue_size
	#if  maxqueuesize > 0, continue
	bgtz $t1, continue_clear_queue
		#else return -1 and jump out
		li $v0, -1
		j end_process_clear_queue
		#continue
	continue_clear_queue:
		lhu $t2, 0($t0) #size
		addi $t3, $t0, 4 #starting memory of addresses
		li $t4, 0 #counter
		#loop to clear queue
		loop_clear_queue:
			#if counter equals original num elements, jump out
			beq $t4, $t2, done_loop_clear_queue
			#move counter to $t5
			move $t5, $t4
			#multiply by 4 because word
			sll $t5, $t5, 2
			#add to base address
			add $t5, $t5, $t3
			#store 0
			li $t6, 0
			sw $t6, 0($t5)
			addi $t4, $t4, 1 #inc counter
			j loop_clear_queue
		done_loop_clear_queue:
			#store 0 into number of elements
			li $t6, 0
			sh $t6, 0($t0)
			#store max size
			sh $t1, 2($t0)
			#return 0
			li $v0, 0
	end_process_clear_queue:
		jr $ra

enqueue:
	#allocating stack
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
	#arguments
	move $t0, $a0 #queue
	move $t1, $a1 #packet
	lhu $t2, 0($t0) #size
	lhu $t3, 2($t0) #max_queue_size
	#if size is less than max, continue
	blt $t2, $t3, continue_enqueue
		#else, return max and jump
		move $v0, $t3
		j end_process_enqueue
	#continuation
	continue_enqueue:
		#add to end of array
		addi $t4, $t0, 4 #skip over size and max
		#go to correct index and mult by 4 because word
		move $t5, $t2
		sll $t5, $t5, 2
		#$t5 has place in memory of last element
		add $t5, $t5, $t4
		#store word into last index
		sw $t1, 0($t5)
		addi $t2, $t2, 1 #inc size
		sh $t2, 0($t0) #size
		#saving important information
		move $s0, $t0 #queue
		move $s1, $t1 #packet
		addi $s2, $t2, -1 #index of child (i)
		#$s3 is the index of the parent (i-1)/2
		addi $s3, $s2, -1
		srl $s3, $s3, 1  
		#loop for heapifying
		loop_enqueue:
			#if parent is negative jump
			bltz $s3, done_loop_enqueue
			#if child is negative or 0, jump
			blez $s2, done_loop_enqueue
			#child packet
			move $s4, $s2
			sll $s4, $s4, 2
			addi $s4, $s4, 4
			add $s4, $s4, $s0
			#loading child address into $s5
			lw $s5, 0($s4)
			#parent packet
			move $s6, $s3
			sll $s6, $s6, 2
			addi $s6, $s6, 4
			add $s6, $s6, $s0
			#loading parent packet into $s7
			lw $s7, 0($s6)
			#compare now
			move $a0, $s5
			move $a1, $s7
			jal compare_to
			#if greater than or equal zero, process finished
			bgez $v0, done_loop_enqueue
			#now process swap
			sw $s7, 0($s4)
			sw $s5, 0($s6)
			#update parent and child indices
			move $s2, $s3 #move previous parent into child
			#loading new parent (i-1)/2
			addi $s3, $s2, -1
			srl $s3, $s3, 1  
			j loop_enqueue
		done_loop_enqueue:
			#return current size
			lhu $v0, 0($s0) #size
		#process complete
	end_process_enqueue:
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

dequeue:
	#allocating stack
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
	move $s0, $a0 #queue
	lhu $s1, 0($s0) #size
	#if queue has 0 elements return 0 and jump
	bgtz $s1, continue_dequeue
		li $v0, 0
		j end_process_dequeue
	#else continue
	continue_dequeue:
		#jump over the first word to access the array
		addi $t0, $s0, 4
		#$s2 has dequeued element and stores it into $s2 to return it later
		lw $s2, 0($t0)
		#decreases size by 1 and stores into size
		addi $s1, $s1, -1
		sh $s1, 0($s0) #stores size into first half
		#go to last element and acquire it, and place 0 there
		move $t1, $s1
		sll $t1, $t1, 2 #mult by 4 since word
		addi $t1, $t1, 4 #jump over first word
		add $t1, $t1, $s0 #add to base address for queue
		#load word from last index
		lw $t2, 0($t1)
		#store 0 in last index
		li $t3, 0
		sw $t3, 0($t1)
		#store last element onto the top of the heap
		move $t4, $s0
		addi $t4, $t4, 4
		sw $t2, 0($t4)
		#original parent index
		li $s4, 0
		#left child (1) index
		sll $s5, $s4, 1
		addi $s5, $s5, 1
		#right child (2) index
		sll $s6, $s4, 1
		addi $s6, $s6, 2
		loop_dequeue:
			#loading the size
			lhu $t8, 0($s0) #size
			#if left child index is greater than or equal size, jump
			bge $s5, $t8, done_loop_dequeue
			#left child (1)
			move $t0, $s5
			sll $t0, $t0, 2
			addi $t0, $t0, 4
			add $t0, $t0, $s0
			#loading left child (1) into $t1
			lw $t1, 0($t0)
			#if right is greater than or equal to size, only process left (index out of bounds)
			bge $s6, $t8, left_child_only
			#right child (2)
			move $t2, $s6
			sll $t2, $t2, 2
			addi $t2, $t2, 4
			add $t2, $t2, $s0
			#loading parent packet into $t3
			lw $t3, 0($t2)
			#if left child is null, can no longer heapify
			beqz $t1, done_loop_dequeue
			#if right child is not equal to zero, compare both
			bnez $t3, compare_children_dequeue
			#else, only load left child index into $s7
			left_child_only:
				move $s7, $s5
				#continue to compare child to parent
				j continue_heapify_dequeue
			#compare left child and right child
			compare_children_dequeue:
				#load arguments and compare
				move $a0, $t1
				move $a1, $t3
				jal compare_to
				#if greater than 0, then left child is bigger, so use right
				bgtz $v0, right_child_smaller_dequeue
					#else use left child index
					move $s7, $s5
					#continue process
					j continue_heapify_dequeue
				#use right child
				right_child_smaller_dequeue:
					move $s7, $s6
			#compare child to parent
			continue_heapify_dequeue:
				#parent packet
				move $t0, $s4
				sll $t0, $t0, 2
				addi $t0, $t0, 4
				add $t0, $t0, $s0
				#loading parent address into $s1
				lw $s1, 0($t0)
				#child packet
				move $t1, $s7
				sll $t1, $t1, 2
				addi $t1, $t1, 4
				add $t1, $t1, $s0
				#loading child packet into $s3
				lw $s3, 0($t1)
				#compare now
				move $a0, $s1
				move $a1, $s3
				jal compare_to
				#if less than or equal zero, parent is smaller than child, process finished
				blez $v0, done_loop_dequeue
				#now process swap
				#parent index
				move $t0, $s4
				sll $t0, $t0, 2
				addi $t0, $t0, 4
				add $t0, $t0, $s0
				#child index
				move $t1, $s7
				sll $t1, $t1, 2
				addi $t1, $t1, 4
				add $t1, $t1, $s0
				#store in opposite places
				sw $s3, 0($t0)
				sw $s1, 0($t1)
				#update parent and child indices
				move $s4, $s7 #move previous child into parent
				#loading new child 1 (2i+1)
				sll $s5, $s4, 1
				addi $s5, $s5, 1
				#loading new child 2 (2i+2)
				sll $s6, $s4, 1
				addi $s6, $s6, 2
			j loop_dequeue
		done_loop_dequeue:
			#return dequeued value
			move $v0, $s2
	end_process_dequeue:
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

assemble_message:
	#allocating stack
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp) 
	#load in arguments
	move $s0, $a0 #msg
	move $s1, $a1 #queue
	li $s2, 0 #num of dequeued packets
	li $s3, 0 #num of failed checksum tests
	#loop to dequeue packets
	outer_loop_assemble_message:
		#dequeue method, load queue
		move $a0, $s1
		jal dequeue
		#if can no longer dequeue elements, then jump out
		beqz $v0, done_outer_loop_assemble_message
		#$s4 now has the address of the packet
		move $s4, $v0
		#compute checksum
		move $a0, $s4
		jal compute_checksum
		#different words of the packet
		lw $t0, 0($s4) #(word 0)
		lw $t1, 4($s4) #(word 1)
		lw $t2, 8($s4) #(word 2)
		addi $t3, $s4, 12 # (word 3 - string address)
		#src addr: (word 2) to load the cuurent value of checksum
		srl $t4, $t2, 16
		andi $t4, $t4, 0xFFFF
		#they are equal, so no need to increment invalid checksum counter
		beq $t4, $v0, continue_string_process_assemble_message
			addi $s3, $s3, 1
		#continue processing string
		continue_string_process_assemble_message:
			#total length: (word 0)
			andi $t5, $t0, 0xFFFF
			#subtract total length by 12 to get the length of the word
			addi $t5, $t5, -12
			#starting address of word
			move $t6, $t3
			li $t7, 0 #character counter
			inner_loop_assemble_message:
				#if counter is equal to string length, jump
				beq $t7, $t5, done_inner_loop_assemble_message
				#load byte at the string address
				lbu $t8, 0($t6)
				#store into the real string
				sb $t8, 0($s0)
				addi $t7, $t7, 1 #inc char counter
				addi $t6, $t6, 1 #inc packet memory address
				addi $s0, $s0, 1 #inc return string memory address
				#jump back to continue processing string
				j inner_loop_assemble_message
			done_inner_loop_assemble_message:
				#increment number of packets processed
				addi $s2, $s2, 1
		#jump back to continue processing more packets
		j outer_loop_assemble_message
	done_outer_loop_assemble_message:
		move $v0, $s2 #return num of dequeued packets
		move $v1, $s3 #return num of failed checksum tests
		#load memory back into registers
		lw $s4, 0($sp)
		lw $s3, 4($sp) 
		lw $s2, 8($sp)
		lw $s1, 12($sp)
		lw $s0, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24
		jr $ra

make_packet:
	lw $t4, 0($sp)  # msg_id
	lw $t5, 4($sp)  # priority
	lw $t6, 8($sp)  # protocol
	lw $t7, 12($sp) # src_addr
	lw $t8, 16($sp) # dest_addr
	lw $t9, 20($sp) # frag_offset
	#allocating stack
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
	#arguments
	move $s0, $a0 #packet_buffer
	move $s1, $a1 #msg-string
	move $s2, $a2 #payload_size
	move $s3, $a3 #version
	move $s4, $t4 #msg_id
	move $s5, $t5 #priority
	move $s6, $t6 #protocol
	move $s7, $t7 #src_addr
	move $t0, $t8 #dest_addr
	move $t9, $t9 #frag_offset
	#process for storing string into packet
	addi $t1, $s0, 12 #payload_buffer
	#char letter counter
	li $v0, 0
	li $t2, 0 #payload_size_counter
	#loop to store string
	loop_make_packet:
		#if payload hit jump
		beq $t2, $s2, done_loop_make_packet
		#load byte from string
		lbu $t3, 0($s1)
		#if null terminator hit, jump
		beqz $t3, done_loop_make_packet
		#store byte into payload buffer
		sb $t3, 0($t1) 
		addi $s1, $s1, 1 #inc string msg memory
		addi $t1, $t1, 1 #in packet payload memory
		addi $v0, $v0, 1 #inc return num of strings copied
		addi $t2, $t2, 1 #inc counter
		#jump back
		j loop_make_packet
	done_loop_make_packet:
	#if payload not hit, then short string, store null terminator
	beq $t2, $s2, continue_make_packet
		#null terminator in $t3
		sb $t3, 0($t1)
		addi $v0, $v0, 1
		addi $t2, $t2, 1
	#continue process
	continue_make_packet:
	addi $t4, $s0, 0 #(word 0)
	addi $t5, $s0, 4 #(word 1)
	addi $t6, $s0, 8 #(word 2)
	#storing values into word 0
	li $t7, 0 # (word 1 value)
	#version: (word 0)
	sll $t7, $t7, 4
	add $t7, $t7, $s3
	#msg id: (word 0)
	sll $t7, $t7, 12
	add $t7, $t7, $s4
	#total length: (word 0)
	addi $t8, $v0, 12
	sll $t7, $t7, 16
	add $t7, $t7, $t8
	#store into first word
	sw $t7, 0($t4)
	#concatonating values to put into word 1
	li $t7, 0 # (word 1 value)
	#priority: (word 1)
	sll $t7, $t7, 8
	add $t7, $t7, $s5
	#flags: (word 1)
	sll $t7, $t7, 2
	addi $t7, $t7, 1
	#protocol: (word 1)
	sll $t7, $t7, 10
	add $t7, $t7, $s6
	#frag offset: (word 1)
	sll $t7, $t7, 12
	add $t7, $t7, $t9
	#storing into word 1
	sw $t7, 0($t5)
	#storing values into word 2
	li $t7, 0 # (word 2 value)
	#src addr: (word 2)
	sll $t7, $t7, 8
	add $t7, $t7, $s7
	#dest addr: (word 2)
	sll $t7, $t7, 8
	add $t7, $t7, $t0
	#total length: (word 0)
	sw $t7, 0($t6)
	#storing values to keep place
	move $s4, $t6
	move $s5, $t7
	move $s7, $v0
	#moving piece to calculate checksum
	move $a0, $s0
	jal compute_checksum
	#restoring values
	move $t6, $s4
	move $t7, $s5
	#storing checksum
	move $t0, $v0
	#shifting to the beginning
	sll $t0, $t0, 16
	#adding original value
	add $t7, $t7, $t0
	#storing into word 2
	sw $t7, 0($t6)
	move $v0, $s7 #number of lettersprocessed
	addi $v1, $v0, 12 #num letters + 12 bytes
	add $v1, $v1, $s0 #exact continuation in packet memory
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
	
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
