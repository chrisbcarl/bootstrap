# java -jar MARS4_5.jar nc '0x10010000-0x10010050' bubblesort.asm
# note, reads better in MARS with the tabs, doesnt read well in vscode

.data
	array:	.word 256, 16, 8, 4096, 2, 32768, 32, 8192, 4, 64, 128, 16384, 512, 1024, 2048, 65536, 8192, 2147483647  # 2147483648 is a negative, 0x8000000
	size:	.word 18

.text
	main:

	bubblesort_discussion:
		# for (j in n - 1)
		# 	for (i in n - 1)
		# 		if (array[i] > array[i + 1])
		# 			swap(array[i], array[i + 1])
		la	$t0,	array		# $t0 <- array (the address)
		add	$t1,	$zero, $zero	# $t1 <- i

		# $t2 <- array + i*4 (the address)
		mul	$t2,	$t1,	4	# $t2 <- i*4
		add	$t2,	$t0,	$t2	# $t2 <- array + i*4 ( the address)

		# $t3 <- array[i] (value)
		lw	$t3,	0($t2)		# $t3 <- *$t2
		# $t4 <- array[i + 1] (value)
		lw	$t4,	4($t2)		# $t4 <- *($t2 + 4)

	bubblesort:
		# need array, n, j, i, will use shift to multiply, and shift to divide to get back the i
		la	$t0,	array			# array
		lw	$t1,	size			# n
		add	$t2,	$zero,	$zero		# j = 0, count up
		add	$t3,	$zero,	$zero		# i = 0, count up
		add	$t4,	$zero,	$zero		# unused
		add	$t5,	$zero,	$zero		# effective address of base + i*4
		add	$t6,	$zero,	$zero		# value of array[i]
		add	$t7,	$zero,	$zero		# value of array[i+1]

	# bubblesort loop outer
	bubblesort_lou:					# for (j in n - 1)
		add	$t2,	$t2,	1		# 	j += 1
		beq	$t2,	$t1,	bubblesort_end		# 	if (j == n): goto outer end
		add	$t3,	$zero,	$zero		# 	else       : goto inner start, set i = 0

	# bubblesort loop inner
	bubblesort_lin:					# 	for (i in n-1)
		add	$t3,	$t3,	1		# 		i += 1
		beq	$t3,	$t1,	bubblesort_lou	# 		if (i == n): goto outer loop
							# 		else       : goto inner loop

		add	$t5,	$t3,	$zero		# effective address i+1
		sll	$t5,	$t5,	2		# effective address (i+1) *= 4
		add	$t5,	$t5,	$t0		# effective address = array + (i+1)*4
		lw	$t6,	-4($t5)			# array[i] value
		lw	$t7,	0($t5)			# array[i+1] value
		blt	$t6,	$t7,	bubblesort_lin	# if (array[i] < array[i+1]): goto loop inner start
									# else:                       swap(array[i], array[i + 1])
		sw	$t7,	-4($t5)			# we already have the values, so set @[array + i*4] = *(array + (i+1)*4)
		sw	$t6,	0($t5)			# @[array + (i+1)*4] = @(array + i*4)

		b	bubblesort_lin

	bubblesort_end:

