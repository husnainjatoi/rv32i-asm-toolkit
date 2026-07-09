# RISC-V Assembly Grand Challenge

![Language](https://img.shields.io/badge/Language-RISC--V_Assembly-blue)
[![Status](https://img.shields.io/badge/Status-Completed-success)]()
![Environment](https://img.shields.io/badge/Environment-Venus_Simulator-orange)

**Author:** Husnain Jatoi  
**Project:** Maktab-e-Digital Systems Lab Module 3 Capstone 

## Project Description
A comprehensive suite of bare-metal RISC-V assembly programs engineered to demonstrate low-level architectural control, strict calling convention compliance, and hardware-software interfacing. Developed as the capstone for MEDS Module 3, this project bridges high-level programming logic with execution at the ISA level. It features array manipulation routines, deeply recursive algorithms with complete stack frame management, and a custom assembly-native instruction decoder that parses hexadecimal machine code back into human-readable mnemonics.

## Repository Structure
```text
rv32i-asm-toolkit/
├── docs/                          
│   ├── ENCODING_WORKSHEET.md       # Manual 32-bit binary instruction encoding
│   ├── EXTENSION_SUMMARY.md        # Technical breakdown of the RV 'C' Extension
│   └── PRIVILEGED_SUMMARY.md       # Technical breakdown of RV Privileged Modes
├── screenshots/                    # Venus execution screenshots
│   ├── part1_output.png
│   ├── part2_output_top.png
│   ├── part2_output_bottom.png
│   └── part3_output.png
├── part1_array_ops.s               # Array processing suite & Selection Sort
├── part2_recursion.s               # Call-stack recursion: Fibonacci & Tower of Hanoi
├── part3_encoding.s                # Dynamic instruction decoder and mini-disassembler
├── .gitignore                      # Ignore IDE settings, temporary scratch files, and compiled build artifacts
└── README.md                       # Project documentation
```

## Core Capabilities
* **Strict Calling Conventions:** Implements rigorous stack frame management (`sp` allocation, saving/restoring `ra` and callee-saved `s0`-`s11` registers) across all leaf and recursive functions to prevent state corruption.
* **Complex Recursion Handling:** Executes mathematical recursion natively in assembly. Features an optimized Fibonacci sequence using `.data` array memoization (caching) and a programmatic solver for the Tower of Hanoi.
* **Assembly-Native Disassembly:** Utilizes shift-and-mask bitwise operations natively in assembly to decode raw hexadecimal machine codes (`0x007302B3`) into their component fields (Opcode, `rd`, `funct3`, `rs1`) and corresponding textual mnemonics.
* **In-Place Memory Manipulation:** Features memory-safe array traversals, pointer arithmetic, and a fully functional in-place Selection Sort algorithm that mutates and prints dynamic data segments.

## Execution and Validation Environment

### Prerequisites
This project does not require a local toolchain (like GCC or GNU Make). All logic is built and validated against the standard RISC-V 32-bit instruction set using the Venus web environment.
* **Venus RISC-V Simulator:** [https://venus.cs61c.org/](https://venus.cs61c.org/)

### Simulation Instructions
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/husnainjatoi/rv32i-asm-toolkit
   cd rv32i-asm-toolkit
   ```
2. Navigate to the Venus Simulator in your browser.
3. Open the **Editor** tab and paste the raw text of the desired target file (e.g., `part1_array_ops.s`).
4. Switch to the **Simulator** tab.
5. Click **Assemble & Simulate** to compile the raw source.
6. Click **Run** to execute the datapath. View the standard output in the Venus console.

## Execution Summary (Sample Outputs)

### Part 1: Array Processing & Selection Sort
```text
Sum: 181
Max: 100
Min: -43
Negative Count: 3
Sorted array: -43 -11 -4 1 6 7 10 12 13 24 66 100
```

### Part 2: Recursive Algorithms
```text
Fibonacci(5): 5
Fibonacci(10): 55
Fibonacci(15): 610
Fibonacci(20): 6765

--- Tower of Hanoi ---

Move disk 1 from A to C
Move disk 2 from A to B
Move disk 1 from C to B
Move disk 3 from A to C
Move disk 1 from B to A
Move disk 2 from B to C
Move disk 1 from A to C

...
```

### Part 3: Instruction Decoder & Disassembler
```text
Instruction: 0x007302B3 | Opcode: 51 | rd: x5 | funct3: 0 | rs1: x6 | Mnemonic: add x5, x6, x7
Instruction: 0x00F50513 | Opcode: 19 | rd: x10 | funct3: 0 | rs1: x10 | Mnemonic: addi x10, x10, 15
Instruction: 0x00112623 | Opcode: 35 | rd: x12 | funct3: 2 | rs1: x2 | Mnemonic: sw x1, 12(x2)
Instruction: 0x01DE0463 | Opcode: 99 | rd: x8 | funct3: 0 | rs1: x28 | Mnemonic: beq x28, x29, 8
Instruction: 0x12345437 | Opcode: 55 | rd: x8 | funct3: 5 | rs1: x8 | Mnemonic: lui x8, 0x00012345
Instruction: 0x010000EF | Opcode: 111 | rd: x1 | funct3: 0 | rs1: x0 | Mnemonic: jal x1, 16
```