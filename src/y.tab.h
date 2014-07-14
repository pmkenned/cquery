/* A Bison parser, made by GNU Bison 2.7.1.  */

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

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
