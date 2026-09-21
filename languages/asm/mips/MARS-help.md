# Shortcuts
|Task     |Key|
|---      |---|
|Assemble |F3 |
|Step Once|F7 |
|Go       |F5 |
|Reset    |F12|


# Command Line
[Command Line Documentation](https://dpetersanderson.github.io/Help/MarsHelpCommand.html)
- most common

```bash
# gui (synchronous)
java -jar mars.jar

# Assemble, run, display registers $s0 and $s1, display contents of memory 0x10010000-0x10010010.
java -jar mars.jar '$s0' '$s1' '0x10010000-0x10010010' fibonacci.asm

# Assemble and simulate fibonacci.asm. At end of simulation, dump the contents of addresses 0x1001000 to 0x10010020 to file hexdata.txt in hexadecimal text format with one word per line.
java -jar mars.jar dump 0x10010000-0x10010020 HexText hexcode.txt fibonacci.asm

# Displays command options and explanations.
java -jar mars.jar h
```

- least common

```bash
# Assemble fibonacci.asm. Does not attempt to run the program, and the assembled code is not saved.
java -jar mars.jar a fibonacci.asm

# Assemble and run infinite.asm for a maximum of 100,000 execution steps.
java -jar mars.jar 100000 infinite.asm

# Assemble major.asm and all other files in the same directory, link the assembled code, and run starting with the first instruction in major.asm.
java -jar mars.jar p major.asm

# Assemble and link major.asm, minor.asm and sub.asm. If successful, execution will begin with the first instruction in major.asm.
java -jar mars.jar major.asm minor.asm sub.asm

# Assemble fibonacci.asm without simulating (note use of 'a' option). At end of assembly, dump the text segment (machine code) to file hexcode.txt in hexadecimal text format with one instruction per line.
java -jar mars.jar a dump .text HexText hexcode.txt fibonacci.asm

# Assemble and run process.asm with two program argument values, "counter" and "10". It may retrieve the argument count (2) from $a0, and the address of an array containing pointers to the strings "count" and "10", from $a1. At the end of the run, display the contents of register $t0.
java -jar mars.jar t0 process.asm pa counter 10
```


# Usage
```text
MARS 4.5  Copyright 2003-2014 Pete Sanderson and Kenneth Vollmar

Usage:  Mars  [options] filename [additional filenames]
  Valid options (not case sensitive, separate by spaces) are:
      a  -- assemble only, do not simulate
  ae<n>  -- terminate MARS with integer exit code <n> if an assemble error occurs.
  ascii  -- display memory or register contents interpreted as ASCII codes.
      b  -- brief - do not display register/memory address along with contents
      d  -- display MARS debugging statements
     db  -- MIPS delayed branching is enabled
    dec  -- display memory or register contents in decimal.
   dump <segment> <format> <file> -- memory dump of specified memory segment
            in specified format to specified file.  Option may be repeated.
            Dump occurs at the end of simulation unless 'a' option is used.
            Segment and format are case-sensitive and possible values are:
            <segment> = .text, .data
            <format> = AsciiText, Binary, BinaryText, HexText, HEX, SegmentWindow
      h  -- display this help.  Use by itself with no filename.
    hex  -- display memory or register contents in hexadecimal (default)
     ic  -- display count of MIPS basic instructions 'executed'
     mc <config>  -- set memory configuration.  Argument <config> is
            case-sensitive and possible values are: Default for the default
            32-bit address space, CompactDataAtZero for a 32KB memory with
            data segment at address 0, or CompactTextAtZero for a 32KB
            memory with text segment at address 0.
     me  -- display MARS messages to standard err instead of standard out.
            Can separate messages from program output using redirection
     nc  -- do not display copyright notice (for cleaner redirected/piped output).
     np  -- use of pseudo instructions and formats not permitted
      p  -- Project mode - assemble all files in the same directory as given file.
  se<n>  -- terminate MARS with integer exit code <n> if a simulation (run) error occurs.
     sm  -- start execution at statement with global label main, if defined
    smc  -- Self Modifying Code - Program can write and branch to either text or data segment
    <n>  -- where <n> is an integer maximum count of steps to simulate.
            If 0, negative or not specified, there is no maximum.
 $<reg>  -- where <reg> is number or name (e.g. 5, t3, f10) of register whose
            content to display at end of run.  Option may be repeated.
<reg_name>  -- where <reg_name> is name (e.g. t3, f10) of register whose
            content to display at end of run.  Option may be repeated.
            The $ is not required.
<m>-<n>  -- memory address range from <m> to <n> whose contents to
            display at end of run. <m> and <n> may be hex or decimal,
            must be on word boundary, <m> <= <n>.  Option may be repeated.
     pa  -- Program Arguments follow in a space-separated list.  This
            option must be placed AFTER ALL FILE NAMES, because everything
            that follows it is interpreted as a program argument to be
            made available to the MIPS program at runtime.
If more than one filename is listed, the first is assumed to be the main
unless the global statement label 'main' is defined in one of the files.
Exception handler not automatically assembled.  Add it to the file list.
Options used here do not affect MARS Settings menu values and vice versa.
```
