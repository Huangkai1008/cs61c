.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)  # hold the matrix pointer 
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # hold the file descriptor 
    sw s4, 20(sp) # hold the matrix size

    mv s1, a1
    mv s2, a2

# open the file with read permissions
open_file:
    li a1, 0
    jal fopen

    # raise exception if fopen returns -1
    li t0, -1  
    beq a0, t0, fopen_error
    mv s3, a0

# read the number of rows and columns from the file
read_file:
    # read row number
    mv a0, s3
    mv a1, s1
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    # read column number
    mv a0, s3
    mv a1, s2
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

# allocate space on the heap to store the matrix
allocate_space:
    # now s1 is the row number, s2 is the col number
    # so the space is 4 * row * col
    li s4, 4
    lw t0, 0(s1)
    mul s4, s4, t0
    lw t0, 0(s2)
    mul s4, s4, t0

    mv a0, s4
    jal malloc
    beq a0, zero, malloc_error
    # store the matrix pointer to s0
    mv s0, a0

# read the matrix from the file to the memory allocated in the previous step
read_matrix_to_memory:
    mv a0, s3
    mv a1, s0
    mv a2, s4
    jal fread
    bne a0, s4, fread_error

# close the file
close_file: 
    mv a0, s3
    jal fclose
    bne a0, zero, fclose_error
end:
    # return pointer
    mv a0, s0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    jr ra

fopen_error:
    li a0, 27
    j exit

fread_error:
    li a0, 29
    j exit

malloc_error:
    li a0, 26
    j exit

fclose_error:
    li a0, 28
    j exit