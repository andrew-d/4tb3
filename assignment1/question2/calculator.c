#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

#include "tokens.h"

#define __stringify(s)  #s
#define stringify(s)    __stringify(s)

#ifdef DEBUG
#define dprintf(format, ...)    fprintf(stderr, __FILE__ "(" stringify(__LINE__) "): " format, __VA_ARGS__)
#else
#define dprintf(format, ...)
#endif

#define STACK_SIZE  16

/* Our stack */
double stack[STACK_SIZE];

/* Current stack pointer, pointer past end of stack */
double* stack_ptr = &stack[-1];
double* stack_end = &stack[STACK_SIZE - 1];

/* Macros that test whether our stack is full */
#define is_full()      (stack_ptr == stack_end)
#define is_empty()     (stack_ptr == (&stack[-1]))

/* Stuff that we need for flex */
double current_num = 0.0;
extern int yylex();
extern FILE* yyin;


void push_stack(double number) {
    if ( is_full() ) {
        fprintf(stderr, "Stack overflow\n");
        exit(2);
    }

    ++stack_ptr;
    *stack_ptr = number;
}

double pop_stack() {
    if( is_empty() ) {
        fprintf(stderr, "Stack underflow\n");
        exit(3);
    }

    return *stack_ptr--;
}

double do_operation(int token, double first, double second) {
    switch( token ) {
        case PLUS:  return first + second;
        case MINUS: return first - second;
        case TIMES: return first * second;
        default:
            dprintf("Got bad operator: %d", token);
            return 0.0;
    }
}

int main(int argc, char** argv) {
    int tok = 0;
    bool done = false;

    // Zero out stack.
    memset(stack, 0, sizeof(stack));

    if ( argc > 1 ) {
        yyin = fopen(argv[1], "r");
        if( !yyin ) {
            fprintf(stderr, "Could not open input file: %s", argv[1]);
            exit(1);
        }
    } else {
        yyin = stdin;
    }

    // Read all data.
    while( (tok = yylex()) != 0 ) {
        double first, second;
        double* curr = NULL;

        dprintf("Got token with id %d\n", tok);
        if( NUMBER == tok ) {
            dprintf("Got number: %.2f\n", current_num);
        }

        switch( tok ) {
            case NUMBER:
                push_stack(current_num);
                break;

            case PLUS:
            case MINUS:
            case TIMES:
                first = pop_stack();
                second = pop_stack();

                first = do_operation(tok, first, second);
                push_stack(first);
                break;

            case PRINT:
            case PRINT_POP:
                first = pop_stack();
                printf("%f\n", first);

                if( tok == PRINT ) { push_stack(first); }
                break;

            case CLEAR:
                while( !is_empty() ) {
                    pop_stack();
                }
                break;

            case DUPLICATE:
                first = pop_stack();
                push_stack(first);
                push_stack(first);
                break;

            case PRINT_ALL:
                // TODO: fixme
                for( curr == stack_ptr; curr != (&stack[-1]); curr-- ) {
                    printf("%f\n", *curr);
                    fflush(stdout);
                }
                break;

            default:
                fprintf(stderr, "Got an unknown token: %d", tok);
                exit(4);
                break;

        };
    }

    return 0;
}
