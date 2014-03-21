%{
#include <stdio.h>
#include <string.h>
%}

/* TODO:
  * Decide what to do for setup, hold, period, width etc.
  * Decide what to do for 'e' and 'E' number prefixes
  * Finish defining associativity for operators
  * UDP
  * constant_expression?
*/

/* Syntax */
%token ';' ':' '(' ')' '{' '}' '[' ']' ',' '.' '@' '#' '$' '?'
%token '+' '-' '*' '/' '%' '!' '~' '&' '|' '<' '>' '=' '^'

/* multi-character syntax */
%token TILDE_AMP            /*  ~&  */
%token CARET_PIPE           /*  ^|  */
%token TILDE_CARET          /*  ~^  */
%token EQ_EQ                /*  ==  */
%token NOT_EQ               /*  !=  */
%token EQ_EQ_EQ             /*  === */
%token NOT_EQ_EQ            /*  !== */
%token LAND                 /*  &&  */
%token AMP_AMP_AMP          /*  &&& */
%token LOR                  /*  ||  */
%token LTE                  /*  <=  */
%token GTE                  /*  >=  */
%token CARET_TILDE          /*  ^~  */
%token LSHIFT               /*  <<  */
%token RSHIFT               /*  >>  */
%token EQ_GT                /*  =>  */
%token AST_GT               /*  *>  */
%token HYPH_GT              /*  ->  */

%left  '+' '-'
%left  '*' '/' '%'
%left  LAND LOR '&' '|' '^' CARET_TILDE RSHIFT LSHIFT
%left EQ_EQ NOT_EQ EQ_EQ_EQ NOT_EQ_EQ
%nonassoc '<' '>' LTE GTE
%right '='

/* Keywords */
%token _BEGIN_     END
%token MACROMODULE
%token MODULE      ENDMODULE
%token PRIMITIVE   ENDPRIMITIVE
%token TABLE       ENDTABLE
%token TASK        ENDTASK
%token FUNCTION    ENDFUNCTION
%token SPECIFY     ENDSPECIFY
%token INTEGER REAL TIME
%token SPECPARAM PARAMETER DEFPARAM
%token INPUT OUTPUT INOUT
%token WIRE TRI TRI0 TRI1 SUPPLY0 SUPPLY1 WAND TRIAND TRIOR WOR TRIREG
%token SCALARED VECTORED
%token REG
%token EVENT
%token SMALL MEDIUM LARGE
%token STRONG0 STRONG1 PULL0 PULL1 WEAK0 WEAK1 HIGHZ0 HIGHZ1
%token AND NAND OR NOR XOR XNOR BUF BUFIF0 BUFIF1 NOT NOTIF0 NOTIF1 PULLDOWN PULLUP
%token NMOS RNMOS PMOS RPMOS CMOS RCMOS TRAN RTRAN TRANIF0 TRANIF1 RTRANIF0 RTRANIF1
%token ASSIGN DEASSIGN
%token _INITIAL_ ALWAYS
%token IF ELSE
%token CASE CASEZ CASEX ENDCASE DEFAULT
%token FOREVER REPEAT WHILE FOR WAIT
%token DISABLE
%token FORCE RELEASE
%token FORK JOIN
%token POSEDGE NEGEDGE EDGE

%token OUTPUT_SYMBOL INIT_VAL
%token STRING IDENTIFIER DECIMAL_NUMBER UNSIGNED_NUMBER BASE SCALAR_CONSTANT
%token LEVEL_SYMBOL EDGE_SYMBOL
%token EDGE_DESCRIPTOR

%start description_list

%%

description_list:	/* termination undetermined */
	| description_list description ;
	;

/* TODO: UDP */
description:	/* termination undetermined */
	  module
	;

module:	/* termination undetermined */
	  module_begin IDENTIFIER list_of_ports_encl_opt ';'
		module_item_list
		ENDMODULE
	;

module_begin:	/* termination undetermined */
      MODULE
    | MACROMODULE
    ;

list_of_ports_encl_opt:	/* termination undetermined */
	| '(' list_of_ports ')'
	;

/* TODO: port expressions and references */
list_of_ports:	/* termination undetermined */
	  IDENTIFIER
	| list_of_ports ',' IDENTIFIER
	;

module_item_list:	/* termination undetermined */
	| module_item_list module_item
	;

module_item:	/* termination undetermined */
      continuous_assign
    | module_instantiation
    | initial_statement
    | always_statement
    | input_declaration
    | output_declaration
    | inout_declaration
    | reg_declaration
    ;

continuous_assign:	/* termination undetermined */
	  ASSIGN list_of_assignments ';'
	| NETTYPE list_of_assignments ';'
	;

list_of_assignments:	/* termination undetermined */
	  assignment
	| list_of_assignments ',' assignment
	;

