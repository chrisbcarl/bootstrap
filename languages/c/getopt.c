/*
gcc languages/c/getopt.c -o dist/getopt && dist/getopt
optspec: [A-Za-z][-+:;]?
    [A-Za-z]    - the option is a flag
    :           - the option requires an argument, ex -a 1
    ::          - option takes an optional arg, ex -a 1 or -a
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

const char* PROG = "getopt";
const char* USAGE = "\
usage: getopt [-h] [-n N] [-d DEBUG]\n\
\n\
    How to use getopt.h\n\
\n\
Examples:\n\
    $ getopt -d -n 5\n\
\n\
options:\n\
  -h, --help            show this help message and exit\n\
\n\
optional:\n\
  -n N                  N? (default: 0)\n\
  -d DEBUG, --debug DEBUG\n\
                        add debug messages? (default: None)\n\
";

int DEBUG = 0;
int N = 0;

int argparse(int argc, char *argv[]) {
    // argparse
    char* optspec = "dn:h";
    int opt;

    while ((opt = getopt(argc, argv, optspec)) != -1) {
        if (DEBUG) {
            printf("opt: %d\n", opt);
            printf("    optarg: %s, optind: %d, opterr: %d, optopt: %d\n", optarg, optind, opterr, optopt);  // extern defined - optarg, optind, opterr, optopt
        }
        switch (opt) {
            case 'd': {
                DEBUG = 1;
                fprintf(stdout, "DEBUG: debug enabled!\n");
                break;
            }
            case 'n': {
                N = atoi(optarg);
                break;
            }
            default: {
                fprintf(stdout, USAGE, PROG);
                exit(EXIT_FAILURE);
            }
        }
    }

    // validate
    if (N < 0) {fprintf(stderr, "ERROR: -n cannot be negative!\n");}

    return EXIT_SUCCESS;
}



int main(int argc, char *argv[]) {
    if (argparse(argc, argv) != EXIT_SUCCESS) return EXIT_FAILURE;

    return EXIT_SUCCESS;
}