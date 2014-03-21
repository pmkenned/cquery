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
 * $Header: /vol/eros/eros8/stcheng/vl2mv/include/RCS/vlr_int.h,v 1.2 1993/01/15 19:46:06 stcheng Exp stcheng $
 *
 * Internal header file for verilog parser
 * STCheng, stcheng@ic.berkeley.edu, 10/92
 */

/* macros */
#define MAXSTRLEN BUFSIZ
#define MAXBITNUM 32
#define ERR_CHK      1
#define ERR_COMPILE  2
#define ERR_INTERNAL 3
#define ERR_ASSERT   4

#define SEP_LBITSELECT "["
#define SEP_RBITSELECT "]"
#define SEP_LTRANGE    "{"
#define SEP_RTRANGE    "}"
#define SEP_LARRAY     "<"
#define SEP_RARRAY     ">"
#define SEP_GATEPIN   ":"
#define SEP_DIR       "$"
#define SEP_LATCH     "|"
#define PIN_LATCH     "lat"
#define PIN_RAWOUT    "raw"
#define PIN_TRUE      "true"
#define PIN_FALSE     "false"
#define PIN_IN        "in"

/* internal intermediate files */
#define SCRATCH_FILE  "gate.blif"
#define SCRIPT_NAME   "script.complement"
#define SIS_LOG       "sis.log"

/* names assumed to be clock signal hence skipped */
#define CLOCK         "clk"

/* deciding if a mux is neede for if/else or case */
#define NO_MUX        0x0
#define MUX_T         0x3    /* 11b */
#define MUX_F         0x2    /* 10b */

/* for verilog.l */
#define MACRO_DEFINE  "define"

/* blif(-mv) stuffs */

/* what is 'GND' in mv? */
/* blif-mv library functions */
#define BLIF_GND         "_BLIF_GND"
#define BLIF_SUP         "_BLIF_SUP"
#define BLIF_LIB_AND     "_BLIF_AND"
#define BLIF_LIB_OR      "_BLIF_OR"
#define BLIF_LIB_XOR     "_BLIF_XOR"
#define BLIF_LIB_XNOR    "_BLIF_XNOR"
#define BLIF_LIB_ADD     "_BLIF_ADD"
#define BLIF_LIB_SUB     "_BLIF_SUB"

/* default library names (index into lib_func[]), I/O format */
#define LIB_MUX      0

/* sorry, I define data in header, though it's not good, it's convenient */
static char *lib_fun[][2] = {
    {".subckt vlr_mux", " %s a=%s b=%s s=%s o=%s\n"}        /*  mux */
    };

#define YYTRACE(str) if (YYTrace) fprintf(stderr, "%s\n", str);
#define CreTRACE(str) if (CreTrace) fprintf(stderr, "  <C>%s", str);
#define PrtTRACE(str) if (PrtTrace) fprintf(stderr, "  <P>%s", str);
#define StpTRACE(str) if (StpTrace) fprintf(stderr, "  <S>%s", str);
#define WrtTRACE(str) if (WrtTrace) fprintf(stderr, "  <W>%s", str);
#define TODO(str) \
  {fprintf(stderr, "not implemented (translation not presice)>>\n%s\n", str); }
#define ASSERT(cond,msg) if (!(cond)) {fprintf(stderr,"ASSERT Fail:%s\n",msg);}
#define Assert(cond)  if (!cond) {fprintf(stderr,"Assert fail: file \"%s\", line %d\n",__FILE__,__LINE__);exit(ERR_ASSERT);}
				      
#define ISVLCONST(type) ((type)==BitExpr||(type)==IntExpr||(type)==RealExpr)
#define ISREDUCTION(type) ((type)==UnandExpr||(type)==UnorExpr|| \
			   (type)==UxnorExpr||(type)==UandExpr|| \
			   (type)==UorExpr||(type)==UxorExpr)

/* externals */
extern char yytext[];
extern int yylineno;
extern vl_descPtr vl_description;
extern vl_modulePtr vl_currentModule;
extern vl_primitivePtr vl_currentPrimitive;

/* prototype */

/* verilog.y */
void yyerror ARGS(char *str);

/* verilog.l */
int yywrap ARGS(());
void skipcommentblock ARGS(());
void binbin ARGS((char *, char *));
void octbin ARGS((char *, char *));
void decbin ARGS((char *, char *));
void hexbin ARGS((char *, char *));
char *utol ARGS((char *));
void memorize_macro ARGS((char *, st_table *));
void expand_macro ARGS((char *, st_table *));

/* util.c */
char *strdup ARGS((char *));
char *strappend ARGS((char*, char*));
char *strappendS ARGS((char*, char*));
char *WRT_BLIF_GND ARGS((FILE *));
char *WRT_BLIF_SUP ARGS((FILE *));
vl_term *true_term ARGS((FILE *));
int ptrcmp ARGS((char *, char *));
int ptrhash ARGS((char *, int));
int declcmp ARGS((char *, char *));
int declhash ARGS((char *, int));
char *strip_char ARGS((char *, char));
FILE *open_file ARGS((char *, char *));
void close_file ARGS((FILE *));
