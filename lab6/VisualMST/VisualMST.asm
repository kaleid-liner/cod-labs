.text
	j _start
	
	j _syscall_0 # IVT: syscall 0
	
	_syscall_0:
	# key data
	_key_poll:
	lw $v0, 0x1001($zero)
	beq $v0, $zero, _key_poll
	lw $v0, 0x1000($zero)
	sw $zero, 0x1001($zero)
	eret
	
_start:
	# vram
	addi $t0, $zero, 1
	sll $t0, $t0, 16
	# x
	sll $t1, $t0, 1
	# y
	addi $t2, $t1, 1
	# rgb
	addi $s0, $zero, 64
	sw $s0, ($t1)
	sw $s0, ($t2)
	
	loop:
	
	addi $s1, $zero, 1 # up
	addi $s2, $zero, 2 # down
	addi $s3, $zero, 3 # left
	addi $s4, $zero, 4 # right
	addi $s5, $zero, 5 # enter
	
	addi $v0, $zero, 1
	syscall
	bne $v0, $s1, key_down
	lw $a0, ($t2)
	addi $a0, $a0, -1
	sw $a0, ($t2)
	j key_end
	
	key_down:
	bne $v0, $s2, key_left
	lw $a0, ($t2)
	addi $a0, $a0, 1
	sw $a0, ($t2)
	j key_end
	
	key_left:
	bne $v0, $s3, key_right
	lw $a0, ($t1)
	addi $a0, $a0, -1
	sw $a0, ($t1)
	j key_end
	
	key_right:
	bne $v0, $s4, key_enter
	lw $a0, ($t1)
	addi $a0, $a0, 1
	sw $a0, ($t1)
	j key_end
	
	key_enter:
	bne $v0, $s5, key_end
	lw $a0, ($t1)
	lw $a1, ($t2)
	
	slti $k0, $a0, 3
	bne $k0, $zero, edge_left
	addi $s0, $a0, -3
	j right_start
	edge_left:
	addi $s0, $zero, 0
	
	right_start:
	slti $k0, $a0, 125
	beq $k0, $zero, edge_right
	addi $s1, $a0, 3
	j up_start
	edge_right:
	addi $s1, $zero, 127
	
	up_start:
	slti $k0, $a1, 3
	bne $k0, $zero, edge_up
	addi $s2, $a1, -3
	j down_start
	edge_up:
	addi $s2, $zero, 0
	
	down_start:
	slti $k0, $a1, 125
	beq $k0, $zero, edge_down
	addi $s3, $a1, 3
	j draw_start
	edge_down:
	addi $s3, $zero, 127
	
	draw_start:
	addi $s1, $s1, 1
	addi $s3, $s3, 1
	
	addi $t8, $s0, 0
	outer_loop:
	addi $t9, $s2, 0
	lw $a0, 0x2000($zero)
	
	inner_loop:
		sll $a1, $t9, 7
		add $a1, $a1, $t8
		add $a1, $a1, $t0
		sw $a0, ($a1)
		
		addi $t9, $t9, 1
		bne $t9, $s3, inner_loop
	
	addi $t8, $t8, 1
	bne $t8, $s1, outer_loop
	
	key_end:
	j loop
	
