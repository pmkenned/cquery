%{
#include <stdio.h>
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
    { print_graph($1); }
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
    ENTITY IDENT IS PORT '(' port_list ')' ';' attribute_list END IDENT ';'
      { $$ = new_node("entity_def"); add_child($$, $2); add_child($$, $6); add_child($$, $9); }
    ;

port_list:    /* empty */
    | port
      { $$ = $1; }
    | port_list ';' port
      { $$ = node("port_list",$1,$3); }
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
    | bit_range
      { $$ = $1; }
    ;

bit_slice_opt: /* empty */
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
    | attribute_list attribute
      { $$ = node("attribute_list",$1,$2); }
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
      { $$ = node("arch_def",$2,$8); }
    ;

signal_list: /* empty */
    | signal_list signal_decl
      { $$ = node("ident_list",$1,$2); }
    ;

signal_decl:
    SIGNAL ident_list ':' IDENT bit_range_opt ';'
      { $$ = node("signal_decl",$2,$4); }
    ;

ident_list:
      IDENT /* not empty */
      { $$ = $1; }
    | ident_list ',' IDENT
      { $$ = node("ident_list",$1,$3); }
    ;

arch_body:
    list_of_assign_or_inst /* TODO: technically redundant */
      { $$ = $1; }
    ;

list_of_assign_or_inst: /* empty */
    | list_of_assign_or_inst assign
      { $$ = node("list_of_assign_or_inst",$1,$2); }
    | list_of_assign_or_inst instantiation
      { $$ = node("list_of_assign_or_inst",$1,$2); }
    ;

assign:
    signal_opt_vector LTEQ expr ';'
      { $$ = node("assign",$1,$3); }
    ;

signal_opt_vector:
    IDENT bit_slice_opt
      { $$ = node("signal_opt_vector",$1,$2); }
    ;

expr_list: /* empty */
    | expr
      { $$ = $1; }
    | expr_list ',' expr
      { $$ = node("expr_list",$1,$3); }
    ;

func_invocation:
    IDENT '(' expr_list ')'
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
      { $$ = node("binary",$1,$2); }
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
    IDENT ':' ENTITY IDENT '.' IDENT generic_map_opt PORT MAP '(' port_map_list ')' ';'
    { $$ = node("instantiation", $1, $11); }
    ;

generic_map_opt:
    | GENERIC MAP '(' generic_map_list ')'
    { $$ = node("generic_map_opt", $3, NULL); }
    ;

/* TODO: what is the difference between generic map and port map? */
generic_map_list:
      port_map_list
    { $$ = node("generic_map_list", $1, NULL); }
    ;

port_map_list: /* empty */
    | port_map
    { $$ = node("port_map_list", $1, NULL); }
    | port_map_list ',' port_map
    { $$ = node("port_map_list", $1, $3); }
    ;

port_map:
    expr bit_range_opt EQGT expr /* TODO: is it correct to use expr on both sides of EQGT? */
    { $$ = node("port_map", $1, $4); }
    ;

lib_stm:
    LIBRARY ident_list ';'
    { $$ = node("lib_stm", $1, $2); }
    ;

use_stm:
    USE ident_period_list ';'
    { $$ = node("use_stm", $1, $2); }
    ;

ident_period_list:
      IDENT
    {  $$ = $1; }
    | ident_period_list '.' IDENT /* TODO: no whitespace can be between period and identifier */
    {  $$ = node("ident_period_list", $1, $3); }
    ;

literal:
      STRING   { $$ = $1; }
    | NUMBER   { $$ = $1; }
    | DIGIT    { $$ = $1; }
    ;

%%

void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
    return 1;
}
