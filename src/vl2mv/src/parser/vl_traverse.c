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

