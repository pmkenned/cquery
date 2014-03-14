%{
%}

/* TODO:
  * define tokens
  * replace *, ?, and + with appropriate stuff
  * replace English descriptions
  * remove <>
  * make "any of the following" into lists
  * surround all literal characters with ''
  * $functions
  * consider removing synonyms (pro: fewer non-terminals; con: less abstraction)
  * identifier_hier probably allows for spaces between '.' but shouldn't
*/

/* Syntax */
%token ';' ':' '(' ')' '{' '}' '[' ']' ',' '.' '@' '#'
%token '+' '-' '*' '/' '%' '!' '~' '&' '|' '<' '>'

/* Keywords */
%token IDENTIFIER
%token BEGIN       END
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
%token WIRE TRI TRI0 TRI1 SUPPLY0 SUPPLY1 WAND WOR TRIREG
%token SCALARED VECTORED
%token REG
%token EVENT
%token SMALL MEDIUM LARGE
%token STRONG0 STRONG1 PULL0 PULL1 WEAK0 WEAK1 HIGHZ0 HIGHZ1
%token AND NAND OR NOR XOR XNOR BUFIF0 BUFIF1 NOT NOTIF0 NOTIF1 PULLDOWN PULLUP
%token NMOS RNMOS RPMOS CMOS RCMOS TRAN RTRAN TRANIF0 TRANIF1 RTRANIF0 RTRANIF1
%token ASSIGN DEASSIGN
%token INTIAL ALWAYS
%token IF ELSE
%token CASE CASEZ CASEX ENDCASE DEFAULT
%token FOREVER REPEAT WHILE FOR WAIT
%token DISABLE
%token FORCE RELEASE
%token FORK JOIN
%token POSEDGE NEGEDGE EDGE

%token OUTPUT_SYMBOL INIT_VAL
%token STRING NUMBER DECIMAL_NUMBER UNSIGNED_NUMBER BASE
%token LEVEL_SYMBOL EDGE_SYMBOL
%token NULL EDGE_DESCRIPTOR

/* IDENTIFIER:
	An identifier is any sequence of letters, digits, dollar signs ($), and
	underscore (_) symbol, except that the first must be a letter or the
	underscore; the first character may not be a digit or $. Upper and lower case
	letters are considered to be different. Identifiers may be up to 1024
	characters long. Some Verilog-based tools do not recognize  identifier
	characters beyond the 1024th as a significant part of the identifier. Escaped
	identifiers start with the backslash character (\) and may include any
	printable ASCII character. An escaped identifier ends with white space. The
	leading backslash character is not considered to be part of the identifier. */

/* STRING: is text enclosed in "" and contained on one line. */

/* NUMBER:
	Numbers can be specified in decimal, hexadecimal, octal or binary, and may
	optionally start with a + or -.  The <BASE> token controls what number digits
	are legal.  <BASE> must be one of d, h, o, or b, for the bases decimal,
	hexadecimal, octal, and binary respectively. A number can contain any set of
	the following characters that is consistent with <BASE>:
	0123456789abcdefABCDEFxXzZ? */

/* OUTPUT_SYMBOL: is one of the following characters:
	  0
	| 1
	| x
	| X */

/* INIT_VAL:
	  1'b0
	| 1'b1
	| 1'bx
	| 1'bX
	| 1'B0
	| 1'B1
	| 1'Bx
	| 1'BX
	| 1
	| 0 */

/* LEVEL_SYMBOL:
	  0
	| 1
	| x
	| X
	| '?'
	| b
	| B */

/* EDGE_SYMBOL:
	  r
	| R
	| f
	| F
	| p
	| P
	| n
	| N
	| '*' */

/* NULL:
	  nothing - this form covers the case of an empty item in a list - for example:
	      (a, b, , d) */

/* DECIMAL_NUMBER:
	  A number containing a set of any of the following characters, optionally preceded by + or -
	 	0123456789_ */

/* UNSIGNED_NUMBER:
	  A number containing a set of any of the following characters:
	        0123456789_ */

/* BASE:
	  'b
	| 'B
	| 'o
	| 'O
	| 'd
	| 'D
	| 'h
	| 'H */

