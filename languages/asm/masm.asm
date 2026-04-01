; https://www.wikihow.com/Use-MASM-in-Visual-Studio-2022
; https://pastebin.com/4vwxHJ0x

.386
.model flat,stdcall
.stack 4096

; externally defined
ExitProcess PROTO, dwExitCode:DWORD

.data
    array1 DWORD 1,2,3,4
    array2 DWORD 4 DUP(?)

.code
    main PROC
        xor AX,AX       ; clear a register (fastest)

        ; https://stackoverflow.com/a/26134736
        mov esi, OFFSET array1      ; source pointer in esi
        mov edi, OFFSET array2      ; destination in edi
        mov ecx, LENGTHOF array1    ; number of dwords to copy
        cld                         ; clear direction flag so that pointers are increasing
        rep movsd                   ; copy ecx dwords

        INVOKE ExitProcess,69
    main ENDP
    END main
