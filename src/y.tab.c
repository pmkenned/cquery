/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison implementation for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.7.12-4996"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
/* Line 371 of yacc.c  */
#line 1 "verilog.yacc"

#include <stdio.h>
#include <string.h>

/* Line 371 of yacc.c  */
#line 73 "y.tab.c"

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TILDE_AMP = 258,
     CARET_PIPE = 259,
     TILDE_CARET = 260,
     EQ_EQ = 261,
     NOT_EQ = 262,
     EQ_EQ_EQ = 263,
     NOT_EQ_EQ = 264,
     LAND = 265,
     AMP_AMP_AMP = 266,
     LOR = 267,
     LTE = 268,
     GTE = 269,
     CARET_TILDE = 270,
     LSHIFT = 271,
     RSHIFT = 272,
     EQ_GT = 273,
     AST_GT = 274,
     HYPH_GT = 275,
     SETUP = 276,
     HOLD = 277,
     PERIOD = 278,
     WIDTH = 279,
     SKEW = 280,
     RECOVERY = 281,
     SETUPHOLD = 282,
     _BEGIN_ = 283,
     END = 284,
     MACROMODULE = 285,
     MODULE = 286,
     ENDMODULE = 287,
     PRIMITIVE = 288,
     ENDPRIMITIVE = 289,
     TABLE = 290,
     ENDTABLE = 291,
     TASK = 292,
     ENDTASK = 293,
     FUNCTION = 294,
     ENDFUNCTION = 295,
     SPECIFY = 296,
     ENDSPECIFY = 297,
     INTEGER = 298,
     REAL = 299,
     TIME = 300,
     SPECPARAM = 301,
     PARAMETER = 302,
     DEFPARAM = 303,
     INPUT = 304,
     OUTPUT = 305,
     INOUT = 306,
     WIRE = 307,
     TRI = 308,
     TRI0 = 309,
     TRI1 = 310,
     SUPPLY0 = 311,
     SUPPLY1 = 312,
     WAND = 313,
     TRIAND = 314,
     TRIOR = 315,
     WOR = 316,
     TRIREG = 317,
     SCALARED = 318,
     VECTORED = 319,
     REG = 320,
     EVENT = 321,
     SMALL = 322,
     MEDIUM = 323,
     LARGE = 324,
     STRONG0 = 325,
     STRONG1 = 326,
     PULL0 = 327,
     PULL1 = 328,
     WEAK0 = 329,
     WEAK1 = 330,
     HIGHZ0 = 331,
     HIGHZ1 = 332,
     AND = 333,
     NAND = 334,
     OR = 335,
     NOR = 336,
     XOR = 337,
     XNOR = 338,
     BUF = 339,
     BUFIF0 = 340,
     BUFIF1 = 341,
     NOT = 342,
     NOTIF0 = 343,
     NOTIF1 = 344,
     PULLDOWN = 345,
     PULLUP = 346,
     NMOS = 347,
     RNMOS = 348,
     PMOS = 349,
     RPMOS = 350,
     CMOS = 351,
     RCMOS = 352,
     TRAN = 353,
     RTRAN = 354,
     TRANIF0 = 355,
     TRANIF1 = 356,
     RTRANIF0 = 357,
     RTRANIF1 = 358,
     ASSIGN = 359,
     DEASSIGN = 360,
     _INITIAL_ = 361,
     ALWAYS = 362,
     IF = 363,
     ELSE = 364,
     CASE = 365,
     CASEZ = 366,
     CASEX = 367,
     ENDCASE = 368,
     DEFAULT = 369,
     FOREVER = 370,
     REPEAT = 371,
     WHILE = 372,
     FOR = 373,
     WAIT = 374,
     DISABLE = 375,
     FORCE = 376,
     RELEASE = 377,
     FORK = 378,
     JOIN = 379,
     POSEDGE = 380,
     NEGEDGE = 381,
     EDGE = 382,
     OUTPUT_SYMBOL = 383,
     INIT_VAL = 384,
     STRING = 385,
     IDENTIFIER = 386,
     DECIMAL_NUMBER = 387,
     UNSIGNED_NUMBER = 388,
     BASE = 389,
     SCALAR_CONSTANT = 390,
     LEVEL_SYMBOL = 391,
     EDGE_SYMBOL = 392,
     EDGE_DESCRIPTOR = 393
   };
#endif
/* Tokens.  */
#define TILDE_AMP 258
#define CARET_PIPE 259
#define TILDE_CARET 260
#define EQ_EQ 261
#define NOT_EQ 262
#define EQ_EQ_EQ 263
#define NOT_EQ_EQ 264
#define LAND 265
#define AMP_AMP_AMP 266
#define LOR 267
#define LTE 268
#define GTE 269
#define CARET_TILDE 270
#define LSHIFT 271
#define RSHIFT 272
#define EQ_GT 273
#define AST_GT 274
#define HYPH_GT 275
#define SETUP 276
#define HOLD 277
#define PERIOD 278
#define WIDTH 279
#define SKEW 280
#define RECOVERY 281
#define SETUPHOLD 282
#define _BEGIN_ 283
#define END 284
#define MACROMODULE 285
#define MODULE 286
#define ENDMODULE 287
#define PRIMITIVE 288
#define ENDPRIMITIVE 289
#define TABLE 290
#define ENDTABLE 291
#define TASK 292
#define ENDTASK 293
#define FUNCTION 294
#define ENDFUNCTION 295
#define SPECIFY 296
#define ENDSPECIFY 297
#define INTEGER 298
#define REAL 299
#define TIME 300
#define SPECPARAM 301
#define PARAMETER 302
#define DEFPARAM 303
#define INPUT 304
#define OUTPUT 305
#define INOUT 306
#define WIRE 307
#define TRI 308
#define TRI0 309
#define TRI1 310
#define SUPPLY0 311
#define SUPPLY1 312
#define WAND 313
#define TRIAND 314
#define TRIOR 315
#define WOR 316
#define TRIREG 317
#define SCALARED 318
#define VECTORED 319
#define REG 320
#define EVENT 321
#define SMALL 322
#define MEDIUM 323
#define LARGE 324
#define STRONG0 325
#define STRONG1 326
#define PULL0 327
#define PULL1 328
#define WEAK0 329
#define WEAK1 330
#define HIGHZ0 331
#define HIGHZ1 332
#define AND 333
#define NAND 334
#define OR 335
#define NOR 336
#define XOR 337
#define XNOR 338
#define BUF 339
#define BUFIF0 340
#define BUFIF1 341
#define NOT 342
#define NOTIF0 343
#define NOTIF1 344
#define PULLDOWN 345
#define PULLUP 346
#define NMOS 347
#define RNMOS 348
#define PMOS 349
#define RPMOS 350
#define CMOS 351
#define RCMOS 352
#define TRAN 353
#define RTRAN 354
#define TRANIF0 355
#define TRANIF1 356
#define RTRANIF0 357
#define RTRANIF1 358
#define ASSIGN 359
#define DEASSIGN 360
#define _INITIAL_ 361
#define ALWAYS 362
#define IF 363
#define ELSE 364
#define CASE 365
#define CASEZ 366
#define CASEX 367
#define ENDCASE 368
#define DEFAULT 369
#define FOREVER 370
#define REPEAT 371
#define WHILE 372
#define FOR 373
#define WAIT 374
#define DISABLE 375
#define FORCE 376
#define RELEASE 377
#define FORK 378
#define JOIN 379
#define POSEDGE 380
#define NEGEDGE 381
#define EDGE 382
#define OUTPUT_SYMBOL 383
#define INIT_VAL 384
#define STRING 385
#define IDENTIFIER 386
#define DECIMAL_NUMBER 387
#define UNSIGNED_NUMBER 388
#define BASE 389
#define SCALAR_CONSTANT 390
#define LEVEL_SYMBOL 391
#define EDGE_SYMBOL 392
#define EDGE_DESCRIPTOR 393



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 412 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if (! defined __GNUC__ || __GNUC__ < 2 \
      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5))
#  define __attribute__(Spec) /* empty */
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif


/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(N) (N)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (YYID (0))
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2542

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  168
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  187
/* YYNRULES -- Number of rules.  */
#define YYNRULES  470
/* YYNRULES -- Number of states.  */
#define YYNSTATES  945

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   393

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    22,     2,    14,    15,    21,    24,     2,
       5,     6,    19,    17,    11,    18,    12,    20,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     4,     3,
      26,    28,    27,    16,    13,     2,     2,     2,     2,    31,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     9,     2,    10,    29,     2,     2,     2,     2,     2,
       2,    30,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     7,    25,     8,    23,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,   133,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,   151,   152,   153,
     154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
     164,   165,   166,   167
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     6,     9,    11,    13,    14,    17,
      24,    31,    32,    34,    38,    40,    44,    46,    52,    53,
      55,    57,    61,    63,    67,    69,    74,    81,    83,    85,
      87,    89,    91,    93,    95,    97,    99,   101,   103,   105,
     107,   109,   111,   113,   115,   117,   119,   121,   123,   134,
     136,   139,   141,   143,   145,   146,   148,   154,   156,   160,
     162,   164,   166,   169,   174,   176,   179,   186,   188,   190,
     192,   196,   201,   203,   205,   207,   209,   210,   213,   215,
     218,   225,   227,   235,   236,   238,   240,   242,   244,   245,
     248,   250,   253,   255,   257,   259,   261,   263,   265,   267,
     269,   273,   278,   283,   288,   294,   301,   308,   310,   312,
     314,   316,   318,   320,   322,   324,   326,   328,   330,   331,
     333,   335,   338,   341,   346,   350,   354,   358,   362,   368,
     375,   379,   381,   385,   387,   391,   393,   400,   402,   404,
     406,   410,   412,   413,   415,   419,   423,   427,   428,   430,
     436,   442,   444,   446,   448,   450,   452,   454,   456,   458,
     460,   462,   463,   465,   471,   473,   477,   483,   485,   487,
     489,   491,   493,   495,   497,   499,   501,   503,   505,   507,
     509,   511,   513,   515,   517,   519,   521,   523,   525,   527,
     529,   531,   533,   535,   537,   541,   546,   547,   549,   552,
     558,   560,   564,   569,   570,   572,   575,   577,   581,   583,
     585,   590,   591,   593,   598,   600,   604,   610,   611,   613,
     615,   617,   619,   623,   624,   626,   628,   632,   638,   641,
     644,   646,   648,   649,   652,   655,   658,   664,   672,   679,
     686,   693,   696,   702,   708,   718,   721,   727,   731,   733,
     735,   737,   739,   743,   747,   751,   755,   759,   763,   767,
     771,   777,   781,   787,   789,   791,   797,   799,   802,   806,
     810,   813,   817,   824,   828,   835,   837,   838,   841,   843,
     845,   847,   849,   851,   853,   855,   861,   864,   870,   873,
     875,   879,   880,   883,   885,   887,   889,   891,   893,   895,
     899,   901,   905,   909,   914,   920,   926,   928,   930,   932,
     936,   938,   943,   950,   952,   956,   958,   963,   970,   972,
     974,   976,   982,   990,  1004,  1030,  1032,  1033,  1038,  1050,
    1062,  1072,  1082,  1094,  1106,  1120,  1124,  1126,  1128,  1132,
    1133,  1135,  1137,  1139,  1141,  1146,  1148,  1152,  1153,  1156,
    1158,  1162,  1164,  1167,  1171,  1175,  1179,  1183,  1185,  1190,
    1192,  1193,  1196,  1198,  1212,  1226,  1228,  1231,  1235,  1236,
    1238,  1240,  1242,  1243,  1248,  1264,  1280,  1282,  1283,  1285,
    1287,  1289,  1298,  1302,  1305,  1307,  1312,  1319,  1321,  1323,
    1324,  1327,  1329,  1335,  1337,  1341,  1343,  1346,  1350,  1356,
    1358,  1360,  1362,  1364,  1366,  1368,  1370,  1372,  1374,  1376,
    1378,  1380,  1382,  1384,  1386,  1388,  1390,  1392,  1394,  1396,
    1398,  1400,  1402,  1404,  1406,  1408,  1410,  1412,  1414,  1416,
    1418,  1420,  1422,  1424,  1429,  1436,  1438,  1440,  1442,  1446,
    1447,  1449,  1450,  1453,  1455,  1459,  1463,  1468,  1473,  1477,
    1484,  1489,  1494,  1496,  1499,  1501,  1505,  1506,  1508,  1511,
    1514,  1521,  1524,  1527,  1532,  1535,  1540,  1542,  1545,  1548,
    1552
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     169,     0,    -1,   170,    -1,    -1,   170,   171,    -1,   173,
      -1,   184,    -1,    -1,   172,   183,    -1,    60,   160,   174,
       3,   172,    61,    -1,    59,   160,   174,     3,   172,    61,
      -1,    -1,   175,    -1,     5,   176,     6,    -1,   177,    -1,
     176,    11,   177,    -1,   178,    -1,    12,   182,     5,   178,
       6,    -1,    -1,   179,    -1,   181,    -1,     7,   180,     8,
      -1,   181,    -1,   180,    11,   181,    -1,   160,    -1,   160,
       9,   333,    10,    -1,   160,     9,   333,     4,   333,    10,
      -1,   160,    -1,   212,    -1,   213,    -1,   214,    -1,   215,
      -1,   216,    -1,   220,    -1,   221,    -1,   222,    -1,   223,
      -1,   224,    -1,   243,    -1,   249,    -1,   256,    -1,   226,
      -1,   225,    -1,   287,    -1,   267,    -1,   268,    -1,   204,
      -1,   206,    -1,    62,   160,     5,   227,     6,     3,   185,
     187,   190,    63,    -1,   186,    -1,   185,   186,    -1,   214,
      -1,   220,    -1,   213,    -1,    -1,   188,    -1,   135,   189,
      28,   158,     3,    -1,   160,    -1,    64,   191,    65,    -1,
     192,    -1,   194,    -1,   193,    -1,   192,   193,    -1,   197,
       4,   157,     3,    -1,   195,    -1,   194,   195,    -1,   196,
       4,   200,     4,   201,     3,    -1,   197,    -1,   198,    -1,
     203,    -1,   202,   199,   202,    -1,     5,   165,   165,     6,
      -1,   166,    -1,   165,    -1,   157,    -1,    18,    -1,    -1,
     202,   165,    -1,   165,    -1,   203,   165,    -1,    66,   205,
       3,   209,   269,    67,    -1,   160,    -1,    68,   207,   160,
       3,   210,   271,    69,    -1,    -1,   208,    -1,   241,    -1,
      72,    -1,    73,    -1,    -1,   209,   211,    -1,   211,    -1,
     210,   211,    -1,   212,    -1,   213,    -1,   214,    -1,   215,
      -1,   220,    -1,   221,    -1,   222,    -1,   223,    -1,    76,
     291,     3,    -1,    78,   240,   227,     3,    -1,    79,   240,
     227,     3,    -1,    80,   240,   227,     3,    -1,   217,   218,
     349,   227,     3,    -1,    91,   234,   218,   349,   227,     3,
      -1,   217,   236,   218,   349,   242,     3,    -1,    81,    -1,
      82,    -1,    84,    -1,    85,    -1,    87,    -1,    88,    -1,
      83,    -1,    86,    -1,    90,    -1,    89,    -1,    91,    -1,
      -1,   219,    -1,   241,    -1,    92,   241,    -1,    93,   241,
      -1,    94,   240,   228,     3,    -1,    74,   228,     3,    -1,
      72,   228,     3,    -1,    73,   227,     3,    -1,    95,   232,
       3,    -1,   133,   236,   349,   242,     3,    -1,   217,   236,
     218,   349,   242,     3,    -1,    77,   291,     3,    -1,   160,
      -1,   227,    11,   160,    -1,   229,    -1,   228,    11,   229,
      -1,   230,    -1,   231,     9,   333,     4,   333,    10,    -1,
     160,    -1,   160,    -1,   233,    -1,   232,    11,   233,    -1,
     160,    -1,    -1,   235,    -1,     5,    96,     6,    -1,     5,
      97,     6,    -1,     5,    98,     6,    -1,    -1,   237,    -1,
       5,   238,    11,   239,     6,    -1,     5,   239,    11,   238,
       6,    -1,    85,    -1,    99,    -1,   101,    -1,   103,    -1,
     105,    -1,    86,    -1,   100,    -1,   102,    -1,   104,    -1,
     106,    -1,    -1,   241,    -1,     9,   333,     4,   333,    10,
      -1,   272,    -1,   242,    11,   272,    -1,   244,   236,   349,
     245,     3,    -1,   107,    -1,   108,    -1,   109,    -1,   110,
      -1,   111,    -1,   112,    -1,   113,    -1,   114,    -1,   115,
      -1,   116,    -1,   117,    -1,   118,    -1,   119,    -1,   120,
      -1,   121,    -1,   122,    -1,   123,    -1,   124,    -1,   125,
      -1,   126,    -1,   127,    -1,   128,    -1,   129,    -1,   131,
      -1,   130,    -1,   132,    -1,   246,    -1,   245,    11,   246,
      -1,   247,     5,   254,     6,    -1,    -1,   248,    -1,   160,
     240,    -1,   160,   236,   349,   250,     3,    -1,   251,    -1,
     250,    11,   251,    -1,   252,     5,   254,     6,    -1,    -1,
     253,    -1,   160,   240,    -1,   255,    -1,   254,    11,   255,
      -1,   337,    -1,   160,    -1,   160,   257,   259,     3,    -1,
      -1,   258,    -1,    14,     5,   336,     6,    -1,   260,    -1,
     259,    11,   260,    -1,   160,   240,     5,   261,     6,    -1,
      -1,   262,    -1,   263,    -1,   265,    -1,   264,    -1,   263,
      11,   264,    -1,    -1,   337,    -1,   266,    -1,   265,    11,
     266,    -1,    12,   160,     5,   337,     6,    -1,   135,   271,
      -1,   136,   271,    -1,   271,    -1,     3,    -1,    -1,   270,
     271,    -1,   273,     3,    -1,   274,     3,    -1,   137,     5,
     337,     6,   269,    -1,   137,     5,   337,     6,   269,   138,
     269,    -1,   139,     5,   337,     6,   276,   142,    -1,   140,
       5,   337,     6,   276,   142,    -1,   141,     5,   337,     6,
     276,   142,    -1,   144,   271,    -1,   145,     5,   337,     6,
     271,    -1,   146,     5,   337,     6,   271,    -1,   147,     5,
     272,     3,   337,     3,   272,     6,   271,    -1,   275,   269,
      -1,   148,     5,   337,     6,   269,    -1,    49,   233,     3,
      -1,   278,    -1,   279,    -1,   283,    -1,   284,    -1,   149,
     205,     3,    -1,   149,   280,     3,    -1,   133,   272,     3,
      -1,   134,   332,     3,    -1,   150,   272,     3,    -1,   151,
     332,     3,    -1,   332,    28,   337,    -1,   332,    28,   337,
      -1,   332,    28,   275,   337,     3,    -1,   332,    42,   337,
      -1,   332,    28,   275,   337,     3,    -1,   351,    -1,   352,
      -1,   145,     5,   337,     6,   352,    -1,   277,    -1,   276,
     277,    -1,   336,     4,   269,    -1,   143,     4,   269,    -1,
     143,   269,    -1,    57,   270,    58,    -1,    57,     4,   280,
     281,   270,    58,    -1,   152,   270,   153,    -1,   152,     4,
     280,   281,   270,   153,    -1,   160,    -1,    -1,   281,   282,
      -1,   212,    -1,   220,    -1,   222,    -1,   223,    -1,   221,
      -1,   224,    -1,   205,    -1,   205,     5,   336,     6,     3,
      -1,   285,     3,    -1,   285,     5,   336,     6,     3,    -1,
      15,   286,    -1,   160,    -1,    70,   288,    71,    -1,    -1,
     288,   289,    -1,   290,    -1,   293,    -1,   321,    -1,   326,
      -1,   306,    -1,   330,    -1,    75,   291,     3,    -1,   292,
      -1,   291,    11,   292,    -1,   348,    28,   333,    -1,   294,
      28,   303,     3,    -1,     5,   298,    47,   300,     6,    -1,
       5,   295,    48,   296,     6,    -1,   297,    -1,   299,    -1,
     298,    -1,   297,    11,   298,    -1,   301,    -1,   301,     9,
     333,    10,    -1,   301,     9,   333,     4,   333,    10,    -1,
     300,    -1,   299,    11,   300,    -1,   302,    -1,   302,     9,
     333,    10,    -1,   302,     9,   333,     4,   333,    10,    -1,
     160,    -1,   160,    -1,   304,    -1,     5,   304,    11,   304,
       6,    -1,     5,   304,    11,   304,    11,   304,     6,    -1,
       5,   304,    11,   304,    11,   304,    11,   304,    11,   304,
      11,   304,     6,    -1,     5,   304,    11,   304,    11,   304,
      11,   304,    11,   304,    11,   304,    11,   304,    11,   304,
      11,   304,    11,   304,    11,   304,    11,   304,     6,    -1,
     335,    -1,    -1,    11,   333,    11,   320,    -1,    15,    50,
       5,   307,    11,   307,    11,   318,   319,     6,     3,    -1,
      15,    51,     5,   307,    11,   307,    11,   318,   319,     6,
       3,    -1,    15,    52,     5,   309,    11,   318,   319,     6,
       3,    -1,    15,    53,     5,   309,    11,   318,   305,     6,
       3,    -1,    15,    54,     5,   307,    11,   307,    11,   318,
     319,     6,     3,    -1,    15,    55,     5,   309,    11,   307,
      11,   318,   319,     6,     3,    -1,    15,    56,     5,   307,
      11,   307,    11,   318,    11,   318,   319,     6,     3,    -1,
     310,   308,   314,    -1,   298,    -1,   300,    -1,   311,   308,
     314,    -1,    -1,   311,    -1,   154,    -1,   155,    -1,   312,
      -1,   156,     9,   313,    10,    -1,   167,    -1,   313,    11,
     167,    -1,    -1,    40,   315,    -1,   316,    -1,     5,   316,
       6,    -1,   317,    -1,    23,   317,    -1,   317,    35,   164,
      -1,   317,    37,   164,    -1,   317,    36,   164,    -1,   317,
      38,   164,    -1,   348,    -1,   348,     9,   337,    10,    -1,
     337,    -1,    -1,    11,   320,    -1,   348,    -1,   137,     5,
     322,     6,     5,   298,   323,    47,   300,     6,    28,   303,
       3,    -1,   137,     5,   322,     6,     5,   295,   323,    48,
     296,     6,    28,   303,     3,    -1,   181,    -1,   338,   181,
      -1,   181,   339,   181,    -1,    -1,   324,    -1,    17,    -1,
      18,    -1,    -1,   137,     5,   337,     6,    -1,   325,     5,
     328,   298,    47,     5,   300,   323,     4,   327,     6,     6,
      28,   303,     3,    -1,   325,     5,   328,   298,    48,     5,
     296,   323,     4,   327,     6,     6,    28,   303,     3,    -1,
     337,    -1,    -1,   329,    -1,   154,    -1,   155,    -1,   137,
       5,   331,     6,   294,    28,   303,     3,    -1,   337,   339,
     337,    -1,   338,   337,    -1,   348,    -1,   348,     9,   337,
      10,    -1,   348,     9,   333,     4,   333,    10,    -1,   344,
      -1,   337,    -1,    -1,    11,   335,    -1,   337,    -1,   337,
       4,   337,     4,   337,    -1,   337,    -1,   336,    11,   337,
      -1,   340,    -1,   338,   340,    -1,   337,   339,   337,    -1,
     337,    16,   337,     4,   337,    -1,   159,    -1,    17,    -1,
      18,    -1,    22,    -1,    23,    -1,    24,    -1,    32,    -1,
      25,    -1,    33,    -1,    29,    -1,    34,    -1,    17,    -1,
      18,    -1,    19,    -1,    20,    -1,    21,    -1,    35,    -1,
      36,    -1,    37,    -1,    38,    -1,    39,    -1,    41,    -1,
      26,    -1,    42,    -1,    27,    -1,    43,    -1,    24,    -1,
      25,    -1,    29,    -1,    44,    -1,    46,    -1,    45,    -1,
     343,    -1,   348,    -1,   348,     9,   337,    10,    -1,   348,
       9,   333,     4,   333,    10,    -1,   344,    -1,   345,    -1,
     346,    -1,     5,   335,     6,    -1,    -1,   162,    -1,    -1,
      12,   162,    -1,   161,    -1,   341,   163,   162,    -1,   161,
      12,   162,    -1,   161,   342,    31,   161,    -1,   161,   342,
      30,   161,    -1,     7,   336,     8,    -1,     7,   337,     7,
     336,     8,     8,    -1,   160,     5,   336,     6,    -1,   347,
       5,   336,     6,    -1,   347,    -1,    15,   286,    -1,   160,
      -1,   348,    12,   160,    -1,    -1,   350,    -1,    14,   343,
      -1,    14,   348,    -1,    14,     5,   335,   334,   334,     6,
      -1,    14,   343,    -1,    14,   348,    -1,    14,     5,   335,
       6,    -1,    13,   348,    -1,    13,     5,   353,     6,    -1,
     337,    -1,   154,   354,    -1,   155,   354,    -1,   353,   109,
     353,    -1,   160,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   106,   106,   108,   109,   112,   113,   115,   116,   119,
     122,   126,   127,   130,   133,   134,   137,   138,   140,   141,
     144,   145,   148,   149,   152,   153,   154,   157,   160,   161,
     162,   163,   164,   165,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   175,   176,   177,   178,   179,   182,   189,
     190,   193,   194,   195,   197,   198,   201,   204,   207,   210,
     211,   214,   215,   218,   221,   222,   225,   228,   229,   232,
     235,   238,   239,   242,   245,   246,   248,   249,   252,   253,
     256,   262,   265,   270,   271,   274,   275,   276,   278,   279,
     282,   283,   286,   287,   288,   289,   290,   291,   292,   293,
     296,   299,   302,   305,   308,   309,   310,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   325,   326,
     329,   330,   331,   334,   337,   340,   343,   346,   349,   350,
     353,   356,   357,   360,   361,   364,   365,   368,   371,   374,
     375,   378,   380,   381,   384,   385,   386,   388,   389,   392,
     393,   396,   397,   398,   399,   400,   403,   404,   405,   406,
     407,   409,   410,   413,   416,   417,   420,   423,   424,   425,
     426,   427,   428,   429,   430,   431,   432,   433,   434,   435,
     436,   437,   438,   439,   440,   441,   442,   443,   444,   445,
     446,   447,   448,   451,   452,   455,   457,   458,   461,   464,
     467,   468,   471,   473,   474,   477,   480,   481,   484,   485,
     488,   490,   491,   494,   497,   498,   501,   503,   504,   507,
     508,   511,   512,   514,   515,   518,   519,   523,   526,   529,
     532,   533,   535,   536,   539,   540,   541,   542,   543,   544,
     545,   546,   547,   548,   549,   550,   551,   552,   553,   554,
     555,   556,   557,   558,   559,   560,   561,   562,   565,   568,
     569,   572,   573,   576,   577,   578,   581,   582,   585,   586,
     587,   590,   591,   594,   595,   598,   600,   601,   604,   605,
     606,   607,   608,   609,   612,   613,   616,   617,   620,   623,
     626,   628,   629,   632,   633,   634,   635,   636,   637,   640,
     643,   644,   647,   650,   653,   654,   657,   660,   663,   664,
     667,   668,   669,   672,   673,   676,   677,   678,   682,   686,
     689,   690,   691,   693,   696,   704,   706,   707,   710,   711,
     712,   713,   714,   715,   716,   719,   723,   724,   727,   730,
     731,   734,   735,   736,   739,   742,   743,   745,   746,   749,
     750,   753,   754,   755,   756,   757,   758,   762,   763,   766,
     768,   769,   772,   775,   778,   783,   784,   785,   787,   788,
     791,   792,   794,   795,   798,   802,   809,   811,   812,   815,
     816,   819,   822,   823,   826,   827,   828,   829,   832,   834,
     835,   838,   839,   842,   843,   846,   847,   848,   849,   850,
     853,   854,   855,   856,   857,   858,   859,   860,   861,   862,
     865,   866,   867,   868,   869,   870,   871,   872,   873,   874,
     875,   876,   877,   878,   879,   880,   881,   882,   883,   884,
     885,   888,   889,   890,   891,   892,   893,   894,   895,   897,
     898,   900,   901,   907,   908,   909,   910,   912,   916,   919,
     922,   923,   924,   927,   931,   932,   934,   935,   938,   939,
     940,   943,   944,   945,   948,   949,   952,   953,   954,   955,
     960
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "';'", "':'", "'('", "')'", "'{'", "'}'",
  "'['", "']'", "','", "'.'", "'@'", "'#'", "'$'", "'?'", "'+'", "'-'",
  "'*'", "'/'", "'%'", "'!'", "'~'", "'&'", "'|'", "'<'", "'>'", "'='",
  "'^'", "'e'", "'E'", "TILDE_AMP", "CARET_PIPE", "TILDE_CARET", "EQ_EQ",
  "NOT_EQ", "EQ_EQ_EQ", "NOT_EQ_EQ", "LAND", "AMP_AMP_AMP", "LOR", "LTE",
  "GTE", "CARET_TILDE", "LSHIFT", "RSHIFT", "EQ_GT", "AST_GT", "HYPH_GT",
  "SETUP", "HOLD", "PERIOD", "WIDTH", "SKEW", "RECOVERY", "SETUPHOLD",
  "_BEGIN_", "END", "MACROMODULE", "MODULE", "ENDMODULE", "PRIMITIVE",
  "ENDPRIMITIVE", "TABLE", "ENDTABLE", "TASK", "ENDTASK", "FUNCTION",
  "ENDFUNCTION", "SPECIFY", "ENDSPECIFY", "INTEGER", "REAL", "TIME",
  "SPECPARAM", "PARAMETER", "DEFPARAM", "INPUT", "OUTPUT", "INOUT", "WIRE",
  "TRI", "TRI0", "TRI1", "SUPPLY0", "SUPPLY1", "WAND", "TRIAND", "TRIOR",
  "WOR", "TRIREG", "SCALARED", "VECTORED", "REG", "EVENT", "SMALL",
  "MEDIUM", "LARGE", "STRONG0", "STRONG1", "PULL0", "PULL1", "WEAK0",
  "WEAK1", "HIGHZ0", "HIGHZ1", "AND", "NAND", "OR", "NOR", "XOR", "XNOR",
  "BUF", "BUFIF0", "BUFIF1", "NOT", "NOTIF0", "NOTIF1", "PULLDOWN",
  "PULLUP", "NMOS", "RNMOS", "PMOS", "RPMOS", "CMOS", "RCMOS", "TRAN",
  "RTRAN", "TRANIF0", "TRANIF1", "RTRANIF0", "RTRANIF1", "ASSIGN",
  "DEASSIGN", "_INITIAL_", "ALWAYS", "IF", "ELSE", "CASE", "CASEZ",
  "CASEX", "ENDCASE", "DEFAULT", "FOREVER", "REPEAT", "WHILE", "FOR",
  "WAIT", "DISABLE", "FORCE", "RELEASE", "FORK", "JOIN", "POSEDGE",
  "NEGEDGE", "EDGE", "OUTPUT_SYMBOL", "INIT_VAL", "STRING", "IDENTIFIER",
  "DECIMAL_NUMBER", "UNSIGNED_NUMBER", "BASE", "SCALAR_CONSTANT",
  "LEVEL_SYMBOL", "EDGE_SYMBOL", "EDGE_DESCRIPTOR", "$accept",
  "source_text", "description_list", "description", "module_item_list",
  "module", "list_of_ports_encl_opt", "list_of_ports_encl",
  "list_of_ports", "port", "port_expression_opt", "port_expression",
  "port_reference_list", "port_reference", "name_of_port", "module_item",
  "UDP", "UDP_declaration_list", "UDP_declaration",
  "UDP_initial_statement_opt", "UDP_initial_statement",
  "output_terminal_name", "table_definition", "table_entries",
  "combinational_entry_list", "combinational_entry",
  "sequential_entry_list", "sequential_entry", "input_list",
  "level_input_list", "edge_input_list", "edge", "state", "next_state",
  "level_symbol_star", "level_symbol_plus", "task", "name_of_task",
  "function", "range_or_type_opt", "range_or_type", "tf_declaration_star",
  "tf_declaration_plus", "tf_declaration", "parameter_declaration",
  "input_declaration", "output_declaration", "inout_declaration",
  "net_declaration", "NETTYPE", "expandrange_opt", "expandrange",
  "reg_declaration", "time_declaration", "integer_declaration",
  "real_declaration", "event_declaration", "continuous_assign",
  "parameter_override", "list_of_variables", "list_of_register_variables",
  "register_variable", "name_of_register", "name_of_memory",
  "list_of_name_of_events", "name_of_event", "charge_strength_opt",
  "charge_strength", "drive_strength_opt", "drive_strength", "STRENGTH0",
  "STRENGTH1", "range_opt", "range", "list_of_assignments",
  "gate_declaration", "GATETYPE", "gate_instance_list", "gate_instance",
  "name_of_gate_instance_opt", "name_of_gate_instance",
  "UDP_instantiation", "UDP_instance_list", "UDP_instance",
  "name_of_UDP_instance_opt", "name_of_UDP_instance", "terminal_list",
  "terminal", "module_instantiation", "parameter_value_assignment_opt",
  "parameter_value_assignment", "module_instance_list", "module_instance",
  "list_of_module_connections_opt", "list_of_module_connections",
  "module_port_connection_list", "module_port_connection",
  "named_port_connection_list", "named_port_connection",
  "initial_statement", "always_statement", "statement_or_null",
  "statement_list", "statement", "assignment", "blocking_assignment",
  "non_blocking_assignment", "delay_or_event_control", "case_item_list",
  "case_item", "seq_block", "par_block", "name_of_block",
  "block_declaration_list", "block_declaration", "task_enable",
  "system_task_enable", "name_of_system_task", "system_identifier",
  "specify_block", "specify_item_list", "specify_item",
  "specparam_declaration", "list_of_param_assignments", "param_assignment",
  "path_declaration", "path_description", "list_of_path_inputs",
  "list_of_path_outputs", "specify_input_terminal_descriptor_list",
  "specify_input_terminal_descriptor",
  "specify_output_terminal_descriptor_list",
  "specify_output_terminal_descriptor", "input_identifier",
  "output_identifier", "path_delay_value", "path_delay_expression",
  "comma_const_exp_comma_notify_reg_opt", "system_timing_check",
  "timing_check_event", "specify_terminal_descriptor",
  "controlled_timing_check_event", "timing_check_event_control_opt",
  "timing_check_event_control", "edge_control_specifier",
  "edge_descriptor_list", "amp_timing_check_condition_opt",
  "timing_check_condition", "scalar_timing_check_condition",
  "scalar_expression", "timing_check_limit", "comma_notify_register_opt",
  "notify_register", "level_sensitive_path_declaration",
  "conditional_port_expression", "polarity_operator_opt",
  "polarity_operator", "if_expression_opt",
  "edge_sensitive_path_declaration", "data_source_expression",
  "edge_identifier_opt", "edge_identifier", "sdpd",
  "sdpd_conditional_expression", "lvalue", "constant_expression",
  "comma_mintypmax_expression_opt", "mintypmax_expression",
  "expression_list", "expression", "UNARY_OPERATOR", "BINARY_OPERATOR",
  "primary", "unsigned_number_opt", "dot_unsigned_number_opt", "number",
  "concatenation", "multiple_concatenation", "function_call",
  "name_of_system_function", "identifier_hier", "delay_opt", "delay",
  "delay_control", "event_control", "event_expression",
  "scalar_event_expression", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,    59,    58,    40,    41,   123,   125,    91,
      93,    44,    46,    64,    35,    36,    63,    43,    45,    42,
      47,    37,    33,   126,    38,   124,    60,    62,    61,    94,
     101,    69,   258,   259,   260,   261,   262,   263,   264,   265,
     266,   267,   268,   269,   270,   271,   272,   273,   274,   275,
     276,   277,   278,   279,   280,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   331,   332,   333,   334,   335,
     336,   337,   338,   339,   340,   341,   342,   343,   344,   345,
     346,   347,   348,   349,   350,   351,   352,   353,   354,   355,
     356,   357,   358,   359,   360,   361,   362,   363,   364,   365,
     366,   367,   368,   369,   370,   371,   372,   373,   374,   375,
     376,   377,   378,   379,   380,   381,   382,   383,   384,   385,
     386,   387,   388,   389,   390,   391,   392,   393
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   168,   169,   170,   170,   171,   171,   172,   172,   173,
     173,   174,   174,   175,   176,   176,   177,   177,   178,   178,
     179,   179,   180,   180,   181,   181,   181,   182,   183,   183,
     183,   183,   183,   183,   183,   183,   183,   183,   183,   183,
     183,   183,   183,   183,   183,   183,   183,   183,   184,   185,
     185,   186,   186,   186,   187,   187,   188,   189,   190,   191,
     191,   192,   192,   193,   194,   194,   195,   196,   196,   197,
     198,   199,   199,   200,   201,   201,   202,   202,   203,   203,
     204,   205,   206,   207,   207,   208,   208,   208,   209,   209,
     210,   210,   211,   211,   211,   211,   211,   211,   211,   211,
     212,   213,   214,   215,   216,   216,   216,   217,   217,   217,
     217,   217,   217,   217,   217,   217,   217,   217,   218,   218,
     219,   219,   219,   220,   221,   222,   223,   224,   225,   225,
     226,   227,   227,   228,   228,   229,   229,   230,   231,   232,
     232,   233,   234,   234,   235,   235,   235,   236,   236,   237,
     237,   238,   238,   238,   238,   238,   239,   239,   239,   239,
     239,   240,   240,   241,   242,   242,   243,   244,   244,   244,
     244,   244,   244,   244,   244,   244,   244,   244,   244,   244,
     244,   244,   244,   244,   244,   244,   244,   244,   244,   244,
     244,   244,   244,   245,   245,   246,   247,   247,   248,   249,
     250,   250,   251,   252,   252,   253,   254,   254,   255,   255,
     256,   257,   257,   258,   259,   259,   260,   261,   261,   262,
     262,   263,   263,   264,   264,   265,   265,   266,   267,   268,
     269,   269,   270,   270,   271,   271,   271,   271,   271,   271,
     271,   271,   271,   271,   271,   271,   271,   271,   271,   271,
     271,   271,   271,   271,   271,   271,   271,   271,   272,   273,
     273,   274,   274,   275,   275,   275,   276,   276,   277,   277,
     277,   278,   278,   279,   279,   280,   281,   281,   282,   282,
     282,   282,   282,   282,   283,   283,   284,   284,   285,   286,
     287,   288,   288,   289,   289,   289,   289,   289,   289,   290,
     291,   291,   292,   293,   294,   294,   295,   296,   297,   297,
     298,   298,   298,   299,   299,   300,   300,   300,   301,   302,
     303,   303,   303,   303,   303,   304,   305,   305,   306,   306,
     306,   306,   306,   306,   306,   307,   308,   308,   309,   310,
     310,   311,   311,   311,   312,   313,   313,   314,   314,   315,
     315,   316,   316,   316,   316,   316,   316,   317,   317,   318,
     319,   319,   320,   321,   321,   322,   322,   322,   323,   323,
     324,   324,   325,   325,   326,   326,   327,   328,   328,   329,
     329,   330,   331,   331,   332,   332,   332,   332,   333,   334,
     334,   335,   335,   336,   336,   337,   337,   337,   337,   337,
     338,   338,   338,   338,   338,   338,   338,   338,   338,   338,
     339,   339,   339,   339,   339,   339,   339,   339,   339,   339,
     339,   339,   339,   339,   339,   339,   339,   339,   339,   339,
     339,   340,   340,   340,   340,   340,   340,   340,   340,   341,
     341,   342,   342,   343,   343,   343,   343,   343,   344,   345,
     346,   346,   346,   347,   348,   348,   349,   349,   350,   350,
     350,   351,   351,   351,   352,   352,   353,   353,   353,   353,
     354
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     2,     1,     1,     0,     2,     6,
       6,     0,     1,     3,     1,     3,     1,     5,     0,     1,
       1,     3,     1,     3,     1,     4,     6,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,    10,     1,
       2,     1,     1,     1,     0,     1,     5,     1,     3,     1,
       1,     1,     2,     4,     1,     2,     6,     1,     1,     1,
       3,     4,     1,     1,     1,     1,     0,     2,     1,     2,
       6,     1,     7,     0,     1,     1,     1,     1,     0,     2,
       1,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       3,     4,     4,     4,     5,     6,     6,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     0,     1,
       1,     2,     2,     4,     3,     3,     3,     3,     5,     6,
       3,     1,     3,     1,     3,     1,     6,     1,     1,     1,
       3,     1,     0,     1,     3,     3,     3,     0,     1,     5,
       5,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     1,     5,     1,     3,     5,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     4,     0,     1,     2,     5,
       1,     3,     4,     0,     1,     2,     1,     3,     1,     1,
       4,     0,     1,     4,     1,     3,     5,     0,     1,     1,
       1,     1,     3,     0,     1,     1,     3,     5,     2,     2,
       1,     1,     0,     2,     2,     2,     5,     7,     6,     6,
       6,     2,     5,     5,     9,     2,     5,     3,     1,     1,
       1,     1,     3,     3,     3,     3,     3,     3,     3,     3,
       5,     3,     5,     1,     1,     5,     1,     2,     3,     3,
       2,     3,     6,     3,     6,     1,     0,     2,     1,     1,
       1,     1,     1,     1,     1,     5,     2,     5,     2,     1,
       3,     0,     2,     1,     1,     1,     1,     1,     1,     3,
       1,     3,     3,     4,     5,     5,     1,     1,     1,     3,
       1,     4,     6,     1,     3,     1,     4,     6,     1,     1,
       1,     5,     7,    13,    25,     1,     0,     4,    11,    11,
       9,     9,    11,    11,    13,     3,     1,     1,     3,     0,
       1,     1,     1,     1,     4,     1,     3,     0,     2,     1,
       3,     1,     2,     3,     3,     3,     3,     1,     4,     1,
       0,     2,     1,    13,    13,     1,     2,     3,     0,     1,
       1,     1,     0,     4,    15,    15,     1,     0,     1,     1,
       1,     8,     3,     2,     1,     4,     6,     1,     1,     0,
       2,     1,     5,     1,     3,     1,     2,     3,     5,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     4,     6,     1,     1,     1,     3,     0,
       1,     0,     2,     1,     3,     3,     4,     4,     3,     6,
       4,     4,     1,     2,     1,     3,     0,     1,     2,     2,
       6,     2,     2,     4,     2,     4,     1,     2,     2,     3,
       1
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       3,     0,     2,     1,     0,     0,     0,     4,     5,     6,
      11,    11,     0,    18,     0,    12,     0,     0,     0,     0,
      24,     0,    14,    16,    19,    20,     7,     7,   131,     0,
       0,    22,    27,     0,   439,    13,    18,     0,     0,     0,
       0,    21,     0,    18,   439,   439,     0,   400,   401,   402,
     403,   404,   406,   408,   405,   407,   409,   399,   454,   443,
     440,     0,   388,   439,   395,     0,   431,   435,   436,   437,
     452,   432,    15,    10,     0,    83,   291,     0,     0,     0,
       0,     0,   161,   161,   161,   107,   108,   113,   109,   110,
     114,   111,   112,   116,   115,   117,   161,     0,   167,   168,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   178,
     179,   180,   181,   182,   183,   184,   185,   186,   187,   188,
     189,   191,   190,   192,   147,     0,     0,   147,     8,    46,
      47,    28,    29,    30,    31,    32,   118,    33,    34,    35,
      36,    37,    42,    41,    38,   147,    39,    40,    44,    45,
      43,     9,     0,   132,    23,     0,     0,   391,     0,   393,
     289,   453,   439,     0,     0,   439,    25,   439,   410,   411,
     412,   413,   414,   425,   426,   421,   423,   427,   415,   416,
     417,   418,   419,   420,   422,   424,   428,   430,   429,   439,
     396,     0,   439,   439,     0,    81,     0,   439,    86,    87,
       0,    84,    85,     0,   137,     0,   133,   135,     0,     0,
       0,   454,     0,   300,     0,     0,     0,   162,     0,     0,
       0,   118,   143,     0,   141,     0,   139,     0,   456,   148,
     439,     0,   439,     0,     0,   232,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     232,    81,   284,   228,     0,     0,     0,   248,   249,   250,
     251,     0,     0,   387,   384,   263,   264,   229,     0,   456,
       0,   212,     0,     0,   456,   119,   118,   120,   456,    54,
      49,    53,    51,    52,    17,   438,   439,   448,   439,   439,
       0,   393,   445,     0,     0,     0,     0,   397,   444,     0,
       0,   388,   455,    88,     0,     0,     0,     0,   290,     0,
       0,   292,   293,   294,     0,   297,   295,     0,   296,   298,
     125,     0,   439,   126,   124,   100,     0,   439,   130,     0,
       0,     0,     0,     0,     0,   456,     0,   127,     0,   151,
     156,   152,   157,   153,   158,   154,   159,   155,   160,     0,
       0,   439,     0,   457,   439,   464,   439,   461,   462,   288,
       0,     0,     0,     0,     0,     0,   439,   439,   439,   439,
     241,   439,   439,     0,   439,    81,     0,     0,     0,     0,
       0,     0,   439,   234,   235,   231,   245,   230,   286,   439,
     439,   439,   439,   439,   203,   161,     0,   214,   121,   122,
       0,   456,   196,     0,    50,     0,    55,     0,   394,     0,
     450,   447,   446,    26,   439,   451,   439,   433,     0,   439,
       0,   318,     0,   306,   308,   310,     0,     0,     0,     0,
       0,     0,     0,     0,   439,   439,   377,   134,     0,   301,
     302,   101,   102,   103,   144,   145,   146,     0,   123,   140,
       0,     0,   439,   458,   459,     0,   164,     0,     0,   466,
       0,     0,   247,   275,   276,   271,   233,   254,   439,   255,
       0,     0,     0,     0,     0,     0,     0,     0,   252,   253,
     256,   257,   276,   273,     0,     0,     0,   439,   259,   261,
       0,   388,     0,   161,     0,   200,     0,   204,     0,   210,
       0,     0,     0,   161,     0,   193,     0,   197,    57,     0,
      76,     0,   439,     0,   398,     0,    89,    92,    93,    94,
      95,    96,    97,    98,    99,     0,     0,     0,    90,     0,
       0,     0,   439,   339,   339,     0,     0,   339,     0,   339,
     299,    24,   365,     0,     0,     0,   439,   439,     0,   320,
     325,   379,   380,     0,   378,   439,     0,     0,     0,   389,
     128,     0,   470,   467,   468,   465,   439,   463,   232,   258,
       0,   439,   439,   439,     0,     0,   439,     0,   232,     0,
       0,   439,     0,   439,   385,   213,   205,   199,   203,   439,
     217,   215,   104,     0,   198,   166,   196,   439,     0,    78,
       0,    59,    61,    76,    64,     0,     0,    68,     0,    69,
      48,   392,   449,   434,    80,   163,    91,     0,   319,     0,
     307,   313,   315,   309,     0,     0,   341,   342,     0,     0,
       0,   340,   343,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   373,   439,   366,   383,   395,     0,   325,
     303,     0,     0,   105,   149,   150,   439,   389,   165,   469,
     278,   279,   282,   280,   281,   283,     0,   277,   236,     0,
     439,   266,     0,   439,   439,   242,   264,   243,     0,   246,
       0,   285,   287,     0,   260,     0,   201,   454,     0,   206,
     208,     0,     0,   218,   219,   221,   220,   225,   224,   106,
     194,     0,     0,    58,    62,     0,    65,    67,     0,     0,
       0,    77,    72,    76,    79,    82,   305,     0,   439,   304,
     439,   311,     0,   339,   318,   336,   337,   347,   339,   439,
     347,   439,   339,   339,   339,   367,     0,     0,   382,   439,
       0,     0,   136,   390,     0,   272,     0,     0,   270,   238,
     267,     0,   239,   240,     0,   274,     0,   386,   202,   439,
       0,   216,   223,     0,   195,    56,    73,     0,     0,     0,
      70,   314,     0,     0,   345,     0,     0,     0,   335,     0,
     360,   359,   338,   326,     0,     0,     0,   368,   308,   439,
       0,     0,     0,   460,   237,   269,   268,     0,   265,   207,
     439,   222,   226,     0,    63,     0,   439,   316,   312,   344,
       0,   439,     0,     0,   348,   349,   351,   357,   439,     0,
       0,   439,     0,   439,   439,   439,   370,   371,     0,   369,
       0,     0,   321,   439,   368,   368,     0,     0,    75,    74,
       0,    71,     0,   346,   360,     0,   352,     0,     0,     0,
       0,   439,   360,   361,   362,     0,     0,     0,   360,   360,
       0,     0,     0,   381,     0,     0,     0,   244,   227,    66,
     317,     0,   350,   353,   355,   354,   356,     0,     0,   330,
       0,   331,     0,     0,   439,     0,     0,   322,   439,   439,
     439,     0,   358,     0,   327,     0,     0,   360,     0,     0,
       0,     0,   376,     0,   328,   329,   332,   333,     0,   439,
     439,   439,     0,     0,     0,     0,     0,     0,     0,     0,
     334,   364,   363,   439,   439,   439,     0,     0,     0,   323,
     439,   374,   375,     0,   439,     0,   439,     0,   439,     0,
     439,     0,   439,     0,   324
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     7,    37,     8,    14,    15,    21,    22,
      23,    24,    30,    25,    33,   128,     9,   279,   280,   405,
     406,   509,   511,   600,   601,   602,   603,   604,   605,   606,
     607,   713,   767,   840,   608,   609,   129,   252,   130,   200,
     201,   418,   527,   516,   517,   518,   519,   520,   135,   136,
     274,   275,   521,   522,   523,   524,   141,   142,   143,    29,
     205,   206,   207,   208,   225,   226,   221,   222,   228,   229,
     349,   350,   216,   217,   455,   144,   145,   504,   505,   506,
     507,   146,   494,   495,   496,   497,   688,   689,   147,   270,
     271,   396,   397,   692,   693,   694,   695,   696,   697,   148,
     149,   386,   362,   387,   456,   254,   255,   256,   670,   671,
     257,   258,   377,   568,   667,   259,   260,   261,   161,   150,
     203,   311,   312,   212,   213,   313,   314,   422,   619,   423,
     725,   620,   621,   425,   622,   548,   549,   822,   315,   629,
     727,   634,   630,   631,   632,   775,   778,   814,   815,   816,
     780,   820,   853,   316,   543,   828,   829,   317,   318,   901,
     553,   554,   319,   544,   262,    61,   657,   550,   672,   157,
      63,   189,    64,    65,   164,    66,    67,    68,    69,    70,
      71,   352,   353,   265,   266,   460,   563
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -718
static const yytype_int16 yypact[] =
{
    -718,   103,   352,  -718,   -38,    28,    45,  -718,  -718,  -718,
     228,   228,   280,    37,   291,  -718,   310,   238,   242,   261,
     442,   142,  -718,  -718,  -718,  -718,  -718,  -718,  -718,   305,
     164,  -718,  -718,   457,  1219,  -718,    37,  1621,  1706,   463,
     334,  -718,   242,     9,  1219,  1219,   360,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,   523,    80,
    -718,    97,  2466,    53,  -718,   355,  -718,  -718,  -718,  -718,
     531,   318,  -718,  -718,   391,    65,  -718,   392,   238,   392,
     397,   397,   550,   550,   550,  -718,  -718,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,   560,   550,   406,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,   567,  1528,  1528,   221,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,   137,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,   567,  -718,  -718,  -718,  -718,
    -718,  -718,    38,  -718,  -718,   568,   570,  1879,   333,  2324,
    -718,  -718,  1219,   411,   239,  1219,  -718,  1219,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  1219,
    -718,   415,  1219,  1219,   419,  -718,   575,  1219,  -718,  -718,
     420,  -718,  -718,   108,   572,   236,  -718,  -718,   573,   275,
     279,  -718,   281,  -718,   117,   296,   238,  -718,   238,   238,
     427,   127,  -718,   392,  -718,   297,  -718,   267,   569,  -718,
    1219,    35,    49,   360,   406,   580,    52,    52,   581,   582,
     583,   584,  1528,   585,   587,   588,   590,   425,    52,    52,
     592,    93,   593,  -718,   594,   596,   818,  -718,  -718,  -718,
    -718,    78,    70,  -718,   484,  -718,  -718,  -718,   597,   569,
     441,  -718,   550,   550,   569,  -718,   127,  -718,   569,    47,
    -718,  -718,  -718,  -718,  -718,  -718,  1219,  -718,  1219,  1219,
     339,  2466,   358,   443,   445,   598,  1915,  2466,  -718,   432,
     599,  2361,  -718,  -718,   603,   606,   451,   418,  -718,   397,
     607,  -718,  -718,  -718,   589,  -718,  -718,   608,  -718,  -718,
    -718,   392,  1219,  -718,  -718,  -718,   397,  1219,  -718,   301,
     314,   325,   609,   610,   612,   569,   351,  -718,   406,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,  -718,   611,
     613,    56,    52,  -718,   987,   614,  1219,  -718,   614,  -718,
     616,   460,  1340,   618,   600,   622,  1219,  1219,  1219,  1219,
    -718,  1219,  1219,    52,  1219,  -718,   624,   626,   627,   628,
     460,  1380,  1219,  -718,  -718,  -718,  -718,  -718,  -718,  1219,
     966,  1219,  1219,  1219,   472,   550,   372,  -718,  -718,  -718,
     238,   569,   475,   481,  -718,   574,  -718,  1951,  2466,   493,
    -718,  -718,  -718,  -718,  1219,  -718,  1219,  -718,   785,  1219,
     350,  -718,   601,   631,   586,   635,   632,   640,   641,   646,
     647,   648,   649,   376,  1240,  1261,   209,  -718,   652,  -718,
    -718,  -718,  -718,  -718,  -718,  -718,  -718,   238,  -718,  -718,
     290,   362,  1219,  -718,   614,   404,  -718,   497,   497,  2466,
      51,   653,  -718,  -718,  -718,  -718,  -718,  -718,  1219,  -718,
    1985,  2019,  2053,  2087,  2121,  2155,   655,  2189,  -718,  -718,
    -718,  -718,  -718,  -718,   453,   469,   656,  1219,  2466,  2466,
     658,  2398,   470,   550,   405,  -718,   659,  -718,   660,  -718,
     441,   428,    52,   550,   437,  -718,   661,  -718,  -718,   639,
     495,   605,  1219,   665,  2466,   664,  -718,  -718,  -718,  -718,
    -718,  -718,  -718,  -718,  -718,   602,   667,  1312,  -718,   503,
     451,   503,  1219,   390,   390,   390,   390,   390,   390,   390,
    -718,   244,  2496,   669,   672,  2223,  1240,  1219,   677,  -718,
    -718,  -718,  -718,   451,  -718,  1219,   438,   679,   683,   671,
    -718,    52,  -718,  -718,  -718,  -718,   987,  -718,   229,  2466,
     818,  1071,  1071,  1071,  1528,  1528,  1219,   818,   229,   687,
     689,  1219,  1570,  1219,  -718,  -718,  -718,  -718,   472,  1282,
     676,  -718,  -718,   439,  -718,  -718,   475,  1282,   538,  -718,
     638,   495,  -718,   -22,  -718,   700,   702,  -718,    21,   542,
    -718,  2466,  -718,  -718,  -718,  -718,  -718,   642,  -718,   706,
     703,  -718,   704,  -718,   709,   254,  -718,  -718,   707,   708,
     557,  -718,  -718,   710,   711,   557,   712,   713,   715,   716,
     242,   724,   725,  -718,  1219,  -718,  2466,  -718,   720,   570,
    -718,   389,   722,  -718,  -718,  -718,  1219,   671,  -718,   625,
    -718,  -718,  -718,  -718,  -718,  -718,  1418,  -718,   595,   744,
    1008,  -718,   116,  1029,  1050,  -718,  -718,  -718,  1843,  -718,
    1488,  -718,  -718,  2257,  -718,   726,  -718,   237,   471,  -718,
    2466,   604,   714,  -718,   729,  -718,   730,  -718,  2466,  -718,
    -718,   477,   732,  -718,  -718,   702,  -718,  -718,   578,   617,
     591,  -718,  -718,  -718,  -718,  -718,  -718,   503,  1219,  -718,
    1219,  -718,   579,   390,  -718,  -718,  -718,   705,   390,  1219,
     705,  1219,   390,   390,   390,  -718,   451,   721,  2466,  1219,
     745,   747,  -718,  -718,   748,  -718,   818,   818,  -718,  -718,
    -718,   818,  -718,  -718,    52,  -718,   742,  -718,  -718,  1282,
     755,  -718,    62,   750,  -718,  -718,  -718,   759,   762,   615,
     620,  -718,   285,   757,  -718,   516,   758,    40,  -718,   760,
     764,  2466,  -718,   765,   767,   768,   770,   513,    71,  1261,
     478,   503,   503,  -718,  -718,  -718,  -718,   776,  -718,  -718,
    1219,  -718,  -718,    23,  -718,   777,  1219,  -718,  -718,  -718,
     619,  1219,    43,   397,  -718,  -718,   473,   504,  1219,   397,
     788,  1219,   789,  1219,  1219,  1219,  -718,  -718,   749,  -718,
     723,   793,  -718,  1219,   513,   513,  1528,  2291,  -718,  -718,
     799,  -718,   763,  -718,   764,   797,  -718,   643,   644,   645,
     650,  1219,   764,  -718,   614,   801,   795,   807,   764,   764,
     800,   503,   503,  -718,   479,   808,   809,  -718,  -718,  -718,
    -718,   810,  -718,  -718,  -718,  -718,  -718,  2435,   812,  -718,
     397,  -718,   816,   817,  1219,   820,   822,  -718,  1219,  1219,
    1219,   826,  -718,   827,  -718,   837,   838,   764,   740,   787,
     832,   839,  2466,   840,  -718,  -718,  -718,  -718,   841,  1261,
    1261,  1219,   842,   843,   848,   849,   850,   833,   834,   844,
    -718,  -718,  -718,  1219,  1261,  1261,   486,   851,   857,  -718,
    1219,  -718,  -718,   855,  1219,   858,  1219,   859,  1219,   860,
    1219,   862,  1219,   868,  -718
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -718,  -718,  -718,  -718,   853,  -718,   865,  -718,  -718,   846,
     825,  -718,  -718,   -17,  -718,  -718,  -718,  -718,   621,  -718,
    -718,  -718,  -718,  -718,  -718,   286,  -718,   283,  -718,  -344,
    -718,  -718,  -718,  -718,   184,  -718,  -718,   -41,  -718,  -718,
    -718,  -718,  -718,  -350,   -25,     0,    18,   496,  -718,  -718,
    -146,  -718,   -18,   -14,   -10,    -7,  -340,  -718,  -718,   -69,
     -45,   577,  -718,  -718,  -718,  -172,  -718,  -718,   -30,  -718,
     448,   452,   -48,   -36,   399,  -718,  -718,  -718,   307,  -718,
    -718,  -718,  -718,   317,  -718,  -718,   309,   148,  -718,  -718,
    -718,  -718,   408,  -718,  -718,  -718,   149,  -718,   147,  -718,
    -718,  -386,  -229,  -118,  -219,  -718,  -718,   522,   -32,  -167,
    -718,  -718,  -271,   431,  -718,  -718,  -718,  -718,   681,  -718,
    -718,  -718,  -718,   -63,   623,  -718,   273,   180,  -710,  -718,
    -303,  -718,  -516,  -718,  -718,  -717,  -537,  -718,  -718,  -461,
     282,   -78,  -718,   -21,  -718,  -718,   190,  -718,   109,   110,
    -405,  -578,    48,  -718,  -718,  -695,  -718,  -718,  -718,    50,
    -718,  -718,  -718,  -718,  -184,  -151,   270,   -42,     2,   -34,
     505,   -23,   -59,  -718,  -718,  -161,    73,  -718,  -718,  -718,
     -75,  -170,  -718,  -718,  -552,   375,   480
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -455
static const yytype_int16 yytable[] =
{
      62,    31,   156,   424,   190,   214,   214,   253,   267,   209,
     648,   159,   131,   131,   295,   624,    18,   363,   215,   137,
     137,   381,   676,   138,   138,   154,   710,   139,   139,   378,
     140,   140,   525,   196,   210,   218,   219,   132,   132,   202,
     354,   838,   300,   -60,    18,   812,   304,   158,   223,    19,
     264,   264,   364,   365,   356,   133,   133,   565,    44,   230,
      45,   452,   360,   813,   364,   379,   813,    44,    46,    45,
     528,   357,   831,   633,   197,   335,   637,    46,   639,    47,
      48,   388,   835,   389,    49,    50,    51,    52,   826,   827,
     464,    53,   163,   830,    54,    55,    56,   269,   390,   394,
     277,   165,  -454,     3,   400,  -454,   276,   166,   402,   482,
    -441,  -441,   391,   306,   726,   278,    82,    83,  -368,   726,
     751,  -454,    10,   307,   370,    82,    83,   288,   291,   194,
     401,    62,    96,   296,   283,  -454,   197,   198,   199,   865,
     866,    96,   227,   599,  -147,   327,   197,   329,    35,   330,
     331,   885,   281,    36,   476,   297,   355,   358,   291,   301,
     566,   264,   264,    62,   290,   447,   449,   264,   364,    20,
     282,   438,    41,   264,   264,    42,   440,   616,   336,   308,
     839,   264,   403,   309,   668,   277,   711,   712,    11,   364,
     453,   679,   915,   916,   299,   211,   291,    20,   263,   263,
     211,   771,   790,   211,   798,    12,   376,   927,   928,   211,
      59,    60,   211,    58,    59,    60,   211,    59,    60,   272,
     273,    57,    58,    59,    60,  -439,   227,   623,   665,   272,
     273,   502,   158,    13,   214,   268,   398,   399,   665,   320,
     277,   490,   162,  -209,   466,   310,   433,   321,  -209,   162,
     651,   214,   407,    34,   408,   291,  -454,   705,   720,   707,
    -454,   283,   776,   466,   721,   515,   871,   779,   526,   293,
     294,   784,   785,   786,   878,   834,   454,   264,   323,   281,
     882,   883,   324,   748,   325,    17,    40,   264,    62,   806,
     321,   409,   326,    62,    26,   807,   864,   282,   264,   328,
     337,    77,    78,    79,   441,    80,   264,   326,   338,   263,
     263,    39,    40,    27,   461,   263,    40,   442,   364,   908,
     459,   263,   263,    96,    97,    40,   783,   193,   443,   263,
     194,   501,   470,   471,   472,   473,    40,   474,   475,   666,
     477,   287,   658,   264,   288,   410,   886,   498,   291,   680,
     288,   900,   339,   340,   448,   291,   488,   489,   491,   291,
     794,   795,   321,   551,   552,   796,   341,   342,   343,   344,
     345,   346,   347,   348,   917,   499,   340,   364,   556,   540,
     514,   625,    62,   500,   484,    62,   926,   326,  -442,  -442,
     342,   485,   344,   933,   346,   492,   348,   935,    28,   937,
     545,   939,    20,   941,   652,   943,   844,   560,   587,   617,
     559,     4,     5,   852,     6,   561,   588,   542,   858,   859,
     860,    32,    77,    78,    79,   263,    80,   264,    82,    83,
      84,   592,   685,   788,   569,   263,   740,   741,   415,    40,
     595,   653,   699,   288,    96,   586,   263,   339,   596,    40,
     561,    34,   264,   582,   263,   594,   675,   677,   636,   579,
     638,   341,    43,   343,   288,   345,   152,   347,   426,   427,
     428,   429,   430,   431,   432,   580,   585,   758,   611,   897,
     288,   288,   759,   764,   832,   887,   264,   647,   759,   833,
     888,   263,   929,   392,   153,   264,   194,   930,    62,   264,
     264,   513,   264,   750,   288,   649,   750,   750,   847,   848,
     849,   850,   646,   851,   635,   635,   194,   635,   191,   640,
     160,    62,   644,   332,   333,   334,   809,   810,   162,   645,
     826,   827,   459,   134,   134,   797,   192,   291,   291,   291,
     673,   674,   678,   660,   626,   627,   628,   683,   466,    62,
     661,   195,   204,   660,   662,   690,   698,   211,   663,   197,
     661,   664,   466,   690,   662,   220,   224,   772,   663,   773,
     364,   664,   227,   292,   284,   263,   285,   298,   303,   302,
     305,  -138,   322,   351,   361,   375,   366,   367,   368,   369,
     371,   264,   372,   373,   264,   374,   380,   383,   382,   384,
     263,   395,   393,   416,   411,   264,   412,   419,   413,   420,
     738,   421,   434,   436,   743,   444,   445,   435,   446,   462,
     463,   467,   450,   735,   451,   469,   194,   478,   468,   479,
     480,   481,   493,   531,   263,   503,   291,   533,   510,   291,
     291,   508,   530,   263,   532,   534,   535,   263,   263,   529,
     263,   536,   537,   538,   539,   842,   555,   562,   576,   567,
     599,   581,   583,   618,   589,   590,   597,   598,   610,   614,
     856,   264,   264,   612,   613,   641,   264,   615,   642,   264,
     650,    44,   656,    45,    62,   654,    62,  -223,   691,   655,
     681,    46,   682,    47,    48,   781,   702,   781,    49,    50,
      51,    52,   817,   703,   708,    53,   709,   714,    54,    55,
      56,   715,   716,   718,   717,   719,   722,   724,   867,   723,
     761,   728,   729,   731,   732,   690,   733,   734,   698,   736,
     306,   739,   742,   746,   566,   765,   757,   817,   817,   263,
     762,   763,   263,   766,   854,   777,   774,   385,   747,   789,
     791,   230,   792,   263,   793,   231,   769,   231,   232,   233,
     800,   264,   691,   803,   760,   804,   837,   808,   909,   811,
     862,   818,    62,   870,   768,   819,   821,   781,   823,   824,
     805,   825,   836,   841,   781,   711,   843,    62,   385,   781,
     781,   781,   230,   234,   855,   857,   863,   861,   231,   232,
     233,   235,   869,   872,   879,   854,   880,   873,   874,   875,
     881,   884,   889,   890,   876,   910,   891,   877,   893,   263,
     263,   385,   895,   896,   263,   230,   898,   263,   899,   904,
     905,   231,   232,   233,   234,    57,    58,    59,    60,  -439,
     906,   907,   235,   911,   923,   912,   913,   914,   918,   919,
     781,   920,   921,   922,   931,   902,   902,    77,    78,    79,
     932,    80,   924,    82,    83,    84,   934,   234,   155,   936,
     938,   940,   925,   942,   944,   235,    16,   236,   237,    96,
      38,   238,    72,   239,   240,   241,   706,   704,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   770,   437,   558,
     404,   593,   557,   700,   251,   686,   701,   799,   591,   263,
     802,   801,   487,   578,   359,   737,   787,   730,   236,   237,
     782,   845,   238,   846,   239,   240,   241,   744,   894,   242,
     243,   244,   245,   246,   247,   248,   249,   250,   564,   546,
     903,   659,     0,     0,     0,   251,     0,     0,     0,   439,
       0,   236,   237,     0,     0,   238,     0,   239,   240,   241,
       0,     0,   242,   243,   244,   245,   246,   247,   248,   249,
     250,    44,     0,    45,     0,     0,     0,     0,   251,   231,
     232,    46,     0,    47,    48,     0,     0,     0,    49,    50,
      51,    52,    44,     0,    45,    53,     0,     0,    54,    55,
      56,     0,    46,     0,    47,    48,     0,     0,     0,    49,
      50,    51,    52,    44,     0,    45,    53,     0,     0,    54,
      55,    56,     0,    46,     0,    47,    48,     0,     0,     0,
      49,    50,    51,    52,    44,     0,    45,    53,     0,     0,
      54,    55,    56,     0,    46,     0,    47,    48,     0,     0,
       0,    49,    50,    51,    52,    44,     0,    45,    53,     0,
       0,    54,    55,    56,     0,    46,     0,    47,    48,     0,
       0,     0,    49,    50,    51,    52,    44,     0,    45,    53,
       0,     0,    54,    55,    56,     0,    46,     0,    47,    48,
       0,     0,     0,    49,    50,    51,    52,     0,     0,     0,
      53,     0,     0,    54,    55,    56,     0,     0,     0,     0,
       0,   486,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    57,    58,    59,    60,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   457,   458,     0,     0,     0,    57,    58,    59,    60,
     749,   669,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    57,    58,    59,
      60,   752,   669,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    57,    58,
      59,    60,   753,   669,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    57,
      58,    59,    60,     0,   669,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    44,     0,    45,     0,     0,     0,
      57,    58,    59,    60,    46,     0,    47,    48,     0,     0,
       0,    49,    50,    51,    52,    44,     0,    45,    53,     0,
       0,    54,    55,    56,     0,    46,     0,    47,    48,     0,
       0,     0,    49,    50,    51,    52,   547,     0,    45,    53,
       0,     0,    54,    55,    56,     0,    46,     0,    47,    48,
       0,     0,     0,    49,    50,    51,    52,    44,     0,    45,
      53,     0,     0,    54,    55,    56,     0,    46,     0,    47,
      48,     0,     0,     0,    49,    50,    51,    52,     0,     0,
       0,    53,     0,     0,    54,    55,    56,     0,     0,   230,
       0,     0,     0,     0,     0,   231,   232,   233,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   230,     0,     0,
       0,     0,     0,   231,   232,   233,     0,     0,     0,     0,
       0,   234,     0,     0,     0,     0,     0,     0,     0,   235,
       0,     0,     0,     0,     0,     0,     0,     0,    57,    58,
      59,    60,     0,     0,    77,    78,    79,   230,    80,   234,
      82,    83,    84,   231,   232,   233,     0,   235,   465,    57,
     541,    59,    60,     0,     0,     0,    96,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      57,    58,    59,    60,     0,   230,     0,     0,     0,   234,
       0,   231,   232,   233,     0,     0,     0,   235,     0,     0,
       0,    57,   687,    59,    60,   236,   237,     0,     0,   238,
       0,   239,   240,   241,     0,     0,   242,   243,   244,   245,
     246,   247,   248,   249,   250,     0,     0,   234,     0,     0,
       0,     0,   251,   236,   237,   235,   745,   238,     0,   239,
     240,   241,     0,     0,   242,   243,   244,   245,   246,   247,
     248,   249,   250,     0,     0,   230,     0,     0,     0,     0,
     251,   231,   232,   233,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   236,   237,     0,     0,   238,     0,   239,
     240,   241,     0,     0,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   483,     0,   230,     0,   234,     0,     0,
     251,   231,   232,   233,     0,   235,     0,     0,     0,     0,
       0,   236,   237,     0,     0,   238,     0,   239,   240,   241,
       0,     0,   242,   243,   244,   245,   246,   247,   248,   249,
     250,     0,     0,   684,     0,     0,     0,   234,   251,     0,
       0,     0,     0,     0,     0,   235,   167,   168,   169,   170,
     171,   172,     0,     0,   173,   174,   175,   176,     0,   177,
       0,     0,     0,     0,     0,   178,   179,   180,   181,   182,
       0,   183,   184,   185,   186,   187,   188,     0,     0,     0,
       0,   236,   237,     0,     0,   238,     0,   239,   240,   241,
       0,     0,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   755,     0,     0,     0,     0,     0,     0,   251,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   236,   237,     0,     0,   238,     0,   239,   240,   241,
       0,     0,   242,   243,   244,   245,   246,   247,   248,   249,
     250,     0,    73,     0,     0,     0,     0,    74,   251,    75,
       0,    76,     0,    77,    78,    79,     0,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    90,    91,    92,
      93,    94,    95,     0,     0,    96,    97,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,     0,   125,   126,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   151,     0,     0,
       0,     0,    74,     0,    75,     0,    76,     0,    77,    78,
      79,   127,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,     0,     0,
      96,    97,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
       0,   125,   126,     0,     0,     0,   754,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   167,
     168,   169,   170,   171,   172,     0,   127,   173,   174,   175,
     176,     0,   177,     0,     0,     0,     0,     0,   178,   179,
     180,   181,   182,   286,   183,   184,   185,   186,   187,   188,
       0,     0,     0,     0,     0,   167,   168,   169,   170,   171,
     172,     0,     0,   173,   174,   175,   176,     0,   177,     0,
       0,     0,     0,     0,   178,   179,   180,   181,   182,   414,
     183,   184,   185,   186,   187,   188,     0,     0,     0,     0,
       0,   167,   168,   169,   170,   171,   172,     0,     0,   173,
     174,   175,   176,     0,   177,     0,     0,     0,     0,     0,
     178,   179,   180,   181,   182,   512,   183,   184,   185,   186,
     187,   188,     0,     0,     0,     0,     0,   167,   168,   169,
     170,   171,   172,     0,     0,   173,   174,   175,   176,     0,
     177,     0,     0,     0,     0,     0,   178,   179,   180,   181,
     182,   570,   183,   184,   185,   186,   187,   188,     0,     0,
       0,   167,   168,   169,   170,   171,   172,     0,     0,   173,
     174,   175,   176,     0,   177,     0,     0,     0,     0,     0,
     178,   179,   180,   181,   182,   571,   183,   184,   185,   186,
     187,   188,     0,     0,     0,   167,   168,   169,   170,   171,
     172,     0,     0,   173,   174,   175,   176,     0,   177,     0,
       0,     0,     0,     0,   178,   179,   180,   181,   182,   572,
     183,   184,   185,   186,   187,   188,     0,     0,     0,   167,
     168,   169,   170,   171,   172,     0,     0,   173,   174,   175,
     176,     0,   177,     0,     0,     0,     0,     0,   178,   179,
     180,   181,   182,   573,   183,   184,   185,   186,   187,   188,
       0,     0,     0,   167,   168,   169,   170,   171,   172,     0,
       0,   173,   174,   175,   176,     0,   177,     0,     0,     0,
       0,     0,   178,   179,   180,   181,   182,   574,   183,   184,
     185,   186,   187,   188,     0,     0,     0,   167,   168,   169,
     170,   171,   172,     0,     0,   173,   174,   175,   176,     0,
     177,     0,     0,     0,     0,     0,   178,   179,   180,   181,
     182,   575,   183,   184,   185,   186,   187,   188,     0,     0,
       0,   167,   168,   169,   170,   171,   172,     0,     0,   173,
     174,   175,   176,     0,   177,     0,     0,     0,     0,     0,
     178,   179,   180,   181,   182,   577,   183,   184,   185,   186,
     187,   188,     0,     0,     0,   167,   168,   169,   170,   171,
     172,     0,     0,   173,   174,   175,   176,     0,   177,     0,
       0,     0,     0,     0,   178,   179,   180,   181,   182,   643,
     183,   184,   185,   186,   187,   188,     0,     0,     0,   167,
     168,   169,   170,   171,   172,     0,     0,   173,   174,   175,
     176,     0,   177,     0,     0,     0,     0,     0,   178,   179,
     180,   181,   182,   756,   183,   184,   185,   186,   187,   188,
       0,     0,     0,   167,   168,   169,   170,   171,   172,     0,
       0,   173,   174,   175,   176,     0,   177,     0,     0,     0,
       0,     0,   178,   179,   180,   181,   182,   868,   183,   184,
     185,   186,   187,   188,     0,     0,     0,   167,   168,   169,
     170,   171,   172,     0,     0,   173,   174,   175,   176,     0,
     177,     0,     0,     0,     0,     0,   178,   179,   180,   181,
     182,   289,   183,   184,   185,   186,   187,   188,     0,     0,
     167,   168,   169,   170,   171,   172,     0,     0,   173,   174,
     175,   176,     0,   177,     0,     0,     0,     0,     0,   178,
     179,   180,   181,   182,     0,   183,   184,   185,   186,   187,
     188,   417,     0,     0,     0,     0,     0,   167,   168,   169,
     170,   171,   172,     0,     0,   173,   174,   175,   176,     0,
     177,     0,     0,     0,     0,     0,   178,   179,   180,   181,
     182,     0,   183,   184,   185,   186,   187,   188,   584,     0,
       0,     0,     0,     0,   167,   168,   169,   170,   171,   172,
       0,     0,   173,   174,   175,   176,     0,   177,     0,     0,
       0,     0,     0,   178,   179,   180,   181,   182,     0,   183,
     184,   185,   186,   187,   188,   892,     0,     0,     0,     0,
       0,   167,   168,   169,   170,   171,   172,     0,     0,   173,
     174,   175,   176,     0,   177,     0,     0,     0,     0,     0,
     178,   179,   180,   181,   182,     0,   183,   184,   185,   186,
     187,   188,   167,   168,   169,   170,   171,   172,     0,     0,
     173,   174,   175,   176,     0,   177,     0,     0,     0,     0,
       0,   178,   179,   180,   181,   182,     0,   183,   184,   185,
     186,   187,   188,   168,   169,   170,   171,   172,     0,     0,
     173,   174,   175,   176,     0,   177,     0,     0,     0,     0,
       0,   178,   179,   180,   181,   182,     0,   183,   184,   185,
     186,   187,   188
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-718)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
      34,    18,    44,   306,    63,    80,    81,   125,   126,    78,
     547,    45,    37,    38,   165,   531,     7,   236,    81,    37,
      38,   250,   574,    37,    38,    42,     5,    37,    38,   248,
      37,    38,   418,    74,    79,    83,    84,    37,    38,    75,
       5,    18,   193,    65,     7,     5,   197,    45,    96,    12,
     125,   126,   236,   237,     5,    37,    38,     6,     5,     7,
       7,     5,   234,    23,   248,   249,    23,     5,    15,     7,
     420,   232,   789,   534,     9,   221,   537,    15,   539,    17,
      18,     3,   792,     5,    22,    23,    24,    25,    17,    18,
     361,    29,    12,   788,    32,    33,    34,   127,    28,   269,
     136,     4,     9,     0,   274,    12,   136,    10,   278,   380,
      30,    31,    42,     5,   630,   145,    78,    79,    47,   635,
       4,    28,   160,    15,   242,    78,    79,    11,   162,    12,
     276,   165,    94,   167,   152,    42,     9,    72,    73,   834,
     835,    94,     5,   165,     7,    28,     9,   216,     6,   218,
     219,   861,   152,    11,   373,   189,   231,   232,   192,   193,
     109,   236,   237,   197,   162,   335,   338,   242,   352,   160,
     152,   322,     8,   248,   249,    11,   327,   527,   223,    71,
     157,   256,   135,    75,   570,   221,   165,   166,   160,   373,
     351,   577,   909,   910,   192,   160,   230,   160,   125,   126,
     160,   717,   739,   160,   756,   160,   247,   924,   925,   160,
     161,   162,   160,   160,   161,   162,   160,   161,   162,    92,
      93,   159,   160,   161,   162,   163,     5,   530,   568,    92,
      93,   401,   230,     5,   309,    14,   272,   273,   578,     3,
     276,   392,     5,     6,   362,   137,   309,    11,    11,     5,
     553,   326,   286,     9,   288,   289,    12,   601,     4,   603,
      16,   279,   723,   381,    10,   416,   844,   728,   419,    30,
      31,   732,   733,   734,   852,   791,   351,   352,     3,   279,
     858,   859,     3,   669,     3,     5,    11,   362,   322,     4,
      11,   289,    11,   327,     3,    10,   833,   279,   373,     3,
       3,    72,    73,    74,     3,    76,   381,    11,    11,   236,
     237,     6,    11,     3,   356,   242,    11,     3,   502,   897,
     354,   248,   249,    94,    95,    11,   731,     9,     3,   256,
      12,   400,   366,   367,   368,   369,    11,   371,   372,   568,
     374,     8,   561,   418,    11,     6,   862,   395,   382,   578,
      11,   888,    85,    86,     3,   389,   390,   391,   392,   393,
     746,   747,    11,   154,   155,   751,    99,   100,   101,   102,
     103,   104,   105,   106,   911,     3,    86,   561,   447,     3,
     414,   532,   416,    11,   382,   419,   923,    11,    30,    31,
     100,   389,   102,   930,   104,   393,   106,   934,   160,   936,
     434,   938,   160,   940,   555,   942,   811,     3,     3,   527,
     452,    59,    60,   818,    62,    11,    11,   434,   823,   824,
     825,   160,    72,    73,    74,   352,    76,   502,    78,    79,
      80,     3,   583,   736,   468,   362,    47,    48,     6,    11,
       3,     3,     3,    11,    94,   493,   373,    85,    11,    11,
      11,     9,   527,   487,   381,   503,   574,   575,   536,     6,
     538,    99,     5,   101,    11,   103,     3,   105,    50,    51,
      52,    53,    54,    55,    56,     6,     6,     6,   512,   884,
      11,    11,    11,     6,     6,     6,   561,   546,    11,    11,
      11,   418,     6,     9,   160,   570,    12,    11,   532,   574,
     575,     8,   577,   670,    11,   547,   673,   674,    35,    36,
      37,    38,   546,     9,   535,   536,    12,   538,   163,   542,
     160,   555,   545,    96,    97,    98,    10,    11,     5,   546,
      17,    18,   566,    37,    38,   754,     5,   571,   572,   573,
     572,   573,   576,   568,   154,   155,   156,   581,   666,   583,
     568,   160,   160,   578,   568,   589,   590,   160,   568,     9,
     578,   568,   680,   597,   578,     5,   160,   718,   578,   720,
     754,   578,     5,   162,     6,   502,     6,   162,     3,   160,
     160,     9,     9,    14,     4,   160,     5,     5,     5,     5,
       5,   666,     5,     5,   669,     5,     4,     3,     5,     3,
     527,   160,     5,     4,   161,   680,   161,     4,    10,     3,
     644,   160,     5,     5,   656,     6,     6,    28,     6,     3,
     160,     3,    11,   640,    11,     3,    12,     3,    28,     3,
       3,     3,   160,    47,   561,   160,   670,     5,    64,   673,
     674,   160,    11,   570,     9,     5,     5,   574,   575,    48,
     577,     5,     5,     5,     5,   806,     4,   160,     3,     6,
     165,     5,     4,   160,     5,     5,     5,    28,    63,    67,
     821,   746,   747,     8,    10,     6,   751,    10,     6,   754,
       3,     5,    11,     7,   718,     6,   720,    11,    12,     6,
       3,    15,     3,    17,    18,   729,   158,   731,    22,    23,
      24,    25,   777,    65,     4,    29,     4,   165,    32,    33,
      34,    69,     6,     9,    11,     6,     9,   160,   836,    11,
       6,    11,    11,    11,    11,   759,    11,    11,   762,     5,
       5,    11,    10,   138,   109,     3,    10,   812,   813,   666,
      11,    11,   669,   165,   819,    40,   167,     3,     4,    28,
       5,     7,     5,   680,     6,    13,   165,    13,    14,    15,
       5,   836,    12,     4,   160,     3,   800,    10,    28,    11,
      47,    11,   806,    10,   157,    11,    11,   811,    11,    11,
     165,    11,     6,     6,   818,   165,   167,   821,     3,   823,
     824,   825,     7,    49,     6,     6,     3,    48,    13,    14,
      15,    57,     3,     6,     3,   880,    11,   164,   164,   164,
       3,    11,     4,     4,   164,    28,     6,   851,     6,   746,
     747,     3,     6,     6,   751,     7,     6,   754,     6,     3,
       3,    13,    14,    15,    49,   159,   160,   161,   162,   163,
       3,     3,    57,    11,    11,     6,     6,     6,     6,     6,
     884,     3,     3,     3,     3,   889,   890,    72,    73,    74,
       3,    76,    28,    78,    79,    80,    11,    49,    43,    11,
      11,    11,    28,    11,     6,    57,    11,   133,   134,    94,
      27,   137,    36,   139,   140,   141,   603,   601,   144,   145,
     146,   147,   148,   149,   150,   151,   152,   713,   321,   451,
     279,   502,   450,   596,   160,   588,   597,   759,   500,   836,
     763,   762,   390,   482,   233,   642,   736,   635,   133,   134,
     730,   812,   137,   813,   139,   140,   141,   657,   880,   144,
     145,   146,   147,   148,   149,   150,   151,   152,   458,   434,
     890,   566,    -1,    -1,    -1,   160,    -1,    -1,    -1,   326,
      -1,   133,   134,    -1,    -1,   137,    -1,   139,   140,   141,
      -1,    -1,   144,   145,   146,   147,   148,   149,   150,   151,
     152,     5,    -1,     7,    -1,    -1,    -1,    -1,   160,    13,
      14,    15,    -1,    17,    18,    -1,    -1,    -1,    22,    23,
      24,    25,     5,    -1,     7,    29,    -1,    -1,    32,    33,
      34,    -1,    15,    -1,    17,    18,    -1,    -1,    -1,    22,
      23,    24,    25,     5,    -1,     7,    29,    -1,    -1,    32,
      33,    34,    -1,    15,    -1,    17,    18,    -1,    -1,    -1,
      22,    23,    24,    25,     5,    -1,     7,    29,    -1,    -1,
      32,    33,    34,    -1,    15,    -1,    17,    18,    -1,    -1,
      -1,    22,    23,    24,    25,     5,    -1,     7,    29,    -1,
      -1,    32,    33,    34,    -1,    15,    -1,    17,    18,    -1,
      -1,    -1,    22,    23,    24,    25,     5,    -1,     7,    29,
      -1,    -1,    32,    33,    34,    -1,    15,    -1,    17,    18,
      -1,    -1,    -1,    22,    23,    24,    25,    -1,    -1,    -1,
      29,    -1,    -1,    32,    33,    34,    -1,    -1,    -1,    -1,
      -1,   145,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   159,   160,   161,   162,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   154,   155,    -1,    -1,    -1,   159,   160,   161,   162,
     142,   143,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,   160,   161,
     162,   142,   143,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,   160,
     161,   162,   142,   143,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,
     160,   161,   162,    -1,   143,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     5,    -1,     7,    -1,    -1,    -1,
     159,   160,   161,   162,    15,    -1,    17,    18,    -1,    -1,
      -1,    22,    23,    24,    25,     5,    -1,     7,    29,    -1,
      -1,    32,    33,    34,    -1,    15,    -1,    17,    18,    -1,
      -1,    -1,    22,    23,    24,    25,     5,    -1,     7,    29,
      -1,    -1,    32,    33,    34,    -1,    15,    -1,    17,    18,
      -1,    -1,    -1,    22,    23,    24,    25,     5,    -1,     7,
      29,    -1,    -1,    32,    33,    34,    -1,    15,    -1,    17,
      18,    -1,    -1,    -1,    22,    23,    24,    25,    -1,    -1,
      -1,    29,    -1,    -1,    32,    33,    34,    -1,    -1,     7,
      -1,    -1,    -1,    -1,    -1,    13,    14,    15,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     7,    -1,    -1,
      -1,    -1,    -1,    13,    14,    15,    -1,    -1,    -1,    -1,
      -1,    49,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    57,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,   160,
     161,   162,    -1,    -1,    72,    73,    74,     7,    76,    49,
      78,    79,    80,    13,    14,    15,    -1,    57,    58,   159,
     160,   161,   162,    -1,    -1,    -1,    94,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     159,   160,   161,   162,    -1,     7,    -1,    -1,    -1,    49,
      -1,    13,    14,    15,    -1,    -1,    -1,    57,    -1,    -1,
      -1,   159,   160,   161,   162,   133,   134,    -1,    -1,   137,
      -1,   139,   140,   141,    -1,    -1,   144,   145,   146,   147,
     148,   149,   150,   151,   152,    -1,    -1,    49,    -1,    -1,
      -1,    -1,   160,   133,   134,    57,    58,   137,    -1,   139,
     140,   141,    -1,    -1,   144,   145,   146,   147,   148,   149,
     150,   151,   152,    -1,    -1,     7,    -1,    -1,    -1,    -1,
     160,    13,    14,    15,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   133,   134,    -1,    -1,   137,    -1,   139,
     140,   141,    -1,    -1,   144,   145,   146,   147,   148,   149,
     150,   151,   152,   153,    -1,     7,    -1,    49,    -1,    -1,
     160,    13,    14,    15,    -1,    57,    -1,    -1,    -1,    -1,
      -1,   133,   134,    -1,    -1,   137,    -1,   139,   140,   141,
      -1,    -1,   144,   145,   146,   147,   148,   149,   150,   151,
     152,    -1,    -1,     3,    -1,    -1,    -1,    49,   160,    -1,
      -1,    -1,    -1,    -1,    -1,    57,    16,    17,    18,    19,
      20,    21,    -1,    -1,    24,    25,    26,    27,    -1,    29,
      -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,    39,
      -1,    41,    42,    43,    44,    45,    46,    -1,    -1,    -1,
      -1,   133,   134,    -1,    -1,   137,    -1,   139,   140,   141,
      -1,    -1,   144,   145,   146,   147,   148,   149,   150,   151,
     152,   153,    -1,    -1,    -1,    -1,    -1,    -1,   160,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   133,   134,    -1,    -1,   137,    -1,   139,   140,   141,
      -1,    -1,   144,   145,   146,   147,   148,   149,   150,   151,
     152,    -1,    61,    -1,    -1,    -1,    -1,    66,   160,    68,
      -1,    70,    -1,    72,    73,    74,    -1,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    85,    86,    87,    88,
      89,    90,    91,    -1,    -1,    94,    95,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,    -1,   135,   136,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    61,    -1,    -1,
      -1,    -1,    66,    -1,    68,    -1,    70,    -1,    72,    73,
      74,   160,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,    -1,    -1,
      94,    95,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,   133,
      -1,   135,   136,    -1,    -1,    -1,     3,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    16,
      17,    18,    19,    20,    21,    -1,   160,    24,    25,    26,
      27,    -1,    29,    -1,    -1,    -1,    -1,    -1,    35,    36,
      37,    38,    39,     4,    41,    42,    43,    44,    45,    46,
      -1,    -1,    -1,    -1,    -1,    16,    17,    18,    19,    20,
      21,    -1,    -1,    24,    25,    26,    27,    -1,    29,    -1,
      -1,    -1,    -1,    -1,    35,    36,    37,    38,    39,     4,
      41,    42,    43,    44,    45,    46,    -1,    -1,    -1,    -1,
      -1,    16,    17,    18,    19,    20,    21,    -1,    -1,    24,
      25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    36,    37,    38,    39,     4,    41,    42,    43,    44,
      45,    46,    -1,    -1,    -1,    -1,    -1,    16,    17,    18,
      19,    20,    21,    -1,    -1,    24,    25,    26,    27,    -1,
      29,    -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,
      39,     6,    41,    42,    43,    44,    45,    46,    -1,    -1,
      -1,    16,    17,    18,    19,    20,    21,    -1,    -1,    24,
      25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    36,    37,    38,    39,     6,    41,    42,    43,    44,
      45,    46,    -1,    -1,    -1,    16,    17,    18,    19,    20,
      21,    -1,    -1,    24,    25,    26,    27,    -1,    29,    -1,
      -1,    -1,    -1,    -1,    35,    36,    37,    38,    39,     6,
      41,    42,    43,    44,    45,    46,    -1,    -1,    -1,    16,
      17,    18,    19,    20,    21,    -1,    -1,    24,    25,    26,
      27,    -1,    29,    -1,    -1,    -1,    -1,    -1,    35,    36,
      37,    38,    39,     6,    41,    42,    43,    44,    45,    46,
      -1,    -1,    -1,    16,    17,    18,    19,    20,    21,    -1,
      -1,    24,    25,    26,    27,    -1,    29,    -1,    -1,    -1,
      -1,    -1,    35,    36,    37,    38,    39,     6,    41,    42,
      43,    44,    45,    46,    -1,    -1,    -1,    16,    17,    18,
      19,    20,    21,    -1,    -1,    24,    25,    26,    27,    -1,
      29,    -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,
      39,     6,    41,    42,    43,    44,    45,    46,    -1,    -1,
      -1,    16,    17,    18,    19,    20,    21,    -1,    -1,    24,
      25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    36,    37,    38,    39,     6,    41,    42,    43,    44,
      45,    46,    -1,    -1,    -1,    16,    17,    18,    19,    20,
      21,    -1,    -1,    24,    25,    26,    27,    -1,    29,    -1,
      -1,    -1,    -1,    -1,    35,    36,    37,    38,    39,     6,
      41,    42,    43,    44,    45,    46,    -1,    -1,    -1,    16,
      17,    18,    19,    20,    21,    -1,    -1,    24,    25,    26,
      27,    -1,    29,    -1,    -1,    -1,    -1,    -1,    35,    36,
      37,    38,    39,     6,    41,    42,    43,    44,    45,    46,
      -1,    -1,    -1,    16,    17,    18,    19,    20,    21,    -1,
      -1,    24,    25,    26,    27,    -1,    29,    -1,    -1,    -1,
      -1,    -1,    35,    36,    37,    38,    39,     6,    41,    42,
      43,    44,    45,    46,    -1,    -1,    -1,    16,    17,    18,
      19,    20,    21,    -1,    -1,    24,    25,    26,    27,    -1,
      29,    -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,
      39,     7,    41,    42,    43,    44,    45,    46,    -1,    -1,
      16,    17,    18,    19,    20,    21,    -1,    -1,    24,    25,
      26,    27,    -1,    29,    -1,    -1,    -1,    -1,    -1,    35,
      36,    37,    38,    39,    -1,    41,    42,    43,    44,    45,
      46,    10,    -1,    -1,    -1,    -1,    -1,    16,    17,    18,
      19,    20,    21,    -1,    -1,    24,    25,    26,    27,    -1,
      29,    -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,
      39,    -1,    41,    42,    43,    44,    45,    46,    10,    -1,
      -1,    -1,    -1,    -1,    16,    17,    18,    19,    20,    21,
      -1,    -1,    24,    25,    26,    27,    -1,    29,    -1,    -1,
      -1,    -1,    -1,    35,    36,    37,    38,    39,    -1,    41,
      42,    43,    44,    45,    46,    10,    -1,    -1,    -1,    -1,
      -1,    16,    17,    18,    19,    20,    21,    -1,    -1,    24,
      25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    36,    37,    38,    39,    -1,    41,    42,    43,    44,
      45,    46,    16,    17,    18,    19,    20,    21,    -1,    -1,
      24,    25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,
      -1,    35,    36,    37,    38,    39,    -1,    41,    42,    43,
      44,    45,    46,    17,    18,    19,    20,    21,    -1,    -1,
      24,    25,    26,    27,    -1,    29,    -1,    -1,    -1,    -1,
      -1,    35,    36,    37,    38,    39,    -1,    41,    42,    43,
      44,    45,    46
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,   169,   170,     0,    59,    60,    62,   171,   173,   184,
     160,   160,   160,     5,   174,   175,   174,     5,     7,    12,
     160,   176,   177,   178,   179,   181,     3,     3,   160,   227,
     180,   181,   160,   182,     9,     6,    11,   172,   172,     6,
      11,     8,    11,     5,     5,     7,    15,    17,    18,    22,
      23,    24,    25,    29,    32,    33,    34,   159,   160,   161,
     162,   333,   337,   338,   340,   341,   343,   344,   345,   346,
     347,   348,   177,    61,    66,    68,    70,    72,    73,    74,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    90,    91,    94,    95,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   127,   128,
     129,   130,   131,   132,   133,   135,   136,   160,   183,   204,
     206,   212,   213,   214,   215,   216,   217,   220,   221,   222,
     223,   224,   225,   226,   243,   244,   249,   256,   267,   268,
     287,    61,     3,   160,   181,   178,   335,   337,   336,   337,
     160,   286,     5,    12,   342,     4,    10,    16,    17,    18,
      19,    20,    21,    24,    25,    26,    27,    29,    35,    36,
      37,    38,    39,    41,    42,    43,    44,    45,    46,   339,
     340,   163,     5,     9,    12,   160,   205,     9,    72,    73,
     207,   208,   241,   288,   160,   228,   229,   230,   231,   227,
     228,   160,   291,   292,   348,   291,   240,   241,   240,   240,
       5,   234,   235,   240,   160,   232,   233,     5,   236,   237,
       7,    13,    14,    15,    49,    57,   133,   134,   137,   139,
     140,   141,   144,   145,   146,   147,   148,   149,   150,   151,
     152,   160,   205,   271,   273,   274,   275,   278,   279,   283,
     284,   285,   332,   344,   348,   351,   352,   271,    14,   236,
     257,   258,    92,    93,   218,   219,   236,   241,   236,   185,
     186,   213,   214,   220,     6,     6,     4,     8,    11,     7,
     336,   337,   162,    30,    31,   333,   337,   337,   162,   336,
     333,   337,   160,     3,   333,   160,     5,    15,    71,    75,
     137,   289,   290,   293,   294,   306,   321,   325,   326,   330,
       3,    11,     9,     3,     3,     3,    11,    28,     3,   227,
     227,   227,    96,    97,    98,   218,   228,     3,    11,    85,
      86,    99,   100,   101,   102,   103,   104,   105,   106,   238,
     239,    14,   349,   350,     5,   348,     5,   343,   348,   286,
     233,     4,   270,   272,   332,   332,     5,     5,     5,     5,
     271,     5,     5,     5,     5,   160,   205,   280,   272,   332,
       4,   270,     5,     3,     3,     3,   269,   271,     3,     5,
      28,    42,     9,     5,   349,   160,   259,   260,   241,   241,
     349,   218,   349,   135,   186,   187,   188,   337,   337,   336,
       6,   161,   161,    10,     4,     6,     4,    10,   209,     4,
       3,   160,   295,   297,   298,   301,    50,    51,    52,    53,
      54,    55,    56,   291,     5,    28,     5,   229,   333,   292,
     333,     3,     3,     3,     6,     6,     6,   349,     3,   233,
      11,    11,     5,   343,   348,   242,   272,   154,   155,   337,
     353,   335,     3,   160,   280,    58,   271,     3,    28,     3,
     337,   337,   337,   337,   337,   337,   272,   337,     3,     3,
       3,     3,   280,   153,   336,   336,   145,   275,   337,   337,
     333,   337,   336,   160,   250,   251,   252,   253,   240,     3,
      11,   227,   349,   160,   245,   246,   247,   248,   160,   189,
      64,   190,     4,     8,   337,   333,   211,   212,   213,   214,
     215,   220,   221,   222,   223,   269,   333,   210,   211,    48,
      11,    47,     9,     5,     5,     5,     5,     5,     5,     5,
       3,   160,   181,   322,   331,   337,   338,     5,   303,   304,
     335,   154,   155,   328,   329,     4,   227,   239,   238,   335,
       3,    11,   160,   354,   354,     6,   109,     6,   281,   337,
       6,     6,     6,     6,     6,     6,     3,     6,   281,     6,
       6,     5,   337,     4,    10,     6,   240,     3,    11,     5,
       5,   260,     3,   242,   240,     3,    11,     5,    28,   165,
     191,   192,   193,   194,   195,   196,   197,   198,   202,   203,
      63,   337,     8,    10,    67,    10,   211,   271,   160,   296,
     299,   300,   302,   298,   300,   333,   154,   155,   156,   307,
     310,   311,   312,   307,   309,   311,   309,   307,   309,   307,
     339,     6,     6,     6,   339,   181,   337,   340,   304,   335,
       3,   298,   333,     3,     6,     6,    11,   334,   272,   353,
     212,   220,   221,   222,   223,   224,   270,   282,   269,   143,
     276,   277,   336,   276,   276,   271,   352,   271,   337,   269,
     270,     3,     3,   337,     3,   333,   251,   160,   254,   255,
     337,    12,   261,   262,   263,   264,   265,   266,   337,     3,
     246,   254,   158,    65,   193,   197,   195,   197,     4,     4,
       5,   165,   166,   199,   165,    69,     6,    11,     9,     6,
       4,    10,     9,    11,   160,   298,   300,   308,    11,    11,
     308,    11,    11,    11,    11,   181,     5,   294,   337,    11,
      47,    48,    10,   335,   334,    58,   138,     4,   269,   142,
     277,     4,   142,   142,     3,   153,     6,    10,     6,    11,
     160,     6,    11,    11,     6,     3,   165,   200,   157,   165,
     202,   300,   333,   333,   167,   313,   307,    40,   314,   307,
     318,   337,   314,   318,   307,   307,   307,   295,   298,    28,
     304,     5,     5,     6,   269,   269,   269,   272,   352,   255,
       5,   264,   266,     4,     3,   165,     4,    10,    10,    10,
      11,    11,     5,    23,   315,   316,   317,   348,    11,    11,
     319,    11,   305,    11,    11,    11,    17,    18,   323,   324,
     323,   303,     6,    11,   300,   296,     6,   337,    18,   157,
     201,     6,   333,   167,   318,   316,   317,    35,    36,    37,
      38,     9,   318,   320,   348,     6,   333,     6,   318,   318,
     318,    48,    47,     3,   304,   323,   323,   271,     6,     3,
      10,   319,     6,   164,   164,   164,   164,   337,   319,     3,
      11,     3,   319,   319,    11,   296,   300,     6,    11,     4,
       4,     6,    10,     6,   320,     6,     6,   318,     6,     6,
     304,   327,   337,   327,     3,     3,     3,     3,   319,    28,
      28,    11,     6,     6,     6,   303,   303,   304,     6,     6,
       3,     3,     3,    11,    28,    28,   304,   303,   303,     6,
      11,     3,     3,   304,    11,   304,    11,   304,    11,   304,
      11,   304,    11,   304,     6
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))

/* Error token number */
#define YYTERROR	1
#define YYERRCODE	256


/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - Assume YYFAIL is not used.  It's too flawed to consider.  See
       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
       for details.  YYERROR is fine as it does not invoke this
       function.
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YYUSE (yytype);
}




/* The lookahead symbol.  */
int yychar;


#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);

/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
      
/* Line 1787 of yacc.c  */
#line 2873 "y.tab.c"
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


/* Line 2050 of yacc.c  */
#line 979 "verilog.yacc"


main()
{
    yydebug = 1;
	return(yyparse());
}

int yywrap()
{
    return 1;
}
