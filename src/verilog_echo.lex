%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#define DEBUG 0
/* extern char * yylval; */
%}

%%

             /* TODO: comments */

[ \t]   ;  /* ignore all other whitespace */

\(                ECHO; return('(');
\)                ECHO; return(')');
,                 ECHO; return(',');

~&                ECHO; return(TILDE_AMP);
\^\|              ECHO; return(CARET_PIPE);
~\^               ECHO; return(TILDE_CARET);
==                ECHO; return(EQ_EQ);
!=                ECHO; return(NOT_EQ);
===               ECHO; return(EQ_EQ_EQ);
!==               ECHO; return(NOT_EQ_EQ);
&&                ECHO; return(LAND);
&&&               ECHO; return(AMP_AMP_AMP);
\|\|              ECHO; return(LOR);
\<=               ECHO; return(LTE);
\>=               ECHO; return(GTE);
\^~               ECHO; return(CARET_TILDE);
\<\<              ECHO; return(LSHIFT);
\>\>              ECHO; return(RSHIFT);
=\>               ECHO; return(EQ_GT);
\*\>              ECHO; return(AST_GT);
\-\>              ECHO; return(HYPH_GT);

 /* Keywords */
begin             ECHO; return(_BEGIN_     );
end               ECHO; return(END         );
macromodule       ECHO; return(MACROMODULE );
module            ECHO; return(MODULE      );
endmodule         ECHO; return(ENDMODULE   );
primitive         ECHO; return(PRIMITIVE   );
endprimitive      ECHO; return(ENDPRIMITIVE);
table             ECHO; return(TABLE       );
endtable          ECHO; return(ENDTABLE    );
task              ECHO; return(TASK        );
endtask           ECHO; return(ENDTASK     );
function          ECHO; return(FUNCTION    );
endfunction       ECHO; return(ENDFUNCTION );
specify           ECHO; return(SPECIFY     );
endspecify        ECHO; return(ENDSPECIFY  );
integer           ECHO; return(INTEGER     );
real              ECHO; return(REAL        );
time              ECHO; return(TIME        );
specparam         ECHO; return(SPECPARAM   );
parameter         ECHO; return(PARAMETER   );
defparam          ECHO; return(DEFPARAM    );
input             ECHO; return(INPUT       );
output            ECHO; return(OUTPUT      );
inout             ECHO; return(INOUT       );
wire              ECHO; return(WIRE        );
tri               ECHO; return(TRI         );
tri0              ECHO; return(TRI0        );
tri1              ECHO; return(TRI1        );
supply0           ECHO; return(SUPPLY0     );
supply1           ECHO; return(SUPPLY1     );
wand              ECHO; return(WAND        );
wor               ECHO; return(WOR         );
trireg            ECHO; return(TRIREG      );
scalared          ECHO; return(SCALARED    );
vectored          ECHO; return(VECTORED    );
reg               ECHO; return(REG         );
event             ECHO; return(EVENT       );
small             ECHO; return(SMALL       );
medium            ECHO; return(MEDIUM      );
large             ECHO; return(LARGE       );
strong0           ECHO; return(STRONG0     );
strong1           ECHO; return(STRONG1     );
pull0             ECHO; return(PULL0       );
pull1             ECHO; return(PULL1       );
weak0             ECHO; return(WEAK0       );
weak1             ECHO; return(WEAK1       );
highz0            ECHO; return(HIGHZ0      );
highz1            ECHO; return(HIGHZ1      );
and               ECHO; return(AND         );
nand              ECHO; return(NAND        );
or                ECHO; return(OR          );
nor               ECHO; return(NOR         );
xor               ECHO; return(XOR         );
xnor              ECHO; return(XNOR        );
buf               ECHO; return(BUF         );
bufif0            ECHO; return(BUFIF0      );
bufif1            ECHO; return(BUFIF1      );
not               ECHO; return(NOT         );
notif0            ECHO; return(NOTIF0      );
notif1            ECHO; return(NOTIF1      );
pulldown          ECHO; return(PULLDOWN    );
pullup            ECHO; return(PULLUP      );
nmos              ECHO; return(NMOS        );
rnmos             ECHO; return(RNMOS       );
pmos              ECHO; return(PMOS        );
rpmos             ECHO; return(RPMOS       );
cmos              ECHO; return(CMOS        );
rcmos             ECHO; return(RCMOS       );
tran              ECHO; return(TRAN        );
rtran             ECHO; return(RTRAN       );
tranif0           ECHO; return(TRANIF0     );
tranif1           ECHO; return(TRANIF1     );
rtranif0          ECHO; return(RTRANIF0    );
rtranif1          ECHO; return(RTRANIF1    );
assign            ECHO; return(ASSIGN      );
deassign          ECHO; return(DEASSIGN    );     
initial           ECHO; return(_INITIAL_   );     
always            ECHO; return(ALWAYS      );     
if                ECHO; return(IF          );     
else              ECHO; return(ELSE        );     
case              ECHO; return(CASE        );     
casez             ECHO; return(CASEZ       );     
casex             ECHO; return(CASEX       );     
endcase           ECHO; return(ENDCASE     );     
default           ECHO; return(DEFAULT     );     
forever           ECHO; return(FOREVER     );     
repeat            ECHO; return(REPEAT      );     
while             ECHO; return(WHILE       );     
for               ECHO; return(FOR         );     
wait              ECHO; return(WAIT        );     
disable           ECHO; return(DISABLE     );     
force             ECHO; return(FORCE       );     
release           ECHO; return(RELEASE     );     
fork              ECHO; return(FORK        );     
join              ECHO; return(JOIN        );     
posedge           ECHO; return(POSEDGE     );     
negedge           ECHO; return(NEGEDGE     );     
edge              ECHO; return(EDGE        );

