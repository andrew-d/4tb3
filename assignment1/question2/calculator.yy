%{
#include <math.h>
#include "tokens.h"

/* The current number - from the main file */
extern double current_num;
%}

digit       [0-9]
hexdigit    [0-9A-Fa-f]
sign        [\-+]
float_suff  [fFdD]
exp         [eE]
bin_exp     [pP]

signed_integer  {sign}?{digit}+
exponent_part   {exp}{signed_integer}
decimal_float_1 {digit}+"."{digit}*{exponent_part}?{float_suff}?
decimal_float_2 "."{digit}+{exponent_part}?{float_suff}?
decimal_float_3 {digit}+{exponent_part}{float_suff}?
decimal_float_4 {digit}+{exponent_part}?{float_suff}
decimal_float   ({decimal_float_1})|({decimal_float_2})|({decimal_float_3})|({decimal_float_4})

hex_start       ("0x")|("0X")
hex_numeral     {hex_start}{hexdigit}+
hex_signif      ({hex_numeral})|({hex_numeral}".")|({hex_start}{hexdigit}*"."{hexdigit}+)
binary_exponent {bin_exp}{signed_integer}
hex_float       {hex_signif}{binary_exponent}{float_suff}?

%%

{sign}?{hex_float}      { current_num = atof(yytext);
                          return NUMBER;        }

{sign}?{decimal_float}  { current_num = atof(yytext);
                          return NUMBER;        }

"+"                     { return PLUS;          }
"-"                     { return MINUS;         }
"*"                     { return TIMES;         }
"p"                     { return PRINT;         }
"n"                     { return PRINT_POP;     }
"f"                     { return PRINT_ALL;     }
"c"                     { return CLEAR;         }
"d"                     { return DUPLICATE;     }
[ \t\n\r]               /* Skip all whitespace. */


%%

int yywrap(void) { return 1; }
