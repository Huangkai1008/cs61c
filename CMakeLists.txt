cmake_minimum_required(VERSION 3.16)
project(cs61c C)

set(CMAKE_C_STANDARD 99)

include_directories(lab01)
include_directories(lab02)
include_directories(lab07)
include_directories(lab08)
include_directories(lab09)

add_executable(ex1 lab01/ex1_hello.c)
add_executable(ex2 lab01/ex2_pointer_basics.c)
add_executable(ex3 lab01/ex3_pointers_and_functions.c)
add_executable(ex4 lab01/ex4_ptr_heap_stack.c)
add_executable(ex5 lab01/ex5_arrays.c)
add_executable(ex6 lab01/ex6_pointer_arithmetic.c)
add_executable(ex7 lab01/ex7_strings.c)
add_executable(ex8 lab01/ex8_structs.c)
add_executable(ex9 lab01/ex9_double_pointers.c)
add_executable(ex10 lab01/ex10_test_ll_cycle.c lab01/ex10_ll_cycle.c lab01/ex10_ll_cycle.h)

add_executable(lab02_ex1 lab02/ex1_compiler_warnings.c)


add_executable(unit-tests proj1/src/unit_tests.c proj1/src/snake_utils.c proj1/src/asserts.c)
add_executable(proj1_custom_tests proj1/src/custom_tests.c proj1/src/snake_utils.c proj1/src/asserts.c)
add_executable(snake proj1/src/snake.c proj1/src/snake_utils.c)