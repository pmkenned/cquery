%{
#include <stdio.h>
#include <string.h>
%}

/* TODO:
  * Decide what to do for setup, hold, period, width etc.
  * Decide what to do for 'e' and 'E' number prefixes
  * Finish defining associativity for operators
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

%left '+' '-'
%left '*' '/' '%'
%left '|' '&' '^' LAND LOR
%right '=' NOT_EQ NOT_EQ_EQ
%nonassoc '<' '>' LTE GTE

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

%start source_text

%%

description_list:
	| description_list description ;
	;

description:
	  module
	| UDP;
	;

module:
	  module_begin IDENTIFIER list_of_ports_encl_opt ';'
		module_item_list
		ENDMODULE
	;

module_begin:
      MODULE
    | MACROMODULE
    ;

list_of_ports_encl_opt:
	| '(' list_of_ports ')'
	;

list_of_ports:
	  port
	| list_of_ports ',' port
	;

port:
	  port_expression_opt
	| '.' IDENTIFIER '(' port_expression_opt ')'
	;

port_expression_opt:
	| port_expression
	;

port_expression:
	  port_reference
	| '{' port_reference_list '}'
	;

port_reference_list:
	  port_reference
	| port_reference_list ',' port_reference
	;

port_reference:
	  IDENTIFIER
	| IDENTIFIER '[' constant_expression ']'
	| IDENTIFIER '[' constant_expression ':' constant_expression ']'
	;


module_item_list:
	| module_item_list module_item
	;


module_item:
    ;
