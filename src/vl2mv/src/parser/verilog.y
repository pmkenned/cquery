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