assignment:	/* termination undetermined */
	  lvalue '=' expression
	  ;

lvalue:	/* termination undetermined */
	  identifier_hier
	| identifier_hier '[' expression ']'
	| identifier_hier range
	| concatenation
	;

identifier_hier:
	  IDENTIFIER
	| identifier_hier '.' IDENTIFIER
	;

module_instantiation:	/* termination undetermined */
	  IDENTIFIER parameter_value_assignment_opt module_instance_list ';'
    ;

parameter_value_assignment_opt: /* empty */
	| parameter_value_assignment
	;

parameter_value_assignment:
	  '#' '(' expression_list ')'
	  ;

module_instance_list:
	  module_instance
	| module_instance_list ',' module_instance
	;

module_instance:
	  IDENTIFIER range_opt '(' list_of_module_connections_opt ')'
	  ;

list_of_module_connections_opt:
	| list_of_module_connections
	;

list_of_module_connections:
	  expression_opt_list
	| named_port_connection_list
	;

expression_opt_list:
	  expression_opt
	| expression_opt_list ',' expression_opt
	;

named_port_connection_list:
	  named_port_connection
	| named_port_connection_list ',' named_port_connection
	;

named_port_connection:
	  '.' IDENTIFIER '(' expression ')'
	  ;

initial_statement:	/* termination undetermined */
	  _INITIAL_ statement
    ;

always_statement:	/* termination undetermined */
	  ALWAYS statement
    ;

seq_block:
	  _BEGIN_ statement_list END
	| _BEGIN_ ':' IDENTIFIER block_declaration_list statement_list END
	;

block_declaration_list:
	| block_declaration_list block_declaration
	;

/* TODO: parameter, time, event, real, integer declaration */
block_declaration:
	  reg_declaration
	;

statement_list:
	| statement_list statement
	;

input_declaration:
	  INPUT range_opt list_of_identifiers ';'
    ;

output_declaration:
	  OUTPUT range_opt list_of_identifiers ';'
    ;

inout_declaration:
	  INOUT range_opt list_of_identifiers ';'
	  ;

reg_declaration:
	  REG range_opt list_of_register_variables ';'
	  ;

list_of_register_variables:
	  register_variable
	| list_of_register_variables ',' register_variable;

register_variable:
	  IDENTIFIER
	| IDENTIFIER range

statement_or_null:
	  statement
	| ';';

/* TODO: lots of things missing here */
statement: 	/* termination undetermined */
	  seq_block
    ;

list_of_identifiers:
	  IDENTIFIER
	| list_of_identifiers ',' IDENTIFIER
	;

range_opt:
	| range
	;

/* NOTE: used to be constant_expression */
range:
	  '[' expression ':' expression ']'
	  ;

/* TODO: function, mintypmax */
primary:	/* termination undetermined */
	  number
	| identifier_hier
	| identifier_hier '[' expression ']'
	| identifier_hier range
	| concatenation
	| multiple_concatenation
	;

concatenation:	/* termination undetermined */
	  '{' expression_list '}'
	  ;

multiple_concatenation:	/* termination undetermined */
	  '{' expression '{' expression_list '}' '}'
	  ;

expression_opt:
    | expression
    ;

expression:	/* termination undetermined */
	  primary
	| unary_operator primary
	| expression binary_operator expression
	| expression '?' expression ':' expression
	| STRING
	;

expression_list:	/* termination undetermined */
	  expression
	| expression_list ',' expression
	;

number:
	  DECIMAL_NUMBER
	| unsigned_number_opt BASE UNSIGNED_NUMBER
	| DECIMAL_NUMBER '.' UNSIGNED_NUMBER
	| DECIMAL_NUMBER dot_unsigned_number_opt 'E' DECIMAL_NUMBER
	| DECIMAL_NUMBER dot_unsigned_number_opt 'e' DECIMAL_NUMBER
	;

unsigned_number_opt:
	| UNSIGNED_NUMBER
	;

dot_unsigned_number_opt:
	| '.' UNSIGNED_NUMBER
	;

unary_operator:
	  '+'
	| '-'
	| '!'
	| '~'
	| '&'
	| TILDE_AMP
	| '|'
	| CARET_PIPE
	| '^'
	| TILDE_CARET
	;

binary_operator:
	  '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| EQ_EQ
	| NOT_EQ
	| EQ_EQ_EQ
	| NOT_EQ_EQ
	| LAND
	| LOR
	| '<'
	| LTE
	| '>'
	| GTE
	| '&'
	| '|'
	| '^'
	| CARET_TILDE
	| RSHIFT
	| LSHIFT
	;

NETTYPE:
	  WIRE
	| TRI
	| TRI1
	| SUPPLY0
	| WAND
	| TRIAND
	| TRI0
	| SUPPLY1
	| WOR
	| TRIOR
	| TRIREG
	;


