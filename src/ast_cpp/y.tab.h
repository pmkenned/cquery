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
