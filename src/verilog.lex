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

\(                return('(');
\)                return(')');
,                 return(',');

~&                return(TILDE_AMP);
\^\|              return(CARET_PIPE);
~\^               return(TILDE_CARET);
==                return(EQ_EQ);
!=                return(NOT_EQ);
===               return(EQ_EQ_EQ);
!==               return(NOT_EQ_EQ);
&&                return(LAND);
&&&               return(AMP_AMP_AMP);
\|\|              return(LOR);
\<=               return(LTE);
\>=               return(GTE);
\^~               return(CARET_TILDE);
\<\<              return(LSHIFT);
\>\>              return(RSHIFT);
=\>               return(EQ_GT);
\*\>              return(AST_GT);
\-\>              return(HYPH_GT);

 /* Keywords */
begin             return(_BEGIN_     );
end               return(END         );
macromodule       return(MACROMODULE );
module            return(MODULE      );
endmodule         return(ENDMODULE   );
primitive         return(PRIMITIVE   );
endprimitive      return(ENDPRIMITIVE);
table             return(TABLE       );
endtable          return(ENDTABLE    );
task              return(TASK        );
endtask           return(ENDTASK     );
function          return(FUNCTION    );
endfunction       return(ENDFUNCTION );
specify           return(SPECIFY     );
endspecify        return(ENDSPECIFY  );
integer           return(INTEGER     );
real              return(REAL        );
time              return(TIME        );
specparam         return(SPECPARAM   );
parameter         return(PARAMETER   );
defparam          return(DEFPARAM    );
input             return(INPUT       );
output            return(OUTPUT      );
inout             return(INOUT       );
wire              return(WIRE        );
tri               return(TRI         );
tri0              return(TRI0        );
tri1              return(TRI1        );
supply0           return(SUPPLY0     );
supply1           return(SUPPLY1     );
wand              return(WAND        );
wor               return(WOR         );
trireg            return(TRIREG      );
scalared          return(SCALARED    );
vectored          return(VECTORED    );
reg               return(REG         );
event             return(EVENT       );
small             return(SMALL       );
medium            return(MEDIUM      );
large             return(LARGE       );
strong0           return(STRONG0     );
strong1           return(STRONG1     );
pull0             return(PULL0       );
pull1             return(PULL1       );
weak0             return(WEAK0       );
weak1             return(WEAK1       );
highz0            return(HIGHZ0      );
highz1            return(HIGHZ1      );
and               return(AND         );
nand              return(NAND        );
or                return(OR          );
nor               return(NOR         );
xor               return(XOR         );
xnor              return(XNOR        );
buf               return(BUF         );
bufif0            return(BUFIF0      );
bufif1            return(BUFIF1      );
not               return(NOT         );
notif0            return(NOTIF0      );
notif1            return(NOTIF1      );
pulldown          return(PULLDOWN    );
pullup            return(PULLUP      );
nmos              return(NMOS        );
rnmos             return(RNMOS       );
pmos              return(PMOS        );
rpmos             return(RPMOS       );
cmos              return(CMOS        );
rcmos             return(RCMOS       );
tran              return(TRAN        );
rtran             return(RTRAN       );
tranif0           return(TRANIF0     );
tranif1           return(TRANIF1     );
rtranif0          return(RTRANIF0    );
rtranif1          return(RTRANIF1    );
assign            return(ASSIGN      );
deassign          return(DEASSIGN    );     
initial           return(_INITIAL_   );     
always            return(ALWAYS      );     
if                return(IF          );     
else              return(ELSE        );     
case              return(CASE        );     
casez             return(CASEZ       );     
casex             return(CASEX       );     
endcase           return(ENDCASE     );     
default           return(DEFAULT     );     
forever           return(FOREVER     );     
repeat            return(REPEAT      );     
while             return(WHILE       );     
for               return(FOR         );     
wait              return(WAIT        );     
disable           return(DISABLE     );     
force             return(FORCE       );     
release           return(RELEASE     );     
fork              return(FORK        );     
join              return(JOIN        );     
posedge           return(POSEDGE     );     
negedge           return(NEGEDGE     );     
edge              return(EDGE        );

setup             return(SETUP       );
hold              return(HOLD        );
period            return(PERIOD      );
width             return(WIDTH       );
skew              return(SKEW        );
recovery          return(RECOVERY    );
setuphold         return(SETUPHOLD   );


 /* NUMBER:
	Numbers can be specified in decimal, hexadecimal, octal or binary, and may
	optionally start with a + or -.  The <BASE> token controls what number digits
	are legal.  <BASE> must be one of d, h, o, or b, for the bases decimal,
	hexadecimal, octal, and binary respectively. A number can contain any set of
	the following characters that is consistent with <BASE>:
	0123456789abcdefABCDEFxXzZ? */
 /* [+\-]?\d*\'[dhob][0-9a-fA-F_]  printf("number "); return(NUMBER); /* note: this should perhaps be a non-terminal */
[a-zA-Z_][a-zA-Z0-9_]*          return(IDENTIFIER);
\"[^"]*\"                       return(STRING);  /* confirm this works */

[01xX]                          return(OUTPUT_SYMBOL);
([01]|1\'[bB][01xX])            return(INIT_VAL);
[01xX\?bB]                      return(LEVEL_SYMBOL);
[rRfFpPnN*]                     return(EDGE_SYMBOL);
[0-9_]+                         return(UNSIGNED_NUMBER);
[+\-]?[0-9_]+                   return(DECIMAL_NUMBER);
\'[bBoOdDhH]                    return(BASE);
[01x][01x]                      return(EDGE_DESCRIPTOR);
([01]|1?\'[bB][01])             return(SCALAR_CONSTANT);

%%