/* EDGE_DESCRIPTOR:
	  01
	| 10
	| 0x
	| x1
	| 1x
	| x0 */

%start source_text

%%

source_text:
	  <description_list>

description_list:    /* empty */
	| <description_list> <description>

description:
	  <module>
	| <UDP>

module_item_list:        /* empty */
	| <module_item_list> <module_item>

module:
	  MODULE <name_of_module> <list_of_ports_encl_opt> ';'
		<module_item_list>
		ENDMODULE
	| MACROMODULE <name_of_module> <list_of_ports_encl_opt> ';'
		<module_item_list>
		ENDMODULE

name_of_module:
	  <IDENTIFIER>

list_of_ports_encl_opt: /* empty */
	| <list_of_ports_encl>

list_of_ports_encl:
	  '(' <list_of_ports> ')'

list_of_ports:
	  <port>
	| <list_of_ports> ',' <port>

port:
	  <port_expression_opt>
	| '.' <name_of_port> '(' <port_expression_opt> ')'

port_expression_opt: /* empty */
	| <port_expression>

port_expression:
	  <port_reference>
	| '{' <port_reference_list> '}'

port_reference_list:
	  <port_reference>
	| <port_reference_list> ',' <port_reference>

port_reference:
	  <name_of_variable>
	| <name_of_variable> '[' <constant_expression> ']'
	| <name_of_variable> '[' <constant_expression> ':'<constant_expression> ']'

name_of_port:
	  <IDENTIFIER>

name_of_variable:
	  <IDENTIFIER>

module_item:
	  <parameter_declaration>
	| <input_declaration>
	| <output_declaration>
	| <inout_declaration>
	| <net_declaration>
	| <reg_declaration>
	| <time_declaration>
	| <integer_declaration>
	| <real_declaration>
	| <event_declaration>
	| <gate_declaration>
	| <UDP_instantiation>
	| <module_instantiation>
	| <parameter_override>
	| <continuous_assign>
	| <specify_block>
	| <initial_statement>
	| <always_statement>
	| <task>
	| <function>

UDP:
	  PRIMITIVE <name_of_UDP> '(' <list_of_variables>  ')' ';'
		<UDP_declaration_list>
		<UDP_initial_statement_opt>
		<table_definition>
		ENDPRIMITIVE

name_of_UDP:
	  <IDENTIFIER>

UDP_declaration_list:
	  <UDP_declaration>
	| <UDP_declaration_list> <UDP_declaration>

UDP_declaration:
	  <output_declaration>
	| <reg_declaration>
	| <input_declaration>

UDP_initial_statement_opt: /* empty */
	| <UDP_initial_statement>

UDP_initial_statement:
	  INITIAL <output_terminal_name> = <INIT_VAL> ';'

output_terminal_name:
	  <name_of_variable>

table_definition:
	  TABLE <table_entries> ENDTABLE

table_entries:
	  <combinational_entry_list>
	| <sequential_entry_list>

combinational_entry_list:
	  <combinational_entry>
	| <combinational_entry_list> <combinational_entry>

combinational_entry:
	  <level_input_list> ':' <OUTPUT_SYMBOL> ';'

sequential_entry_list:
	  <sequential_entry>
	| <sequential_entry_list> <sequential_entry>

sequential_entry:
	  <input_list> ':' <state> ':' <next_state> ';'

input_list:
	  <level_input_list>
	| <edge_input_list>

level_input_list:
	  <level_symbol_plus>

edge_input_list:
	  <level_symbol_star> <edge> <level_symbol_star>

edge:
	  '(' <LEVEL_SYMBOL> <LEVEL_SYMBOL> ')'
	| <EDGE_SYMBOL>

state:
	  <LEVEL_SYMBOL>

next_state:
	  <OUTPUT_SYMBOL>
	| '-'

level_symbol_star:       /* star meaning 0 or more */
	| <level_symbol_star> <LEVEL_SYMBOL>

level_symbol_plus: /* plus meaning one or more */
	  <LEVEL_SYMBOL>
	| <level_symbol_plus> <LEVEL_SYMBOL>

task:
	  TASK <name_of_task> ';'
		<tf_declaration_star>
		<statement_or_null>
		ENDTASK

