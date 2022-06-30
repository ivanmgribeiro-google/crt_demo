#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

typedef int (*Operation)(int a, int b);

int main(int argc, char *argv[]) {
    HMODULE hsample;
    Operation add, sub;

    if ((hsample = LoadLibrary("sample.dll")) == NULL) {
        fprintf(stderr, "Error loading sample.dll\n");
        return EXIT_FAILURE;
    }

    printf("Library loaded at %p\n", (void*)hsample);

    if ((add = (Operation)GetProcAddress(hsample, "_Adder")) == NULL) {
        fprintf(stderr, "Error finding Adder()\n");
        return EXIT_FAILURE;
    }
    if ((sub = (Operation)GetProcAddress(hsample, "_Subtracter")) == NULL) {
        fprintf(stderr, "Error finding Subtracter()\n");
        return EXIT_FAILURE;
    }

    printf("add(7, 5) = %d\n", add(7, 5));
    printf("sub(7, 5) = %d\n", sub(7, 5));

    FreeLibrary(hsample);
    return EXIT_SUCCESS;
}
