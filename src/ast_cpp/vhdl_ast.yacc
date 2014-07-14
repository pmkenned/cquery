%{

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
    { ast = $1; print_graph($1); }
    ;

list_of_entity_arch_lib_use:      /* empty */
      { $$ = new_node("list_of_entity_arch_lib_use"); }
    | list_of_entity_arch_lib_use entity_def
      { $$ = $1; add_child($$,$2); }
    | list_of_entity_arch_lib_use arch_def
      { $$ = $1; add_child($$,$2); }
    | list_of_entity_arch_lib_use lib_stm
      { $$ = $1; add_child($$,$2); }
    | list_of_entity_arch_lib_use use_stm
      { $$ = $1; add_child($$,$2); }
    ;

entity_def:
    ENTITY IDENT IS PORT '(' port_list_opt ')' ';' attribute_list END IDENT ';'
      { 
          $$ = new_node("entity_def");
          add_child($$, $2);
          add_child($$, $6);
          add_child($$, $9);
      }
    ;

port_list_opt: /* empty */
    { $$ = NULL; }
    | port_list
    { $$ = $1; }
    ;

port_list:    /* not empty */
      port
      {
          $$ = new_node("port_list");
          add_child($$, $1);
      }
    | port_list ';' port
      {
          $$ = $1;
          add_child($$,$3);
      }
    ;

port:
    IDENT ':' direction IDENT bit_range_opt
      { $$ = node("port",$1,$4); }
    ;

direction:
      IN
      { $$ = $1; }
    | OUT
      { $$ = $1; }
    | INOUT
      { $$ = $1; }
    ;

bit_range_opt: /* empty */
      { $$ = NULL; }
    | bit_range
      { $$ = $1; }
    ;

bit_slice_opt: /* empty */
      { $$ = NULL; }
    | bit_slice
      { $$ = $1; }
    ;

bit_slice:
      bit_index
      { $$ = $1; }
    | bit_range
      { $$ = $1; }
    ;

bit_index:
    '(' NUMBER ')'
      { $$ = $2; }
    ;

bit_range:
    '(' NUMBER TO NUMBER ')' /* TODO: downto? */
      { $$ = node("bit_range",$2,$4); }
    ;

attribute_list: /* empty */
      { $$ = new_node("attribute_list"); }
    | attribute_list attribute
      {
        $$ = $1;
        add_child($$,$2);
      }
    ;

attribute:
    ATTRIBUTE IDENT OF IDENT ':' entity_or_signal IS ident_or_literal ';'
      { $$ = node("attribute",$2,$8); }
    ;

entity_or_signal:
      ENTITY
      { $$ = $1; }
    | SIGNAL
      { $$ = $1; }
    ;

ident_or_literal:
      IDENT
      { $$ = $1; }
    | literal
      { $$ = $1; }
    ;

arch_def:
    ARCHITECTURE IDENT OF IDENT IS signal_list _BEGIN_ arch_body END IDENT ';'
      {
          $$ = new_node("arch_def");
          add_child($$,$2);
          add_child($$,$6);
          add_child($$,$8);
      }
    ;

signal_list: /* empty */
      { $$ = new_node("signal_list"); }
    | signal_list signal_decl
      {
          $$ = $1;
          add_child($$,$2);
      }
    ;

signal_decl:
    SIGNAL ident_list ':' IDENT bit_range_opt ';'
      {
          $$ = new_node("signal_decl");
          add_child($$,$2);
          add_child($$,$4);
          add_child($$,$5);
      }
    ;

ident_list:
      IDENT /* not empty */
      {
          $$ = new_node("ident_list");
          add_child($$,$1);
      }
    | ident_list ',' IDENT
      {
          $$ = $1;
          add_child($$,$3);
      }
    ;

arch_body:
    list_of_assign_or_inst /* TODO: technically redundant */
      { $$ = $1; }
    ;

list_of_assign_or_inst: /* empty */
      { $$ = new_node("list_of_assign_or_inst"); }
    | list_of_assign_or_inst assign
      {
          $$ = $1;
          add_child($$,$2);
      }
    | list_of_assign_or_inst instantiation
      {
          $$ = $1;
          add_child($$,$2);
      }
    ;

assign:
    signal_opt_vector LTEQ expr ';'
      { $$ = node("assign",$1,$3); }
    ;

signal_opt_vector:
    IDENT bit_slice_opt
      { $$ = node("signal_opt_vector",$1,$2); }
    ;

expr_list_opt: /* empty */
    { $$ = NULL; }
    | expr_list
    { $$ = $1; }
    ;

expr_list: /* not empty */
      expr
      {
          $$ = new_node("expr_list");
          add_child($$, $1);
      }
    | expr_list ',' expr
      {
          $$ = $1;
          add_child($$,$3);
      }
    ;

func_invocation:
    IDENT '(' expr_list_opt ')'
      { $$ = node("func_invocation",$1,$3); }
    ;

/* NOTE: this has shift/reduce conflicts */
expr:
      literal
      { $$ = $1; }
    | signal_opt_vector
      { $$ = $1; }
    | func_invocation
      { $$ = $1; }
    | unary_boolean_op expr
      { $$ = node("unary", $2,NULL); }
    | expr binary_op expr
      {
//          $$ = new_node("binary");
          $$ = $2;
          add_child($$,$1);
//          add_child($$,$2);
          add_child($$,$3);
      }
    | '(' expr ')'
      { $$ = $2; }
    ;

unary_boolean_op:
    NOT
      { $$ = $1; }
    ;

binary_op:
      binary_boolean_op
      { $$ = $1; }
    | relational_op
      { $$ = $1; }
    ;

binary_boolean_op:
      AND
      { $$ = $1; }
    | NAND
      { $$ = $1; }
    | OR
      { $$ = $1; }
    | NOR
      { $$ = $1; }
    | XOR
      { $$ = $1; }
    | XNOR
      { $$ = $1; }
    | '&'
      { $$ = $1; }
    | '+'
      { $$ = $1; }
    | '-'
      { $$ = $1; }
    ;

relational_op:
      '='
      { $$ = $1; }
    | '>'
      { $$ = $1; }
    | '<'
      { $$ = $1; }
    | NEQ
      { $$ = $1; }
    ;

instantiation:
    IDENT ':' ENTITY IDENT '.' IDENT generic_map_opt PORT MAP '(' port_map_list_opt ')' ';'
    {
        $$ = new_node("instantiation");
        add_child($$,$1);
        add_child($$,$4);
        add_child($$,$6);
        add_child($$,$7);
        add_child($$,$11);
    }
    ;

generic_map_opt:
    { $$ = NULL; }
    | GENERIC MAP '(' generic_map_list ')'
    { $$ = node("generic_map_opt", $4, NULL); }
    ;

/* TODO: what is the difference between generic map and port map? */
generic_map_list:
      port_map_list_opt
    { $$ = node("generic_map_list", $1, NULL); }
    ;

port_map_list_opt: /* empty */
    { $$ = NULL; }
    | port_map_list
    { $$ = $1; }
    ;

port_map_list: /* not empty */
      port_map
    {
        $$ = new_node("port_map_list");
        add_child($$,$1);
    }
    | port_map_list ',' port_map
    {
        $$ = $1;
        add_child($$, $3);
    }
    ;

port_map:
    expr bit_range_opt EQGT expr /* TODO: is it correct to use expr on both sides of EQGT? */
    { $$ = node("port_map", $1, $4); }
    ;

lib_stm:
    LIBRARY ident_list ';'
    {
        $$ = new_node("lib_stm");
        add_child($$,$2);
    }
    ;

use_stm:
    USE ident_period_list ';'
    { $$ = new_node("use_stm"); add_child($$, $2); }
    ;

ident_period_list:
      IDENT
    {  $$ = new_node("ident_period_list");
    add_child($$, $1); }
    | ident_period_list '.' IDENT /* TODO: no whitespace can be between period and identifier */
    {  $$ = $1; add_child($$, $3); }
    ;

literal:
      STRING   { $$ = $1; }
    | NUMBER   { $$ = $1; }
    | DIGIT    { $$ = $1; }
    ;

%%

int yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
    return 1;
}
