.data
    # Test data array and size declaration
    test_data: .word 5, 10, 15, 20
    size: .word 4
    # Strings for printing results
    str_fib1: .string "Fibonacci("
    str_fib2: .string "): "
    str_newline: .string "\n"
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
        beq s2, s1, exit_main
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