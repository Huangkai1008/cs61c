.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    ble a1, zero, error_38
    ble a2, zero, error_38
    ble a4, zero, error_38
    ble a5, zero, error_38
    bne a2, a4, error_38

    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    li s7, 0    # i = 0

outer_loop_start:
    beq s7, s1, outer_loop_end
    li s8, 0    # j = 0
    j inner_loop_start


inner_loop_start:
    # break loop when j is equal to the width of m1
    beq s8, s5, inner_loop_end

    # call dot
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5
    jal dot
    
    sw a0, 0(s6)
    addi s6, s6, 4

    addi s8, s8, 1
    # change the point of m1
    addi s3, s3, 4

    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    # change the point of m0
    li t0, 4
    mul t0, t0, s2
    add s0, s0, t0

    # reset the point of m1
    li t1, 4
    mul t1, t1, s5
    sub s3, s3, t1

    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40

    jr ra

error_38:
    li a0, 38
    j exit