setup             ECHO; return(SETUP       );
hold              ECHO; return(HOLD        );
period            ECHO; return(PERIOD      );
width             ECHO; return(WIDTH       );
skew              ECHO; return(SKEW        );
recovery          ECHO; return(RECOVERY    );
setuphold         ECHO; return(SETUPHOLD   );


 /* NUMBER:
	Numbers can be specified in decimal, hexadecimal, octal or binary, and may
	optionally start with a + or -.  The <BASE> token controls what number digits
	are legal.  <BASE> must be one of d, h, o, or b, for the bases decimal,
	hexadecimal, octal, and binary respectively. A number can contain any set of
	the following characters that is consistent with <BASE>:
	0123456789abcdefABCDEFxXzZ? */
 /* [+\-]?\d*\'[dhob][0-9a-fA-F_]  printf("number "); return(NUMBER); /* note: this should perhaps be a non-terminal */
[a-zA-Z_][a-zA-Z0-9_]*         printf("ident ");            ECHO; return(IDENTIFIER);
\"[^"]*\"                      printf("string ");           ECHO; return(STRING);  /* confirm this works */

[01xX]                         printf("output_symbol ");    ECHO; return(OUTPUT_SYMBOL);
([01]|1\'[bB][01xX])           printf("init_val ");         ECHO; return(INIT_VAL);
[01xX\?bB]                     printf("level_symbol ");     ECHO; return(LEVEL_SYMBOL);
[rRfFpPnN*]                    printf("edge_symbol ");      ECHO; return(EDGE_SYMBOL);
[0-9_]+                        printf("unsigned_number ");  ECHO; return(UNSIGNED_NUMBER);
[+\-]?[0-9_]+                  printf("decimal_number ");   ECHO; return(DECIMAL_NUMBER);
\'[bBoOdDhH]                   printf("base ");             ECHO; return(BASE);
[01x][01x]                     printf("edge_descriptor ");  ECHO; return(EDGE_DESCRIPTOR);
([01]|1?\'[bB][01])            printf("scalar_constant ");  ECHO; return(SCALAR_CONSTANT);

%%