name_of_task:
	  <IDENTIFIER>

function:
	  FUNCTION <range_or_type_opt> <name_of_function> ';'
		<tf_declaration_plus>
		<statement>
		ENDFUNCTION

range_or_type_opt: /* empty */
	| <range_or_type>

range_or_type:
	  <range>
	| INTEGER
	| REAL

name_of_function:
	  <IDENTIFIER>

tf_declaration_star: / * empty */
	| <tf_declaration_star> <tf_declaration>

tf_declaration_plus: / * empty */
	  <tf_declaration>
	| <tf_declaration_plus> <tf_declaration>

tf_declaration:
	  <parameter_declaration>
	| <input_declaration>
	| <output_declaration>
	| <inout_declaration>
	| <reg_declaration>
	| <time_declaration>
	| <integer_declaration>
	| <real_declaration>

parameter_declaration:
	  PARAMETER <list_of_param_assignments> ';'

list_of_param_assignments:
	  <param_assignment>
	| <list_of_param_assignments> ',' <param_assignment>

param_assignment:
	 <identifier_hier> = <constant_expression>

input_declaration:
	  INPUT <range_opt> <list_of_variables> ';'

output_declaration:
	  OUTPUT <range_opt> <list_of_variables> ';'

inout_declaration:
	  INOUT <range_opt> <list_of_variables> ';'

net_declaration:
	  <NETTYPE> <expandrange_opt> <delay_opt> <list_of_variables> ';'
	| TRIREG <charge_strength_opt> <expandrange_opt> <delay_opt> <list_of_variables> ';'
	| <NETTYPE> <drive_strength_opt> <expandrange_opt> <delay_opt> <list_of_assignments> ';'

NETTYPE: is one of the following keywords:
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

expandrange_opt: /* empty */
	| <expandrange>

expandrange:
	  <range>
	| SCALARED <range>
	| VECTORED <range>

reg_declaration:
	  REG <range_opt> <list_of_register_variables> ';'

time_declaration:
	  TIME <list_of_register_variables> ';'

integer_declaration:
	  INTEGER <list_of_register_variables> ';'

real_declaration:
	  REAL <list_of_variables> ';'

event_declaration:
	  EVENT <list_of_name_of_events> ';'

continuous_assign:
	  ASSIGN <drive_strength_opt> <delay_opt> <list_of_assignments> ';'
	| <NETTYPE> <drive_strength_opt> <expandrange_opt> <delay_opt> <list_of_assignments> ';'

parameter_override:
	  DEFPARAM <list_of_param_assignments> ';'

list_of_variables:
	  <name_of_variable>
	| <list_of_variables> ',' <name_of_variable>

name_of_variable:
	  <IDENTIFIER>

list_of_register_variables:
	  <register_variable>
	| <list_of_register_variables> ',' <register_variable>

register_variable:
	  <name_of_register>
	| <name_of_memory> '[' <constant_expression> ':' <constant_expression> ']'

name_of_register:
	  <IDENTIFIER>

name_of_memory:
	  <IDENTIFIER>

list_of_name_of_events:
	  <name_of_event>
	| <list_of_name_of_events> ',' <name_of_event>

name_of_event:
	  <IDENTIFIER>

charge_strength_opt: /* empty */
	| <charge_strength>

charge_strength:
	  '(' SMALL ')'
	| '(' MEDIUM ')'
	| '(' LARGE ')'

drive_strength_opt: /* empty */
	| <drive_strength>

drive_strength:
	  '(' <STRENGTH0> ',' <STRENGTH1> ')'
	| '(' <STRENGTH1> ',' <STRENGTH0> ')'

STRENGTH0: is one of the following keywords:
	  SUPPLY0
	| STRONG0
	| PULL0
	| WEAK0
	| HIGHZ0

STRENGTH1: is one of the following keywords:
	  SUPPLY1
	| STRONG1
	| PULL1
	| WEAK1
	| HIGHZ1

range_opt: /* empty */
	| <range>

range:
	  '[' <constant_expression> ':' <constant_expression> ']'

list_of_assignments:
	  <assignment>
	| <list_of_assignments> ',' <assignment>

