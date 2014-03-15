/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison interface for Yacc-like parsers in C
   
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
     TILDE_AMP = 258,
     CARET_PIPE = 259,
     CARET_TICK = 260,
     TILDE_CARET = 261,
     EQ_EQ = 262,
     NOT_EQ = 263,
     EQ_EQ_EQ = 264,
     NOT_EQ_EQ = 265,
     AMP_AMP = 266,
     AMP_AMP_AMP = 267,
     PIPE_PIPE = 268,
     LTE = 269,
     GTE = 270,
     CARET_TILDE = 271,
     LSHIFT = 272,
     RSHIFT = 273,
     EQ_GT = 274,
     AST_GT = 275,
     HYPH_GT = 276,
     SETUP = 277,
     HOLD = 278,
     PERIOD = 279,
     WIDTH = 280,
     SKEW = 281,
     RECOVERY = 282,
     SETUPHOLD = 283,
     _BEGIN_ = 284,
     END = 285,
     MACROMODULE = 286,
     MODULE = 287,
     ENDMODULE = 288,
     PRIMITIVE = 289,
     ENDPRIMITIVE = 290,
     TABLE = 291,
     ENDTABLE = 292,
     TASK = 293,
     ENDTASK = 294,
     FUNCTION = 295,
     ENDFUNCTION = 296,
     SPECIFY = 297,
     ENDSPECIFY = 298,
     INTEGER = 299,
     REAL = 300,
     TIME = 301,
     SPECPARAM = 302,
     PARAMETER = 303,
     DEFPARAM = 304,
     INPUT = 305,
     OUTPUT = 306,
     INOUT = 307,
     WIRE = 308,
     TRI = 309,
     TRI0 = 310,
     TRI1 = 311,
     SUPPLY0 = 312,
     SUPPLY1 = 313,
     WAND = 314,
     TRIAND = 315,
     TRIOR = 316,
     WOR = 317,
     TRIREG = 318,
     SCALARED = 319,
     VECTORED = 320,
     REG = 321,
     EVENT = 322,
     SMALL = 323,
     MEDIUM = 324,
     LARGE = 325,
     STRONG0 = 326,
     STRONG1 = 327,
     PULL0 = 328,
     PULL1 = 329,
     WEAK0 = 330,
     WEAK1 = 331,
     HIGHZ0 = 332,
     HIGHZ1 = 333,
     AND = 334,
     NAND = 335,
     OR = 336,
     NOR = 337,
     XOR = 338,
     XNOR = 339,
     BUF = 340,
     BUFIF0 = 341,
     BUFIF1 = 342,
     NOT = 343,
     NOTIF0 = 344,
     NOTIF1 = 345,
     PULLDOWN = 346,
     PULLUP = 347,
     NMOS = 348,
     RNMOS = 349,
     PMOS = 350,
     RPMOS = 351,
     CMOS = 352,
     RCMOS = 353,
     TRAN = 354,
     RTRAN = 355,
     TRANIF0 = 356,
     TRANIF1 = 357,
     RTRANIF0 = 358,
     RTRANIF1 = 359,
     ASSIGN = 360,
     DEASSIGN = 361,
     _INITIAL_ = 362,
     ALWAYS = 363,
     IF = 364,
     ELSE = 365,
     CASE = 366,
     CASEZ = 367,
     CASEX = 368,
     ENDCASE = 369,
     DEFAULT = 370,
     FOREVER = 371,
     REPEAT = 372,
     WHILE = 373,
     FOR = 374,
     WAIT = 375,
     DISABLE = 376,
     FORCE = 377,
     RELEASE = 378,
     FORK = 379,
     JOIN = 380,
     POSEDGE = 381,
     NEGEDGE = 382,
     EDGE = 383,
     OUTPUT_SYMBOL = 384,
     INIT_VAL = 385,
     STRING = 386,
     IDENTIFIER = 387,
     NUMBER = 388,
     DECIMAL_NUMBER = 389,
     UNSIGNED_NUMBER = 390,
     BASE = 391,
     SCALAR_CONSTANT = 392,
     LEVEL_SYMBOL = 393,
     EDGE_SYMBOL = 394,
     EDGE_DESCRIPTOR = 395
   };
