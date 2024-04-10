#include <stdio.h>
#include <stdlib.h>

int *int_on_stack() {
    // Allocates memory on the stack for an integer
    int x = 5;

    // Returns a pointer that points to the number 5
    return &x;
}

int *int_on_heap() {
    int *ptr_to_5 = (int *) malloc(sizeof(int));

    *ptr_to_5 = 5;

    // Returns a pointer that points to the number 5
    return ptr_to_5;
}

int main() {
    int *ptr_to_stack = int_on_stack();
    int *ptr_to_heap = int_on_heap();

    printf("ptr_to_stack is the address %p\n", ptr_to_stack);
    printf("ptr_to_heap is the address %p\n", ptr_to_heap);

    return 0;
}
