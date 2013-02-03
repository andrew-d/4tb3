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
typedef struct _stack_entry_t {
    int token;
    double number;
} stack_entry_t;
stack_entry_t stack[STACK_SIZE];

/* Current stack pointer, pointer past end of stack */
stack_entry_t* stack_ptr = &stack[-1];
stack_entry_t* stack_end = &stack[STACK_SIZE - 1];

/* Macros that test whether our stack is full */
#define is_full()      (stack_ptr == stack_end)
#define is_empty()     (stack_ptr == (&stack[-1]))

/* Stuff that we need for flex */
double current_num = 0.0;
extern int yylex();
extern FILE* yyin;


void push_stack(int token, double number) {
    if ( is_full() ) {
        fprintf(stderr, "Stack overflow\n");
        exit(2);
    }

    ++stack_ptr;
    stack_ptr->token = token;
    stack_ptr->number = number;
}

int pop_stack(double* out_number) {
    if( is_empty() ) {
        fprintf(stderr, "Stack underflow\n");
        exit(3);
    }

    *out_number = stack_ptr->number;
    return (*stack_ptr--).token;
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
    int r = 0;
    bool done = false;

    // Zero out stack.
    memset(stack, 0, sizeof(stack));

    if ( argc > 1 ) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }

    // Read all data.
    while( (r = yylex()) != 0 ) {
        dprintf("Got token with id %d\n", r);
        if( NUMBER == r ) {
            dprintf("Got number: %.2f\n", current_num);
        }

        push_stack(r, current_num);
    }

    // Perform operations on our stack.
    while( !done ) {
        double num;
        int tok = pop_stack(&num);

        switch( tok ) {
            case PRINT:
                
        }
    }

    return 0;
}
