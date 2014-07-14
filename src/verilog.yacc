%{
#include <stdio.h>
#include <string.h>
%}

/* TODO:
  * fix shift/reduce conflicts!
  * define tokens																	DONE
  * replace *, ?, and + with appropriate stuff										DONE
  * replace English descriptions													DONE
  * remove <>																		DONE
  * make "any of the following" into lists											DONE
  * surround all literal characters with ''											DONE
  * $functions
  * consider removing synonyms (pro: fewer non-terminals; con: less abstraction)
  * identifier_hier probably allows for spaces between '.' but shouldn't
*/

/* Notes:
  * Removed name_of_module. Just using IDENTIFIER.
  * Removed name_of_instance. Just using IDENTIFIER range_opt.
  * Removed name_of_UDP. Just using IDENTIFIER.
  * Removed name_of_variable. Just using IDENTIFIER.
  * Removed name_of_function. Just using IDENTIFIER (but maybe should use identifier_hier)
  * Removed name_of_port. Just using IDENTIFIER.
  * Removed name_of_block. Just using IDENTIFIER.
  * Removed name_of_task. Just using IDENTIFIER.
  * Removed name_of_register. Just using IDENTIFIER.
  * Removed name_of_memory. Just using IDENTIFIER.
*/

/* Syntax */
%token ';' ':' '(' ')' '{' '}' '[' ']' ',' '.' '@' '#' '$' '?'
%token '+' '-' '*' '/' '%' '!' '~' '&' '|' '<' '>' '=' '^'
%token 'e' 'E'

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

%token SETUP
%token HOLD
%token PERIOD
%token WIDTH
%token SKEW
%token RECOVERY
%token SETUPHOLD

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

source_text:
	  description_list ;

description_list:    /* empty */
	| description_list description ;

description:
	  module
	| UDP;

module_item_list:        /* empty */
	| module_item_list module_item;

module:
	  MODULE IDENTIFIER list_of_ports_encl_opt ';'
		module_item_list
		ENDMODULE
	| MACROMODULE IDENTIFIER list_of_ports_encl_opt ';'
		module_item_list
		ENDMODULE;

list_of_ports_encl_opt: /* empty */
	| list_of_ports_encl;

list_of_ports_encl:
	  '(' list_of_ports ')';

list_of_ports:
	  port
	| list_of_ports ',' port;

port:
	  port_expression_opt
	| '.' IDENTIFIER '(' port_expression_opt ')';

port_expression_opt: /* empty */
	| port_expression;

port_expression:
	  port_reference
	| '{' port_reference_list '}';

port_reference_list:
	  port_reference
	| port_reference_list ',' port_reference;

port_reference:
	  IDENTIFIER
	| IDENTIFIER '[' constant_expression ']'
	| IDENTIFIER '[' constant_expression ':' constant_expression ']';

module_item:
	  parameter_declaration
	| input_declaration
	| output_declaration
	| inout_declaration
	| net_declaration
	| reg_declaration
	| time_declaration
	| integer_declaration
	| real_declaration
	| event_declaration
	| gate_declaration
	| UDP_instantiation
	| module_instantiation
	| parameter_override
	| continuous_assign
	| specify_block
	| initial_statement
	| always_statement
	| task
	| function;

UDP:
	  PRIMITIVE IDENTIFIER '(' list_of_identifiers  ')' ';'
		UDP_declaration_list
		UDP_initial_statement_opt
		table_definition
		ENDPRIMITIVE;

UDP_declaration_list:
	  UDP_declaration
	| UDP_declaration_list UDP_declaration;

UDP_declaration:
	  output_declaration
	| reg_declaration
	| input_declaration;

UDP_initial_statement_opt: /* empty */
	| UDP_initial_statement;

UDP_initial_statement:
	  _INITIAL_ output_terminal_name '=' INIT_VAL ';';

output_terminal_name:
	  IDENTIFIER;

table_definition:
	  TABLE table_entries ENDTABLE;

