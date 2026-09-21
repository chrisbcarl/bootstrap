# java -jar MARS4_5.jar nc '$v0' call.asm

main:
	li $t0, 5
	li $t1, 10
	jal addNumbers  	# call a subroutine
	move $t2, $v0
	j end

addNumbers:
	add $v0, $t0, $t1
	jr $ra				# return from a subroutine

end:
