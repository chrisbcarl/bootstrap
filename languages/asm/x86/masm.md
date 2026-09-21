# Errors
- `Symbol not defined: ffh` - must be same size as register, so AL can have FFH but AX must have 00FFH...
- A2006: undefined symbol: DGROUP
    - caused by ".model small" or ".model tiny"
    - TODO: root cause
    - people are saying "this is 16bit code, switch to 32"
        - https://masmforum.com/board/index.php?topic=15966.0


# Sample Code
- [write to console no import lib](https://github.com/SilMon/MASM_Examples/blob/main/General/ProcedureDefinitionAndUsage.asm)
- [import libraries for printf](https://github.com/SilMon/MASM_Examples/blob/main/General/Input_Output_Example.asm)


# Rules of Thumb
- MASM != NASM != TASM != GNU ASM (all x86) != MIPS
    - `section .text` in NASM == `.code`
- "cannot perform memory-to-memory": MUST move to a register first, then back, or use string instructions


# x86 Instruction Reference
- the actual bible: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
- HTML
    - https://www.felixcloutier.com/x86/
    - http://ref.x86asm.net/coder32.html - http://ref.x86asm.net/
    - [really good description per instruction](https://c9x.me/x86/)
        - converted https://tizee.github.io/x86_ref_book_web/instruction/
- [microsoft macro assembler reference 6.0 1991](http://bitsavers.informatik.uni-stuttgart.de/pdf/microsoft/masm/Microsoft_MASM_6.0_1991/Microsoft_Macro_Assembler_6.0_Reference_1991.pdf) - up to 486 (80486DX in April 1989)
    - [Macro Assembler Programmer's Guide CD-ROM](https://www.pcjs.org/documents/books/mspl13/masm/mpguide/)
        - breakout https://www.pcjs.org/documents/books/mspl13/masm/
    - [MASM 6.1](https://www.ecsdump.net/wp-content/uploads/2020/12/Macro_Assembler_User_Guide.pdf)
    - [MASM 6.1](https://www.mwftr.com/uC12/MASMReference.pdf)

# Textbooks
- [old sacred texts](https://www.phatcode.net/articles.php?sub=assembly)
    - [intel ia-32 1997](https://www.phatcode.net/articles.php?id=255)
- [art of assembly ecosystem](https://www.plantation-productions.com/Webster/www.artofasm.com/DOS/HardCopy.html)
    - mirror hosted https://www.phatcode.net/res/223/files/html/toc.html
- [irvine ecosystem](https://arian04.github.io/masm-tools-web/irvine/)


# Visual Studio Setup
- Guides
    - [basic](https://www.wikihow.com/Use-MASM-in-Visual-Studio-2022)
    - [x86+x64 project](https://programminghaven.home.blog/2020/02/16/setup-an-assembly-project-on-visual-studio-2019/)
- Visual Studio Installer
    - Modify > Desktop Development with C++
- Create a solution/projects
    - "Empty Project" (C++ flavor)
    - right click solution > Build Dependencies > Build Customizations > enable masm
    - new file `.asm`
- Debug:
    1. View > Terminal (ctrl+`)
    2. Debug > Windows > Watch Watch 1 (should be there by default)
    3. Debug > Windows > Memory > Memory 1
        - access a named by typing &VARIABLE
            - otherwise you'll likely be staring at a bunch of `??` via (address of object)[https://www.poppastring.com/blog/find-the-address-of-an-object-in-visual-studio]
        - right click > signed display (or whatever you want)
    4. Debug > Windows > Registers
        - right click > CPU Segments
        - right click > Flags



# Articles
- [SCAS + interrupt style system calls](https://www.tutorialspoint.com/assembly_programming/assembly_scas_instruction.htm)
- [16bit compilation and interrupt-style syscalls](https://masm32.com/board/index.php?topic=1853.0)
- [All Jump Results](http://unixwiz.net/techtips/x86-jumps.html)
    - [also summary](https://stackoverflow.com/questions/27284895/how-to-compare-a-signed-value-and-an-unsigned-value-in-x86-assembly)
- [array manip in NASM](https://www.tutorialspoint.com/assembly_programming/assembly_arrays.htm)
- [MASM,TASM,NASM examples](https://cs.lmu.edu/~ray/notes/x86assembly/)