gate_declaration:
	  <GATETYPE> <drive_strength_opt> <delay_opt>  <gate_instance_list> ';'

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
	| RTRANIF1

gate_instance_list:
	  <gate_instance>
	| <gate_instance_list> ',' <gate_instance>

gate_instance:
	  <name_of_gate_instance_opt> '(' <terminal_list> ')'

name_of_gate_instance_opt: /* empty */
	| <name_of_gate_instance>

name_of_gate_instance:
	  <IDENTIFIER><range_opt>

UDP_instantiation:
	  <name_of_UDP> <drive_strength_opt> <delay_opt> <UDP_instance_list> ';'

name_of_UDP:
	  <IDENTIFIER>

UDP_instance_list:
	  <UDP_instance>
	| <UDP_instance_list> ',' <UDP_instance>

UDP_instance:
	  <name_of_UDP_instance_opt> '(' <terminal_list> ')'

name_of_UDP_instance_opt: /* empty */
	| <name_of_UDP_instance>

name_of_UDP_instance:
	  <IDENTIFIER><range_opt>

terminal_list:
	  <terminal>
	| <terminal_list> ',' <terminal>

terminal:
	  <expression>
	| <IDENTIFIER>

module_instantiation:
	  <name_of_module> <parameter_value_assignment_opt>
		<module_instance_list> ';'

name_of_module:
	  <IDENTIFIER>

parameter_value_assignment_opt: /* empty */
	| <parameter_value_assignment_opt>

parameter_value_assignment:
	  # '(' <expression_list> ')'

module_instance_list:
	  <module_instance>
	| <module_instance_list> ',' <module_instance>

module_instance:
	  <name_of_instance> '(' <list_of_module_connections_opt> ')'

name_of_instance:
	  <IDENTIFIER><range_opt>

list_of_module_connections_opt: /* empty */
	| <list_of_module_connections>

list_of_module_connections:
	  <module_port_connection_list>
	| <named_port_connection_list>

module_port_connection_list:
	  <module_port_connection>
	| <module_port_connection_list> ',' <module_port_connection>

module_port_connection:
	  <expression>
	| <NULL>

named_port_connection_list:
	  <named_port_connection>
	| <named_port_connection_list> ',' <named_port_connection>

named_port_connection:
	  '.'< IDENTIFIER> '(' <expression> ')' /* TODO: can this allow for space? */

initial_statement:
	  INITIAL <statement>

always_statement:
	  ALWAYS <statement>

statement_or_null:
	  <statement>
	| ';'

statement_list: /* empty */
	| <statement_list> <statement>

statement:
	 <blocking_assignment> ';'
	| <non_blocking_assignment> ';'
	| IF '(' <expression> ')' <statement_or_null>
	| IF '(' <expression> ')' <statement_or_null> ELSE <statement_or_null>
	| CASE '(' <expression> ')' <case_item_list> ENDCASE
	| CASEZ '(' <expression> ')' <case_item_list> ENDCASE
	| CASEX '(' <expression> ')' <case_item_list> ENDCASE
	| FOREVER <statement>
	| REPEAT '(' <expression> ')' <statement>
	| WHILE '(' <expression> ')' <statement>
	| FOR '(' <assignment> ';' <expression> ';' <assignment> ')' <statement>
	| <delay_or_event_control> <statement_or_null>
	| WAIT '(' <expression> ')' <statement_or_null>
	| -> <name_of_event> ';'
	| <seq_block>
	| <par_block>
	| <task_enable>
	| <system_task_enable>
	| DISABLE <name_of_task> ';'
	| DISABLE <name_of_block> ';'
	| ASSIGN <assignment> ';'
	| DEASSIGN <lvalue> ';'
	| FORCE <assignment> ';'
	| RELEASE <lvalue> ';'

assignment:
	  <lvalue> = <expression>

blocking_assignment:
	  <lvalue> = <expression>
	| <lvalue> = <delay_or_event_control> <expression> ';'

non_blocking_assignment:
	  <lvalue> <= <expression>
	| <lvalue> = <delay_or_event_control> <expression> ';'

