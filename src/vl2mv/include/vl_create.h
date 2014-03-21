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

