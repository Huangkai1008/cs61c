.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp) # hold the file descriptor
    sw s1, 8(sp) # hold pointer to the matrix in memory
    sw s2, 12(sp) # hold the number of rows in the matrix
    sw s3, 16(sp) # hold the number of columns in the matrix

    mv s1, a1
    mv s2, a2
    mv s3, a3

# open the file with write permissions
open_file:
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0 fopen_error
    mv s0, a0 # file descriptor

    li t0, -1
    beq a0, t0, fopen_error
    mv s0, a0

# write the number of rows and columns to the file
write_file:
    # write row number
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a1, sp
    li a2, 1
    li a3, 4
    jal fwrite
    li t0 1
    bne a0, t0, fwrite_error

    # write column number
    sw s3, 0(sp)
    mv a0, s0
    mv a1, sp
    li a2, 1
    li a3, 4
    jal fwrite
    li t0 1
    bne a0, t0, fwrite_error
    addi sp, sp, 4

    # write data
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mul a2, a2, s3
    li a3, 4
    jal fwrite
    mv t0 s2
    mul t0 s2 s3
    bne a0, t0, fwrite_error

# close a file, saving any writes we have made to the file
close_file:
    mv a0, s0
    jal fclose
    bne a0, zero, fclose_error

end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jr ra

fopen_error:
    li a0, 27
    j exit

fread_error:
    li a0, 29
    j exit

fwrite_error:
    li a0, 30
    j exit

fclose_error:
    li a0, 28
    j exit