delay_or_event_control:
	  <delay_control>
	| <event_control>
	| REPEAT '(' <expression> ')' <event_control>

case_item_list:
	  <case_item>
	| <case_item_list> <case_item>

case_item:
	  <expression_list> ':' <statement_or_null>
	| DEFAULT ':' <statement_or_null>
	| DEFAULT <statement_or_null>

seq_block:
	  BEGIN <statement_list> END
	| BEGIN ':' <name_of_block> <block_declaration_list> <statement_list> END

par_block:
	  FORK <statement_list> JOIN
	| FORK ':' <name_of_block> <block_declaration_list> <statement_list> JOIN

name_of_block:
	  <IDENTIFIER>

block_declaration_list: /* empty */
	| <block_declaration_list> <block_declaration>

block_declaration:
	  <parameter_declaration>
	| <reg_declaration>
	| <integer_declaration>
	| <real_declaration>
	| <time_declaration>
	| <event_declaration>

task_enable:
	  <name_of_task>
	| <name_of_task> '(' <expression_list> ')' ';'

system_task_enable:
	  <name_of_system_task> ';'
	| <name_of_system_task> '(' <expression_list> ')' ';'

name_of_system_task:
	  $<system_identifier> (Note: the $ may not be followed by a space.)

/* TODO: English */
SYSTEM_IDENTIFIER:
	An <IDENTIFIER> assigned to an existing system task or function

specify_block:
	  SPECIFY <specify_item_list> ENDSPECIFY

specify_item_list: /* empty */
	| <specify_item_list> <specify_item>

specify_item:
	  <specparam_declaration>
	| <path_declaration>
	| <level_sensitive_path_declaration>
	| <edge_sensitive_path_declaration>
	| <system_timing_check>
	| <sdpd>

specparam_declaration:
	  SPECPARAM <list_of_param_assignments> ';'

list_of_param_assignments:
	 <param_assignment_list>

param_assignment_list:
	  <param_assignment>
	| <param_assignment_list> ',' <param_assignment>

param_assignment:
	 <<identifier_hier>=<constant_expression>>

path_declaration:
	  <path_description> = <path_delay_value> ';'

path_description:
	  '(' <specify_input_terminal_descriptor> => <specify_output_terminal_descriptor> ')'
	| '(' <list_of_path_inputs> *> <list_of_path_outputs> ')'

list_of_path_inputs:
	  <specify_input_terminal_descriptor_list>

list_of_path_outputs:
	   <specify_output_terminal_descriptor_list>

specify_input_terminal_descriptor_list:
	  <specify_input_terminal_descriptor>
	| <specify_input_terminal_descriptor_list> ',' <specify_input_terminal_descriptor>

specify_input_terminal_descriptor:
	  <input_identifier>
	| <input_identifier> '[' <constant_expression> ']'
	| <input_identifier> '[' <constant_expression> ':' <constant_expression> ']'

specify_output_terminal_descriptor_list:
	  <specify_output_terminal_descriptor>
	| <specify_output_terminal_descriptor_list> ',' <specify_output_terminal_descriptor>

specify_output_terminal_descriptor:
	  <output_identifier>
	| <output_identifier> '[' <constant_expression> ']'
	| <output_identifier> '[' <constant_expression> ':' <constant_expression> ']'

input_identifier:
	  the <IDENTIFIER> of a module input or inout terminal

output_identifier:
	  the <IDENTIFIER> of a module output or inout terminal.

path_delay_value:
	  <path_delay_expression>
	| '(' <path_delay_expression>',' <path_delay_expression> ')'
	| '(' <path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>')'
	| '(' <path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression> ')'
	| '(' <path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression>','
		<path_delay_expression>',' <path_delay_expression> ')'

path_delay_expression:
	  <mintypmax_expression>

