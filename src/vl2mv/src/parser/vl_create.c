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