#endif
/* Tokens.  */
#define TILDE_AMP 258
#define CARET_PIPE 259
#define CARET_TICK 260
#define TILDE_CARET 261
#define EQ_EQ 262
#define NOT_EQ 263
#define EQ_EQ_EQ 264
#define NOT_EQ_EQ 265
#define AMP_AMP 266
#define AMP_AMP_AMP 267
#define PIPE_PIPE 268
#define LTE 269
#define GTE 270
#define CARET_TILDE 271
#define LSHIFT 272
#define RSHIFT 273
#define EQ_GT 274
#define AST_GT 275
#define HYPH_GT 276
#define SETUP 277
#define HOLD 278
#define PERIOD 279
#define WIDTH 280
#define SKEW 281
#define RECOVERY 282
#define SETUPHOLD 283
#define _BEGIN_ 284
#define END 285
#define MACROMODULE 286
#define MODULE 287
#define ENDMODULE 288
#define PRIMITIVE 289
#define ENDPRIMITIVE 290
#define TABLE 291
#define ENDTABLE 292
#define TASK 293
#define ENDTASK 294
#define FUNCTION 295
#define ENDFUNCTION 296
#define SPECIFY 297
#define ENDSPECIFY 298
#define INTEGER 299
#define REAL 300
#define TIME 301
#define SPECPARAM 302
#define PARAMETER 303
#define DEFPARAM 304
#define INPUT 305
#define OUTPUT 306
#define INOUT 307
#define WIRE 308
#define TRI 309
#define TRI0 310
#define TRI1 311
#define SUPPLY0 312
#define SUPPLY1 313
#define WAND 314
#define TRIAND 315
#define TRIOR 316
#define WOR 317
#define TRIREG 318
#define SCALARED 319
#define VECTORED 320
#define REG 321
#define EVENT 322
#define SMALL 323
#define MEDIUM 324
#define LARGE 325
#define STRONG0 326
#define STRONG1 327
#define PULL0 328
#define PULL1 329
#define WEAK0 330
#define WEAK1 331
#define HIGHZ0 332
#define HIGHZ1 333
#define AND 334
#define NAND 335
#define OR 336
#define NOR 337
#define XOR 338
#define XNOR 339
#define BUF 340
#define BUFIF0 341
#define BUFIF1 342
#define NOT 343
#define NOTIF0 344
#define NOTIF1 345
#define PULLDOWN 346
#define PULLUP 347
#define NMOS 348
#define RNMOS 349
#define PMOS 350
#define RPMOS 351
#define CMOS 352
#define RCMOS 353
#define TRAN 354
#define RTRAN 355
#define TRANIF0 356
#define TRANIF1 357
#define RTRANIF0 358
#define RTRANIF1 359
#define ASSIGN 360
#define DEASSIGN 361
#define _INITIAL_ 362
#define ALWAYS 363
#define IF 364
#define ELSE 365
#define CASE 366
#define CASEZ 367
#define CASEX 368
#define ENDCASE 369
#define DEFAULT 370
#define FOREVER 371
#define REPEAT 372
#define WHILE 373
#define FOR 374
#define WAIT 375
#define DISABLE 376
#define FORCE 377
#define RELEASE 378
#define FORK 379
#define JOIN 380
#define POSEDGE 381
#define NEGEDGE 382
#define EDGE 383
#define OUTPUT_SYMBOL 384
#define INIT_VAL 385
#define STRING 386
#define IDENTIFIER 387
#define NUMBER 388
#define DECIMAL_NUMBER 389
#define UNSIGNED_NUMBER 390
#define BASE 391
#define SCALAR_CONSTANT 392
#define LEVEL_SYMBOL 393
#define EDGE_SYMBOL 394
#define EDGE_DESCRIPTOR 395



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
