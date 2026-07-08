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
    # Storing original registers to stack perfectly following calling convention
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
        beq s2, s1, exit      # Loop terminating condition
        lw s0, 0(s3)          # Load instruction[i]
        
        # 1. Print full instruction (in Hex)
        la a1, str_inst
        mv a2, s0             
        li a3, 34             # Syscall 34: Print Hex
        call print_field
        
        # 2. Extract and Print Opcode (Bits 0-6)
        andi a2, s0, 0x7F    
        la a1, str_op
        li a3, 1              # Syscall 1: Print Integer
        call print_field
        
        # 3. Extract and Print rd (Bits 7-11)
        srli a2, s0, 7
        andi a2, a2, 0x1F
        la a1, str_rd
        li a3, 1
        call print_field
        
        # 4. Extract and Print funct3 (Bits 12-14)
        srli a2, s0, 12
        andi a2, a2, 0x07
        la a1, str_f3
        li a3, 1
        call print_field
        
        # 5. Extract and Print rs1 (Bits 15-19)
        srli a2, s0, 15
        andi a2, a2, 0x1F
        la a1, str_rs1
        li a3, 1
        call print_field
        
        # 6. Print newline for the next instruction
        la a1, str_newline
        li a0, 4
        ecall
        
        # Incrementing loop counter and address pointer
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

print_field:
    # 1. Print the string label
    li a0, 4
    ecall
    
    # 2. Print the extracted value
    mv a1, a2
    mv a0, a3
    ecall
    
    ret