.data
    # Test data array and size declaration
    test_data: .word 5, 10, 15, 20
    size: .word 4
    
    hanoi_data: .word 3, 4, 5, 6
    
    # Strings for formatting results
    str_fib1: .string "Fibonacci("
    str_fib2: .string "): "
    str_newline: .string "\n"
    str_move: .string "Move disk "
    str_from: .string " from "
    str_to: .string " to "
    str_hanoi_title: .string "\n--- Tower of Hanoi ---\n\n"
    str_endline: .string "\n----------------------------\n\n"
    
    # Cache array
    cache: .word 0, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
    cache_size: .word 21

.text
.globl main

main:
    # Storing the registers on stack
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    
    # Loading size and ptr to test_data
    la s0, test_data
    la t0, size
    lw s1, 0(t0)
    li s2, 0 # Loop Counter i
    
    call_loop:
        beq s2, s1, setup_hanoi
        lw a0, 0(s0)
        call fibonacci
        mv t1, a0 # Storing the result in t1
        
        # Printing the "Fibonacci(" string
        la a1, str_fib1
        li a0, 4
        ecall
        
        # Printing the test integer
        lw a1, 0(s0)
        li a0, 1
        ecall
        
        # Printing the "): " string
        la a1, str_fib2
        li a0, 4
        ecall
        
        # Printing the result
        mv a1, t1
        li a0, 1
        ecall
        
        # Printing newline
        la a1, str_newline
        li a0, 4
        ecall
        
        # Incrementing loop counter and test_data ptr
        addi s2, s2, 1
        addi s0, s0, 4
        j call_loop
        
        
        setup_hanoi:
        # Setup for hanoi call
            la s0, hanoi_data
            la t0, size
            lw t2, 0(t0) # Size of array
            li s2, 0 # Loop Counter i
            lw s1, 0(s0)
            
            la a1, str_hanoi_title
            li a0, 4
            ecall
            
        hanoi_loop:  
            beq s2, t2, exit_main
            # Passing arguments
            mv a0, s1
            li a1, 'A'
            li a2, 'B'
            li a3, 'C'
            
            call tower_of_hanoi
            
            la a1, str_endline
            li a0, 4
            ecall
            
            addi s2, s2, 1 # i++
            addi s0, s0, 4 # hanoi_data[i+1]
            j hanoi_loop
        
exit_main:
    # Restoring the original registers from stack
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    
    # Cleanly Exit Program
    li a0, 10
    ecall
    
fibonacci:
    # Storing the registers in stack
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    
    la t0, cache
    
    # Calculating cache(n)
    slli t1, a0, 2
    add t2, t0, t1
    lw t3, 0(t2)
    
    li t4, -1 # Comparison Variable
    
    # Looking in cache for result
    beq t3, t4, calculate_fibonacci
    mv a0, t3 # Storing the result in a0
    j exit_fibonacci
    
    calculate_fibonacci:
        mv s0, a0 # Storing the original n in s0
        
        # Calling fibonacci(n-1)
        addi a0, a0, -1
        call fibonacci
        mv s1, a0
        
        # Calling fibonacci(n-2)
        mv a0, s0
        addi a0, a0, -2
        call fibonacci
        
        add a0, a0, s1 # fibonacci(n-1) + fibonacci(n-2)
        
        la t0, cache
        # Calculating cache(n)
        slli t1, s0, 2
        add t2, t0, t1
        sw a0, 0(t2)  
        
        
    exit_fibonacci:
        # Restoring the registers back from stack
        lw ra, 12(sp)
        lw s0, 8(sp)
        lw s1, 4(sp)
        addi sp, sp, 16
        ret
        
tower_of_hanoi:
    # Storing callee saved registers in stack
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    
    # Moved arguments to s registers to preserve accross recursive calls
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    li t0, 1 # Base condition
    beq t0, s0, print_move
    
    addi a0, s0, -1
    mv a1, s1
    mv a2, s3
    mv a3, s2
    call tower_of_hanoi # tower_of_hanoi(n-1)
    
    print_move:
    # Print "Move disk "
    la a1, str_move
    li a0, 4
    ecall
    
    # Print n
    mv a1, s0
    li a0, 1
    ecall
    
    # Print " from "
    la a1, str_from
    li a0, 4
    ecall
    
    mv a1, s1
    li a0, 11
    ecall
    
    # Print " to "
    la a1, str_to
    li a0, 4
    ecall
    
    mv a1, s3
    li a0, 11
    ecall
    
    la a1, str_newline
    li a0, 4
    ecall

    li t0, 1 # Skip second call if n==1
    beq t0, s0, exit
    
    addi a0, s0, -1
    mv a1, s2
    mv a2, s1
    mv a3, s3
    call tower_of_hanoi # tower_of_hanoi(n-1)
    
    exit:
    # Restoring the original registers
        lw ra, 28(sp)
        lw s0, 24(sp)
        lw s1, 20(sp)
        lw s2, 16(sp)
        lw s3, 12(sp)
        addi sp, sp, 32
    
        ret