system_timing_check:
	  $setup'(' <timing_check_event>',' <timing_check_event>','
		<timing_check_limit>
		<comma_notify_register_opt> ')' ';'
	| $hold'(' <timing_check_event>',' <timing_check_event>','
		<timing_check_limit>
		<comma_notify_register_opt> ')' ';'
	| $period'(' <controlled_timing_check_event>',' <timing_check_limit>
		<comma_notify_register_opt> ')' ';'
	| $width'(' <controlled_timing_check_event>',' <timing_check_limit>
		<','<constant_expression>','<notify_register>>? ')' ';'
	| $skew'(' <timing_check_event>',' <timing_check_event>','
		<timing_check_limit>
		<comma_notify_register_opt> ')' ';'
	| $recovery'(' <controlled_timing_check_event>','
		<timing_check_event>','
		<timing_check_limit> <comma_notify_register_opt> ')' ';'
	| $setuphold'(' <timing_check_event>',' <timing_check_event>','
		<timing_check_limit>',' <timing_check_limit> <comma_notify_register_opt> ')' ';'

timing_check_event:
	  <timing_check_event_control_opt> <specify_terminal_descriptor>
		<amp_timing_check_condition_opt>

specify_terminal_descriptor:
	  <specify_input_terminal_descriptor>
	|<specify_output_terminal_descriptor>

controlled_timing_check_event:
	  <timing_check_event_control> <specify_terminal_descriptor>
		<amp_timing_check_condition_opt>

timing_check_event_control_opt: /* empty */
	| <timing_check_event_control>

timing_check_event_control:
	  POSEDGE
	| NEGEDGE
	| <edge_control_specifier>

edge_control_specifier:
	  EDGE  '[' <edge_descriptor_list> ']'

edge_descriptor_list:
	  <EDGE_DESCRIPTOR>
	| <edge_descriptor_list> ',' <EDGE_DESCRIPTOR>

amp_timing_check_condition_opt: /* empty */
	| '&&&' timing_check_condition

timing_check_condition:
	  <scalar_timing_check_condition>
	| '(' <scalar_timing_check_condition> ')'

scalar_timing_check_condition:
	  <scalar_expression>
	| ~<scalar_expression>
	| <scalar_expression> == <scalar_constant>
	| <scalar_expression> === <scalar_constant>
	| <scalar_expression> != <scalar_constant>
	| <scalar_expression> !== <scalar_constant>

scalar_expression:
	A scalar expression is a one bit net or a bit-select of an expanded vector net.

timing_check_limit:
	  <expression>

scalar_constant:
	  1'b0
	| 1'b1
	| 1'B0
	| 1'B1
	| 'b0
	| 'b1
	| 'B0
	| 'B1
	| 1
	| 0

comma_notify_register_opt: /* empty */
	| ',' <notify_register>

notify_register:
	  <identifier_hier>

level_sensitive_path_declaration:
	  IF '('<conditional_port_expression>')'
		'('<specify_input_terminal_descriptor> <polarity_operator_opt> =>
		<specify_output_terminal_descriptor>')' = <path_delay_value>';'
	| IF '('<conditional_port_expression>')'
		'('<list_of_path_inputs> <polarity_operator_opt> *>
		<list_of_path_outputs>')' = <path_delay_value>';'
	(Note: The following two symbols are literal symbols, not syntax description conventions:)
		*>	=>

conditional_port_expression:
	  <port_reference>
	| <UNARY_OPERATOR><port_reference>
	| <port_reference><BINARY_OPERATOR><port_reference>

polarity_operator_opt: /* empty */
	| <polarity_operator>

polarity_operator:
	  +
	| -

edge_sensitive_path_declaration:
	  <if '('<expression>')'>? '('<edge_identifier>?
		<specify_input_terminal_descriptor> =>
		'('<specify_output_terminal_descriptor> <polarity_operator_opt>
		':' <data_source_expression>')'')' = <path_delay_value>';'
	| <if '('<expression>')'>? '('<edge_identifier>?
		<specify_input_terminal_descriptor> *>
		'('<list_of_path_outputs> <polarity_operator_opt>
		':' <data_source_expression>')'')' =<path_delay_value>';'

/* TODO: English */
data_source_expression:
	Any expression, including constants and lists. Its width must be one bit or
	equal to the  destination's width. If the destination is a list, the data
	source must be as wide as the sum of  the bits of the members.

edge_identifier:
	  POSEDGE
	| NEGEDGE

sdpd:
	 IF '(' <sdpd_conditional_expression> ')' <path_description> '=' <path_delay_value> ';'

