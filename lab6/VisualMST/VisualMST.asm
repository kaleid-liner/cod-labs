.data 
xcord:
	.space 24
ycord:
	.space 24
edge_len:
	# C26 = 15
	.space 60
edge_v0:
	.space 60
edge_v1:
	.space 60
tag:
	.space 24
res:
	.space 20
.text
_start:
	# input...
	
	addi $fp, $zero, 6
	addi $ra, $zero, 5
	la $s0, xcord
	la $s1, ycord
	la $s2, edge_len
	la $s3, edge_v0
	la $s4, edge_v1
	la $s5, tag
	la $s6, res
	
	# calculate length
calc:
	# ptr of outer loop
	addi $t0, $s0, 0
	addi $t1, $s1, 0
	addi $t2, $s2, 0
	addi $t3, $s3, 0
	addi $t4, $s4, 0
	# index of outer loop
	addi $a2, $zero, 0
	
	outer_loop:
	# index of inner loop
	addi $a3, $a2, 1
	# ptr of inner loop
	addi $a0, $t0, 4
	addi $a1, $t1, 4
	
	inner_loop:
		sw $a2, ($t3)
		sw $a3, ($t4)
		lw $t5, ($t0)
		lw $t6, ($t1)
		lw $t7, ($a0)
		lw $t8, ($a1)
		
		bgeu $t5, $t7, rev
		sub $k0, $t7, $t5
		j absend
		rev:
		sub $k0, $t5, $t7
		absend:
		bgeu $t6, $t8, rev2
		sub $k1, $t8, $t6
		j absend2
		rev2:
		sub $k1, $t6, $t8
		absend2:
		
		add $k0, $k0, $k1
		sw $k0, ($t2)
		
		addi $a3, $a3, 1
		addi $t3, $t3, 4
		addi $t4, $t4, 4
		addi $t2, $t2, 4
		addi $a0, $a0, 4
		addi $a1, $a1, 4
		
		bne $a3, $fp, inner_loop
	
	addi $a2, $a2, 1
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	bne $a2, $ra, outer_loop
	
	# sort, bubble
sort:
	addi $ra, $zero, 1
	# end
	addi $t9, $zero, 5
	
	sort_outer_loop:
	addi $t2, $s2, 0
	addi $t3, $s3, 0
	addi $t4, $s4, 0
	
	addi $a0, $zero, 0
	
	sort_inner_loop:
		lw $t0, ($t2)
		lw $t1, 1($t2)
		
		bgeu $t1, $t0, noswap
		sw $t0, 1($t2)
		sw $t1, 1($t2)
		lw $t0, ($t3)
		lw $t1, 1($t3)
		sw $t0, 1($t3)
		sw $t1, ($t3)
		lw $t0, ($t4)
		lw $t1, 1($t4)
		sw $t0, 1($t4)
		sw $t1, ($t4)
		
		noswap
		addi $a0, $a0, 1
		addi $t2, $t2, 4
		addi $t3, $t3, 4
		addi $t4, $t4, 4
		
		bne $a0, $t9, sort_inner_loop
	
	addi $t9, $t9, -1
	bne $t9, $ra, sort_outer_loop

solution:
	addi $ra, $zero, 24
	addi $fp, $zero, 1
	addi $t0, $zero, 0
	addi $t3, $s3, 0
	addi $t4, $s4, 0
	addi $t6, $s6, 0
	# res count
	addi $a0, $zero, 0
	
	solution_loop:
	lw $v0, ($t3)
	lw $v1, ($t4)
	add $k0, $v0, $s5
	add $k1, $v1, $s5
	lw $t1, ($k0)
	lw $t2, ($k1)
	
	bne $t1, $zero, next
	bne $t2, $zero, next
	sw $fp, ($k0)
	sw $fp, ($k1)
	sw $a0, ($t6)
	addi $a0, $a0, 1
	addi $t6, $t6, 4
	
	next:
	addi $a0, $a0, 1
	bne $a0, $ra, solution_loop
