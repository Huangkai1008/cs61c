.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # Precheck
    li t0, 5
    bne a0, t0, argument_error

    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s1, 4(sp)    # hold argv
    sw s2, 8(sp)    # whether to print
    sw s3, 12(sp)   # hold pointer to m0
    sw s4, 16(sp)   # hold pointer to m1
    sw s5, 20(sp)   # hold pointer to input
    sw s6, 24(sp)   # hold pointer to h
    sw s7, 28(sp)   # hold pointer to output
    sw s8, 32(sp)   # hold answer
    sw sp, 36(sp)

    mv s1, a1
    mv s2, a2

    addi sp, sp, -24
    # Read pretrained m0
    lw a0, 4(s1) # pointer to the filepath string of the first matrix file m0
    # allocate 8 byte space on stack
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    mv s3, a0

    # Read pretrained m1
    lw a0, 8(s1) # pointer to the filepath string of the first matrix file m1
    # allocate 8 byte space on stack
    addi a1, sp, 8
    addi a2, sp, 12
    jal read_matrix
    mv s4, a0

    # Read input matrix
    lw a0, 12(s1) # pointer to the filepath string of the first matrix file input
    # allocate 8 byte space on stack
    addi a1, sp, 16
    addi a2, sp, 20
    jal read_matrix
    mv s5, a0

    # Allocate heap for h
    #
    # The matrix multiplication function takes in two integer matrices A (dimension n × m) 
    # and B (dimension m × k) and outputs an integer matrix C (dimension n × k)
    lw t0, 0(sp)  # get `n` of h
    lw t1, 20(sp) # get `k` of h
    mul a0, t0, t1 
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_error
    mv s6, a0

    # Compute h = matmul(m0, input)
    mv a0, s3
    lw a1, 0(sp)
    lw a2, 4(sp)
    mv a3, s5
    lw a4, 16(sp)
    lw a5, 20(sp)
    mv a6, s6
    jal matmul

    # free space for m0, input
    mv a0, s3
    jal free
    mv a0, s5
    jal free

    # Compute h = relu(h)
    mv a0, s6
    lw t0, 0(sp)
    lw t1, 20(sp)
    mul a1, t0, t1
    jal relu

    # Allocate heap memory for o
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_error
    mv s7, a0
    
    # Compute o = matmul(m1, h)
    mv a0, s4
    lw a1, 8(sp)
    lw a2, 12(sp)
    mv a3, s6
    lw a4, 0(sp)
    lw a5, 20(sp)
    mv a6, s7
    jal matmul

    # free m1 and h
    mv a0, s4
    jal free
    mv a0, s6
    jal free

    # Write output matrix o
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 8(sp)
    lw a3, 20(sp)
    jal write_matrix

    # Compute and return argmax(o)
    mv a0, s7
    lw t0, 8(sp)
    lw t1, 20(sp)
    mul a1, t0, t1
    jal argmax

    mv s8, a0

    # free o
    mv a0, s7
    jal free

    # If enabled, print argmax(o) and newline
    bne s2, zero, end
    mv a0, s8
    jal print_int
    li a0, '\n'
    jal print_char

end:
    mv a0, s8
    addi sp, sp, 24

    lw ra, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw sp, 36(sp)
    addi sp, sp, 40

    jr ra

malloc_error:
    li a0, 26
    j exit

argument_error:
    li a0, 31
    j exit
