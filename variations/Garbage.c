
#include <stdio.h>

long array[1024];

main(argc, argv)
int argc;
char *argv[];
{
    int numbers;
    int i, n;

    if (argc > 1) {
	numbers = atol(argv[1]);
    } else {
	numbers = 1024;
    }

    if (numbers > 1024) numbers = 1024;

    srand(getpid() * 17);

    for (i=0; i<numbers; i++) {
	n = rand() & 0x00000fff;
	n |= (n << 12);
	printf("%08lx\n",n);
    }
}


