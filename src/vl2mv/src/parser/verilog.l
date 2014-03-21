%{
/*
 *  vl2mv: Verilog to BLIF-MV Translator Distribution
 *
 *  Copyright (c) 1992, 1993
 *        Regents of the University of California
 *  All rights reserved.
 *
 *  Use and copying of this software and preparation of derivative works
 *  based upon this software are permitted.  However, any distribution of
 *  this software or derivative works must include the above copyright 
 *  notice.
 *
 *  This software is made available AS IS, and neither the Electronics
 *  Research Laboratory or the Universify of California make any
 *  warranty about the software, its performance or its conformity to
 *  any specification.
 *
 *
 * $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/verilog.l,v 1.3 1993/01/15 19:47:19 stcheng Exp stcheng $
 *
 * Lexical Scanner for Verilog
 *
 * Author: Szu-Tsung Cheng, stcheng@ic.berkeley.edu
 *
 * Date: September 18, 1992
 */

#include <stdio.h>
#include "util.h"
#include "st.h"
#include "list.h"
#include "vl_defs.h"
#include "vl_types.h"
#include "vlr_int.h"
#include "verilog_yacc.h"

static scan_table = 0;
char yyid[MAXSTRLEN];
char brep[MAXSTRLEN];
int bexp0, bexp1;
st_table *macros;

%}

%a 2000
%e 1500
%k 1000
%n 500
%p 4000

%Start Snormal Stable

Space       [\n\r\t\b ]
Alpha       [a-zA-Z]
AlphaU      [a-zA-Z_]
AlphaNum    [a-zA-Z0-9]
AlphaNumU   [a-zA-Z0-9_]
Digit       [0-9]
DigitU      [0-9_]
Number      {Digit}{DigitU}*
Decimal     ({Number})?'[dD]{Number}
Octal       ({Number})?'[oO][0-7xXzZ?][0-7xXzZ?_]*
Hexdecimal  ({Number})?'[hH][0-9a-fA-FxXzZ?][0-9a-fA-FxXzZ?_]*
Binary      ({Number})?'[bB][01xXzZ?][01xXzZ?_]*

%%

                             if (scan_table)
                               BEGIN Stable; 
                             else
                               BEGIN Snormal;

<Snormal,Stable>{Space}+     { continue; }

<Snormal,Stable>"/*"         { skipcommentblock(); continue; }
<Snormal,Stable>"//"[^\n]*\n { continue; }

