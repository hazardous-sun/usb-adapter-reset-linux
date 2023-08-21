#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "%d\n", argc);
        fprintf(stderr, "Usage: %s <value1> <value2>\n", argv[0]);
        return 1;
    }

    int arr[2];
    arr[0] = atoi(argv[1]);
    arr[1] = atoi(argv[2]);

    printf("Stored values: %d, %d\n", arr[0], arr[1]);

    return 0;
}
