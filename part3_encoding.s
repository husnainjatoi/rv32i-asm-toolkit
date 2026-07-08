.data
    # The 6 machine code instructions from the encoding worksheet
    instruction: .word 0x007302B3, 0x00F50513, 0x00112623, 0x01DE0463, 0x12345437, 0x010000EF
    instr_num: .word 6
    
    # Formatting strings
    str_inst:       .string "Instruction: "
    str_op:         .string " | Opcode: "
    str_rd:         .string " | rd: x"
    str_f3:         .string " | funct3: "
    str_rs1:        .string " | rs1: x"
    str_newline:    .string "\n"
    
.text
.globl main

main:
    # Storing original registers to stack
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)
    sw s5, 4(sp)
    
    # Loading number of instructions and ptr to instructions
    la s3, instruction
    la t1, instr_num
    lw s1, 0(t1)
    
    li s2, 0 # Loop counter i
    loop:
        beq s2, s1, exit # Loop terminating condition
        lw s0, 0(s3) # Load instruction[i]
        
        andi t0, s0, 0x7F # Extracting opcode
        
        # Extracting rd
        srli t1, s0, 7
        andi t1, t1, 0x1F
        
        # Extracting funct3
        srli t2, s0, 12
        andi t2, t2, 0x07
        
        # Extracting rs1
        srli t3, s0, 15
        andi t3, t3, 0x1F
        
        # Printing Sequence
        
        li a0, 4
        la a1, str_inst
        ecall # Printing "Instruction: "
        
        li a0, 34
        mv a1, s0
        ecall # Printing instruction
        
        li a0, 4
        la a1, str_op
        ecall # Printing " | opcode: "
        
        li a0, 1
        mv a1, t0
        ecall # Printing opcode
        
        li a0, 4
        la a1, str_rd
        ecall # Printing " | rd: x"
        
        li a0, 1
        mv a1, t1
        ecall # Printing rd
        
        li a0, 4
        la a1, str_f3
        ecall # Printing " | funct3: "
        
        li a0, 1
        mv a1, t2
        ecall # Printing funct3
        
        li a0, 4
        la a1, str_rs1
        ecall # Printing " | rs1: x"
        
        li a0, 1
        mv a1, t3
        ecall # Printing rs1
        
        li a0, 4
        la a1, str_newline
        ecall # Printing newline
        
        # Incrementing loop counter and address
        addi s2, s2, 1
        addi s3, s3, 4
        
        # Jumping back to loop
        j loop
        
exit:
    # Restoring original registers from stack
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    lw s5, 4(sp)
    addi sp, sp, 32

    # Cleanly Exiting program
    li a0, 10
    ecall