table_entries:
	  combinational_entry_list
	| sequential_entry_list;

combinational_entry_list:
	  combinational_entry
	| combinational_entry_list combinational_entry;

combinational_entry:
	  level_input_list ':' OUTPUT_SYMBOL ';';

sequential_entry_list:
	  sequential_entry
	| sequential_entry_list sequential_entry;

sequential_entry:
	  input_list ':' state ':' next_state ';';

input_list:
	  level_input_list
	| edge_input_list;

level_input_list:
	  level_symbol_plus;

edge_input_list:
	  level_symbol_star edge level_symbol_star;

edge:
	  '(' LEVEL_SYMBOL LEVEL_SYMBOL ')'
	| EDGE_SYMBOL;

state:
	  LEVEL_SYMBOL;

next_state:
	  OUTPUT_SYMBOL
	| '-';

level_symbol_star:       /* star meaning 0 or more */
	| level_symbol_star LEVEL_SYMBOL;

level_symbol_plus: /* plus meaning one or more */
	  LEVEL_SYMBOL
	| level_symbol_plus LEVEL_SYMBOL;

task:
	  TASK IDENTIFIER ';'
		tf_declaration_star
		statement_or_null
		ENDTASK;

function:
	  FUNCTION range_or_type_opt IDENTIFIER ';'
		tf_declaration_plus
		statement
		ENDFUNCTION;

range_or_type_opt: /* empty */
	| range_or_type;

range_or_type:
	  range
	| INTEGER
	| REAL;

tf_declaration_star: /* empty */
	| tf_declaration_star tf_declaration;

tf_declaration_plus: /* empty */
	  tf_declaration
	| tf_declaration_plus tf_declaration;

tf_declaration:
	  parameter_declaration
	| input_declaration
	| output_declaration
	| inout_declaration
	| reg_declaration
	| time_declaration
	| integer_declaration
	| real_declaration;

parameter_declaration:
	  PARAMETER list_of_param_assignments ';';

input_declaration:
	  INPUT range_opt list_of_identifiers ';';

output_declaration:
	  OUTPUT range_opt list_of_identifiers ';';

inout_declaration:
	  INOUT range_opt list_of_identifiers ';';

net_declaration:
	  NETTYPE expandrange_opt delay_opt list_of_identifiers ';'
	| TRIREG charge_strength_opt expandrange_opt delay_opt list_of_identifiers ';'
	| NETTYPE drive_strength_opt expandrange_opt delay_opt list_of_assignments ';';

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
	| TRIREG;

expandrange_opt: /* empty */
	| expandrange;

expandrange:
	  range
	| SCALARED range
	| VECTORED range;

reg_declaration:
	  REG range_opt list_of_register_variables ';';

time_declaration:
	  TIME list_of_register_variables ';';

integer_declaration:
	  INTEGER list_of_register_variables ';';

real_declaration:
	  REAL list_of_identifiers ';';

event_declaration:
	  EVENT list_of_identifiers ';';

continuous_assign:
	  ASSIGN drive_strength_opt delay_opt list_of_assignments ';'
	| NETTYPE drive_strength_opt expandrange_opt delay_opt list_of_assignments ';';

parameter_override:
	  DEFPARAM list_of_param_assignments ';';

list_of_identifiers:
      IDENTIFIER
    | list_of_identifiers ',' IDENTIFIER
    ;

list_of_register_variables:
	  register_variable
	| list_of_register_variables ',' register_variable;

register_variable:
	  IDENTIFIER
	| IDENTIFIER '[' constant_expression ':' constant_expression ']';

charge_strength_opt: /* empty */
	| charge_strength;

charge_strength:
	  '(' SMALL ')'
	| '(' MEDIUM ')'
	| '(' LARGE ')';

drive_strength_opt: /* empty */
	| drive_strength;

drive_strength:
	  '(' STRENGTH0 ',' STRENGTH1 ')'
	| '(' STRENGTH1 ',' STRENGTH0 ')';

