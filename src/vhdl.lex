ES (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))

%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#define DEBUG 0
int line = 1;
extern char * yylval;
%}

%%

--.*    ; /* remove comments */

[ \t]   ;  /* ignore all other whitespace */

[\n]    line++; DEBUG && printf("\n%d ",line);

\"([^"\\\n]|{ES})*\"   DEBUG && printf("string "); yylval = strdup(yytext); return(STRING);

,           DEBUG && printf(", ");   return(',');
\.          DEBUG && printf(". ");   return('.');
;           DEBUG && printf("; ");   return(';');
:           DEBUG && printf(": ");   return(':');
\{          DEBUG && printf("{ ");   return('{');
\}          DEBUG && printf("} ");   return('}');
\[          DEBUG && printf("[ ");   return('[');
\]          DEBUG && printf("] ");   return(']');
\(          DEBUG && printf("( ");   return('(');
\)          DEBUG && printf(") ");   return(')');
\<=         DEBUG && printf("<= ");  return(LTEQ);
=>          DEBUG && printf("=> ");  return(EQGT);
&           DEBUG && printf("& ");  return('&');
\+           DEBUG && printf("+ ");  return('+');
-           DEBUG && printf("- ");  return('-');
=           DEBUG && printf("= ");  return('=');
\/=           DEBUG && printf("/= ");  return(NEQ);
\<           DEBUG && printf("< ");  return('<');
\>           DEBUG && printf("> ");  return('>');
\'          DEBUG && printf("' "); return('\'');

[nN][oO][tT]      DEBUG && printf("NOT ");  return(NOT);
[aA][nN][dD]      DEBUG && printf("AND ");  return(AND);
[nN][aA][nN][dD]  DEBUG && printf("NAND "); return(NAND);
[oO][rR]          DEBUG && printf("OR ");   return(OR);
[nN][oO][rR]      DEBUG && printf("NOR ");  return(NOR);
[xX][oO][rR]      DEBUG && printf("XOR ");  return(XOR);
[xX][nN][oO][rR]  DEBUG && printf("XNOR "); return(XNOR);

[uU][sS][eE]                   DEBUG && printf("use "); return(USE);
[lL][iI][bB][rR][aA][rR][yY]   DEBUG && printf("library "); return(LIBRARY);
[eE][nN][tT][iI][tT][yY]       DEBUG && printf("entity "); return(ENTITY);
[aA][rR][cC][hH][iI][tT][eE][cC][tT][uU][rR][eE]  DEBUG && printf("architecture "); return(ARCHITECTURE);
[aA][tT][tT][rR][iI][bB][uU][tT][eE]              DEBUG && printf("attribute "); return(ATTRIBUTE);
[iI][sS]                       DEBUG && printf("is "); return(IS);
[oO][fF]                       DEBUG && printf("of "); return(OF);
[pP][oO][rR][tT]               DEBUG && printf("port "); return(PORT);
[gG][eE][nN][eE][rR][iI][cC]   DEBUG && printf("generic "); return(GENERIC);
[mM][aA][pP]                   DEBUG && printf("map "); return(MAP);
[bB][eE][gG][iI][nN]           DEBUG && printf("_begin_ "); return(_BEGIN_);
[eE][nN][dD]                   DEBUG && printf("end "); return(END);
[tT][oO]                       DEBUG && printf("to "); return(TO);
[sS][iI][gG][nN][aA][lL]       DEBUG && printf("signal "); return(SIGNAL);
[iI][nN]                       DEBUG && printf("in "); return(IN);
[oO][uU][tT]                   DEBUG && printf("out "); return(OUT);
[iI][nN][oO][uU][tT]           DEBUG && printf("inout "); return(INOUT);
 
[a-zA-Z_][a-zA-Z0-9_]* DEBUG && printf("IDENT "); yylval = strdup(yytext); return(IDENT);
'[0-9]'                DEBUG && printf("DIGIT "); yylval = strdup(yytext); return(DIGIT); /* TODO: should this be done with yacc? */
[0-9]+                 DEBUG && printf("NUMBER "); yylval = strdup(yytext); return(NUMBER); /* TODO: should I convert atoi? */
