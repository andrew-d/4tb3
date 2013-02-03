%{
#include <math.h>
#include "tokens.h"

/* The current number - from the main file */
extern double current_num;
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
