# java -jar MARS4_5.jar nc '$a0' '$v0' '0x10010000-0x1001000c' ascii syscall-printstring.asm

.data
    msg:    .asciiz "Hello World"
.text
    main:   la $a0, msg     # Address of string
            li $v0, 4       # Print string syscall
            syscall