sdpd_conditional_expression:
	  <expression> <BINARY_OPERATOR> <expression>
	| <UNARY_OPERATOR> <expression>

lvalue:
	  <identifier_hier>
	| <identifier_hier> '[' <expression> ']'
	| <identifier_hier> '[' <constant_expression> ':' <constant_expression> ']'
	| <concatenation>

constant_expression:
	 <expression>

comma_mintypmax_expression_opt: /* empty */
	| ',' <mintypmax_expression>

mintypmax_expression:
	  <expression>
	| <expression> ':' <expression> ':' <expression>

expression_list:
	  <expression>
	| <expression_list> ',' <expression>

expression:
	  <primary>
	| <UNARY_OPERATOR> <primary>
	| <expression> <BINARY_OPERATOR> <expression>
	| <expression> '?' <expression> ':' <expression>
	| <STRING>

/* TODO: multi-character tokens must be made into tokens (?) */
UNARY_OPERATOR: is one of the following tokens:
	  '+'
	| '-'
	| '!'
	| '~'
	| '&'
	| '~&'
	| '|'
	| '^|'
	| '^'
	| '~^'

/* TODO: multi-character tokens must be made into tokens (?) */
BINARY_OPERATOR:
	  '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| ==
	| !=
	| ===
	| !==
	| &&
	| ||
	| '<'
	| <=
	| '>'
	| >=
	| '&'
	| '|'
	| '^'
	| ^~
	| >>
	| <<

primary:
	  <number>
	| <identifier_hier>
	| <identifier_hier> '[' <expression> ']'
	| <identifier_hier> '[' <constant_expression> ':' <constant_expression> ']'
	| <concatenation>
	| <multiple_concatenation>
	| <function_call>
	| '(' <mintypmax_expression> ')'

/* TODO: should this be a token? */
number:
	  <DECIMAL_NUMBER>
	| <UNSIGNED_NUMBER>? <BASE> <UNSIGNED_NUMBER>
	| <DECIMAL_NUMBER>'.'<UNSIGNED_NUMBER>
	| <DECIMAL_NUMBER><'.'<UNSIGNED_NUMBER>>?
		E<DECIMAL_NUMBER>
	| <DECIMAL_NUMBER><'.'<UNSIGNED_NUMBER>>?
		e<DECIMAL_NUMBER>
/*	(Note: embedded spaces are illegal in Verilog numbers, but embedded underscore
	characters can be used for spacing in any type of number.) */

concatenation:
	  '{' <expression_list> '}'

multiple_concatenation:
	  '{' <expression> '{' <expression_list> '}' '}'

function_call:
	  <name_of_function> '(' <expression_list> ')'
	| <name_of_system_function> '(' <expression_list> ')'
	| <name_of_system_function>

name_of_function:
	  <identifier_hier>

name_of_system_function:
	  $<SYSTEM_IDENTIFIER> /* (Note: the $ may not be followed by a space.) */

/* TODO: this should probably be a token to disallow whitespace between identifiers */
identifier_hier:
	  <IDENTIFIER>
	| <identifier_hier> '.' <IDENTIFIER>

delay_opt: /* empty */
	| <delay>

delay:
	  '#' <number>
	| '#' <identifier_hier>
	| '#' '(' <mintypmax_expression> <comma_mintypmax_expression_opt> <comma_mintypmax_expression_opt> ')'
		
delay_control:
	  '#' <number>
	| '#' <identifier_hier>
	| '#' '(' <mintypmax_expression> ')'

event_control:
	  '@' <identifier_hier>
	| '@' '(' <event_expression> ')'

event_expression:
	  <expression>
	| POSEDGE <scalar_event_expression>
	| NEGEDGE <scalar_event_expression>
	| <event_expression> OR <event_expression>

/* TODO: English */
scalar_event_expression:
	Scalar event expression is an expression that resolves to a one bit value.

comment:
	  <short_comment>
	| <long_comment>

short_comment:
	  // <comment_text> <END-OF-LINE>

long_comment:
	  /* <comment_text> */

/* TODO: English */
comment_text:
	  The comment text is zero or more ASCII characters



%%
