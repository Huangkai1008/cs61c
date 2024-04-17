.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    ble a2, zero, wrong_elements_e
    ble a3, zero, wrong_stride_e
    ble a4, zero, wrong_stride_e

loop_start:
    # initialize final result to 0
    li t0, 0
    # get byte offset of arr0
    li t1, 4
    mul t1, t1, a3
    # get byte offset of arr1
    li t2, 4
    mul t2, t2, a4

loop_continue:
    beq a2, zero, loop_end
    # get value to product in arr0
    lw t3, 0(a0)
    # get value to product in arr1
    lw t4, 0(a1)
    mul t3, t3, t4
    # add product value to result
    add t0, t0, t3

    addi a2, a2, -1
    add a0, a0, t1
    add a1, a1, t2

    j loop_continue

loop_end:
    # Epilogue
    mv a0, t0
    jr ra

wrong_elements_e:
    li a0, 36
    j exit

wrong_stride_e:
    li a0, 37
    j exit