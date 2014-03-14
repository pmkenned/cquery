%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char *
%}

%token ',' '.' ';' ':' '{' '}' '[' ']' '(' ')'
%token LTEQ EQGT NEQ
%token IDENT NUMBER DIGIT STRING
%token USE LIBRARY ENTITY ARCHITECTURE ATTRIBUTE IS OF PORT GENERIC MAP END TO SIGNAL IN OUT INOUT
%token _BEGIN_  /* BEGIN is already defined in lex.yy.c as something else */
%token NOT AND NAND OR NOR XOR XNOR

%start root

%%

root:
    list_of_entity_arch_lib_use

list_of_entity_arch_lib_use:      /* empty */
    | list_of_entity_arch_lib_use entity_def
    | list_of_entity_arch_lib_use arch_def
    | list_of_entity_arch_lib_use lib_stm
    | list_of_entity_arch_lib_use use_stm

entity_def:
    ENTITY IDENT IS PORT '(' port_list ')' ';' attribute_list END IDENT ';'

port_list:    /* empty */
    | port
    | port_list ';' port

port:
    IDENT ':' direction IDENT bit_range_opt

direction:
      IN
    | OUT
    | INOUT

bit_range_opt: /* empty */
    | bit_range

bit_slice_opt: /* empty */
    | bit_slice

bit_slice:
      bit_index
    | bit_range

bit_index:
    '(' NUMBER ')'

bit_range:
    '(' NUMBER TO NUMBER ')' /* TODO: downto? */

attribute_list: /* empty */
    | attribute_list attribute

attribute:
    ATTRIBUTE IDENT OF IDENT ':' entity_or_signal IS ident_or_literal ';'

entity_or_signal:
      ENTITY
    | SIGNAL

ident_or_literal:
      IDENT
    | literal

arch_def:
    ARCHITECTURE IDENT OF IDENT IS signal_list _BEGIN_ arch_body END IDENT ';'

signal_list: /* empty */
    | signal_list signal_decl

signal_decl:
    SIGNAL ident_list ':' IDENT bit_range_opt ';'

ident_list:
      IDENT /* not empty */
    | ident_list ',' IDENT

arch_body:
    list_of_assign_or_inst /* TODO: technically redundant */

list_of_assign_or_inst: /* empty */
    | list_of_assign_or_inst assign
    | list_of_assign_or_inst instantiation

assign:
    signal_opt_vector LTEQ expr ';'

signal_opt_vector:
    IDENT bit_slice_opt

expr_list: /* empty */
    | expr
    | expr_list ',' expr

func_invocation:
    IDENT '(' expr_list ')'

/* NOTE: this has shift/reduce conflicts */
expr:
      literal
    | signal_opt_vector
    | func_invocation
    | unary_boolean_op expr
    | expr binary_op expr
    | '(' expr ')'

unary_boolean_op:
    NOT

binary_op:
      binary_boolean_op
    | relational_op

binary_boolean_op:
      AND
    | NAND
    | OR
    | NOR
    | XOR
    | XNOR
    | '&'
    | '+'
    | '-'

relational_op:
      '='
    | '>'
    | '<'
    | NEQ

instantiation:
    IDENT ':' ENTITY IDENT '.' IDENT generic_map_opt PORT MAP '(' port_map_list ')' ';'
    {  }

generic_map_opt:
    | GENERIC MAP '(' generic_map_list ')'

/* TODO: what is the difference between generic map and port map? */
generic_map_list:
      port_map_list

port_map_list: /* empty */
    | port_map
    | port_map_list ',' port_map

port_map:
    expr bit_range_opt EQGT expr /* TODO: is it correct to use expr on both sides of EQGT? */

lib_stm:
    LIBRARY ident_list ';'

use_stm:
    USE ident_period_list ';'

ident_period_list:
      IDENT
    | ident_period_list '.' IDENT /* TODO: no whitespace can be between period and identifier */

literal:
      STRING   { $$ = $1; }
    | NUMBER   { $$ = $1; }
    | DIGIT    { $$ = $1; }

%%

void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
    return 1;
}