STRENGTH0:
	  SUPPLY0
	| STRONG0
	| PULL0
	| WEAK0
	| HIGHZ0;

STRENGTH1:
	  SUPPLY1
	| STRONG1
	| PULL1
	| WEAK1
	| HIGHZ1;

range_opt: /* empty */
	| range;

range:
	  '[' constant_expression ':' constant_expression ']';

list_of_assignments:
	  assignment
	| list_of_assignments ',' assignment;

gate_declaration:
	  GATETYPE drive_strength_opt delay_opt  gate_instance_list ';';

GATETYPE:
	  AND
	| NAND
	| OR
	| NOR
	| XOR
	| XNOR
	| BUF
	| BUFIF0
	| BUFIF1
	| NOT
	| NOTIF0
	| NOTIF1
	| PULLDOWN
	| PULLUP
	| NMOS
	| RNMOS
	| PMOS
	| RPMOS
	| CMOS
	| RCMOS
	| TRAN
	| RTRAN
	| TRANIF0
	| RTRANIF0
	| TRANIF1
	| RTRANIF1;

gate_instance_list:
	  gate_instance
	| gate_instance_list ',' gate_instance;

gate_instance:
	  name_of_gate_instance_opt '(' terminal_list ')';

name_of_gate_instance_opt: /* empty */
	| name_of_gate_instance;

name_of_gate_instance:
	  IDENTIFIER range_opt;

UDP_instantiation:
	  IDENTIFIER drive_strength_opt delay_opt UDP_instance_list ';';

UDP_instance_list:
	  UDP_instance
	| UDP_instance_list ',' UDP_instance;

UDP_instance:
	  name_of_UDP_instance_opt '(' terminal_list ')';

name_of_UDP_instance_opt: /* empty */
	| name_of_UDP_instance;

name_of_UDP_instance:
	  IDENTIFIER range_opt;

terminal_list:
	  terminal
	| terminal_list ',' terminal;

terminal:
	  expression
	| IDENTIFIER;

module_instantiation:
	  IDENTIFIER parameter_value_assignment_opt module_instance_list ';';

parameter_value_assignment_opt: /* empty */
	| parameter_value_assignment;

parameter_value_assignment:
	  '#' '(' expression_list ')';

module_instance_list:
	  module_instance
	| module_instance_list ',' module_instance;

module_instance:
	  IDENTIFIER range_opt '(' list_of_module_connections_opt ')';

list_of_module_connections_opt: /* empty */
	| list_of_module_connections;

list_of_module_connections:
	  module_port_connection_list
	| named_port_connection_list;

module_port_connection_list:
	  module_port_connection
	| module_port_connection_list ',' module_port_connection;

module_port_connection: /* empty */
	| expression;

named_port_connection_list:
	  named_port_connection
	| named_port_connection_list ',' named_port_connection;

/* TODO: not supposed to allow for space. Maybe have lex make a special token */
named_port_connection:
	  '.' IDENTIFIER '(' expression ')';

initial_statement:
	  _INITIAL_ statement;

always_statement:
	  ALWAYS statement;

statement_or_null:
	  statement
	| ';';

statement_list: /* empty */
	| statement_list statement;

statement:
	 blocking_assignment ';'
	| non_blocking_assignment ';'
	| IF '(' expression ')' statement_or_null
	| IF '(' expression ')' statement_or_null ELSE statement_or_null
	| CASE '(' expression ')' case_item_list ENDCASE
	| CASEZ '(' expression ')' case_item_list ENDCASE
	| CASEX '(' expression ')' case_item_list ENDCASE
	| FOREVER statement
	| REPEAT '(' expression ')' statement
	| WHILE '(' expression ')' statement
	| FOR '(' assignment ';' expression ';' assignment ')' statement
	| delay_or_event_control statement_or_null
	| WAIT '(' expression ')' statement_or_null
	| HYPH_GT IDENTIFIER ';'
	| seq_block
	| par_block
	| task_enable
	| system_task_enable
	| DISABLE IDENTIFIER ';'
	| DISABLE IDENTIFIER ';'
	| ASSIGN assignment ';'
	| DEASSIGN lvalue ';'
	| FORCE assignment ';'
	| RELEASE lvalue ';';

