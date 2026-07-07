.data
    # Labels for array and array size
    my_array: .word 12, 24, 1, -4, 6, 7, -11, 10, 13, 66, -43, 100
    array_size: .word 12
    
    # Labels for printing results
    str_sum: .string "Sum: "
    str_max: .string "Max: "
    str_min: .string "Min: "
    str_neg: .string "Negative Count: "
    str_newline: .string "\n"
    str_space: .string " "

.text
.globl main
main:

    # Saving return address and callee saved registers
	addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    
    # Loading the array address and size
    la s1, my_array
    la t0, array_size
    lw s0, 0(t0)
    
    # sum_array FUNCTION SETUP AND CALL
    # Initializing arguments for function call
    mv a1, s0
    mv a0, s1
    
    call sum_array
    mv t1, a0 # Saving the sum result in t1
    
    # Printing "Sum: " string
    la a1, str_sum
    li a0, 4
    ecall
    
    # Printing the sum
    mv a1, t1
    li a0, 1
    ecall
    
    # Printing newline
    la a1, str_newline
    li a0, 4
    ecall
    
    # find_max FUNCTION SETUP AND CALL
    # Initializing arguments for function call
    mv a1, s0
    mv a0, s1
    
    call find_max
    mv t2, a0 # Saving the max result in t2
    
    # Printing "Max: " string
    la a1, str_max
    li a0, 4
    ecall
    
    # Printing the max number
    mv a1, t2
    li a0, 1
    ecall
    
    # Printing newline
    la a1, str_newline
    li a0, 4
    ecall
    
    # find_min FUNCTION SETUP AND CALL
    # Initializing arguments for function call
    mv a1, s0
    mv a0, s1
    
    call find_min
    mv t3, a0 # Saving the max result in t3
    
    # Printing "Min: " string
    la a1, str_min
    li a0, 4
    ecall
    
    # Printing the min number
    mv a1, t3
    li a0, 1
    ecall
    
    # Printing newline
    la a1, str_newline
    li a0, 4
    ecall
    
    # count_neg FUNCTION SETUP AND CALL
    # Initializing arguments for function call
    mv a1, s0
    mv a0, s1
    
    call count_neg
    mv t4, a0 # Saving the count in t4
    
    # Printing "Negative Count: " string
    la a1, str_neg
    li a0, 4
    ecall
    
    # Printing the count
    mv a1, t4
    li a0, 1
    ecall
    
    # Printing newline
    la a1, str_newline
    li a0, 4
    ecall
    
    # Restoring return address and callee stored registers
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    # Resetting the stack
    addi sp, sp, 16
    
    # Exiting the program
    li a0, 10
    ecall
    
sum_array:
    li t0, 0 # Loop Counter i
    li t1, 0 # Total Sum
    
    sum_loop:
        beq t0, a1, exit_sum # Loop exit condition
        lw t2, 0(a0)
        add t1, t1, t2 # Sum = Sum + array[a0]
    
    # Incrementing i and array_ptr
        addi t0, t0, 1
        addi a0, a0, 4

        j sum_loop
    
    exit_sum:
        mv a0, t1
        ret
    
find_max:
    li t0, 1 # Loop Counter i
    lw t1, 0(a0) # Max Number initialized to the first element
    addi a0, a0, 4
    
    max_loop:
        beq t0, a1, exit_max # Loop exit condition
        lw t2 , 0(a0)
        ble t2, t1, skip_max # Check if t2 <= t1
        mv t1, t2 # Swap
    
    skip_max:
        addi t0, t0, 1
        addi a0, a0, 4
        j max_loop
    
    exit_max:
        mv a0, t1
        ret
    
find_min:
    li t0, 1 # Loop Counter i
    lw t1, 0(a0) # Max Number initialized to the first element
    addi a0, a0, 4
    
    min_loop:
        beq t0, a1, exit_min # Loop exit condition
        lw t2 , 0(a0)
        bge t2, t1, skip_min # Check if t2 <= t1
        mv t1, t2 # Swap
    
    skip_min:
        addi t0, t0, 1
        addi a0, a0, 4
        j min_loop
    
    exit_min:
        mv a0, t1
        ret
    
count_neg:
    li t0, 0 # Loop Counter i
    li t1, 0 # Negative Count
    
    count_loop:
        beq t0, a1, exit_count
        lw t2, 0(a0)
        bgez t2, skip_count
        addi t1, t1, 1
        
    skip_count:
        addi t0, t0, 1
        addi a0, a0, 4
        j count_loop
        
    exit_count:
        mv a0, t1
        ret