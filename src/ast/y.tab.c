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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

#define YYSTYPE node_t *

typedef struct node_tag {
    char * label;
    struct node_tag ** children;
    int num_children;
    int child_cap;
} node_t;

node_t * new_node(char * s) {
    node_t * n = malloc(sizeof(node_t));
    n->num_children = 0;
    n->child_cap = 10;
    n->children = malloc(sizeof(node_t *)*10);
    int l = strlen(s);
    n->label = malloc(sizeof(char)*(l+1));
    strncpy(n->label, s, l);
    return n;
}

void add_child(node_t * n, node_t * c) {
    if(n->num_children == n->child_cap) {
        n->child_cap *= 2;
        n->children = realloc(n->children, sizeof(node_t *) * n->child_cap);
    }
    n->children[n->num_children] = c;
    n->num_children++;
}

node_t * node(char * s, node_t * n1, node_t * n2) {
    node_t * n = new_node(s);
    add_child(n, n1);
    add_child(n, n2);
    return n;
}

void print_tree(FILE * fp, node_t * n, int depth) {

    int i;

    for(i=0; i < n->num_children; i++) {
        if(n->children[i] != NULL) {
            fprintf(fp,"%s_%p -> %s_%p;\n", n->label, n, n->children[i]->label, n->children[i]);
            print_tree(fp,n->children[i], depth+1);
        }
    }
}

void print_graph(node_t * n) {
    char filename[] = "graph.gv";
    FILE * fp = fopen(filename, "w");
    if(fp == NULL) {
        fprintf(stderr, "error: cannot write to file %s\n",filename);
        exit(1);
    }
    fprintf(fp, "digraph G {\n");
    print_tree(fp,n,0);
    fprintf(fp, "}\n");
    fclose(fp);
}