assignment:
	  lvalue '=' expression;

blocking_assignment:
	  lvalue '=' expression
	| lvalue '=' delay_or_event_control expression ';';

non_blocking_assignment:
	  lvalue LTE expression
	| lvalue '=' delay_or_event_control expression ';';

delay_or_event_control:
	  delay_control
	| event_control
	| REPEAT '(' expression ')' event_control;

case_item_list:
	  case_item
	| case_item_list case_item;

case_item:
	  expression_list ':' statement_or_null
	| DEFAULT ':' statement_or_null
	| DEFAULT statement_or_null;

seq_block:
	  _BEGIN_ statement_list END
	| _BEGIN_ ':' IDENTIFIER block_declaration_list statement_list END;

par_block:
	  FORK statement_list JOIN
	| FORK ':' IDENTIFIER block_declaration_list statement_list JOIN;

block_declaration_list: /* empty */
	| block_declaration_list block_declaration;

block_declaration:
	  parameter_declaration
	| reg_declaration
	| integer_declaration
	| real_declaration
	| time_declaration
	| event_declaration;

task_enable:
	  IDENTIFIER
	| IDENTIFIER '(' expression_list ')' ';';

system_task_enable:
	  name_of_system_task ';'
	| name_of_system_task '(' expression_list ')' ';';

name_of_system_task:
	  '$' system_identifier /* (Note: the $ may not be followed by a space.) */;

system_identifier:
	IDENTIFIER /* TODO: An IDENTIFIER assigned to an existing system task or function */;

specify_block:
	  SPECIFY specify_item_list ENDSPECIFY;

specify_item_list: /* empty */
	| specify_item_list specify_item;

specify_item:
	  specparam_declaration
	| path_declaration
	| level_sensitive_path_declaration
	| edge_sensitive_path_declaration
	| system_timing_check
	| sdpd;

specparam_declaration:
	  SPECPARAM list_of_param_assignments ';';

list_of_param_assignments:
	  param_assignment
	| list_of_param_assignments ',' param_assignment;

param_assignment:
	 identifier_hier '=' constant_expression;

path_declaration:
	  path_description '=' path_delay_value ';';

path_description:
	  '(' specify_input_terminal_descriptor EQ_GT specify_output_terminal_descriptor ')'
	| '(' list_of_path_inputs AST_GT list_of_path_outputs ')';

list_of_path_inputs:
	  specify_input_terminal_descriptor_list;

list_of_path_outputs:
	   specify_output_terminal_descriptor_list;

specify_input_terminal_descriptor_list:
	  specify_input_terminal_descriptor
	| specify_input_terminal_descriptor_list ',' specify_input_terminal_descriptor;

specify_input_terminal_descriptor:
	  input_identifier
	| input_identifier '[' constant_expression ']'
	| input_identifier '[' constant_expression ':' constant_expression ']';

specify_output_terminal_descriptor_list:
	  specify_output_terminal_descriptor
	| specify_output_terminal_descriptor_list ',' specify_output_terminal_descriptor;

specify_output_terminal_descriptor:
	  output_identifier
	| output_identifier '[' constant_expression ']'
	| output_identifier '[' constant_expression ':' constant_expression ']';

/* the IDENTIFIER of a module input or inout terminal */
input_identifier:
	  IDENTIFIER;

/* the IDENTIFIER of a module output or inout terminal. */
output_identifier:
	  IDENTIFIER ;

path_delay_value:
	  path_delay_expression
	| '(' path_delay_expression',' path_delay_expression ')'
	| '(' path_delay_expression',' path_delay_expression','
		path_delay_expression')'
	| '(' path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression ')'
	| '(' path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression','
		path_delay_expression',' path_delay_expression ')';

path_delay_expression:
	  mintypmax_expression;

