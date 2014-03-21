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