/* Line 371 of yacc.c  */
#line 139 "y.tab.c"

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
#line 271 "y.tab.c"

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
#define YYLAST   178

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  50
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  40
/* YYNRULES -- Number of rules.  */
#define YYNRULES  83
/* YYNRULES -- Number of states.  */
#define YYNSTATES  158

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
static const yytype_uint8 yyprhs[] =
{
       0,     0,     3,     5,     6,     9,    12,    15,    18,    31,
      32,    34,    38,    44,    46,    48,    50,    51,    53,    54,
      56,    58,    60,    64,    70,    71,    74,    84,    86,    88,
      90,    92,   104,   105,   108,   115,   117,   121,   123,   124,
     127,   130,   135,   138,   139,   141,   145,   150,   152,   154,
     156,   159,   163,   167,   169,   171,   173,   175,   177,   179,
     181,   183,   185,   187,   189,   191,   193,   195,   197,   199,
     213,   214,   220,   222,   223,   225,   229,   234,   238,   242,
     244,   248,   250,   252
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      51,     0,    -1,    52,    -1,    -1,    52,    53,    -1,    52,
      66,    -1,    52,    86,    -1,    52,    87,    -1,    22,    16,
      25,    27,    11,    54,    12,     5,    62,    30,    16,     5,
      -1,    -1,    55,    -1,    54,     5,    55,    -1,    16,     6,
      56,    16,    57,    -1,    33,    -1,    34,    -1,    35,    -1,
      -1,    61,    -1,    -1,    59,    -1,    60,    -1,    61,    -1,
      11,    17,    12,    -1,    11,    17,    31,    17,    12,    -1,
      -1,    62,    63,    -1,    24,    16,    26,    16,     6,    64,
      25,    65,     5,    -1,    22,    -1,    32,    -1,    16,    -1,
      89,    -1,    23,    16,    26,    16,    25,    67,    36,    70,
      30,    16,     5,    -1,    -1,    67,    68,    -1,    32,    69,
       6,    16,    57,     5,    -1,    16,    -1,    69,     3,    16,
      -1,    71,    -1,    -1,    71,    72,    -1,    71,    81,    -1,
      73,    13,    76,     5,    -1,    16,    58,    -1,    -1,    76,
      -1,    74,     3,    76,    -1,    16,    11,    74,    12,    -1,
      89,    -1,    73,    -1,    75,    -1,    77,    76,    -1,    76,
      78,    76,    -1,    11,    76,    12,    -1,    37,    -1,    79,
      -1,    80,    -1,    38,    -1,    39,    -1,    40,    -1,    41,
      -1,    42,    -1,    43,    -1,    44,    -1,    45,    -1,    46,
      -1,    47,    -1,    48,    -1,    49,    -1,    15,    -1,    16,
       6,    22,    16,     4,    16,    82,    27,    29,    11,    84,
      12,     5,    -1,    -1,    28,    29,    11,    83,    12,    -1,
      84,    -1,    -1,    85,    -1,    84,     3,    85,    -1,    76,
      57,    14,    76,    -1,    21,    69,     5,    -1,    20,    88,
       5,    -1,    16,    -1,    88,     4,    16,    -1,    19,    -1,
      17,    -1,    18,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    84,    84,    89,    90,    92,    94,    96,   101,   105,
     106,   108,   113,   118,   120,   122,   126,   127,   131,   132,
     137,   139,   144,   149,   153,   154,   159,   164,   166,   171,
     173,   178,   182,   183,   188,   193,   195,   200,   204,   205,
     207,   212,   217,   221,   222,   224,   229,   235,   237,   239,
     241,   243,   245,   250,   255,   257,   262,   264,   266,   268,
     270,   272,   274,   276,   278,   283,   285,   287,   289,   294,
     298,   299,   305,   309,   310,   312,   317,   322,   327,   332,
     334,   339,   340,   341
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
  "root", "list_of_entity_arch_lib_use", "entity_def", "port_list", "port",
  "direction", "bit_range_opt", "bit_slice_opt", "bit_slice", "bit_index",
  "bit_range", "attribute_list", "attribute", "entity_or_signal",
  "ident_or_literal", "arch_def", "signal_list", "signal_decl",
  "ident_list", "arch_body", "list_of_assign_or_inst", "assign",
  "signal_opt_vector", "expr_list", "func_invocation", "expr",
  "unary_boolean_op", "binary_op", "binary_boolean_op", "relational_op",
  "instantiation", "generic_map_opt", "generic_map_list", "port_map_list",
  "port_map", "lib_stm", "use_stm", "ident_period_list", "literal", YY_NULL
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
      54,    54,    55,    56,    56,    56,    57,    57,    58,    58,
      59,    59,    60,    61,    62,    62,    63,    64,    64,    65,
      65,    66,    67,    67,    68,    69,    69,    70,    71,    71,
      71,    72,    73,    74,    74,    74,    75,    76,    76,    76,
      76,    76,    76,    77,    78,    78,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    80,    80,    80,    80,    81,
      82,    82,    83,    84,    84,    84,    85,    86,    87,    88,
      88,    89,    89,    89
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     2,     2,     2,     2,    12,     0,
       1,     3,     5,     1,     1,     1,     0,     1,     0,     1,
       1,     1,     3,     5,     0,     2,     9,     1,     1,     1,
       1,    11,     0,     2,     6,     1,     3,     1,     0,     2,
       2,     4,     2,     0,     1,     3,     4,     1,     1,     1,
       2,     3,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,    13,
       0,     5,     1,     0,     1,     3,     4,     3,     3,     1,
       3,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,     0,     2,     1,     0,     0,     0,     0,     4,     5,
       6,     7,    79,     0,    35,     0,     0,     0,     0,    78,
       0,    77,     0,     0,    80,    36,     0,     0,     9,    32,
       0,     0,    10,     0,     0,     0,     0,     0,    38,    33,
      13,    14,    15,     0,    11,    24,     0,     0,    37,    16,
       0,     0,     0,    18,    39,     0,    40,     0,    12,    17,
       0,     0,    25,    16,     0,     0,     0,    42,    19,    20,
      21,     0,     0,     0,     0,     0,    31,     0,     0,     0,
      18,    82,    83,    81,    53,    48,    49,     0,     0,    47,
       0,     0,     8,    34,     0,    22,     0,    43,    41,    68,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,    67,     0,    54,    55,    50,     0,     0,     0,    52,
      82,     0,    44,    51,    23,     0,    70,     0,    46,    27,
      28,     0,     0,     0,    45,     0,     0,     0,    29,     0,
      30,    73,     0,    26,    16,     0,    72,    74,    73,     0,
      71,     0,     0,     0,    75,     0,    76,    69
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     8,    31,    32,    43,    58,    67,    68,
      69,    59,    50,    62,   131,   139,     9,    33,    39,    15,
      47,    48,    54,    85,   121,    86,   144,    88,   112,   113,
     114,    56,   133,   145,   146,   147,    10,    11,    13,    89
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -72
static const yytype_int16 yypact[] =
{
     -72,    18,    55,   -72,    41,    65,    97,    98,   -72,   -72,
     -72,   -72,   -72,    75,   -72,     7,    -1,    90,    99,   -72,
     101,   -72,    91,   103,   -72,   -72,   109,    96,   107,   -72,
     118,    11,   -72,   -11,    64,   107,   120,    65,   -72,   -72,
     -72,   -72,   -72,   111,   -72,   -72,    56,   100,   112,   121,
     -17,   113,   115,    49,   -72,   122,   -72,   116,   -72,   -72,
     123,   124,   -72,   121,   129,   114,   125,   -72,   -72,   -72,
     -72,    85,   106,   117,   133,   136,   -72,   128,    -9,    85,
     134,   -72,   -72,   -72,   -72,   -72,   -72,     4,    85,   -72,
     130,   132,   -72,   -72,   142,   -72,    46,    89,   -72,   -72,
     -72,   -72,   -72,   -72,   -72,   -72,   -72,   -72,   -72,   -72,
     -72,   -72,    85,   -72,   -72,    25,   137,   144,   135,   -72,
      -9,     3,    25,    25,   -72,   -18,   126,    85,   -72,   -72,
     -72,   127,   131,   138,    25,    93,   145,   139,   -72,   148,
     -72,    85,   146,   -72,   -10,   143,   155,   -72,    85,   147,
     -72,    85,     8,    85,   -72,   154,    25,   -72
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -72,   -72,   -72,   -72,   -72,   140,   -72,   -61,   -72,   -72,
     -72,   -26,   -72,   -72,   -72,   -72,   -72,   -72,   -72,   141,
     -72,   -72,   -72,   119,   -72,   -72,   -71,   -72,   -72,   -72,
     -72,   -72,   -72,   -72,    14,    12,   -72,   -72,   -72,    29
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      87,    57,    75,    95,   129,    99,   127,    60,    96,    98,
      20,   151,    21,    61,   130,   128,    35,   115,     3,    99,
     155,    37,    90,    36,    22,    38,   122,    70,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
      99,   123,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,   111,    70,    65,   134,    12,   119,    20,
      66,    99,    51,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,   111,     4,     5,     6,     7,    18,
      19,    14,   156,   149,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,    79,    40,    41,    42,
      79,    80,    81,    82,    83,    80,   120,    82,    83,   138,
      81,    82,    83,    16,    17,    24,    23,    25,    26,    27,
      28,    29,    84,    30,    34,    45,    84,    49,    53,    63,
      52,    64,    57,    72,    76,    71,    77,    90,    92,    73,
      74,    93,    78,    91,    94,    97,   118,   116,   117,   124,
     125,   126,   135,   143,   132,   150,   141,   148,   151,   157,
     136,   153,   152,   154,   140,   137,     0,    55,   142,     0,
       0,     0,     0,     0,     0,    44,     0,     0,    46
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-72)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
      71,    11,    63,    12,    22,    15,     3,    24,    79,     5,
       3,     3,     5,    30,    32,    12,     5,    88,     0,    15,
      12,    32,    31,    12,    25,    36,    97,    53,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      15,   112,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    80,     6,   127,    16,    12,     3,
      11,    15,     6,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    20,    21,    22,    23,     4,
       5,    16,   153,   144,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    11,    33,    34,    35,
      11,    16,    17,    18,    19,    16,    17,    18,    19,    16,
      17,    18,    19,    16,    16,    16,    26,    16,    27,    16,
      11,    25,    37,    16,     6,     5,    37,    16,    16,    16,
      30,    16,    11,    17,     5,    13,    22,    31,     5,    16,
      16,     5,    17,    26,    16,    11,     4,    17,    16,    12,
       6,    16,    25,     5,    28,    12,    11,    11,     3,     5,
      29,    14,   148,   151,   135,    27,    -1,    48,    29,    -1,
      -1,    -1,    -1,    -1,    -1,    35,    -1,    -1,    37
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    51,    52,     0,    20,    21,    22,    23,    53,    66,
      86,    87,    16,    88,    16,    69,    16,    16,     4,     5,
       3,     5,    25,    26,    16,    16,    27,    16,    11,    25,
      16,    54,    55,    67,     6,     5,    12,    32,    36,    68,
      33,    34,    35,    56,    55,     5,    69,    70,    71,    16,
      62,     6,    30,    16,    72,    73,    81,    11,    57,    61,
      24,    30,    63,    16,    16,     6,    11,    58,    59,    60,
      61,    13,    17,    16,    16,    57,     5,    22,    17,    11,
      16,    17,    18,    19,    37,    73,    75,    76,    77,    89,
      31,    26,     5,     5,    16,    12,    76,    11,     5,    15,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    78,    79,    80,    76,    17,    16,     4,    12,
      17,    74,    76,    76,    12,     6,    16,     3,    12,    22,
      32,    64,    28,    82,    76,    25,    29,    27,    16,    65,
      89,    11,    29,     5,    76,    83,    84,    85,    11,    57,
      12,     3,    84,    14,    85,    12,    76,     5
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
#line 85 "vhdl_ast.yacc"
    { print_graph((yyvsp[(1) - (1)])); }
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 89 "vhdl_ast.yacc"
    { (yyval) = new_node("list_of_entity_arch_lib_use"); }
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 91 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 93 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 95 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 97 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (2)]); add_child((yyval),(yyvsp[(2) - (2)])); }
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 102 "vhdl_ast.yacc"
    { (yyval) = new_node("entity_def"); add_child((yyval), (yyvsp[(2) - (12)])); add_child((yyval), (yyvsp[(6) - (12)])); add_child((yyval), (yyvsp[(9) - (12)])); }
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 107 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 109 "vhdl_ast.yacc"
    { (yyval) = node("port_list",(yyvsp[(1) - (3)]),(yyvsp[(3) - (3)])); }
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 114 "vhdl_ast.yacc"
    { (yyval) = node("port",(yyvsp[(1) - (5)]),(yyvsp[(4) - (5)])); }
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 119 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 121 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 15:
/* Line 1787 of yacc.c  */
#line 123 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 128 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 19:
/* Line 1787 of yacc.c  */
#line 133 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 20:
/* Line 1787 of yacc.c  */
#line 138 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 21:
/* Line 1787 of yacc.c  */
#line 140 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 145 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(2) - (3)]); }
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 150 "vhdl_ast.yacc"
    { (yyval) = node("bit_range",(yyvsp[(2) - (5)]),(yyvsp[(4) - (5)])); }
    break;

  case 25:
