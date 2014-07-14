/* A Bison parser, made by GNU Bison 2.7.1.  */

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
#define YYBISON_VERSION "2.7.1"

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
#line 1 "vhdl_ast.yacc"


#include <iostream>
#include <fstream>
#include <string>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>

#include "node.h"

extern FILE * yyin;
extern node_t * ast;

extern "C" {
    int yylex(void);
    int yywrap();
    int yyerror(const char *str);
}

node_t * new_node(std::string const & s) {
    node_t * n = new node_t;
    n->label = s;
    return n;
}

void add_child(node_t * n, node_t * c) {
    n->children.push_back(c);
}

node_t * node(std::string const & s, node_t * n1, node_t * n2) {
//    fprintf(stderr,"creating new node with label %s\n",s);
    node_t * n = new_node(s);
    add_child(n, n1);
    add_child(n, n2);
    return n;
}

void print_tree(std::ofstream & file, node_t * n, int depth) {

    size_t num_children = n->children.size();

    for(size_t i=0; i < num_children; i++) {
        if(n->children[i] != NULL) {
            file << n->label << "_" << n << " -> ";;
            if(isdigit(n->children[i]->label[0]))
                file << "c"; 
            file << n->children[i]->label << "_" << n->children[i] << ";\n";
            print_tree(file,n->children[i], depth+1);
        }
    }
}

void print_graph(node_t * n) {
    char filename[] = "graph.gv";

    std::ofstream file;
    file.open(filename);

    if(!file.is_open()) {
        std::cerr << "error: cannot write to file " << filename << std::endl;
        exit(1);
    }
    file <<  "digraph G {\n";
    print_tree(file,n,0);
    file << "}\n";
    file.close();
}




/* Line 371 of yacc.c  */
#line 144 "y.tab.c"

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

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
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
     LTEQ = 258,
     EQGT = 259,
     NEQ = 260,
     IDENT = 261,
     NUMBER = 262,
     DIGIT = 263,
     STRING = 264,
     USE = 265,
     LIBRARY = 266,
     ENTITY = 267,
     ARCHITECTURE = 268,
     ATTRIBUTE = 269,
     IS = 270,
     OF = 271,
     PORT = 272,
     GENERIC = 273,
     MAP = 274,
     END = 275,
     TO = 276,
     SIGNAL = 277,
     IN = 278,
     OUT = 279,
     INOUT = 280,
     _BEGIN_ = 281,
     NOT = 282,
     AND = 283,
     NAND = 284,
     OR = 285,
     NOR = 286,
     XOR = 287,
     XNOR = 288
   };
