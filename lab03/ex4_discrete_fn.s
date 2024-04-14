.globl f # this allows other files to find the function f

# f takes in two arguments:
# a0 is the value we want to evaluate f at
# a1 is the address of the "output" array (defined above).
# The return value should be stored in a0
f:
    addi a0, a0, 3 # according to Hint 4, f(-3) should be stored at offset 0
    slli a0, a0, 2 # multiply the index by the size of the elements of the array
    add a1, a1, a0 # add offset to the address of the array 
    lw a0, 0(a1)

    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
