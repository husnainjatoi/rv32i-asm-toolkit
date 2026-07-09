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
    
    
    # Disassembler mnemonic labels
    str_mnemonic:   .string " | Mnemonic: "
    str_add:        .string "add"
    str_addi:       .string "addi"
    str_sw:         .string "sw"
    str_beq:        .string "beq"
    str_lui:        .string "lui"
    str_jal:        .string "jal"
    str_space_x:    .string " x"
    str_comma_x:    .string ", x"
    str_comma_space: .string ", "
    str_lparen_x:    .string "(x"
    str_rparen:      .string ")"
    
.text
.globl main

main:
    # Storing original registers to stack perfectly following calling convention
    addi sp, sp, -48
    sw s7, 44(sp)
    sw s8, 40(sp)
    sw s9, 36(sp)
    sw s10, 32(sp)
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)
    sw s5, 4(sp)
    sw s6, 0(sp)
    
    # Loading number of instructions and ptr to instructions
    la s3, instruction
    la t1, instr_num
    lw s1, 0(t1)
    
    li s2, 0 # Loop counter i
    
    loop:
        beq s2, s1, exit_loop # Loop terminating condition
        lw s0, 0(s3) # Load instruction[i]
        
        # 1. Print full instruction (in Hex)
        la a1, str_inst
        mv a2, s0              
        li a3, 34 # Print Hex
        call print_field
        
        # 2. Extract and Print Opcode (Bits 0-6)
        andi a2, s0, 0x7F
        la a1, str_op
        li a3, 1 # Print Integer
        call print_field
        
        # 3. Extract and Print rd (Bits 7-11)
        srli a2, s0, 7
        andi a2, a2, 0x1F
        mv s6, a2       # Storing for use in disassembler
        la a1, str_rd
        li a3, 1
        call print_field
        
        # 4. Extract and Print funct3 (Bits 12-14)
        srli a2, s0, 12
        andi a2, a2, 0x07
        mv s7, a2       # Storing for use in disassembler
        la a1, str_f3
        li a3, 1
        call print_field
        
        # 5. Extract and Print rs1 (Bits 15-19)
        srli a2, s0, 15
        andi a2, a2, 0x1F
        mv s8, a2       # Storing for use in disassembler
        la a1, str_rs1
        li a3, 1
        call print_field
        
        # Extract rs2 for disassembler use (Bits 20-24)
        srli s10, s0, 20
        andi s10, s10, 0x1F
        
        # Mini disassembler
        # Print " | Mnemonic: "
        la a1, str_mnemonic
        li a0, 4
        ecall
        
        
        andi t4, s0, 0x7F # Extracing opcode again
        # Comparing opcodes to print the correct mnemonic
        li t5, 0x33
        beq t4, t5, print_add   # R-Type (add)
        
        li t5, 0x13
        beq t4, t5, print_addi  # I-Type (addi)
        
        li t5, 0x23
        beq t4, t5, print_sw    # S-Type (sw)
        
        li t5, 0x63
        beq t4, t5, print_beq   # B-Type (beq)
        
        li t5, 0x37
        beq t4, t5, print_lui   # U-Type (lui)
        
        li t5, 0x6F
        beq t4, t5, print_jal   # J-Type (jal)
        
        j print_newline
            
        print_add:
            la a1, str_add
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s6 # rd
            li a0, 1
            ecall
            
            la a1, str_comma_x
            li a0, 4
            ecall
            
            mv a1, s8 # rs1
            li a0, 1
            ecall

            la a1, str_comma_x
            li a0, 4 
            ecall
            
            mv a1, s10 # rs2
            li a0, 1 
            ecall
            
        j print_newline
        
        print_addi:
            la a1, str_addi
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s6
            li a0, 1 # rd
            ecall
            
            la a1, str_comma_x
            li a0, 4
            ecall
            
            mv a1, s8
            li a0, 1 # rs1
            ecall
            
            la a1, str_comma_space
            li a0, 4
            ecall
            
            srai a1, s0, 20
            li a0, 1
            ecall
            
            j print_newline
        
        print_sw:
            la a1, str_sw
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s10 # rs2
            li a0, 1 
            ecall

            la a1, str_comma_space
            li a0, 4
            ecall
            
            # Get the top bits with sign extension
            srai s9, s0, 25
            # Make room for lower 5 bits
            slli s9, s9, 5
            # Extract lower 5 bits
            srli t6, s0, 7
            andi t6, t6, 0x1F
            
            # Combine to make one immediate
            or a1, s9, t6
            # Print
            li a0, 1
            ecall
            
            la a1, str_lparen_x
            li a0, 4
            ecall
            
            mv a1, s8 # rs1 (Base Address)
            li a0, 1
            ecall
            
            la a1, str_rparen
            li a0, 4
            ecall
            
            j print_newline
        
        print_beq:
            la a1, str_beq
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s8 # rs1
            li a0, 1
            ecall

            la a1, str_comma_x
            li a0, 4 
            ecall
            
            mv a1, s10 # rs2
            li a0, 1 
            ecall
            
            la a1, str_comma_space
            li a0, 4 
            ecall
            
            # Bit 31 moved to immediate bit 12 with sign extension
            srai s9, s0, 31
            slli s9, s9, 12
            
            slli t6, s0, 4
            li t0, 0x0800
            and t6, t6, t0 # Mask out everything except bit 11
            
            srli t1, s0, 20
            andi t1, t1, 0x07E0
            
            srli t2, s0, 7
            andi t2, t2, 0x001E # Mask out everything except bits 4:1
            
            # Combining to make one immediate
            or a1, s9, t6
            or a1, a1, t1
            or a1, a1, t2
            
            li a0, 1
            ecall
            
            j print_newline
        
        print_lui:
            la a1, str_lui
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s6
            li a0, 1 # rd
            ecall
            
            la a1, str_comma_space
            li a0, 4 
            ecall
            
            srai a1, s0, 12
            li a0, 34
            ecall
            
            j print_newline
        
        print_jal:
            la a1, str_jal
            li a0, 4
            ecall
            
            la a1, str_space_x
            li a0, 4
            ecall
            
            mv a1, s6
            li a0, 1 # rd
            ecall
            
            la a1, str_comma_space
            li a0, 4 
            ecall
            
            # Shift bit 31 down to bit 20
            srai t0, s0, 31
            slli t0, t0, 20
            
            # Shift bits 30:21 down to 10:1
            srli t1, s0, 20
            andi t1, t1, 0x07FE
            
            # Shift bit 20 down to bit 11
            srli t2, s0, 9
            li t3, 0x0800 
            and t2, t2, t3
            
            # Immediate Bits 19:12 (already in place)
            mv t4, s0
            li t5, 0x000FF000
            and t4, t4, t5
            
            # Combining to make one immediate
            or a1, t0, t4
            or a1, a1, t1
            or a1, a1, t2
            
            li a0, 1
            ecall
            
            
    print_newline:  
        # 6. Print newline for the next instruction
        la a1, str_newline
        li a0, 4
        ecall
        
        # Incrementing loop counter and address pointer
        addi s2, s2, 1
        addi s3, s3, 4
        
        # Jumping back to loop
        j loop
        
exit_loop:
    # Restoring original registers from stack
    lw s7, 44(sp)
    lw s8, 40(sp)
    lw s9, 36(sp)
    lw s10, 32(sp)
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    lw s5, 4(sp)
    lw s6, 0(sp)
    addi sp, sp, 48

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