#endif
/* Tokens.  */
#define LTEQ 258
#define EQGT 259
#define NEQ 260
#define IDENT 261
#define NUMBER 262
#define DIGIT 263
#define STRING 264
#define USE 265
#define LIBRARY 266
#define ENTITY 267
#define ARCHITECTURE 268
#define ATTRIBUTE 269
#define IS 270
#define OF 271
#define PORT 272
#define GENERIC 273
#define MAP 274
#define END 275
#define TO 276
#define SIGNAL 277
#define IN 278
#define OUT 279
#define INOUT 280
#define _BEGIN_ 281
#define NOT 282
#define AND 283
#define NAND 284
#define OR 285
#define NOR 286
#define XOR 287
#define XNOR 288



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

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 276 "y.tab.c"

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
#define YYLAST   175

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  50
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  43
/* YYNRULES -- Number of rules.  */
#define YYNRULES  86
/* YYNRULES -- Number of states.  */
#define YYNSTATES  161

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   288

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    44,     2,
      11,    12,     2,    45,     3,    46,     4,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     6,     5,
      49,    47,    48,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     9,     2,    10,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     7,     2,     8,     2,     2,     2,     2,
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
       2,     2,     2,     2,     2,     2,     1,     2,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     6,     9,    12,    15,    18,    31,
      32,    34,    36,    40,    46,    48,    50,    52,    53,    55,
      56,    58,    60,    62,    66,    72,    73,    76,    86,    88,
      90,    92,    94,   106,   107,   110,   117,   119,   123,   125,
     126,   129,   132,   137,   140,   141,   143,   145,   149,   154,
     156,   158,   160,   163,   167,   171,   173,   175,   177,   179,
     181,   183,   185,   187,   189,   191,   193,   195,   197,   199,
     201,   203,   217,   218,   224,   226,   227,   229,   231,   235,
     240,   244,   248,   250,   254,   256,   258
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      51,     0,    -1,    52,    -1,    -1,    52,    53,    -1,    52,
      67,    -1,    52,    89,    -1,    52,    90,    -1,    22,    16,
      25,    27,    11,    54,    12,     5,    63,    30,    16,     5,
      -1,    -1,    55,    -1,    56,    -1,    55,     5,    56,    -1,
      16,     6,    57,    16,    58,    -1,    33,    -1,    34,    -1,
      35,    -1,    -1,    62,    -1,    -1,    60,    -1,    61,    -1,
      62,    -1,    11,    17,    12,    -1,    11,    17,    31,    17,
      12,    -1,    -1,    63,    64,    -1,    24,    16,    26,    16,
       6,    65,    25,    66,     5,    -1,    22,    -1,    32,    -1,
      16,    -1,    92,    -1,    23,    16,    26,    16,    25,    68,
      36,    71,    30,    16,     5,    -1,    -1,    68,    69,    -1,
      32,    70,     6,    16,    58,     5,    -1,    16,    -1,    70,
       3,    16,    -1,    72,    -1,    -1,    72,    73,    -1,    72,
      83,    -1,    74,    13,    78,     5,    -1,    16,    59,    -1,
      -1,    76,    -1,    78,    -1,    76,     3,    78,    -1,    16,
      11,    75,    12,    -1,    92,    -1,    74,    -1,    77,    -1,
      79,    78,    -1,    78,    80,    78,    -1,    11,    78,    12,
      -1,    37,    -1,    81,    -1,    82,    -1,    38,    -1,    39,
      -1,    40,    -1,    41,    -1,    42,    -1,    43,    -1,    44,
      -1,    45,    -1,    46,    -1,    47,    -1,    48,    -1,    49,
      -1,    15,    -1,    16,     6,    22,    16,     4,    16,    84,
      27,    29,    11,    86,    12,     5,    -1,    -1,    28,    29,
      11,    85,    12,    -1,    86,    -1,    -1,    87,    -1,    88,
      -1,    87,     3,    88,    -1,    78,    58,    14,    78,    -1,
      21,    70,     5,    -1,    20,    91,     5,    -1,    16,    -1,
      91,     4,    16,    -1,    19,    -1,    17,    -1,    18,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    89,    89,    94,    95,    97,    99,   101,   106,   116,
     117,   122,   127,   135,   140,   142,   144,   149,   150,   155,
     156,   161,   163,   168,   173,   178,   179,   187,   192,   194,
     199,   201,   206,   216,   217,   225,   235,   240,   248,   253,
     254,   259,   267,   272,   277,   278,   283,   288,   296,   302,
     304,   306,   308,   310,   318,   323,   328,   330,   335,   337,
     339,   341,   343,   345,   347,   349,   351,   356,   358,   360,
     362,   367,   379,   380,   386,   391,   392,   397,   402,   410,
     415,   423,   428,   431,   436,   437,   438
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "','", "'.'", "';'", "':'", "'{'", "'}'",
  "'['", "']'", "'('", "')'", "LTEQ", "EQGT", "NEQ", "IDENT", "NUMBER",
  "DIGIT", "STRING", "USE", "LIBRARY", "ENTITY", "ARCHITECTURE",
  "ATTRIBUTE", "IS", "OF", "PORT", "GENERIC", "MAP", "END", "TO", "SIGNAL",
  "IN", "OUT", "INOUT", "_BEGIN_", "NOT", "AND", "NAND", "OR", "NOR",
  "XOR", "XNOR", "'&'", "'+'", "'-'", "'='", "'>'", "'<'", "$accept",
  "root", "list_of_entity_arch_lib_use", "entity_def", "port_list_opt",
  "port_list", "port", "direction", "bit_range_opt", "bit_slice_opt",
  "bit_slice", "bit_index", "bit_range", "attribute_list", "attribute",
  "entity_or_signal", "ident_or_literal", "arch_def", "signal_list",
  "signal_decl", "ident_list", "arch_body", "list_of_assign_or_inst",
  "assign", "signal_opt_vector", "expr_list_opt", "expr_list",
  "func_invocation", "expr", "unary_boolean_op", "binary_op",
  "binary_boolean_op", "relational_op", "instantiation", "generic_map_opt",
  "generic_map_list", "port_map_list_opt", "port_map_list", "port_map",
  "lib_stm", "use_stm", "ident_period_list", "literal", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,    44,    46,    59,    58,   123,   125,    91,
      93,    40,    41,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,    38,    43,    45,    61,    62,    60
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    50,    51,    52,    52,    52,    52,    52,    53,    54,
      54,    55,    55,    56,    57,    57,    57,    58,    58,    59,
      59,    60,    60,    61,    62,    63,    63,    64,    65,    65,
      66,    66,    67,    68,    68,    69,    70,    70,    71,    72,
      72,    72,    73,    74,    75,    75,    76,    76,    77,    78,
      78,    78,    78,    78,    78,    79,    80,    80,    81,    81,
      81,    81,    81,    81,    81,    81,    81,    82,    82,    82,
      82,    83,    84,    84,    85,    86,    86,    87,    87,    88,
      89,    90,    91,    91,    92,    92,    92
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     2,     2,     2,     2,    12,     0,
       1,     1,     3,     5,     1,     1,     1,     0,     1,     0,
       1,     1,     1,     3,     5,     0,     2,     9,     1,     1,
       1,     1,    11,     0,     2,     6,     1,     3,     1,     0,
       2,     2,     4,     2,     0,     1,     1,     3,     4,     1,
       1,     1,     2,     3,     3,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,    13,     0,     5,     1,     0,     1,     1,     3,     4,
       3,     3,     1,     3,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,     0,     2,     1,     0,     0,     0,     0,     4,     5,
       6,     7,    82,     0,    36,     0,     0,     0,     0,    81,
       0,    80,     0,     0,    83,    37,     0,     0,     9,    33,
       0,     0,    10,    11,     0,     0,     0,     0,     0,    39,
      34,    14,    15,    16,     0,    25,    12,     0,     0,    38,
      17,     0,     0,     0,    19,    40,     0,    41,     0,    13,
      18,     0,     0,    26,    17,     0,     0,     0,    43,    20,
      21,    22,     0,     0,     0,     0,     0,    32,     0,     0,
       0,    19,    85,    86,    84,    55,    50,    51,     0,     0,
      49,     0,     0,     8,    35,     0,    23,     0,    44,    42,
      70,    58,    59,    60,    61,    62,    63,    64,    65,    66,
      67,    68,    69,     0,    56,    57,    52,     0,     0,     0,
      54,    85,     0,    45,    46,    53,    24,     0,    72,    48,
       0,    28,    29,     0,     0,     0,    47,     0,     0,     0,
      30,     0,    31,    75,     0,    27,    17,     0,    74,    76,
      77,    75,     0,    73,     0,     0,     0,    78,     0,    79,
      71
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     8,    31,    32,    33,    44,    59,    68,
      69,    70,    60,    51,    63,   133,   141,     9,    34,    40,
      15,    48,    49,    55,    86,   122,   123,    87,   146,    89,
     113,   114,   115,    57,   135,   147,   148,   149,   150,    10,
      11,    13,    90
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -73
static const yytype_int16 yypact[] =
{
     -73,     5,    43,   -73,    -2,    12,    44,    45,   -73,   -73,
     -73,   -73,   -73,    20,   -73,    17,    46,    49,    56,   -73,
      57,   -73,    50,    60,   -73,   -73,    67,    54,    64,   -73,
      75,    70,   105,   -73,   -21,    22,   106,    64,    12,   -73,
     -73,   -73,   -73,   -73,    96,   -73,   -73,    15,    92,   107,
     113,   -14,   109,   110,     1,   -73,   114,   -73,   111,   -73,
     -73,   115,   116,   -73,   113,   124,   108,   117,   -73,   -73,
     -73,   -73,    98,   112,   118,   128,   131,   -73,   121,    -8,
      98,   127,   -73,   -73,   -73,   -73,   -73,   -73,     4,    98,
     -73,   123,   125,   -73,   -73,   138,   -73,    47,   102,   -73,
     -73,   -73,   -73,   -73,   -73,   -73,   -73,   -73,   -73,   -73,
     -73,   -73,   -73,    98,   -73,   -73,    59,   133,   140,   132,
     -73,    -8,   135,   146,    59,    59,   -73,   -19,   122,   -73,
      98,   -73,   -73,   126,   129,   130,    59,    51,   141,   134,
     -73,   148,   -73,    98,   143,   -73,    -9,   144,   -73,   152,
     -73,    98,   145,   -73,    98,   149,    98,   -73,   155,    59,
     -73
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -73,   -73,   -73,   -73,   -73,   -73,   136,   -73,   -63,   -73,
     -73,   -73,   -27,   -73,   -73,   -73,   -73,   -73,   -73,   -73,
     137,   -73,   -73,   -73,   119,   -73,   -73,   -73,   -72,   -73,
     -73,   -73,   -73,   -73,   -73,   -73,    11,   -73,    10,   -73,
     -73,   -73,    28
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      88,    76,    58,   131,    96,     3,   100,    66,    97,    99,
      61,    38,    67,   132,    12,    39,    62,   116,    20,   100,
      20,    52,    21,    91,    18,    19,   124,    71,    14,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
     112,   125,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,   112,    71,    41,    42,    43,   136,   120,
      16,    17,   100,     4,     5,     6,     7,   140,    82,    83,
      84,    22,    24,    25,   100,    23,    27,    26,    28,    29,
      30,    35,    36,   152,   159,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,    80,
      37,    45,    50,    80,    81,    82,    83,    84,    81,   121,
      83,    84,    53,    54,    58,    64,    65,    72,    73,    77,
      78,    74,    75,    93,    79,    85,    94,    95,    98,    85,
     117,   118,   119,    91,    92,   126,   127,   129,   128,   130,
     134,   137,   143,   145,   151,   154,   153,   139,   138,   156,
     160,   158,   155,   144,   157,   142,     0,     0,    56,     0,
       0,     0,     0,    46,     0,    47
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-73)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
      72,    64,    11,    22,    12,     0,    15,     6,    80,     5,
      24,    32,    11,    32,    16,    36,    30,    89,     3,    15,
       3,     6,     5,    31,     4,     5,    98,    54,    16,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,   113,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    81,    33,    34,    35,   130,    12,
      16,    16,    15,    20,    21,    22,    23,    16,    17,    18,
      19,    25,    16,    16,    15,    26,    16,    27,    11,    25,
      16,     6,    12,   146,   156,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    11,
       5,     5,    16,    11,    16,    17,    18,    19,    16,    17,
      18,    19,    30,    16,    11,    16,    16,    13,    17,     5,
      22,    16,    16,     5,    17,    37,     5,    16,    11,    37,
      17,    16,     4,    31,    26,    12,     6,    12,    16,     3,
      28,    25,    11,     5,    11,     3,    12,    27,    29,    14,
       5,    12,   151,    29,   154,   137,    -1,    -1,    49,    -1,
      -1,    -1,    -1,    37,    -1,    38
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    51,    52,     0,    20,    21,    22,    23,    53,    67,
      89,    90,    16,    91,    16,    70,    16,    16,     4,     5,
       3,     5,    25,    26,    16,    16,    27,    16,    11,    25,
      16,    54,    55,    56,    68,     6,    12,     5,    32,    36,
      69,    33,    34,    35,    57,     5,    56,    70,    71,    72,
      16,    63,     6,    30,    16,    73,    74,    83,    11,    58,
      62,    24,    30,    64,    16,    16,     6,    11,    59,    60,
      61,    62,    13,    17,    16,    16,    58,     5,    22,    17,
      11,    16,    17,    18,    19,    37,    74,    77,    78,    79,
      92,    31,    26,     5,     5,    16,    12,    78,    11,     5,
      15,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    80,    81,    82,    78,    17,    16,     4,
      12,    17,    75,    76,    78,    78,    12,     6,    16,    12,
       3,    22,    32,    65,    28,    84,    78,    25,    29,    27,
      16,    66,    92,    11,    29,     5,    78,    85,    86,    87,
      88,    11,    58,    12,     3,    86,    14,    88,    12,    78,
       5
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
        case 2:
/* Line 1787 of yacc.c  */
#line 90 "vhdl_ast.yacc"
    { ast = (yyvsp[(1) - (1)]); print_graph((yyvsp[(1) - (1)])); }
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 94 "vhdl_ast.yacc"
    { (yyval) = new_node("list_of_entity_arch_lib_use"); }
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 96 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 98 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 100 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 102 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 107 "vhdl_ast.yacc"
    { 
          (yyval) = new_node("entity_def");
          add_child((yyval), (yyvsp[(2) - (12)]));
          add_child((yyval), (yyvsp[(6) - (12)]));
          add_child((yyval), (yyvsp[(9) - (12)]));
      }
    break;

  case 9:
/* Line 1787 of yacc.c  */
#line 116 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 118 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 123 "vhdl_ast.yacc"
    {
          (yyval) = new_node("port_list");
          add_child((yyval), (yyvsp[(1) - (1)]));
      }
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 128 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (3)]);
          add_child((yyval),(yyvsp[(3) - (3)]));
      }
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 136 "vhdl_ast.yacc"
    { (yyval) = node("port",(yyvsp[(1) - (5)]),(yyvsp[(4) - (5)])); }
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 141 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 15:
/* Line 1787 of yacc.c  */
#line 143 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 16:
/* Line 1787 of yacc.c  */
#line 145 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 149 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 18:
/* Line 1787 of yacc.c  */
#line 151 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 19:
/* Line 1787 of yacc.c  */
#line 155 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 20:
/* Line 1787 of yacc.c  */
#line 157 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 21:
/* Line 1787 of yacc.c  */
#line 162 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 164 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 169 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(2) - (3)]); }
    break;

  case 24:
/* Line 1787 of yacc.c  */
#line 174 "vhdl_ast.yacc"
    { (yyval) = node("bit_range",(yyvsp[(2) - (5)]),(yyvsp[(4) - (5)])); }
    break;

  case 25:
/* Line 1787 of yacc.c  */
#line 178 "vhdl_ast.yacc"
    { (yyval) = new_node("attribute_list"); }
    break;

  case 26:
/* Line 1787 of yacc.c  */
#line 180 "vhdl_ast.yacc"
    {
        (yyval) = (yyvsp[(1) - (2)]);
        add_child((yyval),(yyvsp[(2) - (2)]));
      }
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 188 "vhdl_ast.yacc"
    { (yyval) = node("attribute",(yyvsp[(2) - (9)]),(yyvsp[(8) - (9)])); }
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 193 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 29:
/* Line 1787 of yacc.c  */
#line 195 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 30:
/* Line 1787 of yacc.c  */
#line 200 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 31:
/* Line 1787 of yacc.c  */
#line 202 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 32:
/* Line 1787 of yacc.c  */
#line 207 "vhdl_ast.yacc"
    {
          (yyval) = new_node("arch_def");
          add_child((yyval),(yyvsp[(2) - (11)]));
          add_child((yyval),(yyvsp[(6) - (11)]));
          add_child((yyval),(yyvsp[(8) - (11)]));
      }
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 216 "vhdl_ast.yacc"
    { (yyval) = new_node("signal_list"); }
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 218 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (2)]);
          add_child((yyval),(yyvsp[(2) - (2)]));
      }
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 226 "vhdl_ast.yacc"
    {
          (yyval) = new_node("signal_decl");
          add_child((yyval),(yyvsp[(2) - (6)]));
          add_child((yyval),(yyvsp[(4) - (6)]));
          add_child((yyval),(yyvsp[(5) - (6)]));
      }
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 236 "vhdl_ast.yacc"
    {
          (yyval) = new_node("ident_list");
          add_child((yyval),(yyvsp[(1) - (1)]));
      }
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 241 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (3)]);
          add_child((yyval),(yyvsp[(3) - (3)]));
      }
    break;

  case 38:
/* Line 1787 of yacc.c  */
#line 249 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 253 "vhdl_ast.yacc"
    { (yyval) = new_node("list_of_assign_or_inst"); }
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 255 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (2)]);
          add_child((yyval),(yyvsp[(2) - (2)]));
      }
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 260 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (2)]);
          add_child((yyval),(yyvsp[(2) - (2)]));
      }
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 268 "vhdl_ast.yacc"
    { (yyval) = node("assign",(yyvsp[(1) - (4)]),(yyvsp[(3) - (4)])); }
    break;

  case 43:
/* Line 1787 of yacc.c  */
#line 273 "vhdl_ast.yacc"
    { (yyval) = node("signal_opt_vector",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 277 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 279 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 284 "vhdl_ast.yacc"
    {
          (yyval) = new_node("expr_list");
          add_child((yyval), (yyvsp[(1) - (1)]));
      }
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 289 "vhdl_ast.yacc"
    {
          (yyval) = (yyvsp[(1) - (3)]);
          add_child((yyval),(yyvsp[(3) - (3)]));
      }
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 297 "vhdl_ast.yacc"
    { (yyval) = node("func_invocation",(yyvsp[(1) - (4)]),(yyvsp[(3) - (4)])); }
    break;

  case 49:
/* Line 1787 of yacc.c  */
#line 303 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 50:
/* Line 1787 of yacc.c  */
#line 305 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 51:
/* Line 1787 of yacc.c  */
#line 307 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 52:
/* Line 1787 of yacc.c  */
#line 309 "vhdl_ast.yacc"
    { (yyval) = node("unary", (yyvsp[(2) - (2)]),NULL); }
    break;

  case 53:
/* Line 1787 of yacc.c  */
#line 311 "vhdl_ast.yacc"
    {
//          $$ = new_node("binary");
          (yyval) = (yyvsp[(2) - (3)]);
          add_child((yyval),(yyvsp[(1) - (3)]));
//          add_child($$,$2);
          add_child((yyval),(yyvsp[(3) - (3)]));
      }
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 319 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(2) - (3)]); }
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 324 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 329 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 331 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 336 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 338 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 340 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 342 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 62:
/* Line 1787 of yacc.c  */
#line 344 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 63:
/* Line 1787 of yacc.c  */
#line 346 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 64:
/* Line 1787 of yacc.c  */
#line 348 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 65:
/* Line 1787 of yacc.c  */
#line 350 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 352 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 357 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 359 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 69:
/* Line 1787 of yacc.c  */
#line 361 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 70:
/* Line 1787 of yacc.c  */
#line 363 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 71:
/* Line 1787 of yacc.c  */
#line 368 "vhdl_ast.yacc"
    {
        (yyval) = new_node("instantiation");
        add_child((yyval),(yyvsp[(1) - (13)]));
        add_child((yyval),(yyvsp[(4) - (13)]));
        add_child((yyval),(yyvsp[(6) - (13)]));
        add_child((yyval),(yyvsp[(7) - (13)]));
        add_child((yyval),(yyvsp[(11) - (13)]));
    }
    break;

  case 72:
/* Line 1787 of yacc.c  */
#line 379 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 73:
/* Line 1787 of yacc.c  */
#line 381 "vhdl_ast.yacc"
    { (yyval) = node("generic_map_opt", (yyvsp[(4) - (5)]), NULL); }
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 387 "vhdl_ast.yacc"
    { (yyval) = node("generic_map_list", (yyvsp[(1) - (1)]), NULL); }
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 391 "vhdl_ast.yacc"
    { (yyval) = NULL; }
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 393 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 398 "vhdl_ast.yacc"
    {
        (yyval) = new_node("port_map_list");
        add_child((yyval),(yyvsp[(1) - (1)]));
    }
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 403 "vhdl_ast.yacc"
    {
        (yyval) = (yyvsp[(1) - (3)]);
        add_child((yyval), (yyvsp[(3) - (3)]));
    }
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 411 "vhdl_ast.yacc"
    { (yyval) = node("port_map", (yyvsp[(1) - (4)]), (yyvsp[(4) - (4)])); }
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 416 "vhdl_ast.yacc"
    {
        (yyval) = new_node("lib_stm");
        add_child((yyval),(yyvsp[(2) - (3)]));
    }
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 424 "vhdl_ast.yacc"
    { (yyval) = new_node("use_stm"); add_child((yyval), (yyvsp[(2) - (3)])); }
    break;

  case 82:
/* Line 1787 of yacc.c  */
#line 429 "vhdl_ast.yacc"
    {  (yyval) = new_node("ident_period_list");
    add_child((yyval), (yyvsp[(1) - (1)])); }
    break;

  case 83:
/* Line 1787 of yacc.c  */
#line 432 "vhdl_ast.yacc"
    {  (yyval) = (yyvsp[(1) - (3)]); add_child((yyval), (yyvsp[(3) - (3)])); }
    break;

  case 84:
/* Line 1787 of yacc.c  */
#line 436 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 85:
/* Line 1787 of yacc.c  */
#line 437 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 86:
/* Line 1787 of yacc.c  */
#line 438 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;


/* Line 1787 of yacc.c  */
#line 2197 "y.tab.c"
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
#line 441 "vhdl_ast.yacc"


int yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
    return 1;
}
