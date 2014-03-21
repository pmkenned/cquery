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