<Snormal,Stable>`define[^\n]*\n { memorize_macro(yytext, macros); continue; }

<Snormal>">="               { return YYGEQ;  }
<Snormal>"=<"               { return YYLEQ;  }
<Snormal>"&&"               { return YYLOGAND;    }
<Snormal>"||"               { return YYLOGOR;     }
<Snormal>"==="              { return YYCASEEQUALITY;  }
<Snormal>"=="               { return YYLOGEQUALITY;   }
<Snormal>"!=="              { return YYCASEINEQUALITY; }
<Snormal>"!="               { return YYLOGINEQUALITY; }
<Snormal>"^~"               { return YYLOGXNOR; }
<Snormal>"~^"               { return YYLOGXNOR; }
<Snormal>"~&"               { return YYLOGNAND;      }
<Snormal>"~|"               { return YYLOGNOR;       }
<Snormal>"<<"               { return YYLSHIFT;      }
<Snormal>">>"               { return YYRSHIFT;      }
<Snormal>"?:"               { return YYCONDITIONAL; }

<Snormal>\"[^"]*            { return YYSTRING; }

<Snormal>always             { return YYALWAYS; }
<Snormal>"*>"               { return YYALLPATH; }
<Snormal>and                { return YYAND; }
<Snormal>assign             { return YYASSIGN; }
<Snormal>begin              { return YYBEGIN; }
<Snormal>buf                { return YYBUF; }
<Snormal>bufif0             { return YYBUFIF0; }
<Snormal>bufif1             { return YYBUFIF1; }
<Snormal>case               { return YYCASE; }
<Snormal>casex              { return YYCASEX; }
<Snormal>casez              { return YYCASEZ; }
<Snormal>cmos               { return YYCMOS; }
<Snormal>deassign           { return YYDEASSIGN; }
<Snormal>default            { return YYDEFAULT; }
<Snormal>defparam           { return YYDEFPARAM; }
<Snormal>disable            { return YYDISABLE; }
<Snormal>edge               { return YYEDGE; }
<Snormal>else               { return YYELSE; }
<Snormal>end                { return YYEND; }
<Snormal>endcase            { return YYENDCASE; }
<Snormal>endfunction        { return YYENDFUNCTION; }
<Snormal>endmodule          { return YYENDMODULE; }
<Snormal>endprimitive       { return YYENDPRIMITIVE; }
<Snormal>endspecify         { return YYENDSPECIFY; }
<Stable>endtable            { scan_table = 0; return YYENDTABLE; }
<Snormal>endtask            { return YYENDTASK; }
<Snormal>event              { return YYEVENT; }
<Snormal>for                { return YYFOR; }
<Snormal>forever            { return YYFOREVER; }
<Snormal>fork               { return YYFORK; }
<Snormal>function           { return YYFUNCTION; }
<Snormal>highz0             { return YYHIGHZ0; }
<Snormal>highz1             { return YYHIGHZ1; }
<Snormal>if                 { return YYIF; }
<Snormal>initial            { return YYINITIAL; }
<Snormal>inout              { return YYINOUT; }
<Snormal>input              { return YYINPUT; }
<Snormal>integer            { return YYINTEGER; }
<Snormal>join               { return YYJOIN; }
<Snormal>large              { return YYLARGE; }
<Snormal>"=>"               { return YYLEADTO; }
<Snormal>macromodule        { return YYMACROMODULE; }
<Snormal>medium             { return YYMEDIUM; }
<Snormal>module             { return YYMODULE; }
<Snormal>mreg               { return YYMREG; }
<Snormal>"<="               { return YYNBASSIGN;  }
<Snormal>nand               { return YYNAND; }
<Snormal>negedge            { return YYNEGEDGE; }
<Snormal>nmos               { return YYNMOS; }
<Snormal>nor                { return YYNOR; }
<Snormal>not                { return YYNOT; }
<Snormal>notif0             { return YYNOTIF0; }
<Snormal>notif1             { return YYNOTIF1; }
<Snormal>or                 { return YYOR; }
<Snormal>output             { return YYOUTPUT; }
<Snormal>parameter          { return YYPARAMETER; }
<Snormal>pmos               { return YYPMOS; }
<Snormal>posedge            { return YYPOSEDGE; }
<Snormal>primitive          { return YYPRIMITIVE; }
<Snormal>pull0              { return YYPULL0; }
<Snormal>pull1              { return YYPULL1; }
<Snormal>pulldown           { return YYPULLDOWN; }
<Snormal>pullup             { return YYPULLUP; }
<Snormal>rcmos              { return YYRCMOS; }
<Snormal>real               { return YYREAL; }
<Snormal>reg                { return YYREG; }
<Snormal>repeat             { return YYREPEAT; }
<Snormal>"->"               { return YYRIGHTARROW; }
<Snormal>rnmos              { return YYRNMOS; }
<Snormal>rpmos              { return YYRPMOS; }
<Snormal>rtran              { return YYRTRAN; }
<Snormal>rtranif0           { return YYRTRANIF0; }
<Snormal>rtranif1           { return YYRTRANIF1; }
<Snormal>scalered           { return YYSCALARED; }
<Snormal>small              { return YYSMALL; }
<Snormal>specify            { return YYSPECIFY; }
<Snormal>specparam          { return YYSPECPARAM; }
<Snormal>strong0            { return YYSTRONG0; }
<Snormal>strong1            { return YYSTRONG1; }
<Snormal>supply0            { return YYSUPPLY0; }
<Snormal>supply1            { return YYSUPPLY1; }
<Snormal>swire              { return YYSWIRE; }
<Snormal>table              { scan_table = 1; return YYTABLE; }
<Snormal>task               { return YYTASK; }
<Snormal>time               { return YYTIME; }
<Snormal>tran               { return YYTRAN; }
<Snormal>tranif0            { return YYTRANIF0; }
<Snormal>tranif1            { return YYTRANIF1; }
<Snormal>tri                { return YYTRI; }
<Snormal>tri0               { return YYTRI0; }
<Snormal>tri1               { return YYTRI1; }
<Snormal>triand             { return YYTRIAND; }
<Snormal>trior              { return YYTRIOR; }
<Snormal>vectored           { return YYVECTORED; }
<Snormal>wait               { return YYWAIT; }
<Snormal>wand               { return YYWAND; }
<Snormal>weak0              { return YYWEAK0; }
<Snormal>weak1              { return YYWEAK1; }
<Snormal>while              { return YYWHILE; }
<Snormal>wire               { return YYWIRE; }
<Snormal>wor                { return YYWOR; }
<Snormal>xnor               { return YYXNOR; }
<Snormal>xor                { return YYXOR; }

<Snormal>\$setup              { return YYsysSETUP; }
<Snormal>\${Alpha}+           { return YYsysID; }

<Snormal>`{AlphaU}{AlphaNumU}* {
                                char *macro;

                                strcpy(yyid, yytext); 
                                if (st_lookup(macros, yyid+1, &macro)) {
                                    expand_macro(yyid+1, macros);
                                    continue;
                                }
                                return YYID; 
                               }
