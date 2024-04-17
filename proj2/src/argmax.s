.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    bgt a1, zero, loop_start # make sure the length of the array is greater than 0
    # raise exception if length less than 1
    li a0, 36
    j exit

loop_start:
    # initialize t0 to 0
    li t0, 0
    # initialize t1 as max value
    lw t1, 0(a0)
    # initialize t2 to 1
    li t2, 1

loop_continue:
    beq t2, a1, loop_end
    addi a0, a0, 4
    lw t3, 0(a0)
    bgt t3, t1, update_max
    addi t2, t2, 1
    j loop_continue

update_max:
    mv t0, t2
    mv t1, t3
    addi t2, t2, 1
    j loop_continue

loop_end:
    # Epilogue
    mv a0, t0
    jr ra
