.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # initialize t0 to hold the result and t1 as the counter
    addi t0, x0, 1 # t0 to hold the final result
    addi t1, x0, 1 # t1 to hold the counter
    
    addi t2, a0, 0

factorial_loop:
    bgt t1, t2, factorial_end   # counter greater than max number
    mul t0, t0, t1
    addi t1, t1, 1
    j factorial_loop
    
factorial_end:
    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    addi a0, t0, 0
    jr ra

