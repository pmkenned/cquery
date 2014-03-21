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



