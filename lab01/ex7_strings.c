#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // allocate memory to store the string "hello"
    // Hint: how many bytes do we need to store this string?
    char *hello_str = malloc(6 * sizeof(char));

    // store the characters one at a time
    // Hint: don't forget the null terminator
    // Note: we use single quotes for characters
    hello_str[0] = 'h';
    hello_str[1] = 'e';
    hello_str[2] = 'l';
    hello_str[3] = 'l';
    hello_str[4] = 'o';

    // store the null terminator
    hello_str[5] = '\0';

    // Prints hello_str
    printf("prints hello: %s\n", hello_str);

    // print the length of hello_str
    printf("length of hello: %lu\n", strlen(hello_str));

    // allocate memory to store the string "world"
    char *world_str = malloc(6 * sizeof(char));

    // fill in the type
    // Note: this automatically stores the string "world" in static memory
    //       but static memory is immutable, so you may need to copy it
    //       to the stack or the heap
    const char *static_world_str = "world";

    // use strcpy and static_world_str to store "world" into world_str
    // Hint: strcpy takes two arguments:
    // first the destination, then the source
    strcpy(world_str, static_world_str);

    // Prints world_str
    printf("prints world: %s\n", world_str);

    // Prints the address of world_str
    printf("address of world_str: %p\n", world_str);

    // compute the address of the letter r using world_str
    char *ptr_to_r = world_str + 2;
    printf("address of 'r': %p\n", ptr_to_r);

    // allocate memory to store the string "hello world"
    char *hello_world_str = malloc(12 * sizeof(char));

    // use strcpy and hello_str to store
    // the string "hello" into hello_world_str
    strcpy(hello_world_str, hello_str);

    // store the space character in "hello world" at the correct index
    // Note: a space is not the same as null terminator
    //       a null terminator is represented by '\0'
    hello_world_str[5] = ' ';

    // use strcpy, pointer arithmetic, and world_str to store
    // the string "world" into hello_world_str
    strcpy(hello_world_str  + 6, world_str);

    // Prints hello_world_str
    printf("prints hello world: %s\n", hello_world_str);

    return 0;
}