<Snormal>{AlphaU}{AlphaNumU}* { 
                                strcpy(yyid, yytext); 
                                return YYID; 
                              }
<Snormal>\\[^\n\t\b\r ]*      { 
                                strcpy(yyid, yytext); 
                                return YYID; 
                              }

<Snormal>{Number}*\.{Number}+ { return YYRNUMBER; }
<Snormal>{Number}+\.{Number}* { return YYRNUMBER; }
<Snormal>{Number}             { return YYINUMBER; }
<Snormal>{Binary}             { 
                                binbin(yytext, brep); 
                                encodebit(brep, &bexp1, &bexp0); 
                                return YYINUMBER; 
                              }
<Snormal>{Octal}              { 
                                octbin(yytext, brep); 
                                encodebit(brep, &bexp1, &bexp0); 
                                return YYINUMBER; 
                              }
<Snormal>{Decimal}            { 
                                decbin(yytext, brep); 
                                encodebit(brep, &bexp1, &bexp0); 
                                return YYINUMBER; 
                              }
<Snormal>{Hexdecimal}         { 
                                hexbin(yytext, brep); 
                                encodebit(brep, &bexp1, &bexp0); 
                                return YYINUMBER; 
                              }

<Stable>\(\?\?\)              { return '*'; }
<Stable>\(01\)                { return 'r'; }
<Stable>\(10\)                { return 'f'; }
<Snormal,Stable>.             { return yytext[0]; }

%%    

int yywrap()
{
return 1;
}

void skipcommentblock()
{
    int done, level = 0;
    char c;

    for (done=0; !done; yyleng = (yyleng > YYLMAX-2) ? YYLMAX-2 : yyleng) {
        yytext[yyleng++] = c;
        if ((c = input()) == '*') {
            yytext[yyleng++] = c;
            if ((c = input()) == '/') {
                done = (level-- == 0); 
            } else {
                unput(c);
            }
	} else if (c == '/') {
	    yytext[yyleng++] = c;
	    if ((c = input()) == '*') {
		level++;
	    } else {
		unput(c);
	    }
        } else if (c == 0) {
            char buf[MAXSTRLEN];
            sprintf(buf, "incomplete comment (%d)\n", yylineno);
            fail(buf);
        }
    }
}

void binbin(instr, outstr)
char *instr;
char *outstr;
{
    char *cp, *firstcp;
    int blen = 0, bpos=0;

    blen = atoi(instr);
    blen = (blen==0) ? MAXBITNUM : blen;
    firstcp = strpbrk(instr, "bB")+1;
    cp = instr + strlen(instr) - 1;
    outstr[blen] = '\0';
    for (bpos = blen-1; bpos >=0 && cp >= firstcp;) {
	if (*cp != '_') {
	    outstr[bpos] = *cp;
	    bpos--;
	}
    }
    for (; bpos >=0; bpos--) {
	outstr[bpos] = '0';
    }
}

char *hexnum[16] = {"0000","0001","0010","0011",
		    "0100","0101","0110","0111",
		    "1000","1001","1010","1011",
                    "1100","1101","1110","1111"};

