.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    bgt a1, zero, loop_start # make sure the length of the array is greater than 0
    # raise exception if length less than 1
    li a0, 36
    j exit

loop_start:
    beq a1, zero, loop_end
    addi a1, a1, -1
    # load value from address a0: t0 = *a0
    lw t0, 0(a0)

    bge t0, zero, loop_continue
    # sets negative value in the array to 0
    sw zero, 0(a0)

loop_continue:
    addi, a0, a0, 4
    j loop_start

loop_end:
    # Epilogue
    jr ra
