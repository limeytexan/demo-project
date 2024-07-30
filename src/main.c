#include <stdio.h>
#include "flox_hello_world.h"

int main(int argc, char *argv[]) {
    printf("In function main(), argv[0] = '%s'\n", argv[0]);
    flox_hello_world();
    return 0;
}