comma_const_exp_comma_notify_reg_opt: /* empty */
	| ',' constant_expression ',' notify_register;

system_timing_check:
	  '$' SETUP     '(' timing_check_event ',' timing_check_event ',' timing_check_limit comma_notify_register_opt ')' ';'
	| '$' HOLD      '(' timing_check_event ',' timing_check_event ',' timing_check_limit comma_notify_register_opt ')' ';'
	| '$' PERIOD    '(' controlled_timing_check_event ',' timing_check_limit comma_notify_register_opt ')' ';'
	| '$' WIDTH     '(' controlled_timing_check_event ',' timing_check_limit comma_const_exp_comma_notify_reg_opt ')' ';'
	| '$' SKEW      '(' timing_check_event ',' timing_check_event ',' timing_check_limit comma_notify_register_opt ')' ';'
	| '$' RECOVERY  '(' controlled_timing_check_event ',' timing_check_event ',' timing_check_limit comma_notify_register_opt ')' ';'
	| '$' SETUPHOLD '(' timing_check_event ',' timing_check_event ',' timing_check_limit',' timing_check_limit comma_notify_register_opt ')' ';';

timing_check_event:
	  timing_check_event_control_opt specify_terminal_descriptor
		amp_timing_check_condition_opt;

specify_terminal_descriptor:
	  specify_input_terminal_descriptor
	|specify_output_terminal_descriptor;

controlled_timing_check_event:
	  timing_check_event_control specify_terminal_descriptor
		amp_timing_check_condition_opt;

timing_check_event_control_opt: /* empty */
	| timing_check_event_control;

timing_check_event_control:
	  POSEDGE
	| NEGEDGE
	| edge_control_specifier;

edge_control_specifier:
	  EDGE  '[' edge_descriptor_list ']';

edge_descriptor_list:
	  EDGE_DESCRIPTOR
	| edge_descriptor_list ',' EDGE_DESCRIPTOR;

amp_timing_check_condition_opt: /* empty */
	| AMP_AMP_AMP timing_check_condition;

timing_check_condition:
	  scalar_timing_check_condition
	| '(' scalar_timing_check_condition ')';

scalar_timing_check_condition:
	  scalar_expression
	| '~' scalar_expression
	| scalar_expression EQ_EQ SCALAR_CONSTANT
	| scalar_expression EQ_EQ_EQ SCALAR_CONSTANT
	| scalar_expression NOT_EQ SCALAR_CONSTANT
	| scalar_expression NOT_EQ_EQ SCALAR_CONSTANT;

/*	TODO: A scalar expression is a one bit net or a bit-select of an expanded vector net. */
scalar_expression:
	  identifier_hier
	| identifier_hier '[' expression ']';

timing_check_limit:
	  expression;

comma_notify_register_opt: /* empty */
	| ',' notify_register;

notify_register:
	  identifier_hier;

level_sensitive_path_declaration:
	  IF '(' conditional_port_expression')'
		'(' specify_input_terminal_descriptor polarity_operator_opt EQ_GT
		specify_output_terminal_descriptor ')' '=' path_delay_value ';'
	| IF '(' conditional_port_expression ')'
		'(' list_of_path_inputs polarity_operator_opt AST_GT
		list_of_path_outputs ')' '=' path_delay_value ';';

conditional_port_expression:
	  port_reference
	| unary_operator port_reference
	| port_reference binary_operator port_reference;

polarity_operator_opt: /* empty */
	| polarity_operator;

polarity_operator:
	  '+'
	| '-';

if_expression_opt: /* empty */
	| IF '(' expression ')';

edge_sensitive_path_declaration:
	  if_expression_opt '(' edge_identifier_opt
		specify_input_terminal_descriptor EQ_GT
		'(' specify_output_terminal_descriptor polarity_operator_opt
		':' data_source_expression ')' ')' '=' path_delay_value ';'
	| if_expression_opt '(' edge_identifier_opt
		specify_input_terminal_descriptor AST_GT
		'(' list_of_path_outputs polarity_operator_opt
		':' data_source_expression ')' ')' '=' path_delay_value ';';

