#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {

    char hostname[1024];
    gethostname(hostname, 1024);

    printf("From prog1 : ");
    puts(hostname);

    return EXIT_SUCCESS;
}
