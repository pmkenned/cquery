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
