ES (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))

%{

extern "C" int yylex(void);

#include <stdio.h>
#include <string.h>
#include "node.h"
#include "y.tab.h"
#define DEBUG 0
int line = 1;
int col = 1;
//typedef node_t;
%}

%%

--.*    ; /* remove comments */

[ \t]   col++;  /* ignore all other whitespace */

[\n]    line++; DEBUG && printf("\t(%d)\n%d ", col, line); col = 1;

\"([^"\\\n]|{ES})*\"   DEBUG && printf("string "); col += strlen(yytext); yylval = node(strdup(yytext),NULL,NULL); return(STRING);

,           DEBUG && printf(", ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(',');
\.          DEBUG && printf(". ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('.');
;           DEBUG && printf("; ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(';');
:           DEBUG && printf(": ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(':');
\{          DEBUG && printf("{ ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('{');
\}          DEBUG && printf("} ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('}');
\[          DEBUG && printf("[ ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('[');
\]          DEBUG && printf("] ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(']');
\(          DEBUG && printf("( ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('(');
\)          DEBUG && printf(") ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(')');
\<=         DEBUG && printf("<= "); col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(LTEQ);
=>          DEBUG && printf("=> "); col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(EQGT);
&           DEBUG && printf("& ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('&');
\+          DEBUG && printf("+ ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('+');
-           DEBUG && printf("- ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('-');
=           DEBUG && printf("= ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('=');
\/=         DEBUG && printf("/= "); col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(NEQ);
\<          DEBUG && printf("< ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('<');
\>          DEBUG && printf("> ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('>');
\'          DEBUG && printf("' ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return('\'');

[nN][oO][tT]      DEBUG && printf("NOT ");  col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(NOT);
[aA][nN][dD]      DEBUG && printf("AND ");  col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(AND);
[nN][aA][nN][dD]  DEBUG && printf("NAND "); col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(NAND);
[oO][rR]          DEBUG && printf("OR ");   col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(OR);
[nN][oO][rR]      DEBUG && printf("NOR ");  col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(NOR);
[xX][oO][rR]      DEBUG && printf("XOR ");  col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(XOR);
[xX][nN][oO][rR]  DEBUG && printf("XNOR "); col += strlen(yytext);  yylval = node(strdup(yytext), NULL, NULL); return(XNOR);

[uU][sS][eE]                                      DEBUG && printf("use ");          col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(USE);
[lL][iI][bB][rR][aA][rR][yY]                      DEBUG && printf("library ");      col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(LIBRARY);
[eE][nN][tT][iI][tT][yY]                          DEBUG && printf("entity ");       col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(ENTITY);
[aA][rR][cC][hH][iI][tT][eE][cC][tT][uU][rR][eE]  DEBUG && printf("architecture "); col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(ARCHITECTURE);
[aA][tT][tT][rR][iI][bB][uU][tT][eE]              DEBUG && printf("attribute ");    col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(ATTRIBUTE);
[iI][sS]                                          DEBUG && printf("is ");           col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(IS);
[oO][fF]                                          DEBUG && printf("of ");           col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(OF);
[pP][oO][rR][tT]                                  DEBUG && printf("port ");         col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(PORT);
[gG][eE][nN][eE][rR][iI][cC]                      DEBUG && printf("generic ");      col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(GENERIC);
[mM][aA][pP]                                      DEBUG && printf("map ");          col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(MAP);
[bB][eE][gG][iI][nN]                              DEBUG && printf("_begin_ ");      col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(_BEGIN_);
[eE][nN][dD]                                      DEBUG && printf("end ");          col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(END);
[tT][oO]                                          DEBUG && printf("to ");           col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(TO);
[sS][iI][gG][nN][aA][lL]                          DEBUG && printf("signal ");       col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(SIGNAL);
[iI][nN]                                          DEBUG && printf("in ");           col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(IN);
[oO][uU][tT]                                      DEBUG && printf("out ");          col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(OUT);
[iI][nN][oO][uU][tT]                              DEBUG && printf("inout ");        col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(INOUT);
 
[a-zA-Z_][a-zA-Z0-9_]* DEBUG && printf("IDENT ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL, NULL); return(IDENT);
'[0-9]'                DEBUG && printf("DIGIT ");  col += strlen(yytext); yylval = node(strdup(yytext), NULL,NULL);  return(DIGIT); /* TODO: should this be done with yacc? */
[0-9]+                 DEBUG && printf("NUMBER "); col += strlen(yytext); yylval = node(strdup(yytext), NULL,NULL);  return(NUMBER); /* TODO: should I convert atoi? */
