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

    # Intializing arguments for selection_sort call
    la a0, my_array
    la t2, array_size
    lw a1, 0(t2)
    call selection_sort
    
    # Print array loop
    mv t2, s1             # t0 = current array pointer
    li t3, 0              # Loop counter i
    
    print_loop:
        bge t3, s0, exit_print # i >= array_size (s0)
    
        # Print the current integer
        lw a1, 0(t2)          # a1 = array[i]
        li a0, 1              
        ecall
    
        # Print a space
        la a1, str_space      
        li a0, 4              
        ecall
    
    # Increment pointer and counter
        addi t2, t2, 4        
        addi t3, t3, 1        
    
        j print_loop          
    
    exit_print:
    # Print a final newline to clean up the console
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
        addi t0, t0, 1 # Increment loop counter
        addi a0, a0, 4 # Increment address of array
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
        addi t0, t0, 1 # Increment loop counter
        addi a0, a0, 4 # Increment address of array
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
        addi t1, t1, 1 # Count += 1
        
    skip_count:
        addi t0, t0, 1 # Increment loop counter
        addi a0, a0, 4 # Increment address of array
        j count_loop
        
    exit_count:
        mv a0, t1
        ret
        
selection_sort:
    # Storing callee saved registers
    addi sp, sp, -16
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)
    
    li t0, 0 # Outer loop counter i
    li t1, 1 # Inner loop counter j
    li t2, 0 # Current minimum index
    
    outer_loop:
        bge t0, a1, exit_sort # i >= array_size (a1)
        mv t2, t0 # minIdx = i
        addi t1, t0, 1 # j = i + 1
   
        inner_loop:
            bge t1, a1, exit_inner

            slli t3, t1, 2
            add t3, t3, a0
            lw t4, 0(t3) # t4 = array[j]            
            
            slli t5, t2, 2
            add t5, t5, a0
            lw t6, 0(t5) # t6 = array[minIdx]
            
            ble t6, t4, skip_update
            mv t2, t1 # update minIdx
            
            skip_update:
                addi t1, t1, 1
                j inner_loop
            
        exit_inner:
            slli s0, t0, 2
            add s0, s0, a0
            lw s1, 0(s0) # s1 = array[i]
            
            slli s2, t2, 2
            add s2, s2, a0
            lw s3, 0(s2) # s1 = array[minIdx]
            
            # Swapping the elements
            sw s3, 0(s0)
            sw s1, 0(s2)
            
            addi t0, t0, 1 # i = i + 1
            j outer_loop
    
    exit_sort:
        lw s0, 12(sp)
        lw s1, 8(sp)
        lw s2, 4(sp)
        lw s3, 0(sp)
        addi sp, sp, 16
        ret