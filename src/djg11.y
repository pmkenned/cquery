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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/main.c,v 1.2 1993/01/15 19:40:32 stcheng Exp stcheng $
 */
#include <stdio.h>
#include "util.h"
#include "st.h"
#include "list.h"
#include "vl_types.h"
#include "vl_defs.h"
#include "vl_traverse.h"
#include "vl_write.h"

extern vl_descPtr vl_description;
extern st_table *macros;
extern PrtEnable;
extern Use_MV_Lib;
extern FILE *yyin;
extern FILE *mv_file;
extern FILE *open_file();

char *opts = "lpo:";
int ith_module = 0;

int main(argc, argv)
int argc;
char *argv[];
{
    char c;
    lsHandle handle;
    lsGen gen;
    vl_module *mod;
    extern int optind;
    extern char *optarg;

    /* initialize macro table for scanner */
    macros = st_init_table(strcmp, st_strhash);

    if (argc <= 1) {
	usage(argv[0]);
    }

    while ((c = getopt(argc, argv, opts)) != EOF) {
	switch (c) {
	case 'l': Use_MV_Lib=1; break;
	case 'p': PrtEnable=1; break;
	case 'o': mv_file=open_file(optarg,"w"); break;
	default: usage(argv[0]);
	}
    }

    yyin = fopen(argv[optind],"r");
    if (!yyin) usage(argv[0]);

    printf("-- beginning parse\n");
    if (yyparse())
	printf("-- parsing failure\n");
    else
	printf("-- completed parsing\n");

    st_foreach(vl_description->mp_st, vl_step_desc, NIL(char));
    PrtEnable = 1;
    gen = lsStart(vl_description->modules);
    while (lsNext(gen, &mod, &handle) != LS_NOMORE) {
	vl_write_desc(mod->name->name, mod, 0);
	ith_module++;
    }
    /*
    st_foreach(vl_description->mp_st, vl_write_desc, NIL(char));
    */
    vl_dump_libs(mv_file, vl_description->decl_st);
}

usage(cmd)
char *cmd;
{
    fprintf(stderr, "usage: %s -%s <filename>\n", cmd, opts);
    fprintf(stderr, "       -o <file> : direct output to <file>\n");
    fprintf(stderr, "       -p        : dump internal representation\n");
    exit(255);
}
                                                                                                   vl2mv/src/parser/util.c                                                                             100644  027004  000214  00000022053 05346760050 012305  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/util.c,v 1.2 1993/01/15 19:41:00 stcheng Exp stcheng $
 *
 * Verilog parser utilities.
 *
 * Author: STCheng, stcheng@ic.berkeley.edu
 *
 */

#include <stdio.h>
#include "util.h"
#include "list.h"
#include "st.h"
#include "vl_defs.h"
#include "vl_types.h"
#include "vlr_int.h"
#include "verilog_yacc.h"
#include "vl_create.h"
#include "vl_write.h"

void chk_error(str)
char *str;
{
    printf(stderr, "internal utility error:%s\n", str);
    exit(ERR_CHK);
}

char *chk_malloc(n)
unsigned n;
{
    char *retval;
    if ((retval=(char*)malloc(n)) == NIL(char))
	chk_error("can't allocate memory ");

    return retval;
}

void chk_free(p)
char *p;
{
    free(p);
}

char* strdup(str)
char* str;
{
    char *retval;
    unsigned length;

    length = strlen(str)+1;
    retval = (char*)chk_malloc(length);
    strcpy(retval, str);
    return retval;
}

compile_error(str)
char* str;
{
    extern yylineno;

    fprintf(stderr, "line %d %s\n", yylineno, str);
    exit(ERR_COMPILE);
}

internal_error(str)
char* str;
{
    fprintf(stderr, "internal error: %s\n", str);
    exit(ERR_INTERNAL);
}

Translate_Warning(str)
char *str;
{
    fprintf(stderr, "%s, translation might be imprecise\n",
	    str);
}

int drive_strength(strength0, strength1)
int strength0, strength1;
{
    int retval;

    switch(strength0) {
    case YYSUPPLY0: 
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1Supply0; break;
	case YYSTRONG1:retval = Strong1Supply0; break;
	case YYPULL1:  retval = Pull1Supply0; break;
	case YYWEAK1:  retval = Weak1Supply0; break;
	case YYHIGHZ1: retval = HighZ1Supply0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYSTRONG0:
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1Strong0; break;
	case YYSTRONG1:retval = Strong1Strong0; break;
	case YYPULL1:  retval = Pull1Strong0; break;
	case YYWEAK1:  retval = Weak1Strong0; break;
	case YYHIGHZ1: retval = HighZ1Strong0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYPULL0:
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1Pull0; break;
	case YYSTRONG1:retval = Strong1Pull0; break;
	case YYPULL1:  retval = Pull1Pull0; break;
	case YYWEAK1:  retval = Weak1Pull0; break;
	case YYHIGHZ1: retval = HighZ1Pull0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYWEAK0:
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1Weak0; break;
	case YYSTRONG1:retval = Strong1Weak0; break;
	case YYPULL1:  retval = Pull1Weak0; break;
	case YYWEAK1:  retval = Weak1Weak0; break;
	case YYHIGHZ1: retval = HighZ1Weak0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYHIGHZ0:
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1HighZ0; break;
	case YYSTRONG1:retval = Strong1HighZ0; break;
	case YYPULL1:  retval = Pull1HighZ0; break;
	case YYWEAK1:  retval = Weak1HighZ0; break;
	case YYHIGHZ1: retval = HighZ1HighZ0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    default: compile_error("illegal strength0/strength1");
    }

    return retval;
}

/* 
 * insert_intances 
 *
 *     insert instances into current module symbol table and link all 
 *     instance names back to their declaration statements.
 */
void insert_instances(inst_list, inst_master)
lsList inst_list;     /* list of vl_mod_prim_inst */
void *inst_master;    /* expression used to instantiate the instances */
{
    lsGen gen;
    lsHandle handle;
    char *mpg;

    /* insert instances into inst_st */
    if (vl_currentModule == NIL(vl_module)) {
	compile_error("instantiate mod/prim/gate not within module");
    } else {
	lsGen gen;
	lsHandle Hanle;
	typestruct *mpg;
	
	gen = lsStart(inst_list);
	if (lsNext(gen, &mpg, &handle) == LS_OK) {
	    if (((vl_mod_prim_inst*)mpg)->name) { /* around anonymous inst */
		st_insert(vl_currentModule->inst_st, 
			  ((vl_mod_prim_inst*)mpg)->name->name, mpg);
		((vl_mod_prim_inst*)mpg)->name->mpg_master_exp = inst_master;
	    }
	    while (lsNext(gen, &mpg, &handle) != LS_NOMORE) {
		if (((vl_mod_prim_inst*)mpg)->name) {
		    st_insert(vl_currentModule->inst_st, 
			      ((vl_mod_prim_inst*)mpg)->name->name, mpg);
		    ((vl_mod_prim_inst*)mpg)->name->mpg_master_exp = 
			inst_master;
		}
	    }
	}
	(void) lsFinish(gen);
    }
}

/*
 * collect_latch
 *
 *     put signals that are candidate to use latch into vl_currentModule's
 *     symbol table.
 */
void collect_latch(name)
char *name;
{
    vl_id_range *id_sym, *latch_sym;
    blif_latch *latch;
    char latch_name[MAXSTRLEN];

    if (!st_lookup(vl_currentModule->latch_st, name, &latch)) {
	if (!st_lookup(vl_currentModule->sig_st, name, &id_sym)) {
	    char buf[MAXSTRLEN];
	   
	    sprintf(buf, "%s %s", name, "undefined and used as latch");
	    compile_error(buf);
	    id_sym = vl_create_id_range(name, NIL(vl_range));
	    st_insert(vl_currentModule->sig_st, name, (char*)id_sym);
	}
	sprintf(latch_name, "%s%s", name, SEP_LATCH);
	latch_sym = vl_copy_id_range(id_sym);
	free(latch_sym->name);
	latch_sym->name = strdup(latch_name);
	st_insert(vl_currentModule->sig_st, strdup(latch_name), latch_sym);
	latch = create_latch(id_sym, NIL(char), NIL(char));
	st_insert(vl_currentModule->latch_st, name, latch);
    } 
}

dup_info_var_in_st(vars)
st_table *vars;
{
    st_generator *gen;
    char *key;
    var_info *cur_var;

    gen = st_init_gen(vars);
    while (st_gen(gen, &key, &cur_var)) {
	st_insert(vars, key, copy_var_info(cur_var));
    }
    st_free_gen(gen);
}

reset_cond_list_in_st(vars)
st_table *vars;
{
    st_generator *gen;
    char *key;
    var_info *cur_var;

    gen = st_init_gen(vars);
    while (st_gen(gen, &key, &cur_var)) {
	lsDestroy(cur_var->cond_list,0);
	cur_var->cond_list = lsCreate();
    }
    st_free_gen(gen);
}

int data_width(expr)
vl_expr *expr;
{
    int retval = 0, v;

    switch(expr->type) {
    case IntExpr: 
	for (retval=0, v=expr->u.intval; v>0; v >>= 1, retval++);
	break;
    case RealExpr: 
	for (retval=0, v=(int)expr->u.realval; v>0; v >>= 1, retval++);
	break;
    case BitExpr: break;
    }

    return retval;
}

char *strappend(str1, str2)
char *str1;
char *str2;
{
    char *retval;
    strcat(str1, str2);
    retval = str1 + strlen(str2);
    return retval;
}

char *strappendS(str1, str2)
char *str1;
char *str2;
{
    strcat(str1, str2);
    strcat(str1, " ");
    return (str1 + strlen(str2)+1);
}

char *WRT_BLIF_GND(file)
FILE *file;
{
    char *retval;

    retval = strdup(new_termname());
    fprintf(file, ".names %s\n", retval);
    fprintf(file, "0\n");
    return retval;
}

char *WRT_BLIF_SUP(file)
FILE *file;
{
    char *retval;

    retval = strdup(new_termname());
    fprintf(file, ".names %s\n", retval);
    fprintf(file, "1\n");
    return retval;
}

vl_term *true_term(file)
FILE *file;
{
    vl_term *retval;

    retval = vl_create_term(vl_create_id_range(strdup(new_termname()),NIL(vl_id_range)),
			       0, -1);
    fprintf(file, ".names %s\n", retval->name->name);
    fprintf(file, "1\n");
    return retval;
}

int ptrcmp(ptr1, ptr2)
char *ptr1;
char *ptr2;
{
    if (ptr1==ptr2) return 0;
    if (ptr1 < ptr2) return -1;
    if (ptr1 > ptr2) return 1;
}

int ptrhash(key, modulus)
char *key;
int modulus;
{
    return ((int)key % modulus);
}

/*
 * declcmp
 *
 *     for now, it can only handle numerical symbolic values,
 *     other entension to mvar should check this also.
 */
int declcmp(ptr1, ptr2)
char *ptr1, *ptr2;
{
    int l1, l2;
    int r1, r2;

    l1 = vl_eval_expr(get_decl_range_left(ptr1));
    r1 = vl_eval_expr(get_decl_range_right(ptr1));
    l2 = vl_eval_expr(get_decl_range_left(ptr2));
    r2 = vl_eval_expr(get_decl_range_right(ptr2));

    if (l1==l2 && r1==r2) 
	return 0;
    else
	return 1;
}

int declhash(key, modulus)
char *key;
int modulus;
{
    return ((int)key % modulus);
}

char *strip_char (str, ch)
char *str;
char ch;
{
    int i;
    
    for (i=strlen(str)-1; i>=0; i--) {
	if (str[i]==ch) 
	    str[i]='\0';
	else 
	    break;
    }
    return str;
}

FILE *open_file(name, mode)
char *name;
char *mode;
{
    FILE *retval;

    retval = fopen(name, mode);
    if (!retval) {
	char msg[MAXSTRLEN];

	sprintf(msg, "can't open file %s", name);
	chk_error(msg);
    }
    return retval;
}

void close_file(file)
FILE *file;
{
    fclose(file);
}

char *num_to_binstr(num, width)
int num, width;
{
    static char retval[MAXSTRLEN];
    int i;

    for (i=0; i<width; i++) {
	retval[width-i-1] = (char)('0'+(num & 1));
	num = (num >> 1);
    }
    retval[width] = '\0';

    return retval;
}

 st_foreach(vl_description->mp_st, vl_write_desc, NIL(char));
    */
    vl_dump_libs(mv_file, vl_description->decl_st);
}

usage(cmd)
char *cmd;
{
    fprintf(stderr, "usage: %s -%s <filename>\n", cmd, opts);
    fprintf(stderr, "       -o <file> : direct output to <file>\n");
    fprintf(stderr, "       -p        : dump internal representation\n");
    exit(255);
}
                                                                                                   vl2mv/src/parser/makefile                                                                           100644  027004  000214  00000005063 05332024414 012656  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #
#  vl2mv: Verilog to BLIF-MV Translator Distribution
#
#  Copyright (c) 1992, 1993
#        Regents of the University of California
#  All rights reserved.
#
#  Use and copying of this software and preparation of derivative works
#  based upon this software are permitted.  However, any distribution of
#  this software or derivative works must include the above copyright 
#  notice.
#
#  This software is made available AS IS, and neither the Electronics
#  Research Laboratory or the Universify of California make any
#  warranty about the software, its performance or its conformity to
#  any specification.
#
#
# $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/makefile,v 1.2 1993/01/15 19:48:20 stcheng Exp stcheng $
#
# makefile for vl2mv
#

# programs used
CC = cc
LEX = lex
MAKE = make
SED = sed
YACC = yacc

# .c.o suffixes
.SUFFIXES:
.SUFFIXES: .c .o

# target
TARGET = ../../vl2mv

# directories
INCLUDE = ../../include
LIB = ../../lib

# related files
CFILES = main.c vl_create.c vl_traverse.c vl_write.c util.c
OFILES = main.o vl_create.o vl_traverse.o vl_write.o util.o
HFILES = $(INCLUDE)/vlr_int.h $(INCLUDE)/vl_create.h $(INCLUDE)/vl_defs.h $(INCLDUDE)/vl_types.h $(INCLUDE)/vl_write.h
LFILES = verilog.l
YFILES = verilog.y
GCFILES = verilog_yacc.c
GLCFILES = verilog_lex.c
GOFILES = verilog_yacc.o
GLOFILES = verilog_lex.o
GHFILES = verilog_yacc.h

# libraries
LIBS = $(LIB)/libutil.a $(LIB)/libarray.a $(LIB)/libst.a  $(LIB)/liblist.a

# flags
CFLAGS = -g -I$(INCLUDE)
LDFLAGS = -g
LFLAGS = -n
YFLAGS = -d

# defaults
.c.o:
	$(CC) -c $(CFLAGS) $*.c

$(TARGET):= CFLAGS = -g
$(TARGET):= LDFLAGS = -g
$(TARGET): $(GOFILES) $(GLOFILES) $(OFILES) $(LIBS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(GOFILES) $(GLOFILES) $(OFILES) $(LIBS)

# yacc/lex rules
verilog_yacc.c verilog.h: verilog.y verilog.sed
	$(YACC) $(YFLAGS) verilog.y
	@$(SED) -f verilog.sed y.tab.c > verilog_yacc.c
	@$(SED) -f verilog.sed y.tab.h > $(INCLUDE)/verilog_yacc.h
	@$(RM) y.tab.c y.tab.h

verilog_lex.c: verilog.l verilog.sed
	$(LEX) $(LFLAGS) verilog.l
	@$(SED) -f verilog.sed lex.yy.c > verilog_lex.c
	@$(RM) lex.yy.c

#libraries
$(LIB)/libutil.a: 
	cd ../util; make; cd ../parser

$(LIB)/libarray.a:
	cd ../array; make; cd ../parser

$(LIB)/libst.a:
	cd ../st; make; cd ../parser

$(LIB)/liblist.a:
	cd ../list; make; cd ../parser

# everything depends on makefile
$(CFILES) $(HFILES) $(EFILES) $(LFILES) $(YFILES): makefile

# files which include .h files
$(CFILES): $(HFILES)

# clean up directory
clean:
	@$(RM) $(TARGET) $(OFILES) $(GCFILES) $(GLCFILES) $(GOFILES) $(GLOFILES) $(GHFILES)
	@$(RM) target make.out

Strong0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYPULL0:
	switch(strength1) {
	case YYSUPPLY1:retval = Supply1Pull0; break;
	case YYSTRONG1:retval = Strong1Pull0; break;
	case YYPULL1:  retval = Pull1Pull0; break;
	case YYWEAK1:  retval = Weak1Pull0; break;
	case YYHIGHZ1: retval = HighZ1Pull0; break;
	default: compile_error("illegal strength0/strength1");
	} 
	break;
    case YYWEAK0:
	switch(strength1) {
	case vl2mv/src/parser/verilog.l                                                                          100644  027004  000214  00000034145 05332024416 013007  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 %{
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
ormal>for                { return YYFOR; }
<Snormal>forever            { return YYFOREVER; }
<Snormal>fork               { return YYFORK; }
<Snormal>function           { return YYFUNCTION; }
<Snormal>highz0             { return YYHIGHZ0; }
<Snormal>highz1             { return YYHIGHZ1; }
<Snormal>if                 { return YYIF; }
<Snormal>initial            { return YYINITIAL; }
<Snormal>inout             vl2mv/src/parser/verilog.y                                                                          100644  027004  000214  00000260616 05332024423 013026  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/verilog.y,v 1.3 1993/01/15 19:47:04 stcheng Exp stcheng $
 *
 * verilog.y:
 *   
 *   Purpose -
 *     verilog parser, from D.E.Thomas, P.R.Moorby, "The Verilog Hardware 
 *     Description Language."
 *           
 *   Author -
 *     Szu-Tsung Cheng, stcheng@ic.berkeley.edu
 *
 *   Date -
 *     9/14/92 1st version, raw grammar finished. s/s, s/r errors not resolved
 *     9/??/92 s/s, s/r errors solved except if ... else ...
 *     10/12/92 Combined with Gary's vl_create and vl_print routines. Now
 *               whole parsing is working. Check in first versin RCS.
 *     10/15/92 Add named port and primitive table processing. Check in RCS.
 */

%{

#include <stdio.h>
#include "util.h"
#include "list.h"
#include "st.h"
#include "vl_defs.h"
#include "vl_types.h"
#include "vlr_int.h"
#include "vl_create.h"

extern char yyid[];
extern char brep[];
extern int bexp0, bexp1;


static int YYTrace=0;

vl_descPtr vl_description;
vl_modulePtr vl_currentModule;
vl_primitivePtr vl_currentPrimitive;
char modName[MAXSTRLEN];
short eventType;

%}

/* YYSTYPE */
%union {
    int             ival;
    char            *charp;
    typestructPtr   type;
    lsList          lstp;
    vl_bassign_stmtPtr      basgn;
    vl_begin_end_stmtPtr    seqstmt;
    vl_case_itemPtr caseitem;
    vl_cont_assignPtr       casgn;
    vl_declPtr      bascdcl;
    vl_delayPtr     dlay;
    vl_descPtr      desc;
    vl_event_exprPtr        evnt;
    vl_exprPtr      expr;
    vl_fork_join_stmtPtr    parstmt;
    vl_functionPtr  func;
    vl_gate_instPtr gtinst;
    vl_gate_inst_listPtr    gtlist;
    vl_id_rangePtr  idrng;
    vl_lvalPtr      lval;
    vl_mod_prim_inst_listPtr modlist;
    vl_modulePtr    modu;
    vl_netdeclPtr   netdcl;
    vl_paramdeclPtr paradcl;
    vl_portPtr      port;
    vl_port_connectPtr      connect;
    vl_prim_entryPtr        ntry;
    vl_primitivePtr prim;
    vl_procstmtPtr  prcstmt;
    vl_rangePtr     rang;
    vl_range_or_typePtr     rngtyp;
    vl_rangedeclPtr rangdcl;
    vl_taskPtr      task;
    vl_task_enable_stmtPtr  taskenablstmt;
}

/* starting symbol */
%start source_text

/* tokens */
%token YYID                      /* verilog user defined identifier */
%token YYINUMBER                 /* integer */
%token YYRNUMBER                 /* real */
%token YYSTRING                  /* string quoted by "" */
%token YYALLPATH                 /* *> */
%token YYALWAYS                  /* always */
%token YYAND                     /* and */
%token YYASSIGN                  /* assign */
%token YYBEGIN                   /* begin */
%token YYBUF                     /* buf */
%token YYBUFIF0                  /* bufif0 */
%token YYBUFIF1                  /* bufif1 */
%token YYCASE                    /* case */
%token YYCASEX                   /* casex */
%token YYCASEZ                   /* casez */
%token YYCMOS                    /* cmos */
%token YYCONDITIONAL             /* ?: */
%token YYDEASSIGN                /* deassign */
%token YYDEFAULT                 /* default */
%token YYDEFPARAM                /* defparam */
%token YYDISABLE                 /* disable */
%token YYELSE                    /* else */
%token YYEDGE                    /* edge */
%token YYEND                     /* end */
%token YYENDCASE                 /* endcase */
%token YYENDMODULE               /* endmodule */
%token YYENDFUNCTION             /* endfunction */
%token YYENDPRIMITIVE            /* endprimitive */
%token YYENDSPECIFY              /* endspecify */
%token YYENDTABLE                /* endtable */
%token YYENDTASK                 /* endtask */
%token YYEVENT                   /* event */
%token YYFOR                     /* for */
%token YYFOREVER                 /* forever */
%token YYFORK                    /* fork */
%token YYFUNCTION                /* function */
%token YYGEQ                     /* >= */
%token YYHIGHZ0                  /* highz0 */
%token YYHIGHZ1                  /* highz1 */
%token YYIF                      /* if */
%token YYINITIAL                 /* initial */
%token YYINOUT                   /* inout */
%token YYINPUT                   /* input */
%token YYINTEGER                 /* integer */
%token YYJOIN                    /* join */
%token YYLARGE                   /* large */
%token YYLEADTO                  /* => */
%token YYLEQ                     /* =< */
%token YYLOGAND                  /* && */
%token YYCASEEQUALITY            /* === */
%token YYCASEINEQUALITY          /* !== */
%token YYLOGNAND                 /* ~& */
%token YYLOGNOR                  /* ~| */
%token YYLOGOR                   /* || */
%token YYLOGXNOR                 /* ~^ or ^~ */
%token YYLOGEQUALITY             /* == */
%token YYLOGINEQUALITY           /* != */
%token YYLSHIFT                  /* << */
%token YYMACROMODULE             /* macromodule */
%token YYMEDIUM                  /* medium */
%token YYMODULE                  /* module */
%token YYMREG   	         /* mreg */
%token YYNAND                    /* nand */
%token YYNBASSIGN                /* <= non-blocking assignment */
%token YYNEGEDGE                 /* negedge */
%token YYNMOS                    /* nmos */
%token YYNOR                     /* nor */
%token YYNOT                     /* not */
%token YYNOTIF0                  /* notif0 */
%token YYNOTIF1                  /* notif1 */
%token YYOR                      /* or */
%token YYOUTPUT                  /* output */
%token YYPARAMETER               /* parameter */
%token YYPMOS                    /* pmos */
%token YYPOSEDGE                 /* posedge */
%token YYPRIMITIVE               /* primitive */
%token YYPULL0                   /* pull0 */
%token YYPULL1                   /* pull1 */
%token YYPULLUP                  /* pullup */
%token YYPULLDOWN                /* pulldown */
%token YYRCMOS                   /* rcmos */
%token YYREAL                    /* real */
%token YYREG                     /* reg */
%token YYREPEAT                  /* repeat */
%token YYRIGHTARROW              /* -> */
%token YYRNMOS                   /* rnmos */
%token YYRPMOS                   /* rpmos */
%token YYRSHIFT                  /* >> */
%token YYRTRAN                   /* rtran */
%token YYRTRANIF0                /* rtranif0 */
%token YYRTRANIF1                /* rtranif1 */
%token YYSCALARED                /* scalared */
%token YYSMALL                   /* small */
%token YYSPECIFY                 /* specify */
%token YYSPECPARAM               /* secparam */
%token YYSTRONG0                 /* strong0 */
%token YYSTRONG1                 /* strong1 */
%token YYSUPPLY0                 /* supply0 */
%token YYSUPPLY1                 /* supply1 */
%token YYSWIRE                   /* swire */
%token YYTABLE                   /* table */
%token YYTASK                    /* task */
%token YYTIME                    /* time */
%token YYTRAN                    /* tran */
%token YYTRANIF0                 /* tranif0 */
%token YYTRANIF1                 /* tranif1 */
%token YYTRI                     /* tri */
%token YYTRI0                    /* tri0 */
%token YYTRI1                    /* tri1 */
%token YYTRIAND                  /* triand */
%token YYTRIOR                   /* trior */
%token YYTRIREG                  /* trireg */
%token YYVECTORED                /* vectored */
%token YYWAIT                    /* wait */
%token YYWAND                    /* wand */
%token YYWEAK0                   /* weak0 */
%token YYWEAK1                   /* weak1 */
%token YYWHILE                   /* while */
%token YYWIRE                    /* wire */
%token YYWOR                     /* wor */
%token YYXNOR                    /* xnor */
%token YYXOR                     /* xor */
%token YYsysSETUP                /* $setup */
%token YYsysID                   /* $... */

%right YYCONDITIONAL
%right '?' ':'
%left YYOR
%left YYLOGOR
%left YYLOGAND
%left '|'
%left '&' '^' YYLOGXNOR
%left YYLOGEQUALITY YYLOGINEQUALITY YYCASEEQUALITY YYCASEINEQUALITY
%left '<' YYLEQ '>' YYGEQ YYNBASSIGN
%left YYLSHIFT YYRSHIFT
%left '+' '-'
%left '*' '/' '%'
%right '~' '!' YYUNARYOPERATOR

%type <desc> source_text
%type <desc> description
%type <modu> module
%type <prim> primitive
%type <lstp> port_list_opt port_list
%type <port> port
%type <lstp> port_expression_opt port_expression
%type <lstp> port_ref_list
%type <idrng> port_reference
%type <rang> port_reference_arg
%type <type> module_item
%type <lstp> module_item_clr
%type <paradcl> parameter_declaration
%type <rangdcl> input_declaration output_declaration inout_declaration
%type <rangdcl> reg_declaration
%type <netdcl>  net_declaration
%type <bascdcl> time_declaration event_declaration
%type <bascdcl> integer_declaration real_declaration
%type <gtlist>  gate_instantiation
%type <type> module_or_primitive_instantiation
%type <paradcl> parameter_override
%type <casgn>   continuous_assign
%type <prcstmt> initial_statement always_statement
%type <task> task
%type <func> function
%type <lstp> variable_list primitive_declaration_eclr
%type <lstp> table_definition
%type <lstp> table_entries combinational_entry_eclr sequential_entry_eclr
%type <ntry> combinational_entry sequential_entry
%type <lstp> input_list level_symbol_or_edge_eclr
%type <ival> output_symbol state next_state 
%type <ival> level_symbol edge level_symbol_or_edge edge_symbol
%type <type> primitive_declaration
%type <lstp> tf_declaration_clr tf_declaration_eclr
%type <lstp> statement_opt
%type <rngtyp>  range_or_type_opt range_or_type
%type <rang> range
%type <type> tf_declaration
%type <lstp> assignment_list
%type <rang> range_opt
%type <expr> expression
%type <ival> drive_strength_opt drive_strength 
%type <ival> charge_strength_opt charge_strength
%type <ival> nettype
%type <rang> expandrange_opt expandrange
%type <dlay> delay_opt delay
%type <lstp> register_variable_list
%type <lstp> name_of_event_list
%type <idrng>  identifier
%type <idrng>  register_variable
%type <charp>  name_of_register
%type <idrng>  name_of_event
%type <ival> strength0 strength1
%type <basgn>  assignment
%type <lstp> drive_delay_clr gate_instance_list
%type <ival> gatetype drive_delay
%type <gtinst> gate_instance
%type <lstp> terminal_list
%type <idrng>  name_of_gate_instance name_of_module_or_primitive
%type <expr> terminal
%type <lstp> module_or_primitive_option_clr
%type <ival> module_or_primitive_option
%type <lstp> module_or_primitive_instance_list
%type <dlay> delay_or_parameter_value_assignment
%type <type> module_or_primitive_instance
%type <lstp> module_connection_list module_port_connection_list
%type <lstp> named_port_connection_list
%type <connect> module_port_connection named_port_connection
%type <type> statement
%type <lstp> statement_clr case_item_eclr
%type <caseitem> case_item
%type <dlay> delay_control
%type <evnt> event_control
%type <lval> lvalue
%type <lstp> expression_list
%type <seqstmt>  seq_block
%type <parstmt>  par_block
%type <idrng> name_of_block
%type <lstp> block_declaration_clr
%type <type> block_declaration
%type <taskenablestmt>  task_enable
%type <lstp> concatenation multiple_concatenation
%type <lstp> mintypmax_expression_list
%type <expr> mintypmax_expression
%type <expr> primary
%type <expr> function_call
%type <evnt> event_expression ored_event_expression

%%

/* F.1 Source Text */

source_text
        :
          {
	      extern vl_descPtr mod_list;

              YYTRACE("sorce_text:");
	      $$ = vl_description = mod_list = vl_create_desc("stdin");
          }
        | source_text description
          {
              YYTRACE("source_text: source_text description");
          }
        ;

description 
	: module
          {
              YYTRACE("description: module");
          }
	| primitive
          {
              YYTRACE("description: primitive");
          }
	;

module 
	: YYMODULE YYID 
          {
              vl_id_rangePtr idptr;

              idptr = vl_create_id_range(strdup(yyid), NIL(vl_range));
	      vl_currentModule = vl_create_module(idptr, LS_NIL, LS_NIL); 
          } 
          port_list_opt ';'
          {
	      vl_currentModule->ports = $4;
          }
          module_item_clr
	  YYENDMODULE
          {
              YYTRACE("module: YYMODULE YYID port_list_opt ';' module_item_clr YYENDMODULE");
	      vl_currentModule->mod_items = $7;
	      $$ = vl_currentModule;
	      vl_currentModule = NIL(vl_module);
          }
	| YYMACROMODULE YYID port_list_opt ';'
		module_item_clr
	  YYENDMODULE
          {
              YYTRACE("module: YYMACROMODULE YYID port_list_opt ';' module_item_clr YYENDMODULE");
	      TODO("module: YYMACROMODULE YYID port_list_opt ';' module_item_clr YYENDMODULE");
          }
	;

port_list_opt
	:
          {
              YYTRACE("port_list_opt:");
              $$ = LS_NIL;
          }
	| '(' port_list ')'
          {
              YYTRACE("port_list_opt: '(' port_list ')'");
              $$ = $2;
          }
	;

port_list
	: port
          {
              lsHandle handle;

              YYTRACE("port_list: port");
              $$ = lsCreate();
              lsNewEnd($$, (lsGeneric)$1, &handle);
          }
	| port_list ',' port
          {
	      lsHandle *handle;

              YYTRACE("port_list: port_list ',' port");
	      lsNewEnd($1, (lsGeneric)$3, handle);
	      $$ = $1;
          }
	;

port
	: port_expression_opt
          {
              YYTRACE("port: port_expression_opt");
              $$ = vl_create_port(ModulePort, NIL(vl_id_range), $1);
          }
	| '.' YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
          '(' port_expression_opt ')'
          {
              YYTRACE("port: ',' YYID '(' port_expression_opt ')'");
	      $$ = vl_create_port(NamedPort, $<idrng>3, $5);
          }
	;

port_expression_opt
	:
           {
               YYTRACE("port_expression_opt:");
               $$ = LS_NIL;
           }
	|  port_expression
           {
               YYTRACE("port_expression_opt: port_expression");
           }
	;

port_expression
	: port_reference
          {
	      lsHandle handle;

              YYTRACE("port_expression: port_reference");
              $$ = lsCreate();
              lsNewEnd($$, $1, &handle);
          }
	| '{' port_ref_list '}'
          {
              YYTRACE("port_expression: '{' port_ref_list '}'");
	      $$ = $2;
          }
        ;

port_ref_list
	: port_reference
          {
              lsHandle handle;

              YYTRACE("port_ref_list: port_reference");
              $$ = lsCreate();
              lsNewEnd($$, $1, &handle);
          }
	| port_ref_list ',' port_reference
          {
              lsHandle handle;

              YYTRACE("port_ref_list: port_ref_list ',' port_reference");
              lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
	;

port_reference
	: YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
          port_reference_arg
          {
              YYTRACE("port_reference: YYID port_reference_arg");
              $$ = vl_create_id_range($<idrng>2->name, $3);
          }
	;

port_reference_arg
        :
          {
              YYTRACE("port_reference_arg:");
	      $$ = vl_create_range(NIL(vl_expr), NIL(vl_expr));
          }
        | '[' expression ']' /* expression must be constant expression */
          {
              YYTRACE("port_reference_arg: '[' expression ']'");
	      $$ = vl_create_range($2, NIL(vl_expr));
          }
        | '[' expression ':' expression ']' /* expression must be constant */
          {
              YYTRACE("port_reference_arg: '[' expression ':' expression ']'");
	      $$ = vl_create_range($2, $4);
          }
        ;

module_item_clr
        :
          {
              YYTRACE("module_item_clr:");
              $$ = lsCreate();
          }
        | module_item_clr module_item
          {
              lsHandle handle;

              YYTRACE("module_item_clr: module_item_clr module_item");
              lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

module_item
	: parameter_declaration
          {
              YYTRACE("module_item: parameter_declaration");
              $$ = (typestructPtr)$1;
          }
	| input_declaration
          {
              YYTRACE("module_item: input_declaration");
              $$ = (typestructPtr)$1;
          }
	| output_declaration
          {
              YYTRACE("module_item: output_declaration");
              $$ = (typestructPtr)$1;
          }
	| inout_declaration
          {
              YYTRACE("module_item: inout_declaration");
              $$ = (typestructPtr)$1;
          }
	| net_declaration
          {
              YYTRACE("module_item: net_declaration");
              $$ = (typestructPtr)$1;
          }
	| reg_declaration
          {
              YYTRACE("module_item: reg_declaration");
              $$ = (typestructPtr)$1;
          }
	| time_declaration
          {
              YYTRACE("module_item: time_declaration");
              $$ = (typestructPtr)$1;
          }
	| integer_declaration
          {
              YYTRACE("module_item: integer_declaration");
              $$ = (typestructPtr)$1;
          }
	| real_declaration
          {
              YYTRACE("module_item: real_declaration");
              $$ = (typestructPtr)$1;
          }
	| event_declaration
          {
              YYTRACE("module_item: event_declaration");
              $$ = (typestructPtr)$1;
          }
	| gate_instantiation
          {
              YYTRACE("module_item: gate_instantiation");
              $$ = (typestructPtr)$1;
          }
	| module_or_primitive_instantiation
          {
              YYTRACE("module_item: module_or_primitive_instantiation");
              $$ = (typestructPtr)$1;
          }
	| parameter_override
          {
              YYTRACE("module_item: parameter_override");
              $$ = (typestructPtr)$1;
          }
	| continuous_assign
          {
              YYTRACE("module_item: continous_assign");
              $$ = (typestructPtr)$1;
          }
	| specify_block
          {
              YYTRACE("module_item: specify_block");
              $$ = $<type>1;
          }
	| initial_statement
          {
              YYTRACE("module_item: initial_statement");
              $$ = (typestructPtr)$1;
          }
	| always_statement
          {
              YYTRACE("module_item: always_statement");
              $$ = (typestructPtr)$1;
          }
	| task
          {
              YYTRACE("module_item: task");
              $$ = (typestructPtr)$1;
          }
	| function
          {
              YYTRACE("module_item: function");
              $$ = (typestructPtr)$1;
          }
	;

primitive
	: YYPRIMITIVE YYID 
          {
	      vl_id_rangePtr idptr;

	      idptr = vl_create_id_range(strdup(yyid), NIL(vl_range));
	      vl_currentPrimitive = vl_create_primitive(idptr, 
							LS_NIL, 
							LS_NIL, 
							LS_NIL);
          }
          '(' port_list ')' ';'
	  	primitive_declaration_eclr
		table_definition
	  YYENDPRIMITIVE
          {
              lsList port_list;

              YYTRACE("primitive: YYPRMITIVE YYID '(' variable_list ')' ';' primitive_declaration_eclr table_definition YYENDPRIMITIVE");
	      vl_currentPrimitive->ports = $5;
	      vl_currentPrimitive->decls = $8;
	      vl_currentPrimitive->entries = $9;
              $$ = vl_currentPrimitive;
	      vl_currentPrimitive = NIL(vl_primitive);
          }
	;

primitive_declaration_eclr
        : primitive_declaration
          {
              lsHandle handle;

              YYTRACE("primitive_declaration_eclr: primitive_declaration");
              $$ = lsCreate();
              lsNewEnd($$, $1, &handle);
          }
        | primitive_declaration_eclr primitive_declaration
          {
              lsHandle handle;

              YYTRACE("primitive_declaration_eclr: primitive_declaration_eclr primitive_declaration");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

primitive_declaration
	: output_declaration
          {
              YYTRACE("primitive_declaration: output_declaration");
	      $$ = (typestructPtr)$1;
          }
	| reg_declaration
          {
              YYTRACE("primitive_decalration: reg_declaration");
	      $$ = (typestructPtr)$1;
          }
	| input_declaration
          {
              YYTRACE("primitive_decalration: input_declaration");
	      $$ = (typestructPtr)$1;
          }
	;

table_definition
	: YYTABLE table_entries YYENDTABLE
          {
              YYTRACE("table_definition: YYTABLE table_entries YYENDTABLE");
	      $$ = $2;
          }
	;

table_entries
	: combinational_entry_eclr
          {
              YYTRACE("table_definition: combinational_entry_eclr");
	      vl_currentPrimitive->type = CombPrimDecl;
          }
	| sequential_entry_eclr
          {
              YYTRACE("table_definition: sequential_entry_eclr");
	      vl_currentPrimitive->type = SeqPrimDecl;
          }
	;

combinational_entry_eclr
	: combinational_entry
          {
              YYTRACE("combinational_entry_eclr: combinational_entry");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, LS_NH);
          }
	| combinational_entry_eclr combinational_entry
          {
              YYTRACE("combinational_entry_eclr: combinational_entry_eclr combinational_entry");
	      lsNewEnd($1, $2, LS_NH);
	      $$ = $1;
          }
	;

combinational_entry
	: input_list ':' output_symbol ';'
          {
              YYTRACE("combinational_entry: input_list ':' output_symbol ';'");
	      $$ = vl_create_prim_entry($1, PrimNone, $3);
          }
	;

sequential_entry_eclr
	: sequential_entry
          {
              YYTRACE("sequential_entry_eclr: sequential_entry");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, LS_NH);
          }
	| sequential_entry_eclr sequential_entry
          {
              YYTRACE("sequential_entry_eclr: sequential_entry_eclr sequential_entry");
	      lsNewEnd($1, $2, LS_NH);
	      $$ = $1;
          }
	;

sequential_entry
	: input_list ':' state ':' next_state ';'
          {
              YYTRACE("sequential_entry: input_list ':' state ':' next_state ';'");
	      $$ = vl_create_prim_entry($1, $3, $5);
          }
	;

input_list
	: level_symbol_or_edge_eclr
          {
              YYTRACE("input_list: level_symbol_or_edge_eclr");
          }
	;

level_symbol_or_edge_eclr
        : level_symbol_or_edge
          {
              YYTRACE("level_symbol_or_edge_eclr: level_symbol_or_edge");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, LS_NH);
          }
        | level_symbol_or_edge_eclr level_symbol_or_edge
          {
              YYTRACE("level_symbol_or_edge_eclr: level_symbol_or_edge_eclr level_symbol_or_edge");
	      lsNewEnd($1, $2, LS_NH);
	      $$ = $1;
          }
        ;

level_symbol_or_edge
        : level_symbol
          {
              YYTRACE("level_symbol_or_edge: level_symbol");
          }
        | edge
          {
              YYTRACE("level_symbol_or_edge: edge");
          }
        ;

edge
	: '(' level_symbol level_symbol ')'
          {
              YYTRACE("edge: '(' level_symbol level_symbol ')'");
	      switch ($2) {
	      case Prim0: $$ = ($3==PrimX) ? Prim0X : PrimR; break;
	      case Prim1: $$ = ($3==PrimX) ? Prim1X : PrimF; break;
	      case PrimX: 
		  $$ = ($3==Prim1) ? PrimX1 : ($3==Prim0) ? PrimX0 : PrimXB;
		  break;
	      case PrimB: $$ = ($3==PrimX) ? PrimBX : PrimBB; break;
	      case PrimQ: 
		  $$ = ($3==Prim1) ? PrimQ1 : ($3==Prim0) ? PrimQ0 : PrimQB;
		  break;
	      default: {
		  char mesg[MAXSTRLEN];
		  
		  sprintf(mesg, "Unknown edge symbol (%d,%d)", $2, $3);
		  compile_error(mesg);
	      }
	      }
          }
	| edge_symbol
          {
              YYTRACE("edge: edge_symbol");
          }
	;

state
	: level_symbol
          {
              YYTRACE("state: level_symbol");
          }
	;

next_state
	: output_symbol
          {
              YYTRACE("next_state: output_symbol");
          }
	| '-'
          {
              YYTRACE("next_state: '_'");
	      $$ = PrimM;
          }
	;

output_symbol
	: '0'
          {
              YYTRACE("output_symbol: '0'");
	      $$ = Prim0;
          }
        | '1'
          {
              YYTRACE("output_symbol: '1'");
	      $$ = Prim1;
          }
        | 'x'
          {
              YYTRACE("output_symbol: 'x'");
	      $$ = PrimX;
          }
        | 'X'
          {
              YYTRACE("output_symbol: 'X'");
	      $$ = PrimX;
          }
        ;

level_symbol
	: '0'
          {
              YYTRACE("level_symbol: '0'");
	      $$ = Prim0;
          }
        | '1'
          {
              YYTRACE("level_symbol: '1'");
	      $$ = Prim1;
          }
        | 'x'
          {
              YYTRACE("level_symbol: 'x'");
	      $$ = PrimX;
          }
        | 'X'
          {
              YYTRACE("level_symbol: 'X'");
	      $$ = PrimX;
          }
        | '?'
          {
              YYTRACE("level_symbol: '?'");
	      $$ = PrimQ;
          }
        | 'b'
          {
              YYTRACE("level_symbol: 'b'");
	      $$ = PrimB;
          }
        | 'B'
          {
              YYTRACE("level_symbol: 'B'");
	      $$ = PrimB;
          }
        ;

edge_symbol
	: 'r'
          {
              YYTRACE("edge_symbol: 'r'");
	      $$ = PrimR;
          }
        | 'R'
          {
              YYTRACE("edge_symbol: 'R'");
	      $$ = PrimR;
          }
        | 'f'
          {
              YYTRACE("edge_symbol: 'f'");
	      $$ = PrimF;
          }
        | 'F'
          {
              YYTRACE("edge_symbol: 'F'");
	      $$ = PrimF;
          }
        | 'p'
          {
              YYTRACE("edge_symbol: 'p'");
	      $$ = PrimP;
          }
        | 'P'
          {
              YYTRACE("edge_symbol: 'P'");
	      $$ = PrimP;
          }
        | 'n'
          {
              YYTRACE("edge_symbol: 'n'");
	      $$ = PrimN;
          }
        | 'N'
          {
              YYTRACE("edge_symbol: 'N'");
	      $$ = PrimN;
          }
        | '*'
          {
              YYTRACE("edge_symbol: '*'");
	      $$ = PrimS;
          }
        ;

task
	: YYTASK YYID  
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));	      
	  }
          ';' tf_declaration_clr statement_opt 
          YYENDTASK
          {
              YYTRACE("YYTASK YYID ';' tf_declaration_clr statement_opt YYENDTASK");
	      $$ = vl_create_task($<idrng>3, $5, $6);
          }
	;

function
        : YYFUNCTION range_or_type_opt YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
          ';' tf_declaration_eclr statement_opt
          YYENDFUNCTION
          {
	      short func_type;

              YYTRACE("YYFUNCTION range_or_type_opt YYID ';' tf_declaration_eclr statement_opt YYENDFUNCTION");
	      if ($2 == NIL(vl_range_or_type)) {
		  func_type = IntFuncDecl; /* default function type */
	      } else {
		  switch ($2->type) {
		  case Range_Dcl: func_type = RangeFuncDecl; break;
		  case Integer_Dcl: func_type = IntFuncDecl; break;
		  case Real_Dcl: func_type = RealFuncDecl; break; 
		  defualt: internal_error("unknown function type");
		  }
	      }
	      $$ = vl_create_function(func_type, $2->range, $<idrng>4, $6, $7);
          }
        ;

range_or_type_opt
        :
          {
              YYTRACE("range_or_type_opt:");
	      $$ = NIL(vl_range_or_type);
          }
        | range_or_type
          {
              YYTRACE("range_or_type_opt: range_or_type");
	      $$ = $1;
          }
        ;

range_or_type
        : range
          {
              YYTRACE("range_or_type: range");
	      $$ = vl_create_range_or_type(Range_Dcl, $1);
          }
        | YYINTEGER
          {
              YYTRACE("range_or_type: YYINTEGER");
	      $$ = vl_create_range_or_type(Integer_Dcl, NIL(vl_range));
          }
        | YYREAL
          {
              YYTRACE("range_or_type: YYREAL");
	      $$ = vl_create_range_or_type(Real_Dcl, NIL(vl_range));
          }
        ;

tf_declaration_clr
        :
          {
              YYTRACE("tf_declaration_clr:");
	      $$ = lsCreate();
          }
        | tf_declaration_clr tf_declaration
          {
	      lsHandle handle;

              YYTRACE("tf_declaration_clr: tf_declaration_clr tf_declaration");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

tf_declaration_eclr
        : tf_declaration
          {
	      lsHandle handle;

              YYTRACE("tf_declaration_eclr: tf_declaration");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | tf_declaration_eclr tf_declaration
          {
	      lsHandle handle;

              YYTRACE("tf_declaration_eclr: tf_decalration_eclr tf_declaration");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

tf_declaration
        : parameter_declaration
          {
              YYTRACE("tf_declaration: parameter_decalration");
	      $$ = (typestructPtr)$1;
          }
        | input_declaration
          {
              YYTRACE("tf_declaration: input_declaration");
	      $$ = (typestructPtr)$1;
          }
        | output_declaration
          {
              YYTRACE("tf_declaration: output_declaration");
	      $$ = (typestructPtr)$1;
          }
        | inout_declaration
          {
              YYTRACE("tf_declaration: inout_declaration");
	      $$ = (typestructPtr)$1;
          }
        | reg_declaration
          {
              YYTRACE("tf_declaration: reg_declaration");
	      $$ = (typestructPtr)$1;
          }
        | time_declaration
          {
              YYTRACE("tf_declaration: time_declaration");
	      $$ = (typestructPtr)$1;
          }
        | integer_declaration
          {
              YYTRACE("tf_declaration: integer_declaration");
	      $$ = (typestructPtr)$1;
          }
        | real_declaration
          {
              YYTRACE("tf_declaration: real_declaration");
	      $$ = (typestructPtr)$1;
          }
        | event_declaration
          {
              YYTRACE("tf_declaration: event_declaration");
	      $$ = (typestructPtr)$1;
          }
        ;

/* F.2 Declarations */

parameter_declaration
        : YYPARAMETER assignment_list ';'
          {
              YYTRACE("parameter_declaration: YYPARAMETER assignment_list ';'");
	      $$ = vl_create_paramdecl(ParamDecl, $2);
          }
        ;

input_declaration
        : YYINPUT range_opt variable_list ';'
          {
              YYTRACE("input_declaration: YYINPUT range_opt variable_list ';'");
	      $$ = vl_create_rangedecl(InputDecl, $2, $3, 0);
          }
        ;

output_declaration
        : YYOUTPUT range_opt variable_list ';'
          {
              YYTRACE("output_declaration: YYOUTPUT range_opt variable_list ';'");
	      $$ = vl_create_rangedecl(OutputDecl, $2, $3, 0);
          }
        ;

inout_declaration
        : YYINOUT range_opt variable_list ';'
          {
              YYTRACE("inout_declaration: YYINOUT range_opt variable_list ';'");
	      $$ = vl_create_rangedecl(InoutDecl, $2, $3, 0);
          }
        ;

net_declaration
        : nettype drive_strength_opt expandrange_opt delay_opt 
            assignment_list ';'
          {
              YYTRACE("net_declaration: nettype drive_strength_opt expandrange_opt delay_opt assignment_list ';'");
	      $$ = vl_create_netdecl($1, $2, $3, $4, $5);
          }
        | nettype drive_strength_opt expandrange_opt delay_opt 
            variable_list ';'
          {
              YYTRACE("net_declaration: nettype drive_strength_opt expandrange_opt delay_opt variable_list ';'");
	      $$ = vl_create_netdecl($1, $2, $3, $4, $5);
          }
        | YYTRIREG charge_strength_opt expandrange_opt delay_opt 
            variable_list ';'
          {
              YYTRACE("net_declaration: YYTRIREG charge_strength_opt expandrange_opt delay_opt variable_list ';'");
	      $$ = vl_create_netdecl(TriregDecl, $2, $3, $4, $5);
          }
        ;

nettype
        : YYSWIRE
          {
              YYTRACE("nettype: YYSWIRE");
	      $$ = SWireDecl;
          }
        | YYWIRE
          {
              YYTRACE("nettype: YYWIRE");
	      $$ = WireDecl;
          }
        | YYTRI
          {
              YYTRACE("nettype: YYTRI");
	      $$ = TriDecl;
          }
        | YYTRI1
          {
              YYTRACE("nettype: YYTRI1");
	      $$ = Tri1Decl;
          }
        | YYSUPPLY0
          {
              YYTRACE("nettype: YYSUPPLY0");
	      $$ = Supply0Decl;
          }
        | YYWAND
	  {
              YYTRACE("nettype: YYWAND");
	      $$ = WandDecl;
	  }
        | YYTRIAND
          {
	      YYTRACE("nettype: YYTRIAND");
	      $$ = TriandDecl;
	  }
        | YYTRI0
          {
	      YYTRACE("nettype: YYTRI0");
	      $$ = Tri0Decl;
	  }
        | YYSUPPLY1
          {
	      YYTRACE("nettype: YYSUPPLY1");
	      $$ = Supply1Decl;
	  } 
        | YYWOR
          {
	      YYTRACE("nettype: YYWOR");
	      $$ = WorDecl;
          }
        | YYTRIOR
          {
              YYTRACE("nettype: YYTRIOR");
	      $$ = TriorDecl;
          }
        ;

/*
 * it's still not clear difference between <range>, SCALAREd <range>, and
 * VECTORED <range>. All of them are treated as <range> now. 10/8/92
 */
expandrange_opt
        :
          {
              YYTRACE("expandrange_opt:");
	      $$ = NIL(vl_range);
          }
        | expandrange
          {
              YYTRACE("expandrange_opt: expandrange");
	      $$ = $1;
          }
        ;

expandrange
        : range
          {
              YYTRACE("expandrange: range");
          }
        | YYSCALARED range
          {
              YYTRACE("expandrange: YYSCALARED range");
	      $$ = $2;
          }
        | YYVECTORED range
          {
              YYTRACE("expandrange: YYVECTORED range");
	      $$ = $2;
          }
        ;

reg_declaration
        : YYREG range_opt register_variable_list ';'
          {
              YYTRACE("reg_declaration: YYREG range_opt register_variable_list ';'");
	      $$ = vl_create_rangedecl(RegDecl, $2, $3, 0);
          }
        | YYMREG range_opt register_variable_list ';'
          {
              YYTRACE("reg_declaration: YYMREG range_opt register_variable_list ';'");
	      $$ = vl_create_rangedecl(RegDecl, $2, $3, MVar);
          }
        ;

time_declaration
        : YYTIME register_variable_list ';'
          {
              YYTRACE("time_declaration: YYTIME register_variable_list ';'");
	      $$ = vl_create_basicdecl(TimeDecl, $2);
          }
        ;

integer_declaration
        : YYINTEGER register_variable_list ';'
          {
              YYTRACE("integer_declaration: YYINTEGER register_variable_list ';'");
	      $$ = vl_create_basicdecl(IntDecl, $2);
          }
        ;

real_declaration
        : YYREAL variable_list ';'
          {
              YYTRACE("real_declaration: YYREAL variable_list ';'");
	      $$ = vl_create_basicdecl(RealDecl, $2);
          }
        ;

event_declaration
        : YYEVENT name_of_event_list ';'
          {
              YYTRACE("event_declaration: YYEVENT name_of_event_list ';'");
	      $$ = vl_create_basicdecl(EventDecl, $2);
          }
        ;

continuous_assign
        : YYASSIGN drive_strength_opt delay_opt assignment_list ';'
          {
              YYTRACE("continuous_assign: YYASSIGN drive_strength_opt delay_opt assignment_list ';'");
	      $$ = vl_create_cont_assign_stmt($2, $3, $4);
          }
        ;

parameter_override
        : YYDEFPARAM assignment_list ';'
          {
              YYTRACE("parameter_override: YYDEFPARAM assign_list ';'");
	      $$ = vl_create_paramdecl(DefparamDecl, $2);
          }
        ;

variable_list
        : identifier
          {
	      lsHandle handle;

              YYTRACE("variable_list: identifier");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | variable_list ',' identifier
          {
	      lsHandle handle;

              YYTRACE("variable_list: variable_list ',' identifier");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

register_variable_list
        : register_variable
          {
	      lsHandle handle;

              YYTRACE("register_variable_list: register_variable");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | register_variable_list ',' register_variable
          {
	      lsHandle handle;

              YYTRACE("register_variable_list: register_variable_list ',' register_variable");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;
        
register_variable
        : name_of_register
          {
              YYTRACE("register_variable: name_of_register");
	      $$ = vl_create_id_range($1, NIL(vl_range));
          }
        | name_of_register '[' expression ':' expression ']'
          {
              YYTRACE("register_variable: name_of_register '[' expression ':' expression ']'");
	      $$ = vl_create_id_range($1, vl_create_range($3, $5));
          }
        ;

name_of_register
        : YYID
          {
              YYTRACE("name_of_register: YYID");
	      $$ = strdup(yyid);
          }
        ;

name_of_event_list
        : name_of_event
          {
	      lsHandle handle;

              YYTRACE("name_of_event_list: name_of_event");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | name_of_event_list ',' name_of_event
          {
	      lsHandle handle;

              YYTRACE("name_of_event_list: name_of_event_list ',' name_of_event");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

name_of_event
        : YYID
          {
              YYTRACE("name_of_event: YYID");
	      $$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
          }
        ;

charge_strength_opt
        :
          {
              YYTRACE("charge_strength_opt:");
	      $$ = 0;
          }
        | charge_strength
          {
              YYTRACE("charge_strength_opt: charge_strength");
          }
        ;

charge_strength
        : '(' YYSMALL ')'
          {
              YYTRACE("charge_strength: '(' YYSMALL ')'");
	      $$ = Small;
          }
        | '(' YYMEDIUM ')'
          {
              YYTRACE("charge_strength: '(' YYMEDIUM ')'");
	      $$ = Medium;
          }
        | '(' YYLARGE ')'
          {
              YYTRACE("charge_strength: '(' YYLARGE ')'");
	      $$ = Large;
          }
        ;

drive_strength_opt
        :
          {
              YYTRACE("drive_strength_opt:");
	      $$ = 0;
          }
        | drive_strength
          {
              YYTRACE("drive_strength_opt: drive_strength");
	      $$ = $1;
          }
        ;

drive_strength
        : '(' strength0 ',' strength1 ')'
          {
              YYTRACE("drive_strength: '(' strength0 ',' strength1 ')'");
	      $$ = drive_strength($2, $4);
          }
        | '(' strength1 ',' strength0 ')'
          {
              YYTRACE("drive_strength: '(' strength1 ',' strength0 ')'");
	      $$ = drive_strength($4, $2);
          }
        ;

strength0
        : YYSUPPLY0
          {
              YYTRACE("strength0: YYSUPPLY0");
	      $$ = YYSUPPLY0;
          }
        | YYSTRONG0
          {
              YYTRACE("strength0: YYSTRING0");
	      $$ = YYSTRONG0;
          }
        | YYPULL0
          {
              YYTRACE("strength0: YYPULL0");
	      $$ = YYPULL0;
          }
        | YYWEAK0
          {
              YYTRACE("strength0: YYWEAK0");
	      $$ = YYWEAK0;
          }
        | YYHIGHZ0
          {
              YYTRACE("strength0: YYHIGHZ0");
	      $$ = YYHIGHZ0;
          }
        ;

strength1
        : YYSUPPLY1
          {
              YYTRACE("strength1: YYSUPPLY1");
	      $$ = YYSUPPLY1;
          }
        | YYSTRONG1
          {
              YYTRACE("strength1: YYSTRONG1");
	      $$ = YYSTRONG1;
          }
        | YYPULL1
          {
              YYTRACE("strength1: YYPULL1");
	      $$ = YYPULL1;
          }
        | YYWEAK1
          {
              YYTRACE("strength1: YYWEAK1");
	      $$ = YYWEAK1;
          }
        | YYHIGHZ1
          {
              YYTRACE("strength1: YYHIGHZ1");
	      $$ = YYHIGHZ1;
          }
        ;

range_opt
        :
          {
              YYTRACE("range_opt:");
	      $$ = NIL(vl_range);
          }
        | range
          {
              YYTRACE("range_opt: range");
	      $$ = $1;
          }
        ;

range
        : '[' expression ':' expression ']'
          {
              YYTRACE("range: '[' expression ':' expression ']'");
	      $$ = vl_create_range($2, $4);
          }
        ;

assignment_list
        : assignment
          {
	      lsHandle handle;

              YYTRACE("assignment_list: assignment");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | assignment_list ',' assignment
          {
	      lsHandle handle;

              YYTRACE("assignment_list: assignment_list ',' assignment");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

/* F.3 Primitive Instances */

gate_instantiation
        : gatetype drive_delay_clr gate_instance_list ';'
          {
	      int strength=0;
	      vl_delay *delay=NIL(vl_delay);
	      int head, tail;

              YYTRACE("gate_instantiation: gatetype drive_delay_clr gate_instance_list ';'");

	      extract_delay_strength($2, &delay, &strength);
	      lsDestroy($2, NULL);

	      /* create gate_inst_list */
	      $$ = vl_create_gate_inst_list($1, strength, delay, $3);

	      insert_instances($3, $$);
          }
        ;

drive_delay_clr
        :
          {
              YYTRACE("drive_delay_clr:");
	      $$ = lsCreate();
          }
        | drive_delay_clr drive_delay
          {
	      lsHandle handle;

              YYTRACE("drive_delay_clr: drive_delay_clr drive_delay");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

drive_delay
        : drive_strength
          {
              YYTRACE("drive_delay: drive_strength");
	      $$ = $1 << 2;
          }
        | delay
          {
              YYTRACE("drive_delay: delay");
	      /* to save space and encode/decode effort */
              /* we use lsb as an indicator whether drive_delay */
	      /* is drive (lsb==0) or delay (lsb==1) */
	      $$ = (int)($1) | LEAST_SB;
          }
        ;

gatetype
        : YYAND
          {
	      YYTRACE("gatetype: YYAND");
	      $$ = AndGate;
	  }
        | YYNAND
          {
	      YYTRACE("gatetype: YYNAND");
	      $$ = NandGate;
	  }
        | YYOR
          {
	      YYTRACE("gatetype: YYOR");
	      $$ = OrGate;
	  }
        | YYNOR
          {
	      YYTRACE("gatetype: YYNOR");
	      $$ = NorGate;
	  }
        | YYXOR
          {
	      YYTRACE("gatetype: YYXOR");
	      $$ = XorGate;
	  }
        | YYXNOR
          {
	      YYTRACE("gatetype: YYXNOR");
	      $$ = XnorGate;
	  }
        | YYBUF
          {
	      YYTRACE("gatetype: YYBUF");
	      $$ = BufGate;
	  }
        | YYBUFIF0
          {
	      YYTRACE("gatetype: YYBIFIF0");
	      $$ = Bufif0Gate;
	  }
        | YYBUFIF1
          {
	      YYTRACE("gatetype: YYBIFIF1");
	      $$ = Bufif1Gate;
	  }
        | YYNOT
          {
	      YYTRACE("gatetype: YYNOT");
	      $$ = NotGate;
	  }
        | YYNOTIF0
          {
	      YYTRACE("gatetype: YYNOTIF0");
	      $$ = Notif0Gate;
	  }
        | YYNOTIF1
          {
	      YYTRACE("gatetype: YYNOTIF1");
	      $$ = Notif1Gate;
	  }
        | YYPULLDOWN
          {
	      YYTRACE("gatetype: YYPULLDOWN");
	      $$ = PulldownGate;
	  }
        | YYPULLUP
          {
	      YYTRACE("gatetype: YYPULLUP");
	      $$ = PullupGate;
	  }
        | YYNMOS
          {
	      YYTRACE("gatetype: YYNMOS");
	      $$ = NmosGate;
	  }
        | YYPMOS
          {
	      YYTRACE("gatetype: YYPMOS");
	      $$ = PmosGate;
	  }
        | YYRNMOS
          {
	      YYTRACE("gatetype: YYRNMOS");
	      $$ = RnmosGate;
	  }
        | YYRPMOS
          {
	      YYTRACE("gatetype: YYRPMOS");
	      $$ = RpmosGate;
	  }
        | YYCMOS
          {
	      YYTRACE("gatetype: YYCMOS");
	      $$ = CmosGate;
	  }
        | YYRCMOS
          {
	      YYTRACE("gatetype: YYRCMOS");
	      $$ = RcmosGate;
	  }
        | YYTRAN
          {
	      YYTRACE("gatetype: YYTRAN");
	      $$ = TranGate;
	  }
        | YYRTRAN
          {
	      YYTRACE("gatetype: YYRTRAN");
	      $$ = RtranGate;
	  }
        | YYTRANIF0
          {
	      YYTRACE("gatetype: YYTRANIF0");
	      $$ = Tranif0Gate;
	  }
        | YYRTRANIF0
          {
	      YYTRACE("gatetype: YYRTRANIF0");
	      $$ = Rtranif0Gate;
	  }
        | YYTRANIF1
          {
	      YYTRACE("gatetype: YYTRANIF1");
	      $$ = Tranif1Gate;
	  }
        | YYRTRANIF1
          {
	      YYTRACE("gatetype: YYRTRANIF1");
	      $$ = Rtranif1Gate;
	  }
        ;

gate_instance_list
        : gate_instance
          {
	      lsHandle handle;

              YYTRACE("gate_instance_list: gate_instance");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | gate_instance_list ',' gate_instance
          {
	      lsHandle handle;

              YYTRACE("gate_instance_list: gate_instance_list ',' gate_instance");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

gate_instance
        : '(' terminal_list ')'
          {
              YYTRACE("gate_instance: '(' terminal_list ')'");
	      $$ = vl_create_gate_inst(NIL(vl_id_range), $2);
          }
        | name_of_gate_instance '(' terminal_list ')'
          {
              YYTRACE("gate_instance: name_of_gate_instance '(' terminal_list ')'");
	      $$ = vl_create_gate_inst($1, $3);
          }
        ;

name_of_gate_instance
        : YYID
          {
              YYTRACE("name_of_gate_instance: YYID");
	      $$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
          }
        ;

terminal_list
        : terminal
          {
	      lsHandle handle;

              YYTRACE("terminal_list: terminal");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | terminal_list ',' terminal
          {
	      lsHandle handle;

              YYTRACE("terminal_list: terminal_list ',' terminal");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

terminal
        : expression
          {
              YYTRACE("terminal: expression");
          }
        ;

/* F.4 Module Instantiations */

module_or_primitive_instantiation
        : name_of_module_or_primitive module_or_primitive_option_clr
             module_or_primitive_instance_list ';'
          {
	      char *mod_prim;
	      int strength=0;
	      vl_delay *delay=NIL(vl_delay);

              YYTRACE("module_or_primitive_instantiation: name_of_module_or_primitive module_or_primitive_option_clr module_or_primitive_instance_list ';'");

	      extract_delay_strength($2, &delay, &strength);
	      lsDestroy($2, NULL);

	      /* find/create master mod/prim; create mod_prim_inst_list */
	      $$ = vl_add_find_mod_prim_instances($1, delay, strength, $3);

	      insert_instances($3, $$);
          }
        ;

name_of_module_or_primitive
        : YYID
          {
              YYTRACE("name_of_module_or_primitive: YYID");
	      $$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
          }
        ;

module_or_primitive_option_clr
        :
          {
              YYTRACE("module_or_primitive_option_clr:");
	      $$ = lsCreate();
          }
        | module_or_primitive_option_clr module_or_primitive_option
          {
	      lsHandle handle;

              YYTRACE("module_or_primitive_option_clr: module_or_primitive_option_clr module_or_primitive_option");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

module_or_primitive_option
        : drive_strength
          {
              YYTRACE("module_or_primitive_option:");
	      $$ = $1 << 2;
          }
        | delay_or_parameter_value_assignment
          {
              YYTRACE("module_or_primitive_option: delay");
	      /* same hack as <drive_delay> */
	      $$ = (int)($1) | LEAST_SB;
          }
        ;

delay_or_parameter_value_assignment
        : '#' YYINUMBER    /* delay */
          {
	      vl_expr *expr;

	      YYTRACE("delay_or_parameter_value_assignment: '#' YYINUMBER");
	      expr = vl_create_expr(IntExpr, atoi(yytext), (double)0.0,
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' YYRNUMBER    /* delay */
          {
	      vl_expr *expr;

	      YYTRACE("delay_or_parameter_value_assignment: '#' YYRNUMBER");
	      expr = vl_create_expr(IntExpr, 0, atof(yytext),
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' identifier   /* delay */
          {
	      vl_expr *expr;

	      YYTRACE("delay_or_parameter_value_assignment: '#' identifier");
	      expr = vl_create_expr(IDExpr, 0, (double)0.0,
				    $2, NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' '(' mintypmax_expression_list ')' /* delay | parameter_assign */
          {
	      YYTRACE("delay_or_parameter_value_assignment: '#' '(' mintypmax_expression_list ')'");
	      TODO("delay_or_parameter_value_assignment: '#' '(' mintypmax_expression_list ')'");
	      $$ = vl_create_delay(NIL(vl_expr), NIL(vl_expr), NIL(vl_expr));
	  }
        ;

module_or_primitive_instance_list
        : module_or_primitive_instance
          {
	      lsHandle handle;

              YYTRACE("module_or_primitive_instance_list: module_or_primitive_instance");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | module_or_primitive_instance_list ',' module_or_primitive_instance
          {
	      lsHandle handle;

              YYTRACE("module_or_primitive_instance_list: module_or_primitive_instance_list ',' module_or_primitive_instance");
	      lsNewEnd($1, $3,  &handle);
	      $$ = $1;
          }
        ;

/* terminal_list in primitive_instance ca be derived from 
 * module_connection -> module_port ->expression
 */
module_or_primitive_instance
        : '(' module_connection_list ')'
          {
              YYTRACE("module_or_primitive_instance: '(' module_connection_list ')'");
	      $$ = (typestructPtr)vl_create_mod_prim_inst(NIL(vl_id_range), $2);
          }
        | identifier '(' module_connection_list ')'
          {
              YYTRACE("module_or_primitive_instance: '(' module_connection_list ')'");
	      $$ = (typestructPtr)vl_create_mod_prim_inst($1, $3);
          }
        ;

module_connection_list
        : module_port_connection_list
          {
              YYTRACE("module_connection_list: module_port_connection_list");
          }
        | named_port_connection_list
          {
              YYTRACE("module_connection_list: named_port_connection_list");
          }
        ;

module_port_connection_list
        : module_port_connection
          {
	      lsHandle handle;

              YYTRACE("module_port_connection_list: module_port_connection");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | module_port_connection_list ',' module_port_connection
          {
	      lsHandle handle;

              YYTRACE("module_port_connection_list: module_port_connection_list ',' module_port_connection");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
          }
        ;

named_port_connection_list
        : named_port_connection
          {
	      lsHandle handle;

              YYTRACE("named_port_connection_list: named_port_connection");
	      $$ = lsCreate();
	      lsNewEnd($$, $<ival>1, &handle);
          }
        | named_port_connection_list ',' named_port_connection
          {
	      lsHandle handle;

              YYTRACE("named_port_connection_list: named_port_connection_list ',' name_port_connection");
	      lsNewEnd($1, $<ival>3, &handle);
	      $$ = $1;
          }
        ;

module_port_connection
        :
          {
              YYTRACE("module_port_connection:");
	      $$ = vl_create_port_connect(ModuleConnect, 
					  NIL(vl_id_range), NIL(vl_expr));
          }
        | expression
          {
              YYTRACE("module_port_connection: expression");
	      $$ = vl_create_port_connect(ModuleConnect, NIL(vl_id_range), $1);
          }
        ;

named_port_connection
        : '.' identifier '(' expression ')'
          {
              YYTRACE("named_port_connection: '.' identifier '(' expression ')'");
	      $$ = vl_create_port_connect(NamedConnect, $2, $4);
          }
        ;

/* F.5 Bahavioral Statements */

initial_statement
        : YYINITIAL statement
          {
              YYTRACE("initial_statement: YYINITIAL statement");
	      $$ = vl_create_procstmt(InitialStmt, $2);
          }
        ;

always_statement
        : YYALWAYS statement
          {
              YYTRACE("always_statement: YYALWAYS statement");
	      $$ = vl_create_procstmt(AlwaysStmt, $2);
          }
        ;

statement_opt
        :
          {
              YYTRACE("statement_opt:");
	      $$ = lsCreate();
          }
        | statement
          {
	      lsHandle handle;

              YYTRACE("statement_opt: statement");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        ;        

statement_clr
        :
          {
              YYTRACE("statement_clr:");
	      $$ = lsCreate();
          }
        | statement_clr statement
          {
	      lsHandle handle;

              YYTRACE("statement_clr: statement_clr statement");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

/*
 *      | YYIF '(' expression ')' statement_opt
 *      | YYIF '(' expression ')' statement_opt YYELSE statement_opt
 *
 * is changed, since it allows statements like:
 *
 *     if(...)else
 *     ...
 *
 * now, according to the grammar rule of C, I changed it, such that the only
 * valid form is:
 *
 *     if(...);else;
 *     ...
 *
 * instead just put a null statement there.
 *
 *---------
 *
 * stmt 
 *      : matched_stmt
 *      | unmatched_stmt
 *      ;
 *
 * matched_stmt 
 *      : YYIF '(' expr ')' matched_stmt YYELSE matched_stmt
 *      | other_stmt
 *      ;
 *
 * unmatched_stmt
 *      : YYIF '(' expr ')' stmt
 *      | YYIF '(' expr ')' matched_stmt YYELSE unmatched_stmt
 *      ;
 *
 * can solve the problem that the original <if> production rule is ambiguous, 
 * however, since yacc is LALR(1), this set of modified production rule can't 
 * solve the shift/reduce associated with if/else production rule. On the other
 * side, since the default action when yacc facing shift/reduce is to shift,
 * hence, we can keep the original production rule, and else will always be 
 * regarded as belonging to the nearest <if>.
 *
 *---------
 *
 *      | delay_control statement_opt
 *      | event_control stetement_opt
 *
 * can derive
 *        delay_control (null)
 *        event_control (null)
 * is changed, such that only 
 *        delay_control ';'
 *        event_control ';'
 * is meaningful
 *
 *---------
 *
 *      | YYWAIT '(' expression ')' statement_opt
 *
 * will generate 
 *
 *   wait
 *   ...
 *
 * is now change such that the only valid form is:
 *
 *   wait;
 *
 * instead put only a null statement there, it will vague where it is a null
 * statement or the statement is the beginning of next new statement. Hope you
 * understand what I mean.
 */
statement
        : ';' 
          {
              YYTRACE("statement: ';'");
	      $$ = NIL(typestruct);
          }
        | assignment ';'
          {
              YYTRACE("statement: assignment ';'");
          }
        | YYIF '(' expression ')' statement
          {
              YYTRACE("statement: YYIF '(' expression ')' statement");
	      $$ = (typestructPtr)vl_create_if_else_stmt($3, $5, NIL(typestruct));
          }
        | YYIF '(' expression ')' statement YYELSE statement
          {
              YYTRACE("statement: YYIF '(' expression ')' statement YYELSE statement");   
	      $$ = (typestructPtr)vl_create_if_else_stmt($3, $5, $7);
	  } 
        | YYCASE '(' expression ')' case_item_eclr YYENDCASE
          {
              YYTRACE("statement: YYCASE '(' expression ')' case_item_eclr YYENDCASE");
	      $$ = (typestructPtr)vl_create_case_stmt(CaseStmt, $3, $5);
          }
        | YYCASEZ '(' expression ')' case_item_eclr YYENDCASE
          {
              YYTRACE("statement: YYCASEZ '(' expression ')' case_item_eclr YYENDCASE"); 
	      $$ = (typestructPtr)vl_create_case_stmt(CasezStmt, $3, $5);
          }
        | YYCASEX '(' expression ')' case_item_eclr YYENDCASE
          {
              YYTRACE("statement: YYCASEX '(' expression ')' case_item_eclr YYENDCASE");
	      $$ = (typestructPtr)vl_create_case_stmt(CasexStmt, $3, $5);
          }
        | YYFOREVER statement
          {
              YYTRACE("statement: YYFOREVER statement");
	      $$ = (typestructPtr)vl_create_forever_stmt($2);
          }
        | YYREPEAT '(' expression ')' statement
          {
              YYTRACE("statement: YYREPEAT '(' expression ')' statement");
	      $$ = (typestructPtr)vl_create_repeat_stmt($3, $5);
          } 
        | YYWHILE '(' expression ')' statement
          {
              YYTRACE("statement: YYWHILE '(' expression ')' statement");
	      $$ = (typestructPtr)vl_create_while_stmt($3, $5);
          }
        | YYFOR '(' assignment ';' expression ';' assignment ')' statement
          {
              YYTRACE("statement: YYFOR '(' assignment ';' expression ';' assignment ')' statement");
	      $$ = (typestructPtr)vl_create_for_stmt($3, $5, $7, $9);
          }
        | delay_control statement
          {
              YYTRACE("statement: delay_control statement");
	      $$ = (typestructPtr)vl_create_delay_control_stmt($1, $2);
          }
        | event_control statement
          {
              YYTRACE("statement: event_control statement");
	      $$ = (typestructPtr)vl_create_event_control_stmt($1, $2);
          }
        | lvalue '=' delay_control expression ';'
          {
              YYTRACE("statement: lvalue '=' delay_control expression ';'");
	      $$ = (typestructPtr)vl_create_bassign_stmt(DelayBassignStmt, $1, $3, $4);
          }
        | lvalue '=' event_control expression ';'
          {
              YYTRACE("statement: lvalue '=' event_control expression ';'");
	      $$ = (typestructPtr)vl_create_bassign_stmt(EventBassignStmt, $1, $3, $4);
          }
        | lvalue YYNBASSIGN delay_control expression ';'
          {
              YYTRACE("statement: lvalue YYNBASSIGN delay_control expression ';'");
	      $$ = (typestructPtr)vl_create_bassign_stmt(DelayNbassignStmt, $1, $3, $4);
          }
        | lvalue YYNBASSIGN event_control expression ';'
          {
              YYTRACE("statement: lvalue YYNBASSIGN event_control expression ';'");
	      $$ = (typestructPtr)vl_create_bassign_stmt(EventNbassignStmt, $1, $3, $4);
          }
        | YYWAIT '(' expression ')' statement
          {
              YYTRACE("statement: YYWAIT '(' expression ')' statement");
	      $$ = (typestructPtr)vl_create_wait_stmt($3, $5);
          }
        | YYRIGHTARROW name_of_event ';'
          {
              YYTRACE("statement: YYRIGHTARROW name_of_event ';'");
	      $$ = (typestructPtr)vl_create_send_event_stmt($2);
          }
        | seq_block
          {
              YYTRACE("statement: seq_block");
          }
        | par_block
          {
              YYTRACE("statement: par_block");
          }
        | task_enable
          {
              YYTRACE("statement: task_enable");
          }
        | system_task_enable
          {
              YYTRACE("statement: system_task_enable");
	      TODO("statement: system_task_enable");
	      $$ = NIL(typestruct);
          }
        | YYDISABLE YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
          ';'  /* name of task or block */
          {
              YYTRACE("statement: YYDISABLE YYID ';'");
	      $$ = (typestructPtr)vl_create_disable_stmt($<idrng>3);
          }
        | YYASSIGN assignment ';'
          {
              YYTRACE("statement: YYASSIGN assignment ';'");
	      $2->type = AssignStmt;
	      $$ = (typestructPtr)$2;
          }
        | YYDEASSIGN lvalue ';'
          {
              YYTRACE("statement: YYDEASSIGN lvalue ';'");
	      $$ = (typestructPtr)vl_create_deassign_stmt($2);
          }
        ;

assignment
        : lvalue '=' expression
          {
              YYTRACE("assignment: lvalue '=' expression");
	      $$ = vl_create_bassign_stmt(BassignStmt, $1, NIL(void), $3);
          }
        | lvalue YYNBASSIGN expression
          {
              YYTRACE("assignment: lvalue YYNBASSIGN expression");
	      $$ = vl_create_bassign_stmt(NbassignStmt, $1, NIL(void), $3);
          }
        ;

case_item_eclr
        : case_item
          {
	      lsHandle handle;

              YYTRACE("case_item_eclr: case_item");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
          }
        | case_item_eclr case_item
          {
	      lsHandle handle;

              YYTRACE("case_item_eclr: case_item_eclr case_item");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;
/*
 * case_item
 *        : expression_list ':' statement_opt
 *        | YYDEFAULT ':' statement_opt
 *        | YYDEFAULT statement_opt
 *        ;
 *
 * instead of allowing case item to generate null statement in the form (null),
 * null statement is now taking the form (null);
 */
case_item
        : expression_list ':' statement
          {
              YYTRACE("case_item: expression_list ':' statement");
	      $$ = vl_create_case_item(CaseItem, $1, $3);
          }
        | YYDEFAULT ':' statement
          {
              YYTRACE("case_item: YYDEFAULT ':' statement");
	      $$ = vl_create_case_item(DefaultItem, LS_NH, $3);
          }
        | YYDEFAULT statement
          {
              YYTRACE("case_item: YYDEFAULT statement");
	      $$ = vl_create_case_item(DefaultItem, LS_NH, $2);
          }
        ;

seq_block
        : YYBEGIN statement_clr YYEND
          {
              YYTRACE("seq_block: YYBEGIN statement_clr YYEND");
	      $$ = vl_create_begin_end_stmt(NIL(vl_id_range), LS_NH, $2);
          }
        | YYBEGIN ':' name_of_block block_declaration_clr statement_clr YYEND
          {
              YYTRACE("seq_block: YYBEGIN ':' name_of_block block_declaration_clr statement_clr YYEND");
	      $$ = vl_create_begin_end_stmt($3, $4, $5);
          }
        ;

par_block
        : YYFORK statement_clr YYJOIN
          {
              YYTRACE("par_block: YYFORK statement_clr YYJOIN");
	      $$ = vl_create_fork_join_stmt(NIL(vl_id_range), LS_NH, $2);
          }
        | YYFORK ':' name_of_block block_declaration_clr statement_clr YYJOIN
          {
              YYTRACE("par_block: YYFORK ':' name_of_block block_declaration_clr statement_clr YYJOIN");
	      $$ = vl_create_fork_join_stmt($3, $4, $5);
          }
        ;

name_of_block
        : YYID
          {
              YYTRACE("name_of_block: YYID");
	      $$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
          }
        ;

block_declaration_clr
        :
          {
              YYTRACE("block_declaration_clr:");
	      $$ = lsCreate();
          }
        | block_declaration_clr block_declaration
          {
	      lsHandle handle;

              YYTRACE("block_declaration_clr: block_declaration_clr block_declaration");
	      lsNewEnd($1, $2, &handle);
	      $$ = $1;
          }
        ;

block_declaration
        : parameter_declaration
          {
              YYTRACE("block_declaration: parameter_declaration");
              $$ = (typestructPtr)$1;
          }
        | reg_declaration
          {
              YYTRACE("block_declaration: reg_declaration");
              $$ = (typestructPtr)$1;
          }
        | integer_declaration
          {
              YYTRACE("block_declaration: integer_declaration");
              $$ = (typestructPtr)$1;
          }
        | real_declaration
          {
              YYTRACE("block_declaration: real_declaration");
              $$ = (typestructPtr)$1;
          }
        | time_declaration
          {
              YYTRACE("block_delcaration: time_declaration");
              $$ = (typestructPtr)$1;
          }
        | event_declaration
          {
              YYTRACE("block_declaration: event_declaration");
              $$ = (typestructPtr)$1;
          }
        ;

/* YYID is the name of a task */
task_enable
        : YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
          ';'
          {
              YYTRACE("task_enable: YYID ';'");
	      vl_create_task_enable_stmt(TaskEnableStmt, $<idrng>2, NIL(vl_expr));
          }
        | YYID 
          {
	      $<idrng>$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
	  }
         '(' expression_list ')' ';'
          {
              YYTRACE("task_enable: YYID '(' expression_list ')' ';'");
	      vl_create_task_enable_stmt(TaskEnableStmt, $<idrng>2, $4);
          }
        ;

system_task_enable
        : name_of_system_task ';'
          {
              YYTRACE("system_task_enable: name_of_system_task ';'");
          }
        | name_of_system_task '(' expression_list ')'
          {
              YYTRACE("system_task_enable: name_of_system_task '(' expression_list ')'");
          }
        ;

name_of_system_task
        : system_identifier
          {
              YYTRACE("name_of_system_task: system_identifier");
          }
        ;

/* F.6 Specify section */

specify_block
        : YYSPECIFY specify_item_clr YYENDSPECIFY
          {
              YYTRACE("specify_block: YYSPECIFY specify_item_clr YYENDSPECIFY");
	      TODO("specify_block: YYSPECIFY specify_item_clr YYENDSPECIFY");
          } 
        ;

specify_item_clr
        :
        | specify_item_clr specify_item
        ;

specify_item
        : specparam_declaration
        | path_declaration
        | level_sensitive_path_declaration
        | edge_sensitive_path_declaration
        | system_timing_check
        ;

specparam_declaration
        : YYSPECPARAM assignment_list ';'
        ;

path_declaration
        : path_description '=' path_delay_value ';'
        ;

/*
 * in the 2nd rule, path_description : ( path_list *> path_list_or_edge_sen... )
 *
 * unless you are using a LALR(2) parser, you can't make sure whether you are
 * facing path_description or edge_sensitive_path_description:
 *
 * path_description : ( path_list *> path_list)
 * edge_sensitive_path_description : ( specify_terminal_descriptor *> 
 *                                     ( path_list polarity ?: expression ))
 *
 * so we have to combine the parts after *> to form a new rule, and it makes the
 * rule grouping ugly.
 */ 
                                         
path_description
        : '(' specify_terminal_descriptor YYLEADTO specify_terminal_descriptor ')'
        | '(' path_list YYALLPATH path_list_or_edge_sensitive_path_list ')'
        ;

path_list
        : specify_terminal_descriptor
        | path_list ',' specify_terminal_descriptor
        ;

specify_terminal_descriptor
        : YYID
        | YYID '[' expression ']'
        | YYID '[' expression ';' expression ']'
        ;

path_list_or_edge_sensitive_path_list
        : path_list
        | '(' path_list ',' specify_terminal_descriptor
              polarity_operator YYCONDITIONAL 
              expression ')'
        ;

path_delay_value
        : path_delay_expression
        | '(' path_delay_expression ',' path_delay_expression ')'
        | '(' path_delay_expression ',' path_delay_expression ',' 
              path_delay_expression ')'
        | '(' path_delay_expression ',' path_delay_expression ','
              path_delay_expression ',' path_delay_expression ','
              path_delay_expression ',' path_delay_expression ')'
        ;

path_delay_expression
        : expression
        ;

/* grammar rules for system timing check hasn't been done yet, includes:
 *  <system_timing_check>
 *  <timign_check_event>
 *  <controlled_timing_check_event>
 *  <timing_check_event_control>
 *  <timing_check_condidtion>
 *  <SCALAR_EXPRESSION>
 *  <timing_check_limit>
 *  <scalar_constant>
 *  <notify_register>
 *  in page 211. 
*/

system_timing_check
        : YYsysSETUP '(' ')' ';'

/*
 * level_sensitive_path_declaration, edge_sensititve_path_declaration
 *
 * both in the form:
 *
 *  if () ...
 *    ... = path_delay_value     <- expression
 *
 * this is ambiguous in the context that we are facing specify_item_clr
 * hence, a delimiter ';' is added at the end of the statement of seperate them.
 *
 *--------
 *
 * In the 1st rule, 
 *   level_sensitive_path_declaration : if ( exp ) 
 *                                        ( path_list , specify polar => spec_...
 *
 * unless you are using a LALR(2) parser, no way to distinguish the two rules:
 *
 * level_sen*path*declaration : if ( exp ) ( spe*t*des polar*_opt => spe*t*des )
 *                                           path_l* = path_delay* ;
 * edge_sen*path*declaration : if ( exp ) ( spe*t*des => ( spec*t*des pol* ?: 
 *                                          exp ) ) = path_delay* ;
 *
 * when we are facing =>, the difference in the remaining parts after => makes
 * the new rule spec_terminal_desptr_or_edge_sensitive_spec_terminal_desptr even
 * uglier.
 */

level_sensitive_path_declaration
        : YYIF '(' expression ')'
            '(' specify_terminal_descriptor polarity_operator_opt YYLEADTO
                spec_terminal_desptr_or_edge_sensitive_spec_terminal_desptr
        | YYIF '(' expression ')'
            '(' path_list ',' specify_terminal_descriptor 
                polarity_operator_opt YYALLPATH path_list ')'
                path_list '=' path_delay_value ';'
        ;

spec_terminal_desptr_or_edge_sensitive_spec_terminal_desptr
        : specify_terminal_descriptor ')' path_list '=' path_delay_value ';'
        | '(' specify_terminal_descriptor polarity_operator YYCONDITIONAL
              expression ')' ')' '=' path_delay_value ';'


polarity_operator_opt
        :
        | polarity_operator
        ;

polarity_operator
        : '+'
        | '-'
        ;

edge_sensitive_path_declaration
        : '(' specify_terminal_descriptor YYLEADTO
            '(' specify_terminal_descriptor polarity_operator YYCONDITIONAL
                expression ')' ')' '=' path_delay_value ';'
        | '(' edge_identifier specify_terminal_descriptor YYLEADTO
            '(' specify_terminal_descriptor polarity_operator YYCONDITIONAL
                expression ')' ')' '=' path_delay_value ';'
        | '(' edge_identifier specify_terminal_descriptor YYALLPATH
            '(' path_list ',' specify_terminal_descriptor
                polarity_operator YYCONDITIONAL 
                expression ')' ')' '=' path_delay_value ';'
        | YYIF '(' expression ')'
            '(' specify_terminal_descriptor YYALLPATH
              '(' path_list ',' specify_terminal_descriptor
                  polarity_operator YYCONDITIONAL 
                  expression ')' ')' '=' path_delay_value ';'
        | YYIF '(' expression ')'
            '(' edge_identifier specify_terminal_descriptor YYLEADTO
              '(' specify_terminal_descriptor polarity_operator YYCONDITIONAL
                  expression ')' ')' '=' path_delay_value ';'
        | YYIF '(' expression ')'
            '(' edge_identifier specify_terminal_descriptor YYALLPATH
              '(' path_list ',' specify_terminal_descriptor
                  polarity_operator YYCONDITIONAL 
                  expression ')' ')' '=' path_delay_value ';'
        ;

edge_identifier
        : YYPOSEDGE
        | YYNEGEDGE
        ;

/* F.7 Expressions */

lvalue
        : identifier
          {
	      YYTRACE("lvalue: YYID");
	      $$ = vl_create_lval(IDExpr, $1,
				  NIL(vl_range), NIL(vl_expr));
	  }
        | identifier '[' expression ']'
          {
	      YYTRACE("lvalue: YYID '[' expression ']'");
	      $$ = vl_create_lval(BitSelExpr, $1, 
				  vl_create_range($3, NIL(vl_expr)), 
				  NIL(vl_expr));
	  }
        | identifier '[' expression ':' expression ']'
          {
	      YYTRACE("lvalue: YYID'[' expression ':' expression ']'");
	      $$ = vl_create_lval(PartSelExpr, $1, 
				  vl_create_range($3, $5), NIL(vl_expr));
	  }
        | concatenation
          {
	      YYTRACE("lvalue: concatenation");
	      $$ = vl_create_lval(ConcatExpr, NIL(vl_id_range), NIL(vl_range), $1);
	  }
        ;

mintypmax_expression_list
        : mintypmax_expression
          {
	      lsHandle handle;

	      YYTRACE("mintypmax_expression_list: mintypmax_expression");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
	  }
        | mintypmax_expression_list ',' mintypmax_expression
          {
	      lsHandle handle;

	      YYTRACE("mintypmax_expression_list: mintypmax_expression_list ',' mintypmax_expression");
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
	  }
        ;

mintypmax_expression
        : expression
          {
	      YYTRACE("mintypmax_expression: expression");
	      $$ = vl_create_expr(MinTypMaxExpr, 0, (double)0.0, 
				  $1, NIL(vl_expr), NIL(vl_expr));
	  }
        | expression ':' expression ':' expression
          {
	      YYTRACE("mintypmax_expression: expression ':' expression ':' expression");
	      $$ = vl_create_expr(MinTypMaxExpr, 0, (double)0.0, 
				  $1, $3, $5);
	  }
        ;

expression_list
        : expression
          {
	      lsHandle handle;

	      YYTRACE("expression_list: expression");
	      $$ = lsCreate();
	      lsNewEnd($$, $1, &handle);
	  }
        | expression_list ',' expression
          {
	      lsHandle handle;

	      YYTRACE("expression_list: expression_list ',' expression");
	      $$ = lsCreate();
	      lsNewEnd($1, $3, &handle);
	      $$ = $1;
	  }
        ;

expression
        : primary
          {
	      YYTRACE("expression: primary");
	  }
        | '+' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '+' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UplusExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  } 
        | '-' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '-' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UminusExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));

	  }
        | '!' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '!' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UnotExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));

	  }
        | '~' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '~' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UcomplExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | '&' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '&' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UandExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | '|' primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: '|' primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UorExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | YYLOGNAND primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: YYLOGNAND primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UnorExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | YYLOGNOR primary %prec YYUNARYOPERATOR
          {
              YYTRACE("expression: YYLOGNOR primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UnorExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | YYLOGXNOR primary %prec YYUNARYOPERATOR
          {
	      YYTRACE("expression: YYLOGXNOR primary %prec YYUNARYOPERATOR");
	      $$ = vl_create_expr(UxnorExpr, 0, (double)0.0,
				  $2, NIL(vl_expr), NIL(vl_expr));
	  }
        | expression '+' expression
          {
	      YYTRACE("expression: expression '+' expression");
	      $$ = vl_create_expr(BplusExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '-' expression
          {
	      YYTRACE("expression: expressio '-' expression");
	      $$ = vl_create_expr(BminusExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '*' expression
          {
	      YYTRACE("expression: expression '*' expression");
	      $$ = vl_create_expr(BtimesExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '/' expression
          {
	      YYTRACE("expression: expression '/' expression");
	      $$ = vl_create_expr(BdivExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '%' expression
          {
	      YYTRACE("expression: expression '%' expression");
	      $$ = vl_create_expr(BremExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLOGEQUALITY expression
          {
	      YYTRACE("expression: expression YYLOgEQUALITY expression");
	      $$ = vl_create_expr(Beq2Expr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLOGINEQUALITY expression
          {
	      YYTRACE("expression: expression YYLOGINEQUALITY expression");
	      $$ = vl_create_expr(Bneq2Expr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYCASEEQUALITY expression
          {
	      YYTRACE("expression: expression YYCASEEQUALITY expression");
	      $$ = vl_create_expr(Beq3Expr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYCASEINEQUALITY expression
          {
	      YYTRACE("expression: expression YYCASEINEQUALITY expression");
	      $$ = vl_create_expr(Bneq3Expr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLOGAND expression
          {
	      YYTRACE("expression: expression YYLOGAND expression");
	      $$ = vl_create_expr(BlandExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLOGOR expression
          {
	      YYTRACE("expression: expression YYLOGOR expression");
	      $$ = vl_create_expr(BlorExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '<' expression
          {
	      YYTRACE("expression: expression '<' expression");
	      $$ = vl_create_expr(BltExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '>' expression
          {
	      YYTRACE("expression: expression '>' expression");
	      $$ = vl_create_expr(BgtExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '&' expression
          {
	      YYTRACE("expression: expression '&' expression");
	      $$ = vl_create_expr(BandExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '|' expression
          {
	      YYTRACE("expression: expression '|' expression");
	      $$ = vl_create_expr(BorExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '^' expression
          {
	      YYTRACE("expression: expression '^' expression");
	      $$ = vl_create_expr(BxorExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLEQ expression
          {
	      YYTRACE("expression: expression YYLEQ expression");
	      $$ = vl_create_expr(BleExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYNBASSIGN expression
          {
	      YYTRACE("expression: expression YYLEQ expression");
	      $$ = vl_create_expr(BleExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYGEQ expression
          {
	      YYTRACE("expression: expression YYGEQ expression");
	      $$ = vl_create_expr(BgeExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLSHIFT expression
          {
	      YYTRACE("expression: expression YYLSHIFT expression");
	      $$ = vl_create_expr(BlshiftExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYRSHIFT expression
          {
	      YYTRACE("expression: expression YYRSHIFT expression");
	      $$ = vl_create_expr(BrshiftExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYLOGXNOR expression
          {
	      YYTRACE("expression: expression YYLOGXNOR expression");
	      $$ = vl_create_expr(BxnorExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression '?' expression ':' expression
          {
	      YYTRACE("expression: expression '?' expression ':' expression");
	      $$ = vl_create_expr(TcondExpr, 0, (double)0.0,
				  $1, $3, $5);
	  }
        | YYSTRING
          {
	      YYTRACE("expression: YYSTRING");
	      $$ = vl_create_expr(StringExpr, 0, (double)0.0,
				  strdup(yytext), NIL(vl_expr), NIL(vl_expr));
	  }
        ;

primary
        : YYINUMBER
          {
	      YYTRACE("primary: YYINUMBER");
              if (strchr(yytext, '\'')) {
		  $$ = vl_create_expr(BitExpr, 0, (double)0.0,
				      bexp1, bexp0, strdup(brep));
	      } else {
		  $$ = vl_create_expr(IntExpr, atoi(yytext), (double)0.0,
				      NIL(vl_expr), NIL(vl_expr), NIL(vl_expr));
	      }
	  }
        | YYRNUMBER
          {
	      YYTRACE("primary: YYRNUMBER");
	      $$ = vl_create_expr(RealExpr, 0, atof(yytext),
				  NIL(vl_expr), NIL(vl_expr), NIL(vl_expr));
	  }
        | identifier
          {
	      YYTRACE("primary: identifier");
	      $$ = vl_create_expr(IDExpr, 0, (double)0.0,
				  $1, NIL(vl_expr), NIL(vl_expr));
	  }
        | identifier '[' expression ']'
          {
	      YYTRACE("primary: identifier '[' expression ']'");
	      $$ = vl_create_expr(BitSelExpr, 0, (double)0.0,
				  vl_create_id_range($1->name, 
				    vl_create_range($3, NIL(vl_expr))), 
				  NIL(vl_expr), NIL(vl_expr));
	  }
        | identifier '[' expression ':'  expression ']'
          {
	      YYTRACE("primary: identifier '[' expression ':' expression ']'");
	      $$ = vl_create_expr(BitSelExpr, 0, (double)0.0,
				  vl_create_id_range($1->name, 
				    vl_create_range($3, $5)), 
				  NIL(vl_expr), NIL(vl_expr));
	  }
        | concatenation
          {
	      YYTRACE("primary: concatenation");
	      $$ = vl_create_expr(ConcatExpr, 0, (double)0.0,
				  $1, NIL(vl_expr), NIL(vl_expr));
	  }
        | multiple_concatenation
	  {
	      YYTRACE("primary: multiple_concatenatin");
	      TODO("primary: multiple_concatenatin");
	      $$ = vl_create_expr(ConcatExpr, 0, (double)0.0,
				  $1, NIL(vl_expr), NIL(vl_expr));
	  }
        | function_call
          {
	      YYTRACE("primary: function_call");
	  }
        | '(' mintypmax_expression ')'
          {
	      YYTRACE("primary: '(' mintypmax_expression ')'");
	      $$ = $2;
	  }
        ;

/*
 * number : decimal_number
 *        | unsigned number? base number
 *        | real_number
 *        ;
 *
 * is put in lex rules
 */

concatenation
        : '{' expression_list '}'
          {
	      YYTRACE("concatenation: '{' expression_list '}'");
	      $$ = $2;
	  }
        ;

multiple_concatenation
        : '{' expression '{' expression_list '}' '}'
	    {
		YYTRACE("multiple_concatenation: '{' expression '{' expression_list '}' '}'");
		TODO("multiple_concatenation: '{' expression '{' expression_list '}' '}'");
		$$ = $4;
	    }
        ;

function_call
        : identifier '(' expression_list ')'
          {
	      YYTRACE("function_call: identifier '(' expression_list ')'");
	      $$ = vl_create_expr(FuncExpr, 0, (double)0.0,
				  $1, $3);
	  }
/*
 *      | system_function_call
 *
 * is not implemented, it will cause a r/r error, you have to implement that
 * using semantic routine.
 */
        ;

system_identifier
        : YYsysID
        ;

/* F.8 General */

identifier
        : YYID
          {
              YYTRACE("identifier: YYID");
	      $$ = vl_create_id_range(strdup(yyid), NIL(vl_range));
          }
        | identifier '.' YYID
          {
              YYTRACE("identifier: identifier '.' YYID");
              TODO("identifier: identifier '.' YYID");
          }
        ;

delay_opt
        :
          {
	      YYTRACE("delay_opt:");
	      $$ = NIL(vl_delay);
	  }
        | delay
          {
	      YYTRACE("delay_opt: delay");
	  }
        ;

delay
        : '#' YYINUMBER
          {
	      vl_expr *expr;

	      YYTRACE("delay: '#' YYINUMBER");
	      expr = vl_create_expr(IntExpr, atoi(yytext), (double)0.0,
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' YYRNUMBER
          {
	      vl_expr *expr;

	      YYTRACE("delay: '#' YYRNUMBER");
	      expr = vl_create_expr(IntExpr, 0, atof(yytext),
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }  
        | '#' identifier
          {
	      vl_expr *expr;

	      YYTRACE("delay: '#' identifier");
	      expr = vl_create_expr(IDExpr, 0, (double)0.0,
				    $2, NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' '(' mintypmax_expression ')'
          {
	      YYTRACE("delay: '#' '(' mintypmax_expression ')'");
	      $$ = vl_create_delay($3, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' '(' mintypmax_expression ',' mintypmax_expression ')'
          {
	      YYTRACE("delay: '#' '(' mintypmax_expression ',' mintypmax_expression ')'");
	      $$ = vl_create_delay($3, $5, NIL(vl_expr));
	  }
        | '#' '(' mintypmax_expression ',' mintypmax_expression ',' 
                  mintypmax_expression ')'
          {
	      YYTRACE("delay: '#' '(' mintypmax_expression ',' mintypmax_expression ',' mintypmax_expression ')'");
	      $$ = vl_create_delay($3, $5, $7);
	  }
        ;

delay_control
        : '#' YYINUMBER
          {
	      vl_expr *expr;

	      YYTRACE("delay_control: '#' YYINUMBER");
	      expr = vl_create_expr(IntExpr, atoi(yytext), (double)0.0,
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' YYRNUMBER
          {
	      vl_expr *expr;

	      YYTRACE("delay_control: '#' YYRNUMBER");
	      expr = vl_create_expr(IntExpr, 0, atof(yytext),
				    NIL(void), NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }  
        | '#' identifier
          {
	      vl_expr *expr;

	      YYTRACE("delay_control: '#' identifier");
	      expr = vl_create_expr(IDExpr, 0, (double)0.0,
				    $2, NIL(void), NIL(void));
	      $$ = vl_create_delay(expr, NIL(vl_expr), NIL(vl_expr));
	  }
        | '#' '(' mintypmax_expression ')'
          {
	      YYTRACE("delay_control: '#' '(' mintypmax_expression ')'");
	      $$ = vl_create_delay($3, NIL(vl_expr), NIL(vl_expr));
	  }
        ;

event_control
        : '@' identifier
          {
	      vl_exprPtr expr;

	      YYTRACE("event_control: '@' identifier");
	      expr = vl_create_expr(IDExpr, 0, (double)0.0,
				    $2, NIL(vl_expr), NIL(vl_expr));
	      $$ = vl_create_event_expr(EventExpr, expr);
	  }
        | '@' '(' event_expression ')'
          {
	      YYTRACE("event_control: '@' '(' event_expression ')'");
	      $$ = $3;
	  }
        | '@' '(' ored_event_expression ')'
          {
	      YYTRACE("event_control: '@' '(' ored_event_expression ')'");
	      $$ = $3;
	  }
        ;

/*
 * event_expression: event_expression YYOR event_expression 
 *
 * is replaced with
 *
 * event_expression: event_expression YYOR expression
 */
event_expression
        : expression
          {
	      YYTRACE("event_expression: expression");
	      $$ = vl_create_event_expr(EventExpr, $1);
	  }
        | YYPOSEDGE expression
          {
	      YYTRACE("event_expression: YYPOSEDGE expression");
	      $$ = vl_create_event_expr(PosedgeEventExpr, $2);
	  }
        | YYNEGEDGE expression
          {
	      YYTRACE("event_expression: YYNEGEDGE expression");
	      $$ = vl_create_event_expr(NegedgeEventExpr, $2);
	  }
	| YYEDGE expression
	  {
	      YYTRACE("event_expression: YYEDGE expression");
	      $$ = vl_create_event_expr(EdgeEventExpr, $2);
          }
        ;

ored_event_expression
        : event_expression YYOR event_expression
          {
	      lsList event_list;
	      YYTRACE("ored_event_expression: event_expression YYOR event_expression");
	      event_list = lsCreate();
	      lsNewEnd(event_list, $1, LS_NH);
	      lsNewEnd(event_list, $3, LS_NH);
	      $$ = vl_create_event_expr(OrEventExpr, NIL(vl_expr));
	      $$->list = event_list;
	  }
        | ored_event_expression YYOR event_expression
          {
	      YYTRACE("ored_event_expression: ored_event_expression YYOR event_expression");
	      lsNewEnd($1->list, $3, LS_NH);
	      $$ = $1;
	  }
        ; 

%%

void yyerror(str)
char *str;
{
    fprintf(stderr, "%s : (%d) token :%s\n", str, yylineno, yytext);
    exit (1);
}

void extract_delay_strength(delay_strength, delay, strength)
lsList delay_strength;
vl_delay **delay;
int *strength;
{
    int head, tail;

    switch (lsLength(delay_strength)) {
    case 0: break;
    case 1: 
	lsFirstItem(delay_strength, &head, 0);
	if (head & LEAST_SB)
	    *delay = (vl_delay*)(head & (~LEAST_SB));
	else
	    *strength = (head >> 2);
	break;
    case 2: 
	lsFirstItem(delay_strength, &head, 0);
	lsLastItem(delay_strength, &tail, 0);
	if (head & LEAST_SB || !(tail & LEAST_SB))
	    compile_error("mod/prim/gate illegal drive_strength | delay");
	*strength = (head >> 2);
	*delay = (vl_delay*)(tail & (~LEAST_SB));
	break;
    default: compile_error("too many drive_strength | delay");
    }
}
ate_expr(BleExpr, 0, (double)0.0,
				  $1, $3, NIL(vl_expr));
	  }
        | expression YYNBASSIGN expression
   vl2mv/src/parser/vl_create.c                                                                        100644  027004  000214  00000073223 05332024423 013271  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
   $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/vl_create.c,v 1.3 1993/01/15 19:41:18 stcheng Exp stcheng $

   vl_create.c: Routines to create cell types for Verilog to BLIF-MV
   parser.
   GY  9/92
*/

#include <stdlib.h>
#include "util.h"
#include "list.h"
#include "st.h"
#include "vl_types.h"
#include "vl_defs.h"
#include "vlr_int.h"
#include "vl_create.h"

vl_descPtr mod_list;		/* list of all the modules and primitives */
static CreTrace = 0;

vl_desc *vl_create_desc(filename)
char *filename;
{
    vl_descPtr desc;

    CreTRACE("Creating Description\n");
    desc = (vl_descPtr)chk_malloc(sizeof(vl_desc));
    desc->filename = filename;
    desc->modules = lsCreate();
    desc->mp_st = st_init_table(strcmp, st_strhash);
    desc->decl_st = st_init_table(declcmp, declhash);
    desc->handle = (lsHandle)0;
    return desc;
}

vl_module *vl_create_module(mod_name, ports, mod_items)
    vl_id_range *mod_name;
    lsList ports;
    lsList mod_items;
{
    vl_module *mod;
    vl_module *clash_module;	/* if module name is same as previous */
    vl_id_range *id;
    vl_decl *decl;

    CreTRACE("Creating module\n");
    if (st_lookup(mod_list->mp_st, mod_name->name, &clash_module)) {
	clash_module->type = ModDecl;
	clash_module->flags = 0;
	clash_module->ports = ports;
	clash_module->mod_items = mod_items;
	clash_module->handle = (lsHandle)0;
	if (clash_module->inst_st) {
	    clash_module->inst_st = st_init_table(strcmp, st_strhash);
	}
	if (clash_module->sig_st) {
	    clash_module->sig_st = st_init_table(strcmp, st_strhash);
	}
	if (clash_module->latch_st) {
	    clash_module->latch_st = st_init_table(strcmp, st_strhash);
	}
	return clash_module;
    }
    mod = (vl_module *)chk_malloc(MAX(sizeof(vl_module),sizeof(vl_primitive)));
    st_insert(mod_list->mp_st, mod_name->name, (char *)mod);
    lsNewEnd(mod_list->modules, (char *)mod, LS_NH);
    mod->type = ModDecl;
    mod->flags = 0;
    mod->name = mod_name;
    mod->ports = ports;
    mod->sig_st = st_init_table(strcmp, st_strhash);
    mod->inst_st = st_init_table(strcmp, st_strhash);
    mod->latch_st = st_init_table(strcmp, st_strhash);
    mod->mod_items = mod_items;
    mod->clk = NIL(vl_id_range);
    mod->syndrome_width = 0;
    mod->handle = (lsHandle)0;
    return(mod);
}


vl_primitive *vl_create_primitive(prim_name, ports, prim_decls, prim_entries)
    vl_id_range *prim_name;
    lsList ports;
    lsList prim_decls;
    lsList prim_entries;
{
    vl_primitive *prim;
    vl_primitive *clash_prim;	/* if primitive name is same as previous */
    vl_id_range *id;
    vl_decl *decl;

    CreTRACE("Creating primitive\n");
    if (st_lookup(mod_list->mp_st, prim_name->name, &clash_prim)) {
	clash_prim->type = CombPrimDecl;
	clash_prim->flags = 0;
	clash_prim->ports = ports;
	clash_prim->sig_st = st_init_table(strcmp, st_strhash);
	clash_prim->decls = prim_decls;
	clash_prim->entries = prim_entries;
	clash_prim->handle = (lsHandle)0;
	return clash_prim;
    }
    prim = (vl_primitive *)chk_malloc(sizeof(vl_primitive));
	st_insert(mod_list->mp_st, prim_name->name, (char *)prim);
    prim->type = CombPrimDecl;
    prim->flags = 0;
    prim->name = prim_name;
    prim->ports = ports;
    prim->sig_st = st_init_table(strcmp, st_strhash);
    prim->decls = prim_decls;
    prim->entries = prim_entries;
    prim->handle = (lsHandle)0;
    return(prim);
}

vl_port *vl_create_port(type, id, exprs)
    short type;
    vl_id_range *id;
    lsList exprs;
{
    vl_port *port;

    CreTRACE("Creating Port\n");
    port = (vl_port *)chk_malloc(sizeof(vl_port));
    port->type = type;
    port->id = id;
    port->port_exp = exprs;
    return port;
}

vl_port_connect *vl_create_port_connect(type, id, expr)
    short type;
    vl_id_range *id;
    vl_expr *expr;
{
    vl_port_connect *port_connect;

    CreTRACE("Creating Port Connect\n");
    port_connect = (vl_port_connect *)chk_malloc(sizeof(vl_port_connect));
    port_connect->type = type;
    port_connect->id = id;
    port_connect->expr = expr;
    return port_connect;
}

vl_prim_entry *vl_create_prim_entry(inputs, state, output)
    lsList inputs;
    unsigned char state;
    unsigned char output; /* or next state */
{
    vl_prim_entry *entry;
    lsHandle handle;
    lsGen gen;
    unsigned char insym;
    int i = 0;

    CreTRACE("Creating primitive entry");
    entry = (vl_prim_entry *)chk_malloc(sizeof(vl_prim_entry));
    entry->state = state;
    entry->next_state = output;
    gen = lsStart(inputs);
    if (lsNext(gen, &insym, &handle) == LS_OK) {
	entry->inputs[i++] = insym;
	while (i < MAXINLEN && lsNext(gen, &insym, &handle) != LS_NOMORE) {
	    entry->inputs[i++] = insym;
	}
    }
    return entry;
}


vl_decl *vl_create_basicdecl(type, ids)
    short type;
    lsList ids;
{
    vl_decl *decl;

    CreTRACE("Creating Basic decl\n");
    decl = (vl_decl *)chk_malloc(sizeof(vl_decl));
    decl->type = type;
    decl->flags = 0;
    decl->ids = ids;
    decl->handle = (lsHandle)0;
    return(decl);
}

vl_rangedecl *vl_create_rangedecl(type, range, ids, mv)
    short type;
    vl_range *range;
    lsList ids;
    int mv;
{
    vl_rangedecl *decl;
    lsGen gen;
    lsHandle handle;
    char *id, *dummy;

    CreTRACE("Creating Range decl\n");
    decl = (vl_rangedecl *)chk_malloc(sizeof(vl_decl));
    decl->type = type;
    decl->flags = (type==InputDecl)?InPort:(type==OutputDecl)?OutPort:
                  (type==InoutDecl)?(InPort|OutPort):RegVar;
    decl->flags |= mv;
    decl->range = range;
    decl->ids = ids;
    decl->handle = (lsHandle)0;

    /* insert signals into symbol table and back link id to declaratin expr */
    gen = lsStart(ids);
    if (lsNext(gen, &id, &handle) == LS_OK) {
	char *idname;

	((vl_id_range *)id)->mpg_master_exp = decl;
	((vl_id_range *)id)->flags = mv | decl->flags;
	idname = ((vl_id_range *)id)->name;
	
	if (vl_currentModule != NIL(vl_module)) {
	    if (!st_lookup(vl_currentModule->sig_st, idname, &dummy))
		st_insert(vl_currentModule->sig_st, idname, id);
	    else {
		((vl_id_range*)dummy)->flags |= mv;
		((vl_id_range*)dummy)->flags |= decl->flags;
		if (!(((vl_id_range*)dummy)->range))
		    ((vl_id_range*)dummy)->range = ((vl_id_range*)id)->range;
	    }
	}
	else if (vl_currentPrimitive != NIL(vl_primitive)) {
	    if (!st_lookup(vl_currentPrimitive->sig_st, idname, &dummy))
		st_insert(vl_currentPrimitive->sig_st, idname, id);
	    else {
		((vl_id_range*)dummy)->flags |= mv;
		((vl_id_range*)dummy)->flags |= decl->flags;
		if (!(((vl_id_range*)dummy)->range))
		    ((vl_id_range*)dummy)->range = ((vl_id_range*)id)->range;
	    }
	}
	else
	    compile_error("declaring signal not within module/primitive");

	while (lsNext(gen, &id, &handle) != LS_NOMORE) {
	    ((vl_id_range *)id)->mpg_master_exp = decl;
	    ((vl_id_range *)id)->flags = mv | decl->flags;
	    idname = ((vl_id_range *)id)->name;

	    if (vl_currentModule != NIL(vl_module)) {
		if (!st_lookup(vl_currentModule->sig_st, idname, &dummy))
		    st_insert(vl_currentModule->sig_st, idname, id);
		else {
		    ((vl_id_range*)dummy)->flags |= mv;
		    ((vl_id_range*)dummy)->flags |= decl->flags;
		    if (!(((vl_id_range*)dummy)->range))
			((vl_id_range*)dummy)->range = ((vl_id_range*)id)->range;
		}
	    }
	    else if (vl_currentPrimitive != NIL(vl_primitive)) {
		if (!st_lookup(vl_currentPrimitive->sig_st, idname, &dummy))
		    st_insert(vl_currentPrimitive->sig_st, idname, id);
		else {
		    ((vl_id_range*)dummy)->flags |= mv;
		    ((vl_id_range*)dummy)->flags |= decl->flags;
		    if (!(((vl_id_range*)dummy)->range))
			((vl_id_range*)dummy)->range = ((vl_id_range*)id)->range;
		}
	    }
	    else
		compile_error("declaring signal not within module/primitive");
	}
    }

    return(decl);
}

vl_paramdecl *vl_create_paramdecl(type, assigns)
    short type;
    lsList assigns;
{
    vl_paramdecl *decl;
    lsGen gen;
    lsHandle handle;
 
    CreTRACE("Creating Parameter decl\n");
    decl = (vl_paramdecl *)chk_malloc(sizeof(vl_paramdecl));
    decl->type = type;
    decl->flags = 0;
    decl->assigns = assigns;
    decl->handle = (lsHandle)0;

    return(decl);
}

vl_netdecl *vl_create_netdecl(type, strength, range, delay, ids)
    short type;
    int strength;
    vl_range *range;
    vl_delay *delay;
    lsList ids;			/* can be assignments or ids */
{
    vl_netdecl *decl;
    lsGen gen;
    lsHandle handle;
    vl_id_range *id;
    vl_id_range *id_sym;

    CreTRACE("Creating Net decl\n");
    decl = (vl_netdecl *)chk_malloc(sizeof(vl_netdecl));
    decl->type = type;
    decl->flags = 0;
    decl->strength = strength;
    decl->range = range;
    decl->delay = delay;
    decl->ids = ids;
    decl->handle = (lsHandle)0;

    /* insert signals into symbol table and back link id to declaratin expr */
    gen = lsStart(ids);
    if (lsNext(gen, &id, &handle) == LS_OK) {
	id->mpg_master_exp = decl;

	if (vl_currentModule != NIL(vl_module)) {
	    if (!st_lookup(vl_currentModule->sig_st, id->name, &id_sym))
		st_insert(vl_currentModule->sig_st, id->name, id);
	} else if (vl_currentPrimitive != NIL(vl_primitive)) {
	    if (!st_lookup(vl_currentPrimitive->sig_st, id->name, &id_sym))
		st_insert(vl_currentPrimitive->sig_st, id->name, id);
	} else
	    compile_error("declaring signal not within module/primitive");

	while (lsNext(gen, &id, &handle) != LS_NOMORE) {
	    id->mpg_master_exp = decl;

	    if (vl_currentModule != NIL(vl_module))
		st_insert(vl_currentModule->sig_st, id->name, id);
	    else if (vl_currentPrimitive != NIL(vl_primitive))
		st_insert(vl_currentPrimitive->sig_st, id->name, id);
	    else
		compile_error("declaring signal not within module/primitive");
	}
    }

    return(decl);
}

vl_task *vl_create_task(name, decls, stmts)
    vl_id_range *name;
    lsList decls;
    lsList stmts;
{
    vl_task *task;

    CreTRACE("Creating Task\n");
    task = (vl_task *)chk_malloc(sizeof(vl_task));
    task->type = TaskDecl;
    task->flags = 0;
    task->name = name;
    task->decls = decls;
    task->stmts = stmts;
    task->handle = (lsHandle)0;
    return(task);
}

vl_function *vl_create_function(type, range, name, decls, stmts)
    short type;
    vl_range *range;
    vl_id_range *name;
    lsList decls;
    lsList stmts;
{
    vl_function *func;

    CreTRACE("Creating Function\n");
    func = (vl_function *)chk_malloc(sizeof(vl_function));
    func->type = type;
    func->flags = 0;
    func->range = range;
    func->name = name;
    func->decls = decls;
    func->stmts = stmts;
    func->handle = (lsHandle)0;
    return(func);
}

vl_gate_inst_list *vl_create_gate_inst_list(type, strength, delays, gates)
    short type;
    int strength;
    vl_delay *delays;
    vl_gate_inst *gates;
{
    vl_gate_inst_list *gatelist;

    CreTRACE("Creating Gate Instance List\n");
    gatelist = (vl_gate_inst_list *)chk_malloc(sizeof(vl_gate_inst_list));
    gatelist->type = type;
    gatelist->flags = 0;
    gatelist->strength = strength;
    gatelist->delays = delays;
    gatelist->gates = gates;
    gatelist->handle = (lsHandle)0;
    return(gatelist);
}

vl_gate_inst *vl_create_gate_inst(name, terms)
    vl_id_range *name;
    lsList terms;
{
    vl_gate_inst *gate;

    CreTRACE("Creating Gate Instance\n");
    gate = (vl_gate_inst *)chk_malloc(sizeof(vl_gate_inst));
    gate->name = name;
    gate->terms = terms;
    gate->handle = (lsHandle)0;
    return(gate);
}

typestruct *vl_add_find_mod_prim_instances(mp_name, delay, strength, instances)
vl_id_range *mp_name;
vl_delay *delay;
int strength;
lsList instances;
{
    char *mod_pri;
    typestructPtr retval;
    int still_unknown=0;

    if (!st_lookup(vl_description->mp_st, mp_name->name, &mod_pri)) {
	still_unknown = 1;
    } else if (mod_pri == NIL(char)) {
	still_unknown = 1;
    }
    
    if (still_unknown) {
	/* reference bofore declaration, assuming module */
	/* there is a implicit union of vl_module & vl_primitive */
	/* in vl_crate_module */
	mod_pri = (char*)vl_create_module(mp_name, LS_NIL, LS_NIL);
	st_insert(mod_list->mp_st, mp_name->name, mod_pri);
	retval = (typestructPtr)vl_create_mod_prim_inst_list(mp_name, 
				    strength, delay, instances);
	return retval;
    } else {
	if (((typestructPtr)mod_pri)->type == ModDecl) {
	    if (strength!=0)
		compile_error("redundant strength for module instance");
	    retval = (typestructPtr)vl_create_mod_prim_inst_list(mp_name, 
				        strength, delay, instances);
	    ((vl_mod_prim_inst_listPtr)retval)->type = ModInst;
	} else if (((typestructPtr)mod_pri)->type == CombPrimDecl ||
		   ((typestructPtr)mod_pri)->type == SeqPrimDecl) {
	    retval = (typestructPtr)vl_create_mod_prim_inst_list(mp_name, 
				        strength, delay, instances);
	    ((vl_mod_prim_inst_listPtr)retval)->type = PrimInst;
	} else {
	    compile_error("unknown module/primitive");
	}
    }

    return retval;
}


vl_mod_prim_inst_list *vl_create_mod_prim_inst_list(name, strength, delays, mps)
    vl_id_range *name;
    int strength;
    vl_delay *delays;
    lsList mps;
{
    vl_mod_prim_inst_list *mplist;

    CreTRACE("Creating Module/Primitive Instance List\n");
    mplist = (vl_mod_prim_inst_list *)chk_malloc(sizeof(vl_mod_prim_inst_list));
    mplist->type = ModInst;
    mplist->flags = 0;
    mplist->name = name;
    mplist->strength = strength;
    mplist->delays = delays;
    mplist->mps = mps;
    mplist->handle = (lsHandle)0;
    return(mplist);
}

vl_mod_prim_inst *vl_create_mod_prim_inst(name, ports)
    vl_id_range *name;
    lsList *ports;
{
    vl_mod_prim_inst *mp;

    CreTRACE("Creating Primitive Instance\n");
    mp = (vl_mod_prim_inst *)chk_malloc(sizeof(vl_mod_prim_inst));
    mp->name = name;
    mp->ports = ports;
    mp->handle = (lsHandle)0;
    return(mp);
}

/* Create Process statement: always or initial */
vl_procstmt *vl_create_procstmt(type, stmt)
    short type;
    void *stmt;
{
    vl_procstmt *pstmt;

    CreTRACE("Creating Process stmt\n");
    pstmt = (vl_procstmt *)chk_malloc(sizeof(vl_procstmt));
    pstmt->type = type;
    pstmt->flags = 0;
    pstmt->stmt = stmt;
    pstmt->handle = (lsHandle)0;
    return(pstmt);
}

vl_begin_end_stmt *vl_create_begin_end_stmt(name, decls, stmts)
    vl_id_range *name;
    void *decls;
    void *stmts;
{
    vl_begin_end_stmt *bestmt;

    CreTRACE("Creating beginend\n");
    bestmt = (vl_begin_end_stmt *)chk_malloc(sizeof(vl_begin_end_stmt));
    bestmt->type = BeginEndStmt;
    bestmt->flags = 0;
    bestmt->name = name;
    bestmt->decls = decls;
    bestmt->stmts = stmts;
    bestmt->handle = (lsHandle)0;
    return(bestmt);
}

vl_if_else_stmt *vl_create_if_else_stmt(cond, if_stmt, else_stmt)
    vl_expr *cond;
    void *if_stmt;
    void *else_stmt;
{
    vl_if_else_stmt *stmt;

    CreTRACE("Creating if_else_stmt\n");
    stmt = (vl_if_else_stmt *)chk_malloc(sizeof(vl_if_else_stmt));
    stmt->type = IfElseStmt;
    stmt->flags = 0;
    stmt->cond = cond;
    stmt->if_stmt = if_stmt;
    stmt->else_stmt = else_stmt;
    stmt->handle = (lsHandle)0;
    return(stmt);
}

vl_case_stmt *vl_create_case_stmt(type, cond, case_items)
    short type;
    vl_expr *cond;
    lsList case_items;
{
    vl_case_stmt *stmt;

    CreTRACE("Creating case_stmt\n");
    stmt = (vl_case_stmt *)chk_malloc(sizeof(vl_case_stmt));
    stmt->type = type;
    stmt->flags = 0;
    stmt->cond = cond;
    stmt->case_items = case_items;
    stmt->handle = (lsHandle)0;
    return(stmt);
}

vl_forever_stmt *vl_create_forever_stmt(stmt)
    void *stmt;
{
    vl_forever_stmt *fstmt;

    CreTRACE("Creating forever_stmt\n");
    fstmt = (vl_forever_stmt *)chk_malloc(sizeof(vl_forever_stmt));
    fstmt->type = ForeverStmt;
    fstmt->flags = 0;
    fstmt->stmt = stmt;
    fstmt->handle = (lsHandle)0;
    return(fstmt);
}

vl_repeat_stmt *vl_create_repeat_stmt(count, stmt)
    vl_expr *count;
    void *stmt;
{
    vl_repeat_stmt *rstmt;

    CreTRACE("Creating repeat_stmt\n");
    rstmt = (vl_repeat_stmt *)chk_malloc(sizeof(vl_repeat_stmt));
    rstmt->type = RepeatStmt;
    rstmt->flags = 0;
    rstmt->count = count;
    rstmt->stmt = stmt;
    rstmt->handle = (lsHandle)0;
    return(rstmt);
}

vl_while_stmt *vl_create_while_stmt(cond, stmt)
    vl_expr *cond;
    void *stmt;
{
    vl_while_stmt *wstmt;

    CreTRACE("Creating while_stmt\n");
    wstmt = (vl_while_stmt *)chk_malloc(sizeof(vl_while_stmt));
    wstmt->type = WhileStmt;
    wstmt->flags = 0;
    wstmt->cond = cond;
    wstmt->stmt = stmt;
    wstmt->handle = (lsHandle)0;
    return(wstmt);
}

vl_for_stmt *vl_create_for_stmt(init, cond, end, stmt)
    vl_bassign_stmt *init;
    vl_expr *cond;
    vl_bassign_stmt *end;
    void *stmt;
{
    vl_for_stmt *fstmt;

    CreTRACE("Creating for_stmt\n");
    fstmt = (vl_for_stmt *)chk_malloc(sizeof(vl_for_stmt));
    fstmt->type = ForStmt;
    fstmt->flags = 0;
    fstmt->init = init;
    fstmt->cond = cond;
    fstmt->end = end;
    fstmt->stmt = stmt;
    fstmt->handle = (lsHandle)0;
    return(fstmt);
}

vl_delay_control_stmt *vl_create_delay_control_stmt(delay, stmt)
    vl_delay *delay;
    void *stmt;
{
    vl_delay_control_stmt *dcstmt;

    CreTRACE("Creating delay_control_stmt\n");
    dcstmt = (vl_delay_control_stmt *)chk_malloc(sizeof(vl_delay_control_stmt));
    dcstmt->type = DelayControlStmt;
    dcstmt->flags = 0;
    dcstmt->delay = delay;
    dcstmt->stmt = stmt;
    return(dcstmt);
}

vl_event_control_stmt *vl_create_event_control_stmt(event, stmt)
    vl_event_expr *event;
    void *stmt;
{
    vl_event_control_stmt *ecstmt;

    CreTRACE("Creating event_control_stmt\n");
    ecstmt = (vl_event_control_stmt *)chk_malloc(sizeof(vl_event_control_stmt));
    ecstmt->type = EventControlStmt;
    ecstmt->flags = 0;
    ecstmt->event = event;
    ecstmt->stmt = stmt;
    return(ecstmt);
}

/* create an assignment, with a possible delay or event control in it */
vl_bassign_stmt *vl_create_bassign_stmt(type, lhs, control, rhs)
    short type;			/* AssignStmt BassignStmt or NbassignStmt */
    vl_lval *lhs;
    void *control;		/* event or delay control */
    vl_expr *rhs;
{
    vl_bassign_stmt *bassign;

    CreTRACE("Creating bassign_stmt\n");
    bassign = (vl_bassign_stmt *)chk_malloc(sizeof(vl_bassign_stmt));
    bassign->type = type;
    bassign->flags = 0;
    bassign->lhs = lhs;
    bassign->control = control;
    bassign->rhs = rhs;
    bassign->handle = (lsHandle)0;
    return(bassign);
}

vl_cont_assign *vl_create_cont_assign_stmt(strength, delay, assigns)
int strength;
vl_delay *delay;
lsList assigns;
{
    vl_cont_assign *cassign;

    CreTRACE("Creating cont_assign");
    cassign = (vl_cont_assign *)chk_malloc(sizeof(vl_cont_assign));
    cassign->type = ContAssign;
    cassign->flags = 0;
    cassign->strength = strength;
    cassign->delay = delay;
    cassign->assigns = assigns;
    return cassign;
}

vl_wait_stmt *vl_create_wait_stmt(cond, stmt)
    vl_expr *cond;
    void *stmt;
{
    vl_wait_stmt *wstmt;

    CreTRACE("Creating wait_stmt\n");
    wstmt = (vl_wait_stmt *)chk_malloc(sizeof(vl_wait_stmt));
    wstmt->type = WaitStmt;
    wstmt->flags = 0;
    wstmt->cond = cond;
    wstmt->stmt = stmt;		
    wstmt->handle = (lsHandle)0;
    return(wstmt);
}

vl_send_event_stmt *vl_create_send_event_stmt(name)
    vl_id_range *name;
{
    vl_send_event_stmt *send_event;

    CreTRACE("creating send_event_stmt\n");
    send_event = (vl_send_event_stmt*)chk_malloc(sizeof(vl_send_event_stmt));
    send_event->type = SendEventStmt;
    send_event->name = name;
}

vl_fork_join_stmt *vl_create_fork_join_stmt(name, decls, stmts)
    vl_id_range *name;
    void *decls;
    void *stmts;
{
    vl_fork_join_stmt *fjstmt;

    CreTRACE("Creating fork_join_stmt\n");
    fjstmt = (vl_fork_join_stmt *)chk_malloc(sizeof(vl_fork_join_stmt));
    fjstmt->type = ForkJoinStmt;
    fjstmt->flags = 0;
    fjstmt->name = name;
    fjstmt->decls = decls;
    fjstmt->stmts = stmts;
    fjstmt->handle = (lsHandle)0;
    return(fjstmt);
}


vl_task_enable_stmt *vl_create_task_enable_stmt(type, name, args)
    short type;			/* TaskEnableStmt or SysTaskEnableStmt */
    vl_id_range *name;
    lsList args;
{
    vl_task_enable_stmt *testmt;

    CreTRACE("Creating task_enable_stmt\n");
    testmt = (vl_task_enable_stmt *)chk_malloc(sizeof(vl_task_enable_stmt));
    testmt->type = type;
    testmt->flags = 0;
    testmt->name = name;
    testmt->args = args;
    testmt->handle = (lsHandle)0;
    return(testmt);
}

vl_disable_stmt *vl_create_disable_stmt(name)
    vl_id_range *name;
{
    vl_disable_stmt *dstmt;

    CreTRACE("Creating disable_stmt\n");
    dstmt = (vl_disable_stmt *)chk_malloc(sizeof(vl_disable_stmt));
    dstmt->type = DisableStmt;
    dstmt->flags = 0;
    dstmt->name = name;
    dstmt->handle = (lsHandle)0;
    return(dstmt);
}

vl_deassign_stmt *vl_create_deassign_stmt(lhs)
    vl_lval *lhs;
{
    vl_deassign_stmt *dstmt;

    CreTRACE("Creating deassign_stmt\n");
    dstmt = (vl_deassign_stmt *)chk_malloc(sizeof(vl_deassign_stmt));
    dstmt->type = DeassignStmt;
    dstmt->flags = 0;
    dstmt->lhs = lhs;
    dstmt->handle = (lsHandle)0;
    return(dstmt);
}

vl_case_item *vl_create_case_item(type, expr, stmt)
    short type;			/* CaseItem or DefaultItem */
    lsList expr;
    void *stmt;
{
    vl_case_item *item;

    CreTRACE("Creating case_item\n");
    item = (vl_case_item *)chk_malloc(sizeof(vl_case_item));
    item->type = type;
    item->flags = 0;
    item->exprs = expr;
    item->stmt = stmt;
    item->handle = (lsHandle)0;
    return(item);
}

vl_event_expr *vl_create_event_expr(type, expr)
    short type;			/* OrEventExpr NegedgeEventExpr */
				/* PosedgeEventExpr EventExpr */
    struct vl_expr *expr;
{
    vl_event_expr *event;

    CreTRACE("Creating event_expr\n");
    event = (vl_event_expr *)chk_malloc(sizeof(vl_event_expr));
    event->type = type;
    event->flags = 0;
    event->expr = expr;
    event->list = (lsHandle)0;
    return(event);
}

vl_lval *vl_create_lval(type, name, range, concat)
    short type;			/* IDExpr BitSelExpr PartSelExpr ConcatExpr */
    vl_id_range *name;
    vl_range *range;
    lsList concat;
{
    vl_lval *lval;

    CreTRACE("Creating lval\n");
    lval = (vl_lval *)chk_malloc(sizeof(vl_lval));
    lval->type = type;
    lval->flags = 0;
    lval->name = name;
    lval->range = range;
    lval->concat = concat;
    return(lval);
}

vl_expr *vl_create_expr(type, intval, realval, p1, p2, p3)
    short type;			/* Any expression from vl_defs.h */
    int intval;			/* used if is integer */
    double realval;		/* used if expr is real */
    void *p1, *p2, *p3;		/* ptrs for other types of expr */
{
    vl_expr *expr;

    CreTRACE("Creating expr\n");
    expr = (vl_expr *)chk_malloc(sizeof(vl_expr));
    expr->type = type;
    expr->flags = 0;
    switch (type) {
    case BitExpr:
	expr->u.bexpr.part1 = (int)p1;
	expr->u.bexpr.part0 = (int)p2;
	expr->u.exprs.e3 = (vl_expr*)p3;
    case IntExpr:
	expr->u.intval = intval; 
	break;
    case RealExpr:
	expr->u.realval = realval; 
	break;
    case IDExpr:
	expr->u.name = (vl_id_range *)p1; 
	break;
    case BitSelExpr:    case PartSelExpr:
	expr->u.idrng = (vl_id_range *)p1; 
	break;
    case ConcatExpr:
	expr->u.exprs.e1 = (vl_expr*)p1;
	expr->u.exprs.e2 = NIL(vl_expr);
	expr->u.exprs.e3 = NIL(vl_expr);
	break;			/* use next field for concat exprs */
    case MinTypMaxExpr:
	expr->u.exprs.e1 = (vl_expr*)p1;
	expr->u.exprs.e2 = (vl_expr*)p2;
	expr->u.exprs.e3 = (vl_expr*)p3;
	break;			/* use next field for other exprs */
    case StringExpr:
	expr->u.string = (char *)p1;
	break;
    case FuncExpr:
	expr->u.func_call.name = (vl_id_range *)p1;
	expr->u.func_call.args = (lsList)p2;
	break;
    case UplusExpr:    case UminusExpr:
    case UnotExpr:    case UcomplExpr:
    /* Unary Reduction Operators */
    case UandExpr:    case UnandExpr:
    case UorExpr:    case UnorExpr:
    case UxorExpr:    case UxnorExpr:
	expr->u.exprs.e1 = (vl_expr *)p1;
	expr->u.exprs.e2 = NIL(vl_expr);
	expr->u.exprs.e3 = NIL(vl_expr);
	break;
    /* Binary Operators */
    case BplusExpr:    case BminusExpr:
    case BtimesExpr:    case BdivExpr:
    case BremExpr:    case Beq2Expr:
    case Bneq2Expr:    case Beq3Expr:
    case Bneq3Expr:    case BlandExpr:
    case BlorExpr:    case BltExpr:
    case BleExpr:   case BgtExpr:
    case BgeExpr:    case BandExpr:
    case BorExpr:    case BxorExpr:
    case BxnorExpr:    case BlshiftExpr:
    case BrshiftExpr:
	expr->u.exprs.e1 = (vl_expr *)p1;
	expr->u.exprs.e2 = (vl_expr *)p2;
	expr->u.exprs.e3 = NIL(vl_expr);
	break;
	/* ternary operators */
    case TcondExpr:
	expr->u.exprs.e1 = (vl_expr *)p1;
	expr->u.exprs.e2 = (vl_expr *)p2;
	expr->u.exprs.e3 = (vl_expr *)p3;
	break;
    }
    return(expr);
}

vl_range *vl_create_range(left, right)
    vl_expr *left;
    vl_expr *right;
{
    vl_range *range;

    CreTRACE("Creating range\n");
    range = (vl_range *)chk_malloc(sizeof(vl_range));
    range->left = left;
    range->right = right;
    return(range);
}

vl_delay *vl_create_delay(delay1, delay2, delay3)
    vl_expr *delay1;
    vl_expr *delay2;
    vl_expr *delay3;
{
    vl_delay *delay;

    CreTRACE("Creating delay\n");
    delay = (vl_delay *)chk_malloc(sizeof(vl_delay));
    delay->delay1 = delay1;
    delay->delay2 = delay2;
    delay->delay3 = delay3;
    return(delay);
}

/* 
 * STCheng
 *
 * auxiliary creating routines for parsing
 */

vl_range_or_typePtr vl_create_range_or_type(type, range)
short type;
vl_rangePtr range;
{
    vl_range_or_typePtr rng_typ;

    rng_typ = (vl_range_or_typePtr)chk_malloc(sizeof(vl_range_or_type));
    rng_typ->type = type;
    rng_typ->range = range;
    return rng_typ;
}

/*
 * vl_create_id_range
 *
 *     when range is NIL(vl_range), then id is a scalar
 */
vl_id_range *vl_create_id_range(name, range)
char *name;
vl_range *range;
{
    vl_id_range *id_range;

    CreTRACE("Creating id_range\n");
    id_range = (vl_id_range *)chk_malloc(sizeof(vl_id_range));
    id_range->name = name;
    id_range->range = range;
    id_range->initial = NIL(vl_term);
    id_range->syndrome_expr_list = lsCreate();
    id_range->mpg_master_exp = NIL(void);
    return(id_range);
}

vl_term *vl_create_term(name, lo, hi)
vl_id_range *name;
int lo, hi;
{
    vl_term *term;

    CreTRACE("Creating term\n");
    term = (vl_term *)chk_malloc(sizeof(vl_term));
    term->name = name;
    term->flag = 0;
    term->lo = lo;
    term->hi = hi;
    return term;
}

/* copy routines */
vl_id_range *vl_copy_id_range(id_range)
vl_id_range *id_range;
{
    vl_id_range *retval;

    CreTRACE("Copying id_range\n");
    retval = (vl_id_range *)chk_malloc(sizeof(vl_id_range));
    retval->name = strdup(id_range->name);
    retval->range = id_range->range;
    retval->syndrome_expr_list = id_range->syndrome_expr_list;
    retval->mpg_master_exp = id_range->mpg_master_exp;
    return(retval);
}

vl_term *vl_copy_term(term)
vl_term *term;
{
    vl_term *retval;

    CreTRACE("Copying term\n");
    retval = (vl_term*)chk_malloc(sizeof(vl_term));
    retval->name = vl_copy_id_range(term->name);
    retval->flag = term->flag;
    retval->lo = term->lo;
    retval->hi = term->hi;
    return retval;
}

var_info *copy_var_info(var)
var_info *var;
{
    var_info *retval;

    retval = (var_info*)chk_malloc(sizeof(var_info));
    retval->id = vl_copy_id_range(var->id);
    retval->current_terminal = vl_copy_term(var->current_terminal);
    retval->cond_list = lsCopy(var->cond_list,0);
    return retval;
}

/* create a term containing id_range, however, name is replaced with newname */
vl_term *create_rename_term(id_range, newname, lo, hi)
vl_id_range *id_range;
char *newname;
int lo;
int hi;
{
    vl_id_range *new_id;
    vl_term *new_term;

    new_id = vl_copy_id_range(id_range);
    chk_free(new_id->name);
    new_id->name = strdup(newname);
    new_term = vl_create_term(new_id, lo, hi);
    new_term->flag = get_decl_flags(id_range->mpg_master_exp);
    return new_term;
}

var_info *create_var_info(id, term)
vl_id_range *id;
vl_term *term;
{
    var_info *retval;

    retval = (var_info*)chk_malloc(sizeof(var_info));
    retval->id = id;
    retval->current_terminal = term;
    retval->cond_list = lsCreate();
    return retval;
}

/* free routines */

void vl_free_id(id)
vl_id_range *id;
{
    if (id->name) chk_free(id->name);
    chk_free(id);
}

void vl_free_term(term)
vl_term *term;
{
    if (term->name) vl_free_id(term->name);
    chk_free(term);
}

void free_var_info(vinfo)
var_info *vinfo;
{
    if (vinfo->id) vl_free_id(vinfo->id);
    if (vinfo->current_terminal) vl_free_term(vinfo->current_terminal);
    chk_free(vinfo);
}

blif_latch *create_latch(name, input, output)
vl_id_range *name;
vl_term *input, *output;
{
    blif_latch *retval;

    retval = (blif_latch*)chk_malloc(sizeof(blif_latch));
    retval->name = name;
    retval->inport = input;
    retval->outport = output;
    return retval;
}

syndrome_expr *create_syndrome_expr(synd, expr)
char *synd;
vl_term *expr;
{
    syndrome_expr *retval;

    retval = (syndrome_expr*)chk_malloc(sizeof(syndrome_expr));
    retval->syndrome = synd;
    retval->expr = expr;
    return retval;
}

const_term *create_const_term(const_expr, term)
vl_expr *const_expr;
vl_term *term;
{
    const_term *retval;

    retval = (const_term*)chk_malloc(sizeof(const_term));
    retval->const_expr = const_expr;
    retval->term = term;
    return retval;
}

vl_term *new_term(range, lo, hi)
vl_range *range;
int lo;
int hi;
{
    vl_term *retval;

    retval = (vl_term*)chk_malloc(sizeof(vl_term));
    retval = vl_create_term(vl_create_id_range(strdup(new_termname()),range),
			    lo, hi);
    return retval;
}
 = SendEventStmt;
    send_event->name = name;
}

vl_fork_join_stmt *vl_create_fork_join_stmt(name, decls, stmts)
    vl_id_range *name;
    void *decls;
    void *stmts;
{
    vl_fork_join_stmt *fjstmt;

    CreTRACE("Creating fork_join_stmt\n");
    fjstmt = (vl_fork_join_stmt *)chk_malloc(sizeof(vl_fork_join_stmt));
    fjstmt->type = ForkJoinStmt;
    fjstmt-vl2mv/src/parser/vl_traverse.c                                                                      100644  027004  000214  00000130623 05346760071 013672  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
   $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/vl_traverse.c,v 1.2 1993/01/15 19:41:37 stcheng Exp stcheng $

   vl_print.c: Routines to print the abstract syntax tree
   for Verilog to BLIF-MV.
   GY  9/92

   Modified:
   STCheng 11/92 Based on vl_print.c, vl_traverse.c traverse the parsing
       tree, collect useful information for later processing. vl_traverse.c
       can still print out the parsing tree if you turn on the local static
       varable PrtEnable.
               
*/

#include <stdlib.h>
#include "util.h"
#include "st.h"
#include "list.h"
#include "vl_types.h"
#include "vl_defs.h"
#include "vlr_int.h"
#include "vl_traverse.h"

extern vl_desc *mod_list;	/* list of all the modules and primitives */
static StpTrace=0;
int    PrtEnable=0;             /* when PrtEnable is false, vl_print_* can */
                                /* be used to traverse parse tree */

void vl_fprintf_stmt(va_alist)
va_dcl
{
    FILE *file;
    char *fmt;
    va_list args;

    va_start(args);
    file = va_arg(args, FILE*);
    fmt = va_arg(args, char*);
    if (PrtEnable) (void)vfprintf(file, fmt, args);
    va_end(args);
}

enum st_retval vl_step_desc(name, value, arg)
char *name;
char *value;
char *arg;
{
    if (((typestructPtr)value)->type == ModDecl) {
	vl_step_module(stdout, (vl_module*)value);
    } else if (((typestructPtr)value)->type == CombPrimDecl ||
	       ((typestructPtr)value)->type == SeqPrimDecl) {
	vl_step_primitive(stdout, (vl_primitive*)value);
    }
    return ST_CONTINUE;
}

void vl_step_module(file, mod)
    FILE *file;
    vl_module *mod;
{
    if (mod == NULL) return;

    ASSERT(mod->type==ModDecl, "Expecting ModDecl");
    vl_currentModule = mod;
    StpTRACE("printing module\n");
    vl_fprintf_stmt(file, "module ");
    vl_step_id_range(file, mod->name);
    vl_step_ports(file, mod->ports);
    vl_fprintf_stmt(file, ";\n");
    vl_step_mod_item_list(file, mod->mod_items);
    vl_fprintf_stmt(file, "endmodule\n\n");
    vl_currentModule = NIL(vl_module);
}


void vl_step_primitive(file, prim)
    FILE *file;
    vl_primitive *prim;
{
    if (prim == NULL) return;

    ASSERT((prim->type==CombPrimDecl || prim->type==SeqPrimDecl), 
	   "Expecting PrimDecl");
    StpTRACE("Printing primitive\n");
    vl_fprintf_stmt(file, "primitive ");
    vl_step_id_range(file, prim->name);
    vl_step_ports(file, prim->ports);
    vl_fprintf_stmt(file, ";\n");
    vl_step_mod_item_list(file, prim->decls);
    vl_step_prim_table(file, prim->type, prim->entries);
    vl_fprintf_stmt(file, "endprimitive\n\n");
}


void vl_step_prim_table(file, type, entries)
    FILE *file;
    short type;
    lsList entries;
{
    vl_prim_entry *e;
    int i;
    lsHandle handle;
    lsGen gen;

    if (entries == NULL) return;

    StpTRACE("Printing primitive table\n");
    vl_fprintf_stmt(file, "table\n");
    for(gen = lsStart(entries); lsNext(gen, &e, &handle) != LS_NOMORE; ) {
	for (i=0; i<10; i++) {
	    if (e->inputs[i] == PrimNone)
		break;
	    else
		vl_fprintf_stmt(file, "%s ", vl_get_prim_symbol(e->inputs[i]));
	}
	vl_fprintf_stmt(file, ": %s", vl_get_prim_symbol(e->state));
	if (type == SeqPrimDecl) /* print next state */
	    vl_fprintf_stmt(file, ": %s", vl_get_prim_symbol(e->next_state));
	vl_fprintf_stmt(file, ";\n", vl_get_prim_symbol(e->state));
    }
    (void) lsFinish(gen);
    vl_fprintf_stmt(file, "endtable\n");
}


void vl_step_basicdecl(file, decl)
    FILE *file;
    vl_decl *decl;
{

    StpTRACE("Printing Basic decl\n");
    switch(decl->type) {
    case RealDecl:
	vl_fprintf_stmt(file, "real "); 
	vl_step_id_list(file, decl->ids);
	break;
    case EventDecl:
	vl_fprintf_stmt(file, "event ");
	vl_step_id_list(file, decl->ids);
	break;
    case IntDecl:
	vl_fprintf_stmt(file, "integer ");
	vl_step_id_range_list(file, decl->ids);
	break;
    case TimeDecl:
	vl_fprintf_stmt(file, "time ");
	vl_step_id_range_list(file, decl->ids);
	break;
    default:
	internal_error("Unexpected Basic Decl type");	break;
    }
    vl_fprintf_stmt(file, ";\n");
}

/*
void vl_step_arr_decl(file, decl)
    FILE *file;
    vl_arr_decl *decl;
{

    StpTRACE("Printing Array decl\n");
    switch(decl->type) {
    case IntDecl:
	vl_fprintf_stmt(file, "integer ");	break;
    case TimeDecl:
	vl_fprintf_stmt(file, "time "); 	break;
    default:
	internal_error("Unexpected Basic Decl type");	break;
    }
    vl_step_expr_list(file, decl->ids); // can be of form a[0:2] //
    vl_fprintf_stmt(file, ";\n");
}
*/
void vl_step_rangedecl(file, decl)
    FILE *file;
    vl_rangedecl *decl;
{
    StpTRACE("Printing Range decl\n");
    switch(decl->type) {
    case InputDecl:
	vl_fprintf_stmt(file, "input ");	break;
    case OutputDecl:
	vl_fprintf_stmt(file, "output ");	break;
    case InoutDecl:
	vl_fprintf_stmt(file, "inout ");	break;
    case RegDecl:
	vl_fprintf_stmt(file, "reg ");  	break;
    default:
	internal_error("Unexpected Range Decl");	break;
    }
    vl_step_range(file, decl->range);
    if (decl->type == RegDecl)
	vl_step_id_range_list(file, decl->ids);
    else
	vl_step_id_list(file, decl->ids);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_paramdecl(file, decl)
    FILE *file;
    vl_paramdecl *decl;
{

    StpTRACE("Printing Parameter decl\n");
    switch(decl->type) {
    case ParamDecl:
	vl_fprintf_stmt(file, "parameter ");	break;
    case DefparamDecl:
	vl_fprintf_stmt(file, "defparam ");	break;
    default:
	internal_error("Unexpected Param Decl");	break;
    }
    /* foreach in list, comma separated */
    {
	vl_bassign_stmt *assign;
	lsHandle handle;
	lsGen gen;

	gen = lsStart(decl->assigns);
	if (lsNext(gen, &assign, &handle) == LS_OK) {
	    vl_step_bassign_stmt(file, assign);
	    while(lsNext(gen, &assign, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, ", ");
		vl_step_bassign_stmt(file, assign);
	    }
	}
    }
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_netdecl(file, decl)
    FILE *file;
    vl_netdecl *decl;
{

    StpTRACE("Printing Net decl\n");
    switch(decl->type) {
    case WireDecl:
	vl_fprintf_stmt(file, "wire");  	break;
    case TriDecl:
	vl_fprintf_stmt(file, "tri");   	break;
    case Tri0Decl:
	vl_fprintf_stmt(file, "tri0");  	break;
    case Tri1Decl:
	vl_fprintf_stmt(file, "tri1");  	break;
    case Supply0Decl:
	vl_fprintf_stmt(file, "supply0");	break;
    case Supply1Decl:
	vl_fprintf_stmt(file, "supply1");	break;
    case WandDecl:
	vl_fprintf_stmt(file, "wand");  	break;
    case TriandDecl:
	vl_fprintf_stmt(file, "triand");	break;
    case WorDecl:
	vl_fprintf_stmt(file, "wor");   	break;
    case TriorDecl:
	vl_fprintf_stmt(file, "trior"); 	break;
    case TriregDecl:
	vl_fprintf_stmt(file, "trireg");	break;
    default:
	internal_error("Unexpected Net Decl");	break;
    }
    vl_step_strength(file, decl->strength);
    vl_step_range(file, decl->range);
    vl_step_delay(file, decl->delay);
    vl_step_net_list(file, decl->ids); /* assignments or ids */
    vl_fprintf_stmt(file, ";\n");

}

void vl_step_task(file, task)
    FILE *file;
    vl_task *task;
{

    StpTRACE("Printing Task\n");
    ASSERT(task->type == TaskDecl, "Unexpected Task Type");
    
    vl_fprintf_stmt(file, "\ntask ");
    vl_step_id_range(file, task->name);
    vl_fprintf_stmt(file, ";\n");
    vl_step_decl_list(file, task->decls);
    vl_step_stmt_list(file, task->stmts);
    vl_fprintf_stmt(file, "endtask\n");
}

void vl_step_function(file, func)
    FILE *file;
    vl_function *func;
{

    StpTRACE("Printing Function\n");
    
    vl_fprintf_stmt(file, "\nfunc ");
    switch(func->type) {
    case IntFuncDecl:
	vl_fprintf_stmt(file, "integer ");	break;
    case RealFuncDecl:
	vl_fprintf_stmt(file, "real "); 	break;
    case RangeFuncDecl:
	vl_step_range(file, func->range);	break;
    default:
	internal_error("Unexpected Function Type");
    }
    vl_step_id_range(file, func->name);
    vl_fprintf_stmt(file, ";\n");
    vl_step_decl_list(file, func->decls);
    vl_step_stmt_list(file, func->stmts);
    vl_fprintf_stmt(file, "endfunction\n");
}

void vl_step_gate_inst_list(file, gatelist)
    FILE *file;
    vl_gate_inst_list *gatelist;
{

    StpTRACE("Printing Gate Instance List\n");
    switch(gatelist->type) {
    case AndGate:
	vl_fprintf_stmt(file, "and");	break;
    case NandGate:
	vl_fprintf_stmt(file, "nand");	break;
    case OrGate:
	vl_fprintf_stmt(file, "or");	break;
    case NorGate:
	vl_fprintf_stmt(file, "nor");	break;
    case XorGate:
	vl_fprintf_stmt(file, "xor");	break;
    case XnorGate:
	vl_fprintf_stmt(file, "xnor");	break;
    case BufGate:
	vl_fprintf_stmt(file, "buf");	break;
    case Bufif0Gate:
	vl_fprintf_stmt(file, "bufif0");	break;
    case Bufif1Gate:
	vl_fprintf_stmt(file, "bufif1");	break;
    case NotGate:
	vl_fprintf_stmt(file, "not");	break;
    case Notif0Gate:
	vl_fprintf_stmt(file, "notif0");	break;
    case Notif1Gate:
	vl_fprintf_stmt(file, "notif1");	break;
    case PulldownGate:
	vl_fprintf_stmt(file, "pulldown");	break;
    case PullupGate:
	vl_fprintf_stmt(file, "pullup");	break;
    case NmosGate:
	vl_fprintf_stmt(file, "nmos");	break;
    case RnmosGate:
	vl_fprintf_stmt(file, "rnmos");	break;
    case PmosGate:
	vl_fprintf_stmt(file, "pmos");	break;
    case RpmosGate:
	vl_fprintf_stmt(file, "rpmos");	break;
    case CmosGate:
	vl_fprintf_stmt(file, "cmos");	break;
    case RcmosGate:
	vl_fprintf_stmt(file, "rcmos");	break;
    case TranGate:
	vl_fprintf_stmt(file, "tran");	break;
    case RtranGate:
	vl_fprintf_stmt(file, "rtran");	break;
    case Tranif0Gate:
	vl_fprintf_stmt(file, "tranif0");	break;
    case Rtranif0Gate:
	vl_fprintf_stmt(file, "rtranif0");	break;
    case Tranif1Gate:
	vl_fprintf_stmt(file, "tranif1");	break;
    case Rtranif1Gate:
	vl_fprintf_stmt(file, "rtranif1");	break;
    default:
	internal_error("Unexpected Gate Type");	break;
    }
    vl_fprintf_stmt(file, " ");
    vl_step_strength(file, gatelist->strength);
    vl_step_delay(file, gatelist->delays);
    vl_step_gates(file, gatelist->gates);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_gates(file, gates)
    FILE *file;
    lsList gates;
{
    vl_gate_inst *gate;
    lsHandle handle;
    lsGen gen;

    StpTRACE("Printing Gate Instances\n");
    gen = lsStart(gates);
    if (lsNext(gen, &gate, &handle) == LS_OK) {
	vl_step_gate(file, gate);    
	while(lsNext(gen, &gate, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_gate(file, gate);
	}
    }
    (void) lsFinish(gen);
}

void vl_step_prim_inst_list(file, primlist)
    FILE *file;
    vl_mod_prim_inst_list *primlist;
{

    StpTRACE("Printing Primitive Instance List\n");

    vl_step_id_range(file, primlist->name);
    vl_step_strength(file, primlist->strength);
    vl_step_delay(file, primlist->delays);
    vl_step_prims(file, primlist->mps);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_prims(file, prims)
    FILE *file;
    lsList prims;
{
    vl_mod_prim_inst *prim;
    lsHandle handle;
    lsGen gen;

    StpTRACE("Printing Primitive Instances\n");
    gen = lsStart(prims);
    if (lsNext(gen, &prim, &handle) == LS_OK) {
	vl_step_prim(file, prim);    
	while(lsNext(gen, &prim, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_prim(file, prim);
	}
    }
    (void) lsFinish(gen);
}

void vl_step_mod_inst_list(file, modinstlist)
    FILE *file;
    vl_mod_prim_inst_list *modinstlist;
{

    StpTRACE("Printing Module Instance List\n");

    vl_step_id_range(file, modinstlist->name);
    vl_fprintf_stmt(file, " ");
    vl_step_param_vals(file, modinstlist->delays);
    vl_step_mod_insts(file, modinstlist->mps);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_mod_insts(file, modinsts)
    FILE *file;
    lsList modinsts;
{
    vl_mod_prim_inst *modinst;
    lsHandle handle;
    lsGen gen;

    StpTRACE("Printing Module Instances\n");
    gen = lsStart(modinsts);
    if (lsNext(gen, &modinst, &handle) == LS_OK) {
	vl_step_modinst(file, modinst);    
	while(lsNext(gen, &modinst, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_modinst(file, modinst);
	}
    }
    (void) lsFinish(gen);
}

/* Create Process statement: always or initial */
void vl_step_procstmt(file, pstmt)
    FILE *file;
    vl_procstmt *pstmt;
{
    StpTRACE("Printing Process stmt\n");
    switch(pstmt->type) {
    case AlwaysStmt:
	vl_fprintf_stmt(file, "always\n");  
	break;
    case InitialStmt:
	vl_currentModule->flags |= WithInitial;
	vl_fprintf_stmt(file, "initial\n"); break;
    default:
	internal_error("Unexpected Process Statement Type");	break;
    }
    vl_step_stmt(file, pstmt->stmt);
}

void vl_step_begin_end_stmt(file, bestmt)
    FILE *file;
    vl_begin_end_stmt *bestmt;
{

    StpTRACE("Printing beginend\n");
    ASSERT(bestmt->type == BeginEndStmt, "Unexpected BeginEndStmt Type");

    vl_fprintf_stmt(file, "begin\n");
    vl_step_decl_list(file, bestmt->decls);
    vl_step_stmt_list(file, bestmt->stmts);
    vl_fprintf_stmt(file, "end\n");
}

void vl_step_if_else_stmt(file, stmt)
    FILE *file;
    vl_if_else_stmt *stmt;
{

    StpTRACE("Printing if_else_stmt\n");
    ASSERT(stmt->type == IfElseStmt, "Unexpected IfElseStmt Type");
    vl_currentModule->syndrome_width++;

    vl_fprintf_stmt(file, "if (");
    vl_step_expr(file, stmt->cond);
    vl_fprintf_stmt(file, ")\n");
    vl_step_stmt(file, stmt->if_stmt);
    if (stmt->else_stmt) {
	vl_fprintf_stmt(file, "else\n");
	vl_step_stmt(file, stmt->else_stmt);
    }
}

void vl_step_case_stmt(file, stmt)
    FILE *file;
    vl_case_stmt *stmt;
{

    StpTRACE("Printing case_stmt\n");

    switch(stmt->type) {
    case CaseStmt:
	vl_fprintf_stmt(file, "case ("); 	break;
    case CasexStmt:
	vl_fprintf_stmt(file, "casex (");	break;
    case CasezStmt:
	vl_fprintf_stmt(file, "casez (");	break;
    default:
	internal_error("Unexpected Case Type");	break;
    }
    vl_step_expr(file, stmt->cond);
    vl_fprintf_stmt(file, ")\n");
    /* foreach case_item, print */
    {
	vl_case_item *item;
	lsHandle handle;
	lsGen gen;
	
	gen = lsStart(stmt->case_items);
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    vl_step_case_item(file, item);    
	    while(lsNext(gen, &item, &handle) != LS_NOMORE) {
		vl_step_case_item(file, item);
	    }
	}
    }
    vl_fprintf_stmt(file, "endcase\n");
}

void vl_step_forever_stmt(file, stmt)
    FILE *file;
    vl_forever_stmt *stmt;
{
    StpTRACE("Printing forever_stmt\n");
    ASSERT(stmt->type == ForeverStmt, "Unexpected ForeverStmt Type");

    vl_fprintf_stmt(file, "forever\n");
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_repeat_stmt(file, stmt)
    FILE *file;
    vl_repeat_stmt *stmt;
{
    StpTRACE("Printing repeat_stmt\n");
    ASSERT(stmt->type == RepeatStmt, "Unexpected RepeatStmt Type");

    vl_fprintf_stmt(file, "repeat (");
    vl_step_expr(file, stmt->count);
    vl_fprintf_stmt(file, ")\n");
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_while_stmt(file, stmt)
    FILE *file;
    vl_while_stmt *stmt;
{
    StpTRACE("Printing while_stmt\n");
    ASSERT(stmt->type == WhileStmt, "Unexpected WhileStmt Type");

    vl_fprintf_stmt(file, "while (");
    vl_step_expr(file, stmt->cond);
    vl_fprintf_stmt(file, ")\n");
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_for_stmt(file, stmt)
    FILE *file;
    vl_for_stmt *stmt;
{

    StpTRACE("Printing for_stmt\n");
    ASSERT(stmt->type == ForStmt, "Unexpected ForStmt Type");

    vl_fprintf_stmt(file, "for (");
    vl_step_bassign_stmt(file, stmt->init);
    vl_fprintf_stmt(file, "; ");
    vl_step_expr(file, stmt->cond);
    vl_fprintf_stmt(file, "; ");
    vl_step_bassign_stmt(file, stmt->end);
    vl_fprintf_stmt(file, ")\n");
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_delay_control_stmt(file, stmt)
    FILE *file;
    vl_delay_control_stmt *stmt;
{

    StpTRACE("Printing delay_control_stmt\n");
    ASSERT(stmt->type == DelayControlStmt, "Unexpected DelayControlStmt Type");

    vl_step_delay(file, stmt->delay);
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_event_control_stmt(file, stmt)
    FILE *file;
    vl_event_control_stmt *stmt;
{

    StpTRACE("Printing event_control_stmt\n");
    ASSERT(stmt->type == EventControlStmt, "Unexpected EventControlStmt Type");

    vl_fprintf_stmt(file, "@(");
    vl_step_event_expr(file, stmt->event);
    vl_fprintf_stmt(file, ")");
    vl_step_stmt(file, stmt->stmt);
}

/* Print an assignment, with a possible delay or event control in it */
void vl_step_bassign_stmt(file, bassign)
    FILE *file;
    vl_bassign_stmt *bassign;
{
    StpTRACE("Printing bassign_stmt\n");
    
    if (bassign->type == AssignStmt) {
	vl_fprintf_stmt(file, "assign ");
    }
    vl_step_lval(file, bassign->lhs);
    switch(bassign->type) {
    case AssignStmt:
    case BassignStmt:
	vl_fprintf_stmt(file, " = ");	
	break;
    case NbassignStmt:
	vl_fprintf_stmt(file, " <= "); 
	collect_latch(bassign->lhs->name->name);
	break;
    case DelayBassignStmt:
	vl_fprintf_stmt(file, " = ");	
	vl_step_delay(file, (vl_delay *)bassign->control);
	break;
    case DelayNbassignStmt:
	vl_fprintf_stmt(file, " <= ");	
	vl_step_delay(file, (vl_delay *)bassign->control);
	collect_latch(bassign->lhs->name->name);
	break;
    case EventBassignStmt:
	vl_fprintf_stmt(file, " = @(");
	vl_step_event_expr(file, (vl_event_expr *)bassign->control);
	vl_fprintf_stmt(file, ")");
	break;
    case EventNbassignStmt:
	vl_fprintf_stmt(file, " <= @(");	
	vl_step_event_expr(file, (vl_event_expr *)bassign->control);
	vl_fprintf_stmt(file, ")");
	collect_latch(bassign->lhs->name->name);
	break;
    default:
	internal_error("Unexpected Assign Type");	break;
    }
    vl_step_expr(file, bassign->rhs);
}

void vl_step_wait_stmt(file, stmt)
    FILE *file;
    vl_wait_stmt *stmt;
{

    StpTRACE("Printing wait_stmt\n");
    ASSERT(stmt->type == WaitStmt, "Unexpected WaitStmt Type");

    vl_fprintf_stmt(file, "wait (");
    vl_step_expr(file, stmt->cond);
    vl_fprintf_stmt(file, ")\n");
    vl_step_stmt(file, stmt->stmt);
}

void vl_step_fork_join_stmt(file, stmt)
    FILE *file;
    vl_fork_join_stmt *stmt;
{

    StpTRACE("Printing fork_join_stmt\n");
    ASSERT(stmt->type == ForkJoinStmt, "Unexpected ForkJoinStmt Type");

    vl_fprintf_stmt(file, "fork\n");
    vl_step_decl_list(file, stmt->decls);
    vl_step_stmt_list(file, stmt->stmts);
    vl_fprintf_stmt(file, "join\n");
}


void vl_step_task_enable_stmt(file, stmt)
    FILE *file;
    vl_task_enable_stmt *stmt;
{

    StpTRACE("Printing task_enable_stmt\n");
    ASSERT(((stmt->type == TaskEnableStmt) || 
	    (stmt->type == SysTaskEnableStmt)), 
	   "Unexpected TaskEnableStmt Type");

    vl_step_id_range(file, stmt->name);
    if (stmt->args) {		/* only print if arguments exist */
	vl_fprintf_stmt(file, " (");
	vl_step_expr_list(file, stmt->args); /* comma separated list */
	vl_fprintf_stmt(file, " )");
    }
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_disable_stmt(file, stmt)
    FILE *file;
    vl_disable_stmt *stmt;
{
    StpTRACE("Printing disable_stmt\n");
    ASSERT(stmt->type == DisableStmt, "Unexpected DisableStmt Type");

    vl_fprintf_stmt(file, "disable ");
    vl_step_id_range(file, stmt->name);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_deassign_stmt(file, stmt)
    FILE *file;
    vl_deassign_stmt *stmt;
{
    StpTRACE("Printing deassign_stmt\n");
    ASSERT(stmt->type == DeassignStmt, "Unexpected DeassignStmt Type");

    vl_fprintf_stmt(file, "deassign ");
    vl_step_lval(file, stmt->lhs);
    vl_fprintf_stmt(file, ";\n");
}

void vl_step_case_item(file, item)
    FILE *file;
    vl_case_item *item;
{
    StpTRACE("Printing case_item\n");
    switch(item->type) {
    case CaseItem:
	vl_currentModule->syndrome_width++;
	vl_step_expr_list(file, item->exprs); 
	vl_fprintf_stmt(file, ": ");
	break;
    case DefaultItem:
	vl_fprintf_stmt(file, "default: ");
	break;
    default:
	internal_error("Unexpected CaseItem Type");
	break;
    }
    vl_step_stmt(file, item->stmt);
}

void vl_step_event_expr(file, event)
    FILE *file;
    vl_event_expr *event;
{
    StpTRACE("Printing event_expr\n");
    if (event == NIL(vl_event_expr)) return;
    switch(event->type) {
    case OrEventExpr:  {
	vl_event_expr *e;
	lsHandle handle;
	lsGen gen;

	gen = lsStart(event->list);
	if (lsNext(gen, &e, &handle) == LS_OK) {
	    vl_step_event_expr(file, e);    
	    while(lsNext(gen, &e, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, " or ");
		vl_step_event_expr(file, e);
	    }
	}
	(void) lsFinish(gen);
	break;
    }
    case NegedgeEventExpr:
	vl_fprintf_stmt(file, "negedge ");
	vl_step_expr(file, event->expr);
	break;
    case PosedgeEventExpr:
	vl_fprintf_stmt(file, "posedge ");
	vl_step_expr(file, event->expr);
	break;
    case EdgeEventExpr:
	vl_fprintf_stmt(file, "edge ");
	vl_step_expr(file, event->expr);
	break;
    case EventExpr:
	vl_step_expr(file, event->expr);	
	break;
    default:
	internal_error("Unexpected EventExpr Type");	
	break;
    }

    /* all clock should be the same signal withing a module */
    /* besides, only @(*edge clk) is allowed                */
    if (!vl_currentModule->clk)
	vl_currentModule->clk = event->expr->u.name;
    else if (!strcmp(vl_currentModule->clk->name,event->expr->u.name)) {
	char msg[MAXSTRLEN];
	
	sprintf(msg, "%s is assumed to be clock, %s is redefined",
		vl_currentModule->clk->name,
		event->expr->u.name->name);
	Translate_Warning(msg);
    }
}

void vl_step_lval(file, lval)
    FILE *file;
    vl_lval *lval;
{
    vl_id_range *id_sym;

    StpTRACE("Printing lval\n");

    switch(lval->type) {
    case IDExpr:
	vl_step_id_range(file, lval->name);
	break;
    case BitSelExpr:
    case PartSelExpr:
	vl_step_id_range(file, lval->name);
	vl_step_range(file, lval->range);
	break;
    case ConcatExpr: {
	vl_expr *e;
	lsHandle handle;
	lsGen gen;
	
	vl_fprintf_stmt(file, "{");	
	gen = lsStart(lval->concat);
	if (lsNext(gen, &e, &handle) == LS_OK) {
	    vl_step_expr(file, e);    
	    while(lsNext(gen, &e, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, ", ");
		vl_step_expr(file, e);
	    }
	}
	vl_fprintf_stmt(file, "}");	
	(void) lsFinish(gen);
	
	break;
    }
    default:
	internal_error("Unexpected Lval Type");
	break;
    }
}

void vl_step_expr(file, expr)
    FILE *file;
    vl_expr *expr;
{
    if (!expr) return;
    StpTRACE("Printing expr\n");
    switch (expr->type) {
    case BitExpr:
	vl_fprintf_stmt(file, "'b%s", expr->u.exprs.e3);
	break;
    case IntExpr:
	vl_fprintf_stmt(file, "%d", expr->u.intval);
	break;
    case RealExpr:
	vl_fprintf_stmt(file, "%f", expr->u.realval);
	break;
    case IDExpr:
	vl_step_id_range(file, expr->u.name);
	break;
    case BitSelExpr:    case PartSelExpr:
	vl_step_id_range(file, expr->u.idrng);
	break;
    case ConcatExpr: {
	/* print all in list */
	vl_expr *e;
	lsHandle handle;
	lsGen gen;

	vl_fprintf_stmt(file, "{");	
	gen = lsStart((lsList)(expr->u.exprs.e1));
	if (lsNext(gen, &e, &handle) == LS_OK) {
	    vl_step_expr(file, e);    
	    while(lsNext(gen, &e, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, ", ");
		vl_step_expr(file, e);
	    }
	}
	vl_fprintf_stmt(file, "}");	
	(void) lsFinish(gen);
	break;			/* use next field for concat exprs */
    }
    case MinTypMaxExpr: {
	/* print one or three in list */
	vl_expr *e;
	lsHandle handle;
	lsGen gen;

	vl_fprintf_stmt(file, "(");
	vl_step_expr(file, expr->u.exprs.e1);
	if (expr->u.exprs.e2) {
	    vl_fprintf_stmt(file, ":");
	    vl_step_expr(file, expr->u.exprs.e2);
	}
	if (expr->u.exprs.e3) {
	    vl_fprintf_stmt(file, ":");
	    vl_step_expr(file, expr->u.exprs.e3);
	}
	vl_fprintf_stmt(file, ")");
	break;			/* use next field for other exprs */
    }
    case StringExpr:
	vl_fprintf_stmt(file, "%s", expr->u.string);
	break;
    case FuncExpr:
	vl_step_id_range(file, expr->u.func_call.name);
	if (expr->u.func_call.args) {
	    vl_fprintf_stmt(file, " (");
	    vl_step_expr_list(file, expr->u.func_call.args);
	    vl_fprintf_stmt(file, ") ");
	}
	break;
    case UplusExpr:    case UminusExpr:
    case UnotExpr:    case UcomplExpr:
    /* Unary Reduction Operators */
    case UandExpr:    case UnandExpr:
    case UorExpr:    case UnorExpr:
    case UxorExpr:    case UxnorExpr:
	vl_fprintf_stmt(file, "%s", vl_get_expr_op(expr->type));
	vl_step_expr(file, expr->u.exprs.e1);
	break;
    /* Binary Operators */
    case BplusExpr:    case BminusExpr:
    case BtimesExpr:    case BdivExpr:
    case BremExpr:    case Beq2Expr:
    case Bneq2Expr:    case Beq3Expr:
    case Bneq3Expr:    case BlandExpr:
    case BlorExpr:    case BltExpr:
    case BleExpr:   case BgtExpr:
    case BgeExpr:    case BandExpr:
    case BorExpr:    case BxorExpr:
    case BxnorExpr:    case BlshiftExpr:
    case BrshiftExpr:
	vl_step_expr(file, expr->u.exprs.e1);
	vl_fprintf_stmt(file, " %s ", vl_get_expr_op(expr->type));
	vl_step_expr(file, expr->u.exprs.e2);
	break;
    /* ternary operators */
    case TcondExpr:
	vl_step_expr(file, expr->u.exprs.e1);
	vl_fprintf_stmt(file, " ? ");
	vl_step_expr(file, expr->u.exprs.e2);
	vl_fprintf_stmt(file, " : ");
	vl_step_expr(file, expr->u.exprs.e3);
	break;
    }
}

/* traverse a comma separated list of expressions */
void vl_step_expr_list(file, exprs)
    FILE *file;
    lsList exprs;
{
    void *expr;
    lsHandle handle;
    lsGen gen;
    
    StpTRACE("Printing Expression List\n");
    gen = lsStart(exprs);
    if (lsNext(gen, &expr, &handle) == LS_OK) {
	vl_step_expr(file, expr);    
	while(lsNext(gen, &expr, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ",");
	    vl_step_expr(file, expr);
	}
    }
    (void) lsFinish(gen);

}

void vl_step_range(file, range)
    FILE *file;
    vl_range *range;
{
    StpTRACE("Printing range\n");

    if (range == NIL(vl_range) || 
	(range->left == NIL(vl_expr) && range->right == NIL(vl_expr))) return;
    vl_fprintf_stmt(file, "[");
    vl_step_expr(file, range->left);
    if (range->right) {
	vl_fprintf_stmt(file, " : ");
	vl_step_expr(file, range->right);
    }
    vl_fprintf_stmt(file, "]");
}

/* Print a delay expression.  Each may be a MinTypMax expression */
void vl_step_delay(file, delay)
    FILE *file;
    vl_delay *delay;
{
    StpTRACE("Printing delay\n");
    if (delay == NIL(vl_delay)) return;
    vl_fprintf_stmt(file, " #(");
    vl_step_expr(file, delay->delay1);
    if (delay->delay2) {
	vl_fprintf_stmt(file, ", ");
	vl_step_expr(file, delay->delay2);
	if (delay->delay3) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_expr(file, delay->delay3);
	}
    }
    vl_fprintf_stmt(file, ") ");
}




/* void vl_step_id: create location for an ID and put name in it.
   Return the new ID.
   It is the responsibility of the caller to put name in permanent storage
*/
void vl_step_id_range(file, id_range)
    FILE *file;
    vl_id_range *id_range;
{
    StpTRACE("Printing id[range]\n");
    if (id_range == NIL(vl_id_range)) return;
    vl_fprintf_stmt(file, "%s", id_range->name);
    if (id_range->range == NIL(vl_range)) return;
    vl_step_range(file, id_range->range);
}


/* Print a comma separated list of identifiers */
void vl_step_id_list(file, ids)
    FILE *file;
    lsList ids;
{
    vl_id_range *id;
    lsHandle handle;
    lsGen gen;

    gen = lsStart(ids);
    if (lsNext(gen, &id, &handle) == LS_OK) {
	vl_step_id_range(file, id);    
	while(lsNext(gen, &id, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_id_range(file, id);
	}
    }
    (void) lsFinish(gen);
}

/* Print a comma separated list of identifiers */
void vl_step_id_range_list(file, ids)
    FILE *file;
    lsList ids;
{
    vl_id_range *id;
    lsHandle handle;
    lsGen gen;

    if (ids == (lsList)0) return;
    gen = lsStart(ids);
    if (lsNext(gen, &id, &handle) == LS_OK) {
	vl_step_id_range(file, id);    
	while(lsNext(gen, &id, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_id_range(file, id);
	}
    }
    (void) lsFinish(gen);
}

/* Print comma separated list of nets */
void vl_step_net_list(file, nets)
    FILE *file;
    lsList nets;
{
    void *net;
    lsHandle handle;
    lsGen gen;

    gen = lsStart(nets);
    if (lsNext(gen, &net, &handle) == LS_OK) {
	vl_step_net(file, net);
	while(lsNext(gen, &net, &handle) != LS_NOMORE) {
	    vl_fprintf_stmt(file, ", ");
	    vl_step_net(file, net);
	}
    }
    (void) lsFinish(gen);
}

/* Print a single net.  May be of type BassignStmt or IDExpr */
void vl_step_net(file, net)
    FILE *file;
    void *net;
{    
    switch(((vl_expr *)net)->type) {
    case BassignStmt:
	vl_step_bassign_stmt(file, net);	   break;
    case IDExpr:
	vl_step_expr(file, net);	           break;
    default:
	vl_step_id_range(file, (vl_id_range*)net); break;
    }
}

/* print the port list of a module or primitive */
void vl_step_ports (file, ports)
    FILE *file ;
    lsList ports;
{
    void *item;
    lsHandle handle;
    lsGen gen;

    vl_fprintf_stmt(file, "(");
    /* print each expression in the list, comma separated */
    if (ports != (lsList)0) {
	gen = lsStart(ports);
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    vl_step_port(file, item);
	    while (lsNext(gen, &item, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, ",");
		vl_step_port(file, item);
	    }
	}
    }
    vl_fprintf_stmt(file, ")");
    (void) lsFinish(gen);
}

void vl_step_port(file, port)
    FILE *file;
    vl_portPtr port;
{
    if (port->type == NamedPort) {
	vl_fprintf_stmt(file, ".");
	vl_step_id_range(file, port->id);
	vl_fprintf_stmt(file, "(");
    }

    vl_step_id_range_list(file, port->port_exp);

    if (port->type == NamedPort) {
	vl_fprintf_stmt(file, ")");
    }
}

/* print the port connection list of a module or primitive */
void vl_step_connects (file, connects)
    FILE *file ;
    lsList connects;
{
    void *item;
    lsHandle handle;
    lsGen gen;

    /* print each expression in the list, comma separated */
    if (connects != (lsList)0) {
	gen = lsStart(connects);
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    vl_step_port_connect(file, (vl_port_connectPtr)item);
	    while (lsNext(gen, &item, &handle) != LS_NOMORE) {
		vl_fprintf_stmt(file, ",");
		vl_step_port_connect(file, (vl_port_connectPtr)item);
	    }
	}
    }
    (void) lsFinish(gen);
}

void vl_step_port_connect(file, connect)
    FILE *file;
    vl_port_connectPtr connect;
{
    if (connect->type == NamedConnect) {
	vl_fprintf_stmt(file, ".");
	vl_step_id_range(file, connect->id);
	vl_fprintf_stmt(file, "(");
    }

    vl_step_expr(file, connect->expr);

    if (connect->type == NamedConnect) {
	vl_fprintf_stmt(file, ")");
    }
}

/* foreach mod item, print it */
void vl_step_mod_item_list (file, mitems)
    FILE *file ;
    lsList mitems;
{
    void *item;
    lsHandle handle;
    lsGen gen;
    
    StpTRACE("Printing Module Items\n");
    if (mitems != (lsList)0) {
	gen = lsStart(mitems);
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    vl_step_mod_item(file, item);    
	    while(lsNext(gen, &item, &handle) != LS_NOMORE) {
		vl_step_mod_item(file, item);
	    }
	}
    }
    (void) lsFinish(gen);
}

/* Print one of the module item types */
void vl_step_mod_item(file, item)
    FILE *file;
    void *item;
{
    st_table *var_touched;
    
    switch(((vl_decl *)item)->type) {

    case RealDecl:  	case EventDecl:
	vl_step_basicdecl(file, (vl_decl *)item);
	break;

    case IntDecl:   	case TimeDecl:
	vl_step_basicdecl(file, (vl_decl *)item);
	break;

    case InputDecl: 	case OutputDecl:
    case InoutDecl: 	case RegDecl:
	vl_step_rangedecl(file, (vl_rangedecl *)item);
	break;	    

    case ParamDecl: 	case DefparamDecl:
	vl_step_paramdecl(file, (vl_paramdecl *)item);
	break;
	/* NetDecl: a net with strength, delay, assignment */
    case WireDecl:  	case TriDecl:
    case Tri0Decl:  	case Tri1Decl:
    case Supply0Decl:	case Supply1Decl:
    case WandDecl:  	case TriandDecl:
    case WorDecl:   	case TriorDecl:
    case TriregDecl:
	vl_step_netdecl(file, (vl_netdecl *)item);
	break;
	
    case ContAssign:
	vl_step_cont_assign(file, (vl_cont_assign *)item);
	break;

    case TaskDecl:
	vl_step_task(file, (vl_task *)item);
	break;
	    
    case IntFuncDecl:	case RealFuncDecl:
    case RangeFuncDecl:
	vl_step_function(file, (vl_function *)item);
	break;
	    
    case AndGate:   	case NandGate:
    case OrGate:    	case NorGate:
    case XorGate:   	case XnorGate:
    case BufGate:   	case Bufif0Gate:
    case Bufif1Gate:	case NotGate:
    case Notif0Gate:	case Notif1Gate:
    case PulldownGate:	case PullupGate:
    case NmosGate:  	case RnmosGate:
    case PmosGate:  	case RpmosGate:
    case CmosGate:  	case RcmosGate:
    case TranGate:  	case RtranGate:
    case Tranif0Gate: 	case Rtranif0Gate:
    case Tranif1Gate:	case Rtranif1Gate:
	vl_step_gate_inst_list(file, (vl_gate_inst_list *)item);
	break;

    case PrimInst:
	vl_step_prim_inst_list(file, (vl_mod_prim_inst_list *)item);
	break;

    case ModInst:
	vl_step_mod_inst_list(file, (vl_mod_prim_inst_list *)item);
	break;
	    
    case AlwaysStmt:
    case InitialStmt:
	vl_step_procstmt(file, (vl_procstmt *)item);
	break;
	    
    default:
	internal_error("Unexpected Moduel Item");
	break;
    }
}


void vl_step_decl_list (file, decls)
    FILE *file ;
    void *decls;
{
    void *decl;
    lsHandle handle;
    lsGen gen;
    
    StpTRACE("Printing Decls\n");
    if (decls == NIL(void)) return;
    gen = lsStart(decls);
    if (lsNext(gen, &decl, &handle) == LS_OK) {
	vl_step_decl(file, decl);    
	while(lsNext(gen, &decl, &handle) != LS_NOMORE) {
	    vl_step_decl(file, decl);
	}
    }
    (void) lsFinish(gen);

}

void vl_step_stmt_list (file, stmts)
    FILE *file ;
    void *stmts;
{
    void *stmt;
    lsHandle handle;
    lsGen gen;
    
    StpTRACE("Printing Statements\n");
    gen = lsStart(stmts);
    if (lsNext(gen, &stmt, &handle) == LS_OK) {
	vl_step_stmt(file, stmt);    
	while(lsNext(gen, &stmt, &handle) != LS_NOMORE) {
	    vl_step_stmt(file, stmt);
	}
    }
    (void) lsFinish(gen);

}

void vl_step_strength (file, s)
    FILE *file ;
    int s;
{
    vl_fprintf_stmt(file, "%s", vl_get_strength(s));
}

/* print a single instance of a gate or the form "name (t1, t2, ...)" */
void vl_step_gate (file, gate)
    FILE *file ;
    vl_gate_inst *gate;
{
    vl_step_id_range(file, gate->name);
    vl_fprintf_stmt(file, "(");
    vl_step_expr_list(file, gate->terms); /* comma separated list of exprs */
    vl_fprintf_stmt(file, ")");
}

void vl_step_prim (file, prim)
    FILE *file ;
    vl_mod_prim_inst *prim;
{
    vl_step_id_range(file, prim->name);
    vl_fprintf_stmt(file, "(");
    vl_step_expr_list(file, prim->ports); /* comma separated list of exprs */
    vl_fprintf_stmt(file, ")");
}

void vl_step_param_vals (file, param_vals)
    FILE *file ;
    vl_expr *param_vals;
{
    if (param_vals == NIL(vl_expr)) return;

    vl_fprintf_stmt(file, "#(");
    vl_step_expr_list(file, param_vals);
    vl_fprintf_stmt(file, ")");
}

void vl_step_modinst (file, mod)
    FILE *file ;
    vl_mod_prim_inst *mod;
{
    vl_step_id_range(file, mod->name);
    /* print ( <list_of_expression_or_NULL> ) */
    vl_fprintf_stmt(file, " (");
    vl_step_connects(file, mod->ports);
    vl_fprintf_stmt(file, ") ");
}
    
void vl_step_stmt (file, stmt)
    FILE *file ;
    void *stmt;
{
/* to be done */
    if (stmt == NIL(void)) {
	vl_fprintf_stmt(file, ";\n");
	return;
    }
    switch(((vl_bassign_stmt *)stmt)->type) {
    case BeginEndStmt:
	vl_step_begin_end_stmt(file, (vl_begin_end_stmt *)stmt);
	break;
    case IfElseStmt:
	vl_step_if_else_stmt(file, (vl_if_else_stmt *)stmt);
	break;
    case CaseStmt:
    case CasexStmt:
    case CasezStmt:
	vl_step_case_stmt(file, (vl_case_stmt *)stmt);
	break;
    case CaseItem:
	vl_step_stmt(file, ((vl_case_item *)stmt)->stmt);
	break;
    case DefaultItem:
	vl_step_stmt(file, ((vl_case_item *)stmt)->stmt);
	break;
    case ForeverStmt:
	vl_step_forever_stmt(file, (vl_forever_stmt *)stmt);
	break;
    case RepeatStmt:
	vl_step_repeat_stmt(file, (vl_repeat_stmt *)stmt);
	break;
    case WhileStmt:
	vl_step_while_stmt(file, (vl_while_stmt *)stmt);
	break;
    case ForStmt:
	vl_step_for_stmt(file, (vl_for_stmt *)stmt);
	break;
    case DelayControlStmt:
	vl_step_delay_control_stmt(file, (vl_delay_control_stmt *)stmt);
	break;
    case EventControlStmt:
	vl_step_event_control_stmt(file, (vl_event_control_stmt *)stmt);
	break;
    case AssignStmt:
    case BassignStmt:
    case NbassignStmt:
    case DelayBassignStmt:
    case DelayNbassignStmt:
    case EventBassignStmt:
    case EventNbassignStmt:
	vl_step_bassign_stmt(file, (vl_bassign_stmt *)stmt);
	vl_fprintf_stmt(file, ";\n");
	break;
    case WaitStmt:
	vl_step_wait_stmt(file, (vl_wait_stmt *)stmt);
	break;
    case ForkJoinStmt:
	vl_step_fork_join_stmt(file, (vl_fork_join_stmt *)stmt);
	break;
    case TaskEnableStmt:
    case SysTaskEnableStmt:
	vl_step_task_enable_stmt(file, (vl_task_enable_stmt *)stmt);
	break;
    case DisableStmt:
	vl_step_disable_stmt(file, (vl_disable_stmt *)stmt);
	break;
    case DeassignStmt:
	vl_step_deassign_stmt(file, (vl_deassign_stmt *)stmt);
	break;
    case SendEventStmt:
	vl_fprintf_stmt(file, "-> ");
	vl_step_id_range(file, ((vl_send_event_stmt *)stmt)->name);
        vl_fprintf_stmt(file, ";\n");
	break;
    default: {
	char msg[MAXSTRLEN];
	sprintf(msg, "vl_step_stmt:Unexpected Statement Type %d", 
		((vl_bassign_stmt *)stmt)->type);
	internal_error(msg);
    }
    }
}

void vl_step_decl (file, decl)
    FILE *file ;
    void *decl;
{
    switch(((vl_decl *)decl)->type) {
    case RealDecl:    case EventDecl:    
    case IntDecl:     case TimeDecl:
	vl_step_basicdecl(file, (vl_decl *)decl);
	break;
/*
    case 
	vl_step_arr_decl(file, (vl_arr_decl *)decl);
	break;
*/
    case InputDecl:    case OutputDecl:
    case InoutDecl:    case RegDecl:
	vl_step_rangedecl(file, (vl_rangedecl *)decl);
	break;
    case ParamDecl:    case DefparamDecl:
	vl_step_paramdecl(file, (vl_paramdecl *)decl);
	break;
    case WireDecl:   	case TriDecl:
    case Tri0Decl:    	case Tri1Decl:
    case Supply0Decl:   case Supply1Decl:
    case WandDecl:	case TriandDecl:
    case WorDecl:	case TriorDecl:
    case TriregDecl:
	vl_step_netdecl(file, (vl_netdecl *)decl);
	break;
    default: 
	internal_error("Unexprected Declaration Type");
	break;
    }
}

void vl_step_cont_assign (file, assign)
    FILE *file;
    vl_cont_assign *assign;
{
    vl_fprintf_stmt(file, "assign ");
    vl_step_strength(file, assign->strength);
    vl_step_delay(file, assign->delay);
    vl_step_net_list(file, assign->assigns); /* list of assignments */
    vl_fprintf_stmt(file, ";\n");
}


/* return string corresponding to a primitive edge, level symbol or 
   edge symbol.  
*/
char *vl_get_prim_symbol(sym)
    unsigned char sym;
{
    switch(sym) {
    case PrimNone: return("");
    case Prim0: return("0");
    case Prim1: return("1");	
    case PrimX: return("X");	
    case PrimQ: return("?");
    case PrimR: return("R");
    case PrimF: return("F");
    case PrimP: return("P");
    case PrimN: return("N");
    case PrimS: return("*");
    case PrimM: return("-");
    case PrimB: return("B");
    case Prim0X: return("(0X)");
    case Prim1X: return("(1X)");
    case PrimX0: return("(X0)");
    case PrimX1: return("(X1)");       
    case PrimXB: return("(XB)");
    case PrimBX: return("(BX)");
    case PrimBB: return("(BB)");
    case PrimQ0: return("(?0)");
    case PrimQ1: return("(?1)");
    case PrimQB: return("(?B)");
    default: {
	char msg[MAXSTRLEN];
	sprintf(msg, "Unexpected primitive symbol type %d", sym);
	internal_error(msg); break;
    }
    }
}


/* return string corresponding to a strength value */
char *vl_get_strength(type)
    int type;
{
    switch(type) {
    case 0:
	return("\0");
    case Supply0Supply1:
	return("(supply0, supply1)");	break;
    case Supply0Strong1:
	return("(supply0, strong1)");	break;
    case Supply0Pull1:
	return("(supply0, pull1)");	break;
    case Supply0Weak1:
	return("(supply0, weak1)");	break;
    case Supply0HighZ1:
	return("(supply0, highz1)");	break;
    case Strong0Supply1:
	return("(strong0, supply1)");	break;
    case Strong0Strong1:
	return("(strong0, strong1)");	break;
    case Strong0Pull1:
	return("(strong0, pull1)");	break;
    case Strong0Weak1:
	return("(strong0, weak1)");	break;
    case Strong0HighZ1:
	return("(strong0, highz1)");	break;
    case Pull0Supply1:
	return("(pull0, supply1)");	break;
    case Pull0Strong1:
	return("(pull0, strong1)");	break;
    case Pull0Pull1:
	return("(pull0, pull1)");	break;
    case Pull0Weak1:
	return("(pull0, weak1)");	break;
    case Pull0HighZ1:
	return("(pull0, highz1)");	break;
    case Weak0Supply1:
	return("(weak0, supply1)");	break;
    case Weak0Strong1:
	return("(weak0, strong1)");	break;
    case Weak0Pull1:
	return("(weak0, pull1)");	break;
    case Weak0Weak1:
	return("(weak0, weak1)");	break;
    case Weak0HighZ1:
	return("(weak0, highz1)");	break;
    case HighZ0Supply1:
	return("(highz0, supply1)");	break;
    case HighZ0Strong1:
	return("(highz0, strong1)");	break;
    case HighZ0Pull1:
	return("(highz0, pull1)");	break;
    case HighZ0Weak1:
	return("(highz0, weak1)");	break;
    case HighZ0HighZ1:
	return("(highz0, highz1)");	break;
    case Supply1Supply0:
	return("(supply1, supply0)");	break;
    case Supply1Strong0:
	return("(supply1, strong0)");	break;
    case Supply1Pull0:
	return("(supply1, pull0)");	break;
    case Supply1Weak0:
	return("(supply1, weak0)");	break;
    case Supply1HighZ0:
	return("(supply1, highz0)");	break;
    case Strong1Supply0:
	return("(strong1, supply0)");	break;
    case Strong1Strong0:
	return("(strong1, strong0)");	break;
    case Strong1Pull0:
	return("(strong1, pull0)");	break;
    case Strong1Weak0:
	return("(strong1, weak0)");	break;
    case Strong1HighZ0:
	return("(strong1, highz0)");	break;
    case Pull1Supply0:
	return("(pull1, supply0)");	break;
    case Pull1Strong0:
	return("(pull1, strong0)");	break;
    case Pull1Pull0:
	return("(pull1, pull0)");	break;
    case Pull1Weak0:
	return("(pull1, weak0)");	break;
    case Pull1HighZ0:
	return("(pull1, highz0)");	break;
    case Weak1Supply0:
	return("(weak1, supply0)");	break;
    case Weak1Strong0:
	return("(weak1, strong0)");	break;
    case Weak1Pull0:
	return("(weak1, pull0)");	break;
    case Weak1Weak0:
	return("(weak1, weak0)");	break;
    case Weak1HighZ0:
	return("(weak1, highz0)");	break;
    case HighZ1Supply0:
	return("(highz1, supply0)");	break;
    case HighZ1Strong0:
	return("(highz1, strong0)");	break;
    case HighZ1Pull0:
	return("(highz1, pull0)");	break;
    case HighZ1Weak0:
	return("(highz1, weak0)");	break;
    case HighZ1HighZ0:
	return("(highz1, highz0)");	break;
    case Small:
	return("(small)");	break;
    case Medium:
	return("(medium)");	break;
    case Large:
	return("(large)");	break;
    default: 
	{
	char err_msg[MAXSTRLEN];

	sprintf(err_msg, "Unexpected strength type %d", type);
	internal_error(err_msg);
    }
    }
}

/* return string corresponding to an expression operator */
char *vl_get_expr_op(type)
    int type;
{
    switch(type) {
    /* these expression do not have an operator, return nothing */
    case IDExpr:         case BitSelExpr:
    case PartSelExpr:    case ConcatExpr:
    case MinTypMaxExpr:  case IntExpr:
    case RealExpr:       case StringExpr:
    case FuncExpr:
	return("");	break;
    case UplusExpr:
	return("+");	break;
    case UminusExpr:
	return("-");	break;
    case UnotExpr:
	return("!");	break;
    case UcomplExpr:
	return("~");	break;
    case UandExpr:
	return("&");	break;
    case UnandExpr:
	return("~&");	break;
    case UorExpr:
	return("|");	break;
    case UnorExpr:
	return("~|");	break;
    case UxorExpr:
	return("^");	break;
    case UxnorExpr:
	return("~^");	break;
    case BplusExpr:
	return("+");	break;
    case BminusExpr:
	return("-");	break;
    case BtimesExpr:
	return("*");	break;
    case BdivExpr:
	return("/");	break;
    case BremExpr:
	return("%");	break;
    case Beq2Expr:
	return("==");	break;
    case Bneq2Expr:
	return("!=");	break;
    case Beq3Expr:
	return("===");	break;
    case Bneq3Expr:
	return("!==");	break;
    case BlandExpr:
	return("&&");	break;
    case BlorExpr:
	return("||");	break;
    case BltExpr:
	return("<");	break;
    case BleExpr:
	return("<=");	break;
    case BgtExpr:
	return(">");	break;
    case BgeExpr:
	return(">=");	break;
    case BandExpr:
	return("&");	break;
    case BorExpr:
	return("|");	break;
    case BxorExpr:
	return("^");	break;
    case BxnorExpr:
	return("~^");	break;
    case BlshiftExpr:
	return("<<");	break;
    case BrshiftExpr:
	return(">>");	break;
    /* ternary operator has two operators, "?" and ":".  Return the first */
    case TcondExpr:
	return("?");	break;
    default:
	internal_error("Unexpected expression type");	break;
    }
}

m->ports); /* comma separated list of exprs */
    vl_fprintf_stmt(file, ")");
}

void vl_step_param_vals (fivl2mv/src/parser/vl_write.c                                                                         100644  027004  000214  00000326407 05332024430 013163  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* 
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/vl_write.c,v 1.1 1993/01/15 19:43:28 stcheng Exp stcheng $
 * $Log: vl_write.c,v $
 * Revision 1.1  1993/01/15  19:43:28  stcheng
 * Initial revision
 *
 * Revision 1.2  1992/12/21  11:06:01  stcheng
 * First stable version. Some bugs (nested if is not right)
 * but can handle continuous assignment conflicts
 *
 * Revision 1.1  1992/11/30  21:42:01  stcheng
 * Initial revision
 *
 *
 * routines for writing BLIF-MV 
 *
 * Author: STCheng, Oct/92
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "util.h"
#include "array.h"
#include "list.h"
#include "st.h"
#include "vl_types.h"
#include "vl_defs.h"
#include "vlr_int.h"
#include "vl_create.h"
#include "vl_write.h"

extern ith_module;
static int WrtTrace = 0;
static Being_Conditioned=0;
int Use_MV_Lib = 0;
vl_term *Initial_Signal = NIL(vl_term);
FILE *mv_file = stdout;

char *ctrl_syndrome = NIL(char);
lsList ctrl_list;
int ith_ctrl;

enum st_retval vl_write_desc(name, value, arg)
char *name;
char *value;
char *arg;
{
    /* initialize globals */
    if (!Initial_Signal) 
	Initial_Signal = vl_create_term(vl_create_id_range(strdup("_initial_"),NIL(vl_range)), 0, -1);

    if (((typestructPtr)value)->type == ModDecl) {
	vl_write_module(mv_file, (vl_module*)value);
    } else if (((typestructPtr)value)->type == CombPrimDecl ||
	       ((typestructPtr)value)->type == SeqPrimDecl) {
	/*
	  vl_write_primitive(stdout, (vl_primitive*)value);
	 */
    }
    return ST_CONTINUE;
}

/*
 * vl_dump_libs
 *
 *     dump lib (multi-value or binary), notice, that multi-value
 *     can support only numerial values now, not enumeration yet.
 *     and for now, the only lib I need is the mux.
 *
 *     a more elegant way of generating libs should be deviced.
 */
void vl_dump_libs(file, decl_st)
FILE *file;
st_table *decl_st;
{
    st_generator *gen;
    char *key;
    void *decl;
    int i, left, right;
    char buf[MAXSTRLEN], tmp[MAXSTRLEN], *cp;
    

    /* dump binary (default) libs */
    fprintf(file, ".model vlr_mux{0,1}\n");
    fprintf(file, ".inputs a b s\n");
    fprintf(file, ".outputs o\n");
    fprintf(file, ".names a b s o\n");
    fprintf(file, "0 - 1 0\n");
    fprintf(file, "1 - 1 1\n");
    fprintf(file, "- 0 0 0\n");
    fprintf(file, "- 1 0 1\n");
    fprintf(file, ".end\n");

    /* dump multi-value libs */
    gen = st_init_gen(decl_st);
    while (st_gen(gen, &key, &decl)) {
	left = vl_eval_expr(get_decl_range_left(decl));
	right = vl_eval_expr(get_decl_range_right(decl));

	if (left==0 && right==1) continue;

	fprintf(file, ".model vlr_mux{");
	for (i=left; i<=right; i++) {
	    fprintf(file, "%d%c", i, (i==right)?'}':',');
	}
	fprintf(file, "\n");

	fprintf(file, ".inputs a b s\n");
	fprintf(file, ".outputs o\n");
	cp = buf; *cp = '\0';
	for (i=left; i<=right; i++) {
	    sprintf(tmp, "%d%c", i, (i==right)?' ':' ');
	    cp = strappend(cp, tmp);
	}

	fprintf(file, ".mv a %d %s\n", right-left+1, buf);
	fprintf(file, ".mv b %d %s\n", right-left+1, buf);
	fprintf(file, ".mv o %d %s\n", right-left+1, buf);
	fprintf(file, ".names a b s o\n");
	for (i=left; i<=right; i++) {
	    fprintf(file, "%d - 1 %d\n", i, i);
	}
	for (i=left; i<=right; i++) {
	    fprintf(file, "- %d 0 %d\n", i, i);
	}
	fprintf(file, ".end\n");
    }
}

void vl_write_module(file, mod)
    FILE *file;
    vl_module *mod;
{
    if (mod == NULL) return;

    ASSERT(mod->type==ModDecl, "Expecting ModDecl");
    vl_currentModule = mod;
    WrtTRACE("writing module\n");

    /* 
     * write module prelogue/epilogue
     *
     * vl_write_id_range(file, mod->name);
     * vl_write_ports(file, mod->ports);
     */

    /* space/initialize control syndrome */
    ctrl_syndrome = (char*)chk_malloc(mod->syndrome_width+1);
    memset(ctrl_syndrome, (int)'-', mod->syndrome_width);
    ctrl_syndrome[mod->syndrome_width] = '\0';
    ctrl_list = lsCreate();
    ith_ctrl = 0;

    fprintf(file, ".model %s\n", mod->name->name);
    vl_write_io_list(file);
    vl_write_svar(file);
    vl_write_consts(file);
    vl_write_mod_item_list(file, mod->mod_items);
    vl_currentModule = NIL(vl_module);
    vl_write_initial_generator(file);
    fprintf(file, ".end\n");

    lsDestroy(ctrl_list, 0);
    chk_free(ctrl_syndrome);
    ctrl_syndrome = NIL(char);
}

void vl_write_consts(file)
FILE *file;
{
    /* not used yet
    fprintf(file, ".names _BLIF_GND\n");
    fprintf(file, "0\n");
    fprintf(file, ".names _BLIF_SUP\n");
    fprintf(file, "1\n");
    */
}

void vl_write_io_list(file)
FILE *file;
{
    st_generator *gen;
    char *key;
    vl_id_range *id_sym;
    int lo, hi;
    int i;
    char *dir;

    /* 0-th module is the root module, it generate Initial_Signal */
    if (vl_currentModule->flags & WithInitial)
	if (ith_module!=0) 
	    fprintf(file,".inputs %s\n", Initial_Signal->name->name);

    /* write inputs/outputs list */
    gen = st_init_gen(vl_currentModule->sig_st);
    while (st_gen(gen, &key, &id_sym)) {
	if (!(id_sym->flags & InPort) && !(id_sym->flags & OutPort)) {
	    continue;
	}

	/* latch will be implicitly clocked in blif-mv */
	if (vl_currentModule->clk) {
	    if (!strcmp(vl_currentModule->clk->name, key)) {
		continue;
	    }
	} else {
	    if (!strcmp(key, CLOCK)) {
		continue;
	    }
	}

	dir = (id_sym->flags & InPort) ? ".inputs":".outputs";
	if (id_sym->flags & MVar) {
	    fprintf(file, "%s %s", dir, id_sym->name);
	} else {
	    get_hilo(id_sym, &hi, &lo);
	    if (lo > hi) {
		fprintf(file, "%s %s", dir, id_sym->name);
	    } else {
		fprintf(file, "%s ", dir);
		for (i=lo; i<=hi; i++) {
		    char buf[MAXSTRLEN];
		    
		    sprintf(buf, "%s%s%d%s", id_sym->name, 
			    SEP_LBITSELECT, i, SEP_RBITSELECT);
		    fprintf(file, "%s ", buf);
		}
	    }
	}
	fprintf(file, "\n");
    }
    st_free_gen(gen);
}

void vl_write_svar(file)
FILE *file;
{
    st_generator *gen;
    char *key;
    vl_id_range *id_sym;
    int lo, hi;
    int i;

    /* write svar declaration */
    gen = st_init_gen(vl_currentModule->sig_st);
    while (st_gen(gen, &key, &id_sym)) {
	if (!(id_sym->flags & MVar)) continue;

	get_hilo(id_sym, &hi, &lo);
	fprintf(file, ".mv %s %d ", id_sym->name, hi-lo+1);
	for (i=lo; i<=hi; i++) {
	    fprintf(file, "%d ", i);
	}
	fprintf(file, "\n");
    }
}

void vl_write_mod_item_list (file, mitems)
    FILE *file ;
    lsList mitems;
{
    void *item;
    lsHandle handle;
    lsGen gen;
    array_t *vars_array;  /* array of st_table *var_touched */
    st_table *var_touched, *final_vars;
    
    WrtTRACE("writing Module Items\n");

    vars_array = array_alloc(st_table*, 0);
    if (mitems != (lsList)0) {
	gen = lsStart(mitems);
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    var_touched = vl_write_mod_item(file, item, NIL(st_table));
	    if (var_touched) {
		array_insert_last(st_table*, vars_array, var_touched);
	    }
	    while(lsNext(gen, &item, &handle) != LS_NOMORE) {
		var_touched = vl_write_mod_item(file, item, NIL(st_table));
		if (var_touched) {
		    array_insert_last(st_table*, vars_array, var_touched);
		}
	    }
	}
	(void) lsFinish(gen);
    }

    final_vars = conflict_arbitrator(file, vars_array);
    non_block_assignment(file, final_vars);
    instantiate_latch(file, final_vars);
}

/*
 * vl_write_mod_item
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *         for further modification, the latche instantiation may be better
 *         placed in other routines, say vl_write_module, who has a more
 *         global view of the whole module.
 */
st_table *vl_write_mod_item(file, item, other_vars)
FILE *file;
void *item;
st_table *other_vars;
{
    st_table *var_touched=NIL(st_table);
    
    switch(((vl_decl *)item)->type) {

    case RealDecl:  	case EventDecl:
	break;

    case IntDecl:   	case TimeDecl:
	break;

    case InputDecl: 	case OutputDecl:
    case InoutDecl: 	case RegDecl:
	break;	    

    case ParamDecl: 	case DefparamDecl:
	break;
	/* NetDecl: a net with strength, delay, assignment */
    case WireDecl:  	case TriDecl:
    case Tri0Decl:  	case Tri1Decl:
    case Supply0Decl:	case Supply1Decl:
    case WandDecl:  	case TriandDecl:
    case WorDecl:   	case TriorDecl:
    case TriregDecl:
	break;
	
    case ContAssign:
	var_touched = st_init_table(strcmp, st_strhash);
	vl_write_cont_assign(file, (vl_cont_assign*)item, var_touched);
	break;

    case TaskDecl:
	break;
	    
    case IntFuncDecl:
    case RangeFuncDecl:
	break;
    case RealFuncDecl:
	break;
	    
    case AndGate:   	case NandGate:
    case OrGate:    	case NorGate:
    case XorGate:   	case XnorGate:
    case BufGate:   	case Bufif0Gate:
    case Bufif1Gate:	case NotGate:
    case Notif0Gate:	case Notif1Gate:
    case PulldownGate:	case PullupGate:
    case NmosGate:  	case RnmosGate:
    case PmosGate:  	case RpmosGate:
    case CmosGate:  	case RcmosGate:
    case TranGate:  	case RtranGate:
    case Tranif0Gate: 	case Rtranif0Gate:
    case Tranif1Gate:	case Rtranif1Gate:
	break;

    case PrimInst:
	break;

    case ModInst:
	vl_write_mod_inst_list(file, (vl_mod_prim_inst_list*)item);
	break;
	    
    case InitialStmt:
	vl_write_reset(file, (vl_procstmt*)item);
	break;
    case AlwaysStmt:
	var_touched = st_init_table(strcmp, st_strhash);
	vl_write_procstmt(file, (vl_procstmt*)item, var_touched);
	break;
	    
    default:
	internal_error("Unexpected Moduel Item");
	break;
    }

    return var_touched;
}

void vl_write_mod_inst_list(file, modinstlist)
FILE *file;
vl_mod_prim_inst_list *modinstlist;
{
    vl_module *mod;
    vl_mod_prim_inst *modinst;

    if (st_lookup(vl_description->mp_st, modinstlist->name->name, &mod)) {
	lsGen gen;
	lsHandle handle;

	gen = lsStart(modinstlist->mps);
	if (lsNext(gen, &modinst, &handle) == LS_OK) {
	    vl_write_mod_inst(file, mod, modinst);
	    while (lsNext(gen, &modinst, &handle) != LS_NOMORE) {
		vl_write_mod_inst(file, mod, modinst);
	    }
	}
	lsFinish(gen);
    } else {
	char msg[MAXSTRLEN];

	sprintf(msg, 
		"module %s used without definition", modinstlist->name->name);
	Translate_Warning(msg);
    }
}

void vl_write_mod_inst(file, master, inst)
FILE *file;
vl_module *master;
vl_mod_prim_inst *inst;
{
    int lo, hi;
    int i;
    lsHandle inst_handle, mast_handle, handle;
    lsGen inst_gen, mast_gen, gen;
    vl_port_connect *inst_item;
    vl_port *mast_item;
    lsList input_consts;
    const_term *ct;

    fprintf(file, ".subckt %s %s ", master->name->name, inst->name->name);

    if (master->flags & WithInitial) {
	fprintf(file, "%s=%s ", 
		Initial_Signal->name->name, Initial_Signal->name->name);
    }

    if (inst->ports && master->ports) {
	lsHandle handle;
	lsGen gen;
	vl_id_range *id, *cur_sig;

	input_consts = lsCreate();

	inst_gen = lsStart(inst->ports);
	mast_gen = lsStart(master->ports);
	while (lsNext(inst_gen, &inst_item, &inst_handle) != LS_NOMORE && 
	       lsNext(mast_gen, &mast_item, &mast_handle) != LS_NOMORE) {
	    /* no composite data */
	    lsFirstItem(mast_item->port_exp, &id, &handle); 

	    assert(st_lookup(master->sig_st, id->name, &id));
	    vl_write_expr(file, inst_item->expr, NIL(st_table));

	    if (!inst_item->expr->term) {
		/* connect constant */
		int hi, lo;
		vl_term *term_out;

		get_hilo(id, &hi, &lo);
		term_out = new_term(NIL(vl_range),lo,hi);
		term_out->flag |= id->flags;
		lsNewEnd(input_consts, 
			 create_const_term(inst_item->expr,term_out), 0);
		if (id->flags & MVar) {
		    fprintf(file, "%s=%s ", id->name, term_out->name->name);
		} else {
		    if (lo > hi) {
			fprintf(file, "%s=%s ", 
				id->name, term_out->name->name);
		    } else {
			for (i=lo; i<=hi; i++) {
			    fprintf(file, "%s%s%d%s=%s%s%d%s ",
				    id->name,
				    SEP_LBITSELECT, i, SEP_RBITSELECT,
				    term_out->name->name,
				    SEP_LBITSELECT, i, SEP_RBITSELECT);
			    
			}
		    }
		}
		continue;
	    }

	    assert(st_lookup(vl_currentModule->sig_st, inst_item->expr->u.name->name, &cur_sig));

	    /* clocking i/o will be ignored */
            /* since blif-mv is implicitly clocked */
	    if (!strcmp(master->clk->name,inst_item->expr->term->name->name))
		continue;

	    if (id->flags & MVar) {
		/* mvar */
		fprintf(file, "%s=%s ", 
			id->name,
			inst_item->expr->term->name->name);
	    } else {
		get_hilo(id, &hi, &lo);
		if (lo > hi) {
		    /* scalar */
		    if (inst_item->expr->term->lo > inst_item->expr->term->hi){
			fprintf(file, "%s=%s ", 
				id->name,
				inst_item->expr->term->name->name);
		    } else {
			fprintf(file, "%s=%s%s%d%s ", 
				id->name,
				inst_item->expr->term->name->name,
				SEP_LBITSELECT, 
				inst_item->expr->term->lo,
				SEP_RBITSELECT);
		    }
		} else {
		    /* vector */
		    int sig_lo, sig_hi;

		    sig_lo = inst_item->expr->term->lo;
		    sig_hi = inst_item->expr->term->hi;
		    
		    for (i=lo; i<=hi; i++) {
			char mast_buf[MAXSTRLEN];
			char inst_buf[MAXSTRLEN];

			sprintf(mast_buf, "%s%s%d%s", id->name,
				SEP_LBITSELECT, i, SEP_RBITSELECT);
			sprintf(inst_buf, "%s%s%d%s", 
				inst_item->expr->term->name->name,
				SEP_LBITSELECT, sig_lo-lo+i, SEP_RBITSELECT);
			fprintf(file, "%s=%s ", mast_buf, inst_buf);
		    }
		}
	    }
	}
	lsFinish(inst_gen);
	lsFinish(mast_gen);

	fprintf(file, "\n");

	gen = lsStart(input_consts);
	while(lsNext(gen, &ct, &handle) != LS_NOMORE) {
	    vl_write_const(file, ct->const_expr, ct->term);
	}
	lsFinish(gen);

	lsDestroy(input_consts, 0);
    }
}

/*
 * vl_write_reset
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *     right hand side must be able to be evaluated to be a constant
 *     at compile time.
 */
void vl_write_reset(file, init_stmt)
FILE *file;
vl_procstmt *init_stmt;
{
    vl_write_reset_stmt(file, init_stmt->stmt);
}

/*
 * vl_write_procstmt
 * 
 *     handles initial_statement(InitialStmt) & always_statement(AlwaysStmt).
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *     current goal:
 *         always statement: fsm, combinational ckt.
 *
 *     rules to allocate a variable (reg, output, input, input, ...) 
 *     a register (a latch in BLIF-MV):
 *
 *         1. when it is possible to branch through a procedural block
 *            without assigning to the same registers in all cases. (this
 *            needs still more ponder)
 *         2. lhs of <= (non-blocking assignment).
 *
 *     to simplify translation process, current principles of translation 
 *     is that, all if/then/else statement will be interpreted as selecting
 *     (mux), while switch statement will be interpreted as mux or trasisiton
 *     table depending on whether the condition of case_item is a simple
 *     expression (-> transition table) (int, bitstream, symbolic constant) 
 *     or an more complicated expression (-> mux).
 *
 *     for the 2nd assumption, we can only do static check, hence
 *     translation will be somewhat conservative.
 *
 *     to do: 
 *         initial statement: everything
 *         always statement: generalize
 */
void vl_write_procstmt(file, procstmt, vars)
FILE *file;
vl_procstmt *procstmt;
st_table *vars;
{
    WrtTRACE("Writing always/initial statement");

    /* do reset(initial)/transition relation extraction(always) */

    if (procstmt->type == AlwaysStmt) {
	/* write blif-mv */
	vl_write_stmt(file, procstmt->stmt, NO_MUX, NIL(vl_term), vars);
    }
}

/*
 * vl_write_stmt
 *
 *     Write blif-mv for a given statement.
 *
 * arguments:
 * 
 *     file: output file
 *     stmt: stmt to be processed
 *     muxed: if the stmt is inside on branch of an if statement
 *     muxsel: if muxed==#t, what is the control signal terminal
 *     vars: variable touched by the statement
 * 
 * returns:
 *
 *     st_table of var_info of variable touched by the stmt.
 * 
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *     routines calling vl_write_stmt should take the responsibility
 *     freeing the returned symbol table
 */
st_table *vl_write_stmt(file, stmt, muxed, muxsel, vars)
FILE *file;
void *stmt;
int muxed;
vl_term *muxsel;
st_table *vars;
{
    vl_id_range *id_sym;
    vl_term *out_term;
    var_info *cur_var;
    lsList old_clist;

    if (stmt == NIL(void)) {
	return vars;
    }

    WrtTRACE("Writing statement");

    switch(((vl_bassign_stmt *)stmt)->type) {
    case BeginEndStmt:
	vars = vl_write_begin_end_stmt(file, stmt, muxed, muxsel, vars);
	break;
    case IfElseStmt:
	Being_Conditioned++;
	vars = vl_write_if_else_stmt(file, stmt, vars);
	Being_Conditioned--;
	break;
    case CaseStmt:
    case CasexStmt:
    case CasezStmt:
	Being_Conditioned++;
	vars = vl_write_case_stmt(file, stmt, vars);
	Being_Conditioned--;
	break;
    case CaseItem:
	break;
    case DefaultItem:
	break;
    case ForeverStmt:
	break;
    case RepeatStmt:
	break;
    case WhileStmt:
	break;
    case ForStmt:
	break;
    case DelayControlStmt:
	break;
    case EventControlStmt:
	vars = vl_write_event_control_stmt(file, stmt, vars);
	break;
    case AssignStmt:
    case BassignStmt:
    case NbassignStmt:
    case DelayBassignStmt:
    case DelayNbassignStmt:
    case EventBassignStmt:
    case EventNbassignStmt:
	/* 
         * 1. write_assign
         * 2. modify vars (st of *var_info)
         * 3. append cond_list in current *var_info with new sel signal
         */
	if (!st_lookup(vl_currentModule->sig_st, 
		       ((vl_bassign_stmt*)stmt)->lhs->name->name, 
		       &id_sym)) {
	    char buf[MAXSTRLEN];

	    sprintf(buf, "variable %s not declared while used as lhs", 
		    ((vl_bassign_stmt*)stmt)->lhs->name->name);
	    compile_error(buf);
	    id_sym = ((vl_bassign_stmt*)stmt)->lhs->name;
	    st_insert(vl_currentModule->sig_st, id_sym->name, id_sym);
	}

	if (((vl_bassign_stmt*)stmt)->type == NbassignStmt ||
	    ((vl_bassign_stmt*)stmt)->type == DelayNbassignStmt ||
	    ((vl_bassign_stmt*)stmt)->type == EventNbassignStmt) {
	    char buf[MAXSTRLEN];
	    sprintf(buf, "%s%s", id_sym->name, SEP_LATCH);
	    st_lookup(vl_currentModule->sig_st, buf, &id_sym);
	}
	
	out_term = vl_write_assign(file,(vl_bassign_stmt*)stmt,
				   muxed,muxsel,vars);
	if (!out_term) break;

	if (((vl_bassign_stmt *)stmt)->type == NbassignStmt ||
	    ((vl_bassign_stmt *)stmt)->type == DelayNbassignStmt ||
	    ((vl_bassign_stmt *)stmt)->type == EventNbassignStmt) {
	    /* <= */
	    syndrome_expr *newCtrlExpr;

	    newCtrlExpr = create_syndrome_expr(strdup(ctrl_syndrome),out_term);
	    lsNewEnd(id_sym->syndrome_expr_list, newCtrlExpr, 0);
	    /* break; */
	} else {
	    /* = */
	    syndrome_expr *newCtrlExpr;

	    newCtrlExpr = create_syndrome_expr(strdup(ctrl_syndrome),out_term);
	    lsNewEnd(id_sym->syndrome_expr_list, newCtrlExpr, 0);
	    /* break; */
	}
	/*
	if (st_lookup(vars, id_sym->name, &cur_var)) {
	    old_clist = cur_var->cond_list;
	} else {
	    old_clist = lsCreate();
	}
	*/
	old_clist = lsCreate();
	/* modify current_termianl for lhs var */
	/* note: one shouldn't free old var_info for id_sym->name */
	/*       since it may be used by other if/ese brahcnes    */
	st_insert(vars, id_sym->name, 
		  create_var_info(vl_copy_id_range(id_sym), out_term));
	
	st_lookup(vars, id_sym->name, &cur_var);
	if (!Being_Conditioned) {
	    if (old_clist) 
		lsDestroy(old_clist, 0);
	    cur_var->cond_list = 0;
	} else {
	    cur_var->cond_list = old_clist;
	}
	break;
    case WaitStmt:
        break;
    case ForkJoinStmt:
	break;
    case TaskEnableStmt:
    case SysTaskEnableStmt:
	break;
    case DisableStmt:
	break;
    case DeassignStmt:
	break;
    case SendEventStmt:
	break;
    default: {
	char msg[MAXSTRLEN];
	sprintf(msg, "vl_write_stmt:Unexpected Statement Type %d", 
		((vl_bassign_stmt *)stmt)->type);
	internal_error(msg);
    }
    }
    return vars;
}

/*
 * vl_write_reset_stmt
 *
 *     write initial statement, all expression must be sure that they can
 *     be evaluated to constant.
 *
 * arguments:
 *
 * returns:
 *
 * side effects:
 * 
 * bugs:
 *
 *     can handle only begin/end and assignment.
 *     ignore declaration within begin/end now.
 * 
 * comments:
 */
void vl_write_reset_stmt(file, stmt)
FILE *file;
void *stmt;
{
    lsHandle handle;
    lsGen gen;
    void *local_stmt;
    int rhs;
    int lo, hi;
    int i;
    vl_id_range *lhs_id;
    lsList stmts;

    if (stmt == NIL(void)) return;

    WrtTRACE("Writing reset statement");

    switch(((vl_bassign_stmt*)stmt)->type) {
    case BeginEndStmt: 
	stmts = ((vl_begin_end_stmt*)stmt)->stmts;
	gen = lsStart(stmts);
	if (lsNext(gen, &local_stmt, &handle) == LS_OK) {
	    vl_write_reset_stmt(file, local_stmt);
	    while (lsNext(gen, &local_stmt, &handle)) {
		vl_write_reset_stmt(file, local_stmt);
	    }
	}
	lsFinish(gen);
	break;
    case AssignStmt: 
    case BassignStmt:
	/*
	rhs = vl_eval_expr(((vl_bassign_stmt*)stmt)->rhs);
	if (st_lookup(vl_currentModule->sig_st,
		       ((vl_bassign_stmt*)stmt)->lhs->name->name,
		       &lhs_id)) {
	    get_hilo(lhs_id, &hi, &lo);
	    if (lhs_id->flags & MVar) {
		fprintf(file, ".r %s=%d\n", 
			((vl_bassign_stmt*)stmt)->lhs->name->name, rhs);
	    } else {
		if (lo > hi) {
		    fprintf(file, ".r %s=%d\n",
			   ((vl_bassign_stmt*)stmt)->lhs->name->name, rhs&1);
		} else {
		    for (i=lo; i<=hi; i++, rhs >>= 1) {
			char buf[MAXSTRLEN];
			
			sprintf(buf, "%s%s%d%s", 
				((vl_bassign_stmt*)stmt)->lhs->name->name, 
				SEP_LBITSELECT, i, SEP_RBITSELECT);
			fprintf(file, ".r %s=%d\n", buf, rhs&1);
		    }
		}
	    }
	} else {
	    char msg[MAXSTRLEN];

	    sprintf(msg, "%s in inialization without declaration, no effect",
		    ((vl_bassign_stmt*)stmt)->lhs->name->name);
	    Translate_Warning(msg);
	}
	*/
	vl_write_expr(file, ((vl_bassign_stmt*)stmt)->rhs, NIL(st_table));
	
	if (st_lookup(vl_currentModule->sig_st,
		      ((vl_bassign_stmt*)stmt)->lhs->name->name,
		      &lhs_id)) {
	    if (((vl_bassign_stmt*)stmt)->rhs->term == NIL(vl_term)) {
		/* initialize with constant */
		vl_term *term_out;

		get_hilo(lhs_id, &hi, &lo);
		term_out = new_term(NIL(vl_range),lo,hi);
		vl_write_const(file, ((vl_bassign_stmt*)stmt)->rhs, term_out);
		((vl_bassign_stmt*)stmt)->rhs->term = term_out;
	    }
	    lhs_id->initial = ((vl_bassign_stmt*)stmt)->rhs->term;
	} else {
	    char msg[MAXSTRLEN];
		
	    sprintf(msg, "%s in inialization without declaration, no effect",
		    ((vl_bassign_stmt*)stmt)->lhs->name->name);
	    Translate_Warning(msg);
	}
	break;
    default: {
	internal_error("initial statement can only handle begin/end, assignment");
    }
    }
}

st_table *vl_write_begin_end_stmt(file, bestmt, muxed, control, vars)
FILE *file;
vl_begin_end_stmt *bestmt;
int muxed;
vl_term *control;
st_table *vars;
{
    WrtTRACE("Writing begin/end\n");

    vl_write_decl_list(file, bestmt->decls, muxed, control, vars);
    vars = vl_write_stmt_list(file, bestmt->stmts, muxed, control, vars);
    return vars;
}

st_table *vl_write_if_else_stmt(file, stmt, vars)
FILE *file;
vl_if_else_stmt *stmt;
st_table *vars;
{
    st_table *t_vars, *f_vars;
    st_generator *gen;
    char *key;
    var_info *t_in, *f_in, *cur_var;
    int using_ith_ctrl;
    vl_term *sel, *tmp_term;

    WrtTRACE("Writing if/then/else statement");   

    using_ith_ctrl = ith_ctrl;
    ith_ctrl++;

    vl_write_expr(file, stmt->cond, vars);
    /* due to stupid restriction of BLIF_MV */
    /* cond signal have to be renamed       */
    tmp_term = new_term(NIL(vl_range), 0, -1);
    if (stmt->cond->term->lo <= stmt->cond->term->hi) { 
	sel = new_term(NIL(vl_range), 0, -1);
	vl_write_vector_bop(file, UorExpr, 
			    stmt->cond->term, NIL(vl_term), sel);
    } else {
	sel = stmt->cond->term;
    }
    vl_write_bin_connect(file, sel, tmp_term);
    lsNewEnd(ctrl_list, tmp_term, 0);

    t_vars = st_copy(vars);
    f_vars = st_copy(vars);
    dup_info_var_in_st(t_vars);
    dup_info_var_in_st(f_vars);
    reset_cond_list_in_st(t_vars);
    reset_cond_list_in_st(f_vars);

    ctrl_syndrome[using_ith_ctrl] = '1';
    vl_write_stmt(file, stmt->if_stmt, MUX_T, stmt->cond->term, t_vars);
    ctrl_syndrome[using_ith_ctrl] = '0';
    vl_write_stmt(file, stmt->else_stmt, MUX_F, stmt->cond->term, f_vars);
    ctrl_syndrome[using_ith_ctrl] = '-';

    fprintf(file, "# if/else (");
    vl_step_expr(file, stmt->cond);
    fprintf(file, ")\n");
    vars = create_var_muxes(file, stmt->cond->term, t_vars, f_vars, vars);

    /* free t_vars & f_vars */
    gen = st_init_gen(t_vars);
    while (st_gen(gen, &key, &t_in)) {
	st_delete(t_vars, &key, &t_in);
	if (st_lookup(vars, key, &cur_var))
	    if (cur_var == t_in)
		continue;
	free_var_info(t_in);
    }
    st_free_gen(gen);
    gen = st_init_gen(f_vars);
    while (st_gen(gen, &key, &f_in)) {
	st_delete(t_vars, &key, &f_in);
	if (st_lookup(vars, key, &cur_var))
	    if (cur_var == f_in)
		continue;
	free_var_info(f_in);
    }
    st_free_gen(gen);
    
    st_free_table(t_vars);
    st_free_table(f_vars);

    return vars;
}

/*
 * vl_write_case_stmt
 *
 * side effects:
 *
 * comments:
 * 
 * bugs:
 *
 *     Still can't create a circuit/fsm respond correctly as the behavior
 *     of case, casex, casez.
 */
st_table *vl_write_case_stmt(file, stmt, vars)
FILE *file;
vl_case_stmt *stmt;
st_table *vars;
{
    st_table **case_vars;
    int i;
    vl_case_item *item;
    lsHandle handle;
    lsGen gen;
    vl_term **controls, *prev_ctrl;
    int using_ith_ctrl;
    char old_ctrl_syndrome[MAXSTRLEN];

    WrtTRACE("Writing case\n");

    strcpy(old_ctrl_syndrome, ctrl_syndrome);

    switch (stmt->type) {
    case CaseStmt:
    case CasexStmt:
    case CasezStmt: break;
    default:
	internal_error("Unexpected Case Type"); break;
    }

    vl_write_expr(file, stmt->cond, vars);
    /* print each case_item */
    {
	vl_write_expr(file, stmt->cond->term, vars);

	case_vars = (st_table**)chk_malloc(lsLength(stmt->case_items) * 
					   sizeof(st_table*));
	controls = (vl_term**)chk_malloc(lsLength(stmt->case_items) *
					 sizeof(vl_term*));
	for (i=0; i<lsLength(stmt->case_items); i++) {
	    case_vars[i] = NIL(st_table);
	    controls[i] = NIL(vl_term);
	}

	gen = lsStart(stmt->case_items);  i = 0;
	if (lsNext(gen, &item, &handle) == LS_OK) {
	    controls[i] = 
		write_case_comparator(file, 
				      stmt->cond->term, item->exprs);
	    if (item->type == CaseItem) {
		lsNewEnd(ctrl_list, controls[i], 0);
		using_ith_ctrl = ith_ctrl;
		ith_ctrl++;
		ctrl_syndrome[using_ith_ctrl] = '1';
	    }

	    vl_write_expr_list(file, item->exprs, vars);

	    case_vars[i] = st_copy(vars);
	    dup_info_var_in_st(case_vars[i]);
	    reset_cond_list_in_st(case_vars[i]);
	    case_vars[i] = 
		vl_write_stmt(file, item->stmt, 
			      (controls[i])?MUX_T:NO_MUX, 
			      (controls[i])?controls[i]:NIL(vl_term), 
			      case_vars[i]);
	    if (item->type == CaseItem) 
		ctrl_syndrome[using_ith_ctrl] = '0';


	    prev_ctrl = controls[i];

	    while(lsNext(gen, &item, &handle) != LS_NOMORE && prev_ctrl) {
		i++;
		controls[i] = 
		    write_case_comparator(file, 
					  stmt->cond->term, item->exprs);
		if (item->type == CaseItem) {
		    lsNewEnd(ctrl_list, controls[i], 0);
		    using_ith_ctrl = ith_ctrl;
		    ith_ctrl++;
		    ctrl_syndrome[using_ith_ctrl] = '1';
		}

		vl_write_expr_list(file, item->exprs, vars);

		case_vars[i] = st_copy(vars);
		dup_info_var_in_st(case_vars[i]);
		reset_cond_list_in_st(case_vars[i]);
		case_vars[i] = 
		    vl_write_stmt(file, item->stmt, 
				  (controls[i])?MUX_T:MUX_F, 
				  (controls[i])?controls[i]:prev_ctrl,
				  case_vars[i]);
		if (item->type == CaseItem) 
		    ctrl_syndrome[using_ith_ctrl] = '0';

		prev_ctrl = controls[i];
	    }
	}
    	(void)lsFinish(gen);
    }

    strcpy(ctrl_syndrome, old_ctrl_syndrome);
    
    fprintf(file, "# case (");
    vl_step_expr(file, stmt->cond);
    fprintf(file, ")\n");

    if (!prev_ctrl) { /* last case item is 'default' */
	st_table *vars_tmp, *vars_else;
	i=lsLength(stmt->case_items)-1;
	vars_else = case_vars[i];
	for (i -= 2; i>=0; i--) {
	    vars_tmp = st_copy(vars);
	    dup_info_var_in_st(vars_tmp);
	    reset_cond_list_in_st(vars_tmp);
	    create_var_muxes(file, controls[i+1],
			     case_vars[i+1], vars_else, vars_tmp);
	    vars_else = vars_tmp;
	}
	create_var_muxes(file, controls[0],
			 case_vars[0], vars_else, vars);
    } else {
	/* not correctly implemented yet */
	for (i=lsLength(stmt->case_items)-1; i>=0; i--) {
	    case_vars[i] = create_var_muxes(file, controls[i],
					    case_vars[i], vars, vars);
	}
    }
    
    return vars;
}

/*
 * vl_write_cont_assign
 *
 *     write the BLIF-MV corresponding to an assignment statement.
 *     be sure to call this routine when your verilog statment corresponds
 *     to a combinational circuit. otherwise, you guess what the result will
 *     be? Ha, you have to guess.
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *    current routine can't handle hierarchical reference yet.
 *    to add that ability, one need to modify searching routines (st_lookup)
 *    to following the module hierarchy.
 *
 *    this routine change the type flag of each assignment into AssignStmt
 *    then call vl_write_assign().
 */
void vl_write_cont_assign(file, assign, vars)
FILE *file;
vl_cont_assign *assign;
st_table *vars;
{
    vl_id_range *lhs_id;
    lsGen gen;
    lsHandle handle;
    vl_bassign_stmt *a;
    vl_term *lhs_term;
    int hi, lo;

    WrtTRACE("Writing cont_assign\n");
    
    gen = lsStart(assign->assigns);
    if (lsNext(gen, &a, &handle) == LS_OK) {
	a->type = AssignStmt;
	st_lookup(vl_currentModule->sig_st, a->lhs->name->name, &lhs_id);
	get_hilo(lhs_id, &hi, &lo);
	lhs_term = vl_write_assign(file, a, 0, NIL(vl_term), NIL(st_table));
	st_insert(vars, lhs_id->name, 
		  create_var_info(vl_copy_id_range(lhs_id), lhs_term));
	while (lsNext(gen, &a, &handle) != LS_NOMORE) {
	    a->type = AssignStmt;
	    lhs_term = vl_write_assign(file, 
				       a, 0, NIL(vl_term), NIL(st_table));
	    st_insert(vars, lhs_id->name,
		      create_var_info(vl_copy_id_range(lhs_id), lhs_term));
	}
    }
    (void)lsFinish(gen);
}

st_table *vl_write_event_control_stmt(file, stmt, vars)
FILE *file;
vl_event_control_stmt *stmt;
st_table *vars;
{
    WrtTRACE("Writing event_control_stmt\n");

    /* todo: processing event control should be inserted here */
    vars = vl_write_stmt(file, stmt->stmt, 0, NIL(vl_term), vars);
    return vars;
}

/*
 * vl_write_assign
 *
 *     write the BLIF-MV corresponding to an assignment statement.
 *     current strategy used:
 *
 *     whether lhs is latched by check vl_currentModule->latch_st
 *
 *     1. lhs is non-muxed, 
 *        muxed == 00b
 *     
 *        rhs is connected to <var>#raw
 *
 *     2. lhs is muxed, connected to <true> port
 *        muxed == 11b
 *
 *        rhs is connected to <var>#<muxsel>#true
 *        'muxsel' is used as control signal
 *
 *     3. lhs is muxed, connected to <false> port
 *        muxed == 10b
 * 
 *        rhs is connected to <var>#<muxsel>#false
 *        'muxsel' is used as control signal
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *
 *    current routine can't handle hierarchical reference yet.
 *    to add that ability, one need to modify searching routines (st_lookup)
 *    to following the module hierarchy.
 */
vl_term *vl_write_assign(file, assign, muxed, muxsel, vars)
FILE *file;
vl_bassign_stmt *assign;
int muxed;
vl_term *muxsel;
st_table *vars;
{
    char latch_name[MAXSTRLEN];
    vl_id_range *lhs_id;
    vl_expr *left, *right;
    vl_term *term_out, *assign_term, *retval=NIL(vl_term);
    int lo, hi;

    WrtTRACE("Writing assign_stmt\n");

    fprintf(file, "# ");
    vl_step_bassign_stmt(file, assign);
    fprintf(file, "\n");
    
    vl_write_expr(file, assign->rhs, vars);
    if (assign->type == NbassignStmt || 
	assign->type == DelayNbassignStmt ||
	assign->type == EventNbassignStmt) {
	sprintf(latch_name, "%s%s", assign->lhs->name->name, SEP_LATCH);
	st_lookup(vl_currentModule->sig_st, latch_name, &lhs_id);
    } else {
	st_lookup(vl_currentModule->sig_st, assign->lhs->name->name, &lhs_id);
    }

    if (lhs_id->flags & InPort) {
	char msg[MAXSTRLEN];
	sprintf(msg, "%s is input variable while used as lhs", lhs_id->name);
	Translate_Warning(msg);
    }

    switch(assign->type) {
    /* the data flow problem make it difficult to generate hardware */
    /* having the same behavior, currently, we use the same method  */
    /* to handle non-blocking assignment to handle this             */
    case BassignStmt:
	
    case NbassignStmt:
    case AssignStmt: {
	char buf[MAXSTRLEN];

	vl_id_range *true_id=NIL(vl_id_range), *false_id=NIL(vl_id_range);

	get_hilo(lhs_id, &hi, &lo);

	/* create terminal for lhs */
	if (!muxed) {
	    if (vars) {
		/* procedural assignments and sorts */
		sprintf(buf, "%s%s%s%s", lhs_id->name,
			SEP_GATEPIN, PIN_RAWOUT, new_termname());
	    } else {
		/* continuous assignment */
		sprintf(buf, "%s%s%s%s", lhs_id->name,
			SEP_GATEPIN, PIN_RAWOUT, new_termname());
	    }
	} else {
	    if (muxed & 1) {
		sprintf(buf, "%s%s%s%s%s%s", lhs_id->name,
			SEP_GATEPIN, muxsel->name->name, new_termname(),
			SEP_GATEPIN, PIN_TRUE);
	    } else {
		sprintf(buf, "%s%s%s%s%s%s", lhs_id->name,
			SEP_GATEPIN, muxsel->name->name, new_termname(),
			SEP_GATEPIN, PIN_FALSE);
	    }
	}
	assign_term = term_out = create_rename_term(lhs_id, buf, lo, hi);
	
	/* if this is an array, then switch control need to be generated */
	if (assign->lhs->range) {
	    var_info *cur_var;
	    vl_term *orig_term;

	    vl_write_expr(file, assign->lhs->range->left, vars);
	    if (vars) {
		if (st_lookup(vars, lhs_id->name, &cur_var)) {
		    orig_term = cur_var->current_terminal;
		} else {
		    orig_term = vl_create_term(assign->lhs->name, lo, hi);
		}
	    } else {
		orig_term = vl_create_term(assign->lhs->name, lo, hi);
	    }
	    assign_term = new_term(assign->lhs->range, lo, hi);
	    write_switch(file, lhs_id,
			 assign->lhs->range->left->term, 
			 orig_term, assign_term, term_out);
	}
	
	/* connect lhs / rhs */
	if (ISVLCONST(assign->rhs->type)) {
	    vl_write_const(file, assign->rhs, assign_term);
	} else {
	    if ((term_out->flag & MVar) == 
		(assign->rhs->term->flag & MVar)) {
		if (assign->rhs->term->flag & MVar) {
		    vl_write_mv_connect(file, assign->rhs->term, assign_term);
		} else {
		    vl_write_bin_connect(file, assign->rhs->term, assign_term);
		}
	    } else if (assign->rhs->term->flag & MVar) {
		vl_mv_to_bin(assign->rhs->term);
		vl_write_bin_connect(file, assign->rhs->term, assign_term);
	    } else {
		vl_bin_to_mv(assign->rhs->term);
		vl_write_mv_connect(file, assign->rhs->term, assign_term);
	    }
	    vl_free_term(assign->rhs->term);
	}

	retval = term_out;
	break;
    }
    /* I don't think we can synthesize timed (delay) information now */
    case DelayBassignStmt:  break;
    case DelayNbassignStmt: break;
    /* need more investigation */
    case EventBassignStmt:  break;
    case EventNbassignStmt: break;
    default: break;
    }

    return retval;
}

/*
 * vl_write_decl_list
 *
 *     decl might contain wire assignment, which is equivalent to
 *     continuous assignment.
 */
st_table *vl_write_decl_list(file, decls, muxed, control, vars)
FILE *file;
void *decls;
int muxed;
vl_term *control;
st_table *vars;
{
    
}

st_table *vl_write_stmt_list(file, stmts, muxed, control, vars)
FILE *file;
void *stmts;
int muxed;
vl_term *control;
st_table *vars;
{
    void *stmt;
    lsHandle handle;
    lsGen gen;

    WrtTRACE("Writing stmt_list\n");
    gen = lsStart(stmts);
    if (lsNext(gen, &stmt, &handle) == LS_OK) {
	vars = vl_write_stmt(file, stmt, muxed, control, vars);
	while (lsNext(gen, &stmt, &handle) != LS_NOMORE) {
	    vars = vl_write_stmt(file, stmt, muxed, control, vars);
	}
    }
    (void) lsFinish(gen);
    return vars;
}

/*
 * vl_write_expr_list
 *
 * sides effects:
 *
 * bugs:
 *
 * comments:
 */
void vl_write_expr_list(file, exprs, vars)
FILE *file;
lsList exprs;
st_table *vars;
{
    vl_expr *expr;
    lsHandle handle;
    lsGen gen;

    WrtTRACE("Writing expr_list\n");

    if (!exprs) return;
    gen = lsStart(exprs);
    if (lsNext(gen, &expr, &handle) == LS_OK) {
	vl_write_expr(file, expr, vars);
	while (lsNext(gen, &expr, &handle) != LS_NOMORE) {
	    vl_write_expr(file, expr, vars);
	}
    }
    (void)lsFinish(gen);
}


/*
 * vl_write_expr
 *
 *    given an vl_expr*, generate its combinational ckt in BLIF-MV
 *
 * side effects:
 *
 * bugs:
 *
 *    all IntExpr are assumed to be 32 bit number
 *
 * comments:
 *
 *    It doesn't care delay dependent events, hence, the caller (or user)
 *    should take care of time dependent cases.
 *    current version handles only ID's of type input, output, inout, reg,
 *    and net.
 *    next step should extend to basic decl.
 */
void vl_write_expr(file, expr, vars)
FILE *file;
vl_expr *expr;
st_table *vars;
{
    int lo, hi, inverted;
    int bpos;
    vl_expr *left=NIL(vl_expr), *right=NIL(vl_expr);
    vl_term *term_in1, *term_in2, *term_out;
    vl_id_range *id_sym;
    var_info *id_var_info;
    char term1[MAXSTRLEN], term2[MAXSTRLEN];
    char *ripple;

    if (!expr) return;

    WrtTRACE("write expr");
    
    switch (expr->type) {
    case BitExpr: break;
    case IntExpr: break;
    case RealExpr: break;
    case IDExpr:
	if (vars) {
	    blif_latch *latch; 
	    /* called by write_stmt */
	    if (st_lookup(vars, expr->u.name->name, &id_var_info)) {
		/*
		if (!st_lookup(vl_currentModule->latch_st, 
			       expr->u.name->name, &latch)) {
			       */
		/* access algorithmic variable */
		/* or access latch variable */
		expr->term = term_out = 
		    vl_copy_term(id_var_info->current_terminal);
		break;
	    }
	} 
	/* called by write_cont_assign  || called by write_stmt and id */
	/*                                 is encountered the 1st time */
	if (!st_lookup(vl_currentModule->sig_st, expr->u.name->name, &id_sym)){
	    char msg[MAXSTRLEN];
	    sprintf(msg, "%s not defined", expr->u.name->name);
	    compile_error(msg);
	}
	get_hilo(id_sym, &hi, &lo);
	if (!((id_sym->flags & InPort) && (id_sym->flags & RegVar))) {
	    expr->term = term_out = 
		vl_create_term(vl_copy_id_range(expr->u.name), lo, hi);
	} else {
	    /* this var is input latched */
	    char buf[MAXSTRLEN];
	    expr->term = term_out = 
		vl_create_term(vl_copy_id_range(expr->u.name), lo, hi);
	    sprintf(buf, "%s%s%s", expr->term->name->name, SEP_DIR, PIN_IN);
	    chk_free(expr->term->name->name);
	    expr->term->name->name = strdup(buf);
	}
	term_out->flag = get_decl_flags(id_sym->mpg_master_exp);
	break;
    /* programmer have to make sure he doesn't do       */
    /* bitselect on symbolic vars                       */
    case BitSelExpr:   case PartSelExpr:
	if (vars) {
	    /* called by write_stmt */
	    if (st_lookup(vars, expr->u.name->name, &id_var_info)) {
		st_lookup(vars, expr->u.name->name, &id_var_info);
		expr->term = vl_copy_term(id_var_info->current_terminal);
	    } else {
		/* called by write_stmt and id is encountered the 1st time */
		st_lookup(vl_currentModule->sig_st, 
			  expr->u.name->name, &id_sym);
		get_hilo(id_sym, &hi, &lo);
		expr->term = vl_create_term(vl_copy_id_range(expr->u.name), 
					    lo, hi);
	    }
	} else {
	    /* called by write_cont_assign  */
	    st_lookup(vl_currentModule->sig_st, expr->u.name->name, &id_sym);
	    get_hilo(id_sym, &hi, &lo);
	    expr->term = vl_create_term(vl_copy_id_range(expr->u.name), 
					lo, hi);
	}
	/* now (lo,hi) contains var's declared lo,hi */
	lo = MAX(lo, vl_eval_expr(expr->u.idrng->range->left));
	if (expr->u.idrng->range->right)
	    hi = MIN(hi, vl_eval_expr(expr->u.idrng->range->right));
	else
	    hi = lo;
	/* now (lo,hi) contains appropriate value */
	expr->term->lo = lo;
	expr->term->hi = hi;
	break;
	
    /* this is not a complete version */
    /* it can handle only one component */
    case MinTypMaxExpr:
	vl_write_expr(file, expr->u.exprs.e1, vars);
	expr->term = expr->u.exprs.e1->term;
	break;
    case ConcatExpr: 
    case StringExpr: break;
    case FuncExpr:
    case UplusExpr:    case UminusExpr:
	break;
    /* these two operations still more efforts */
    case UnotExpr:    case UcomplExpr:     inverted=1; goto write_expr;
    /* Unary Reduction Operators */
    case UnandExpr: expr->type = UandExpr; inverted=1; goto write_expr;
    case UnorExpr:  expr->type = UorExpr;  inverted=1; goto write_expr;
    case UxnorExpr: expr->type = UxorExpr; inverted=1; goto write_expr;
    case UandExpr:  inverted=0; goto write_expr;
    case UorExpr:   inverted=0; goto write_expr;
    case UxorExpr:  inverted=0;

	write_expr:

	vl_write_expr(file, expr->u.exprs.e1, vars); 
	vl_mv_to_bin(expr->u.exprs.e1->term);
	term_in1=expr->u.exprs.e1->term;

	expr->term = term_out = new_term(NIL(vl_range), 0, -1);

	ripple = BLIF_GND;
	if (term_in1->lo <= term_in1->hi) {
	    vl_term *ripple_term;

	    ripple_term = 
		vl_create_term(vl_create_id_range(ripple,NIL(vl_range)),
			       term_in1->lo, term_in1->hi);
	    vl_write_vector_bop(file, expr->type, 
				term_in1, NIL(vl_term), ripple_term);
	    vl_write_bit_connect(file, 
				 ripple_term->name->name, term_out->name->name,
				 inverted);
	    vl_free_term(ripple_term);
	} else {
	    /*
	    Translate_Warning("Reduction on scalar");
	    */
	    vl_write_bit_connect(file, 
				 term_in1->name->name, term_out->name->name,
				 inverted);
	}
	if (inverted) {
	    switch (expr->type) {
	    case UandExpr: expr->type = UnandExpr; break;
	    case UorExpr:  expr->type = UnorExpr;  break;
	    case UxorExpr: expr->type = UxnorExpr; break;
	    }
	}
	vl_free_term(term_in1); /* expr->u.exprs.e1 = NIL(vl_expr); */
	break;

    /* Binary Operators */
    case BtimesExpr:  case BdivExpr:  case BremExpr:  
	break;
    case BlshiftExpr: case BrshiftExpr: 
	break;
    /* it's not clear how to design a circuit can implement ===, !==    */
    /* we provide only a 'approximate solution' by using == and !=.     */
    /* However, semantically, they are not the same.                    */
    case Beq3Expr:  case Bneq3Expr:
    case Beq2Expr:  case Bneq2Expr: 
	expr->term = term_out = new_term(NIL(vl_range), 0, -1);
	vl_write_expr(file, expr->u.exprs.e1, vars);
	vl_write_expr(file, expr->u.exprs.e2, vars);

	if (!(expr->u.exprs.e1->term)) {
	    lo = (expr->u.exprs.e2->term) ? expr->u.exprs.e2->term->lo : 0;
	    hi = (expr->u.exprs.e2->term) ? expr->u.exprs.e2->term->hi : 
		                            MAX(data_width(expr->u.exprs.e1),
						data_width(expr->u.exprs.e2));
	    expr->u.exprs.e1->term = new_term(NIL(vl_range), lo, hi);
	    vl_write_const(file, expr->u.exprs.e1, expr->u.exprs.e1->term);
	}
	if (!(expr->u.exprs.e2->term)) {
	    lo = (expr->u.exprs.e1->term) ? expr->u.exprs.e1->term->lo : 0;
	    hi = (expr->u.exprs.e1->term) ? expr->u.exprs.e1->term->hi : 
		                            MAX(data_width(expr->u.exprs.e2),
						data_width(expr->u.exprs.e1));
	    expr->u.exprs.e2->term = new_term(NIL(vl_range), lo, hi);
	    vl_write_const(file, expr->u.exprs.e2, expr->u.exprs.e2->term);
	}

	fprintf(file, "# ");
	vl_step_expr(file, expr);
	fprintf(file, "\n");

	term_in1=expr->u.exprs.e1->term;
	term_in2=expr->u.exprs.e2->term;

	term_in2->flag |= (term_in1->flag & MVar);

	if ((term_in1->flag&MVar) == (term_in2->flag&MVar)) {
	    if (term_in1->flag & MVar) {
		vl_write_mv_comp(file, expr->type, 
				 term_in1, term_in2, term_out);
	    } else {
		vl_write_bin_comp(file, expr->type, 
				  term_in1, term_in2, term_out);
	    }
	} else if (term_in1->flag & MVar) {
	    vl_mv_to_bin(term_in1);
	    vl_write_bin_comp(file, expr->type, term_in1, term_in2, term_out);
	} else if (term_in2->flag & MVar) {
	    vl_mv_to_bin(term_in2);
	    vl_write_bin_comp(file, expr->type, term_in1, term_in2, term_out);
	}

	vl_free_term(term_in1); /* expr->u.exprs.e1 = NIL(vl_expr); */
	vl_free_term(term_in2); /* expr->u.exprs.e2 = NIL(vl_expr); */
	break;
    /* it's not clear how to implement these simulator commands */
    case BlandExpr: case BlorExpr:  
    case BltExpr:  case BleExpr:  case BgtExpr:  case BgeExpr:  
    case BplusExpr:  case BminusExpr: 
    case BandExpr:  case BorExpr:  case BxorExpr:  case BxnorExpr:    
	vl_write_expr(file, expr->u.exprs.e1, vars);
	vl_write_expr(file, expr->u.exprs.e2, vars);
	if (!(expr->u.exprs.e1->term)) {
	    lo = (expr->u.exprs.e2->term) ? expr->u.exprs.e2->term->lo : 0;
	    hi = (expr->u.exprs.e2->term) ? expr->u.exprs.e2->term->hi : 
		                            MAX(data_width(expr->u.exprs.e1),
						data_width(expr->u.exprs.e2));
	    expr->u.exprs.e1->term = new_term(NIL(vl_range), lo, hi);
	    vl_write_const(file, expr->u.exprs.e1, expr->u.exprs.e1->term);
	}
	if (!(expr->u.exprs.e2->term)) {
	    lo = (expr->u.exprs.e1->term) ? expr->u.exprs.e1->term->lo : 0;
	    hi = (expr->u.exprs.e1->term) ? expr->u.exprs.e1->term->hi : 
		                            MAX(data_width(expr->u.exprs.e2),
						data_width(expr->u.exprs.e1));
	    expr->u.exprs.e2->term = new_term(NIL(vl_range), lo, hi);
	    vl_write_const(file, expr->u.exprs.e2, expr->u.exprs.e2->term);
	}
	vl_mv_to_bin(expr->u.exprs.e1->term);
	vl_mv_to_bin(expr->u.exprs.e2->term);
	term_in1=expr->u.exprs.e1->term;
	term_in2=expr->u.exprs.e2->term;

	fprintf(file, "# ");
	vl_step_expr(file, expr);
	fprintf(file, "\n");

	expr->term = term_out = new_term(NIL(vl_range), 0, -1);

	if (term_in1->lo > term_in1->hi) {
	    term_out->lo = term_in2->lo; /* in1:scalar, in2:vector/scalar */
	    term_out->hi = term_in2->hi;
	} else if (term_in2->lo > term_in2->hi) {
	    term_out->lo = term_in1->lo; /* in1:vector, in2:scalar */
	    term_out->hi = term_in1->hi;
	} else {                         /* in1:vector, in2:vector */
	    term_out->lo = 0;            /* normalize lsb to bit-0 */
	    if (term_in1->hi-term_in1->lo != term_in2->hi-term_in2->lo) {
		char buf[MAXSTRLEN];
	       
		sprintf(buf, "different vector sizes %s %s",
			term_in1->name->name, term_in2->name->name);
		Translate_Warning(buf);
	    }
	    term_out->hi = MIN(term_in1->hi-term_in1->lo, 
			       term_in2->hi-term_in2->lo);
	}
	if (Use_MV_Lib)
	    vl_write_mv_lib(file, expr->type, term_in1, term_in2, term_out);
	else 
	    vl_write_vector_bop(file, expr->type,
				term_in1, term_in2, term_out);

	/* allocate carry/borrow output bit */
	if (Use_MV_Lib) {
	    if (expr->type == BplusExpr || expr->type == BminusExpr) {
		char buf[MAXSTRLEN];
		
		sprintf(buf, "%s%s%d%s", 
			term_out->name->name,
			SEP_LBITSELECT, ++term_out->hi, SEP_RBITSELECT);
		vl_write_bit_connect(file, ripple, buf, 0);
	    }
	}

	vl_free_term(term_in1); /* expr->u.exprs.e1 = NIL(vl_expr); */
	vl_free_term(term_in2); /* expr->u.exprs.e2 = NIL(vl_expr); */
	break;
    /* ternary operator */
    /* implemented as mux, select line should be binary */
    /* input lines should be of the same type, either binary or mv */
    case TcondExpr:
	break;
    }
}

/*
 * vl_eval_expr
 *
 *     evaluate vl_expr *expr, expr has to contains no undertermined 
 *     variables.
 *
 * side effects:
 *
 * bugs:
 * 
 *     can't handle x and z in constant. Since the return value itself
 *     is an integer.
 *     Parameter assignment can't be handled yet, it should be solved 
 *     next step.
 *     Real still can't be handled properly, now it's only round to an
 *     integer.
 */
int vl_eval_expr(expr)
vl_expr *expr;
{
    int i, val;

    switch (expr->type) {
    case BitExpr: return expr->u.bexpr.part1; 
    case IntExpr: return expr->u.intval;
    case RealExpr:return (int)expr->u.realval;
    case IDExpr:  compile_error("eval_expr:need constant instead of variable");
    case BitSelExpr:   case PartSelExpr:
	compile_error("need constant instead of variable");
    case ConcatExpr: 
    case MinTypMaxExpr:
    case StringExpr: break;
    case FuncExpr:
    case UplusExpr:  return vl_eval_expr(expr->u.exprs.e1);
    case UminusExpr: return -vl_eval_expr(expr->u.exprs.e1);
    case UnotExpr:   return !vl_eval_expr(expr->u.exprs.e1);
    case UcomplExpr: return ~vl_eval_expr(expr->u.exprs.e1);
    /* Unary Reduction Operators */
    case UnandExpr: case UandExpr:
    case UnorExpr:  case UorExpr: 
    case UxnorExpr: case UxorExpr:
	Translate_Warning("reduction on constant");
	for (i=0, val = vl_eval_expr(expr->u.exprs.e1); i<MAXBITNUM-2; i++) {
	    switch (expr->type) {
	    case UnandExpr: case UandExpr:
		val = (val & 1) & (val >> 1); break;
	    case UnorExpr:  case UorExpr:
		val = (val & 1) | (val >> 1); break;		
	    case UxnorExpr: case UxorExpr:
		val = (val & 1) ^ (val >> 1); break;
	    }
	    val >>= 1;
	}
	if (expr->type == UnandExpr || 
	    expr->type == UnorExpr || 
	    expr->type == UxnorExpr)
	    val = !val;
    /* Binary Operators */
    case BtimesExpr:
	return vl_eval_expr(expr->u.exprs.e1) * vl_eval_expr(expr->u.exprs.e2);
    case BdivExpr:  
	return vl_eval_expr(expr->u.exprs.e1) / vl_eval_expr(expr->u.exprs.e2);
    case BremExpr: 
	return vl_eval_expr(expr->u.exprs.e1) % vl_eval_expr(expr->u.exprs.e2);
    case BlshiftExpr: 
	return vl_eval_expr(expr->u.exprs.e1) << vl_eval_expr(expr->u.exprs.e2);
    case BrshiftExpr:
	return vl_eval_expr(expr->u.exprs.e1) >> vl_eval_expr(expr->u.exprs.e2);
	break;
    /* it's not clear how to design a circuit can implement ===, !==    */
    /* we provide only a 'approximate solution' by using == and !=.     */
    /* However, semantically, they are not the same.                    */
    case Beq3Expr: 
	return vl_eval_expr(expr->u.exprs.e1) == vl_eval_expr(expr->u.exprs.e2);
    case Bneq3Expr: 
	return vl_eval_expr(expr->u.exprs.e1) != vl_eval_expr(expr->u.exprs.e2);
    case Beq2Expr: 
	return vl_eval_expr(expr->u.exprs.e1) == vl_eval_expr(expr->u.exprs.e2);
    case Bneq2Expr:
	return vl_eval_expr(expr->u.exprs.e1) != vl_eval_expr(expr->u.exprs.e2);
    /* it's not clear how to implement these simulator commands */
    case BlandExpr: 
	return vl_eval_expr(expr->u.exprs.e1) && vl_eval_expr(expr->u.exprs.e2);
    case BlorExpr:
	return vl_eval_expr(expr->u.exprs.e1) || vl_eval_expr(expr->u.exprs.e2);
    case BltExpr: 
	return vl_eval_expr(expr->u.exprs.e1) < vl_eval_expr(expr->u.exprs.e2);
    case BleExpr: 
	return vl_eval_expr(expr->u.exprs.e1) <= vl_eval_expr(expr->u.exprs.e2);
    case BgtExpr: 
	return vl_eval_expr(expr->u.exprs.e1) > vl_eval_expr(expr->u.exprs.e2);
    case BgeExpr:  
	return vl_eval_expr(expr->u.exprs.e1) >= vl_eval_expr(expr->u.exprs.e2);
    case BplusExpr: 
	return vl_eval_expr(expr->u.exprs.e1) + vl_eval_expr(expr->u.exprs.e2);
    case BminusExpr:
	return vl_eval_expr(expr->u.exprs.e1) - vl_eval_expr(expr->u.exprs.e2);
    case BandExpr: 
	return vl_eval_expr(expr->u.exprs.e1) & vl_eval_expr(expr->u.exprs.e2);
    case BorExpr:  
	return vl_eval_expr(expr->u.exprs.e1) | vl_eval_expr(expr->u.exprs.e2);
    case BxorExpr:
	return vl_eval_expr(expr->u.exprs.e1) ^ vl_eval_expr(expr->u.exprs.e2);
    case BxnorExpr:
	return ~(vl_eval_expr(expr->u.exprs.e1) ^vl_eval_expr(expr->u.exprs.e2));
    /* ternary operator */
    case TcondExpr:
	return (vl_eval_expr(expr->u.exprs.e1)) ? 
	    vl_eval_expr(expr->u.exprs.e2) : vl_eval_expr(expr->u.exprs.e3);
    }

    return 0;
} 

/*
 * create_var_muxes
 *
 *     foreach var_info *var in t_vars and f_vars, instantiate an appropriate
 *     mux for that variable.
 *
 * arguments:
 *
 *     sel: *vl_term mux control input
 *     t_vars: vars appear at #t branch of if
 *     f_vars: vars appear at #f branch of if
 *     vars:   vars appear at statements preceding if
 *
 * side effects:
 *
 * bugs:
 * 
 * comments:
 */
st_table *create_var_muxes(file, sel, t_vars, f_vars, vars)
vl_term *sel;
st_table *t_vars;
st_table *f_vars;
st_table *vars;
{
    int found;
    int lo, hi;
    var_info *cur_var;
    st_generator *gen;
    var_info *t_in, *f_in;
    char *key, buf[MAXSTRLEN];
    vl_term *term_out, *term_tmp;
    lsList old_clist = 0;
    lsList old_clistt = 0, old_clistf = 0;
    vl_term *term_ctrlt, *term_ctrlf;

    /* key in t_vars && key in f_vars && key in vars */
    gen = st_init_gen(t_vars);
    while (st_gen(gen, &key, &t_in)) {
	/* skip over lhs of <= */
	if (strstr(key,SEP_LATCH)) continue;

	sprintf(buf, "%s%s%s%s%s%s", 
		t_in->id->name, SEP_GATEPIN, sel->name->name,
		SEP_GATEPIN, PIN_RAWOUT, new_termname());
	if (st_lookup(f_vars, key, &f_in)) {
	    if (st_lookup(vars, key, &cur_var)) {
		int t_in_cur_var, f_in_cur_var;

		t_in_cur_var = !strcmp(t_in->current_terminal->name->name,
				       cur_var->current_terminal->name->name);
		f_in_cur_var = !strcmp(f_in->current_terminal->name->name,
				       cur_var->current_terminal->name->name);

		/* (1) key is not touched by both branches */
		if ( t_in_cur_var && f_in_cur_var)
		    continue;

		/* instantiate mux */
		if (t_in->current_terminal->hi-t_in->current_terminal->lo >=
		    f_in->current_terminal->hi-f_in->current_terminal->lo) {
		    lo = t_in->current_terminal->lo;
		    hi = t_in->current_terminal->hi;
		} else {
		    lo = f_in->current_terminal->lo;
		    hi = f_in->current_terminal->hi;
		}
		term_out = create_rename_term(t_in->id, buf, lo, hi);
		term_out->flag |= get_decl_flags(t_in->id->mpg_master_exp);
		write_mvar_decl(file, term_out);
		instantiate_mux(file, t_in->current_terminal, 
				f_in->current_terminal, 
				sel, term_out);
		cur_var->current_terminal = term_out;

		/* (2) key is touched by both branches */
		if (!t_in_cur_var && !f_in_cur_var) {
		    continue;
		}

		/* (3) key is touched only by <t> branch */
		if (!t_in_cur_var && f_in_cur_var) {
		    continue;
		}

		/* (4) key is touched only by <f> branch */
		if (t_in_cur_var && !f_in_cur_var) {
		    continue;
		}
	    }
	}
    }
    st_free_gen(gen);

    /* 1. key in t_vars && key in f_vars && key not in vars */
    gen = st_init_gen(t_vars);
    while (st_gen(gen, &key, &t_in)) {
	/* skip over lhs of <= */
	if (strstr(key,SEP_LATCH)) continue;

	sprintf(buf, "%s%s%s%s%s%s", 
		t_in->id->name, SEP_GATEPIN, sel->name->name,
		SEP_GATEPIN, PIN_RAWOUT, new_termname());
	if (st_lookup(f_vars, key, &f_in)) {
	    if (!st_lookup(vars, key, &cur_var)) {
		/* instantiate mux */
		if (t_in->current_terminal->hi-t_in->current_terminal->lo >=
		    f_in->current_terminal->hi-f_in->current_terminal->lo) {
		    lo = t_in->current_terminal->lo;
		    hi = t_in->current_terminal->hi;
		} else {
		    lo = f_in->current_terminal->lo;
		    hi = f_in->current_terminal->hi;
		}
		term_out = create_rename_term(t_in->id, buf, lo, hi);
		term_out->flag |= get_decl_flags(t_in->id->mpg_master_exp);
		write_mvar_decl(file, term_out);
		instantiate_mux(file, t_in->current_terminal, 
				f_in->current_terminal, 
				sel, term_out);
		
		/* modify var_info */
		assert(!st_lookup(vars,key,&cur_var));
		st_insert(vars, key,
		    create_var_info(vl_copy_id_range(t_in->id), term_out));

		/* modify cond_list */
	    }
	}
    }
    st_free_gen(gen);

    /* key occurs at #t side of if statement for the first time */
    /* key not in vars */
    gen = st_init_gen(t_vars);
    while (st_gen(gen, &key, &t_in)) {
	/* skip over lhs of <= */
	if (strstr(key,SEP_LATCH)) continue;

	sprintf(buf, "%s%s%s%s%s%s", 
		t_in->id->name, SEP_GATEPIN, sel->name->name,
		SEP_GATEPIN, PIN_RAWOUT, new_termname());
	if (!st_lookup(f_vars, key, &f_in)) {
	    vl_term *orig_id;
	    vl_term *term_ctrl;

	    /* instantiate a mux for this key variable */
	    term_out = create_rename_term(t_in->id, buf, 
					  t_in->current_terminal->lo, 
					  t_in->current_terminal->hi);
	    term_out->flag |= get_decl_flags(t_in->id->mpg_master_exp);
	    orig_id = vl_create_term(vl_copy_id_range(t_in->id), 
				     t_in->current_terminal->lo,
				     t_in->current_terminal->hi);
	    orig_id->flag = get_decl_flags(t_in->id->mpg_master_exp);
	    write_mvar_decl(file, term_out);
	    instantiate_mux(file, t_in->current_terminal, orig_id, 
			    sel, term_out);
	    vl_free_term(orig_id);

	    assert(!st_lookup(vars, key, &cur_var));
	    st_insert(vars, key,
		      create_var_info(vl_copy_id_range(t_in->id), term_out));
	}
    }
    st_free_gen(gen);
    
    /* key occurs at #f side of if statement for the first time */
    /* key not in vars */
    gen = st_init_gen(f_vars);
    while (st_gen(gen, &key, &f_in)) {
	/* skip over lhs of <= */
	if (strstr(key,SEP_LATCH)) continue;

	sprintf(buf, "%s%s%s%s%s%s", 
		f_in->id->name, SEP_GATEPIN, sel->name->name,
		SEP_GATEPIN, PIN_RAWOUT, new_termname());
	if (!st_lookup(t_vars, key, &t_in)) {
	    vl_term *orig_id;
	    vl_term *term_ctrl;

	    /* instantiate a mux for this key variable */
	    term_out = create_rename_term(f_in->id, buf, 
					  f_in->current_terminal->lo, 
					  f_in->current_terminal->hi);
	    term_out->flag |= get_decl_flags(f_in->id->mpg_master_exp);
	    orig_id = vl_create_term(vl_copy_id_range(f_in->id),
				     f_in->current_terminal->lo,
				     f_in->current_terminal->hi);
	    orig_id->flag = get_decl_flags(f_in->id->mpg_master_exp);

	    write_mvar_decl(file, term_out);
	    instantiate_mux(file, orig_id, f_in->current_terminal,
			    sel, term_out);
	    vl_free_term(orig_id);

	    assert (!st_lookup(vars, key, &cur_var));
	    st_insert(vars, key,
		      create_var_info(vl_copy_id_range(f_in->id), term_out));
	}
    }
    st_free_gen(gen);

    return vars;
}

/*
 * write_case_comparator 
 *
 * arguments:
 *
 *     file: output stream
 *     selector/tags:
 *
 *         case (selector)
 *         tag, tag, ... : action
 *         ...
 * 
 *         hence, tags is lsList of vl_expr*
 * 
 * side effects:
 *
 * bugs:
 *
 * comment:
 */
vl_term *write_case_comparator(file, selector, tags)
FILE *file;
vl_term *selector;
lsList tags;
{
    int i, j;
    vl_expr *expr;
    lsHandle handle;
    lsGen gen;
    vl_term *term_out;
    vl_term *comp_result;
    char buf[MAXSTRLEN];

    if (!tags) return NIL(vl_term);
    
    term_out = new_term(NIL(vl_range), 0, -1);

    sprintf(buf, ".names ");

    gen = lsStart(tags);
    if (lsNext(gen, &expr, &handle) == LS_OK) {
	comp_result = new_term(NIL(vl_range), 0, -1);

	if (!expr->term && expr->type==IntExpr) {
	    expr->term = new_term(NIL(vl_range), selector->lo, selector->hi);
	    write_int_connect(file, expr->u.intval, expr->term);
	}
	write_comparator(file, selector, expr->term, comp_result);
	strcat(buf, comp_result->name->name);
	vl_free_term(comp_result);
	vl_free_term(expr->term);
	while (lsNext(gen, &expr, &handle) != LS_NOMORE) {
	    comp_result = new_term(NIL(vl_range), 0, -1);

	    if (!expr->term && expr->type==IntExpr) {
		expr->term = new_term(NIL(vl_range), 
				      selector->lo, selector->hi);
		write_int_connect(file, expr->u.intval, expr->term);
	    }

	    write_comparator(file, selector, expr->term, comp_result);
	    strcat(buf, comp_result->name->name);	    
	    vl_free_term(comp_result);
	    vl_free_term(expr->term);
	}
    }
    (void)lsFinish(gen);

    fprintf(file, "%s %s\n", buf, term_out->name->name);
    
    /* write reduction-or */
    for (i=0; i<lsLength(tags); i++) {
	for (j=0; j<lsLength(tags); j++) {
	    fprintf(file, "%c ", (i==j)?'1':'-');
	}
	fprintf(file, "1\n");
    }
    for (j=0; j<lsLength(tags); j++) {
	fprintf(file, "0 ");
    }
    fprintf(file, "0\n");
    
    return term_out;
}

char *new_termname()
{
    static char sbuf[MAXSTRLEN];
    static unsigned int TermCount=0;

    sprintf(sbuf, "_n%x", TermCount++);
    return sbuf;
}

char *vl_write_vector_bop(file, type, in1, in2, out)
FILE *file;
short type;
vl_term *in1, *in2, *out;
{
    int bpos;
    char term1[MAXSTRLEN], term2[MAXSTRLEN], outerm[MAXSTRLEN];
    char *ripple;

    if (ISREDUCTION(type)) {
	fprintf(file, ".names ");
	for (bpos=in1->lo; bpos<=in1->hi; bpos++) {
	    fprintf(file, "%s%s%d%s ", 
		    in1->name->name, 
		    SEP_LBITSELECT, bpos, SEP_RBITSELECT);
	}
	fprintf(file, "%s\n", out->name->name);
	for (bpos=in1->lo; bpos<=in1->hi; bpos++) {
	    int i;
	    for (i=in1->lo; i<=in1->hi; i++) {
		fprintf(file, "%c ", 
			(i==bpos)?
			    ((type==UorExpr||type==UnorExpr)?'1':'0'):'-');
	    }
	    fprintf(file, "%c\n",
		    (type==UorExpr||type==UandExpr)?'1':'0');
	}
	for (bpos=in1->lo; bpos<=in1->hi; bpos++) {
	    fprintf(file, "%c ",
		    (type==UorExpr||type==UnorExpr)?'0':'1');
	}	
	fprintf(file, "%c\n", (type==UorExpr||type==UandExpr)?'0':'1');
	return ripple;
    }
    if (in1->lo > in1->hi && in2->lo > in2->hi) {
	/* in1:scalar; in2:scalar */
	vl_write_bop(file, type, 
		     in1->name->name, in2->name->name, NIL(char), 
		     out->name->name, 0);
    } else if (in1->lo > in1->hi && in2->lo <= in2->hi) {
	/* in1:scalar; in2:vector */
	sprintf(term2, "%s%s%d%s", in2->name->name, 
		SEP_LBITSELECT, in2->lo, SEP_RBITSELECT);
	sprintf(outerm, "%s%s%d%s", out->name->name, 
		SEP_LBITSELECT, out->lo, SEP_RBITSELECT);
	ripple = vl_write_bop(file, type, 
			      in1->name->name, term2, NIL(char), outerm, 0);
	/* connect extra output from in2 to out */
	for (bpos=in2->lo+1; bpos<=in2->hi; bpos++) {
	    sprintf(term2, "%s%s%d%s", in2->name->name, 
		    SEP_LBITSELECT, bpos, SEP_RBITSELECT);
	    sprintf(outerm, "%s%s%d%s", 
		    out->name->name, 
		    SEP_LBITSELECT, out->lo+(bpos-in2->lo), SEP_RBITSELECT);
	    vl_write_bit_connect(file, term2, outerm, 0);
	}
    } else if (in1->lo <= in1->hi && in2->lo > in2->hi) {
	/* in1:vector; in2:scalar */
	sprintf(term1, "%s%s%d%s", in1->name->name, 
		SEP_LBITSELECT, in1->lo, SEP_RBITSELECT);
	sprintf(outerm, "%s%s%d%s", out->name->name, 
		SEP_LBITSELECT, out->lo, SEP_RBITSELECT);
	ripple = vl_write_bop(file, type, 
			      term1, in2->name->name, NIL(char), outerm, 0);
	/* connect extra output from in1 to out */
	for (bpos=in1->lo+1; bpos<=in1->hi; bpos++) {
	    sprintf(term1, "%s%s%d%s", in1->name->name, 
		    SEP_LBITSELECT, bpos, SEP_RBITSELECT);
	    sprintf(outerm, "%s%s%d%s", 
		    out->name->name, 
		    SEP_LBITSELECT, out->lo+(bpos-in1->lo), SEP_RBITSELECT);
	    vl_write_bit_connect(file, term1, outerm, 0);
	}
    } else {
	/* in1:vector; in2:vector */
	for (bpos=out->lo; bpos<=out->hi; bpos++) {
	    sprintf(term1, "%s%s%d%s", 
		    in1->name->name, 
		    SEP_LBITSELECT, in1->lo+bpos, SEP_RBITSELECT);
	    sprintf(term2, "%s%s%d%s", 
		    in2->name->name, 
		    SEP_LBITSELECT, in2->lo+bpos, SEP_RBITSELECT);
	    sprintf(outerm, "%s%s%d%s", 
		    out->name->name, 
		    SEP_LBITSELECT, out->lo+bpos, SEP_RBITSELECT);
	    ripple = vl_write_bop(file, type, term1, term2, ripple, outerm,
				  (bpos==out->hi));
	}
    }
    
    return ripple;
}

/* index into *log_function[] */
#define BLIF_BITCONNECT   0
#define BLIF_NOT          1
#define BLIF_AND          2
#define BLIF_NAND         3
#define BLIF_OR           4
#define BLIF_NOR          5
#define BLIF_XOR          6
#define BLIF_XNOR         7
#define BLIF_ADD          8
#define BLIF_SUB          10
#define BLIF_MUX          12

#define EXPR_TO_BLIF_FUNC(exprval) \
    ((exprval)==BlandExpr)? BLIF_AND : \
    ((exprval)==BlorExpr) ? BLIF_OR  : \
    ((exprval)==BandExpr) ? BLIF_AND : \
    ((exprval)==BorExpr)  ? BLIF_OR  : \
    ((exprval)==BxorExpr) ? BLIF_XOR : \
    ((exprval)==BxnorExpr)? BLIF_XNOR: \
    ((exprval)==BplusExpr)? BLIF_ADD : \
    ((exprval)==BminusExpr)?BLIF_SUB : \
    ((exprval)==UandExpr) ? BLIF_AND : \
    ((exprval)==UnandExpr)? BLIF_NAND: \
    ((exprval)==UorExpr)  ? BLIF_OR  : \
    ((exprval)==UnorExpr) ? BLIF_NOR : \
    ((exprval)==UxorExpr) ? BLIF_XOR : 0

static char *log_function[] = {
    "0 0  \n1 1  \n",                 /* single bit wire connect */
    "0 1  \n1 0  \n",                 /* inverter */
    "0 0 0\n0 1 0\n1 0 0\n1 1 1\n",   /* and */
    "0 0 1\n0 1 1\n1 0 1\n1 1 0\n",   /* nand */
    "0 0 0\n0 1 1\n1 0 1\n1 1 1\n",   /* or */
    "0 0 1\n0 1 0\n1 0 0\n1 1 0\n",   /* nor */
    "0 0 0\n0 1 1\n1 0 1\n1 1 0\n",   /* xor */
    "0 0 1\n0 1 0\n1 0 0\n1 1 1\n",   /* xnor */
    "0 0 0 0\n0 0 1 1\n0 1 0 1\n0 1 1 0\n1 0 0 1\n1 0 1 0\n1 1 0 0\n1 1 1 1\n", /* add */
    "0 0 0 0\n0 0 1 0\n0 1 0 0\n0 1 1 1\n1 0 0 0\n1 0 1 1\n1 1 0 1\n1 1 1 1\n", /* carry */
    "0 0 0 0\n0 0 1 1\n0 1 0 1\n0 1 1 0\n1 0 0 1\n1 0 1 0\n1 1 0 0\n1 1 1 1\n", /* sub */
    "0 0 0 0\n0 0 1 1\n0 1 0 1\n0 1 1 1\n1 0 0 0\n1 0 1 0\n1 1 0 0\n1 1 1 1\n", /* borrow */
    "0 - 0 0\n1 - 0 1\n- 0 1 0\n- 1 1 1\n" /* mux */
    };

char *vl_write_bop(file, type, in1, in2, auxin, out, forbidden_ripple)
FILE *file;
short type;
char *in1, *in2, *auxin, *out;
int forbidden_ripple;
{
    int mv_func;
    char sbuf[MAXSTRLEN];
    static char ripplenet[MAXSTRLEN];

    switch(type) {
    case BlandExpr: case BlorExpr:
    case BandExpr:  case BorExpr:  case BxorExpr:  case BxnorExpr:    
	mv_func = EXPR_TO_BLIF_FUNC(type);
	fprintf(file, ".names %s %s %s\n", in1, in2, out);
	fprintf(file, "%s", log_function[mv_func]);
	sprintf(sbuf, "%s", out);
	break; 
    case UandExpr:  case UnandExpr:  
    case UorExpr:  case UnorExpr:
    case UxorExpr:    case UxnorExpr:
	mv_func = EXPR_TO_BLIF_FUNC(type);
	if (out) {
	    fprintf(file, ".names %s %s %s", in1, in2, out);
	    fprintf(file, "%s", log_function[mv_func]);
	}
	sprintf(sbuf, "%s", new_termname());
	fprintf(file, ".names %s %s %s\n", in1, in2, sbuf);
	fprintf(file, "%s", log_function[mv_func]);
	sprintf(ripplenet, "%s", sbuf);
	break;
    case BplusExpr:  case BminusExpr: 
	mv_func = EXPR_TO_BLIF_FUNC(type);
	fprintf(file, ".names %s %s %s %s\n", 
		in1, in2, 
		(auxin)?auxin:WRT_BLIF_GND(file), (out)?out:new_termname());
	fprintf(file, "%s", log_function[mv_func]);
	if (!forbidden_ripple) {
	    sprintf(sbuf, "%s", new_termname());
	    fprintf(file, ".names %s %s %s %s\n", 
		    in1, in2, (auxin)?auxin:WRT_BLIF_GND(file), sbuf);
	    fprintf(file, "%s", log_function[mv_func+1]);
	    sprintf(ripplenet, "%s", sbuf);
	}
	break;
    }

    return ripplenet;
}

/* write sigle bit direct wire connect */
void vl_write_bit_connect(file, in, out, inverted)
FILE *file;
char *in, *out;
int inverted;
{
    fprintf(file, ".names %s %s\n", in, out);
    if (!inverted)
	fprintf(file, "%s", log_function[BLIF_BITCONNECT]);
    else 
	fprintf(file, "%s", log_function[BLIF_NOT]);
}

/* encoding mv vl_term into binary, straightforward binary representation */
void vl_mv_to_bin(term)
vl_term *term;
{
    int blen;

    if (term->flag & MVar) {
	Translate_Warning("enforced mv->binary encoding");

	term->flag &= !MVar;
	if (term->hi < 0) {
	    term->hi = MAXBITNUM-1;
	    term->lo = 0;
	} else {
	    int range, blen;

	    for (range = term->hi - term->lo + 1, blen = -1;
		 range>0;
		 blen++, range >>= 1);
	    if (blen>0)
		if ((1<<(blen-1)) < term->hi-term->lo+1)
		    blen++;
	    term->lo = 0;
	    term->hi = blen-1;
	}
    }
}

/* decode binary vl_term into mv, sstraightforward binary representation */
void vl_bin_to_mv(term)
vl_term *term;
{
    int blen;

    if (!(term->flag & MVar)) {
	Translate_Warning("enforced binary->mv encoding");
	
	term->flag |= MVar;
	blen = term->hi-term->lo+1;
	term->lo = 1;
	term->hi = (1 << (blen));
    }
}

void vl_write_mv_comp(file, type, in1, in2, out)
FILE *file;
short type;
vl_term *in1, *in2, *out;
{
    int val1, val2;

    if (in1->hi-in1->lo != in2->hi-in2->lo)
	Translate_Warning("comparator have MV's of different domain elts");

    fprintf(file, ".names %s %s %s\n", 
	     in1->name->name, in2->name->name, out->name->name);
    switch (type) {
    case Beq2Expr: 
	for (val1 = in1->lo; val1 <= in1->hi; val1++)
	    for (val2 = in2->lo; val2 <= in2->hi; val2++) {
		fprintf(file, "%d %d %d\n", val1, val2, (val1==val2));
	    }
	break;
    case Bneq2Expr: 
	for (val1 = in1->lo; val1 <= in1->hi; val1++)
	    for (val2 = in2->lo; val2 <= in2->hi; val2++) {
		fprintf(file, "%d %d %d\n", val1, val2, (val1!=val2));
	    }
	break;
    }
}

void vl_write_bin_comp(file, type, in1, in2, out)
FILE *file;
short type;
vl_term *in1, *in2, *out;
{
    int bpos;
    vl_term *tmp, *ripple_term;
    char term[MAXSTRLEN];
    char *ripple;

    /* in1 xor in2 */
    tmp = new_term(NIL(vl_range), 0, -1);

    if (in1->lo != in2->lo) {
	in2->lo = in1->lo;
	in2->hi = in1->lo - in2->lo + in2->hi;
    }
    if (in1->lo > in1->hi) {
        tmp->lo = in2->lo; /* in1:scalar, in2:vector/scalar */
	tmp->hi = in2->hi;
    } else if (in2->lo > in2->hi) {
	tmp->lo = in1->lo; /* in1:vector, in2:scalar */
	tmp->hi = in1->hi;
    } else {                         /* in1:vector, in2:vector */
	tmp->lo = 0;                 /* normalize lsb to bit-0 */
	if (in1->hi-in1->lo != in2->hi-in2->lo) {
	    char buf[MAXSTRLEN];
	    
	    sprintf(buf, "different vector sizes %s %s",
		    in1->name->name, in2->name->name);
	    Translate_Warning(buf);
	}
	tmp->hi = MIN(in1->hi-in1->lo, in2->hi-in2->lo);
    }
    vl_write_vector_bop(file, BxorExpr, in1, in2, tmp);

    /* reduction nor */
    ripple = new_termname();
    ripple_term = vl_create_term(vl_create_id_range(ripple,NIL(vl_range)),
				 tmp->lo, tmp->hi);
    if (tmp->lo <= tmp->hi) {
	ripple = 
	    vl_write_vector_bop(file, UorExpr, tmp, NIL(vl_term), ripple_term);
	vl_write_bit_connect(file, ripple_term->name->name, out->name->name, 
			     (type==Beq2Expr));
	vl_free_term(ripple_term);
    } else {
	vl_write_bit_connect(file, tmp->name->name, out->name->name, 
			     (type==Beq2Expr));
    }
    vl_free_term(tmp);
}

void vl_write_mv_connect(file, in, out)
FILE *file;
vl_term *out, *in;
{
    int val;

    if ((out->hi!=in->hi) || (out->lo!=in->lo))
	Translate_Warning("mv wiring have different range on src/dst");

    fprintf(file, ".names %s %s\n", in->name->name, out->name->name);
    for (val = MAX(out->lo,in->lo); val <= MIN(out->hi,in->hi); val++) {
	fprintf(file, "%d %d\n", val);
    }
}

void vl_write_bin_connect(file, in, out)
FILE *file;
vl_term *out, *in;
{
    int i;
    char out_buf[MAXSTRLEN], in_buf[MAXSTRLEN];

    if (out->lo > out->hi) {
	vl_write_bit_connect(file, in->name->name, out->name->name, 0);
    } else {
	for (i=out->lo; i<=MAX(out->hi-out->lo,in->hi-in->lo)+out->lo; i++) {
	    sprintf(out_buf, "%s%s%d%s", out->name->name, 
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    sprintf(in_buf, "%s%s%d%s", in->name->name, 
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    vl_write_bit_connect(file, in_buf, out_buf, 0);
	}
    }
}

void vl_write_const(file, val, out)
FILE *file;
vl_expr *val;
vl_term *out;
{
    int ismvar=0;
    int i, v;
    int lo, hi;
    vl_expr *left, *right;
    char buf[MAXSTRLEN];

    if (out->name->mpg_master_exp)
	ismvar = get_decl_flags(out->name->mpg_master_exp) & MVar;
    else 
	ismvar = out->flag & MVar;
    if (ismvar) {
	write_mvar_decl(file, out);
	fprintf(file, ".names %s\n", out->name->name);
	switch(val->type) {
	case IntExpr: fprintf(file, "%d\n", val->u.intval); break;
	case RealExpr: fprintf(file, "%d\n", val->u.realval); break;
	case BitExpr: 
	    Translate_Warning("Using binary constant as value of mv variable");
	    fprintf(file, "%d\n", val->u.bexpr.part1);
	    break;
	}
    } else {
	/* binary variable */
	if (out->name->mpg_master_exp) /* general expr */
	    get_hilo(out->name, &hi, &lo);
	else { /* const expr */
	    hi = out->hi;
	    lo = out->lo;
	}
	if (lo <= hi) {
	    for (i=lo, v=val->u.intval; i<=hi; i++, v >>= 1) {
		sprintf(buf, "%s%s%d%s", out->name->name, 
			SEP_LBITSELECT, i, SEP_RBITSELECT);
		fprintf(file, ".names %s\n", buf);
		fprintf(file, "%d\n", (v & 1));
	    }
	} else {
	    fprintf(file, ".names %s\n", out->name->name);
	    fprintf(file, "%d\n", v & 1);
	}
    }
}

/* write_int_connect is based on different notion from vl_write_const */
void write_int_connect(file, v, out)
FILE *file;
int v;
vl_term *out;
{
    int lo, hi, i;
    char buf[MAXSTRLEN];

    lo = out->lo; hi = out->hi;
    for (i=lo; i<=hi; i++, v >>= 1) {
	sprintf(buf, "%s%s%d%s", out->name->name, 
		SEP_LBITSELECT, i, SEP_RBITSELECT);
	fprintf(file, ".names %s\n", buf);
	fprintf(file, "%d\n", (v & 1));
    }
}

void write_comparator(file, in1, in2, out)
FILE *file;
vl_term *in1;
vl_term *in2;
vl_term *out;
{
    if ((in1->flag&MVar) == (in2->flag&MVar)) {
	if (in1->flag & MVar) {
	    vl_write_mv_comp(file, (short)Beq2Expr, in1, in2, out);
	} else {
	    vl_write_bin_comp(file, (short)Beq2Expr, in1, in2, out);
	}
    } else if (in1->flag & MVar) {
	vl_mv_to_bin(in1);
	vl_write_bin_comp(file, (short)Beq2Expr, in1, in2, out);
    } else if (in1->flag & MVar) {
	vl_mv_to_bin(in2);
	vl_write_bin_comp(file, (short)Beq2Expr, in1, in2, out); 
   }
}

vl_range *get_decl_range(decl)
void *decl;
{
    switch (((typestructPtr)(decl))->type) {
    case InputDecl:
    case OutputDecl:
    case InoutDecl:
    case RegDecl:
	return ((vl_rangedeclPtr)(decl))->range;
    case WireDecl:
    case SWireDecl:
	return ((vl_netdeclPtr)(decl))->range;
    default:
	return NIL(vl_range);
    }
}

vl_expr *get_decl_range_left(decl)
void *decl;
{
    switch (((typestructPtr)(decl))->type) {
    case InputDecl:
    case OutputDecl:
    case InoutDecl:
    case RegDecl:
	return ((vl_rangedeclPtr)(decl))->range->left;
    case WireDecl:
    case SWireDecl:
	return ((vl_netdeclPtr)(decl))->range->left;
    default:
	return NIL(vl_expr);
    }
}

vl_expr *get_decl_range_right(decl)
void *decl;
{
    switch (((typestructPtr)(decl))->type) {
    case InputDecl:
    case OutputDecl:
    case InoutDecl:
    case RegDecl:
	return ((vl_rangedeclPtr)(decl))->range->right;
    case WireDecl:
    case SWireDecl:
	return ((vl_netdeclPtr)(decl))->range->right;
    default:
	return NIL(vl_expr);
    }
}

short get_decl_flags(decl)
void *decl;
{
    if (!decl) return 0;

    switch (((typestructPtr)(decl))->type) {
    case InputDecl:
    case OutputDecl:
    case InoutDecl:
    case RegDecl:
	return ((vl_rangedeclPtr)(decl))->flags;
    case WireDecl:
    case SWireDecl:
	return ((vl_netdeclPtr)(decl))->flags;
    default:
	return 0;
    }
}

void get_hilo(id, hi, lo)
vl_id_range *id;
int *hi, *lo;
{
    vl_expr *left, *right;

    if (get_decl_range(id->mpg_master_exp)) {
	left = get_decl_range_left(id->mpg_master_exp);
	right = get_decl_range_right(id->mpg_master_exp);
	*lo = vl_eval_expr(left);
	*hi = vl_eval_expr(right);
    } else {
	*lo = 0;
	*hi = -1;
    }
}

void instantiate_mux(file, t, f, sel, out)
FILE *file;
vl_term *t;
vl_term *f;
vl_term *sel;
vl_term *out;
{
    vl_term *term_control;
    int bpos;
    char buf[MAXSTRLEN], *ripple;
    char t_buf[MAXSTRLEN], f_buf[MAXSTRLEN], out_buf[MAXSTRLEN];
    vl_term *t_elt, *f_elt, *out_elt;
    int idx;
    int hi, lo, bit_lo, bit_hi;

    term_control = sel;
    /* check if implicit reduction or need to be done */
    if (sel->lo <= sel->hi) {
	term_control = new_term(NIL(vl_range), 0, -1);

	ripple = vl_write_vector_bop(file, UorExpr, 
				     sel, NIL(vl_term), term_control);
    }

    if (!out->name->range) { /* non-array */
	if (out->flag & MVar)
	    instantiate_smux(file, t, f, term_control, out);
	else
	    instantiate_bmux(file, t, f, term_control, out);
    } else { /* array */
	bit_lo = out->lo; bit_hi = out->hi;

	lo = vl_eval_expr(out->name->range->left);
	if (out->name->range->right)
	    hi = vl_eval_expr(out->name->range->right);
	else
	    hi = lo;

	for (idx=lo; idx<=hi; idx++) {
	    sprintf(t_buf, "%s%s%d%s", 
		    t->name->name, SEP_LARRAY, idx, SEP_RARRAY);
	    sprintf(f_buf, "%s%s%d%s",
		    f->name->name, SEP_LARRAY, idx, SEP_RARRAY);
	    sprintf(out_buf, "%s%s%d%s",
		    out->name->name, SEP_LARRAY, idx, SEP_RARRAY);

	    t_elt = create_rename_term(t, t_buf, bit_lo, bit_hi);
	    f_elt = create_rename_term(f, f_buf, bit_lo, bit_hi);
	    out_elt = create_rename_term(out, out_buf, bit_lo, bit_hi);
	    if (out->flag & MVar)
		instantiate_smux(file, t_elt, f_elt, term_control, out_elt);
	    else
		instantiate_bmux(file, t_elt, f_elt, term_control, out_elt);
	}
    }
}

void instantiate_smux(file, t, f, sel, out)
FILE *file;
vl_term *t;
vl_term *f;
vl_term *sel;
vl_term *out;
{
    vl_bin_to_mv(t);
    vl_bin_to_mv(f);
    /* you want to use subckt or what ? */
    if (t->lo!=f->lo || t->lo!=out->lo ||
	t->hi!=t->hi || t->hi!=out->hi ||
	f->lo!=out->lo || f->hi!=out->hi)
	Translate_Warning("inconsistent MVar range");

    vl_put_lib(file, LIB_MUX, out, new_termname(),
	       t->name->name, f->name->name, sel->name->name, out->name->name);
}

/*
 * instantiate_bmux
 *
 *     instantiate a binary mux
 *
 * side effects:
 *
 *     hi, lo field of out will be modified accordingly
 *
 * bugs:
 *
 * comments:
 */
void instantiate_bmux(file, t, f, sel, out)
FILE *file;
vl_term *t;
vl_term *f;
vl_term *sel;
vl_term *out;
{
    char fbuf[MAXSTRLEN], tbuf[MAXSTRLEN], obuf[MAXSTRLEN];
    int i;

    vl_mv_to_bin(t);
    vl_mv_to_bin(f);
    
    if (t->hi-t->lo >= f->hi-f->lo) {
	out->lo = t->lo; out->hi = t->hi;
	if (t->lo > t->hi) {
	    vl_put_lib(file, LIB_MUX, out, new_termname(), 
		       t->name->name, f->name->name,
		       sel->name->name, out->name->name);
	}
	for (i=t->lo; i<=t->hi; i++) {
	    if ((i-t->lo) <= (f->hi-f->lo))
		sprintf(fbuf, "%s%s%d%s", f->name->name, 
			SEP_LBITSELECT, i, SEP_RBITSELECT);
	    else
		sprintf(fbuf, "%s%s%d%s", f->name->name,
			SEP_LBITSELECT, i, SEP_RBITSELECT);
	    sprintf(tbuf, "%s%s%d%s", t->name->name, 
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    sprintf(obuf, "%s%s%d%s", out->name->name,
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    vl_put_lib(file, LIB_MUX, out, new_termname(), 
		       tbuf, fbuf, sel->name->name, obuf);
	}
    } else {
	out->lo = f->lo; out->hi = f->hi;
	for (i=f->lo; i<=f->hi; i++) {
	    if ((i-f->lo) <= (t->hi-t->lo))
		sprintf(tbuf, "%s%s%d%s", t->name->name,
			SEP_LBITSELECT, i, SEP_RBITSELECT);
	    else
		sprintf(tbuf, "%s%s%d%s", t->name->name, 
			SEP_LBITSELECT, i, SEP_RBITSELECT);
	    sprintf(fbuf, "%s%s%d%s", f->name->name, 
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    sprintf(obuf, "%s%s%d%s", out->name->name,
		    SEP_LBITSELECT, i, SEP_RBITSELECT);
	    vl_put_lib(file, LIB_MUX, out, new_termname(), 
		       tbuf, fbuf, sel->name->name, obuf);
	}
    }
}

void instantiate_latch(file, vars)
FILE *file;
st_table *vars;
{
    vl_id_range *id_sym;
    st_generator *gen;
    char *key, *ps_buf;
    var_info *var, *lvar;
    blif_latch *latch;
    char latch_name[MAXSTRLEN];

    /* generate output latches */
    gen = st_init_gen(vars);
    while (st_gen(gen, &key, &var)) {
	sprintf(latch_name, "%s%s", key, SEP_LATCH);
	if (vl_currentModule->latch_st) {
	    if (st_lookup(vl_currentModule->sig_st, key, &id_sym)) {
		if (!(id_sym->flags & RegVar)  && 
		    (id_sym->name[strlen(id_sym->name)-1]!='|')) 
		    continue;

		/* this variable is used as lhs of <=, generate */
		/* latch only for var|                          */
		if (st_lookup(vl_currentModule->latch_st, key, &latch))
		    continue;

		/* if this latch is not lhs of <= */
		if (!st_lookup(vars, latch_name, &lvar)) lvar = var;

		ps_buf = strdup(var->id->name);
		if (id_sym->initial) {
		    /* initialized variable */
		    int lo, hi;
		    vl_term *term_out;
		    char buf[MAXSTRLEN];
		    
		    sprintf(buf, "%s%s", id_sym->name, new_termname());
		    term_out = create_rename_term(id_sym, buf, lo, hi);
		    term_out->flag = get_decl_flags(var->id->mpg_master_exp);
		    write_mvar_decl(file,term_out);
		    instantiate_mux(file, id_sym->initial,
				    lvar->current_terminal,
				    Initial_Signal, term_out);
		    lvar->current_terminal = term_out;
		}

		if (get_decl_flags(var->id->mpg_master_exp) & MVar) {
		    fprintf(file, ".latch %s %s\n",
			    lvar->current_terminal->name->name, 
			    strip_char(ps_buf,'|'));
		} else {
		    int i, lo, hi;

		    get_hilo(var->id, &hi, &lo);
		    if (lo > hi) {
			fprintf(file, ".latch %s %s\n",
				lvar->current_terminal->name->name, 
				strip_char(ps_buf,'|'));
		    } else {
			for (i=lo; i<=hi; i++) {
			    fprintf(file, ".latch %s%s%d%s %s%s%d%s\n", 
				    lvar->current_terminal->name->name, 
				    SEP_LBITSELECT, i, SEP_RBITSELECT,
				    strip_char(ps_buf,'|'), 
				    SEP_LBITSELECT, i, SEP_RBITSELECT);
			}
		    }
		}
		chk_free(ps_buf);
	    }
	}
    }
    st_free_gen(gen);

    /* generate input latches */
    gen = st_init_gen(vl_currentModule->sig_st);
    while (st_gen(gen, &key, &id_sym)) {
	char buf[MAXSTRLEN];
	int i, hi, lo;
	sprintf(buf, "%s%s%s", id_sym->name, SEP_DIR, PIN_IN);
	if (id_sym->flags & InPort && id_sym->flags & RegVar) {
	    if (id_sym->flags & MVar) {
		fprintf(file, ".latch %s %s\n", id_sym->name, buf);
	    } else {
		int lo, hi;

		get_hilo(id_sym, &hi, &lo);
		if (lo > hi) {
		    fprintf(file, ".latch %s %s\n", id_sym->name, buf);
		} else {
		    for (i=lo; i<=hi; i++) {
			fprintf(file, ".latch %s%s%d%s %s%s%d%s\n",
				id_sym->name, 
				SEP_LBITSELECT, i, SEP_RBITSELECT,
				buf, SEP_LBITSELECT, i, SEP_RBITSELECT);
		    }
		}
	    }
	}
    }
}

void vl_put_lib(va_alist)
va_dcl
{
    FILE *file;
    char buf[MAXSTRLEN];
    char outputstr[MAXSTRLEN];
    char elt_buf[MAXSTRLEN];
    char typ_buf[MAXSTRLEN];
    char tmp[MAXSTRLEN];
    char *cp, *tcp;
    int code;
    va_list args;
    vl_term *type_term;
    void *decl;
    int i;
    
    va_start(args);
    file = va_arg(args, FILE*);
    code = va_arg(args, int);
    type_term = va_arg(args, vl_term*);

    cp = buf; *cp = '\0';
    cp = strappend(cp, lib_fun[code][0]);

    tcp = typ_buf; *tcp = '\0';
    tcp = strappend(tcp, SEP_LTRANGE);
    /* for now, symbolic variable can take only numerical numbers */
    if (type_term->flag & MVar) {
	if (!st_lookup(vl_description->decl_st,
		       type_term->name->mpg_master_exp,&decl)) {
	    st_insert(vl_description->decl_st,
		      type_term->name->mpg_master_exp, 
		      type_term->name->mpg_master_exp);
	}
	for (i=type_term->lo; i<=type_term->hi; i++) {
	    sprintf(tmp, "%d%c", i, (i==type_term->hi)?'\0':',');
	    tcp = strappend(tcp, tmp);
	}
    } else {
	for (i=0; i<=1; i++) {
	    sprintf(tmp, "%d%c", i, (i==1)?'\0':',');
	    tcp = strappend(tcp, tmp);
	}
    }
    tcp = strappend(tcp, SEP_RTRANGE);

    cp = strappend(cp, typ_buf);
    cp = strappend(cp, lib_fun[code][1]);
    (void)vfprintf(file, buf, args);
    va_end(args);
}

void vl_write_mv_lib(file, type, in1, in2, out)
FILE *file;
short type;
vl_term *in1;
vl_term *in2;
vl_term *out;
{
    int lo, hi;

    fprintf(file, ".subckt ");
    switch(type) {
    case BandExpr: fprintf(file, "%s", BLIF_LIB_AND); break;
    case BorExpr:  fprintf(file, "%s", BLIF_LIB_OR); break;
    case BxorExpr: fprintf(file, "%s", BLIF_LIB_XOR); break;
    case BxnorExpr:fprintf(file, "%s", BLIF_LIB_XNOR); break;
    case BplusExpr: fprintf(file, "%s", BLIF_LIB_ADD); break;
    case BminusExpr:fprintf(file, "%s", BLIF_LIB_SUB); break;
    case UandExpr:  case UnandExpr:  
    case UorExpr:  case UnorExpr:
    case UxorExpr:    case UxnorExpr: break;
    }
    lo = 0;
    hi = MIN(in1->hi-in1->lo,in2->hi-in2->lo);
    fprintf(file, "[%d:%d] %s %s %s %s\n", lo, hi, 
	    new_termname(), in1->name->name, in2->name->name, out->name->name);
}

/*
 * insert_control_list
 *
 *     insert vl_term *sel into var's cond_list list 
 *     if var->cond_list == lsCreate() then var is always touched by
 *     the 'always' statement.
 *
 * arguments:
 *
 *     var:
 *     sel: lsb==0 if var is at sel's (1) terminal
 *          lsb==1 if var is at sel's (0) terminal
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 */
void insert_control_list(cur_var, sel)
var_info *cur_var;
vl_term *sel;
{
    vl_id_range *id_sym;

    if (!sel) return;
    st_lookup(vl_currentModule->sig_st, cur_var->id->name, &id_sym);
    lsNewEnd(cur_var->cond_list, sel, LS_NH);
}

/*
 * conflict_arbitrator
 *
 * arguments:
 *
 *     vars_arrary: arra_t of st_table of *var_info,
 *                  if lsb of the address is 1, then a complemented form
 *                  will be assumed
 *
 * returns:
 *
 *     st_table of *var_info of all vars used.
 *
 * side effects:
 *
 *     access (read only) vl_currentModule.
 *
 * bugs:
 *
 * comments:
 * 
 *     this routine will not do the stupid check over 
 *     mixing binary and multi-value terminals or 
 *     bus width inconsistency
 */
st_table *conflict_arbitrator(file, vars_array)
FILE *file;
array_t *vars_array;
{
    char buf[MAXSTRLEN];
    char buf_tmp[MAXSTRLEN];
    char buf_old[MAXSTRLEN], buf_new[MAXSTRLEN];
    char *cp;
    st_generator *gen;
    st_table *vars, *retval;
    char *key, *vkey;
    var_info *cur_var;
    array_t *controls;
    vl_term *ctrl_i, *nond_out;
    int lo, hi;
    int idx, idx_lo, idx_hi;
    int h, i, j, k;
    vl_id_range *id_sym;
    blif_latch *latch;

    fprintf(file,"# conflict arbitrators\n");
    retval = st_init_table(strcmp, st_strhash);

    /* for all vars v,  if x touched in block-i, ... */
    gen = st_init_gen(vl_currentModule->sig_st);
    while (st_gen(gen, &key, &id_sym)) {
	/* generate multi-input-or for all cond_list in *var_info */

	/* if this is an input port, no one can assign it, hence  */
        /* assignment conflict can occur                          */
	if (id_sym->flags & InPort) continue;

	/* if this var is an var that is used as left hand side of */
        /* a non-blocking assignment, then the no conflict needed  */
	/* it will be taken care by non_block_assginment()         */
	if (st_lookup(vl_currentModule->latch_st, key, &latch) ||
	    strstr(key,SEP_LATCH)) continue;
	
	/* if this var is a wire (continuous assignment),          */
	/* then no nondeterministic control                        */   
        /* will not be generated                                   */
        /* besides, if a var is not declared to be wire/reg        */
        /* it's assumed to be a wire                               */
	if (!(id_sym->flags & RegVar) &&
	    id_sym->name[strlen(id_sym->name)-1]!='|') {
	    int num_changer=0;
	    /* find # of continuous assignments changes x */
	    /* header */
	    get_hilo(id_sym, &hi, &lo);
	    if ((id_sym->flags & MVar) && (lo <= hi)) {
		cp = buf; *cp = '\0';
		cp = strappend(cp, ".names ");
		for (i=0; i<array_n(vars_array); i++) {
		    vars = array_fetch(st_table*, vars_array, i);
		    if (vars) {
			if (st_lookup(vars, key, &cur_var)) {
			    num_changer++;
			    cp = strappendS(cp,
					    cur_var->current_terminal->name);
			}
		    }
		}
		if (!num_changer) continue;
		fprintf(file, "%s %s\n", buf, id_sym->name);
	    }

	    /* transition relation */
	    if (id_sym->flags &MVar) {
		/* mvar */
		for (i=0; i<num_changer; i++) {
		    for (j=lo; j<=hi; j++) {
			for (k=0; k<num_changer; k++) {
			    fprintf(file, "%c ", (i==k)?'0'+j:'-');
			}
			fprintf(file, "%d\n", j);
		    }
		}
	    } else if (lo > hi) {
		/* scalar */
		for (i=0; i<num_changer; i++) {
		    for (j=0; j<=1; j++) {
			for (k=0; k<num_changer; k++) {
			    fprintf(file, "%c ", (i==k)?'0'+j:'-');
			}
			fprintf(file, "%d\n", j);
		    }
		}
	    } else {
		/* vector */
		for (h=lo; h<=hi; h++) {
		    cp = buf; *cp = '\0';
		    cp = strappend(cp, ".names ");
		    for (i=0, num_changer=0; i<array_n(vars_array); i++) {
			vars = array_fetch(st_table*, vars_array, i);
			if (vars) {
			    if (st_lookup(vars, key, &cur_var)) {
				char tmp_buf[MAXSTRLEN];
				num_changer++;
				sprintf(tmp_buf, "%s%s%d%s",
					cur_var->current_terminal->name->name,
					SEP_LBITSELECT, h, SEP_RBITSELECT);
				cp = strappendS(cp, tmp_buf);
			    }
			}
		    }
		    if (!num_changer) continue;
		    fprintf(file, "%s %s%s%d%s\n", buf, id_sym->name,
			    SEP_LBITSELECT, h, SEP_RBITSELECT);
		    for (i=0; i<num_changer; i++) {
			for (j=0; j<=1; j++) {
			    for (k=0; k<num_changer; k++) {
				fprintf(file, "%c ", (i==k)?'0'+j:'-');
			    }
			    fprintf(file, "%d\n", j);
			}
		    }
		}
	    }
	    continue;
	}
	
	/* procedural assignments */

	controls = array_alloc(vl_term*, 0);

	/* generate controls for nondeterministic generator */
	for (i=0; i<array_n(vars_array); i++) {
	    vars = array_fetch(st_table*, vars_array, i);
	    if (vars) {
		if (st_lookup(vars, key, &cur_var)) {
		    ctrl_i = syndrome_to_control(file, key, 
						 vl_currentModule->sig_st);
		    array_insert_last(vl_term*, controls, ctrl_i);
		    continue;
		}
	    }
	    array_insert_last(vl_term*, controls, NIL(vl_term));
	}

	/* nondeterminism generator */
	assert(array_n(vars_array) == array_n(controls));
	get_hilo(id_sym, &hi, &lo);
	if (id_sym->flags &MVar) {
	    /* for mvar */
	    nond_out = new_term(NIL(vl_range), lo, hi);
	    nond_out->flag |= MVar;
	    write_mvar_decl(file, nond_out);
	    /* 2. change var_info for cur_var */
	    st_insert(retval, key, 
		      create_var_info(vl_copy_id_range(id_sym), nond_out));

	    if (id_sym->range) {
		idx_lo = vl_eval_expr(id_sym->range->left);
		if (id_sym->range->right)
		    idx_hi = vl_eval_expr(id_sym->range->right);
		else
		    idx_hi = idx_lo;
	    } else {
		idx_lo = idx_hi = 0;
	    }

	    for (idx=idx_lo; idx<=idx_hi; idx++) {
		/* 1. header */
		cp = buf; *cp = '\0';
		cp = strappend(cp, ".names ");
		for (i=0; i<array_n(controls); i++) {
		    char tmp_buf[MAXSTRLEN];
		    ctrl_i = array_fetch(vl_term*, controls, i);
		    if (ctrl_i) {
			vars = array_fetch(st_table*, vars_array, i);
			st_lookup(vars, key, &cur_var);
			cp = strappendS(cp, ctrl_i->name->name);
			if (id_sym->range) {
			    sprintf(tmp_buf, "%s%s%d%s",
				    cur_var->current_terminal->name->name,
				    SEP_LARRAY, idx, SEP_RARRAY);
			} else {
			    sprintf(tmp_buf, "%s",
				    cur_var->current_terminal->name->name);
			}
			cp = strappendS(cp, tmp_buf);
		    } else {
			cp = strappendS(cp, WRT_BLIF_GND(file));
			cp = strappendS(cp, WRT_BLIF_GND(file));
		    }
		}

		strcpy(buf_old, id_sym->name);
		strip_char(buf_old, '|');
		if (id_sym->range) {
		    sprintf(buf_new, "%s%s%d%s",
			    buf_old, SEP_LARRAY, idx, SEP_RARRAY);
		} else {
		    strcpy(buf_new, buf_old);
		}
		cp = strappendS(cp, buf_new);

		if (id_sym->range) {
		    sprintf(buf_new, "%s%s%d%s",
			    nond_out->name->name, SEP_LARRAY, idx, SEP_RARRAY);
		} else {
		    strcpy(buf_new, nond_out->name->name);
		}
		cp = strappendS(cp, buf_new);

		fprintf(file, "%s\n", buf);

		/* 3. transition relation */
		for (i=0; i<array_n(controls); i++) {
		    for (j=lo; j<= hi; j++) {
			for (k=0; k<i; k++) {
			    fprintf(file,"- - ");
			}
			fprintf(file, "1 %d ", j);
			for (k=i+1; k<array_n(controls); k++) {
			    fprintf(file, "- - ");
			}
			fprintf(file, "- %d\n", j);
		    }
		}
		/* 4. if no one assigns it */
		for (i=lo; i<=hi; i++) {
		    for (j=0; j<array_n(controls); j++) {
			fprintf(file, "0 - ");
		    }
		    fprintf(file, "%d %d\n", i, i);
		}
	    }
    	} else {
	    /* for bvar */
	    if (lo > hi) {
		/* scalar */
		nond_out = new_term(NIL(vl_range), lo, hi);
		/* 2. change var_info for cur_var */
		st_insert(retval, key, 
			  create_var_info(vl_copy_id_range(id_sym), nond_out));
		
		if (id_sym->range) {
		    idx_lo = vl_eval_expr(id_sym->range->left);
		    if (id_sym->range->right)
			idx_hi = vl_eval_expr(id_sym->range->right);
		    else
			idx_hi = idx_lo;
		} else {
		    idx_lo = idx_hi = 0;
		}

		for (idx=idx_lo; idx<=idx_hi; idx++) {
		    /* 1. header */
		    cp = buf; *cp = '\0';
		    cp = strappend(cp, ".names ");
		    for (i=0; i<array_n(controls); i++) {
			char tmp_buf[MAXSTRLEN];
			ctrl_i = array_fetch(vl_term*, controls, i);
			if (ctrl_i) {
			    vars = array_fetch(st_table*, vars_array, i);
			    st_lookup(vars, key, &cur_var);
			    cp = strappendS(cp, ctrl_i->name->name); 
			    if (id_sym->range) {
				sprintf(tmp_buf, "%s%s%d%s",
					cur_var->current_terminal->name->name,
					SEP_LARRAY, idx, SEP_RARRAY);
			    } else {
				sprintf(tmp_buf, "%s",
					cur_var->current_terminal->name->name);
			    }
			    cp = strappendS(cp, tmp_buf);
			} else {
			    cp = strappendS(cp, WRT_BLIF_GND(file));
			    cp = strappendS(cp, WRT_BLIF_GND(file));
			}
		    }

		    strcpy(buf_old, id_sym->name);
		    strip_char(buf_old, '|');
		    if (id_sym->range) {
			sprintf(buf_new, "%s%s%d%s",
				buf_new, SEP_LARRAY, idx, SEP_RARRAY);
		    } else {
			strcpy(buf_new, buf_old);
		    }
		    cp = strappendS(cp, buf_old);

		    if (id_sym->range) {
			sprintf(buf_new, "%s%s%d%s",
				nond_out->name->name, 
				SEP_LARRAY, idx, SEP_RARRAY);
		    } else {
			strcpy(buf_new, nond_out->name->name);
		    }
		    cp = strappendS(cp, buf_new);

		    fprintf(file, "%s\n", buf);
		    /* 3. transition relation */
		    for (i=0; i<array_n(controls); i++) {
			for (j=0; j<= 1; j++) {
			    for (k=0; k<i; k++) {
				fprintf(file,"- - ");
			    }
			    fprintf(file, "1 %d ", j);
			    for (k=i+1; k<array_n(controls); k++) {
				fprintf(file, "- - ");
			    }
			    fprintf(file, "- %d\n", j);
			}
		    }
		    /* 4. if no one assigns it */
		    for (i=0; i<=1; i++) {
			for (j=0; j<array_n(controls); j++) {
			    fprintf(file, "0 - ");
			}
			fprintf(file, "%d %d\n", i, i);
		    }
		}
	    } else {
		/* vector */
		nond_out = new_term(NIL(vl_range), lo, hi);
		/* 2. change var_info for cur_var */
		st_insert(retval, key, 
			  create_var_info(vl_copy_id_range(id_sym), nond_out));
		
		if (id_sym->range) {
		    idx_lo = vl_eval_expr(id_sym->range->left);
		    if (id_sym->range->right)
			idx_hi = vl_eval_expr(id_sym->range->right);
		    else
			idx_hi = idx_lo;
		} else {
		    idx_lo = idx_hi = 0;
		}
		
		for (idx=idx_lo; idx<=idx_hi; idx++) {
		    for (h=lo; h<=hi; h++) {
			/* 1. header */
			cp = buf; *cp = '\0';
			cp = strappend(cp, ".names ");
			for (i=0; i<array_n(controls); i++) {
			    char tmp_buf[MAXSTRLEN];
			    ctrl_i = array_fetch(vl_term*, controls, i);
			    if (ctrl_i) {
				char buf_ctrl[MAXSTRLEN], buf_var[MAXSTRLEN];

				vars = array_fetch(st_table*, vars_array, i);
				st_lookup(vars, key, &cur_var);
				sprintf(buf_ctrl, "%s", ctrl_i->name->name);

				sprintf(buf_var, "%s%s%d%s",
					cur_var->current_terminal->name->name,
					SEP_LBITSELECT, h, SEP_RBITSELECT);
				cp = strappendS(cp, buf_ctrl);
				cp = strappendS(cp, buf_var);
			    } else {
				cp = strappendS(cp, WRT_BLIF_GND(file));
				cp = strappendS(cp, WRT_BLIF_GND(file));
			    }
			}
			if (id_sym->range) {
			    sprintf(buf_tmp, "%s%s%d%s%s%d%s %s%s%d%s%s%d%s", 
				    strip_char(strdup(id_sym->name), '|'),
				    SEP_LARRAY, idx, SEP_RARRAY,
				    SEP_LBITSELECT, h, SEP_RBITSELECT,
				    nond_out->name->name, 
				    SEP_LARRAY, idx, SEP_RARRAY,
				    SEP_LBITSELECT, h, SEP_RBITSELECT);
			} else {
			    sprintf(buf_tmp, "%s%s%d%s %s%s%d%s", 
				    strip_char(strdup(id_sym->name), '|'),
				    SEP_LBITSELECT, h, SEP_RBITSELECT,
				    nond_out->name->name, 
				    SEP_LBITSELECT, h, SEP_RBITSELECT);
			}
			cp = strappendS(cp, buf_tmp);
			fprintf(file, "%s\n", buf);
			/* 3. transition relation */
			for (i=0; i<array_n(controls); i++) {
			    for (j=0; j<= 1; j++) {
				for (k=0; k<i; k++) {
				    fprintf(file,"- - ");
				}
				fprintf(file, "1 %d ", j);
				for (k=i+1; k<array_n(controls); k++) {
				    fprintf(file, "- - ");
				}
				fprintf(file, "- %d\n", j);
			    }
			}
			/* 4. if no one assigns it */
			for (i=0; i<=1; i++) {
			    for (j=0; j<array_n(controls); j++) {
				fprintf(file, "0 - ");
			    }
			    fprintf(file, "%d %d\n", i, i);
			}
		    }
		}
	    }
	}
	array_free(controls);
    }
    st_free_gen(gen);

    return retval;
}

/*
 * write_local_control
 *
 *     when ctrl dominates sub_ctrls, this circuit create the logic for
 *     it.
 *
 * argument:
 *
 *     ctrl: dominating control
 *     sub_ctrls: lsList of *vl_term, controlled ctrl.
 *     inverted: if ctrl need to be viewed a complemented signal.
 *
 * returns:
 *
 *     new control signal
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 */
vl_term *write_local_control(file, ctrl, sub_ctrls, inverted)
FILE *file;
vl_term *ctrl;
lsList sub_ctrls;
int inverted;
{
    int i, j;
    vl_term *retval;
    lsGen gen;
    lsHandle handle;
    vl_term *sub_ctrl;
    int unconditional_assign = 0;

    /* this routine is not in need now 01/12/93 */
    /* return NIL(vl_term); */

    if (!sub_ctrls)
	unconditional_assign = 1;
    else if (lsLength(sub_ctrls)==0)
	unconditional_assign = 1;

    if (unconditional_assign) {
	retval = new_term(NIL(vl_range), 0, -1);
	vl_write_bit_connect(file, ctrl->name->name, retval->name->name, 
			     inverted);
	return retval;
    }

    retval = new_term(NIL(vl_range), 0, -1);

    fprintf(file, ".names %s ", ctrl->name->name);
    gen = lsStart(sub_ctrls);
    if (lsNext(gen, &sub_ctrl, &handle) == LS_OK) {
	fprintf(file, "%s ", ((vl_term*)(((int)sub_ctrl)&~1))->name->name);
	while (lsNext(gen, &sub_ctrl, &handle) != LS_NOMORE) {
	    fprintf(file, "%s ", ((vl_term*)(((int)sub_ctrl)&~1))->name->name);
	}
    }
    lsFinish(gen);
    fprintf(file, "%s\n", retval->name->name);

    for (i=0; i<lsLength(sub_ctrls); i++) {
	fprintf(file, "%c ", (inverted)?'0':'1');
	for (j=0; j<lsLength(sub_ctrls); j++) {
	    fprintf(file, "%c ", (i==j)?'1':'-');
	}
	fprintf(file, "1\n");
    }

    fprintf(file, "%c ", (inverted)?'0':'1');
    gen = lsStart(sub_ctrls);
    if (lsNext(gen, &sub_ctrl, &handle) == LS_OK) {
	fprintf(file, "%c ", ((int)sub_ctrl&1)?'1':'0');
	while (lsNext(gen, &sub_ctrl, &handle) != LS_NOMORE) {
	    fprintf(file, "%c ", ((int)sub_ctrl&1)?'1':'0');
	}
    }
    lsFinish(gen);
    fprintf(file, "0\n");

    fprintf(file, "%c ", (inverted)?'1':'0');
    for (i=0; i<lsLength(sub_ctrls); i++) {
	fprintf(file, "%c ", '-');
    }
    fprintf(file, "0\n");

    return retval;
}

/*
 * st_union
 *
 *     given st1, st2, st_union take union of their elements and
 *     put the union in st1 (so st1 will be destructed).
 * 
 * argument: st1, st2
 *
 * returns: st1
 *
 * side effects:
 *
 * bugs:
 *
 * comments:
 *     st1, st2 is accessed as symbol table of *var_info
 */
st_table *st_union(st1, st2)
st_table *st1;
st_table *st2;
{
    st_generator *gen;
    char *key;
    var_info *vinfo, *vinfo1;

    gen = st_init_gen(st2);
    while (st_gen(gen, &key, &vinfo)) {
	if (!st_lookup(st1, key, &vinfo1)) {
	    st_insert(st1, key, vinfo);
	}
    }
    st_free_gen(gen);
}

void print_control_var_pair(file, ctrl, var)
FILE *file;
char *ctrl;
char *var;
{
    fprintf(file, "%s %s ", ctrl, var);
}

vl_term *write_multi_in_or(file, in_list)
FILE *file;
lsList in_list;
{
    lsGen gen;
    lsHandle handle;
    vl_term *term_out;
    vl_term *in_term, *true_in_term;
    int i, j;

    term_out = new_term(NIL(vl_range), 0, -1);

    fprintf(file, ".names ");
    gen = lsStart(in_list);
    if (lsNext(gen, &in_term, &handle) == LS_OK) {
	true_in_term = (vl_term*)((int)in_term & (~1));
	fprintf(file, "%s ", true_in_term->name->name);
	while (lsNext(gen, &in_term, &handle) != LS_NOMORE) {
	    true_in_term = (vl_term*)((int)in_term & (~1));
	    fprintf(file, "%s ", true_in_term->name->name);
	}
    }
    fprintf(file, "%s\n", term_out->name->name);
    lsFinish(gen);

    gen = lsStart(in_list);
    for (i=0; i<lsLength(in_list); i++) {
	lsNext(gen, &in_term, &handle);
	for (j=0; j<lsLength(in_list); j++) {
	    fprintf(file, "%c ", (i==j)?(((int)in_term&1)?'0':'1'):'-');
	}
	fprintf(file, "1\n");
    }
    lsFinish(gen);

    gen = lsStart(in_list);
    if (lsNext(gen, &in_term, &handle) == LS_OK) {
	fprintf(file, "%c ", ((int)in_term&1)?'1':'0');
	while (lsNext(gen, &in_term, &handle) != LS_NOMORE) {
	    fprintf(file, "%c ", ((int)in_term&1)?'1':'0');
	}
    }
    lsFinish(gen);
    fprintf(file, "0\n");

    return term_out;
}

/*
 * write_mvar_decl
 *
 *     write .mv declaration for term
 */
void write_mvar_decl(file, term)
FILE *file;
vl_term *term;
{
    int i, hi, lo;
    
    if (!(term->flag & MVar)) return;

    hi = term->hi; lo = term->lo;
    fprintf(file, ".mv %s %d ", term->name->name, hi-lo+1);
    for (i=lo; i<=hi; i++) {
	fprintf(file, "%d ", i);
    }
    fprintf(file, "\n");
}

vl_write_initial_generator(file)
FILE *file;
{
    char buf[MAXSTRLEN];

    /* only top module needs to generate initial signal generator */
    if (ith_module!=0) return;

    sprintf(buf, "%s%s", Initial_Signal->name->name, "_PS");
    fprintf(file, ".r %s=1\n", Initial_Signal->name->name);
    fprintf(file, ".names %s\n", buf);
    fprintf(file, "0\n");
    fprintf(file, ".latch %s %s\n", buf, Initial_Signal->name->name);
}

vl_term *syndrome_to_control(file, key, sig_st)
FILE *file;
char *key;
st_table *sig_st;
{
    vl_term *retval=NIL(vl_term);
    vl_id_range *id_sym;
    syndrome_expr *se;
    vl_term *ctrl_term;
    int se_len=0;
    char *syndrome;
    lsList comp;
    lsGen gen;
    lsHandle handle;

    if (!st_lookup(sig_st, key, &id_sym)) return true_term(file);

    retval = new_term(NIL(vl_range), 0, -1);
    fprintf(file, ".names ");
    for (gen=lsStart(ctrl_list); lsNext(gen,&ctrl_term,&handle)!=LS_NOMORE; ) {
	fprintf(file, "%s ", ctrl_term->name->name);
    }
    fprintf(file, "%s\n", retval->name->name);

    for (gen=lsStart(id_sym->syndrome_expr_list); 
	 lsNext(gen,&se,&handle)!=LS_NOMORE; ) {
	se_len = put_entry(file, se->syndrome);
	fprintf(file, "1\n");
    }

    comp=put_guard_zero(file, id_sym->syndrome_expr_list);
    for (gen=lsStart(comp); lsNext(gen,&syndrome,&handle)!=LS_NOMORE; ) {
	put_entry(file, syndrome);
	fprintf(file, "0\n");
    }
    
    return retval;
}

int put_entry(file, str)
FILE *file;
char *str;
{
    int i;

    for (i=0; i<strlen(str); i++) {
	fprintf(file, "%c ", str[i]);
    }

    return i;
}

lsList put_guard_zero(file, se_list)
FILE *file;
lsList se_list;
{
    /* not really <complement> yet */
    lsList retval;
    lsHandle handle;
    lsGen gen;
    FILE *scratch_file;
    char cmd[MAXSTRLEN];
    int output_id, tmp_id;
    syndrome_expr *se;

    scratch_file = open_file(SCRATCH_FILE, "w");

    output_id = put_blif_header(scratch_file, se_list);

    tmp_id = put_blif_gate_header(scratch_file, se_list);
    for (gen=lsStart(se_list); lsNext(gen,&se,&handle)!=LS_NOMORE; ) {
	fprintf(scratch_file, "%s ", se->syndrome);
	fprintf(scratch_file, "1\n");
    }

    fprintf(scratch_file, ".names n%d n%d\n", tmp_id, output_id);
    fprintf(scratch_file, "0 1\n");

    put_blif_tail(scratch_file);
    close_file(scratch_file);

    sprintf(cmd, "sis -f %s %s >%s 2>&1", SCRIPT_NAME, SCRATCH_FILE, SIS_LOG);
    system(cmd);

    scratch_file = open_file("gate.o", "r");
    retval = get_transition(scratch_file);
    close_file(scratch_file);

    return retval;
}

non_block_assignment(file, vars)
FILE *file;
st_table *vars;
{
    st_generator *gen;
    lsList comp;
    lsGen lgen;
    lsHandle handle;
    char *key;
    char latch_name[MAXSTRLEN];
    char *syndrome;
    vl_id_range *id_sym;
    syndrome_expr *se;
    vl_term *out_term, *ctrl_term, *expr_term;
    int n_entries, se_len=0, i, j, k, l, hi, lo;

    gen = st_init_gen(vl_currentModule->sig_st);
    while (st_gen(gen, &key, &id_sym)) {
	if (!strstr(key,SEP_LATCH)) continue;
	
	/* create logic */
	strcpy(latch_name, id_sym->name);
	strip_char(latch_name, '|');
	n_entries = lsLength(id_sym->syndrome_expr_list);
	get_hilo(id_sym, &hi, &lo);
	out_term = new_term(NIL(vl_range), lo, hi);

	if ((id_sym->flags & MVar) || (lo > hi)) {
	    /* mvar || scalar */
	    /* header */
	    fprintf(file, ".names ");
	    for (lgen=lsStart(ctrl_list);
		 lsNext(lgen,&ctrl_term,&handle)!=LS_NOMORE;) {
		fprintf(file, "%s ", ctrl_term->name->name);
	    }
	    (void)lsFinish(lgen);
	    for (lgen=lsStart(id_sym->syndrome_expr_list);
		 lsNext(lgen,&se,&handle)!=LS_NOMORE;) {
		fprintf(file, "%s ", se->expr->name->name);
	    }
	    (void)lsFinish(lgen);
	    fprintf(file, "%s ", latch_name);
	    fprintf(file, "%s\n", out_term->name->name);

	    for (lgen=lsStart(id_sym->syndrome_expr_list), i=0;
		 lsNext(lgen,&se,&handle)!=LS_NOMORE; i++) {
		if (!(id_sym->flags & MVar)) {
		    lo=0; hi=1;
		}

		for (k=lo; k<=hi; k++) {
		    se_len = put_entry(file, se->syndrome);
		    for (j=0; j<i; j++) fprintf(file, "- ");
		    fprintf(file, "%d ", k); j++;
		    for (; j<n_entries; j++) fprintf(file, "- ");
		    fprintf(file, "- %d\n", k);
		}
	    }
	    lsFinish(lgen);

	    comp = put_guard_zero(file, id_sym->syndrome_expr_list);
	    for (lgen=lsStart(comp); 
		 lsNext(lgen,&syndrome,&handle)!=LS_NOMORE;) {
		if (!(id_sym->flags & MVar)) {
		    lo=0; hi=1;
		}
		for (k=lo; k<=hi; k++) {
		    se_len = put_entry(file, syndrome);
		    for (j=0; j<n_entries; j++) fprintf(file, "- ");
		    fprintf(file, "%d %d\n", k, k);
		}
	    }
	    lsFinish(lgen);
	} else {
	    for (l=lo; l<=hi; l++) {
		/* vector */
		/* header */
		fprintf(file, ".names ");
		for (lgen=lsStart(ctrl_list);
		     lsNext(lgen,&ctrl_term,&handle)!=LS_NOMORE;) {
		    fprintf(file, "%s ", ctrl_term->name->name);
		}
		(void)lsFinish(lgen);
		for (lgen=lsStart(id_sym->syndrome_expr_list);
		     lsNext(lgen,&se,&handle)!=LS_NOMORE;) {
		    fprintf(file, "%s%s%d%s ", 
			    se->expr->name->name, 
			    SEP_LBITSELECT, l, SEP_RBITSELECT);
		}
		(void)lsFinish(lgen);
		fprintf(file, "%s%s%d%s ", 
			latch_name,
			SEP_LBITSELECT, l, SEP_RBITSELECT);
		fprintf(file, "%s%s%d%s\n", 
			out_term->name->name,
			SEP_LBITSELECT, l, SEP_RBITSELECT);
		
		for (lgen=lsStart(id_sym->syndrome_expr_list), i=0;
		     lsNext(lgen,&se,&handle)!=LS_NOMORE; i++) {
		    for (k=0; k<=1; k++) {
			se_len = put_entry(file, se->syndrome);
			for (j=0; j<i; j++) fprintf(file, "- ");
			fprintf(file, "%d ", k); j++;
			for (; j<n_entries; j++) fprintf(file, "- ");
			fprintf(file, "- %d\n", k);
		    }
		}
		
		comp = put_guard_zero(file, id_sym->syndrome_expr_list);
		for (lgen=lsStart(comp); 
		     lsNext(lgen,&syndrome,&handle)!=LS_NOMORE;) {
		    if (!(id_sym->flags & MVar)) {
			lo=0; hi=1;
		    }
		    for (k=lo; k<=hi; k++) {
			se_len = put_entry(file, syndrome);
			for (j=0; j<n_entries; j++) fprintf(file, "- ");
			fprintf(file, "%d %d\n", k, k);
		    }
		}
		lsFinish(lgen);
	    }
	}

	/* change var_info */
	st_insert(vars, key, 
		  create_var_info(vl_copy_id_range(id_sym), out_term));
    }
    st_free_gen(gen);
}

int put_blif_header(file, se_list)
FILE *file;
lsList se_list;
{
    int terminal_count=0;
    int retval, i;
    syndrome_expr *se;

    fprintf(file, ".model scratch\n");
    fprintf(file, ".outputs n%d\n", retval = terminal_count++);
    if (lsLength(se_list)) {
	fprintf(file, ".inputs");
	lsFirstItem(se_list, &se, 0);
	for (i=0; i<strlen(se->syndrome); i++) {
	    fprintf(file, " n%d", terminal_count++);
	}
	fprintf(file, "\n");
    }
    return retval;
}

int put_blif_gate_header(file, se_list)
FILE *file;
lsList se_list;
{
    int terminal_count=0;
    int retval, i;
    syndrome_expr *se;

    fprintf(file, ".names");
    if (lsLength(se_list)) {
	lsFirstItem(se_list, &se, 0);
	for (i=0; i<strlen(se->syndrome); i++) {
	    fprintf(file, " n%d", ++terminal_count);
	}
    }
    fprintf(file, " n%d\n", retval = ++terminal_count);
    return retval;
}

put_blif_tail(file)
FILE *file;
{
    fprintf(file, ".end\n");
}

lsList get_transition(file)
FILE *file;
{
    lsList retval;
    char buf[MAXSTRLEN], *cp;
    char syndrome[MAXSTRLEN];
    int n_entries, i;

    retval = lsCreate();
    while (fgets(buf, MAXSTRLEN-1, file)) {
	if (cp = strstr(buf, ".p")) {
	    cp += strlen(".p");
	    n_entries = atoi(cp);
	    for (i=0; i<n_entries && fgets(buf, MAXSTRLEN-1, file); i++) {
		sscanf(buf, "%s", syndrome);
		lsNewEnd(retval, strdup(syndrome), 0);
	    }
	    break;
	}
    }
    return retval;
}

write_switch(file, id_sym, sel, orig, new, out_term)
FILE *file;
vl_id_range *id_sym;
vl_term *sel;
vl_term *orig;
vl_term *new;
vl_term *out_term;
{
    int lo, hi;
    int bit_hi, bit_lo;
    int idx;
    vl_expr *hi_expr;
    char new_buf[MAXSTRLEN], orig_buf[MAXSTRLEN], out_buf[MAXSTRLEN];

    get_hilo(id_sym, &bit_hi, &bit_lo);

    lo = vl_eval_expr(out_term->name->range->left);
    if (out_term->name->range->right)
	hi = vl_eval_expr(out_term->name->range->right);
    else
	hi = lo;

    hi_expr = vl_create_expr(IntExpr, hi, (double)0.0,
			     NIL(void), NIL(void), NIL(void));
    for (idx=lo; idx<=hi; idx++) {
	vl_term *ctrl;
	vl_term *new_elt, *orig_elt, *out_elt;
	vl_expr *const_expr;
	vl_term *const_trm;
	/* constants */
	const_expr = vl_create_expr(IntExpr, idx, (double)0.0,
				    NIL(void), NIL(void), NIL(void));
	const_trm = new_term(NIL(vl_range), 0, data_width(hi_expr)-1);
	vl_write_const(file, const_expr, const_trm);
	chk_free(const_expr);

	/* comparator & control signals */
	ctrl = new_term(NIL(vl_range), 0, -1);
	vl_write_bin_comp(file, Beq2Expr, const_trm, sel, ctrl);

	/* muxes */
	sprintf(new_buf, "%s%s%d%s", 
		new->name->name, SEP_LARRAY, idx, SEP_RARRAY);
	sprintf(orig_buf, "%s%s%d%s", 
		orig->name->name, SEP_LARRAY, idx, SEP_RARRAY);
	sprintf(out_buf, "%s%s%d%s", 
		out_term->name->name, SEP_LARRAY, idx, SEP_RARRAY);
	new_elt = new;
	orig_elt = create_rename_term(orig, orig_buf, bit_lo, bit_hi);
	orig_elt->name->range = NIL(vl_range);
	out_elt = create_rename_term(out_term, out_buf, bit_lo, bit_hi);
	out_elt->name->range = NIL(vl_range);
	instantiate_mux(file, new_elt, orig_elt, ctrl, out_elt, 
			bit_lo, bit_hi);
    }
    chk_free(hi_expr);
}



   for (i=0; i<lsLength(in_list); i++) {
	lsNext(gen, &in_term, &handle);
	for (j=0; j<lsLength(in_list); j++) {
	    fprintf(file, "%c ", (i==j)?(((int)in_term&1)?'0':'1'):'-');
	}
	fprintf(file, "1\n");
    }
    lsFinish(gen);

    gen = lsStart(vl2mv/src/list/                                                                                     040755  027004  000214  00000000000 05402724326 010032  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/src/list/Makefile                                                                             100644  027004  000214  00000001320 05332026170 012266  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #/*
# * Revision Control Information
# *
# * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/Makefile,v $
# * $Author: sis $
# * $Revision: 1.2 $
# * $Date: 1992/05/06 18:55:32 $
# *
# */
# list -- generic list package from David Harrison
#----------------------------------------------------------------------

LIB_DIR = ../../lib

P	= list
PSRC	= list.c
POBJ	= list.o
PHDR	= list.h
MISC	= list.doc Makefile

INCLUDE = -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a

clean:
	rm -f $(TARGET) *.a *.o \
>syndrome_expr_list); 
	 lsNext(gen,&se,&handle)!=LS_NOMORE; ) {
	se_len = put_entry(file, se->syndrome);
	fprintf(file, "1\n");
    }

    comp=put_guard_zero(file, id_sym->syndrome_expr_list);
    for (gen=lsStart(comp); lsNext(gen,&syndrome,&handle)!=LS_NOMORE; ) {
	put_entry(file, syndrome);
	fprintvl2mv/src/list/list.c                                                                               100644  027004  000214  00000060567 05332024462 011771  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
 * Revision Control Information
 *
 * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/list.c,v $
 * $Author: sis $
 * $Revision: 1.2 $
 * $Date: 1992/05/06 18:55:32 $
 *
 */
/*
 * List Management Package
 * 
 * David Harrison
 * University of California, Berkeley, 1985
 *
 * This package implements a simple generic linked list data type.  It
 * uses a doubly linked list structure and provides some standard operations
 * for storing and retrieving data from the list.
 */

#include "util.h"
#include "list.h"		/* Self declaration        */

#define alloc(type)	(type *) malloc(sizeof(type))

/*
 * The list identifier is in reality a pointer to the following list
 * descriptor structure.  Lists are doubly linked with both top and
 * bottom pointers stored in the list descriptor.  The length
 * of the list is also stored in the descriptor.
 */

typedef struct list_elem {	/* One list element  */
    struct list_desc *mainList;	/* List descriptor   */
    struct list_elem *prevPtr;	/* Previous element  */
    struct list_elem *nextPtr;	/* Next list element */
    lsGeneric userData;		/* User pointer      */
} lsElem;

typedef struct list_desc {	/* List descriptor record            */
    lsElem *topPtr, *botPtr;	/* Pointer to top and bottom of list */
    int length;			/* Length of list                    */
} lsDesc;


/*
 * Generators are in reality pointers to the generation descriptor 
 * defined below.  A generator has a current spot which is *between*
 * two items.  Thus,  a generator consists of two pointers:  record
 * before spot and record after spot.  A pointer to the main list
 * is included so the top and bottom pointers of the list can be
 * modified if needed.
 */

typedef struct gen_desc {	/* Generator Descriptor 	*/
    lsDesc *mainList;		/* Pointer to list descriptor   */
    lsElem *beforeSpot;		/* Item before the current spot */
    lsElem *afterSpot;		/* Item after the current spot  */
} lsGenInternal;

/*
 * Handles are in reality pointers to lsElem records.  They are
 * cheap to generate and need not be disposed.
 */



/*
 * List Creation and Deletion
 */

lsList lsCreate()
/*
 * Creates a new linked list and returns its handle.  The handle is used
 * by all other list manipulation routines and should not be discarded.
 */
{
    lsDesc *newList;

    newList = alloc(lsDesc);
    newList->topPtr = newList->botPtr = NIL(lsElem);
    newList->length = 0;
    return( (lsList) newList );
}

lsStatus lsDestroy(list, delFunc)
lsList list;			/* List to destroy              */
void (*delFunc)();		/* Routine to release user data */
/*
 * Frees all resources associated with the specified list.  It frees memory
 * associated with all elements of the list and then deletes the list.
 * User data is released by calling 'delFunc' with the pointer as the
 * argument.  Accessing a list after its destruction is a no-no.
 */
{
    lsDesc *realList;
    lsElem *index, *temp;

    realList = (lsDesc *) list;
    /* Get rid of elements */
    index = realList->topPtr;
    while (index != NIL(lsElem)) {
	temp = index;  index = index->nextPtr;
	if (delFunc)
	  (*delFunc)(temp->userData);
	free((lsGeneric) temp);
    }
    /* Get rid of descriptor */
    free((lsGeneric) realList);
    return(LS_OK);
}


/*
 * Copying lists
 */

static lsGeneric lsIdentity(data)
lsGeneric data;
/* Identity copy function */
{
    return data;
}

lsList lsCopy(list, copyFunc)
lsList list;			/* List to be copied         */
lsGeneric (*copyFunc)();	/* Routine to copy user data */
/*
 * Returns a copy of list `list'.  If `copyFunc' is non-zero,
 * it will be called for each item in `list' and the pointer it 
 * returns will be used in place of the original user data for the 
 * item in the newly created list.  The form of `copyFunc' should be:
 *   lsGeneric copyFunc(data)
 *   lsGeneric data;
 * This is normally used to make copies of the user data in the new list.
 * If no `copyFunc' is provided,  an identity function is used.
 */
{
    lsList newList;
    lsGen gen;
    lsGeneric data;

    if (!copyFunc) copyFunc = lsIdentity;
    newList = lsCreate();
    gen = lsStart(list);
    while (lsNext(gen, &data, LS_NH) == LS_OK) {
	(void) lsNewEnd(newList, (*copyFunc)(data), LS_NH);
    }
    lsFinish(gen);
    return newList;
}


/*
 * Adding New Elements to the Beginning and End of a List
 */

lsStatus lsNewBegin(list, data, itemHandle)
lsList list;			/* List to add element to    */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to data (returned) */
/*
 * Adds a new item to the start of a previously created linked list.
 * If 'itemHandle' is non-zero,  it will be filled with a handle
 * which can be used to generate a generator positioned at the
 * item without generating through the list.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsElem *newElem;

    newElem = alloc(lsElem);
    newElem->userData = data;
    newElem->nextPtr = realList->topPtr;
    newElem->prevPtr = NIL(lsElem);
    newElem->mainList = realList;
    if (realList->topPtr == NIL(lsElem)) {
	/* The new item is both the top and bottom element */
	realList->botPtr = newElem;
    } else {
	/* There was a top element - make its prev correct */
	realList->topPtr->prevPtr = newElem;
    }
    realList->topPtr = newElem;
    realList->length += 1;
    if (itemHandle) *itemHandle = (lsHandle) newElem;
    return(LS_OK);
}

lsStatus lsNewEnd(list, data, itemHandle)
lsList list;			/* List to append element to */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to data (returned) */
/*
 * Adds a new item to the end of a previously created linked list.
 * This routine appends the item in constant time and
 * can be used freely without guilt.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsElem *newElem;

    newElem = alloc(lsElem);
    newElem->userData = data;
    newElem->prevPtr = realList->botPtr;
    newElem->nextPtr = NIL(lsElem);
    newElem->mainList = realList;
    if (realList->topPtr == NIL(lsElem))
      realList->topPtr = newElem;
    if (realList->botPtr != NIL(lsElem))
      realList->botPtr->nextPtr = newElem;
    realList->botPtr = newElem;
    realList->length += 1;
    if (itemHandle) *itemHandle = (lsHandle) newElem;
    return(LS_OK);
}

/*
 * Retrieving the first and last items of a list
 */

lsStatus lsFirstItem(list, data, itemHandle)
lsList list;			/* List to get item from */
lsGeneric *data;			/* User data (returned)  */
lsHandle *itemHandle;	/* Handle to data (returned) */
/*
 * Returns the first item in the list.  If the list is empty,
 * it returns LS_NOMORE.  Otherwise,  it returns LS_OK.
 * If 'itemHandle' is non-zero,  it will be filled with a
 * handle which may be used to generate a generator.
 */
{
    lsDesc *realList = (lsDesc *) list;

    if (realList->topPtr != NIL(lsElem)) {
	*data = realList->topPtr->userData;
	if (itemHandle) *itemHandle = (lsHandle) (realList->topPtr);
	return(LS_OK);
    } else {
	*data = (lsGeneric) 0;
	if (itemHandle) *itemHandle = (lsHandle) 0;
	return(LS_NOMORE);
    }
}

lsStatus lsLastItem(list, data, itemHandle)
lsList list;			/* List to get item from */
lsGeneric *data;			/* User data (returned)  */
lsHandle *itemHandle;	/* Handle to data (returned) */
/*
 * Returns the last item of a list.  If the list is empty,
 * the routine returns LS_NOMORE.  Otherwise,  'data' will
 * be set to the last item and the routine will return LS_OK.
 * If 'itemHandle' is non-zero,  it will be filled with a
 * handle which can be used to generate a generator postioned
 * at this item.
 */
{
    lsDesc *realList = (lsDesc *) list;

    if (realList->botPtr != NIL(lsElem)) {
	*data = realList->botPtr->userData;
	if (itemHandle) *itemHandle = (lsHandle) (realList->botPtr);
	return(LS_OK);
    } else {
	*data = (lsGeneric) 0;
	if (itemHandle) *itemHandle = (lsHandle) 0;
	return(LS_NOMORE);
    }
}



/* Length of a list */

int lsLength(list)
lsList list;			/* List to get the length of */
/*
 * Returns the length of the list.  The list must have been
 * already created using lsCreate.
 */
{
    lsDesc *realList = (lsDesc *) list;

    return(realList->length);
}



/*
 * Deleting first and last items of a list
 */

lsStatus lsDelBegin(list, data)
lsList list;			/* List to delete item from     */
lsGeneric *data;		/* First item (returned)        */
/*
 * This routine deletes the first item of a list.  The user
 * data associated with the item is returned so the caller
 * may dispose of it.  Returns LS_NOMORE if there is no
 * item to delete.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsElem *temp;

    if (realList->topPtr == NIL(lsElem)) {
	/* Nothing to delete */
	*data = (lsGeneric) 0;
	return LS_NOMORE;
    } else {
	*data = realList->topPtr->userData;
	temp = realList->topPtr;
	realList->topPtr = realList->topPtr->nextPtr;
	if (temp->nextPtr != NIL(lsElem)) {
	    /* There is something after the first item */
	    temp->nextPtr->prevPtr = NIL(lsElem);
	} else {
	    /* Nothing after it - bottom becomes null as well */
	    realList->botPtr = NIL(lsElem);
	}
	free((lsGeneric) temp);
	realList->length -= 1;
    }
    return LS_OK;
}


lsStatus lsDelEnd(list, data)
lsList list;			/* List to delete item from */
lsGeneric *data;			/* Last item (returned)     */
/*
 * This routine deletes the last item of a list.  The user
 * data associated with the item is returned so the caller
 * may dispose of it.  Returns LS_NOMORE if there is nothing
 * to delete.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsElem *temp;

    if (realList->botPtr == NIL(lsElem)) {
	/* Nothing to delete */
	*data = (lsGeneric) 0;
	return LS_NOMORE;
    } else {
	*data = realList->botPtr->userData;
	temp = realList->botPtr;
	realList->botPtr = realList->botPtr->prevPtr;
	if (temp->prevPtr != NIL(lsElem)) {
	    /* There is something before the last item */
	    temp->prevPtr->nextPtr = NIL(lsElem);
	} else {
	    /* Nothing before it - top becomes null as well */
	    realList->topPtr = NIL(lsElem);
	}
	free((lsGeneric) temp);
	realList->length -= 1;
    }
    return LS_OK;
}


/*
 * List Generation Routines
 *
 * nowPtr is the element just before the next one to be generated
 */

lsGen lsStart(list)
lsList list;			/* List to generate items from */
/*
 * This routine defines a generator which is used to step through
 * each item of the list.  It returns a generator handle which should
 * be used when calling lsNext, lsPrev, lsInBefore, lsInAfter, lsDelete,
 * or lsFinish.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsGenInternal *newGen;

    newGen = alloc(lsGenInternal);
    newGen->mainList = realList;
    newGen->beforeSpot = NIL(lsElem);
    newGen->afterSpot = realList->topPtr;
    return ( (lsGen) newGen );
}

lsGen lsEnd(list)
lsList list;			/* List to generate items from */
/*
 * This routine defines a generator which is used to step through
 * each item of a list.  The generator is initialized to the end 
 * of the list.
 */
{
    lsDesc *realList = (lsDesc *) list;
    lsGenInternal *newGen;

    newGen = alloc(lsGenInternal);
    newGen->mainList = realList;
    newGen->beforeSpot = realList->botPtr;
    newGen->afterSpot = NIL(lsElem);
    return (lsGen) newGen;
}

lsGen lsGenHandle(itemHandle, data, option)
lsHandle itemHandle;		/* Handle of an item         */
lsGeneric *data;			/* Data associated with item */
int option;			/* LS_BEFORE or LS_AFTER     */
/*
 * This routine produces a generator given a handle.  Handles
 * are produced whenever an item is added to a list.  The generator
 * produced by this routine may be used when calling any of 
 * the standard generation routines.  NOTE:  the generator
 * should be freed using lsFinish.  The 'option' parameter
 * determines whether the generator spot is before or after
 * the handle item.
 */
{
    lsElem *realItem = (lsElem *) itemHandle;
    lsGenInternal *newGen;

    newGen = alloc(lsGenInternal);
    newGen->mainList = realItem->mainList;
    *data = realItem->userData;
    if (option & LS_BEFORE) {
	newGen->beforeSpot = realItem->prevPtr;
	newGen->afterSpot = realItem;
    } else if (option & LS_AFTER) {
	newGen->beforeSpot = realItem;
	newGen->afterSpot = realItem->nextPtr;
    } else {
	free((lsGeneric) newGen);
	newGen = (lsGenInternal *) 0;
    }
    return ( (lsGen) newGen );
}


lsStatus lsNext(generator, data, itemHandle)
lsGen generator;		/* Generator handle        */
lsGeneric *data;			/* User data (return)      */
lsHandle *itemHandle;		/* Handle to item (return) */
/*
 * Generates the item after the item previously generated by lsNext
 * or lsPrev.   It returns a pointer to the user data structure in 'data'.  
 * 'itemHandle' may be used to get a generation handle without
 * generating through the list to find the item.  If there are no more 
 * elements to generate, the routine returns  LS_NOMORE (normally it 
 * returns LS_OK).  lsNext DOES NOT automatically clean up after all 
 * elements have been generated.  lsFinish must be called explicitly to do this.
 */
{
    register lsGenInternal *realGen = (lsGenInternal *) generator;

    if (realGen->afterSpot == NIL(lsElem)) {
	/* No more stuff to generate */
	*data = (lsGeneric) 0;
	if (itemHandle) *itemHandle = (lsHandle) 0;
	return LS_NOMORE;
    } else {
	*data = realGen->afterSpot->userData;
	if (itemHandle) *itemHandle = (lsHandle) (realGen->afterSpot);
	/* Move the pointers down one */
	realGen->beforeSpot = realGen->afterSpot;
	realGen->afterSpot = realGen->afterSpot->nextPtr;
	return LS_OK;
    }
}


lsStatus lsPrev(generator, data, itemHandle)
lsGen generator;		/* Generator handle        */
lsGeneric *data;		/* User data (return)      */
lsHandle *itemHandle;		/* Handle to item (return) */
/*
 * Generates the item before the item previously generated by lsNext
 * or lsPrev.   It returns a pointer to the user data structure in 'data'.  
 * 'itemHandle' may be used to get a generation handle without
 * generating through the list to find the item.  If there are no more 
 * elements to generate, the routine returns  LS_NOMORE (normally it 
 * returns LS_OK).  lsPrev DOES NOT automatically clean up after all 
 * elements have been generated.  lsFinish must be called explicitly to do this.
 */
{
    register lsGenInternal *realGen = (lsGenInternal *) generator;

    if (realGen->beforeSpot == NIL(lsElem)) {
	/* No more stuff to generate */
	*data = (lsGeneric) 0;
	if (itemHandle) *itemHandle = (lsHandle) 0;
	return LS_NOMORE;
    } else {
	*data = realGen->beforeSpot->userData;
	if (itemHandle) *itemHandle = (lsHandle) (realGen->afterSpot);
	/* Move the pointers down one */
	realGen->afterSpot = realGen->beforeSpot;
	realGen->beforeSpot = realGen->beforeSpot->prevPtr;
	return LS_OK;
    }

}

lsStatus lsInBefore(generator, data, itemHandle)
lsGen generator;		/* Generator handle          */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to item (return) */
/*
 * Inserts an element BEFORE the current spot.  The item generated
 * by lsNext will be unchanged;  the inserted item will be generated
 * by lsPrev.  This modifies the list.  'itemHandle' may be used at 
 * a later time to produce a generation handle without generating 
 * through the list.
 */
{
    lsGenInternal *realGen = (lsGenInternal *) generator;
    lsElem *newElem;

    if (realGen->beforeSpot == NIL(lsElem)) {
	/* Item added to the beginning of the list */
	(void) lsNewBegin((lsList) realGen->mainList, data, itemHandle);
	realGen->beforeSpot = realGen->mainList->topPtr;
	return LS_OK;
    } else if (realGen->afterSpot == NIL(lsElem)) {
	/* Item added to the end of the list */
	(void) lsNewEnd((lsList) realGen->mainList, data, itemHandle);
	realGen->afterSpot = realGen->mainList->botPtr;
	return LS_OK;
    } else {
	/* Item added in the middle of the list */
	newElem = alloc(lsElem);
	newElem->mainList = realGen->mainList;
	newElem->prevPtr = realGen->beforeSpot;
	newElem->nextPtr = realGen->afterSpot;
	newElem->userData = data;
	realGen->beforeSpot->nextPtr = newElem;
	realGen->afterSpot->prevPtr = newElem;
	realGen->beforeSpot = newElem;
	realGen->mainList->length += 1;
	if (itemHandle) *itemHandle = (lsHandle) newElem;
	return LS_OK;
    }
}

lsStatus lsInAfter(generator, data, itemHandle)
lsGen generator;		/* Generator handle          */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to item (return)   */
/*
 * Inserts an element AFTER the current spot.  The next item generated
 * by lsNext will be the new element.  The next  item generated by
 * lsPrev is unchanged.  This modifies the list.  'itemHandle' may
 * be used at a later time to generate a generation handle without
 * searching through the list to find the item.
 */
{
    lsGenInternal *realGen = (lsGenInternal *) generator;
    lsElem *newElem;

    if (realGen->beforeSpot == NIL(lsElem)) {
	/* Item added to the beginning of the list */
	(void) lsNewBegin((lsList) realGen->mainList, data, itemHandle);
	realGen->beforeSpot = realGen->mainList->topPtr;
	return LS_OK;
    } else if (realGen->afterSpot == NIL(lsElem)) {
	/* Item added to the end of the list */
	(void) lsNewEnd((lsList) realGen->mainList, data, itemHandle);
	realGen->afterSpot = realGen->mainList->botPtr;
	return LS_OK;
    } else {
	/* Item added in the middle of the list */
	newElem = alloc(lsElem);
	newElem->mainList = realGen->mainList;
	newElem->prevPtr = realGen->beforeSpot;
	newElem->nextPtr = realGen->afterSpot;
	newElem->userData = data;
	realGen->beforeSpot->nextPtr = newElem;
	realGen->afterSpot->prevPtr = newElem;
	realGen->afterSpot = newElem;
	realGen->mainList->length += 1;
	if (itemHandle) *itemHandle = (lsHandle) newElem;
	return LS_OK;
    }
}
	

lsStatus lsDelBefore(generator, data)
lsGen generator;		/* Generator handle        */
lsGeneric *data;			/* Deleted item (returned) */
/*
 * Removes the item before the current spot.  The next call to lsPrev
 * will return the item before the deleted item.  The next call to lsNext
 * will be uneffected.  This modifies the list.  The routine returns 
 * LS_BADSTATE if the user tries to call the routine and there is
 * no item before the current spot.  This routine returns the userData
 * of the deleted item so it may be freed (if necessary).
 */
{
    lsGenInternal *realGen = (lsGenInternal *) generator;
    lsElem *doomedItem;

    if (realGen->beforeSpot == NIL(lsElem)) {
	/* No item to delete */
	*data = (lsGeneric) 0;
	return LS_BADSTATE;
    } else if (realGen->beforeSpot == realGen->mainList->topPtr) {
	/* Delete the first item of the list */
	realGen->beforeSpot = realGen->beforeSpot->prevPtr;
	return lsDelBegin((lsList) realGen->mainList, data);
    } else if (realGen->beforeSpot == realGen->mainList->botPtr) {
	/* Delete the last item of the list */
	realGen->beforeSpot = realGen->beforeSpot->prevPtr;
	return lsDelEnd((lsList) realGen->mainList, data);
    } else {
	/* Normal mid list deletion */
	doomedItem = realGen->beforeSpot;
	doomedItem->prevPtr->nextPtr = doomedItem->nextPtr;
	doomedItem->nextPtr->prevPtr = doomedItem->prevPtr;
	realGen->beforeSpot = doomedItem->prevPtr;
	realGen->mainList->length -= 1;
	*data = doomedItem->userData;
	free((lsGeneric) doomedItem);
	return LS_OK;
    }
}


lsStatus lsDelAfter(generator, data)
lsGen generator;		/* Generator handle        */
lsGeneric *data;			/* Deleted item (returned) */
/*
 * Removes the item after the current spot.  The next call to lsNext
 * will return the item after the deleted item.  The next call to lsPrev
 * will be uneffected.  This modifies the list.  The routine returns 
 * LS_BADSTATE if the user tries to call the routine and there is
 * no item after the current spot.  This routine returns the userData
 * of the deleted item so it may be freed (if necessary).
 */
{
    lsGenInternal *realGen = (lsGenInternal *) generator;
    lsElem *doomedItem;

    if (realGen->afterSpot == NIL(lsElem)) {
	/* No item to delete */
	*data = (lsGeneric) 0;
	return LS_BADSTATE;
    } else if (realGen->afterSpot == realGen->mainList->topPtr) {
	/* Delete the first item of the list */
	realGen->afterSpot = realGen->afterSpot->nextPtr;
	return lsDelBegin((lsList) realGen->mainList, data);
    } else if (realGen->afterSpot == realGen->mainList->botPtr) {
	/* Delete the last item of the list */
	realGen->afterSpot = realGen->afterSpot->nextPtr;
	return lsDelEnd((lsList) realGen->mainList, data);
    } else {
	/* Normal mid list deletion */
	doomedItem = realGen->afterSpot;
	doomedItem->prevPtr->nextPtr = doomedItem->nextPtr;
	doomedItem->nextPtr->prevPtr = doomedItem->prevPtr;
	realGen->afterSpot = doomedItem->nextPtr;
	realGen->mainList->length -= 1;
	*data = doomedItem->userData;
	free((lsGeneric) doomedItem);
	return LS_OK;
    }
}



lsStatus lsFinish(generator)
lsGen generator;		/* Generator handle */
/*
 * Marks the completion of a generation of list items.  This routine should
 * be called after calls to lsNext to free resources used by the
 * generator.  This rule applies even if all items of a list are
 * generated by lsNext.
 */
{
    lsGenInternal *realGen = (lsGenInternal *) generator;

    free((lsGeneric) realGen);
    return(LS_OK);
}



/*
 * Functional list generation
 *
 * An alternate form of generating through items of a list is provided.
 * The routines below generatae through all items of a list in a given
 * direction and call a user provided function for each one.
 */

static lsStatus lsGenForm();

lsStatus lsForeach(list, userFunc, arg)
lsList list;			/* List to generate through */
lsStatus (*userFunc)();		/* User provided function   */
lsGeneric arg;			/* User provided data       */
/*
 * This routine generates all items in `list' from the first item
 * to the last calling `userFunc' for each item.  The function
 * should have the following form:
 *   lsStatus userFunc(data, arg)
 *   lsGeneric data;
 *   lsGeneric arg;
 * `data' will be the user data associated with the item generated.
 * `arg' will be the same pointer provided to lsForeach.  The
 * routine should return LS_OK to continue the generation,  LS_STOP
 * to stop generating items,  and LS_DELETE to delete the item
 * from the list.  If the generation was stopped prematurely,
 * the routine will return LS_STOP.  If the user provided function
 * does not return an appropriate value,  the routine will return
 * LS_BADPARAM.
 */
{
    return lsGenForm(userFunc, arg, lsStart(list), lsNext, lsDelBefore);
}


lsStatus lsBackeach(list, userFunc, arg)
lsList list;			/* List to generate through */
lsStatus (*userFunc)();		/* User provided function   */
lsGeneric arg;			/* User provided data       */
/*
 * This routine is just like lsForeach except it generates
 * all items in `list' from the last item to the first.
 */
{
    return lsGenForm(userFunc, arg, lsEnd(list), lsPrev, lsDelAfter);
}



static lsStatus lsGenForm(userFunc, arg, gen, gen_func, del_func)
lsStatus (*userFunc)();		/* User provided function         */
lsGeneric arg;			/* Data to pass to function       */
lsGen gen;			/* Generator to use               */
lsStatus (*gen_func)();		/* Generator function to use      */
lsStatus (*del_func)();		/* Deletion function to use       */
/*
 * This is the function used to implement the two functional
 * generation interfaces to lists.
 */
{
    lsGeneric data;

    while ((*gen_func)(gen, &data, LS_NH) == LS_OK) {
	switch ((*userFunc)(data, arg)) {
	case LS_OK:
	    /* Nothing */
	    break;
	case LS_STOP:
	    (void) lsFinish(gen);
	    return LS_STOP;
	case LS_DELETE:
	    (*del_func)(gen, &data);
	    break;
	default:
	    return LS_BADPARAM;
	}
    }
    (void) lsFinish(gen);
    return LS_OK;
}


lsList lsQueryHandle(itemHandle)
lsHandle itemHandle;		/* Handle of an item  */
/*
 * This routine returns the associated list of the specified
 * handle.  Returns 0 if there were problems.
 */
{
    lsElem *realHandle = (lsElem *) itemHandle;

    if (realHandle) {
	return (lsList) realHandle->mainList;
    } else {
	return (lsList) 0;
    }
}

lsGeneric lsFetchHandle(itemHandle)
lsHandle itemHandle;
/*
 * This routine returns the user data of the item associated with
 * `itemHandle'.
 */
{
    return ((lsElem *) itemHandle)->userData;
}

lsStatus lsRemoveItem(itemHandle, userData)
lsHandle itemHandle;		/* Handle of an item */
lsGeneric *userData;		/* Returned data     */
/*
 * This routine removes the item associated with `handle' from
 * its list and returns the user data associated with the item
 * for reclaimation purposes.  Note this modifies the list
 * that originally contained `item'.
 */
{
    lsElem *realItem = (lsElem *) itemHandle;
    lsGenInternal gen;

    gen.mainList = realItem->mainList;
    gen.beforeSpot = realItem->prevPtr;
    gen.afterSpot = realItem;
    return lsDelAfter((lsGen) &gen, userData);
}

/* sorting routines removed so that we can compile without octtools */
/* MAR 1/25/93 */
oreSpot = realGen->beforeSpot->prevPtr;
	return LS_OK;
    }

}

lsStatus lsInBefore(generator, data, itemHandle)
lsGen generator;		/* Gevl2mv/src/list/list.doc                                                                             100644  027004  000214  00000033722 05332024463 012306  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
 * Revision Control Information
 *
 * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/list.doc,v $
 * $Author: sis $
 * $Revision: 1.2 $
 * $Date: 1992/05/06 18:55:32 $
 *
 */

List Management Package

David Harrison
University of California, Berkeley, 1985

This package implements a simple generic linked list data type.  It
uses a doubly linked list structure and provides some standard operations
for storing and retrieving data from the list.

Programs using this package should include the file list.h found
in ~cad/include.  The linkage line for a user program called `myprog'
would look like:

      cc -g -o myprog myprog.o /cad/lib/liblist.a

Status Codes
------------

Most of the routines described below return lsStatus (an integer
return code).  The possible return codes are described below:

LS_OK		Routine completed successfully

LS_BADSTATE	Generator is in a bad state
LS_BADPARAM	Bad parameter value to function
LS_NOMORE	No more items to generate

Note that LS_OK is zero.  Thus,  routine return values should be
explicitly compared against LS_OK for success.

Item Handles
------------

Routines which return items of a list optionally return a `handle'.
This handle can be stored in user data structures and later used to
quickly access the item without generating through the list.  If you
do not wish to use handles,  you can pass the zero handle `(lsHandle *) 0'
to the routine.  For brevity,  the LS_NH macro may be used to specify
no handle to routines which return a handle.

List Creation, Deletion, and Copying
------------------------------------

lsList lsCreate()

	Creates a new linked list and returns its handle.  The handle
	is used by all other list manipulation routines and should not
	be discarded. 

lsStatus lsDestroy(list, delFunc)
lsList list;			/* List to destroy              */
void (*delFunc)();		/* Routine to release user data */

	Frees all resources associated with the specified list.  It
	frees memory associated with all elements of the list and then
	deletes the list. User data is released by calling `delFunc'
	with the pointer as the argument.  If no `delFunc' is provided
	(i.e. `delFunc' is zero),  the items in the list are not
	freed.  Accessing a list after its destruction is a no-no.

lsList lsCopy(list, copyFunc)
lsList list;			/* List to copy              */
lsGeneric (*copyFunc)();	/* Routine to copy user data */

       Returns a copy of list `list'.  If `copyFunc' is non-zero,
       it will be called for each item in `list' and the pointer it 
       returns will be used in place of the original user data for the 
       item in the newly created list.  The form of `copyFunc' should be:
	  lsGeneric copyFunc(data)
	  lsGeneric data;
       This is normally used to make copies of the user data in the 
       new list.  If no `copyFunc' is provided,  the routine will use
       an identity function.

Adding New Elements to the Beginning and End of a List
------------------------------------------------------

lsStatus lsNewBegin(list, data, itemHandle)
lsList list;			/* List to add element to    */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to data (returned) */

	Adds a new item to the start of a previously created linked
	list. If 'itemHandle' is non-zero,  it will be filled with a
	handle which can be used to generate a generator positioned
	at the item without generating through the list.

lsStatus lsNewEnd(list, data, itemHandle)
lsList list;			/* List to append element to */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to data (returned) */

	Adds a new item to the end of a previously created linked
	list.  This routine appends the item in constant time and
	can be used freely without guilt.

Retrieving the first and last items of a list
---------------------------------------------

lsStatus lsFirstItem(list, data, itemHandle)
lsList list;			/* List to get item from */
lsGeneric *data;		/* User data (returned)  */
lsHandle *itemHandle;		/* Handle to data (returned) */

	Returns the first item in the list.  If the list is empty,
	it returns LS_NOMORE.  Otherwise,  it returns LS_OK. 
	If 'itemHandle' is non-zero,  it will be filled with a
	handle which may be used to generate a generator.

lsStatus lsLastItem(list, data, itemHandle)
lsList list;			/* List to get item from */
lsGeneric *data;		/* User data (returned)  */
lsHandle *itemHandle;		/* Handle to data (returned) */

	Returns the last item of a list.  If the list is empty,
	the routine returns LS_NOMORE.  Otherwise,  'data' will
	be set to the last item and the routine will return LS_OK.
	If 'itemHandle' is non-zero,  it will be filled with a
	handle which can be used to generate a generator postioned
	at this item.  Accessing the last item of a list is a constant
	time operation.


Deleting first and last items of a list
---------------------------------------

lsStatus lsDelBegin(list, data)
lsList list;			/* List to delete item from     */
lsGeneric *data;		/* First item (returned)        */

	This routine deletes the first item of a list.  If `data' is
	non-zero,  it will be filled with a pointer to the user data
	for the item (which may then be disposed).  The routine
	returns LS_NOMORE if there are no items in the list to delete.

lsStatus lsDelEnd(list, data)
lsList list;			/* List to delete item from */
lsGeneric *data;		/* Last item (returned)     */

	This routine deletes the last item of a list.  If `data' is
	non-zero,  it will be filled with a pointer to the user data
	for the item (which may then be disposed).  The routine
	returns LS_NOMORE if there are no items in the list to delete.
	Deleting the last item of a list is a constant time operation.

Length of a List
----------------

int lsLength(list)
lsList list;			/* List to get the length of */

       Returns the length of the list.  The list must have been
       already created using lsCreate.  Obtaining the length of the
       list is a constant time operation.


List Generation Routines
------------------------

lsGen lsStart(list)
lsList list;			/* List to generate items from */

       This routine defines a generator which is used to step through
       each item of the list.  The generator is initialized to the
       beginning of the list.  It returns a generator handle which
       should be used when calling lsNext, lsPrev, lsInBefore,
       lsInAfter, lsDelBefore, lsDelAfter, or lsFinish.

lsGen lsEnd(list)
lsList list;			/* List to generate items from */

       This routine returns a generator which can be used to step
       through each item of `list'.  The generator is initialized to
       the end of the list.  This can be used to generate through
       items in reverse order.

lsGen lsGenHandle(itemHandle, data, option)
lsHandle itemHandle;		/* Handle of an item         */
lsGeneric *data;		/* Data associated with item */
int option;			/* LS_BEFORE or LS_AFTER     */

	This routine produces a generator given a handle.  Handles are
	produced whenever an item is added to a list.  The generator
	produced by this routine may be used when calling any of the
	standard generation routines.  NOTE:  the generator should be
	freed using lsFinish.  The 'option' parameter determines
	whether the generator spot is before or after the handle item.

lsStatus lsNext(generator, data, itemHandle)
lsGen generator;		/* Generator handle        */
lsGeneric *data;		/* User data (return)      */
lsHandle *itemHandle;		/* Handle to item (return) */

	Generates the item after the item previously generated by
	lsNext or lsPrev.   It returns a pointer to the user data
	structure in 'data'.  'itemHandle' may be used to get a
	generation handle without generating through the list to find
	the item.  If there are no more elements to generate, the
	routine returns  LS_NOMORE (normally it returns LS_OK).
	lsNext DOES NOT automatically clean up after all elements have
	been generated.  lsFinish must be called explicitly to do
	this.

lsStatus lsPrev(generator, data, itemHandle)
lsGen generator;		/* Generator handle        */
lsGeneric *data;		/* User data (return)      */
lsHandle *itemHandle;		/* Handle to item (return) */

	Generates the item before the item previously generated by
	lsNext or lsPrev.   It returns a pointer to the user data
	structure in 'data'.  'itemHandle' may be used to get a
	generation handle without generating through the list to find
	the item.  If there are no more elements to generate, the
	routine returns  LS_NOMORE (normally it returns LS_OK).
	lsPrev DOES NOT automatically clean up after all elements have
	been generated.  lsFinish must be called explicitly to do
	this. 

lsStatus lsInBefore(generator, data, itemHandle)
lsGen generator;		/* Generator handle          */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to item (return) */

	Inserts an element BEFORE the current spot.  The item
	generated by lsNext will be unchanged;  the inserted item will
	be generated by lsPrev.  This modifies the list.  'itemHandle'
	may be used at a later time to produce a generation handle
	without generating through the list.

lsStatus lsInAfter(generator, data, itemHandle)
lsGen generator;		/* Generator handle          */
lsGeneric data;			/* Arbitrary pointer to data */
lsHandle *itemHandle;		/* Handle to item (return)   */

	Inserts an element AFTER the current spot.  The next item
	generated by lsNext will be the new element.  The next  item
	generated by lsPrev is unchanged.  This modifies the list.
	'itemHandle' may be used at a later time to generate a
	generation handle without searching through the list to find
	the item. 

lsStatus lsDelBefore(generator, data)
lsGen generator;		/* Generator handle        */
lsGeneric *data;		/* Deleted item (returned) */

	Removes the item before the current spot.  The next call to
	lsPrev will return the item before the deleted item.  The next
	call to lsNext will be unaffected.  This modifies the list.
	The routine returns LS_BADSTATE if the user tries to call the
	routine and there is no item before the current spot.  This
	routine returns the userData of the deleted item so it may be
	freed (if necessary).

lsStatus lsDelAfter(generator, data)
lsGen generator;		/* Generator handle        */
lsGeneric *data;		/* Deleted item (returned) */

	Removes the item after the current spot.  The next call to
	lsNext will return the item after the deleted item.  The next
	call to lsPrev will be unaffected.  This modifies the list.
	The routine returns LS_BADSTATE if the user tries to call the
	routine and there is no item after the current spot.  This
	routine returns the userData of the deleted item so it may be
	freed (if necessary). 

lsStatus lsFinish(generator)
lsGen generator;		/* Generator handle */

	Marks the completion of a generation of list items.  This
	routine should be called after calls to lsNext to free
	resources used by the generator.  This rule applies even if
	all items of a list are generated by lsNext.



Functional List Generation
--------------------------

lsStatus lsForeach(list, userFunc, arg)
lsList list;			/* List to generate through */
lsStatus (*userFunc)();		/* User provided function   */
lsGeneric arg;			/* User provided data       */

	This routine generates all items in `list' from the first item
	to the last calling `userFunc' for each item.  The function
	should have the following form:
	  lsStatus userFunc(data, arg)
	    lsGeneric data;
	    lsGeneric arg;
	`data' will be the user data associated with the item generated.
	`arg' will be the same pointer provided to lsForeach.  The
	routine should return LS_OK to continue the generation,  LS_STOP
	to stop generating items,  and LS_DELETE to delete the item
	from the list.  If the generation was stopped prematurely,
	the routine will return LS_STOP.  If the user provided function
	does not return an appropriate value,  the routine will return
	LS_BADPARAM.

lsStatus lsBackeach(list, userFunc, arg)
lsList list;			/* List to generate through */
lsStatus (*userFunc)();		/* User provided function   */
lsGeneric arg;			/* User provided data       */

	This routine is just like lsForeach except it generates
	all items in `list' from the last item to the first.



Direct Handle Manipulation Routines
-----------------------------------

lsList lsQueryHandle(itemHandle)
lsHandle itemHandle;		/* Handle of an item  */

	This routine returns the associated list of the specified
	handle.  Returns 0 if there were problems.

lsGeneric lsFetchHandle(itemHandle)
lsHandle itemHandle;		/* Handle of an item  */

	Returns the data associated with `handle'.  Returns 0 if
	their were problems.

lsStatus lsRemoveItem(itemHandle, userData)
lsHandle itemHandle;		/* Handle of an item */
lsGeneric *userData;		/* Returned data     */

	This routine removes the item associated with `handle' from
	its list and returns the user data associated with the item
	for reclaimation purposes.  Note this modifies the list
	that originally contained `item'.


Sorting Operations
------------------

lsStatus lsSort(list, compare)
lsList list;			/* List to sort        */
int (*compare)();		/* Comparison function */

	This routine sorts `list' using `compare' as the comparison
	function between items in the list.  `compare' has the following form:
	  int compare(item1, item2)
	  lsGeneric item1, item2;
	The routine should return -1 if item1 is less than item2, 0 if
	they are equal,  and 1 if item1 is greater than item2. The routine 
	uses a generic merge sort written by Rick Rudell which runs in
	O(n log n) time.

lsStatus lsUniq(list, compare, delFunc)
lsList list;			/* List to remove duplicates from */
int (*compare)();		/* Item comparison function       */
void (*delFunc)();		/* Function to release user data  */

	This routine takes a sorted list and removes all duplicates
	from it.  `compare' has the following form:
	  int compare(item1, item2)
	  lsGeneric item1, item2;
	The routine should return -1 if item1 is less than item2, 0 if
	they are equal,  and 1 if item1 is greater than item2. `delFunc'
	will be called with a pointer to a user data item for each
	duplicate destroyed.  `delFunc' can be zero if no clean up
	is required.

ndle to data (returned) */

	Returns the firstvl2mv/src/util/                                                                                     040755  027004  000214  00000000000 05402724327 010035  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/src/util/Makefile                                                                             100644  027004  000214  00000001437 05332026270 012302  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 # util -- miscellaneous utility routines
#---------------------------------------------------------------------------

LIB_DIR = ../../lib

P	= util
PSRC	= cpu_time.c cpu_stats.c getopt.c safe_mem.c strsav.c texpand.c \
	  prtime.c pipefork.c saveimage.c pathsearch.c stub.c \
	  restart.c state.c tmpfile.c
POBJ	= cpu_time.o cpu_stats.o getopt.o safe_mem.o strsav.o texpand.o \
	  prtime.o pipefork.o saveimage.o pathsearch.o stub.o \
	  restart.o state.o tmpfile.o
MISC	= util.doc Makefile test-restart.c

INCLUDE	= -I../../include 

CFLAGS	= -O $(INCLUDE)
LDFLAGS	=

CC = cc

.c.o:
	$(CC) -c $(CFLAGS) $*.c
#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a
ave been
       already created using lsCreate.  Obtaining the length of the
       list is a constant time operation.


List Generation Routines
------------------------

lsGen lsStart(list)
lsList list;			/* List to generavl2mv/src/util/cpu_stats.c                                                                          100644  027004  000214  00000006060 05332024467 013016  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"


#if defined(BSD) && !defined(_IBMR2)
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>

extern int end, etext, edata;

#endif

void
util_print_cpu_stats(fp)
FILE *fp;
{
#if defined(BSD) && !defined(_IBMR2)
    struct rusage rusage;
    struct rlimit rlp;
    int text, data, vm_limit, vm_soft_limit;
    double user, system, scale;
    char hostname[257];
    caddr_t sbrk();
    int vm_text, vm_init_data, vm_uninit_data, vm_sbrk_data;

    /* Get the hostname */
    (void) gethostname(hostname, 256);
    hostname[256] = '\0';		/* just in case */

    /* Get the virtual memory sizes */
    vm_text = ((int) (&etext)) / 1024.0 + 0.5;
    vm_init_data = ((int) (&edata) - (int) (&etext)) / 1024.0 + 0.5;
    vm_uninit_data = ((int) (&end) - (int) (&edata)) / 1024.0 + 0.5;
    vm_sbrk_data = ((int) sbrk(0) - (int) (&end)) / 1024.0 + 0.5;

    /* Get virtual memory limits */
    (void) getrlimit(RLIMIT_DATA, &rlp);
    vm_limit = rlp.rlim_max / 1024.0 + 0.5;
    vm_soft_limit = rlp.rlim_cur / 1024.0 + 0.5;

    /* Get usage stats */
    (void) getrusage(RUSAGE_SELF, &rusage);
    user = rusage.ru_utime.tv_sec + rusage.ru_utime.tv_usec/1.0e6;
    system = rusage.ru_stime.tv_sec + rusage.ru_stime.tv_usec/1.0e6;
    scale = (user + system)*100.0;
    if (scale == 0.0) scale = 0.001;

    (void) fprintf(fp, "Runtime Statistics\n");
    (void) fprintf(fp, "------------------\n");
    (void) fprintf(fp, "Machine name: %s\n", hostname);
    (void) fprintf(fp, "User time   %6.1f seconds\n", user);
    (void) fprintf(fp, "System time %6.1f seconds\n\n", system);

    text = rusage.ru_ixrss / scale + 0.5;
    data = (rusage.ru_idrss + rusage.ru_isrss) / scale + 0.5;
    (void) fprintf(fp, "Average resident text size       = %5dK\n", text);
    (void) fprintf(fp, "Average resident data+stack size = %5dK\n", data);
    (void) fprintf(fp, "Maximum resident size            = %5dK\n\n", 
	rusage.ru_maxrss/2);
    (void) fprintf(fp, "Virtual text size                = %5dK\n", 
	vm_text);
    (void) fprintf(fp, "Virtual data size                = %5dK\n", 
	vm_init_data + vm_uninit_data + vm_sbrk_data);
    (void) fprintf(fp, "    data size initialized        = %5dK\n", 
	vm_init_data);
    (void) fprintf(fp, "    data size uninitialized      = %5dK\n", 
	vm_uninit_data);
    (void) fprintf(fp, "    data size sbrk               = %5dK\n", 
	vm_sbrk_data);
    (void) fprintf(fp, "Virtual memory limit             = %5dK (%dK)\n\n", 
	vm_soft_limit, vm_limit);

    (void) fprintf(fp, "Major page faults = %d\n", rusage.ru_majflt);
    (void) fprintf(fp, "Minor page faults = %d\n", rusage.ru_minflt);
    (void) fprintf(fp, "Swaps = %d\n", rusage.ru_nswap);
    (void) fprintf(fp, "Input blocks = %d\n", rusage.ru_inblock);
    (void) fprintf(fp, "Output blocks = %d\n", rusage.ru_oublock);
    (void) fprintf(fp, "Context switch (voluntary) = %d\n", rusage.ru_nvcsw);
    (void) fprintf(fp, "Context switch (involuntary) = %d\n", rusage.ru_nivcsw);
#else
    (void) fprintf(fp, "Usage statistics not available\n");
#endif
}
* Generator handle        */
lsGeneric *data;		/* Deleted item (returned) */

	Removes the item before the current spot.  The next call to
	lsPrev will return the item before the deleted item.  The next
	call to lsNext will be unaffected.  This modifies the list.
	The routine returns LS_BADSTATE if the user tries to call the
	routine and there is no item before the current spot.  This
	routine returns the userData of the deleted item so it may be
	freed (if nevl2mv/src/util/cpu_time.c                                                                           100644  027004  000214  00000003276 05332024467 012624  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"

#ifdef IBM_WATC		/* IBM Waterloo-C compiler (same as bsd 4.2) */
#define void int
#define BSD
#endif

#ifdef hpux		/* HPUX/C compiler -- times() with 50 HZ clock */
#define UNIX50
#endif

#ifdef vms		/* VAX/C compiler -- times() with 100 HZ clock */
#define UNIX100
#endif

#ifdef BSD
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#endif

#ifdef UNIX50
#include <sys/types.h>
#include <sys/times.h>
#endif

#ifdef UNIX60
#include <sys/types.h>
#include <sys/times.h>
#endif

#ifdef UNIX100
#include <sys/types.h>
#include <sys/times.h>
#endif



/*
 *   util_cpu_time -- return a long which represents the elapsed processor
 *   time in milliseconds since some constant reference
 */
long 
util_cpu_time()
{
    long t = 0;

#ifdef BSD
    struct rusage rusage;
    (void) getrusage(RUSAGE_SELF, &rusage);
    t = (long) rusage.ru_utime.tv_sec*1000 + rusage.ru_utime.tv_usec/1000;
#endif

#ifdef IBMPC
    long ltime;
    (void) time(&ltime);
    t = ltime * 1000;
#endif

#ifdef UNIX50			/* times() with 50 Hz resolution */
    struct tms buffer;
    times(&buffer);
    t = buffer.tms_utime * 20;
#endif

#ifdef UNIX60			/* times() with 60 Hz resolution */
    struct tms buffer;
    times(&buffer);
    t = buffer.tms_utime * 16.6667;
#endif

#ifdef UNIX100
    struct tms buffer;		/* times() with 100 Hz resolution */
    times(&buffer);
    t = buffer.tms_utime * 10;
#endif

#ifdef vms			/* VAX/C compiler - times() with 100 HZ clock */
    struct {int p1, p2, p3, p4;} buffer;
    static long ref_time;
    times(&buffer);
    t = buffer.p1 * 10;
    if (ref_time == 0)
      ref_time = t;
    t = t - ref_time;
#endif


    return t;
}
routine returns the associated list of the specified
	handle.  Returns 0 if there were problems.

lsGeneric lsFetchHandle(itemHandle)
lsHandle itemHandle;		/* Handle of an item  */

	Returns the data associated with `handle'.  Returns 0 if
	their were problems.

lsStatus lsRemoveItem(itemHandle, userData)
lsHandle itemHavl2mv/src/util/getopt.c                                                                             100644  027004  000214  00000002752 05332024470 012311  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"


/*  File   : getopt.c
 *  Author : Henry Spencer, University of Toronto
 *  Updated: 28 April 1984
 *
 *  Changes: (R Rudell)
 *	changed index() to strchr();
 *	added getopt_reset() to reset the getopt argument parsing
 *
 *  Purpose: get option letter from argv.
 */

char *util_optarg;	/* Global argument pointer. */
int util_optind = 0;	/* Global argv index. */
static char *scan;


void
util_getopt_reset()
{
    util_optarg = 0;
    util_optind = 0;
    scan = 0;
}



int 
util_getopt(argc, argv, optstring)
int argc;
char *argv[];
char *optstring;
{
    register int c;
    register char *place;
    extern char *strchr();

    util_optarg = NIL(char);

    if (scan == NIL(char) || *scan == '\0') {
	if (util_optind == 0) util_optind++;
	if (util_optind >= argc) return EOF;
	place = argv[util_optind];
	if (place[0] != '-' || place[1] == '\0') return EOF;
	util_optind++;
	if (place[1] == '-' && place[2] == '\0') return EOF;
	scan = place+1;
    }

    c = *scan++;
    place = strchr(optstring, c);
    if (place == NIL(char) || c == ':') {
	(void) fprintf(stderr, "%s: unknown option %c\n", argv[0], c);
	return '?';
    }
    if (*++place == ':') {
	if (*scan != '\0') {
	    util_optarg = scan;
	    scan = NIL(char);
	} else {
	    if (util_optind >= argc) {
		(void) fprintf(stderr, "%s: %c requires an argument\n", 
		    argv[0], c);
		return '?';
	    }
	    util_optarg = argv[util_optind];
	    util_optind++;
	}
    }
    return c;
}
                      vl2mv/src/util/saveimage.c                                                                          100644  027004  000214  00000012105 05332024470 012741  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */
/*
 * saveimage.c --
 *
 * Function to save an executable copy of the current process's
 * image in a file.
 *
 */

#include <stdio.h>
#include "util.h"

#ifdef notdef /* BSD */
#include <sys/types.h>
#include <sys/stat.h>
#include <a.out.h>
#include <errno.h>

extern int errno;

#define	BUFSIZE		8192

extern long lseek();	/* For lint */
extern int getpagesize();
extern char *sbrk();

static int copy_file();
static int pad_file();


int
util_save_image(orig_file_name, save_file_name)
char *orig_file_name;
char *save_file_name;
{
    int origFd = -1, saveFd = -1;
    char *start_data, *end_data, *start_text, *end_round;
    struct exec old_hdr, new_hdr;
    struct stat old_stat;
    int n, page_size, length_text, length_data;

    if ((origFd = open(orig_file_name, 0)) < 0) {
	perror(orig_file_name);
	(void) fprintf(stderr, "Cannot open original a.out file\n");
	goto bad;
    }

    if (fstat(origFd, &old_stat) < 0) {
	perror(orig_file_name);
	(void) fprintf(stderr, "Cannot stat original a.out file\n");
	goto bad;
    }

    /*
     * Read the a.out header from the original file.
     */
    if (read(origFd, (char *) &old_hdr, sizeof(old_hdr)) != sizeof(old_hdr)) {
	perror(orig_file_name);
	(void) fprintf(stderr, "Cannot read original a.out header\n");
	goto bad;
    }
    if (N_BADMAG(old_hdr)) {
	(void) fprintf(stderr, "File %s has a bad magic number (%o)\n",
			orig_file_name, old_hdr.a_magic);
	goto bad;
    }
    if (old_hdr.a_magic != ZMAGIC) {
	(void) fprintf(stderr, "File %s is not demand-paged\n", orig_file_name);
	goto bad;
    }

    /*
     * Open the output file.
     */
    if (access(save_file_name, /* F_OK */ 0) == 0) {
	(void) unlink(save_file_name);
    }
    if ((saveFd = creat(save_file_name, 0777)) < 0) {
	if (errno == ETXTBSY) {
	    (void) unlink(save_file_name);
	    saveFd = creat(save_file_name, 0777);
	}
	if (saveFd < 0) {
	    perror(save_file_name);
	    (void) fprintf(stderr, "Cannot create save file.\n");
	    goto bad;
	}
    }

    /*
     * Find out how far the data segment extends.
     */
    new_hdr = old_hdr;
    end_data = sbrk(0);
    page_size = getpagesize();
    n = ((((int) end_data) + page_size - 1) / page_size) * page_size;
    end_round = (char *) n;
    if (end_round > end_data) {
	end_data = sbrk(end_round - end_data);
    }

#ifdef vax
    start_text = 0;
    length_text = new_hdr.a_text;
    start_data = (char *) old_hdr.a_text;
    length_data = end_data - start_data;
#endif vax
#ifdef	sun
    start_text = (char *) N_TXTADDR(old_hdr) + sizeof(old_hdr);
    length_text = old_hdr.a_text - sizeof(old_hdr);
    start_data = (char *) N_DATADDR(old_hdr);
    length_data = end_data - start_data;
#endif	sun
    new_hdr.a_data = end_data - start_data;
    new_hdr.a_bss = 0;

    /*
     * First, the header plus enough pad to extend up to N_TXTOFF.
     */
    if (write(saveFd, (char *) &new_hdr, (int) sizeof(new_hdr)) !=
				sizeof(new_hdr)) {
	perror("write");
	(void) fprintf(stderr, "Error while copying header.\n");
	goto bad;
    }
    if (! pad_file(saveFd, N_TXTOFF(old_hdr) - sizeof(new_hdr))) {
	(void) fprintf(stderr, "Error while padding.\n");
	goto bad;
    }


    /*
     *  Copy our text segment
     */
    if (write(saveFd, start_text, length_text) != length_text) {
	perror("write");
	(void) fprintf(stderr, "Error while copying text segment.\n");
	goto bad;
    }


    /*
     *  Copy our data segment
     */
    if (write(saveFd, start_data, length_data) != length_data) {
	perror("write");
	(void) fprintf(stderr, "Error while copying data segment.\n");
	goto bad;
    }

    /*
     * Copy the symbol table and everything else.
     * This takes us to the end of the original file.
     */
    (void) lseek(origFd, (long) N_SYMOFF(old_hdr), 0);
    if (! copy_file(origFd, saveFd, old_stat.st_size - N_SYMOFF(old_hdr))) {
	(void) fprintf(stderr, "Error while copying symbol table.\n");
	goto bad;
    }
    (void) close(origFd);
    (void) close(saveFd);
    return 1;

bad:
    if (origFd >= 0) (void) close(origFd);
    if (saveFd >= 0) (void) close(saveFd);
    return 0;
}


static int
copy_file(inFd, outFd, nbytes)
int inFd, outFd;
unsigned long nbytes;
{
    char buf[BUFSIZE];
    int nread, ntoread;

    while (nbytes > 0) {
	ntoread = nbytes;
	if (ntoread > sizeof buf) ntoread = sizeof buf;
	if ((nread = read(inFd, buf, ntoread)) != ntoread) {
	    perror("read");
	    return (0);
	}
	if (write(outFd, buf, nread) != nread) {
	    perror("write");
	    return (0);
	}
	nbytes -= nread;
    }

    return (1);
}


static int
pad_file(outFd, nbytes)
int outFd;
int nbytes;
{
    char buf[BUFSIZE];
    int nzero;

    nzero = (nbytes > sizeof(buf)) ? sizeof(buf) : nbytes;
    bzero(buf, nzero);
    while (nbytes > 0) {
	nzero = (nbytes > sizeof(buf)) ? sizeof(buf) : nbytes;
	if (write(outFd, buf, nzero) != nzero) {
	    perror("write");
	    return (0);
	}
	nbytes -= nzero;
    }

    return (1);
}
#else

/* ARGSUSED */
int
util_save_image(orig_file_name, save_file_name)
char *orig_file_name;
char *save_file_name;
{
    (void) fprintf(stderr, 
	"util_save_image: not implemented on your operating system\n");
    return 0;
}

#endif
                               100644  027004  000214  00000003276 05332024467 012624  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 vl2mv/src/util/strsav.c                                                                             100644  027004  000214  00000000277 05332024471 012332  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"


/*
 *  util_strsav -- save a copy of a string
 */
char *
util_strsav(s)
char *s;
{
    return strcpy(ALLOC(char, strlen(s)+1), s);
}
or
 *   time in milliseconds since some constant reference
 */
long 
util_cpu_time()
{
    long t = 0;

#ifdef BSD
    struct rusage rusage;
    (void) getrusage(RUSAGE_SELF, &rusage);
    t = (long) rusage.ru_utime.tv_sec*1000 + rusage.ru_utime.tv_usec/1000;
#endif

#ifdef IBMPC
    long ltime;
    (void) time(&ltime);vl2mv/src/util/util.doc                                                                             100644  027004  000214  00000013565 05332024471 012314  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 Summary:
	ALLOC()
	REALLOC()
	FREE()
	NIL()
	int util_pipefork()
	char *util_tilde_expand()
	char *util_file_search()
	char *util_path_search()
	long util_cpu_time()
	char *util_print_time()
	int util_save_image()
	void util_print_cpu_stats()
	char *util_strsav()
	int util_getopt()
	int util_getopt_reset()


type *
ALLOC(type, number)
typeof type;
int number;
	Allocates 'number' objects of type 'type'.  This macro should be
	used rather than calling malloc() directly because it casts the
	arguments appropriately, and ALLOC() will never return NIL(char),
	choosing instead to terminate the program.


void
FREE(obj)
	Free object 'obj'.  This macro should be used rather than
	calling free() directly because it casts the argument
	appropriately.  It also guarantees that FREE(0) will work
	properly.


type *
REALLOC(type, obj, number)
	Re-allocate 'obj' to hold 'number' objects of type 'type'.
	This macro should be used rather than calling realloc()
	directly because it casts the arguments appropriately, and
	REALLOC() will never return NIL(char), instead choosing to
	terminate the program.  It also guarantees that REALLOC(type, 0, n)
	is the same as ALLOC(type, n).


type *
NIL(type)
	Returns 0 properly casted into a pointer to an object of type
	'type'.  Strictly speaking, this macro is only required when
	a 0 pointer is passed as an argument to a function.  Still,
	some prefer the style of always casting their 0 pointers using
	this macro.


int
util_pipefork(argv, toCommand, fromCommand)
char **argv;
FILE **toCommand;
FILE **fromCommand;
	Fork (using execvp(3)) the program argv[0] with argv[1] ...
	argv[n] as arguments.  (argv[n+1] is set to NIL(char) to
	indicate the end of the list).  Set up two-way pipes between
	the child process and the parent, returning file pointer
	'toCommand' which can be used to write information to the
	child, and the file pointer 'fromCommand' which can be used to
	read information from the child.  As always with unix pipes,
	watch out for dead-locks.  Returns 1 for success, 0 if any
	failure occured forking the child.


char *
util_tilde_expand(filename)
char *filename;
	Returns a new string corresponding to 'tilde-expansion' of the
	given filename (see csh(1), "filename substitution").  This
	means recognizing ~user and ~/ constructs, and inserting the
	appropriate user's home directory.  The returned string should
	be free'd by the caller.


char *
util_file_search(file, path, mode)
char *file;
char *path;
char *mode;
	'path' is string of the form "dir1:dir2: ...".  Each of the
	directories is searched (in order) for a file matching 'file'
	in that directory.  'mode' checks that the file can be accessed
	with read permission ("r"), write permission ("w"), or execute
	permission ("x").  The expanded filename is returned, or
	NIL(char) is returned if no file could be found.  The returned
	string should be freed by the caller.  Tilde expansion is
	performed on both 'file' and any directory in 'path'.


char *
util_path_search(program)
char *program;
	Simulate the execvp(3) semantics of searching the user's environment
	variable PATH for an executable 'program'.  Returns the file name
	of the first executable matching 'program' in getenv("PATH"), or
	returns NIL(char) if none was found.  This routines uses 
	util_file_search().


long
util_cpu_time()
	Returns the processor time used since some constant reference
	in milliseconds.


char *
util_print_time(time)
long time;
	Converts a time into a (static) printable string.  Intended to
	allow different hosts to provide differing degrees of
	significant digits in the result (e.g., IBM 3090 is printed to
	the millisecond, and the IBM PC usually is printed to the
	second).  Returns a string of the form "10.5 sec".


int
util_save_image(old_file, new_file)
char *old_file;
char *new_file;
	Save the text and data segments of the current executable
	(which is the file 'old_file') into the file 'new_file'.
	Returns 1 for success, 0 for failure.  'old_file' is required
	in order to preserve symbol table information for the new
	executable.  'old_file' can be derived from argv[0] of the
	current executable using util_path_search().  NOTE: no stack
	information is preserved.  When the program restarts, it
	re-enters main() with no valid stack.  This is currently highly
	BSD-specific, but should run on most operating systems which are 
	derived from Berkeley Unix 4.2.


void
util_restart(old_file, new_file, interval)
char *old_file;
char *new_file;
int interval;
	Set a checkpoint interval for the current program.  Every
	'interval' seconds, the current program will be saved to the
	file 'new_file'.  Also enables the signal SIGQUIT (usually ^\)
	to force the program to checkpoint and terminate.  'old_file'
	is the filename of the current executable; this allows for the
	saving of the symbol table when the program is checkpointed.
	'old_file' can be derived from argv[0] of the current
	executable using util_path_search().  This saves all stack and
	state information, guaranteeing complete restart when the new
	executable is run.  util_restart() must be called as the first
	statement in main (except, of course, for util_path_search()).
	This is much more operating system and hardware dependent than
	util_save_image(); currently it is implemented only for DEC VAX
	under Ultrix and 4.3bsd, and Sun 3 under Sun OS.


void
util_print_cpu_stats(fp)
FILE *fp;
	Dump to the given file a summary of processor usage statistics.
	For BSD machines, this includes a formatted dump of the
	getrusage(2) structure.


char *
util_strsav(s)
char *s;
	Also known as strsav() for backwards compatability.
	Returns a copy of the string 's'.  


int
util_getopt(argc, argv, string)
int argc;
char **argv;
char *string;
	Also known as getopt(3) for backwards compatability.
	Parses options from an argc/argv command line pair.


int
util_getopt_reset()
	Reset getopt argument parsing to start parsing a new argc/argv pair.
	Not available from the standard getopt(3).
				sizeof(new_hdr)) {
	perror("write");
	(void) fprintf(stderr, "Error while copying header.\n");
	goto bad;
    }
    if (! pad_file(savevl2mv/src/util/pathsearch.c                                                                         100644  027004  000214  00000003447 05332024472 013135  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"

static int check_file();

char *
util_path_search(prog)
char *prog;
{
#ifdef UNIX
    return util_file_search(prog, getenv("PATH"), "x");
#else
    return util_file_search(prog, NIL(char), "x");
#endif
}


char *
util_file_search(file, path, mode)
char *file;			/* file we're looking for */
char *path;			/* search path, colon separated */
char *mode;			/* "r", "w", or "x" */
{
    int quit;
    char *buffer, *filename, *save_path, *cp;

    if (path == 0 || strcmp(path, "") == 0) {
	path = ".";		/* just look in the current directory */
    }

    save_path = path = strsav(path);
    quit = 0;
    do {
	cp = strchr(path, ':');
	if (cp != 0) {
	    *cp = '\0';
	} else {
	    quit = 1;
	}

	/* cons up the filename out of the path and file name */
	if (strcmp(path, ".") == 0) {
	    buffer = strsav(file);
	} else {
	    buffer = ALLOC(char, strlen(path) + strlen(file) + 4);
	    (void) sprintf(buffer, "%s/%s", path, file);
	}
	filename = util_tilde_expand(buffer);
	FREE(buffer);

	/* see if we can access it */
	if (check_file(filename, mode)) {
	    FREE(save_path);
	    return filename;
	}
	FREE(filename);
	path = ++cp;
    } while (! quit); 

    FREE(save_path);
    return 0;
}


static int
check_file(filename, mode)
char *filename;
char *mode;
{
#ifdef UNIX
    int access_mode;

    if (strcmp(mode, "r") == 0) {
	access_mode = /*R_OK*/ 4;
    } else if (strcmp(mode, "w") == 0) {
	access_mode = /*W_OK*/ 2;
    } else if (strcmp(mode, "x") == 0) {
	access_mode = /*X_OK*/ 1;
    }
    return access(filename, access_mode) == 0;
#else
    FILE *fp;
    int got_file;

    if (strcmp(mode, "x") == 0) {
	mode = "r";
    }
    fp = fopen(filename, mode);
    got_file = (fp != 0);
    if (fp != 0) {
	(void) fclose(fp);
    }
    return got_file;
#endif
}
                                                    1  0                                                                                                                                                                 vl2mv/src/util/pipefork.c                                                                           100644  027004  000214  00000003226 05332024474 012627  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include "util.h"
#include <stdio.h>


/*
 * util_pipefork - fork a command and set up pipes to and from
 *
 * Rick L Spickelmier, 3/23/86
 * Richard Rudell, 4/6/86
 *
 * Returns:
 *   1 for success, with toCommand and fromCommand pointing to the streams
 *   0 for failure
 */

/* ARGSUSED */
int
util_pipefork(argv, toCommand, fromCommand)
char **argv;				/* normal argv argument list */
FILE **toCommand;			/* pointer to the sending stream */
FILE **fromCommand;			/* pointer to the reading stream */
{
#ifdef UNIX
    int status = 0;
    int topipe[2], frompipe[2];
    char buffer[1024];
#ifdef _IBMR2
    FILE *fdopen();
#endif

    /* create the PIPES...
     * fildes[0] for reading from command
     * fildes[1] for writing to command
     */
    (void) pipe(topipe);
    (void) pipe(frompipe);

    if (vfork() == 0) {
	/* child here, connect the pipes */
	(void) dup2(topipe[0], fileno(stdin));
	(void) dup2(frompipe[1], fileno(stdout));

	(void) close(topipe[0]);
	(void) close(topipe[1]);
	(void) close(frompipe[0]);
	(void) close(frompipe[1]);

	(void) execvp(argv[0], argv);
	(void) sprintf(buffer, "pipefork: can not exec %s", argv[0]);
	perror(buffer);
	status = 1;
	(void) _exit(1);
    }

    /* parent here, use slimey vfork() semantics to get return status */
    if (status == 1) {
	return 0;
    }
    if ((*toCommand = fdopen(topipe[1], "w")) == NULL) {
	return 0;
    }
    if ((*fromCommand = fdopen(frompipe[0], "r")) == NULL) {
	return 0;
    }
    (void) close(topipe[0]);
    (void) close(frompipe[1]);
    return 1;
#else
    (void) fprintf(stderr, 
	"util_pipefork: not implemented on your operating system\n");
    return 0;
#endif
}
 used rather than
	calling free() directly because it casts the argument
	appropriately.  It also guarantees that FREE(0) will work
	properly.


type *
REALLOC(type, obj, number)
	Re-allocate 'obj' to hold 'number' objects of type 'type'.
	This macro should be used rather than calling realloc()
	directly because it casts the arguments appropriately, and
	REALLvl2mv/src/util/prtime.c                                                                             100644  027004  000214  00000000600 05332024475 012302  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"


/*
 *  util_print_time -- massage a long which represents a time interval in
 *  milliseconds, into a string suitable for output 
 *
 *  Hack for IBM/PC -- avoids using floating point
 */

char *
util_print_time(t)
long t;
{
    static char s[40];

    (void) sprintf(s, "%ld.%02ld sec", t/1000, (t%1000)/10);
    return s;
}
 to
	read information from the child.  As always with unix pipes,
	watch out for dead-locks.  Returns 1 for success, 0 if any
	fvl2mv/src/util/restart.c                                                                            100644  027004  000214  00000005500 05332024475 012472  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifdef notdef
#include <stdio.h>
#include "util.h"

#if (defined(sun) && ! defined(sparc)) || defined(vax)

#include <signal.h>
#include <sys/types.h>
#include <sys/time.h>

static char *save_stack_base;
static char *stack_lo_addr;
static char *stack_hi_addr;
static int stack_size;

static int restart_global_flag;
static char *old_file_name;
static char *new_file_name;

char *util_save_sp;		/* set by util_restart_save_state() */
extern char *sbrk();

static void
grow_stack() 
{
    int i, space[256];

    for(i = 0; i < 256; i++) {
	space[i] = 0;
    }
    if ((char *) &i > stack_lo_addr) {
	grow_stack();
    }
}


/* ARGSUSED */
static int
handle_sigquit(sig, code, scp)
int sig;
int code;
struct sigcontext *scp;
{
    if (util_restart_save_state()) {
	/* we are restarting ! -- return from signal */

    } else {
	/* copy stack to user data space */
	stack_lo_addr = util_save_sp;
	stack_size = stack_hi_addr - stack_lo_addr + 1;
	save_stack_base = sbrk(stack_size);
	(void) memcpy(save_stack_base, stack_lo_addr, stack_size);

	/* write a new executable */
	(void) fprintf(stderr, "Writing executable %s ...\n", new_file_name);
	(void) util_save_image(old_file_name, new_file_name);

	/* terminate if signal was a QUIT */
	if (sig == SIGQUIT) {
	    (void) _exit(1);
	}
    }
}


static void
restart_program()
{
    (void) fprintf(stderr, "Continuing execution ...\n");

    /* create the stack */
    grow_stack();

#ifdef vax
    asm("movl _util_save_sp,sp");
#endif
#ifdef sun
    asm("movl _util_save_sp,sp");
#endif

    /* copy the stack back from user space */
    (void) memcpy(stack_lo_addr, save_stack_base, stack_size);

    /* remove the sbrk for the stack */
    if (sbrk(-stack_size) < 0) {
	perror("sbrk");
    }

    util_restart_restore_state();	/* jump back into handle_sigquit() */
}

void
util_restart(old, new, interval)
char *old, *new;
int interval;
{
    struct itimerval itimer;

#ifdef vax
#ifdef ultrix
    stack_hi_addr = (char *) 0x7fffe3ff;	/* ultrix */
#else
    stack_hi_addr = (char *) 0x7fffebff;	/* bsd 4.3 */
#endif
#endif
#ifdef sun
    stack_hi_addr = (char *) 0x0effffff;	/* Sun OS 3.2, 3.4 */ 
#endif

    old_file_name = old;
    new_file_name = new;

    (void) signal(SIGQUIT, handle_sigquit);

    if (interval > 0) {
	(void) signal(SIGVTALRM, handle_sigquit);
	itimer.it_interval.tv_sec = interval;
	itimer.it_interval.tv_usec = 0;
	itimer.it_value.tv_sec = interval;
	itimer.it_value.tv_usec = 0;
	if (setitimer(ITIMER_VIRTUAL, &itimer, (struct itimerval *) 0) < 0) {
	    perror("setitimer");
	    exit(1);
	}
    }

    if (restart_global_flag) {
	restart_program();
    }
    restart_global_flag = 1;
}

#else

/* ARGSUSED */
void
util_restart(old, new, interval)
char *old;
char *new;
int interval;
{
    (void) fprintf(stderr, 
	"util_restart: not supported on your operating system/hardware\n");
}

#endif
#endif
ummary of processor usage statistics.
	For BSD machines, this includes a formatted dump of the
	getrusage(2) structure.


char *
util_strsav(s)
char *s;
	Also known as strsav() for backwards cvl2mv/src/util/safe_mem.c                                                                           100644  027004  000214  00000004030 05332024476 012560  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"


/*
 *  These are interface routines to be placed between a program and the
 *  system memory allocator.  
 *
 *  It forces well-defined semantics for several 'borderline' cases:
 *
 *	malloc() of a 0 size object is guaranteed to return something
 *	    which is not 0, and can safely be freed (but not dereferenced)
 *	free() accepts (silently) an 0 pointer
 *	realloc of a 0 pointer is allowed, and is equiv. to malloc()
 *	For the IBM/PC it forces no object > 64K; note that the size argument
 *	    to malloc/realloc is a 'long' to catch this condition
 *
 *  The function pointer MMoutOfMemory() contains a vector to handle a
 *  'out-of-memory' error (which, by default, points at a simple wrap-up 
 *  and exit routine).
 */

extern char *MMalloc();
extern void MMout_of_memory();
extern char *MMrealloc();


void (*MMoutOfMemory)() = MMout_of_memory;


/* MMout_of_memory -- out of memory for lazy people, flush and exit */
void 
MMout_of_memory(size)
long size;
{
    (void) fflush(stdout);
    (void) fprintf(stderr, "\nout of memory allocating %ld bytes\n", size);
    exit(1);
}


char *
MMalloc(size)
long size;
{
    char *p;

#ifdef IBMPC
    if (size > 65000L) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
#endif
    if (size <= 0) size = sizeof(long);
    if ((p = (char *) malloc((unsigned) size)) == NIL(char)) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
    return p;
}


char *
MMrealloc(obj, size)
char *obj;
long size;
{
    char *p;

#ifdef IBMPC
    if (size > 65000L) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
#endif
    if (obj == NIL(char)) return MMalloc(size);
    if (size <= 0) size = sizeof(long);
    if ((p = (char *) realloc(obj, (unsigned) size)) == NIL(char)) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
    return p;
}


void
MMfree(obj)
char *obj;
{
    if (obj != 0) {
	free(obj);
    }
}
   return access(filename, access_mode) == 0;
#else
    FILE *fp;
    int got_file;

    if (strcmp(mode, "x") == 0) {
	mode = "r";
    }
    fp = fopen(filename, mode);
    got_file = (fp != 0);
    if (fp != 0) {
	(void) fclose(fp);
    }
    return got_file;
#endif
}
                                                    1  0                                                                                                                                                                 vl2mv/src/util/state.c                                                                              100644  027004  000214  00000003764 05332024500 012125  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifdef notdef
#ifdef lint
util_restart_save_state()
{
    return 0;
}


util_restart_restore_state()
{
}

#else


#ifdef vax
int util_restart_state[32];

util_restart_save_state()
{
    asm("movl	sp,_util_save_sp");
    asm("movl	r1,_util_restart_state");
    asm("movl	r2,_util_restart_state+4");
    asm("movl	r3,_util_restart_state+8");
    asm("movl	r4,_util_restart_state+12");
    asm("movl	r5,_util_restart_state+16");
    asm("movl	r6,_util_restart_state+20");
    asm("movl	r7,_util_restart_state+24");
    asm("movl	r8,_util_restart_state+28");
    asm("movl	r9,_util_restart_state+32");
    asm("movl	r10,_util_restart_state+36");
    asm("movl	r11,_util_restart_state+40");
    asm("movl	8(fp),_util_restart_state+44");
    asm("movl	12(fp),_util_restart_state+48");
    asm("movl	16(fp),_util_restart_state+52");
    asm("movl	$0,r0");
}

util_restart_restore_state()
{
    asm("movl	_util_restart_state,r1");
    asm("movl	_util_restart_state+4,r2");
    asm("movl	_util_restart_state+8,r3");
    asm("movl	_util_restart_state+12,r4");
    asm("movl	_util_restart_state+16,r5");
    asm("movl	_util_restart_state+20,r6");
    asm("movl	_util_restart_state+24,r7");
    asm("movl	_util_restart_state+28,r8");
    asm("movl	_util_restart_state+32,r9");
    asm("movl	_util_restart_state+36,r10");
    asm("movl	_util_restart_state+40,r11");
    asm("movl	_util_restart_state+44,ap");
    asm("movl	_util_restart_state+48,fp");
    asm("addl3	fp,$4,sp");
    asm("movl	_util_restart_state+52,r0");
    asm("jmp	(r0)");
}
#endif


#if defined(sun) && ! defined(sparc)
int util_restart_state[32];

util_restart_save_state()
{
    asm("movel	sp,_util_save_sp");
    asm("movel	sp@,_util_restart_state");
    asm("movel	sp@(0x4),_util_restart_state+4");
    asm("moveml	#0xFFFF,_util_restart_state+8");
    return 0;
}

util_restart_restore_state()
{
    asm("moveml	_util_restart_state+8,#0xFFFF");
    asm("movel	_util_restart_state+4,sp@(0x4)");
    asm("movel	_util_restart_state,sp@");
    return 1;
}
#endif

#endif
#endif
, and
	REALLvl2mv/src/util/stub.c                                                                               100644  027004  000214  00000001747 05332024500 011761  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#ifdef LACK_SYS5

char *
memcpy(s1, s2, n)
char *s1, *s2;
int n;
{
    extern bcopy();
    bcopy(s2, s1, n);
    return s1;
}

char *
memset(s, c, n)
char *s;
int c;
int n;
{
    extern bzero();
    register int i;

    if (c == 0) {
	bzero(s, n);
    } else {
	for(i = n-1; i >= 0; i--) {
	    *s++ = c;
	}
    }
    return s;
}

char *
strchr(s, c)
char *s;
int c;
{
    extern char *index();
    return index(s, c);
}

char *
strrchr(s, c)
char *s;
int c;
{
    extern char *rindex();
    return rindex(s, c);
}


#endif

#ifndef UNIX
#include <stdio.h>

/*ARGSUSED*/
FILE *
popen(string, mode)
char *string;
char *mode;
{
    (void) fprintf(stderr, "popen not supported on your operating system\n");
    return NULL;
}


/*ARGSUSED*/
int
pclose(fp)
FILE *fp;
{
    (void) fprintf(stderr, "pclose not supported on your operating system\n");
    return -1;
}
#endif

/* put something here in case some compilers abort on empty files ... */
util_do_nothing()
{
    return 1;
}
                         vl2mv/src/util/test-restart.c                                                                       100644  027004  000214  00000002133 05332024501 013434  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifdef notdef
#include <stdio.h>
#include "util.h"


main(argc, argv, environ)
int argc;
char **argv;
char **environ;
{
    int i;
    char **ep, *prog;

    prog = util_path_search(argv[0]);
    if (prog == NIL(char)) {
	(void) fprintf(stderr, "Cannot find current executable\n");
	exit(1);
    }
    util_restart(prog, "a.out", 0);

    i = recur(10);
    (void) fprintf(stderr, "terminated normally with i = %d\n", i);

    (void) printf("argc is %d\n", argc);

    for(i = 0, ep = argv; *ep != 0; i++, ep++) {
	(void) printf("%08x (%08x-%08x)\targv[%d]:\t%s\n", 
	    ep, *ep, *ep + strlen(*ep), i, *ep);
    }

    i = 0;
    for(i = 0, ep = environ; *ep != 0; ep++, i++) {
	(void) printf("%08x (%08x-%08x)\tenviron[%d]:\t%s\n", 
	    ep, *ep, *ep + strlen(*ep), i, *ep);
    }

    (void) fprintf(stderr, "returning with status=4\n");
    return 4;
}


recur(cnt)
{
    int i, j, sum;

    if (cnt > 0) {
	return recur(cnt-1);
    } else {
	sum = 0;
	for(j = 0; j < 20; j++) {
	    for(i = 0; i < 100000; i++) {
	       sum += 1;
	    }
	    (void) printf("done loop %d\n", j);
	}
	return sum;
    }
}
#endif
ase, stack_size);

    /* remove the sbrk for the stack */
    if (sbrk(-stack_size) < 0) {
	perror("sbrk");
    }

    util_restart_restore_state();	/* jump back into handle_sigquit() */
}

void
util_restart(old, new, interval)
char *old, *new;
int interval;
{
    struct itimerval itimer;

#ifdef vax
#ifdef ultrix
    stack_hi_addr = (char *) 0x7fffe3ff;	/* ultrix */
#else
    stack_hi_addr = (char *) 0x7fffebff;	/*vl2mv/src/util/texpand.c                                                                            100644  027004  000214  00000002401 05332024501 012434  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"

#ifdef BSD
#include <pwd.h>
#endif


char *
util_tilde_expand(fname)
char *fname;
{
#ifdef BSD
    struct passwd *userRecord;
    char username[256], *filename, *dir, *strcat();
    register int i, j;

    filename = ALLOC(char, strlen(fname) + 256);

    /* Clear the return string */
    i = 0;
    filename[0] = '\0';

    /* Tilde? */
    if (fname[0] == '~') {
	j = 0;
	i = 1;
	while ((fname[i] != '\0') && (fname[i] != '/')) {
	    username[j++] = fname[i++];
	}
	username[j] = '\0';
	dir = (char *)0;
	if (username[0] == '\0') {
	    /* ~/ resolves to home directory of current user */
	    userRecord = getpwuid(getuid());
	    if (userRecord) dir = userRecord->pw_dir;
	} else {
	    /* Special check for ~octtools */
	    if (!strcmp(username,"octtools"))
	        dir = getenv("OCTTOOLS");
	    /* ~user/ resolves to home directory of 'user' */
	    if (!dir) {
	        userRecord = getpwnam(username);
		if (userRecord) dir = userRecord->pw_dir;
	    }
	}
	if (dir) (void) strcat(filename, dir);
	else i = 0;	/* leave fname as-is */
    } /* if tilde */

    /* Concantenate remaining portion of file name */
    (void) strcat(filename, fname + i);
    return filename;
#else
    return strsav(fname);
#endif
}
 size object is guaranteed to return something
 *	    which is not 0, and can safely be freed (but not dereferenced)
 *	free() accepts (silently) an 0 pointer
 *	realloc of a 0 pointer is allowed, and is equiv. to malloc()
 *	For the IBM/PC it forces no ovl2mv/src/util/tmpfile.c                                                                            100644  027004  000214  00000001146 05332024501 012436  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
 *  tmpfile -- open an unnamed temporary file
 *
 *  This is the ANSI C standard routine; we have hacks here because many
 *  compilers/systems do not have it yet.
 */

/* LINTLIBRARY */


#include <stdio.h>
#include "util.h"


#ifdef UNIX

extern char *mktemp();

FILE *
tmpfile()
{
    FILE *fp;
    char *filename, *junk;

    junk = strsav("/usr/tmp/sisXXXXXX");
    filename = mktemp(junk);
    if ((fp = fopen(filename, "w+")) == NULL) {
	FREE(junk);
	return NULL;
    }
    (void) unlink(filename);
    FREE(junk);
    return fp;
}

#else

FILE *
tmpfile()
{
    return fopen("utiltmp", "w+");
}

#endif
0L) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
#endif
    if (obj == NIL(char)) return MMalloc(size);
    if (size <= 0) size = sizeof(long);
    if ((p = (char *) realloc(obj, (unsigned) size)) == NIL(char)) {
	if (MMoutOfMemory != (void (*)()) 0 ) (*MMoutOfMemory)(size);
	return NIL(char);
    }
    return p;
}


void
MMfree(obj)
char *obj;
{
    if (obj != 0vl2mv/src/st/                                                                                       040755  027004  000214  00000000000 05402724327 007506  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/src/st/Makefile                                                                               100644  027004  000214  00000000723 05332026244 011751  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 # st -- hash table package
#---------------------------------------------------------------------------

LIB_DIR = ../../lib

P	= st
PSRC	= st.c
POBJ	= st.o
PHDR	= st.h
MISC	= st.doc Makefile st_bench1.c

INCLUDE	= -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a
;
    asm("movl	r7,_util_restart_state+24");
vl2mv/src/st/st.c                                                                                   100644  027004  000214  00000020655 05332024514 011107  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #include <stdio.h>
#include "util.h"
#include "st.h"

#define ST_NUMCMP(x,y) ((x) != (y))
#define ST_NUMHASH(x,size) (ABS((int)x)%(size))
#define ST_PTRHASH(x,size) ((int)((unsigned)(x)>>2)%size)
#define EQUAL(func, x, y) \
    ((((func) == st_numcmp) || ((func) == st_ptrcmp)) ?\
      (ST_NUMCMP((x),(y)) == 0) : ((*func)((x), (y)) == 0))


#define do_hash(key, table)\
    ((table->hash == st_ptrhash) ? ST_PTRHASH((key),(table)->num_bins) :\
     (table->hash == st_numhash) ? ST_NUMHASH((key), (table)->num_bins) :\
     (*table->hash)((key), (table)->num_bins))

int st_numhash(), st_ptrhash(), st_numcmp(), st_ptrcmp();

st_table *st_init_table_with_params(compare, hash, size, density, grow_factor,
				    reorder_flag)
int (*compare)();
int (*hash)();
int size;
int density;
double grow_factor;
int reorder_flag;
{
    int i;
    st_table *new;

    new = ALLOC(st_table, 1);
    new->compare = compare;
    new->hash = hash;
    new->num_entries = 0;
    new->max_density = density;
    new->grow_factor = grow_factor;
    new->reorder_flag = reorder_flag;
    if (size <= 0) {
	size = 1;
    }
    new->num_bins = size;
    new->bins = ALLOC(st_table_entry *, size);
    for(i = 0; i < size; i++) {
	new->bins[i] = 0;
    }
    return new;
}

st_table *st_init_table(compare, hash)
int (*compare)();
int (*hash)();
{
    return st_init_table_with_params(compare, hash, ST_DEFAULT_INIT_TABLE_SIZE,
				     ST_DEFAULT_MAX_DENSITY,
				     ST_DEFAULT_GROW_FACTOR,
				     ST_DEFAULT_REORDER_FLAG);
}
			    
void
st_free_table(table)
st_table *table;
{
    register st_table_entry *ptr, *next;
    int i;

    for(i = 0; i < table->num_bins ; i++) {
	ptr = table->bins[i];
	while (ptr != NIL(st_table_entry)) {
	    next = ptr->next;
	    FREE(ptr);
	    ptr = next;
	}
    }
    FREE(table->bins);
    FREE(table);
}

#define PTR_NOT_EQUAL(table, ptr, user_key)\
(ptr != NIL(st_table_entry) && !EQUAL(table->compare, user_key, (ptr)->key))

#define FIND_ENTRY(table, hash_val, key, ptr, last) \
    (last) = &(table)->bins[hash_val];\
    (ptr) = *(last);\
    while (PTR_NOT_EQUAL((table), (ptr), (key))) {\
	(last) = &(ptr)->next; (ptr) = *(last);\
    }\
    if ((ptr) != NIL(st_table_entry) && (table)->reorder_flag) {\
	*(last) = (ptr)->next;\
	(ptr)->next = (table)->bins[hash_val];\
	(table)->bins[hash_val] = (ptr);\
    }

st_lookup(table, key, value)
st_table *table;
register char *key;
char **value;
{
    int hash_val;
    register st_table_entry *ptr, **last;

    hash_val = do_hash(key, table);

    FIND_ENTRY(table, hash_val, key, ptr, last);
    
    if (ptr == NIL(st_table_entry)) {
	return 0;
    } else {
	if (value != NIL(char *))  *value = ptr->record; 
	return 1;
    }
}

#define ADD_DIRECT(table, key, value, hash_val, new)\
{\
    if (table->num_entries/table->num_bins >= table->max_density) {\
	rehash(table);\
	hash_val = do_hash(key,table);\
    }\
    \
    new = ALLOC(st_table_entry, 1);\
    \
    new->key = key;\
    new->record = value;\
    new->next = table->bins[hash_val];\
    table->bins[hash_val] = new;\
    table->num_entries++;\
}

st_insert(table, key, value)
register st_table *table;
register char *key;
char *value;
{
    int hash_val;
    st_table_entry *new;
    register st_table_entry *ptr, **last;

    hash_val = do_hash(key, table);

    FIND_ENTRY(table, hash_val, key, ptr, last);

    if (ptr == NIL(st_table_entry)) {
	ADD_DIRECT(table,key,value,hash_val,new);
	return 0;
    } else {
	ptr->record = value;
	return 1;
    }
}

st_add_direct(table, key, value)
st_table *table;
char *key;
char *value;
{
    int hash_val;
    st_table_entry *new;
    
    hash_val = do_hash(key, table);
    ADD_DIRECT(table, key, value, hash_val, new);
}

st_find_or_add(table, key, slot)
st_table *table;
char *key;
char ***slot;
{
    int hash_val;
    st_table_entry *new, *ptr, **last;

    hash_val = do_hash(key, table);

    FIND_ENTRY(table, hash_val, key, ptr, last);

    if (ptr == NIL(st_table_entry)) {
	ADD_DIRECT(table, key, (char *)0, hash_val, new)
	if (slot != NIL(char **)) *slot = &new->record;
	return 0;
    } else {
	if (slot != NIL(char **)) *slot = &ptr->record;
	return 1;
    }
}

st_find(table, key, slot)
st_table *table;
char *key;
char ***slot;
{
    int hash_val;
    st_table_entry *ptr, **last;

    hash_val = do_hash(key, table);

    FIND_ENTRY(table, hash_val, key, ptr, last);

    if (ptr == NIL(st_table_entry)) {
	return 0;
    } else {
	if (slot != NIL(char **)) *slot = &ptr->record;
	return 1;
    }
}

rehash(table)
register st_table *table;
{
    register st_table_entry *ptr, *next, **old_bins = table->bins;
    int i, old_num_bins = table->num_bins, hash_val;

    table->num_bins = table->grow_factor*old_num_bins;
    
    if (table->num_bins%2 == 0) {
	table->num_bins += 1;
    }
    
    table->num_entries = 0;
    table->bins = ALLOC(st_table_entry *, table->num_bins);
    for(i = 0; i < table->num_bins; i++) {
	table->bins[i] = 0;
    }

    for(i = 0; i < old_num_bins ; i++) {
	ptr = old_bins[i];
	while (ptr != NIL(st_table_entry)) {
	    next = ptr->next;
	    hash_val = do_hash(ptr->key, table);
	    ptr->next = table->bins[hash_val];
	    table->bins[hash_val] = ptr;
	    table->num_entries++;
	    ptr = next;
	}
    }
    FREE(old_bins);
}

st_table *st_copy(old_table)
st_table *old_table;
{
    st_table *new_table;
    st_table_entry *ptr, *new;
    int i, num_bins = old_table->num_bins;

    new_table = ALLOC(st_table, 1);
    if (new_table == NIL(st_table)) {
	return NIL(st_table);
    }
    
    *new_table = *old_table;
    new_table->bins = ALLOC(st_table_entry *, num_bins);
    
    if (new_table->bins == NIL(st_table_entry *)) {
	FREE(new_table);
	return NIL(st_table);
    }

    for(i = 0; i < num_bins ; i++) {
	new_table->bins[i] = NIL(st_table_entry);
	ptr = old_table->bins[i];
	while (ptr != NIL(st_table_entry)) {
	    new = ALLOC(st_table_entry, 1);
	    if (new == NIL(st_table_entry)) {
		FREE(new_table->bins);
		FREE(new_table);
		return NIL(st_table);
	    }
	    *new = *ptr;
	    new->next = new_table->bins[i];
	    new_table->bins[i] = new;
	    ptr = ptr->next;
	}
    }
    return new_table;
}

st_delete(table, keyp, value)
register st_table *table;
register char **keyp;
char **value;
{
    int hash_val;
    char *key = *keyp;
    register st_table_entry *ptr, **last;

    hash_val = do_hash(key, table);

    FIND_ENTRY(table, hash_val, key, ptr ,last);
    
    if (ptr == NIL(st_table_entry)) {
	return 0;
    }

    *last = ptr->next;
    if (value != NIL(char *)) *value = ptr->record;
    *keyp = ptr->key;
    FREE(ptr);
    table->num_entries--;
    return 1;
}

int
st_foreach(table, func, arg)
st_table *table;
enum st_retval (*func)();
char *arg;
{
    st_table_entry *ptr, **last;
    enum st_retval retval;
    int i;

    for(i = 0; i < table->num_bins; i++) {
	last = &table->bins[i]; ptr = *last;
	while (ptr != NIL(st_table_entry)) {
	    retval = (*func)(ptr->key, ptr->record, arg);
	    switch (retval) {
	    case ST_CONTINUE:
		last = &ptr->next; ptr = *last;
		break;
	    case ST_STOP:
		return 0;
	    case ST_DELETE:
		*last = ptr->next;
		table->num_entries--;	/* cstevens@ic */
		FREE(ptr);
		ptr = *last;
	    }
	}
    }
    return 1;
}

st_strhash(string, modulus)
register char *string;
int modulus;
{
    register int val = 0;
    register int c;
    
    while ((c = *string++) != '\0') {
	val = val*997 + c;
    }

    return ((val < 0) ? -val : val)%modulus;
}

st_numhash(x, size)
char *x;
int size;
{
    return ST_NUMHASH(x, size);
}

st_ptrhash(x, size)
char *x;
int size;
{
    return ST_PTRHASH(x, size);
}

st_numcmp(x, y)
char *x;
char *y;
{
    return ST_NUMCMP(x, y);
}

st_ptrcmp(x, y)
char *x;
char *y;
{
    return ST_NUMCMP(x, y);
}

st_generator *
st_init_gen(table)
st_table *table;
{
    st_generator *gen;

    gen = ALLOC(st_generator, 1);
    gen->table = table;
    gen->entry = NIL(st_table_entry);
    gen->index = 0;
    return gen;
}


int 
st_gen(gen, key_p, value_p)
st_generator *gen;
char **key_p;
char **value_p;
{
    register int i;

    if (gen->entry == NIL(st_table_entry)) {
	/* try to find next entry */
	for(i = gen->index; i < gen->table->num_bins; i++) {
	    if (gen->table->bins[i] != NIL(st_table_entry)) {
		gen->index = i+1;
		gen->entry = gen->table->bins[i];
		break;
	    }
	}
	if (gen->entry == NIL(st_table_entry)) {
	    return 0;		/* that's all folks ! */
	}
    }
    *key_p = gen->entry->key;
    if (value_p != 0) *value_p = gen->entry->record;
    gen->entry = gen->entry->next;
    return 1;
}


void
st_free_gen(gen)
st_generator *gen;
{
    FREE(gen);
}
                                                                                   vl2mv/src/st/st.doc                                                                                 100644  027004  000214  00000016374 05332024514 011435  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 Basic functions:

st_table *st_init_table(compare_fn, hash_fn)
int (*compare_fn);
int (*hash_fn);

    Create and initialize a table with the comparison function compare_fn and
    hash function hash_fn. compare_fn is

	int compare_fn(char *key1, char *key2)
	    /*
	     * returns <,=,> 0 depending on whether 
	     * key1 <,=,> key2 by some measure
	     */
    
    and  hash_fn is
	
	int hash_fn(char *key, int modulus)
	    /*
	     * returns a integer between 0 and modulus-1
	     * such that if compare_fn(key1,key2) == 0 then
	     * hash_fn(key1) == hash_fn(key2)
	     */

     There are five predefined hash and comparison functions in st.
     For keys as numbers:
	 st_numhash(key, modulus) { return (unsigned int) key % modulus; }
	 st_numcmp(x,y) { return (int) x - (int) y; }
     For keys as pointers:
	 st_ptrhash(key, modulus) { return ((unsigned int) key/4) % modulus }
	 st_ptrcmp(x,y) { return (int) x - (int) y; }
     For keys as strings:
         st_strhash(x,y) - a reasonable hashing function for strings
	 strcmp(x,y) - the standard library function

     It is recommended to use these particular functions if they fit your 
     needs, since st will recognize certain of them and run more quickly
     because of it.
     	 
st_free_table(table)
st_table *table;
    
    Any internal storage associated with table is freed.  It is the user's
    responsibility to free any storage associated with the pointers he 
    placed in the table (by perhaps using st_foreach).

st_insert(table, key, value)
st_table *table;
char *key;
char *value;
    
    Insert value in table under the key 'key'.  Returns 1 if there was
    an entry already under the key, 0 otherewise.  In either case the new
    value is added.

st_lookup(table, key, value_ptr)
st_table *table;
char *key;
char **value_ptr;

    Lookup up `key' in `table'. If an entry is found, 1 is returned
    and if `value_ptr' is not nil, the variable it points to is set to
    associated value.  If an entry is not found, 0 is return and
    value_ptr is unchanged.

st_is_member(table, key)
st_table *table;
char *key;

     Returns 1 if there is an entry under `key' in `table', 0
     otherwise.

st_delete(table, key_ptr, entry_ptr)
st_table *table;
char **key_ptr;
char **value_ptr;

   Delete the entry with the key pointed to by `key_ptr'.  If the
   entry is found, 1 is returned and `key_ptr' is set to the actual key
   and `entry_ptr' is set to the corresponding entry (This allows the
   freeing of the associated storage).  If the entry is not found, then 0
   is returned and nothing is changed.

int st_foreach(table, func, arg)
st_table table;
enum st_retval (*func)();
char *arg;

     For each (key, value) record in `table', st_foreach call func
     with the arguments

	  (*func)(key, value, arg)
	  
     If func returns ST_CONTINUE, st_foreach continues processing entries.
     If func returns ST_STOP, st_foreach stops processing and returns
     immediately. If func returns ST_DELETE, then the entry is
     deleted from the symbol table and st_foreach continues.  In the
     case of ST_DELETE, it is func's responsibility to free the key
     and value, if necessary.  

     The routine returns 1 if all items in the table were generated and
     0 if the generation sequence was aborted using ST_STOP.  The order
     in which the records are visited will be seemingly random.

st_generator *st_init_gen(table)
st_table *table;

     Returns a generator handle which when used with st_gen() will
     progressively return each (key, value) record in `table'.

int st_gen(gen, key_p, value_p)
st_generator *gen;
char **key_p;
char **value_p;

     Given a generator returned by st_init_gen(),  this routine returns
     the next (key, value) pair in the generation sequence.  The
     pointer `value_p' can be zero which means no value will be returned.
     When there are no more items in the generation sequence,  the routine
     returns 0.

     While using a generation sequence,  deleting any (key, value)
     pair other than the one just generated may cause a fatal error
     when st_gen() is called later in the sequence and is therefore
     not recommended.

void st_free_gen(gen)
st_generator *gen;

     After generating all items in a generation sequence,  this
     routine must be called to reclaim the resources associated
     with `gen'.

st_foreach_item(table, gen, key_p, value_p)
st_table *table;
st_generator *gen;
char **key_p;
char **value_p;

     An iteration macro which loops over all the entries in `table', setting
     `key_p' to point to the key and `value_p' to the associated value (if it
     is not nil). `gen' is a generator variable used internally. Sample usage:

     	char *key, *value;
	st_generator *gen;

	st_foreach_item(table, gen, &key, &value) {
	    process_item(value);
	}

st_count(table)
st_table table;

	return the number of entries in the table `table'.

Fancier functions:

st_table *st_init_table_with_params(compare, hash, size, density, grow_factor,
                                    reorder_flag)
int (*compare)();
int (*hash)();
int size;
int density;
double grow_factor;
int reorder_flag;

	The full blown table initializer.  compare and hash are the same
    as in st_init_table. density is the largest the average number of
    entries per hash bin there should be before the table is grown.
    grow_factor is the factor the table is grown by when it becomes too
    full. size is the initial number of bins to be allocated for the hash
    table.  If reorder_flag is non-zero, then everytime an entry is found,
    it is moved to the top of the chain.

       st_init_table(compare, hash) is equivelent to
    st_init_table_with_params(compare, hash, ST_DEFAULT_INIT_TABLE_SIZE,
				     ST_DEFAULT_MAX_DENSITY,
				     ST_DEFAULT_GROW_FACTOR,
				     ST_DEFAULT_REORDER_FLAG);

st_find_or_add(table, key, slot_ptr)
st_table *table;
char *key;
char ***slot_ptr;

   Lookup `key' in `table'.  If not found, create an entry.In either case
   set slot to point to the field in the entry where the value is stored.
   The value associated with `key' may then be changed by accessing
   directly through slot.  Returns 1 if an entry already existed, 0
   otherwise. As an example:

      char **slot;
      char *key;
      char *value = (char *) item_ptr /* ptr to a malloc'd structure */

      if (st_find_or_add(table, key, &slot)) {
	 FREE(*slot); /* free the old value of the record */
      }
      *slot = value;  /* attach the new value to the record */

   This replaces the equivelent code:

      if (st_lookup(table, key, &ovalue)) {
         FREE(ovalue);
      }
      st_insert(table, key, value);


st_find(table, key, slot_ptr)
st_table *table;
char *key;
char ***slot_ptr;

    Like st_find_or_add, but does not create an entry if one is not found.

st_add_direct(table, key, value)
st_table *table;
char *key;
char *value;

    Place 'value' in 'table' under the key 'key'.  This is done
    without checking if 'key' is in 'table' already.  This should
    only be used if you are sure there is not already an entry for
    'key', since it is undefined which entry you would later get from
    st_lookup or st_find_or_add.

st_table *
st_copy(old_table)
st_table *old_table;

    Return a copy of old_table and all its members.  (st_table *) 0 is
    returned if there was insufficient memory to do the copy.

le, hash_val, key, ptr ,last);
    
    if (ptr == NIL(st_table_entry)) {
	return 0;
    }

    *last = ptr->next;
    if (value != NIL(char *)) *value = ptr->record;
    *keyp = ptr->key;
    FREE(ptr);
    table->num_entries--;
    return 1;
}

int
st_foreacvl2mv/src/st/st_bench1.c                                                                            100644  027004  000214  00000002733 05332024516 012326  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #include <stdio.h>
#include "array.h"
#include "st.h"
#include "util.h"

#define MAX_WORD	1024

extern long random();

/* ARGSUSED */
main(argc, argv)
char *argv;
{
    array_t *words;
    st_table *table;
    char word[MAX_WORD], *tempi, *tempj;
    register int i, j;
    long time;
#ifdef TEST
    st_generator *gen;
    char *key;
#endif

    /* read the words */
    words = array_alloc(char *, 1000);
    while (gets(word) != NIL(char)) {
	array_insert_last(char *, words, strsav(word));
#ifdef TEST
	if (array_n(words) == 25) break;
#endif
    }

    /* scramble them */
    for(i = array_n(words)-1; i >= 1; i--) {
	j = random() % i;
	tempi = array_fetch(char *, words, i);
	tempj = array_fetch(char *, words, j);
	array_insert(char *, words, i, tempj);
	array_insert(char *, words, j, tempi);
    }

#ifdef TEST
    (void) printf("Initial data is\n");
    for(i = array_n(words)-1; i >= 0; i--) {
	(void) printf("%s\n", array_fetch(char *, words, i));
    }
#endif

    /* time putting them into an st tree */
    time = util_cpu_time();
    table = st_init_table(strcmp, st_strhash);
    for(i = array_n(words)-1; i >= 0; i--) {
	(void) st_insert(table, array_fetch(char *, words, i), NIL(char));
    }
    (void) printf("Elapsed time for insert of %d objects was %s\n",
	array_n(words), util_print_time(util_cpu_time() - time));

#ifdef TEST
    (void) printf("st data is\n");
    st_foreach_item(table, gen, &key, NIL(char *)) {
	(void) printf("%s\n", key);
    }
#endif
    return 0;
}
                                     vl2mv/src/array/                                                                                    040755  027004  000214  00000000000 05402724327 010176  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/src/array/Makefile                                                                            100644  027004  000214  00000001045 05332026144 012436  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 # array -- dynamic array package
#---------------------------------------------------------------------------

LIBDIR =../../lib

P	= array
PSRC	= array.c
POBJ	= array.o
PHDR	= array.h
VISC	= array.doc Makefile

SRC	= arr_main.c
OBJ	= arr_main.o
HDR	=

INCLUDE	= -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIBDIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a

clean:
	rm -f $(TARGET) *.a *.o \
rd library function

     It is recommended to use these particular functions if they fit your 
     needs, since st will recognize certain of them and run more quickly
     because of it.
     	 
st_free_table(table)
st_table *table;
    
    Any internal storage associated with table is freed.  It is the user's
    responsibility to free any storage associated with the pointers he 
    placed in the table (by perhaps using st_foreach).

st_insert(table, key, value)
st_vl2mv/src/array/arr_main.c                                                                          100644  027004  000214  00000007065 05332024522 012740  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #include <stdio.h>
#include "util.h"
#include "array.h"

extern long random();
extern void srandom();

static int count;			/* global: count # compares */


static int 
compare(a, b)
char **a, **b;
{
    count++;
    return *(int *) a - * (int *) b;
}


static void
print(s, a)
char *s;
array_t *a;
{
    int i;

    (void) printf("%s\n", s);
    for(i = 0; i < array_n(a); i++) {
	(void) printf(" %d", array_fetch(int, a, i));
    }
    (void) printf("\n");
}


#define IN_ORDER 	1
#define REVERSE_ORDER 	2
#define RANDOM 		3
#define RANDOM_RANGE	4


void
usage(prog)
char *prog;
{
    (void) fprintf(stderr, "%s: check out the array package\n", prog);
    (void) fprintf(stderr, "\t-o\tinitial data in order\n");
    (void) fprintf(stderr, "\t-r\tinitial data in reverse order\n");
    (void) fprintf(stderr, "\t-n #\tnumber of values to sort\n");
    (void) fprintf(stderr, "\t-b #\tmaximum value for the random values\n");
    exit(2);
}

int 
main(argc, argv)
int argc;
char *argv[];
{
    long time;
    array_t *a, *a1;
    int *b, i, n, type, c, range, value;

    type = RANDOM_RANGE;
    range = 10;
    n = 15;
    while ((c = getopt(argc, argv, "b:orn:")) != EOF) {
	switch (c) {
	    case 'o':
		type = IN_ORDER;
		break;
	    case 'r':
		type = REVERSE_ORDER;
		break;
	    case 'n':
		n = atoi(optarg);
		break;
	    case 'b':
		type = RANDOM_RANGE;
		range = atoi(optarg);
		break;
	    default:
		usage(argv[0]);
		break;
	}
    }

    if (optind != argc) {
	usage(argv[0]);
    }

    /*
     *  create the input-data
     */
    srandom(1);
    time = util_cpu_time();
    a = array_alloc(int, 0);
    for(i = 0; i < n; i++) {
	if (type == IN_ORDER) {
	    value = i;
	} else if (type == REVERSE_ORDER) {
	    value = n - i;
	} else if (type == RANDOM_RANGE) {
	    value = random() % range;
	} else {
	    value = random();
	}
	array_insert(int, a, i, value);
	if (n < 20) (void) printf(" %d", value);
    }
    (void) printf("\nfill: %d objects, time was %s\n", 
	array_n(a), util_print_time(util_cpu_time()-time));
    if (n < 20) print("unsorted list", a);


    /* 
     *  time a fill using normal subscripted arrays 
     */
    srandom(1);
    time = util_cpu_time();
    b = ALLOC(int, n);
    for(i = 0; i < n; i++) {
	if (type == IN_ORDER) {
	    value = i;
	} else if (type == REVERSE_ORDER) {
	    value = n - i;
	} else if (type == RANDOM_RANGE) {
	    value = random() % range;
	} else {
	    value = random();
	}
	b[i] = value;
    }
    (void) printf("fill (fast): %d objects, time was %s\n", 
	array_n(a), util_print_time(util_cpu_time()-time));

    /*
     *  now a quick check of append() and insert_last()
     */
    a1 = array_alloc(int, 5);
    array_insert_last(int, a1, 2);
    array_insert_last(int, a1, 1);
    array_insert_last(int, a1, 0);
    if (n < 20) print("unsorted list1", a1);
    array_append(a, a1);
    (void) printf("after join: %d objects, time was %s\n", 
	array_n(a), util_print_time(util_cpu_time()-time));
    if (n < 20) print("unsorted list (after join)", a);
    array_free(a1);



    /*
     *  Test the sorter
     */
    count = 0;
    time = util_cpu_time();
    array_sort(a, compare);
    (void) printf("sort: %d objects, %d compares, time was %s\n", 
	array_n(a), count, util_print_time(util_cpu_time()-time));
    if (n < 20) print("sorted list", a);


    /*
     *  Try the uniq
     */
    count = 0;
    time = util_cpu_time();
    array_uniq(a, compare, (void (*)()) 0);
    (void) printf("uniq: %d objects, %d compares, time was %s\n", 
	array_n(a), count, util_print_time(util_cpu_time()-time));
    if (n < 20) print("uniq list", a);

    return 0;
}
quivelent to
    st_init_table_with_params(compare, hash, ST_DEFAULT_INIT_TABLE_SIZE,
				     ST_DEFAULT_MAX_DENSITY,
				     ST_DEFAULT_GROW_FACTOR,
				     ST_DEFAULT_REORDER_FLAG);

st_find_or_add(table, key, slot_ptr)
st_table *table;
char *key;
char ***slot_ptr;

   Lookup `key' in `table'.  If not found, create an entry.In either case
   set slot to point to the field in the entry where the value is stored.
   The value associated with `key' may vl2mv/src/array/array.c                                                                             100644  027004  000214  00000010215 05332024522 012255  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

#include <stdio.h>
#include "util.h"
#include "array.h"

int array_i;		/* global for macro's */

#define INIT_SIZE	3


array_t *
array_do_alloc(size, number)
int size;
int number;
{
    array_t *array;

    array = ALLOC(array_t, 1);
    array->num = 0;
    array->n_size = MAX(number, INIT_SIZE);
    array->obj_size = size;
    array->space = ALLOC(char, array->n_size * array->obj_size);
    (void) memset(array->space, 0, array->n_size * array->obj_size);
    return array;
}


void
array_free(array)
array_t *array;
{
    FREE(array->space);
    FREE(array);
}


array_t *
array_dup(old)
array_t *old;
{
    array_t *new;

    new = ALLOC(array_t, 1);
    new->num = old->num;
    new->n_size = old->num;
    new->obj_size = old->obj_size;
    new->space = ALLOC(char, new->n_size * new->obj_size);
    (void) memcpy(new->space, old->space, old->num * old->obj_size);
    return new;
}

/* append the elements of array2 to the end of array1 */
void
array_append(array1, array2)
array_t *array1;
array_t *array2;
{
    char *pos;

    if (array1->obj_size != array2->obj_size) {
	(void) array_abort(2);
	/* NOTREACHED */
    }

    /* make sure array1 has enough room */
    if (array1->n_size < array1->num + array2->num) {
	(void) array_resize(array1, array1->num + array2->num);
    }

    pos = array1->space + array1->num * array1->obj_size;
    (void) memcpy(pos, array2->space, array2->num * array2->obj_size);
    array1->num += array2->num;
}


/* join array1 and array2, returning a new array */
array_t *
array_join(array1, array2)
array_t *array1;
array_t *array2;
{
    array_t *array;
    char *pos;

    if (array1->obj_size != array2->obj_size) {
	(void) array_abort(3);
	fail("array: join not defined for arrays of different sizes\n");
	/* NOTREACHED */
    }

    array = ALLOC(array_t, 1);
    array->num = array1->num + array2->num;
    array->n_size = array->num;
    array->obj_size = array1->obj_size;
    array->space = ALLOC(char, array->n_size * array->obj_size);
    (void) memcpy(array->space, array1->space, array1->num * array1->obj_size);
    pos = array->space + array1->num * array1->obj_size;
    (void) memcpy(pos, array2->space, array2->num * array2->obj_size);
    return array;
}

char *
array_do_data(array)
array_t *array;
{
    char *data;

    data = ALLOC(char, array->num * array->obj_size);
    (void) memcpy(data, array->space, array->num * array->obj_size);
    return data;
}


int			/* would like to be void, except for macro's */
array_resize(array, new_size)
array_t *array;
int new_size;
{
    int old_size;
    char *pos;

    old_size = array->n_size;
    array->n_size = MAX(array->n_size * 2, new_size);
    array->space = REALLOC(char, array->space, array->n_size * array->obj_size);
    pos = array->space + old_size * array->obj_size;
    (void) memset(pos, 0, (array->n_size - old_size)*array->obj_size);
}

void
array_sort(array, compare)
array_t *array;
int (*compare)();
{
    qsort(array->space, array->num, array->obj_size, compare);
}


void
array_uniq(array, compare, free_func)
array_t *array;
int (*compare)();
void (*free_func)();
{
    int i, last;
    char *dest, *obj1, *obj2;

    dest = array->space;
    obj1 = array->space;
    obj2 = array->space + array->obj_size;
    last = array->num;

    for(i = 1; i < last; i++) {
	if ((*compare)((char **) obj1, (char **) obj2) != 0) {
	    if (dest != obj1) {
		(void) memcpy(dest, obj1, array->obj_size);
	    }
	    dest += array->obj_size;
	} else {
	    if (free_func != 0) (*free_func)(obj1);
	    array->num--;
	}
	obj1 += array->obj_size;
	obj2 += array->obj_size;
    }
    if (dest != obj1) {
	(void) memcpy(dest, obj1, array->obj_size);
    }
}

int			/* would like to be void, except for macro's */
array_abort(i)
int i;
{
    switch (i) {
	case 0: 
	    fail("array: array access out of bounds\n");
	    /* NOTREACHED */
	case 1:
	    fail("array: object size mismatch\n");
	    /* NOTREACHED */
	case 2:
	    fail("array: append not defined for arrays of different sizes\n");
	    /* NOTREACHED */
	case 3:
	    fail("array: join not defined for arrays of different sizes\n");
	    /* NOTREACHED */
	default:
	    fail("array: unknown error\n");
	    /* NOTREACHED */
    }
}
SRC	= array.c
POBJ	= array.o
PHDR	= array.h
VISC	= array.doc Makefile

SRC	= arr_main.c
OBJ	= arr_main.o
HDR	=

INCLUDE	= -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIBDIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).vl2mv/src/array/array.doc                                                                           100644  027004  000214  00000010436 05332024523 012606  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 An array_t is a dynamically allocated array.  As elements are inserted
the array is automatically grown to accomodate the new elements.

The first element of the array is always element 0, and the last
element is element n-1 (if the array contains n elements).

This array package is intended for generic objects (i.e., an array of
int, array of char, array of double, array of struct foo *, or even
array of struct foo).

Be careful when creating an array with holes (i.e., when there is no
object stored at a particular position).  An attempt to read such a
position will return a 'zero' object.  It is poor practice to assume
that this value will be properly interpreted as, for example,  (double)
0.0 or (char *) 0.

In the definitions below, 'typeof' indicates that the argument to the
'function' is a C data type; these 'functions' are actually implemented
as macros.



array_t *
array_alloc(type, number)
typeof type;
int number;
	Allocate and initialize an array of objects of type `type'.
	Polymorphic arrays are okay as long as the type of largest
	object is used for initialization.  The array can initially
	hold `number' objects.  Typical use sets `number' to 0, and 
	allows the array to grow dynamically.


void
array_free(array)
array_t *array;
	Deallocate an array.  Freeing the individual elements of the
	array is the responsibility of the user.


int
array_n(array)
array_t *array;
	Returns the number of elements stored in the array.  If this is
	`n', then the last element of the array is at position `n' - 1.


type *
array_data(type, array)
array_t *array;
typeof type;
	Returns a normal `C' array from an array_t structure.  This is
	sometimes necessary when dealing with functions which do not
	understand the array_t data type.  A copy of the array is
	returned, and it is the users responsibility to free it.  array_n()
	can be used to get the number of elements in the array.


array_t *
array_dup(array)
array_t *array;
	Create a duplicate copy of an array.


void
array_insert(type, array, position, object)
typeof type;
array_t *array;
int position;
type object;
	Insert a new element into an array at the given position.  The
	array is dynamically extended if necessary to accomodate the
	new item.  It is a serious error if sizeof(type) is not the
	same as the type used when the array was allocated.  It is also
	a serious error for 'position' to be less than zero.


void
array_insert_last(type, array, object)
typeof type;
array_t *array;
type object;
	Insert a new element at the end of the array.  Equivalent to:
		array_insert(type, array, array_n(array), object).


type
array_fetch(type, array, position)
typeof type;
array_t *array;
int position;
	Fetch an element from an array.  A runtime error occurs on an
	attempt to reference outside the bounds of the array.  There is
	no type-checking that the value at the given position is
	actually of the type used when dereferencing the array.


type
array_fetch_last(type, array)
typeof type;
array_t *array;
	Fetch the last element from an array.  A runtime error occurs
	if there are no elements in the array.  There is no type-checking 
	that the value at the given position is actually of the type used 
	when dereferencing the array.  Equivalent to:
		array_fetch(type, array, array_n(array))


array_t *
array_join(array1, array2)
array_t *array1;
array_t *array2;
	Returns a new array which consists of the elements from array1
	followed by the elements of array2.


void
array_append(array1, array2)
array_t *array1;
array_t *array2;
	Appends the elements of array2 to the end of array1.


void
array_sort(array, compare)
array_t *array;
int (*compare)();
	Sort the elements of an array.  `compare' is defined as:

		int 
		compare(obj1, obj2)
		char *obj1;
		char *obj2;

	and should return -1 if obj1 < obj2, 0 if obj1 == obj2, or 1
	if obj1 > obj2.



void
array_uniq(array, compare, free_func)
array_t *array;
int (*compare)();
void (*free_func)();
	Compare adjacent elements of the array, and delete any duplicates.
	Usually the array should be sorted (using array_sort) before calling
	array_uniq.  `compare' is defined as:

		int 
		compare(obj1, obj2)
		char *obj1;
		char *obj2;

	and returns -1 if obj1 < obj2, 0 if obj1 == obj2, or 1 if obj1 > obj2.

	`free_func' (if non-null) is defined as:
		
		void
		free_func(obj1)
		char *obj1;

	and frees the given array element.
 *table;
char *key;
char ***slot_ptr;

   Lookup `key' in `table'.  If not found, create an entry.In either case
   set slot to point to the field in the entry where the value is stored.
   The value associated with `key' may vl2mv/include/                                                                                      040755  027004  000214  00000000000 05402724330 007706  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/include/ansi.h                                                                                100644  027004  000214  00000001441 05332024526 011621  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifndef ANSI_H
#define ANSI_H

/*
 * ANSI Compiler Support
 *
 * David Harrison
 * University of California, Berkeley
 * 1988
 *
 * ANSI compatible compilers are supposed to define the preprocessor
 * directive __STDC__.  Based on this directive, this file defines
 * certain ANSI specific macros.
 *
 * ARGS:
 *   Used in function prototypes.  Example:
 *   extern int foo
 *     ARGS((char *blah, double threshold));
 */

/* Function prototypes */
#if defined(__STDC__) || defined(__cplusplus)
#define ARGS(args)	args
#else
#define ARGS(args)	()
#endif

#if defined(__cplusplus)
#define NULLARGS	(void)
#else
#define NULLARGS	()
#endif

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN extern
#endif

#if defined(__cplusplus) || defined(__STDC__) 
#define HAS_STDARG
#endif

#endif
    pos = array1->space + array1->num * array1->obj_size;
    (void) memcpy(pos, array2->space, array2->num * array2->obj_size);
    array1->num += array2->num;
}


/* join array1 and array2, returning a new array */
array_vl2mv/include/array.h                                                                               100644  027004  000214  00000003436 05332024526 012013  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifndef ARRAY_H
#define ARRAY_H


typedef struct array_struct array_t;
struct array_struct {
    char *space;
    int num;		/* number of array elements */
    int n_size;		/* size of 'data' array (in objects) */
    int obj_size;	/* size of each array object */
};


EXTERN array_t *array_do_alloc ARGS((int size, int number));
EXTERN array_t *array_dup ARGS((array_t* old));
EXTERN array_t *array_join ARGS((array_t* array1, array_t* array2));
EXTERN void array_free ARGS((array_t* array));
EXTERN void array_append ARGS((array_t* array1, array_t* array2));
EXTERN void array_sort ARGS((array_t* array, int (*compare)()));
EXTERN void array_uniq ARGS((array_t* array, int (*compare)(), void (*free_func)()));
EXTERN int array_abort ARGS((int i));
EXTERN int array_resize ARGS((array_t* array, int new_size));
EXTERN char *array_do_data ARGS((array_t* array));

extern int array_i;


#define array_alloc(type, number)		\
    array_do_alloc(sizeof(type), number)

#define array_insert(type, a, i, datum)		\
    (array_i = (i),				\
      array_i < 0 ? array_abort(0) : 0,		\
      sizeof(type) != (a)->obj_size ? array_abort(1) : 0,\
      array_i >= (a)->n_size ? array_resize(a, array_i + 1) : 0,\
      array_i >= (a)->num ? (a)->num = array_i + 1 : 0,\
      *((type *) ((a)->space + array_i * (a)->obj_size)) = datum)

#define array_fetch(type, a, i)			\
    (array_i = (i),				\
      (array_i < 0 || array_i >= (a)->num) ? array_abort(0) : 0,\
      *((type *) ((a)->space + array_i * (a)->obj_size)))

#define array_insert_last(type, array, datum)	\
    array_insert(type, array, (array)->num, datum)

#define array_fetch_last(type, array)		\
    array_fetch(type, array, ((array)->num)-1)

#define array_n(array)				\
    (array)->num

#define array_data(type, array)			\
    (type *) array_do_data(array)

#endif
REACHED */
	case 1:
	    fail("array: object size mismatch\n");
	    /* NOTREACHED */
	case 2:
	    fail("array: append not defined for arrays of different sizes\n");
	    /* NOTREACHED */
	case 3:
	    fail("array: join not dvl2mv/include/list.h                                                                                100644  027004  000214  00000010220 05332024527 011636  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
 * Revision Control Information
 *
 * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/list.h,v $
 * $Author: sis $
 * $Revision: 1.2 $
 * $Date: 1992/05/06 18:55:32 $
 *
 */
/*
 * List Management Package Header File
 *
 * David Harrison
 * University of California, 1985
 *
 * This file contains public type definitions for the List Managment
 * package implemented in list.c.  This is stand alone package.
 */

#ifndef LS_DEFINED
#define LS_DEFINED

/* This can be typedef'ed to void if supported */
typedef struct ls_dummy_defn {
    int dummy;			/* Not used */
} ls_dummy;

typedef ls_dummy *lsList;	/* List handle           */
typedef ls_dummy *lsGen;	/* List generator handle */
typedef ls_dummy *lsHandle;	/* Handle to an item     */
typedef int lsStatus;		/* Return codes          */
typedef char *lsGeneric;	/* Generic pointer       */

#define	LS_NIL		0	/* Nil for lsList       */

#define LS_BADSTATE	-3	/* Bad generator state   */
#define LS_BADPARAM	-2	/* Bad parameter value   */
#define LS_NOMORE	-1	/* No more items         */

#define	LS_OK		0

#define LS_BEFORE	1	/* Set spot before object */
#define LS_AFTER	2	/* Set spot after object  */
#define LS_STOP		3	/* Stop generating items  */
#define LS_DELETE	4	/* Delete generated item  */

/*
 * For all those routines that take a handle,  this macro can be
 * used when no handle is required.
 */

#define LS_NH		(lsHandle *) 0

typedef lsGeneric (*LS_PFLSG)();

EXTERN lsList lsCreate ARGS((void));
  /* Create a new list */
EXTERN lsStatus lsDestroy ARGS((lsList list, void (*delFunc)()));
  /* Delete a previously created list */
EXTERN lsList lsCopy ARGS((lsList list, LS_PFLSG copyFunc));
   /* Copies the contents of a list    */

EXTERN lsStatus lsFirstItem ARGS((lsList list, lsGeneric *data, lsHandle *itemHandle));
  /* Gets the first item of a list */
EXTERN lsStatus lsLastItem ARGS((lsList list, lsGeneric *data, lsHandle *itemHandle));
  /* Gets the last item of a list */

EXTERN lsStatus lsNewBegin ARGS((lsList list, lsGeneric data, lsHandle *itemHandle));
  /* Add item to start of list */
EXTERN lsStatus lsNewEnd ARGS((lsList list, lsGeneric data, lsHandle *itemHandle));
  /* Add item to end of list */

EXTERN lsStatus lsDelBegin ARGS((lsList list, lsGeneric *data));
  /* Delete first item of a list */
EXTERN lsStatus lsDelEnd ARGS((lsList list, lsGeneric *data));
  /* Delete last item of a list */

EXTERN int lsLength ARGS((lsList list));
  /* Returns the length of the list */

EXTERN lsGen lsStart ARGS((lsList list));
  /* Begin generation of items in a list */
EXTERN lsGen lsEnd ARGS((lsList list));
  /* Begin generation at end of list */
EXTERN lsGen lsGenHandle ARGS((lsHandle itemHandle, lsGeneric *data, int option));
  /* Produces a generator given a handle */
EXTERN lsStatus lsNext ARGS((lsGen generator, lsGeneric *data, lsHandle *itemhandle));
  /* Generate next item in sequence */
EXTERN lsStatus lsPrev ARGS((lsGen generator, lsGeneric *data, lsHandle *itemHandle));
  /* Generate previous item in sequence */
EXTERN lsStatus lsInBefore ARGS((lsGen generator, lsGeneric data, 
   lsHandle *itemhandle));
  /* Insert an item before the most recently generated by lsNext */
EXTERN lsStatus lsInAfter ARGS((lsGen generator, lsGeneric data, 
   lsHandle *itemhandle));
  /* Insert an item after the most recently generated by lsNext  */
EXTERN lsStatus lsDelBefore ARGS((lsGen generator, lsGeneric *data));
  /* Delete the item before the current spot */
EXTERN lsStatus lsDelAfter ARGS((lsGen generator, lsGeneric *data));
  /* Delete the item after the current spot */
EXTERN lsStatus lsFinish ARGS((lsGen generator));
  /* End generation of items in a list */

EXTERN lsList lsQueryHandle ARGS((lsHandle itemHandle));
  /* Returns the list of a handle */
EXTERN lsGeneric lsFetchHandle ARGS((lsHandle itemHandle));
  /* Returns data associated with handle */
EXTERN lsStatus lsRemoveItem ARGS((lsHandle itemHandle, lsGeneric *userData));
  /* Removes item associated with handle from list */

EXTERN lsStatus lsSort ARGS((lsList list, int (*compare)()));

  /* Sorts a list */
EXTERN lsStatus lsUniq ARGS((lsList list, int (*compare)(), void (*delFunc)() ));
  /* Removes duplicates from a sorted list */

#endif
re(obj1, obj2)
		char *obj1;
		char *obj2;

	and should return -1 if obj1 < obj2, 0 if obj1 == obj2, or 1
	if obj1 > obj2.



void
array_uniq(array, compare, free_func)
array_t *array;
int (*compare)();
void (*free_func)();
	Compare adjacent elements of the array, and delete any duplicates.
	Usually the array should be sorted (using array_sort) before calling
	arrayvl2mv/include/st.h                                                                                  100644  027004  000214  00000004472 05332024530 011317  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* LINTLIBRARY */

/* $Header$ */

#ifndef ST_INCLUDED
#define ST_INCLUDED

typedef struct st_table_entry st_table_entry;
struct st_table_entry {
    char *key;
    char *record;
    st_table_entry *next;
};

typedef struct st_table st_table;
struct st_table {
    int (*compare)();
    int (*hash)();
    int num_bins;
    int num_entries;
    int max_density;
    int reorder_flag;
    double grow_factor;
    st_table_entry **bins;
};

typedef struct st_generator st_generator;
struct st_generator {
    st_table *table;
    st_table_entry *entry;
    int index;
};

#define st_is_member(table,key) st_lookup(table,key,(char **) 0)
#define st_count(table) ((table)->num_entries)

enum st_retval {ST_CONTINUE, ST_STOP, ST_DELETE};

typedef enum st_retval (*ST_PFSR)();
typedef int (*ST_PFI)();

EXTERN int st_delete ARGS((st_table *table, char **key_ptr, char **value_ptr));
EXTERN int st_insert ARGS((st_table* table, char *key, char *value));
EXTERN int st_foreach ARGS((st_table *table, ST_PFSR func, char *arg));
EXTERN int st_gen ARGS((st_generator *gen, char **key_p, char **value_p));
EXTERN int st_lookup ARGS((st_table *table, char *key, char **value_ptr));
EXTERN int st_find_or_add ARGS((st_table *table, char *key, char ***slot_ptr));
EXTERN int st_find ARGS((st_table *table, char *key, char ***slot_ptr));
EXTERN int st_add_direct ARGS((st_table *table, char *key, char *value));
EXTERN int st_strhash ARGS((char *string, int modulus));
EXTERN int st_numhash ARGS((char *x, int size));
EXTERN int st_ptrhash ARGS((char *x, int size));
EXTERN int st_numcmp ARGS((char *x, char *y));
EXTERN int st_ptrcmp ARGS((char* x, char *y));
EXTERN st_table *st_init_table ARGS((ST_PFI compare_fn, ST_PFI hash_fn)), 
	*st_init_table_with_params ARGS((ST_PFI compare, ST_PFI hash, 
	int size, int density, double grow_factor, int reorder_flag));
EXTERN st_table *st_copy ARGS((st_table *old_table));
EXTERN st_generator *st_init_gen ARGS((st_table *table));
EXTERN void st_free_table ARGS((st_table* table));
EXTERN void st_free_gen ARGS((st_generator *gen));


#define ST_DEFAULT_MAX_DENSITY 5
#define ST_DEFAULT_INIT_TABLE_SIZE 11
#define ST_DEFAULT_GROW_FACTOR 2.0
#define ST_DEFAULT_REORDER_FLAG 0

#define st_foreach_item(table, gen, key, value) \
    for(gen=st_init_gen(table); st_gen(gen,key,value) || (st_free_gen(gen),0);)


#endif /* ST_INCLUDED */
                                 1  0                                                                                                                                                                 vl2mv/include/util.h                                                                                100644  027004  000214  00000014675 05332024530 011654  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 #ifndef UTIL_H
#define UTIL_H

#if defined(_IBMR2)
#ifndef _POSIX_SOURCE
#define _POSIX_SOURCE           /* Argh!  IBM strikes again */
#endif
#ifndef _ALL_SOURCE
#define _ALL_SOURCE             /* Argh!  IBM strikes again */
#endif
#ifndef _ANSI_C_SOURCE
#define _ANSI_C_SOURCE          /* Argh!  IBM strikes again */
#endif
#endif

#if defined(_IBMR2) && !defined(__STDC__)
#define _BSD
#endif

#include "ansi.h"	/* since some files don't include sis.h */

#define USE_MM		/* choose libmm.a as the memory allocator */

#if !defined(__STDC__) && !defined(__cplusplus)
/* these are too entrenched to get away with changing the name */
#define strsav		util_strsav
#define getopt		util_getopt
#define getopt_reset	util_getopt_reset
#define optarg		util_optarg
#define optind		util_optind
#endif

#define NIL(type)		((type *) 0)

#ifdef USE_MM
/*
 *  assumes the memory manager is libmm.a
 *	- allows malloc(0) or realloc(obj, 0)
 *	- catches out of memory (and calls MMout_of_memory())
 *	- catch free(0) and realloc(0, size) in the macros
 */
#define ALLOC(type, num)	\
    ((type *) malloc(sizeof(type) * (num)))
#define REALLOC(type, obj, num)	\
    (obj) ? ((type *) realloc((char *) obj, sizeof(type) * (num))) : \
	    ((type *) malloc(sizeof(type) * (num)))
#define FREE(obj)		\
    ((obj) ? (free((char *) (obj)), (obj) = 0) : 0)
#else
/*
 *  enforce strict semantics on the memory allocator
 *	- when in doubt, delete the '#define USE_MM' above
 */
#define ALLOC(type, num)	\
    ((type *) MMalloc((long) sizeof(type) * (long) (num)))
#define REALLOC(type, obj, num)	\
    ((type *) MMrealloc((char *) (obj), (long) sizeof(type) * (long) (num)))
#define FREE(obj)		\
    ((obj) ? (free((char *) (obj)), (obj) = 0) : 0)
#endif


/* Ultrix (and SABER) have 'fixed' certain functions which used to be int */
#if defined(ultrix) || defined(SABER) || defined(aiws) || defined(hpux) || defined(__STDC__) || defined(apollo)
#define VOID_HACK void
#else
#define VOID_HACK int
#endif


/* No machines seem to have much of a problem with these */
#include <stdio.h>
#include <ctype.h>


/* Some machines fail to define some functions in stdio.h */
#if !defined(__STDC__) && !defined(sprite)
extern FILE *popen(), *tmpfile();
extern int pclose();
#ifndef clearerr		/* is a macro on many machines, but not all */
extern VOID_HACK clearerr();
#endif
#if !defined(_IBMR2) && !defined(sgi)
#ifndef rewind
extern VOID_HACK rewind();
#endif
#endif
#endif

#ifndef PORT_H
#include <sys/types.h>
#include <signal.h>
#if defined(ultrix)
#if defined(_SIZE_T_)
#define ultrix4
#else
#if defined(SIGLOST)
#define ultrix3
#else
#define ultrix2
#endif
#endif
#endif
#endif

/* most machines don't give us a header file for these */
#if defined(__STDC__) || defined(sprite)
#include <stdlib.h>
#else
#if defined(hpux)
extern int abort();
extern VOID_HACK free(), exit(), perror();
extern char *getenv(), *malloc(), *realloc(), *calloc();
#else
#if defined(_IBMR2) || defined(sgi)
extern int abort(), exit();
extern void free(), perror();
#else
extern VOID_HACK abort(), free(), exit(), perror();
#endif
extern char *getenv();
#ifdef ultrix4  /*** RAMIN ***/
extern void *malloc(), *realloc(), *calloc();
#else
extern char *malloc(), *realloc(), *calloc(); 
#endif
#endif
#if defined(aiws) || defined(hpux)
extern int sprintf();
#else
#if !defined(_IBMR2) && !defined(sgi)
extern char *sprintf();
#endif
#endif
extern int system();
extern double atof();
#endif

#ifndef PORT_H
#if defined(ultrix3) || defined(sunos4) || defined(_IBMR2)
#define SIGNAL_FN       void
#else
/* sequent, ultrix2, 4.3BSD (vax, hp), sunos3 */
#define SIGNAL_FN       int
#endif
#endif

/* some call it strings.h, some call it string.h; others, also have memory.h */
#if defined(__STDC__) || defined(sprite) || defined(sgi)
#include <string.h>
#else
#if defined(ultrix4) || defined(hpux) || defined(sgi)
#include <strings.h>
#else
/* ANSI C string.h -- 1/11/88 Draft Standard */
/* ugly, awful hack */
#ifndef PORT_H
extern char *strcpy(), *strncpy(), *strcat(), *strncat(), *strerror();
extern char *strpbrk(), *strtok(), *strchr(), *strrchr(), *strstr();
extern int strcoll(), strxfrm(), strncmp(), strlen(), strspn(), strcspn();
extern char *memmove(), *memccpy(), *memchr(), *memcpy(), *memset();
extern int memcmp(), strcmp();
#endif
#endif
#endif

/* a few extras */
#if defined(hpux)
extern VOID_HACK srand();
extern int rand();
#define random() rand()
#define srandom(a) srand(a)
#define bzero(a,b) memset(a, 0, b)
#else
extern VOID_HACK srandom();
extern long random();
#endif

#if defined(__STDC__) || defined(sprite)
#include <assert.h>
#else
#ifndef NDEBUG
#define assert(ex) {\
    if (! (ex)) {\
	(void) fprintf(stderr,\
	    "Assertion failed: file %s, line %d\n\"%s\"\n",\
	    __FILE__, __LINE__, "ex");\
	(void) fflush(stdout);\
	abort();\
    }\
}
#else
#define assert(ex) ;
#endif
#endif


#define fail(why) {\
    (void) fprintf(stderr, "Fatal error: file %s, line %d\n%s\n",\
	__FILE__, __LINE__, why);\
    (void) fflush(stdout);\
    abort();\
}


#ifdef lint
#undef putc			/* correct lint '_flsbuf' bug */
#undef ALLOC			/* allow for lint -h flag */
#undef REALLOC
#define ALLOC(type, num)	(((type *) 0) + (num))
#define REALLOC(type, obj, num)	((obj) + (num))
#endif

#define MAXPATHLEN 1024

/* These arguably do NOT belong in util.h */
#ifndef ABS
#define ABS(a)			((a) < 0 ? -(a) : (a))
#endif
#ifndef MAX
#define MAX(a,b)		((a) > (b) ? (a) : (b))
#endif
#ifndef MIN
#define MIN(a,b)		((a) < (b) ? (a) : (b))
#endif


#ifndef USE_MM
EXTERN void MMout_of_memory ARGS((int));
EXTERN char *MMalloc ARGS((int));
EXTERN char *MMrealloc ARGS((char *, int));
EXTERN void MMfree ARGS((char *));
#endif

EXTERN void util_print_cpu_stats ARGS((FILE *));
EXTERN long util_cpu_time ARGS((void));
EXTERN void util_getopt_reset ARGS((void));
EXTERN int util_getopt ARGS((int, char **, char *));
EXTERN char *util_path_search ARGS((char *));
EXTERN char *util_file_search ARGS((char *, char *, char *));
EXTERN int util_pipefork ARGS((char **, FILE **, FILE **));
EXTERN char *util_print_time ARGS((long));
EXTERN int util_save_image ARGS((char *, char *));
EXTERN char *util_strsav ARGS((char *));
EXTERN int util_do_nothing ARGS((void));
EXTERN char *util_tilde_expand ARGS((char *));

#define ptime()         util_cpu_time()
#define print_time(t)   util_print_time(t)

/* util_getopt() global variables (ack !) */
extern int util_optind;
extern char *util_optarg;

#include <math.h>
#ifndef HUGE_VAL
#ifndef HUGE
#define HUGE  8.9884656743115790e+307
#endif
#define HUGE_VAL HUGE
#endif

#include <varargs.h>
#endif
the array should be sorted (using array_sort) before calling
	arrayvl2mv/include/vlr_int.h                                                                             100644  027004  000214  00000010461 05332024531 012342  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vlr_int.h,v 1.2 1993/01/15 19:46:06 stcheng Exp stcheng $
 *
 * Internal header file for verilog parser
 * STCheng, stcheng@ic.berkeley.edu, 10/92
 */

/* macros */
#define MAXSTRLEN BUFSIZ
#define MAXBITNUM 32
#define ERR_CHK      1
#define ERR_COMPILE  2
#define ERR_INTERNAL 3
#define ERR_ASSERT   4

#define SEP_LBITSELECT "["
#define SEP_RBITSELECT "]"
#define SEP_LTRANGE    "{"
#define SEP_RTRANGE    "}"
#define SEP_LARRAY     "<"
#define SEP_RARRAY     ">"
#define SEP_GATEPIN   ":"
#define SEP_DIR       "$"
#define SEP_LATCH     "|"
#define PIN_LATCH     "lat"
#define PIN_RAWOUT    "raw"
#define PIN_TRUE      "true"
#define PIN_FALSE     "false"
#define PIN_IN        "in"

/* internal intermediate files */
#define SCRATCH_FILE  "gate.blif"
#define SCRIPT_NAME   "script.complement"
#define SIS_LOG       "sis.log"

/* names assumed to be clock signal hence skipped */
#define CLOCK         "clk"

/* deciding if a mux is neede for if/else or case */
#define NO_MUX        0x0
#define MUX_T         0x3    /* 11b */
#define MUX_F         0x2    /* 10b */

/* for verilog.l */
#define MACRO_DEFINE  "define"

/* blif(-mv) stuffs */

/* what is 'GND' in mv? */
/* blif-mv library functions */
#define BLIF_GND         "_BLIF_GND"
#define BLIF_SUP         "_BLIF_SUP"
#define BLIF_LIB_AND     "_BLIF_AND"
#define BLIF_LIB_OR      "_BLIF_OR"
#define BLIF_LIB_XOR     "_BLIF_XOR"
#define BLIF_LIB_XNOR    "_BLIF_XNOR"
#define BLIF_LIB_ADD     "_BLIF_ADD"
#define BLIF_LIB_SUB     "_BLIF_SUB"

/* default library names (index into lib_func[]), I/O format */
#define LIB_MUX      0

/* sorry, I define data in header, though it's not good, it's convenient */
static char *lib_fun[][2] = {
    {".subckt vlr_mux", " %s a=%s b=%s s=%s o=%s\n"}        /*  mux */
    };

#define YYTRACE(str) if (YYTrace) fprintf(stderr, "%s\n", str);
#define CreTRACE(str) if (CreTrace) fprintf(stderr, "  <C>%s", str);
#define PrtTRACE(str) if (PrtTrace) fprintf(stderr, "  <P>%s", str);
#define StpTRACE(str) if (StpTrace) fprintf(stderr, "  <S>%s", str);
#define WrtTRACE(str) if (WrtTrace) fprintf(stderr, "  <W>%s", str);
#define TODO(str) \
  {fprintf(stderr, "not implemented (translation not presice)>>\n%s\n", str); }
#define ASSERT(cond,msg) if (!(cond)) {fprintf(stderr,"ASSERT Fail:%s\n",msg);}
#define Assert(cond)  if (!cond) {fprintf(stderr,"Assert fail: file \"%s\", line %d\n",__FILE__,__LINE__);exit(ERR_ASSERT);}
				      
#define ISVLCONST(type) ((type)==BitExpr||(type)==IntExpr||(type)==RealExpr)
#define ISREDUCTION(type) ((type)==UnandExpr||(type)==UnorExpr|| \
			   (type)==UxnorExpr||(type)==UandExpr|| \
			   (type)==UorExpr||(type)==UxorExpr)

/* externals */
extern char yytext[];
extern int yylineno;
extern vl_descPtr vl_description;
extern vl_modulePtr vl_currentModule;
extern vl_primitivePtr vl_currentPrimitive;

/* prototype */

/* verilog.y */
void yyerror ARGS(char *str);

/* verilog.l */
int yywrap ARGS(());
void skipcommentblock ARGS(());
void binbin ARGS((char *, char *));
void octbin ARGS((char *, char *));
void decbin ARGS((char *, char *));
void hexbin ARGS((char *, char *));
char *utol ARGS((char *));
void memorize_macro ARGS((char *, st_table *));
void expand_macro ARGS((char *, st_table *));

/* util.c */
char *strdup ARGS((char *));
char *strappend ARGS((char*, char*));
char *strappendS ARGS((char*, char*));
char *WRT_BLIF_GND ARGS((FILE *));
char *WRT_BLIF_SUP ARGS((FILE *));
vl_term *true_term ARGS((FILE *));
int ptrcmp ARGS((char *, char *));
int ptrhash ARGS((char *, int));
int declcmp ARGS((char *, char *));
int declhash ARGS((char *, int));
char *strip_char ARGS((char *, char));
FILE *open_file ARGS((char *, char *));
void close_file ARGS((FILE *));
) : 0)
#else
/*
 *  enforce strict semantics on the memory allocator
 *	- when in doubt, delete the '#define USE_MM' above
 */
#define ALLOC(type, num)	\
    ((type *) MMalloc((long) sizeof(type) * (long) (nvl2mv/include/vl_create.h                                                                           100644  027004  000214  00000012033 05332024532 012627  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vl_create.h,v 1.3 1993/01/15 19:44:49 stcheng Exp stcheng $
 */

/* Header file for vl_create.c */

#ifndef VL_CREATE_H
#define VL_CREATE_H


/* external function prototypes */
EXTERN vl_desc *vl_create_desc ARGS((char *));
EXTERN vl_module *vl_create_module ARGS((vl_id_range *,  lsList, lsList));
EXTERN vl_primitive *vl_create_primitive ARGS((vl_id_range*, vl_id_range*, void *, vl_prim_entry *));
EXTERN vl_prim_entry *vl_create_prim_entry ARGS(( ));
EXTERN vl_decl *vl_create_basicdecl ARGS((short, vl_id_range*));
EXTERN vl_rangedecl *vl_create_rangedecl ARGS((short, vl_range *, vl_id_range*));
EXTERN vl_paramdecl *vl_create_paramdecl ARGS((short, lsList));
EXTERN vl_netdecl *vl_create_netdecl ARGS((short, int, vl_range *, vl_delay *, void *));
EXTERN vl_task *vl_create_task ARGS((vl_id_range*, lsList, lsList));
EXTERN vl_function *vl_create_function ARGS((short, vl_range *, vl_id_range*, lsList, lsList));
EXTERN vl_gate_inst_list *vl_create_gate_inst_list ARGS((short, int, vl_delay *, vl_gate_inst *));
EXTERN vl_gate_inst *vl_create_gate_inst ARGS((vl_id_range*, vl_expr *));
EXTERN vl_mod_prim_inst_list *vl_create_prim_inst_list ARGS((vl_id_range*, int, vl_delay *, vl_prim_inst *));
EXTERN vl_mod_prim_inst *vl_create_prim_inst ARGS((vl_id_range*, vl_expr *));
EXTERN vl_procstmt *vl_create_procstmt ARGS((short, vl_stmt *));
EXTERN vl_begin_end_stmt *vl_create_begin_end_stmt ARGS((vl_id_range*, void *, vl_stmt *));
EXTERN vl_if_else_stmt *vl_create_if_else_stmt ARGS((vl_expr *, void *, void *else_));
EXTERN vl_case_stmt *vl_create_case_stmt ARGS((short, vl_expr *, struct vl_case_item *case_));
EXTERN vl_forever_stmt *vl_create_forever_stmt ARGS((void *));
EXTERN vl_repeat_stmt *vl_create_repeat_stmt ARGS((vl_expr *, void *));
EXTERN vl_while_stmt *vl_create_while_stmt ARGS((vl_expr *, void *));
EXTERN vl_for_stmt *vl_create_for_stmt ARGS((vl_bassign_stmt *, vl_expr *, vl_bassign_stmt *, void *));
EXTERN vl_delay_control_stmt *vl_create_delay_control_stmt ARGS((vl_delay *, void *));
EXTERN vl_event_control_stmt *vl_create_event_control_stmt ARGS((vl_event_expr *, void *));
EXTERN vl_cont_assign *vl_create_cont_assign_stmt ARGS((int, vl_delay *, lsList));
EXTERN vl_bassign_stmt *vl_create_bassign_stmt ARGS((short, vl_lval *, void *, vl_expr *));
EXTERN vl_wait_stmt *vl_create_wait_stmt ARGS((vl_expr *, void *));
EXTERN vl_fork_join_stmt *vl_create_fork_join_stmt ARGS((vl_id_range*, void *, void *));
EXTERN vl_task_enable_stmt *vl_create_task_enable_stmt ARGS((short, vl_id_range*, vl_expr *));
EXTERN vl_disable_stmt *vl_create_disable_stmt ARGS((vl_id_range*));
EXTERN vl_deassign_stmt *vl_create_deassign_stmt ARGS((vl_lval *));
EXTERN vl_case_item *vl_create_case_item ARGS((short, vl_expr *, void *));
EXTERN vl_event_expr *vl_create_event_expr ARGS((short, vl_expr *));
EXTERN vl_lval *vl_create_lval ARGS((short, vl_id_range*, vl_range *, vl_expr *));
EXTERN vl_expr *vl_create_expr ARGS((short, int, double, void *, void *, void *));
EXTERN vl_delay *vl_create_delay ARGS((vl_expr *, vl_expr *, vl_expr *));
EXTERN vl_id_range*vl_create_id ARGS((char *));


EXTERN vl_range_or_typePtr vl_create_range_or_type ARGS((short, vl_rangePtr));
EXTERN vl_id_rangePtr vl_create_id_range ARGS((vl_id_range*, vl_range *));
EXTERN vl_rangePtr vl_create_range ARGS((vl_expr *, vl_expr *));
EXTERN vl_port *vl_create_port ARGS((short, vl_id_range*, lsList));
EXTERN vl_port_connect *vl_create_port_connect ARGS((short, vl_id_range*, vl_expr *));
EXTERN vl_send_event_stmt *vl_create_send_event_stmt ARGS((vl_id_range*));
EXTERN typestruct *vl_add_find_mod_prim_instances ARGS((vl_id_range*, vl_delay *, int, lsList));
EXTERN vl_mod_prim_inst_list *vl_create_mod_prim_inst_list ARGS((vl_id_range*, int, vl_delay *, lsList));


EXTERN vl_term *vl_create_term ARGS((vl_id_range*, int, int));


EXTERN blif_latch *create_latch ARGS((vl_id_range*, char*, char*));
EXTERN vl_term *create_rename_term ARGS((vl_id_range*, char*, int, int));
EXTERN syndrome_expr *create_syndrome_expr ARGS((char*, vl_term*));
EXTERN const_term *create_const_term ARGS((vl_expr*, vl_term*));
EXTERN vl_term *new_term ARGS((vl_range*, int, int));

/* copy routines */
EXTERN vl_id_range *vl_copy_id_range ARGS((vl_id_range *));
EXTERN vl_term *vl_copy_term ARGS((vl_term *));
EXTERN var_info *copy_var_info ARGS((var_info*));


/* destroy routines */
EXTERN void vl_free_id ARGS((vl_id_range*));
EXTERN void vl_free_term ARGS((vl_term *));


#endif

IF-MV Translator Distribution
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
 *  Research Laboratory or the Universifvl2mv/include/vl_defs.h                                                                             100644  027004  000214  00000020155 05332024532 012311  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* 
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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vl_defs.h,v 1.3 1993/01/15 19:44:17 stcheng Exp stcheng $
 */

/* constant definitions for Verilog */

/* Cell Types */

/* Last Cell Number is the last constant used in the basic cell types */
#define LastCellNum   	130
#define STCLastCellNum  (LastCellNum+11)

#define None		0
#define CombPrimDecl	1
#define SeqPrimDecl	2
#define ModDecl		3

/* BasicDecl: simple declarations */
#define RealDecl	4
#define IntDecl		5
#define TimeDecl	6
#define EventDecl	7

/* RangeDecl: permit a range */
#define InputDecl	8
#define OutputDecl	9
#define InoutDecl	10
#define RegDecl		11

/* ParamDecl: decl with simple assignments */
#define ParamDecl	12
#define DefparamDecl	13

/* NetDecl: a net with strength, delay, assignment */
#define WireDecl	14
#define TriDecl		15
#define Tri0Decl	16
#define Tri1Decl	17
#define Supply0Decl	18
#define Supply1Decl	19
#define WandDecl	20
#define TriandDecl	21
#define WorDecl		22
#define TriorDecl	23
#define TriregDecl	24

/* Continuous Assignment */
#define ContAssign	25

/* Tasks and Functions */
#define TaskDecl	26
#define IntFuncDecl	27
#define RealFuncDecl	28
#define RangeFuncDecl	29

/* Gate Types */
#define AndGate		30
#define NandGate	31
#define OrGate		32
#define NorGate		33
#define XorGate		34
#define XnorGate	35
#define BufGate		36
#define Bufif0Gate	37
#define Bufif1Gate	38
#define NotGate		39
#define Notif0Gate	40
#define Notif1Gate	41
#define PulldownGate	42
#define PullupGate	43
#define NmosGate	44
#define RnmosGate	45
#define PmosGate	46
#define RpmosGate	47
#define CmosGate	48
#define RcmosGate	49
#define TranGate	50
#define RtranGate	51
#define Tranif0Gate	52
#define Rtranif0Gate	53
#define Tranif1Gate	54
#define Rtranif1Gate	55

#define PrimInst	56
#define ModInst		57

#define AlwaysStmt	58
#define InitialStmt	59

/* Statement Types */
#define BeginEndStmt	60
#define IfElseStmt	61
#define CaseStmt	62
#define CasexStmt	63
#define CasezStmt	64
#define ForeverStmt	65
#define RepeatStmt	66
#define WhileStmt	67
#define ForStmt		68
#define DelayControlStmt	69
#define EventControlStmt	70
#define BassignStmt	71
#define NbassignStmt	72
#define DelayBassignStmt	73
#define DelayNbassignStmt	74
#define EventBassignStmt	75
#define EventNbassignStmt	76
#define WaitStmt	77
#define ForkJoinStmt	78
#define TaskEnableStmt	79
#define SysTaskEnableStmt	80
#define DisableStmt	81
#define AssignStmt	82
#define DeassignStmt	83

#define CaseItem	84
#define DefaultItem	85

/* Event Expression Types */
#define OrEventExpr	86
#define NegedgeEventExpr	87
#define PosedgeEventExpr	88
#define EdgeEventExpr           (LastCellNum+11)
#define EventExpr	89

/* Expressions (also used for Lvalues) */
#define IDExpr		90
#define BitSelExpr	91
#define PartSelExpr	92
#define ConcatExpr	93
#define MinTypMaxExpr	94

#define BitExpr         (LastCellNum+8)
#define IntExpr		95
#define RealExpr	96
#define StringExpr	97
#define FuncExpr	98
#define UplusExpr	99	/* + unary plus */
#define UminusExpr	100	/* - unary minus */
#define UnotExpr	101	/* ! logical unary complement */
#define UcomplExpr	102	/* ~ Bitwise negation (complement) */
/* Unary Reduction Operators */
#define UandExpr	103	/* & unary and reduction */
#define UnandExpr	104	/* ~& unary nand reduction */
#define UorExpr		105	/* | unary or reduction */
#define UnorExpr	106	/* ~| unary nor reduction */
#define UxorExpr	107	/* ^ unary xor reduction  */
#define UxnorExpr	108	/* ~^ or ^~ unary xnor reduction */
/* Binary Operators */
#define BplusExpr	109	/* a+b  plus */
#define BminusExpr	110	/* a-b  minus */
#define BtimesExpr	111	/* a*b  times */
#define BdivExpr	112	/* a/b  division */
#define BremExpr	113	/* a%b  remainder */
#define Beq2Expr	114	/* a==b  equality */
#define Bneq2Expr	115	/* a!=b  inequality */
#define Beq3Expr	116	/* a===b  exact equality */
#define Bneq3Expr	117	/* a!==b  exact inequality */
#define BlandExpr	118	/* a&&b  logical and */
#define BlorExpr	119	/* a||b  logic or */
#define BltExpr		120	/* a<b  less than */
#define BleExpr		121	/* a<=b  less than or equal */
#define BgtExpr		122	/* a>b  greater than */
#define BgeExpr		123	/* a>=b  greater than or equal */
#define BandExpr	124	/* a&b bitwise and */
#define BorExpr		125	/* a|b bitwise or */
#define BxorExpr	126	/* a^b bitwise xor */
#define BxnorExpr	127	/* a^~b or a~^b bitwise xnor */
#define BlshiftExpr	128	/* a<<b left shift */
#define BrshiftExpr	129	/* a>>b right shift */
/* ternary operators */
#define TcondExpr	130	/* e1 ? e2 : e3 conditional*/

/* Primitive Table Types - One of: 
   0 1 X ? B R F P N * - 
or (vw) where v, w are {0, 1, X, B}
*/
#define LastPrimNum 21

#define PrimNone     0
#define Prim0        1
#define Prim1        2
#define PrimX        3
#define PrimQ        4   /* question mark */
#define PrimR        5
#define PrimF        6
#define PrimP        7
#define PrimN        8
#define PrimS        9   /* star '*' */
#define PrimM       10   /* minus '-' */
#define PrimB       18
#define Prim0X      11
#define Prim1X      12
#define PrimX0      13
#define PrimX1      14
#define PrimXB      15   /* (X0) or (X1) */
#define PrimBX      16   /* (0X) or (1X) */
#define PrimBB      17   /* R or F */
#define PrimQ0      19 
#define PrimQ1      20
#define PrimQB      21

/* Strength Types */
/* NOTE: For Drive Strengths both (strong1, strong0) and (strong0, strong1)
   are permitted but they are equal in function.  The order is preserved
   in the definitions below only for pretty printing the input for
   the user */
/* Drive Strengths */
#define Supply0Supply1  3
#define Supply0Strong1  4
#define Supply0Pull1    5
#define Supply0Weak1    6
#define Supply0HighZ1   7
#define Strong0Supply1  8
#define Strong0Strong1  9
#define Strong0Pull1   10
#define Strong0Weak1   11
#define Strong0HighZ1  12
#define Pull0Supply1   13
#define Pull0Strong1   14
#define Pull0Pull1     15
#define Pull0Weak1     16
#define Pull0HighZ1    17
#define Weak0Supply1   18
#define Weak0Strong1   19
#define Weak0Pull1     20
#define Weak0Weak1     21
#define Weak0HighZ1    22
#define HighZ0Supply1  23
#define HighZ0Strong1  24
#define HighZ0Pull1    25
#define HighZ0Weak1    26
#define HighZ0HighZ1   27
#define Supply1Supply0 28
#define Supply1Strong0 29
#define Supply1Pull0   30
#define Supply1Weak0   31
#define Supply1HighZ0  32
#define Strong1Supply0 33
#define Strong1Strong0 34
#define Strong1Pull0   35
#define Strong1Weak0   36
#define Strong1HighZ0  37
#define Pull1Supply0   38
#define Pull1Strong0   39
#define Pull1Pull0     40
#define Pull1Weak0     41
#define Pull1HighZ0    42
#define Weak1Supply0   43
#define Weak1Strong0   44
#define Weak1Pull0     45
#define Weak1Weak0     46
#define Weak1HighZ0    47
#define HighZ1Supply0  48
#define HighZ1Strong0  49
#define HighZ1Pull0    50
#define HighZ1Weak0    51
#define HighZ1HighZ0   52
/* Capacitive Strengths */
#define Small          53
#define Medium         54
#define Large          55

/* 
 * STCheng
 *
 * Auxialiary constants for parsing stack
 */

#define Range_Dcl     (LastCellNum+1)
#define Integer_Dcl   (LastCellNum+2)
#define Real_Dcl      (LastCellNum+3)
#define MOST_SB       (1>>31)
#define LEAST_SB      1

#define ModulePort    (LastCellNum+4)
#define NamedPort     (LastCellNum+5)
#define ModuleConnect (LastCellNum+6)
#define NamedConnect  (LastCellNum+7)

/*
 * Missing stmt type
 */
#define SendEventStmt (LastCellNum+9)

/* Stuffs to handle multiple value logic */
#define SWireDecl     (LastCellNum+10)

/* flags */
#define MVar          (1)
#define InPort        (1<<1)
#define OutPort       (1<<2)
#define RegVar        (1<<3)
#define AlwaysTouched (1<<4)
#define WithInitial   (1<<5)
e_send_event_stmt ARGS((vl_id_range*));
EXTERN typestruct *vl_add_find_mod_prim_instances ARGS((vl_id_range*, vl_delay *, int, lsList));
EXTERN vl_mod_prim_inst_list *vl_create_mod_prim_inst_list ARGS((vl_id_range*, int, vl_delay *, lsList));


EXTERN vl_term *vl_create_term ARGS((vl_id_range*, int, int));


EXTERN blif_latch *create_latch ARGS((vl_id_range*, char*, char*));
EXTERN vl_term *create_revl2mv/include/vl_traverse.h                                                                         100644  027004  000214  00000011321 05332024534 013220  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
   $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vl_traverse.h,v 1.1 1993/01/15 19:45:04 stcheng Exp stcheng $
 
   vl_print.h: Heade file for print routines
   GY  10/92
   Changed to vl_traverse.h: Heads for traversing routines
   STCheng, stcheng@ic.berkeley.edu
 
*/

#ifndef VL_PRINT_H
#define VL_PRINT_H

/* external function prototypes */

EXTERN void vl_step_module ARGS((FILE *, vl_module *));
EXTERN void vl_step_primitive ARGS((FILE *, vl_primitive *));
EXTERN void vl_step_prim_table ARGS((FILE *, short, lsList));
EXTERN void vl_step_basicdecl ARGS((FILE *, vl_decl *));
EXTERN void vl_step_arr_decl ARGS((FILE *, vl_decl *));
EXTERN void vl_step_rangedecl ARGS((FILE *, vl_rangedecl *));
EXTERN void vl_step_paramdecl ARGS((FILE *, vl_paramdecl *));
EXTERN void vl_step_netdecl ARGS((FILE *, vl_netdecl *));
EXTERN void vl_step_task ARGS((FILE *, vl_task *));
EXTERN void vl_step_function ARGS((FILE *, vl_function *));
EXTERN void vl_step_gate_inst_list ARGS((FILE *, vl_gate_inst_list *));
EXTERN void vl_step_gates ARGS((FILE *, lsList));
EXTERN void vl_step_prim_inst_list ARGS((FILE *, vl_prim_inst_list *));
EXTERN void vl_step_prims ARGS((FILE *, lsList));
EXTERN void vl_step_mod_inst_list ARGS((FILE *, vl_mod_inst_list *));
EXTERN void vl_step_mod_insts ARGS((FILE *, lsList));
EXTERN void vl_step_procstmt ARGS((FILE *, vl_procstmt *));
EXTERN void vl_step_begin_end_stmt ARGS((FILE *, vl_begin_end_stmt *));
EXTERN void vl_step_if_else_stmt ARGS((FILE *, vl_if_else_stmt *));
EXTERN void vl_step_case_stmt ARGS((FILE *, vl_case_stmt *));
EXTERN void vl_step_forever_stmt ARGS((FILE *, vl_forever_stmt *));
EXTERN void vl_step_repeat_stmt ARGS((FILE *, vl_repeat_stmt *));
EXTERN void vl_step_while_stmt ARGS((FILE *, vl_while_stmt *));
EXTERN void vl_step_for_stmt ARGS((FILE *, vl_for_stmt *));
EXTERN void vl_step_delay_control_stmt ARGS((FILE *, vl_delay_control_stmt *));
EXTERN void vl_step_event_control_stmt ARGS((FILE *, vl_event_control_stmt *));
EXTERN void vl_step_bassign_stmt ARGS((FILE *, vl_bassign_stmt *));
EXTERN void vl_step_wait_stmt ARGS((FILE *, vl_wait_stmt *));
EXTERN void vl_step_fork_join_stmt ARGS((FILE *, vl_fork_join_stmt *));
EXTERN void vl_step_task_enable_stmt ARGS((FILE *, vl_task_enable_stmt *));
EXTERN void vl_step_disable_stmt ARGS((FILE *, vl_disable_stmt *));
EXTERN void vl_step_deassign_stmt ARGS((FILE *, vl_deassign_stmt *));
EXTERN void vl_step_case_item ARGS((FILE *, vl_case_item *));
EXTERN void vl_step_event_expr ARGS((FILE *, vl_event_expr *));
EXTERN void vl_step_lval ARGS((FILE *, vl_lval *));
EXTERN void vl_step_expr ARGS((FILE *, vl_expr *));
EXTERN void vl_step_expr_list ARGS((FILE *, vl_expr *));
EXTERN void vl_step_range ARGS((FILE *, vl_range *));
EXTERN void vl_step_delay ARGS((FILE *, vl_delay *));
EXTERN void vl_step_id_list ARGS((FILE *, lsList));
EXTERN void vl_step_id_range_list ARGS((FILE *, lsList));
EXTERN void vl_step_net_list ARGS((FILE *, lsList));
EXTERN void vl_step_net ARGS((FILE *, void *));
EXTERN char *vl_get_prim_symbol ARGS((unsigned char));
EXTERN char *vl_get_strength ARGS((int));
EXTERN char *vl_get_expr_op ARGS((int));

EXTERN void vl_step_ports ARGS((FILE *, vl_expr *));
EXTERN void vl_step_mod_item_list ARGS((FILE *, void *));
EXTERN void vl_step_mod_item ARGS((FILE *, void *));
EXTERN void vl_step_decl_list ARGS((FILE *, void *));
EXTERN void vl_step_stmt_list ARGS((FILE *, void *));
EXTERN void vl_step_strength ARGS((FILE *, int));
EXTERN void vl_step_gate ARGS((FILE *, vl_gate_inst *));
EXTERN void vl_step_prim ARGS((FILE *, vl_prim_inst *));    
EXTERN void vl_step_param_vals ARGS((FILE *, vl_expr *));
EXTERN void vl_step_modinst ARGS((FILE *, vl_mod_inst *));    
EXTERN void vl_step_stmt ARGS((FILE *, void *));
EXTERN void vl_step_decl ARGS((FILE *, void *));
EXTERN void vl_step_cont_assign ARGS((FILE *, vl_cont_assign *));

EXTERN enum st_retval vl_step_desc ARGS((char *, char *, char *));
EXTERN void vl_step_port ARGS((FILE *, vl_port *));
EXTERN void vl_step_connects ARGS((FILE *, lsList));
EXTERN void vl_step_port_connect ARGS((FILE *, vl_port_connectPtr));
EXTERN void vl_step_id_range ARGS((FILE *, vl_id_range));
#endif 
ors */
#define UandExpr	103	/* & unary and reduction */
#define UnandExpr	104	/* ~& unary nand reduction */
#define UorExpr		105	/* | unary or reduction */
#define UnorExpr	106	/* ~| unary nor reduction */
#define UxorExpr	107	/* ^ unary xor reduction  */
#define UxnorExpr	108	/* ~^ or ^~ unary xnor revl2mv/include/vl_types.h                                                                            100644  027004  000214  00000050535 05332024535 012544  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /* 
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
   $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vl_types.h,v 1.3 1993/01/15 19:45:30 stcheng Exp stcheng $

   Type Definitions for the Verilog2Blif-MV parser 
   GY 9/92 
   Loosely following the syntax definition in [Thomas and Moorby], 
   Appendix F.1
*/

#define MAXINLEN 10            /* max input variale length in table */

/* Description contains multiple modules from a single file */
typedef struct vl_desc {
    char *filename;
    lsList modules;		/* list of module or primitive */
    st_table *mp_st;		/* module/primitive sym table */
    lsHandle handle;	        /* for another Verilog file */
    st_table *decl_st;          /* table of delcared *void decl */
                                /* reserved to handle multiple  */
                                /* value libraries              */
} vl_desc, *vl_descPtr;


/* Module definition */
typedef struct vl_module {
    short type;			/* module */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* module name */
    lsList ports;	        /* list of port vl_id's */
    st_table *sig_st;		/* signals declared in the module */
    st_table *inst_st;          /* instances used in the module */
    st_table *latch_st;         /* signals holding states */
    lsList mod_items;		/* declaration, instantiation, 
				   cont_assignment, initial, always, 
				   task or function */
    struct vl_id_range *clk;    /* clking signal used in this module */
    int syndrome_width;         /* width of control syndrome */
    lsHandle handle;
} vl_module, *vl_modulePtr;

/* Sequential or Combinational Primitive Definition */
typedef struct vl_primitive {
    short type;			/* seq_primitive or comb_primitive */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* primitive name */
    lsList ports;	        /* list of port vl_id's */
    lsList decls;		/* list of primitive declarations */
    st_table *sig_st;		/* signals declared in the primitive */
    lsList entries;             /* list of table entries */
    lsHandle handle;            /* next module or primitive */
} vl_primitive, *vl_primitivePtr;

/* Port Definition */
typedef struct vl_port {
    short type;                 /* ModulePort or NamedPort */
    lsList port_exp;            /* for ModulePort  and NamedPort */
                                /* list of vl_id_range */
    struct vl_id_range *id;     /* NamedPort only */
} vl_port, *vl_portPtr;

/* Port Connection Definition */
typedef struct vl_port_connect {
    short type;                 /* ModuleConnect or NamedConnect */
    struct vl_expr *expr;       /* for ModuleConnect and NamedConnect */
    struct vl_id_range *id;     /* NamedConnect only */
} vl_port_connect, *vl_port_connectPtr;

/* Primitive Table Entries: a primitive can have only MAXINLEN inputs */
typedef struct vl_prim_entry {
    unsigned char inputs[MAXINLEN];	/* input list */
    unsigned char state;	/* state or output type */
    unsigned char next_state;	/* next_state or empty type */
    struct vl_prim_entry *next;	/* next table entry */
} vl_prim_entry, *vl_prim_entryPtr;

/* BasicDecl: RealDecl, IntDecl, TimeDecl, EventDecl */
typedef struct vl_decl {
    short type;			/* one of BasicDecl */
    short unsigned flags;	/*  */
    lsList ids;	   	        /* list of declared vl_id_range ids */
                                /* for RealDecl | EventDecl, only id is used */
                                /* for IntDecl | TimeDecl, id_range is used */
    lsHandle handle;		/* next mod_item */
} vl_decl, *vl_declPtr;

/* RangeDecl: input, output, inout, or reg declaration */
typedef struct vl_rangedecl {
    short type;			/* InputDecl OutputDecl InoutDecl RegDecl */
    short unsigned flags;	/*  */
    struct vl_range *range;	/* range expression */
    lsList ids;                 /* list of declared vl_id_range ids */
    lsHandle handle;		/* next mod_item */
} vl_rangedecl, *vl_rangedeclPtr;

/* parameter  or defparam declaration */
typedef struct vl_paramdecl {
    short type;			/* param_decl, defparam_decl */
    short unsigned flags;	/*  */
    lsList assigns;             /* list of vl_bassign_stmt */
    lsHandle handle;		/* next mod_item */
} vl_paramdecl, *vl_paramdeclPtr;

/* net declaration: type is one of NETDECL:
   NETDECL: WireDecl TriDecl Tri0Decl Tri1Decl Supply0Decl Supply1Decl
            WandDecl TriandDecl WorDecl TriorDecl TriregDecl
*/
typedef struct vl_netdecl {
    short type;			/* one of NETDECL */
    short unsigned flags;	/*  */
    int strength;		/* charge or drive strength expression */
                                /* in case of drive strength, 0, 1 strength */
                                /* is encoded */
    struct vl_range *range;	/* expanded range expression */
    struct vl_delay *delay;	/* delay expression */
    lsList ids;			/* list of identifiers (vl_id_range) */
				/* or can be list of assignments */
                                /* (vl_bassign_stmt) */
    lsHandle handle;		/* next mod_item */
} vl_netdecl, *vl_netdeclPtr;

/* Continous Assignment */
typedef struct vl_cont_assign {
    short type;			/* ContAssign */
    short unsigned flags;	/*  */
    int strength;		/* drive strength expression */
    struct vl_delay *delay;	/* delay expression */
    void *assigns;		/* list of vl_bassign assignments */
} vl_cont_assign, *vl_cont_assignPtr;

/* Task Declaration */
typedef struct vl_task {
    short type;			/* TaskDecl */
    short unsigned flags;	/*  */
    struct vl_id_range *name;
    lsList decls;		/* list of task declarations */
    st_table *sig_st;           /* signals declared in this task */
    lsList stmts;		/* list of statements (or null) */
    lsHandle handle;		/* next module item */
} vl_task, *vl_taskPtr;


/* Function Declaration */
typedef struct vl_function {
    short type;			/* FuncDecl: integer, real, or range */
    short unsigned flags;	/*  */
    struct vl_range *range;	/* if range type, then used else null */
    struct vl_id_range *name;
    lsList decls;		/* list of function declarations */
    st_table *sig_st;           /* signals declared in the function */
    lsList stmts;		/* list of statements (or null) */
    lsHandle handle;		/* next module item */
} vl_function, *vl_functionPtr;

/* Specify Block */
/* not yet defined */

/* Gate Instantiation */
/* GATETYPE is one of: AndGate NandGate OrGate NorGate XorGate XnorGate
                       BufGate Bufif0Gate Bufif1Gate NotGate Notif0Gate
		       Notif1Gate PulldownGate PullupGate NmosGate RnmosGate
		       PmosGate RpmosGate CmosGate RcmosGate TranGate
		       RtranGate Tranif0Gate Rtranif0Gate Tranif1Gate
		       Rtranif1Gate
*/
typedef struct vl_gate_inst_list {
    short type;			/* one of GATETYPE */
    short unsigned flags;	/*  */
    int strength;		/* a drive strength */
    struct vl_delay *delays;	/* list of delays */
    struct vl_gate_inst *gates;	/* list of gates */
    lsHandle handle;		/* next module item */
} vl_gate_inst_list, *vl_gate_inst_listPtr;

/* Gate Instance */
typedef struct vl_gate_inst {
    struct vl_id_range *name;	/* null or the gate name */
    lsList terms;               /* list of terminal expressions vl_expr */
    lsHandle handle;	        /* next in list of gate instances */
} vl_gate_inst, *vl_gate_instPtr;

/* Module/Primitive Instantiation (list of module/primitive instances) */
typedef struct vl_mod_prim_inst_list {
    short type;			/* ModInst/PrimInst */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* name of module/primitive */
    lsList mps;	                /* list of vl_mod_prim_instPtr */
    lsHandle handle;		/* next module item */
    int strength;		/* a drive strength */
    struct vl_delay *delays;	/* parameter variable assignment list vl_expr*/
                                /* or list of delays */
} vl_mod_prim_inst_list, *vl_mod_prim_inst_listPtr;

/* Module/Primitive Instance */
typedef struct vl_mod_prim_inst {
    struct vl_id_range *name;	/* instance name or null (for primi_inst) */
    lsList *ports;	        /* port connections vl_expr */
                                /* terminal connection for mod_inst */
				/* NOTE: NO named port connections */
				/* any port connection can be NULL */
    void *master;               /* master module/primitive */
    lsHandle handle;	        /* next in list of module instances */
} vl_mod_prim_inst, vl_mod_prim_instPtr;

/* Process Statements: always and initial */
typedef struct vl_procstmt {
    short type;			/* InitialStmt or AlwaysStmt */
    short flags;
    void *stmt;			/* contains 1 statement */
    lsHandle handle;			/* next mod_item */
} vl_procstmt, *vl_procstmtPtr;

/* Statement Types are one of: BeginEndStmt IfElseStmt CaseStmt CasexStmt
         CasezStmt ForeverStmt RepeatStmt WhileStmt ForStmt DelayControlStmt
	 EventControlStmt BassignStmt NbassignStmt WaitStmt ForkJoinStmt
	 TaskEnableStmt SysTaskEnableStmt DisableStmt AssignStmt DeassignStmt
*/

/* Begin End Block */
typedef struct vl_begin_end_stmt {
    short type;			/* BeginEndStmt */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* optional name of block */
    void *decls;		/* optional declarations (only if named) */
    st_table *sig_st;           /* signal table */
    void *stmts;		/* statement list */
    lsHandle handle;            /* next statement in list */
} vl_begin_end_stmt, *vl_begin_end_stmtPtr;

/* If Else statement */
typedef struct vl_if_else_stmt {
    short type;			/* IfElseStmt */
    short unsigned flags;	/*  */
    struct vl_expr *cond;	/* condition */
    void *if_stmt;		/* if condition is true */
    void *else_stmt;		/* if condition is false */
    lsHandle handle;		/* next statement in list */
} vl_if_else_stmt;

/* CaseStmt, CasexStmt, or CasezStmt */
typedef struct vl_case_stmt {
    short type;			/* CaseStmt, CasexStmt, or CasezStmt */
    short unsigned flags;	/*  */
    struct vl_expr *cond;	/* condition */
    lsList case_items;          /* list of vl_case_item */
    lsHandle handle;		/* next statement in list */
} vl_case_stmt;

/* ForeverStmt */
typedef struct vl_forever_stmt {
    short type;			/* ForeverStmt */
    short unsigned flags;	/*  */
    void *stmt;			/* statement to execute forever */
    lsHandle handle;            /* next statement in list */
} vl_forever_stmt;

/* RepeatStmt */
typedef struct vl_repeat_stmt {
    short type;			/* RepeatStmt */
    short unsigned flags;	/*  */
    struct vl_expr *count;	/* # times to repeat loop */
    void *stmt;			/* statement to repeat */
    lsHandle handle;            /* next statement in list */
} vl_repeat_stmt;

/* WhileStmt */
typedef struct vl_while_stmt {
    short type;			/* WhileStmt */
    short unsigned flags;	/*  */
    struct vl_expr *cond;	/* condition */
    void *stmt;			/* statement to repeat */
    lsHandle handle;            /* next statement in list */
} vl_while_stmt;

/* ForStmt */
typedef struct vl_for_stmt {
    short type;			/* ForStmt */
    short unsigned flags;	/*  */
    struct vl_bassign_stmt *init;  /* initial assignment */
    struct vl_expr *cond;	/* loop expression */
    struct vl_bassign_stmt *end;	/* end of loop assignment */
    void *stmt;			/* statement to repeat */
    lsHandle handle;            /* next statement in list */
} vl_for_stmt;

/* DelayControlStmt */
/* e.g.   #delay stmt */
typedef struct vl_delay_control_stmt {
    short type;			/* DelayControlStmt */
    short unsigned flags;	/*  */
    struct vl_delay *delay;	/* can have only one delay expr */
    void *stmt;                 /* statement to execute after delay */
    lsHandle handle;		/* next statement in list */
				/* NULL or statement to execute after delay */
} vl_delay_control_stmt;

/* EventControlStmt */
/* e.g.   @event stmt*/
typedef struct vl_event_control_stmt {
    short type;			/* EventControlStmt */
    short unsigned flags;	/*  */
    struct vl_event_expr *event; /* controlling event */
    void *stmt;                 /* statement to execute after event */
    lsHandle handle;		/* next statement in list */
			        /* NULL or statement to execute after event */
} vl_event_control_stmt;

/*  AssignStmt, (assignment in seq-block) */
/*  BassignStmt, or NbassignStmt (non-blocking assign) */
/*  DelayBassignStmt DelayNbassignStmt    e.g.  a = #d b; */
/*  EventBassignStmt EventNbassignStmt    e.g.  a = @e b; */
typedef struct vl_bassign_stmt {
    short type;			/*  AssignStmt, BassignStmt, or NbassignStmt */
				/*  DelayBassignStmt DelayNbassignStmt */
				/*  EventBassignStmt EventNbassignStmt */
    short unsigned flags;	/*  */
    struct vl_lval *lhs;
    void *control;		/* event or delay control */
    struct vl_expr *rhs;	/* expression to assign */
    lsHandle handle;		/* next statement in list */
} vl_bassign_stmt, *vl_bassign_stmtPtr;

/* WaitStmt */
typedef struct vl_wait_stmt {
    short type;			/* WaitStmt */
    short unsigned flags;	/*  */
    struct vl_expr *cond;	/* condition to wait for */
    void *stmt;                 /* statement to execute after wait */
    lsHandle handle;		/* next statement in list */
				/* statement to execute after wait */
} vl_wait_stmt;

/* -> event */
typedef struct vl_send_event_stmt {
    short type;                 /* SendEventStmt */
    struct vl_id_range *name;   /* event name */
} vl_send_event_stmt, vl_send_event_stmtPtr;

/* ForkJoinStmt */
typedef struct vl_fork_join_stmt {
    short type;			/* ForkJoinStmt */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* optional name of block */
    lsList decls;		/* optional declaration list (only if named) */
    st_table *sig_st;           /* signal declared in this par_block */
    lsList stmts;		/* concurrent statement list */
    lsHandle handle;		/* next statement in list */
} vl_fork_join_stmt, *vl_fork_join_stmtPtr;

/* TaskEnableStmt or SysTaskEnableStmt */
typedef struct vl_task_enable_stmt {
    short type;			/* TaskEnableStmt or SysTaskEnableStmt */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* name of task to execute */
				/* or system task name */
    lsList args;	        /* list of task arguments vl_expr */
    lsHandle handle;		/* next statement in list */
} vl_task_enable_stmt, *vl_task_enable_stmtPtr;

/* DisableStmt */
typedef struct vl_disable_stmt {
    short type;			/* DisableStmt */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* name of task or block to disable */
    lsHandle handle;		/* next statement in list */
} vl_disable_stmt;

/* DeassignStmt */
typedef struct vl_deassign_stmt {
    short type;			/* DeassignStmt */
    short unsigned flags;	/*  */
    struct vl_lval *lhs;	/* the LHS to deassign */
    lsHandle handle;		/* next statement in list */
} vl_deassign_stmt;


/* CaseItem or DefaultItem */
typedef struct vl_case_item {
    short type;			/* CaseItem or DefaultItem */
    short unsigned flags;	/*  */
    lsList exprs;       /* expresison list vl_expr */
    void *stmt;
    lsHandle handle;	/* next case item (or NULL) */
} vl_case_item, *vl_case_itemPtr;

/* event expression: OrEventExpr NegedgeEventExpr PosedgeEventExpr 
                     EventExpr */
typedef struct vl_event_expr {
    short type;		
    short unsigned flags;	/*  */
    struct vl_expr *expr;       /* event expression */
    lsList list;	        /* list of ORed vl_event_exprs */
} vl_event_expr, *vl_event_exprPtr;


/* Expressions (section F.7) */
typedef struct vl_lval {
    short type;			/* ID bit_select part_select concat */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* NULL or identifier */
    struct vl_range *range;	/* NULL or ptr to range */
    lsList concat;	        /* NULL or concatentation (list of vl_expr) */
} vl_lval, *vl_lvalPtr;

/* Expressions: Many types including:
General:          IDExpr BitSelExpr PartSelExpr ConcatExpr MinTypMaxExpr
                  IntExpr RealExpr StringExpr FuncExpr
Unary Operators:  UplusExpr UminusExpr UnotExpr UcomplExpr UandExpr UnandExpr
                  UorExpr UnorExpr UxorExpr UxnorExpr
Binary Operators: BplusExpr BminusExpr BtimesExpr BdivExpr BremExpr Beq2Expr
                  Bneq2Expr Beq3Expr Bneq3Expr BlandExpr BlorExpr BltExpr
		  BleExpr BgtExpr BgeExpr BandExpr BorExpr BxorExpr BxnorExpr
		  BlshiftExpr BrshiftExpr
Ternary Operators: TcondExpr
*/
typedef struct vl_expr {
    short type;			/* one of the above types */
    short unsigned flags;	/*  */
    union {
	int intval;		/* IntExpr */
	double realval;		/* RealExpr */
	struct vl_id_range *name;    /* IDExpr */
	char *string;		/* StringExpr (enclosed in " on 1 line) */
	struct vl_id_range *idrng;   /* BitSelExpr or PartSelExpr range */
	struct func_call {
	    struct vl_id_range *name;	/* name or function or  */
	                                /* system function call */
	    lsList args;    /* arguments to function call (list of vl_expr) */
        } func_call;
	struct bexpr {
	    unsigned int part1;
	    unsigned int part0;
	} bexpr;
	struct exprs {		/* for unary, binary and ternary
				   use only ptrs required, others NULL  */
	    struct vl_expr *e1;
	    struct vl_expr *e2;
	    struct vl_expr *e3;
        } exprs;
    } u;
    struct vl_term *term;       /* output terminal of any sub-exp */
} vl_expr, *vl_exprPtr;

/* a range expression of the fornm [l:r] */
typedef struct vl_range {
    struct vl_expr *left;	/* constant expression */
    struct vl_expr *right;
} vl_range, *vl_rangePtr;

/* a delay expression */
typedef struct vl_delay {
    vl_expr *delay1;		/* rise mintypmax expression */
    vl_expr *delay2;		/* fall mintypmax expression */
    vl_expr *delay3;		/* toZ mintypmax expression */
} vl_delay, *vl_delayPtr;

/* for memories like: reg [7:0] mem[31:0];
   Holds the mem[31:0] part
*/
typedef struct vl_id_range {
    char * name;
    short flags;                /* MVar */
    struct vl_range *range;	/* for mem[a:b] */
    struct vl_term *initial;    /* reset terminal */
    lsList syndrome_expr_list;  /* syndrome_expr list */
    void * mpg_master_exp;      /* module/primitive/gate instantiation */
                                /* expression */
                                /* or declaration expression when id is */
                                /* a declared signal */
                                /* if there are multiple declaration, then */
                                /* point to the first declaring expression */
} vl_id_range, *vl_id_rangePtr;

/* dummy struct for extracting type field */
typedef struct typestruct {
    short type;
} typestruct, *typestructPtr;

/*
 * STCheng
 *
 * Auxialiary types for semantic stacks
 */
typedef struct vl_range_or_type {
    short  type;               /* Range_Dcl, Integer_Dcl, Real_Dcl */
    vl_range *range;           /* for Range_Dcl type */
} vl_range_or_type, *vl_range_or_typePtr;

typedef struct vl_term {
    vl_id_range *name;
    unsigned short flag;       /* MVar */
    int hi, lo;                /* if term is a binary variable   */
                               /*   lo > hi : scalar; o/w vector */
                               /* else                           */
			       /*   if (hi>0) MVar can resum [lo:hi] */
                               /*   else MVar range not determined   */
} vl_term, *vl_termPtr;

typedef struct blif_latch {
    vl_id_range *name;          /* id this latch is associated with */
    vl_term *inport, *outport;  /* i/o terminal */
} blif_latch, *blif_latchPtr;

typedef struct var_info {
    vl_id_range *id;            /* a copy of declaration for var  */
    vl_term *current_terminal;  /* current output name generated  */
                                /* for a certain var by set of stmts */
    lsList cond_list;           /* vl_term* of selecting logic that  */
                                /* wants to touch the var            */
                                /* NILL means it is always touched   */
                                /* empty-list means it is not touched*/
} var_info, *var_infoPtr;

typedef struct syndrome_expr {
    char *syndrome;
    vl_term *expr;
} syndrome_expr, *syndrome_exprPtr;

typedef struct const_term {
    vl_expr *const_expr;
    vl_term *term;
} const_term, *const_termPtr;
     /* list of vl_case_item */
    lsHandle handle;		/* next statement in list */
} vl_case_stmt;

/* ForeverStmt */
typedef struct vl_forever_stmt {
    short tyvl2mv/include/vl_write.h                                                                            100644  027004  000214  00000011137 05332024536 012526  0                                                                                                    37777777777                                                                               1  0                                                                                                                                                                 /*
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
 *  by
 *
 *  STCheng: stcheng@ic.berkeley.edu
 */
EXTERN enum st_retval vl_write_desc ARGS((char *, char *, char *));
EXTERN void vl_write_module ARGS((FILE *, vl_module *));
EXTERN void vl_write_mod_item_list ARGS((FILE *, lsList));
EXTERN st_table *vl_write_mod_item ARGS((FILE *, void *, st_table *));
EXTERN void vl_write_expr ARGS ((FILE *, vl_expr *));
EXTERN void vl_write_expr_list ARGS((FILE *, lsList, st_table *));
EXTERN void vl_write_procstmt ARGS((FILE*, vl_procstmt*, st_table*));
EXTERN st_table *vl_write_begin_end_stmt ARGS((FILE*, vl_begin_end_stmt*, int, vl_term*, st_table*));
EXTERN st_table *vl_write_if_else_stmt ARGS((FILE *, vl_if_else_stmt *, st_table *));
EXTERN st_table *vl_write_case_stmt ARGS((FILE *, vl_case_stmt *, st_table *));
EXTERN st_table *vl_write_event_control_stmt ARGS((FILE*, vl_event_control_stmt*, st_table*));
EXTERN void vl_write_cont_assign ARGS((FILE *, vl_cont_assign *));
EXTERN vl_term *vl_write_assign ARGS((FILE *, vl_bassign_stmt *));
EXTERN st_table *vl_write_stmt ARGS((FILE *, void *, int, vl_term *, st_table *));
EXTERN st_table *vl_write_decl_list ARGS((FILE*, void*, int, vl_term*, st_table*));
EXTERN st_table *vl_write_stmt_list ARGS((FILE*, void*, int, vl_term*, st_table*));
EXTERN char *new_termname ARGS(());
EXTERN char *vl_write_vector_bop ARGS((FILE *, short, vl_term *, vl_term *, vl_term *));
EXTERN char *vl_write_bop ARGS((FILE *, short, char *, char *, char *, char *, int));
EXTERN void vl_write_bit_connect ARGS((FILE *, char *, char *, int));
EXTERN void vl_mv_to_bin ARGS((vl_term *));
EXTERN void vl_bin_to_mv ARGS((vl_term *));
EXTERN void vl_write_mv_comp ARGS((FILE *, short, vl_term *, vl_term *, vl_term *));
EXTERN void vl_write_bin_comp ARGS((FILE *, short, vl_term *, vl_term *, vl_term *));
EXTERN void write_int_connect ARGS((FILE*, int, vl_term*));
EXTERN void vl_write_mv_connect ARGS((FILE *, vl_term *, vl_term *));
EXTERN void vl_write_bin_connect ARGS((FILE *, vl_term *, vl_term *));
EXTERN void vl_write_const ARGS((FILE *, vl_lval *, vl_expr *));
EXTERN vl_term *write_case_comparator ARGS((FILE*, vl_term*, lsList));
EXTERN void write_comparator ARGS((FILE*, vl_term*, vl_term*, vl_term*));
EXTERN int vl_eval_epxr ARGS((vl_expr *));
EXTERN vl_range *get_decl_range ARGS((void *));
EXTERN vl_expr *get_decl_range_left ARGS((void *));
EXTERN vl_expr *get_decl_range_right ARGS((void *));
EXTERN short get_decl_flags ARGS((void *));
EXTERN void get_hilo ARGS((vl_id_range *, int *, int *));
EXTERN void instantiate_mux ARGS((FILE *, vl_erm *, vl_term *, vl_term *, vl_term *));
EXTERN void instantiate_bmux ARGS((FILE *, vl_term*, vl_term*, vl_term*, vl_term*));
EXTERN void instantiate_smux ARGS((FILE *, vl_term*, vl_term*, vl_term*, vl_term*));
EXTERN void vl_put_lib ARGS(());
EXTERN st_table *create_var_muxes ARGS((FILE*, st_table*, st_table*, st_table*));
EXTERN void instantiate_latch ARGS((FILE*, st_table*));
EXTERN void vl_write_mv_lib ARGS((FILE*, short, vl_term*, vl_term*, vl_term*));
EXTERN void insert_control_list ARGS((var_info*, vl_term*));
EXTERN st_table *conflict_arbitrator ARGS((FILE*, array_t*));
EXTERN vl_term *write_multi_in_or ARGS((lsList));
EXTERN void print_control_var_pari ARGS((FILE *, char *, char *));
EXTERN void print_control_var_pair ARGS((FILE *, char *, char *));
EXTERN void vl_write_reset ARGS((FILE *, vl_procstmt *));
EXTERN void vl_write_reset_stmt ARGS((FILE *, void *));
EXTERN vl_term *write_local_control ARGS((FILE*, vl_term*, lsList, int));
EXTERN void vl_write_io_list ARGS((FILE *));
EXTERN void vl_write_mod_inst_list ARGS((FILE *, vl_module *, vl_mod_prim_inst *));
EXTERN void vl_write_mod_inst ARGS((FILE *, vl_module *, vl_mod_prim_inst *));
EXTERN void vl_write_consts ARGS((FILE *));
EXTERN void vl_write_svar ARGS((FILE *));
EXTERN void write_mvar_decl ARGS((FILE *, vl_term *));
EXTERN void vl_dump_libs ARGS((FILE *, st_table *));
EXTERN vl_term *syndrome_to_control ARGS((FILE*, char*, st_table*));
EXTERN lsList get_transition ARGS((FILE *));
EXTERN lsList put_guard_zero ARGS((FILE *, lsList));
*/
} vl_event_expr, *vl_event_exprPtr;


/* Expressions (section F.7) */
typedef struct vl_lval {
    short type;			/* ID bit_select part_select concat */
    short unsigned flags;	/*  */
    struct vl_id_range *name;	/* NULL or identifier */
    struct vl_range *range;	/* NULL or ptr to range */
    lsList concat;	        /* NULL or concatentation (list of vl_expr) */
} vl_lval, *vl_lvalPtr;

/* Expressions: Manyvl2mv/lib/                                                                                          040755  027004  000214  00000000000 05402724330 007031  5                                                                                                         0                                                                                    1  0                                                                                                                                                                 vl2mv/makefile                                                                                      100644  027004  000214  00000001212 05332025511 007751  0                                                                                                         0                                                                                    1  0                                                                                                                                                                 #
# $Header$
#
# commands 
CD   = cd
ECHO = echo
MAKE = make

# sources 
PSR_SRC = ./src/parser

all:
	@$(CD) $(PSR_SRC);                 \
        $(ECHO) Making $(PSR_SRC) ...;     \
        $(MAKE)

clean:
	rm -f ./vl2mv;			   \
	rm -f ./include/verilog_yacc.h;    \
	rm -f ./lib/*.a;		   \
	rm -f ./src/array/array.o;	   \
	rm -f ./src/array/libarray.a;	   \
	rm -f ./src/list/list.o;	   \
	rm -f ./src/list/liblist.a;	   \
	rm -f ./src/parser/*.o;		   \
	rm -f ./src/parser/verilog_lex.c;  \
	rm -f ./src/parser/verilog_yacc.c; \
	rm -f ./src/st/st.o;		   \
	rm -f ./src/st/libst.a;		   \
	rm -f ./src/util/*.o;		   \
	rm -f ./src/util/libutil.a

/* a delay expression */
typedef struct vl_delay {
    vl_expr *delay1;		/* rise mintypmax expression */
    vl_expr *delay2;		/* fall mintypmax expression */
    vl_expr *delay3;		/* toZ mintypmax expression */
} vl_delay, *vl_delayPtr;

/* for memories like: reg [7:0] mem[31:0];
   Holds the mem[31:0] part
*/
typedef struct vl_id_range {
    char * name;
    short flavl2mv/README                                                                                        100600  027004  000214  00000003501 05402724604 007133  0                                                                                                         0                                                                                    1  0                                                                                                                                                                 /*
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
 * $Header: /n/rashd/u/riepe/CVS_REPOSITORY/ravel/Srcs/Parser/README,v 1.1.1.1 1993/03/04 23:37:52 riepe Exp $
 */

Software in this directory was borrowed, or was derived from code, borrowed
with permission from U.C. Berkeley.  Obtained by anonymous ftp from
ic.berkeley.edu in directory /pub/stchengvl2mv.tar.Z.  

Berkeley MIS dependencies deleted, and vl_traverse.c routines heavily
modified by Mike Riepe, University of Michigan, 1/28/93.

Per instructions from Berkeley, the above copyright message is to
accompany the source in this directory.

CONTACT: stcheng@ic.berkeley.edu
Login name: stcheng                     In real life: Szu-Tsung Cheng
Office: 524 Cory, 643-7730              Home phone: 845-2440
Directory: /users/stcheng               Shell: /bin/csh
Advisor: RKB
Group: cad
Mail forwarded to: stcheng@ic.Berkeley.EDU
Project: Verilog -> BLIF-MV Translator
Plan:

---------------------------------------------------------------------
Address: 1622 Berkeley Way Apt 1, Berkeley, CA 94703
Phone  : (510)845-2440 (h)

Schedule: c273:t/th:1100-1230:85evans
          ieor268:t/th:200-330:3113etch
          c267:m/w/f:100-200:71evans
---------------------------------------------------------------------
const_term, *const_termPtr;
     /* list of vl_case_item */
    lsHandle handle;		/* next statement in list */
} vl_case_stmt;

/* ForeverStmt */
typedef struct vl_forever_stmt {
    short tyvl2mv/parser.notes                                                                                  100644  027004  000214  00000011756 05402732241 010640  0                                                                                                         0                                                                                    1  0                                                                                                                                                                 [parser.notes]

A collection of comments received from people I have given this parser to.
These changes have _NOT_  been made in the distribution as it now stands,
and are untested.  You may incorporate them into the code if you wish.

==============================================================================

From cmb@ksr.com Mon Mar 15 16:27:26 1993
Subject: vl2mv

viraphol: Thanks for the pointers to the Verilog parser.  I have obtained it and
been working on bringing it up.

riepe: I received your version of vl2mv.  I have had some problems compiling it
on my Sparc2.  However, after some bug fixes described below, I have it parsing
and printing out the parse tree of a several page Verilog program.

stcheng: I wanted to let you know that I ftp'ed a copy of vl2mv.  In addition, I
received a second copy from riepe.  He had made his version compile and run for
him so I started working with his sources.  I instantly ran into several
problems which I will describe below.  If any of you have already debugged the
stuff I am finding, I would appreciate knowing.  I am mainly parsing behavioral
Verilog.  Has this parser been used for that yet?

My problems:

1) In verilog.l, the parsing of strings seems broken.  I made the following
change:

97c102
< <Snormal>\"[^"]*\"          { return YYSTRING; }             <-- new
---
> <Snormal>\"[^"]*            { return YYSTRING; }             <-- old

2) In verilog.l, form-feeds don't count as whitespace (section 2.2 of March 1991
Cadence Verilog manual).  I changed the following:

54c56
< Space       [\n\r\t\b\f ]					<-- new
---
> Space       [\n\r\t\b ]					<-- old
220c225
< <Snormal>\\[^\n\t\b\r\f ]*    { 				<-- new
---
> <Snormal>\\[^\n\t\b\r ]*      { 				<-- old

3) In verilog.y, vl_create_expr was called with the wrong number of
arguments in rule "function_call : identifier '(' expression_list ')'":

3011c3014
< 				  $1, $3, NIL(void));		<-- new
---
> 				  $1, $3);			<-- old

4) In verilog.y, syntax "port_list : port | port_list ',' port", handle was
declared and used incorrectly:

414c416
< 	      lsHandle handle;					<-- new
---
> 	      lsHandle *handle;					<-- old
417c419
< 	      lsNewEnd($1, (lsGeneric)$3, &handle);		<-- new
---
> 	      lsNewEnd($1, (lsGeneric)$3, handle);		<-- old

5) In verilog.y, syntax "function : YYFUNCTION range_or_type_opt YYID ';'
tf_declaration_eclr statement_opt YYENDFUNCTION", I had to write it as follows:

	      if ($2 == NIL(vl_range_or_type)) {
		  func_type = IntFuncDecl; /* default function type */
		  $$ = vl_create_function(func_type, NIL(vl_range), $<idrng>4, $6, $7);
	      } else {
		  switch ($2->type) {
		  case Range_Dcl: func_type = RangeFuncDecl; break;
		  case Integer_Dcl: func_type = IntFuncDecl; break;
		  case Real_Dcl: func_type = RealFuncDecl; break; 
		  default: internal_error("unknown function type");
		  }
		  $$ = vl_create_function(func_type, $2->range, $<idrng>4, $6, $7);
	      }

You had written it as

	      if ($2 == NIL(vl_range_or_type)) {
		  func_type = IntFuncDecl; /* default function type */
	      } else {
		  switch ($2->type) {
		  case Range_Dcl: func_type = RangeFuncDecl; break;
		  case Integer_Dcl: func_type = IntFuncDecl; break;
		  case Real_Dcl: func_type = RealFuncDecl; break; 
		  defualt: internal_error("unknown function type");
		  }
	      }
	      $$ = vl_create_function(func_type, $2->range, $<idrng>4, $6, $7);

This can cause "$2->range" to follow a null pointer.  Some computers allow this
but generally it is a bad idea.

===============================================================================

From: hai@fc.hp.com (Hai Vo-Ba)
Subject: Re: Verilog HDL parser/analyzer

Michael Anthony Riepe (riepe@quip.eecs.umich.edu) wrote:
: 
: The parser itself seems to contain most of the verilog-HDL grammar, though
: many behavioral constructs are unimplemented in the data structure
: routines.  It is still under development, so there are bugs.
: 
: I spent a few days hacking the code and removed a lot of hooks to berkeley
: OCTTOOLS code that wasn't included with the distribution.  The code as
: I downloaded it didn't compile.  I'll place this on the anonymous FTP
: site here (gip.eecs.umich.edu in pub/riepe) - you'll get a version
: that compiles (at least it does on my decstation) and a list of bug
: fixes that have been sent to me other people I've given it to.

	Thanks for posting this info. I made a minor change to
    vl2mv/include/util.h to get the parser to compile on HP-UX:

	*** new_util.h	Sun May 30 21:31:04 1993
	--- include/util.h	Thu Jan 28 11:43:36 1993
	***************
	*** 108,114 ****
	  #include <stdlib.h>
	  #else
	  #if defined(hpux)
	! extern void abort();
	  extern VOID_HACK free(), exit(), perror();
	! extern char *getenv();
	! extern void *malloc(), *realloc(), *calloc();
	--- 108,113 ----
	  #include <stdlib.h>
	  #else
	  #if defined(hpux)
	! extern int abort();
	  extern VOID_HACK free(), exit(), perror();
	! extern char *getenv(), *malloc(), *realloc(), *calloc();

=============================================================================
 Expressions: Many                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                rser/verilog_yacc.c; \
	rm -f ./src/st/st.o;		   \
	rm -f ./src/st/libst.a;		   \
	rm -f ./src/util/*.o;		   \
	rm -f ./src/util/libutil.a

/* a delay expression */
typedef struct vl_delay {
    vl_expr *delay1;		/* rise mintypmax expression */
    vl_expr *delay2;		/* fall mintypmax expression */
    vl_expr *delay3;		/* toZ mintypmax expression */
} vl_delay, *vl_delayPtr;

/* for memories like: reg [7:0] mem[31:0];
   Holds the mem[31:0] part
*/
typedef struct vl_id_range {
    char * name;
    short flavl2mv/README                                                                                        100600  027004  000214  00000003501 05402724604 007133  0                                                                                                         0                                                                                    1  0                                                                                                                                                                 /*
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
 * $Header: /n/rashd/u/riepe/CVS_REPOSITORY/ravel/Srcs/Parser/README,v 1.1.1.1 1993/03/04 23:37:52 riepe Exp $
 */

Software in this directory was borrowed, or was derived from code, borrowed
with permission from U.C. Berkeley.  Obtained by anonymous ftp from
ic.berkeley.edu in directory /pub/stchengvl2mv.tar.Z.  

Berkeley MIS dependencies deleted, and vl_traverse.c routines heavily
modified by Mike Riepe, University of Michigan, 1/28/93.

Per instructions from Berkeley, the above copyright message is to
accompany the source in this directory.

CONTACT: stcheng@ic.berkeley.edu
Login name: stcheng                     In real life: Szu-Tsung Cheng
Office: 524 Cory, 643-7730              Home phone: 845-2440
Directory: /users/stcheng               Shell: /bin/csh
Advisor: RKB
Group: cad
Mail forwarded to: stcheng@ic.Berkeley.EDU
Project: Verilog -> BLIF-MV Translator
Plan:

---------------------------------------------------------------------
Address: 1622 Berkeley Way Apt 1, Berkeley, CA 94703
Phone  : (510)845-2440 (h)

Schedule: c273:t/th:1100-1230:85evans
          ieor268:t/th:200-330:3113etch
          c267:m/w/f:100-200:71evans
---------------------------------------------------------------------
const_term, *const_termPtr;
     /* list of vl_case_item */
    lsHandle handle;		/* next statement in list */
} vl_case_stmt;

/* ForeverStmt */
typedef struct vl_forever_stmt {
    short tyvl2mv/parser.notes                                                                                  100644  027004  000214  00000011756 05402732241 010640  0                                                                                                         0                                                                                    1  0                                                                                                                                                                 [parser.notes]

A collection of comments received from people I have given this parser to.
These changes have _NOT_  been made in the distribution as it now stands,
and are untested.  You may incorporate them into the code if you wish.

==============================================================================

From cmb@ksr.com Mon Mar 15 16:27:26 1993
Subject: vl2mv

viraphol: Thanks for the pointers to the Verilog parser.  I have obtained it and
been working on bringing it up.

riepe: I received your version of vl2mv.  I have had some problems compiling it
on my Sparc2.  However, after some bug fixes described below, I have it parsing
and printing out the parse tree of a several page Verilog program.

stcheng: I wanted to let you know that I ftp'ed a copy of vl2mv.  In addition, I
received a second copy from riepe.  He had made his version compile and run for
him so I started working with his sources.  I instantly ran into several
problems which I will describe below.  If any of you have already debugged the
stuff I am finding, I would appreciate knowing.  I am mainly parsing behavioral
Verilog.  Has this parser been used for that yet?

My problems:

1) In verilog.l, the parsing of strings seems broken.  I made the following
change:

97c102
< <Snormal>\"[^"]*\"          { return YYSTRING; }             <-- new
---
> <Snormal>\"[^"]*            { return YYSTRING; }             <-- old

2) In verilog.l, form-feeds don't count as whitespace (section 2.2 of March 1991
Cadence Verilog manual).  I changed the following:

54c56
< Space       [\n\r\t\b\f ]					<-- new
---
> Space       [\n\r\t\b ]					<-- old
220c225
< <Snormal>\\[^\n\t\b\r\f ]*    { 				<-- new
---
> <Snormal>\\[^\n\t\b\r ]*      { 				<-- old

3) In verilog.y, vl_create_expr was called with the wrong number of
arguments in rule "function_call : identifier '(' expression_list ')'":

3011c3014
< 				  $1, $3, NIL(void));		<-- new
---
> 				  $1, $3);			<-- old

4) In verilog.y, syntax "port_list : port | port_list ',' port", handle was
declared and used incorrectly:

414c416
< 	      lsHandle handle;					<-- new
---
> 	      lsHandle *handle;					<-- old
417c419
< 	      lsNewEnd($1, (lsGeneric)$3, &handle);		<-- new
---
> 	      lsNewEnd($1, (lsGeneric)$3, handle);		<-- old

5) In verilog.y, syntax "function : YYFUNCTION range_or_type_opt YYID ';'
tf_declaration_eclr statement_opt YYENDFUNCTION", I had to write it as follows:

	      if ($2 == NIL(vl_range_or_type)) {
		  func_type = IntFuncDecl; /* default function type */
		  $$ = vl_create_functi
