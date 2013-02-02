%{
#include <stdlib.h>
#include <stdbool.h>
#include "tokens.h"

#define __stringify(s)  #s
#define stringify(s)    __stringify(s)

#ifdef DEBUG
#define dprintf(format, ...)    fprintf(stderr, __FILE__ "(" stringify(__LINE__) "): " format, __VA_ARGS__)
#else
#define dprintf(format, ...)
#endif

#define STACK_SIZE  16

static double current_num = 0.0;

typedef struct _stack_entry_t {
    int token;
    double number;
} stack_entry_t;
%}

digit       [0-9]
letter      [a-zA-Z]

%%

{digit}+"."{digit}* { current_num = atof(yytext);
                      return NUMBER;        }

"+"                 { return PLUS;          }
"-"                 { return MINUS;         }
"*"                 { return TIMES;         }
"p"                 { return PRINT;         }
"n"                 { return PRINT_POP;     }
"f"                 { return PRINT_ALL;     }
"c"                 { return CLEAR;         }
"d"                 { return DUPLICATE;     }
[ \t\n\r]           /* Skip all whitespace. */
.                   { fprintf(stderr, "Unknown character encountered while parsing: %c\n", yytext[0]);
                       return UNKNOWN;      }


%%

int yywrap(void) { return 1; }

int main(int argc, char** argv) {
    stack_entry_t stack[STACK_SIZE];
    int r = 0, stack_len = 0;
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
        if( stack_len > STACK_SIZE ) {
            fprintf(stderr, "More than STACK_SIZE items added to stack!\n");
            exit(1);
        }

        stack[stack_len].token = r;
        dprintf("Got token with id %d\n", r);

        if( NUMBER == r ) {
            dprintf("Got number: %.2f\n", current_num);
            stack[stack_len].number = current_num;
        }

        stack_len++;
    }

    // Perform operations on our stack.
    while( !done ) {
        int tok = stack[stack_len].token;

        switch( tok ) {
            case 0:
                // EOF - we're done.
                done = true;
                break;

            case NUMBER:
                break;

            case PRINT:
                // Get the next item off the stack.

            default:
                fprintf(stderr, "Unknown token %d!\n", tok);
                exit(1);
                break;
        }
    }

    return 0;
}
