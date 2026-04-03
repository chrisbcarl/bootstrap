ASM tricks:

.code
    XOR AL,AL  # clears the register (everything that's the same is 0'd, all will be the same, so store 0 in AL)

    ; goto is bad because its a direct jump. its a hardcoded JMP 12345H.
    ; call is a relative jump. it's a JMP with displacement relative to the next IP.