/* TODO: should this actually be expression list? */
data_source_expression:
	  expression;

edge_identifier_opt: /* empty */
	| edge_identifier;

edge_identifier:
	  POSEDGE
	| NEGEDGE;

sdpd:
	 IF '(' sdpd_conditional_expression ')' path_description '=' path_delay_value ';';

sdpd_conditional_expression:
	  expression binary_operator expression
	| unary_operator expression;

lvalue:
	  identifier_hier
	| identifier_hier '[' expression ']'
	| identifier_hier '[' constant_expression ':' constant_expression ']'
	| concatenation;

constant_expression:
	 expression;

comma_mintypmax_expression_opt: /* empty */
	| ',' mintypmax_expression;

mintypmax_expression:
	  expression
	| expression ':' expression ':' expression;

expression_list:
	  expression
	| expression_list ',' expression;

expression:
	  primary
	| unary_operator primary
	| expression binary_operator expression
	| expression '?' expression ':' expression
	| STRING;

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
	| TILDE_CARET;

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
	| LSHIFT;

primary:
	  number
	| identifier_hier
	| identifier_hier '[' expression ']'
	| identifier_hier '[' constant_expression ':' constant_expression ']'
	| concatenation
	| multiple_concatenation
	| function_call
	| '(' mintypmax_expression ')';

unsigned_number_opt:
	| UNSIGNED_NUMBER;

dot_unsigned_number_opt: /* empty */
	| '.' UNSIGNED_NUMBER;

/* TODO: should this be a token? */
/*	(Note: embedded spaces are illegal in Verilog numbers, but embedded underscore
	characters can be used for spacing in any type of number.) */
number:
	  DECIMAL_NUMBER
	| unsigned_number_opt BASE UNSIGNED_NUMBER
	| DECIMAL_NUMBER '.' UNSIGNED_NUMBER
	| DECIMAL_NUMBER dot_unsigned_number_opt
		'E' DECIMAL_NUMBER
	| DECIMAL_NUMBER dot_unsigned_number_opt
		'e' DECIMAL_NUMBER;

concatenation:
	  '{' expression_list '}';

multiple_concatenation:
	  '{' expression '{' expression_list '}' '}';

function_call:
	  IDENTIFIER '(' expression_list ')'
	| name_of_system_function '(' expression_list ')'
	| name_of_system_function;

name_of_system_function:
	  '$' system_identifier; /* TODO: the $ may not be followed by a space. */

/* TODO: this should probably be a token to disallow whitespace between identifiers */
identifier_hier:
	  IDENTIFIER
	| identifier_hier '.' IDENTIFIER;

delay_opt: /* empty */
	| delay;

delay:
	  '#' number
	| '#' identifier_hier
	| '#' '(' mintypmax_expression comma_mintypmax_expression_opt comma_mintypmax_expression_opt ')';

delay_control:
	  '#' number
	| '#' identifier_hier
	| '#' '(' mintypmax_expression ')';

event_control:
	  '@' identifier_hier
	| '@' '(' event_expression ')';

event_expression:
	  expression
	| POSEDGE scalar_event_expression
	| NEGEDGE scalar_event_expression
	| event_expression OR event_expression;

/* Scalar event expression is an expression that resolves to a one bit value.
   Compiler needs to confirm that this identifier is only 1 bit. */
scalar_event_expression:
	  IDENTIFIER;

/* NOTE: the lexer will remove comments */
/*;
comment:
	  short_comment
	| long_comment

short_comment:
	  // comment_text <END-OF-LINE>

long_comment: 
	  /* comment_text * /

comment_text:
	  The comment text is zero or more ASCII characters
*/


%%

main()
{
    yydebug = 1;
	return(yyparse());
}

int yywrap()
{
    return 1;
}

yyerror(char * s) {
    fprintf(stderr, "%s\n",s);
}
