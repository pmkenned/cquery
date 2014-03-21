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