/* Line 1787 of yacc.c  */
#line 155 "vhdl_ast.yacc"
    { (yyval) = node("attribute_list",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 26:
/* Line 1787 of yacc.c  */
#line 160 "vhdl_ast.yacc"
    { (yyval) = node("attribute",(yyvsp[(2) - (9)]),(yyvsp[(8) - (9)])); }
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 165 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 167 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 29:
/* Line 1787 of yacc.c  */
#line 172 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 30:
/* Line 1787 of yacc.c  */
#line 174 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 31:
/* Line 1787 of yacc.c  */
#line 179 "vhdl_ast.yacc"
    { (yyval) = node("arch_def",(yyvsp[(2) - (11)]),(yyvsp[(8) - (11)])); }
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 184 "vhdl_ast.yacc"
    { (yyval) = node("ident_list",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 189 "vhdl_ast.yacc"
    { (yyval) = node("signal_decl",(yyvsp[(2) - (6)]),(yyvsp[(4) - (6)])); }
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 194 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 196 "vhdl_ast.yacc"
    { (yyval) = node("ident_list",(yyvsp[(1) - (3)]),(yyvsp[(3) - (3)])); }
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 201 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 206 "vhdl_ast.yacc"
    { (yyval) = node("list_of_assign_or_inst",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 208 "vhdl_ast.yacc"
    { (yyval) = node("list_of_assign_or_inst",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 213 "vhdl_ast.yacc"
    { (yyval) = node("assign",(yyvsp[(1) - (4)]),(yyvsp[(3) - (4)])); }
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 218 "vhdl_ast.yacc"
    { (yyval) = node("signal_opt_vector",(yyvsp[(1) - (2)]),(yyvsp[(2) - (2)])); }
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 223 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 225 "vhdl_ast.yacc"
    { (yyval) = node("expr_list",(yyvsp[(1) - (3)]),(yyvsp[(3) - (3)])); }
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 230 "vhdl_ast.yacc"
    { (yyval) = node("func_invocation",(yyvsp[(1) - (4)]),(yyvsp[(3) - (4)])); }
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 236 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 238 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 49:
/* Line 1787 of yacc.c  */
#line 240 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 50:
/* Line 1787 of yacc.c  */
#line 242 "vhdl_ast.yacc"
    { (yyval) = node("unary", (yyvsp[(2) - (2)]),NULL); }
    break;

  case 51:
/* Line 1787 of yacc.c  */
#line 244 "vhdl_ast.yacc"
    { (yyval) = node("binary",(yyvsp[(1) - (3)]),(yyvsp[(2) - (3)])); }
    break;

  case 52:
/* Line 1787 of yacc.c  */
#line 246 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(2) - (3)]); }
    break;

  case 53:
/* Line 1787 of yacc.c  */
#line 251 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 256 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 258 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 263 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 265 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 267 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 269 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 271 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 273 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 62:
/* Line 1787 of yacc.c  */
#line 275 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 63:
/* Line 1787 of yacc.c  */
#line 277 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 64:
/* Line 1787 of yacc.c  */
#line 279 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 65:
/* Line 1787 of yacc.c  */
#line 284 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 286 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 288 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 290 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 69:
/* Line 1787 of yacc.c  */
#line 295 "vhdl_ast.yacc"
    { (yyval) = node("instantiation", (yyvsp[(1) - (13)]), (yyvsp[(11) - (13)])); }
    break;

  case 71:
/* Line 1787 of yacc.c  */
#line 300 "vhdl_ast.yacc"
    { (yyval) = node("generic_map_opt", (yyvsp[(3) - (5)]), NULL); }
    break;

  case 72:
/* Line 1787 of yacc.c  */
#line 306 "vhdl_ast.yacc"
    { (yyval) = node("generic_map_list", (yyvsp[(1) - (1)]), NULL); }
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 311 "vhdl_ast.yacc"
    { (yyval) = node("port_map_list", (yyvsp[(1) - (1)]), NULL); }
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 313 "vhdl_ast.yacc"
    { (yyval) = node("port_map_list", (yyvsp[(1) - (3)]), (yyvsp[(3) - (3)])); }
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 318 "vhdl_ast.yacc"
    { (yyval) = node("port_map", (yyvsp[(1) - (4)]), (yyvsp[(4) - (4)])); }
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 323 "vhdl_ast.yacc"
    { (yyval) = node("lib_stm", (yyvsp[(1) - (3)]), (yyvsp[(2) - (3)])); }
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 328 "vhdl_ast.yacc"
    { (yyval) = node("use_stm", (yyvsp[(1) - (3)]), (yyvsp[(2) - (3)])); }
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 333 "vhdl_ast.yacc"
    {  (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 335 "vhdl_ast.yacc"
    {  (yyval) = node("ident_period_list", (yyvsp[(1) - (3)]), (yyvsp[(3) - (3)])); }
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 339 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 82:
/* Line 1787 of yacc.c  */
#line 340 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;

  case 83:
/* Line 1787 of yacc.c  */
#line 341 "vhdl_ast.yacc"
    { (yyval) = (yyvsp[(1) - (1)]); }
    break;


/* Line 1787 of yacc.c  */
#line 2046 "y.tab.c"
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
#line 344 "vhdl_ast.yacc"


int yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
    return 1;
}

int main() {
    return(yyparse());
}