void decbin(instr, outstr)
char *instr;
char *outstr;
{
    char *firstcp, buf[MAXSTRLEN];
    int num, blen = 0;

    utol(instr);
    blen = atoi(instr);
    blen = (blen==0) ? MAXBITNUM : blen;
    firstcp = strpbrk(instr, "dD")+1;
    num = atoi(firstcp); /* don't put x, z, ? in decimal string */
    sprintf(buf, "%d'h%x", blen, num);
    hexbin(buf, outstr);
}

void octbin(instr, outstr)
char *instr;
char *outstr;
{
    char *cp, *firstcp;
    int blen = 0, bpos=0, i;

    utol(instr);
    blen = atoi(instr);
    blen = (blen==0) ? MAXBITNUM : blen;
    firstcp = strpbrk(instr, "oO")+1;
    cp = instr + strlen(instr) - 1;
    outstr[blen] = '\0';
    for (bpos = blen-1; bpos >=0 && cp >= firstcp; cp--) {
	if (*cp != '_') {
	    for (i = 3; i >= 1; i--) {
		if (bpos >= 0) {
		    if (*cp=='x' || *cp=='z' || *cp=='?') {
			outstr[bpos] = *cp;
			bpos--;
		    } else if (isdigit(*cp)) {
			outstr[bpos] = hexnum[*cp-'0'][i];
			bpos--;
		    }
		}
	    }
	}
    }
    for (; bpos >=0; bpos--) {
	outstr[bpos] = '0';
    }
}

void hexbin(instr, outstr)
char *instr;
char *outstr;
{
    char *cp, *firstcp;
    int blen = 0, bpos=0, i;

    utol(instr);
    blen = atoi(instr);
    blen = (blen==0) ? MAXBITNUM : blen;
    firstcp = strpbrk(instr, "hH")+1;
    cp = instr + strlen(instr) - 1;
    outstr[blen] = '\0';
    for (bpos = blen-1; bpos >=0 && cp >= firstcp; cp--) {
	if (*cp != '_') {
	    for (i = 3; i >= 0; i--) {
		if (bpos >= 0) {
		    if (*cp=='x' || *cp=='z' || *cp=='?') {
			outstr[bpos] = *cp;
			bpos--;
		    } else if (isdigit(*cp)) {
			outstr[bpos] = hexnum[*cp-'0'][i];
			bpos--;
		    } else if (isxdigit(*cp)) {
			outstr[bpos] = hexnum[*cp-'a'+10][i];
			bpos--;
		    }
		}
	    }
	}
    }
    for (; bpos >=0; bpos--) {
	outstr[bpos] = '0';
    }
}

char *utol(str)
char *str;
{
    char *cp;
    
    for (cp = str; *cp!='\0'; cp++) {
	if (isupper(*cp)) *cp = tolower(*cp);
    }
    return str;
}

encodebit(instr, part1, part0)
char *instr;
int *part1, *part0;
{
    int i, bmask;

    *part1 = *part0 = 0;
    i = strlen(instr);
    i = (i > MAXBITNUM) ? MAXBITNUM-1 : i-1;
    for (bmask = 1; i>=0; bmask <<= 1, i--) {
	switch (instr[i]) {
	case '1': *part1 |= bmask; break;
	case '0': *part0 |= bmask; break;
	case 'x': 
	case '?': *part1 |= bmask; *part0 |= bmask; break;
	case 'z': break;
	}
    }
}

/*
 * memorize_macro
 *
 *     insert a argumentless macro into macro table
 */
void memorize_macro(instr, macros)
char *instr;
st_table *macros;
{
    char *cp;
    char mname[MAXSTRLEN];

    cp = strstr(instr,MACRO_DEFINE) + strlen(MACRO_DEFINE);
    sscanf(cp, "%s", mname);
    cp = strstr(cp, mname) + strlen(mname);
    st_insert(macros, strdup(mname), strdup(cp));
}

/*
 * expand_macro
 *
 *     expand an argumentless macro into input stream (using unput)
 */
void expand_macro(mname, macros)
char *mname;
st_table *macros;
{
    char *mbody;
    int i;

    if (st_lookup(macros, mname, &mbody)) {
	for (i=0; i<strlen(mbody); i++) {
	    unput(mbody[i]);
	}
    }
}
