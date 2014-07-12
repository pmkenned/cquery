ES (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))

%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#define DEBUG 0
int line = 1;
typedef node_t;
node_t * node(char * label, node_t * n1, node_t * n2);
//extern YYSTYPE yylval;
%}

%%

--.*    ; /* remove comments */

[ \t]   ;  /* ignore all other whitespace */

[\n]    line++; DEBUG && printf("\n%d ",line);

\"([^"\\\n]|{ES})*\"   DEBUG && printf("string "); yylval = node(strdup(yytext),NULL,NULL); return(STRING);

,           DEBUG && printf(", ");  yylval = NULL; return(',');
\.          DEBUG && printf(". ");  yylval = NULL; return('.');
;           DEBUG && printf("; ");  yylval = NULL; return(';');
:           DEBUG && printf(": ");  yylval = NULL; return(':');
\{          DEBUG && printf("{ ");  yylval = NULL; return('{');
\}          DEBUG && printf("} ");  yylval = NULL; return('}');
\[          DEBUG && printf("[ ");  yylval = NULL; return('[');
\]          DEBUG && printf("] ");  yylval = NULL; return(']');
\(          DEBUG && printf("( ");  yylval = NULL; return('(');
\)          DEBUG && printf(") ");  yylval = NULL; return(')');
\<=         DEBUG && printf("<= "); yylval = NULL; return(LTEQ);
=>          DEBUG && printf("=> "); yylval = NULL; return(EQGT);
&           DEBUG && printf("& ");  yylval = NULL; return('&');
\+          DEBUG && printf("+ ");  yylval = NULL; return('+');
-           DEBUG && printf("- ");  yylval = NULL; return('-');
=           DEBUG && printf("= ");  yylval = NULL; return('=');
\/=         DEBUG && printf("/= "); yylval = NULL; return(NEQ);
\<          DEBUG && printf("< ");  yylval = NULL; return('<');
\>          DEBUG && printf("> ");  yylval = NULL; return('>');
\'          DEBUG && printf("' ");  yylval = NULL; return('\'');

[nN][oO][tT]      DEBUG && printf("NOT ");  yylval = NULL; return(NOT);
[aA][nN][dD]      DEBUG && printf("AND ");  yylval = NULL; return(AND);
[nN][aA][nN][dD]  DEBUG && printf("NAND "); yylval = NULL; return(NAND);
[oO][rR]          DEBUG && printf("OR ");   yylval = NULL; return(OR);
[nN][oO][rR]      DEBUG && printf("NOR ");  yylval = NULL; return(NOR);
[xX][oO][rR]      DEBUG && printf("XOR ");  yylval = NULL; return(XOR);
[xX][nN][oO][rR]  DEBUG && printf("XNOR "); yylval = NULL; return(XNOR);

[uU][sS][eE]                                      DEBUG && printf("use ");          yylval = NULL; return(USE);
[lL][iI][bB][rR][aA][rR][yY]                      DEBUG && printf("library ");      yylval = NULL; return(LIBRARY);
[eE][nN][tT][iI][tT][yY]                          DEBUG && printf("entity ");       yylval = NULL; return(ENTITY);
[aA][rR][cC][hH][iI][tT][eE][cC][tT][uU][rR][eE]  DEBUG && printf("architecture "); yylval = NULL; return(ARCHITECTURE);
[aA][tT][tT][rR][iI][bB][uU][tT][eE]              DEBUG && printf("attribute ");    yylval = NULL; return(ATTRIBUTE);
[iI][sS]                                          DEBUG && printf("is ");           yylval = NULL; return(IS);
[oO][fF]                                          DEBUG && printf("of ");           yylval = NULL; return(OF);
[pP][oO][rR][tT]                                  DEBUG && printf("port ");         yylval = NULL; return(PORT);
[gG][eE][nN][eE][rR][iI][cC]                      DEBUG && printf("generic ");      yylval = NULL; return(GENERIC);
[mM][aA][pP]                                      DEBUG && printf("map ");          yylval = NULL; return(MAP);
[bB][eE][gG][iI][nN]                              DEBUG && printf("_begin_ ");      yylval = NULL; return(_BEGIN_);
[eE][nN][dD]                                      DEBUG && printf("end ");          yylval = NULL; return(END);
[tT][oO]                                          DEBUG && printf("to ");           yylval = NULL; return(TO);
[sS][iI][gG][nN][aA][lL]                          DEBUG && printf("signal ");       yylval = NULL; return(SIGNAL);
[iI][nN]                                          DEBUG && printf("in ");           yylval = NULL; return(IN);
[oO][uU][tT]                                      DEBUG && printf("out ");          yylval = NULL; return(OUT);
[iI][nN][oO][uU][tT]                              DEBUG && printf("inout ");        yylval = NULL; return(INOUT);
 
[a-zA-Z_][a-zA-Z0-9_]* DEBUG && printf("IDENT "); yylval = node(strdup(yytext), NULL, NULL); return(IDENT);
'[0-9]'                DEBUG && printf("DIGIT "); yylval = node(strdup(yytext), NULL,NULL); return(DIGIT); /* TODO: should this be done with yacc? */
[0-9]+                 DEBUG && printf("NUMBER "); yylval = node(strdup(yytext),NULL,NULL); return(NUMBER); /* TODO: should I convert atoi? */
