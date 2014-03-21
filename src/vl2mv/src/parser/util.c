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

