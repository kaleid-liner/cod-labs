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
	
	addi $s6, $zero, 0
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
	lw $a2, 0x2000($zero)
	lw $a0, ($t1)
	lw $a1, ($t2)
	
	# s6: flag
	# gp: last_x
	# sp: last_y
	
	bne $s6, $zero, draw
	addi $s6, $zero, 1
	addi $gp, $a0, 0
	addi $sp, $a1, 0
	
	sll $k0, $a1, 7
	add $k0, $k0, $a0
	add $k0, $k0, $t0
	sw $a2, ($k0)
	j key_end
	
	draw:
	addi $s6, $zero, 0
	
	slt $k0, $a0, $gp
	bne $k0, $zero, no_x_swap
	addi $k0, $a0, 0
	addi $a0, $gp, 0
	addi $gp, $k0, 0
	no_x_swap:
	slt, $k0, $a1, $sp
	bne $k0, $zero, no_y_swap
	addi $k0, $a1, 0
	addi $a1, $sp, 0
	addi $sp, $k0, 0
	no_y_swap:
	
	addi $gp, $gp, 1
	addi $sp, $sp, 1
	# a0 -> gp
	# a1 -> sp
	addi $k0, $a0, 0
	draw_outer_loop:
	addi $k1, $a1, 0
		
	draw_inner_loop:
	
		sll $s7, $k1, 7
		add $s7, $s7, $k0
		add $s7, $s7, $t0
		sw $a2, ($s7)
		
		addi $k1, $k1, 1
		bne $k1, $sp, draw_inner_loop
	
	addi $k0, $k0, 1
	bne $k0, $gp, draw_outer_loop
	key_end:
	j loop
	
