/****************************************************************************
*
*	Date:	19 Feb, 1990		S. Datta, Univ of Cincinnati 
*
*This file currently contains 3 shift/reduce and 3 reduce/reduce conflicts:
*
*Shift/reduce conflicts:
*
* 1.  	name -> simple_name		
*and    .architecture_identifier. -> LeftParen simple_name RightParen_ERR
*cause 1 shift/reduce conflict.
*
* 2.	attribute_name -> name Apostrophe attribute_designator .aggregate.
*causes 1 shift/reduce conflict (since .aggregate. -> | aggregate)
*
* 3.	component_instantiation_statement -> a_label name
*.generic_map_aspect. .port_map_aspect. Semicolon_ERR
*causes 1 shift/reduce conflict (with .generic_map_aspect.).
*
*Reduce/reduce conflicts:
*
* 1.	range -> attribute_name
*and	name -> attribute_name		causes 1 reduce/reduce conflict.
*
* 2.	expanded_name -> simple_name
*and	name -> simple_name 		causes 2 reduce/reduce conflicts.
*
*To avoid conflicts while implementing on an LALR(1) shift-reduce 
*parser-generator such as YACC or BISON, the original IEEE-1076 VHDL grammar 
*has been modified at appropriate places:
*
*The production for formal_port_element contains "type_mark .constraint." 
*instead of ".name. type_mark .constraint." (ie instead of subtype_indication)
*(AFIT file contains only "type_mark")
*
*The production for formal_generic_element contains "type_mark .constraint." 
*instead of ".name. type_mark .constraint." (ie instead of subtype_indication)
*(AFIT file contains only "type_mark")
*
*In the production for architecture_body, "simple_name" (AFIT) has been 
*changed to "name" in accordance with the LRM
*
*The production for configuration_declaration contains "name" instead of
*"entity_name" (LRM), or "Identifier" (AFIT)
*
*Missing Semicolon_ERR at end of production for block_configuration (in AFIT
*file) has been set right.
*
*In production for block_specification, "name" causes conflict and has not
*been implemented.
*
*In production for component_configuration, "Identifier" (AFIT) has been
*replaced by "name" in accordance with the LRM definition. Besides, missing 
*Semicolon_ERR (in AFIT file) has been set right.
*
*In production for operator_symbol, "sign" has not been implemented. Besides,
*"StringLit" (absent in AFIT file) has been added in accordance with the LRM
*definition. Also, "logical_operator" and "miscelaneous_operator", and 
*productions for them have been added (these were commented out in the AFIT 
*file).
*
*In production for procedure_parameter_element, ".name. type_mark 
*.constraint." (or subtype_indication) has been replaced with "type_mark
*.constraint.". AFIT file contains only "type_mark".
*
*In production for function_parameter_element, ".name. type_mark 
*.constraint." (or subtype_indication) has been replaced with "type_mark
*.constraint.". AFIT file contains only "type_mark".
*
*In production for scalar_type_definition, "range_type_definition" includes
*both integer and floating point types.
*
*In production for index_subtype_definition, "type_mark" (LRM) has been
*replaced by "name".
*
*In production for discrete_range, "subtype_indication" (ie ".name.
*type_mark .constraint." in LRM) has been replaced by "name range_constraint 
*| type_mark". Note: "constraint" (LRM) implies "range_constraint" or 
*"index_constraint", but "index_constraint" has been ommitted in the
*production for discrete_range. This is the same as the AFIT file, except that
*"type_mark" has also been ommitted in AFIT file, since it causes 2
*reduce/reduce errors.
*
*Missing Semicolon_ERR in AFIT file for the production for
*incomplete_type_declaration has been set right here.
*
*This file as well as AFIT file contains "expanded_name" in production for
*"type_mark" to avoid conflict between "type_mark" and "constraint".
*
*In production for constraint, "index_constraint" has been replaced by
*"aggregate", both in this as well as the AFIT file.
*
*Missing Semicolon_ERR in AFIT file for the production for file_declaration
*has been set right.
*
*In production for association_element, ".formal_part_Arrow. actual_part"
*has been replaced by "name Arrow OPEN_or_expression | OPEN_or_expression".
*
*Productions for "formal_part" and "actual_part" have been replaced by their
*equivalents. (ie formal_part -> name | LeftParen name RightParen;
*actual_part -> OPEN_or_expression | LeftParen OPEN_or_expression RightParen;)
*
*In production for local_port_element, "subtype_indication .BUS. 
*.VarAsgn_expression." has been replaced by "type_mark .constraint." in this
*file, and "type_mark" in the AFIT file.
*
*In production for local_generic_element, "subtype_indication 
*.VarAsgn_expression." has been replaced by "type_mark .constraint." in this
*file, and "type_mark" in the AFIT file.
*
*In production for configuration_specification, "Identifier" (AFIT) has been
*replaced by "name" in this file in accordance with the LRM definition.
*
*In production for entity_aspect, "ENTITY Identifier" (AFIT) has been
*replaced by "ENTITY name" as per the LRM, but "CONFIGURATION name" (LRM)
*has been replaced by "CONFIGURATION Identifier", here, as well as in AFIT file.
*
*Missing Semicolon_ERR in production for disconnection_specification in AFIT
*file has been set right.
*
*In production for name, "indexed_name" includes "slice_name". Besides,
*name -> operator_symbol (operator overloading) has not been implemented.
*(causes 28 reduce/reduce conflicts).
*
*prefix -> function_call is not implemented. "function_call" is handled by
*"indexed_name".
*
*suffix -> operator_symbol is not implemented.
*
*indexed_name -> prefix ( expression ,{ expression } ) in LRM is implemented
*here as indexed_name -> name aggregate.
*
*In production for attribute_name, "prefix" (LRM) is replaced by "name",
*and optional '(' expression ')' in LRM is implemented as ".aggregate."
*here.
*
*"attribute_designator -> simple_name | RANGE" includes the keyword "RANGE"
*here. (used as an Identifier here).
*
*In production for primary, "function_call" is handled by "name", and '('
*expression ')' is handled by aggregate. Besides primary -> type_conversion
*is not implemented.
*
*literal -> Identifier is not implemented. (causes 99 reduce/reduce conflicts).
*
*Production for element_association contains "simple_expression direction
*simple_expression | name range_constraint" to compensate for change in 
*production for "choice".
*
*choice -> discrete_range has been replaced by "choice -> simple_expression
*direction simple_expression | name range_constraint", since "discrete_range
*-> subtype_indication | range" causes conflicts. Besides "choice ->
*simple_expression | simple_name" has been replaced by "choice ->
*simple_expression" since "simple_expression" contains "simple_name" in LRM
*definition.
*
*function_call is handled by "indexed_name"
*
*In production for qualified_expression, "type_mark" has been replaced by
*"name", and "aggregate" includes '(' expression ')'.
*
*"type_conversion" has been replaced everywhere by its appropriate
*production.
*
*allocator -> NEW subtype_indication | NEW qualified_expression has been
*replaced by "NEW qualified_expression" only, since "subtype_indication"
*causes conflicts.
*
*.AFTER__expression. -> | AFTER numeric_literal (AFIT) has been changed to
*".AFTER__expression. -> | AFTER expression" to reflect the LRM.
*
*In production for procedure_call_statement, "actual_parameter_part" has
*been ommitted. Its inclusion causes 1 shift/reduce, and 2 reduce/reduce
*conflicts. Here, procedure_call_statement has been implemented as "name
*Semicolon_ERR", since "name" includes "name aggregate".
* 
*In production for component_instantiation_statement, "Identifier" (AFIT)
*has been replaced by "name" as per the LRM definition
*
*generate_statement is always labelled (LRM). So unlabelled_generate_statement
*(AFIT) is not implemented.
*
*Missing Semicolon_ERR in production for library_clause in AFIT file has
*been set right.
*
*
****************************************************************************/
/*
**	$Header: vhdl.y,v 4.0 87/11/30 15:58:01 rbratton Exp $<y_op>$<y_op>$
**
**	$Log:	vhdl.y,v $<y_op>$<y_op>$
 * Revision 4.0  87/11/30  15:58:01  rbratton
 * Check in of VHDL version 4.0 (version reported in thesis).
 *
 * Revision 3.2  87/11/04  16:10:48  rbratton
 * Parser:  corrected ranges and aggregate grammar.  1 shift/reduce
 * conflict.
 * Lex:  Save before trying to implement alternate replacement
 * characters (! for |, : for #, and % for ").
 *
 * Revision 3.1  87/11/01  11:28:31  rbratton
 * Checkpoint save before trying to resolve "range" problems.
 *
 * Revision 3.0  87/10/15  06:23:49  rbratton
 * Beta 3 Save.  Implemented case/selected signal assignment and
 * with/use (using improved symbol table).
 *
 * Revision 2.3  87/10/11  15:06:54  rbratton
 * Because of problems with passing floating point parameters, floating
 * point has been removed--replaced with integer long.  Hopefully, at a
 * later time, the problems will be resolved.
 * This is also a configuration save before adding WITH/USE capabilities
 * to the analyzer.
 *
 * Revision 2.2  87/09/06  20:05:55  rbratton
 * Checkpoint save before implementing improved symbol table.
 *
 * Revision 2.1  87/09/01  11:26:46  rbratton
 * Implemented floating point notation.  Uses float (32 bits?) rather than
 * double, but could possibly be changed later.
 *
** Revision 2.0  87/08/29  09:43:08  rbratton
** Configuration save.  For VHDL Release 2.0
**
** Revision 1.8  87/08/24  18:30:11  rbratton
** 1 shift/reduce conflict (default acceptable).  Creates 487 cases.
** Changed value of NULL_SYMBOL from (struct sym_entry *) 0 to
** NULL (= 0).  Still creates a NULL pointer, but does not generate
** warnings while compiling the resulting code (vhdlyacc.c).
**
** Revision 1.7  87/08/18  19:35:46  rbratton
** Corrected problems with signal assignment statement.  Added labels to
** block statement and label symbol table entry.
**
** Revision 1.6  87/08/09  19:34:47  rbratton
** This version will NOT compile.  It causes a "switch table overflow".
** The next version may be a reduced grammar to try to avoid this
** problem.
**
** Revision 1.5  87/07/18  19:14:53  rbratton
** checkpoint save:  no conflicts
**
** Revision 1.4  87/07/17  18:21:23  rbratton
** checkpoint save:  9 shift/reduce conflicts
** Plus/Minus LeftParen
**
** Revision 1.3  87/07/17  17:57:50  rbratton
** checkpoint save:  13 shift/reduce conflicts
** Plus/Minus; Identifier
**
** Revision 1.2  87/07/15  10:07:55  rbratton
** checkpoint save
**
** Revision 1.1  87/06/21  09:24:24  rbratton
** Added some error recovery.  More to follow.
**
** Revision 1.0  87/04/24  17:28:14  rbratton
** Initial revision
**
**
*/

/*************************************************************************
**	
**	Portions of the following code was extracted from
**    LALR(1) grammar for ANSI Ada (public domain)
**    by Herman Fischer
**    adapted by: Gerry Fisher & Philippe Charles
**	
** 	VHDL source for yacc
**	syntax analysis with error recovery
**	symbol table
**	memory allocation
**	no code generation
**	shift/reduce conflicts: 1
**
**	
** Symbol conventions used:
**    [foo]       is denoted  .foo.
**    {foo}       is denoted  ..foo..
**    {, foo }    is denoted  ...foo..
**    foo_bar     is a single nonterminal
**    FOO__bar    is a nonterminal where the keyword FOO is
**                   followed by a nonterminal bar
**
************************************************************************/

%{
#include <stdio.h>


extern HASH_ENTRY hashtab[];  /* hash table of id indices and names */
extern int ANY_NAME;	/* generic hash table index for error recovery */
extern SYM_PTR ANYPTR; 	/* generic symbol table ptr for error recovery */
SYM_PTR sym1, sym2, sym3;  	/* temp variables for symbol table pointers */
NODE_PTR nod1, nod2, nod3;      /* temp variables for node list pointers */
int op1, op2, op3;     		/* temporary variables for op indices */

int is_childless;		/* attribute of architecture body */
int is_structure;		/* attribute of architecture body */
%}

%union  {
	int y_tok;		/*   token	*/	
	int y_op;		/* Index to op table entry    */
	int y_hash;		/* Index to hash table entry  */
	int y_str;    		/* Index to string storage  */
	SYM_PTR y_sym;		/* Pointer to symbol table entry   */
	long   y_val; 		/* Floating point number (32 bits) */
				/*   (also handles integer values) */
	}

/* terminal symbols */

/* old terminal symbols - keep until removed from yacc code */


%token	Ampersand				
%token	Apostrophe
%token	LeftParen 				
%token	RightParen 				
%token	DoubleStar 				
%token	Star 				
%token	Plus 				
%token	Comma 				
%token	Minus 				
%token	VarAsgn 				
%token	Colon
%token	Semicolon 				
%token	LESym 				
%token	Box 				
%token	LTSym 				
%token	Arrow 				
%token	EQSym 				
%token	GESym 				
%token	GTSym 				
%token	Bar 				
%token	NESym 				
%token	Dot
%token	Slash
%token	Identifier
%token	DecimalInt
%token	DecimalReal
%token	BasedInt
%token	BasedReal
%token	CharacterLit
%token	StringLit
%token	BitStringLit
%token 	ABS
%token  ACCESS
%token 	AFTER
%token 	ALIAS
%token 	ALL
%token 	AND
%token 	ARCHITECTURE
%token 	ARRAY
%token 	ASSERT
%token 	ATTRIBUTE
%token 	BEGIN_
%token 	BLOCK
%token 	BODY
%token 	BUFFER
%token  BUS
%token 	CASE
%token 	COMPONENT
%token 	CONFIGURATION
%token 	CONSTANT
%token 	DISCONNECT
%token 	DOWNTO
%token 	ELSE
%token 	ELSIF
%token 	END_
%token 	ENTITY
%token 	EXIT
%token  FILE_
%token 	FOR
%token 	FUNCTION
%token 	GENERATE
%token 	GENERIC
%token  GUARDED
%token 	IF
%token 	INOUT
%token 	IN
%token 	IS
%token 	LABEL
%token  LIBRARY
%token 	LINKAGE
%token 	LOOP
%token 	MAP
%token 	MOD
%token 	NAND
%token  NEW
%token 	NEXT
%token 	NOR
%token 	NOT
%token 	NULL_
%token 	OF
%token  ON
%token 	OPEN
%token 	OR
%token 	OTHERS
%token 	OUT
%token 	PACKAGE
%token 	PORT
%token 	PROCEDURE
%token 	PROCESS
%token 	RANGE
%token 	RECORD
%token  REGISTER
%token 	REM
%token 	REPORT
%token 	RETURN
%token 	SELECT
%token 	SEVERITY
%token 	SIGNAL
%token 	SUBTYPE
%token 	THEN
%token 	TO
%token 	TRANSPORT
%token 	TYPE
%token 	UNITS
%token  UNTIL
%token 	USE
%token 	VARIABLE
%token  WAIT
%token 	WHEN
%token 	WHILE
%token 	WITH
%token 	XOR

 /****************************************************************************
 **
 **  operator precedences and associativities listed in 		
 **  increasing precedence.						
 **
 **  Note:  ABS and NOT have the same precedence as DoubleStar;
 **  yet, they associate to the right.  The (non)token UNARY_SIGN is used
 **  only to establish precedence for unary plus/minus signs.  It does not
 **  have to be a declared token or have any other value other than its
 **  relative precedence value.
 **
 ****************************************************************************/

%left		AND OR NAND NOR XOR
%left		EQSym NESym LTSym LESym GTSym GESym
%left		Plus Minus Ampersand
%left		Star Slash MOD REM
%right		UNARY_SIGN
%left		DoubleStar
%right		ABS NOT

%{
#ifndef NDEBUG
#define TRACE(x,z) {if(yaccdebug)printf("#RULE %s ::= %s\n",x,z);}
#else
#define TRACE(x,z) ;
#endif
%}

/*
 *  Start symbol = "design_file"
 */
%start design_file

/*
 *  Rules
 */
%%


/*
**  Chapter 1: Design Entities
*/

/* 1.1 */
entity_declaration
	: ENTITY
	  Identifier
	  IS
	  .generic_clause.
	  .port_clause.
	  entity_declarative_part
	  .BEGIN__entity_statement_part.
	  END_ERR
	  .simple_name.
	  Semicolon_ERR
	| ENTITY error
	;

/* 1.1.1 */
.port_clause.
	: /*empty*/
	| port_clause
	;


.generic_clause.
	: /*empty*/
	| generic_clause
	;

port_clause
	: PORT
	  LeftParen
	  formal_port_list
	  RightParen_ERR
	  Semicolon_ERR
	;

generic_clause
	: GENERIC
	  LeftParen
	  formal_generic_list
	  RightParen_ERR
	  Semicolon_ERR
	;



/* 1.1.1.2 */
formal_port_list
	: formal_port_element
	  ...formal_port_element..
	| error RightParen_ERR
	;


...formal_port_element..
	: /*empty*/
	| ...formal_port_element..
	  Semicolon_ERR
	  formal_port_element
		{
		yyerrok;
		}
	;

formal_port_element
	: .SIGNAL.
	  identifier_list
	  Colon
	  .mode.
	  /* .name.		causes conflict  */	
	  type_mark
	  .constraint.	
	  .BUS.
	  .VarAsgn__expression.
	;

.SIGNAL.
	: /*empty*/
	| SIGNAL
	;

.mode.
	:/*empty*/
	| IN
	| OUT
	| INOUT
	| BUFFER
	| LINKAGE
	;

.BUS.
	: /*empty*/
	| BUS
	;



.VarAsgn__expression.
	: /*empty*/
	| VarAsgn
	  expression
	;

/* 1.1.1.1 */
formal_generic_list
	: formal_generic_element
	  ...formal_generic_element..
	| error RightParen_ERR
	;


...formal_generic_element..
	: /*empty*/
	| ...formal_generic_element..
	  Semicolon_ERR
	  formal_generic_element
	  	{
	  	yyerrok;
		}
	;

formal_generic_element
	: .CONSTANT.
	  identifier_list
	  Colon
	  .IN.
	  /* .name.		causes conflict */
	  type_mark
	  .constraint.
	  .VarAsgn__expression.
	;


.CONSTANT.
	: /*empty*/
	| CONSTANT
	;

.IN.
	: /*empty*/
	| IN
	;

/* 1.1.2 */
entity_declarative_part
	: ..entity_declarative_item..
	;


..entity_declarative_item..
	: /*empty*/
	| ..entity_declarative_item..
	  entity_declarative_item
	;


entity_declarative_item
	: alias_declaration
	| constant_declaration
	| type_declaration
	| subtype_declaration
	| attribute_declaration
	| attribute_specification
	| subprogram_declaration
	| subprogram_body
	| signal_declaration
	| file_declaration
	| disconnection_specification
	| use_clause
	;


/* 1.1.3 */

.BEGIN__entity_statement_part.
	: /* empty */
	|  BEGIN_
	  entity_statement_part
	;


entity_statement_part
	: ..entity_statement..
	;

..entity_statement..
	: /*empty*/
	| ..entity_statement..
	  entity_statement
	;


entity_statement
	: concurrent_assertion_statement
	| concurrent_procedure_call
	| process_statement  /* NOT IN 7.2 */
	;


/* 1.2 */
/* architecture bodies */

architecture_body
	: ARCHITECTURE
	  Identifier
	  OF
	  name  /* entity name */
	  IS
	  architecture_declarative_part
	  BEGIN_
	  architecture_statement_part
	  END_ERR
	  .simple_name.   /* architecture simple name */
	  Semicolon_ERR
	| ARCHITECTURE error
	;

/* 1.2.1 */
/* Architecture Declarative Part */
architecture_declarative_part
	: ..block_declarative_item..
	;

..block_declarative_item..
	: /*empty*/
	| ..block_declarative_item..
	  block_declarative_item
	;

block_declarative_item
	: constant_declaration
	| signal_declaration
	| type_declaration
	| subtype_declaration
	| attribute_declaration
	| component_declaration
	| alias_declaration
	| attribute_specification
	| configuration_specification
  	| subprogram_declaration
	| subprogram_body
	| file_declaration
	| disconnection_specification
	| use_clause
	;

/* 1.2.2 */
/* Architecture Statement Part */
architecture_statement_part
	: ..concurrent_statement..
	;


/* 1.3  */
configuration_declaration
	: CONFIGURATION
	  Identifier
	  OF
	  name  /* Identifier */   /* entity_name */
	  IS
	  configuration_declarative_part
	  block_configuration
	  END_ERR
	  .simple_name.
	  Semicolon_ERR
	| CONFIGURATION error
	;

configuration_declarative_part
	: ..configuration_declarative_item..
	;

..configuration_declarative_item..
	: /*empty*/
	| ..configuration_declarative_item..
	  configuration_declarative_item
	;

configuration_declarative_item
	: use_clause
	| attribute_specification
	;

/* 1.3.1 */
/* block configuration */
block_configuration
	: FOR
	  block_specification
	  ..use_clause..
	  ..configuration_item..
	  END_ERR
	  FOR
	  Semicolon_ERR
	;


..use_clause..
	: /*empty*/
	| use_clause
	  ..use_clause..
	;

..configuration_item..
	: /*empty*/
	| ..configuration_item..
	  configuration_item
	;

block_specification
	: label /* arch, block, generate */
	  .opt_index_spec.
	/*  | name		causes conflict */
	;

.opt_index_spec.
	: /*empty*/
	| LeftParen
	  index_specification
	  RightParen_ERR
	;


index_specification
	: discrete_range
	| expression
	;

configuration_item
	: block_configuration
	| component_configuration
	;

/* 1.3.2 */

component_configuration
	: FOR
	  instantiation_list
	  Colon
	  name  /* Identifier  */
	  .USE__binding_indication.
	  .block_configuration.
	  END_ERR
	  FOR
	  Semicolon_ERR
	;

.USE__binding_indication.
	: /*empty*/
	| USE
	  binding_indication
	  Semicolon_ERR
	;

.block_configuration.
	: /*empty*/
	| block_configuration
	;


/*
**  Chapter 2:  Subprograms
*/

/* 2.1 */
subprogram_declaration
	: subprogram_specification
	  Semicolon_ERR
	;

subprogram_specification
	: PROCEDURE
	  designator
	  .procedure_parameter_list.
	| FUNCTION
	  designator
	  .function_parameter_list.
	  RETURN
	  type_mark
	;

designator
	: Identifier
	| operator_symbol
	;

operator_symbol    /* defined in LRM 2.1 */
	: relational_operator
	| adding_operator
/*	| sign  */
	| multiplying_operator
	| logical_operator
	| miscellaneous_operator   
	| StringLit
	;
logical_operator : AND | OR | NAND | NOR | XOR
	;
miscellaneous_operator : DoubleStar | ABS | NOT
	;

.procedure_parameter_list.
	: /*empty*/
	| LeftParen
	  procedure_parameter_element
	  ...procedure_parameter_element..
	  RightParen_ERR
	| LeftParen
	  error
	  RightParen_ERR
	;


...procedure_parameter_element..
	: /*empty*/
	| ...procedure_parameter_element..
	  Semicolon_ERR
	  procedure_parameter_element
		{
		yyerrok;
		}
	;


procedure_parameter_element
	: .procedure_parameter_object_class.
	  identifier_list
	  Colon
	  .procedure_parameter_mode.
	  /* .name. 		causes conflict */
	  type_mark
	  .constraint.
	  .VarAsgn__expression.
	;

.procedure_parameter_object_class.
	: /*empty*/
	| VARIABLE
	| CONSTANT
	;

.procedure_parameter_mode.
	: /*empty*/
	| IN
	| OUT
	| INOUT
	;

.function_parameter_list.
	: /*empty*/
	| LeftParen
	  function_parameter_element
	  ...function_parameter_element..
	  RightParen_ERR
	| LeftParen
	  error
	  RightParen_ERR
	;


...function_parameter_element..
	: /*empty*/
	| ...function_parameter_element..
	  Semicolon_ERR
	  function_parameter_element
	;

function_parameter_element
	: .function_parameter_object_class.
	  identifier_list
	  Colon
	  .function_parameter_mode.
	  type_mark
	  .constraint. 
	  .VarAsgn__expression.
	;


.function_parameter_object_class.
	: /*empty*/
	| CONSTANT
	| SIGNAL
	;

.function_parameter_mode.
	: /*empty*/
	| IN
	;


/* 2.2 */
subprogram_declarative_part
	: /*empty*/
	| subprogram_declarative_part
	  subprogram_declarative_item
		{
		yyerrok;
		}
	;

subprogram_declarative_item
	: constant_declaration
	| variable_declaration
	| alias_declaration
	| type_declaration
	| subtype_declaration
	| attribute_declaration
	| attribute_specification
	| subprogram_declaration
	| subprogram_body
	| file_declaration
	| use_clause
	;


/* 2.2 */
/* subprogram bodies */

subprogram_body
	: subprogram_specification
	  IS
	  subprogram_declarative_part
	  BEGIN_	
	  sequence_of_statements
	  END_ERR
	  .designator.
	  Semicolon_ERR
	;

.designator.
	: /*empty*/
	| designator
	;



/* Packages */

/* 2.5 */
package_declaration
	: PACKAGE 
	  Identifier
	  IS
	  package_declarative_part
	  END_ERR
	  .simple_name.
	  Semicolon_ERR
	| PACKAGE 
		error
	;

package_declarative_part
	: ..package_declarative_item..
	;

..package_declarative_item..
	: /*empty*/
	| ..package_declarative_item..
	  package_declarative_item
	;

package_declarative_item
	: type_declaration
	| subtype_declaration
	| attribute_declaration
	| constant_declaration
	| alias_declaration
	| subprogram_declaration
	| component_declaration
	| attribute_specification
	| signal_declaration
	| file_declaration
	| disconnection_specification
	| use_clause
	| error END_ERR
	  Semicolon_ERR
	;

/* 2.6 */
/* package bodies */

package_body
	: PACKAGE
	  BODY
	  Identifier
	  IS  
	  package_body_declarative_part
	  END_ERR
	  .simple_name.
	  Semicolon_ERR
	| PACKAGE
  	  BODY
  	  error
	;

package_body_declarative_part
	: ..package_body_declarative_item..
	;

..package_body_declarative_item..
	: /*empty*/
	| ..package_body_declarative_item..
	  package_body_declarative_item
	;	

package_body_declarative_item
	: subprogram_declaration
	| subprogram_body
	| type_declaration
	| subtype_declaration
	| constant_declaration
	| file_declaration
	| alias_declaration
	| use_clause
	;


/*
**  Chapter 3:  Types
*/


/* 3.1 */
scalar_type_definition
	: enumeration_type_definition
	| range_type_definition  /* includes integer and floating point */
	| physical_type_definition
	;

range_constraint
	: RANGE
	  range
	;
	
range
	: attribute_name /* simple_expression simple_expression -> (attribute) name */
	| simple_expression
	  direction
	  simple_expression
	;

direction
	: TO
	| DOWNTO
	;

/* 3.1.1. */
enumeration_type_definition
	: LeftParen
	  enumeration_literal
	  ...enumeration_literal..
	  RightParen_ERR
	;


...enumeration_literal..
	: /*empty*/
	| ...enumeration_literal..
	  Comma
	  enumeration_literal
		{
		yyerrok;
		}
	;

enumeration_literal
	: Identifier
	| CharacterLit
	;

/* 3.1.2 & 3.1.4 */
/* Integer and Floating Point types */

range_type_definition
	: range_constraint
	;

/* 3.1.3 */
physical_type_definition
	: range_constraint
	  UNITS
	  base_unit_declaration
	  ..secondary_unit_declaration..
	  END_ERR
	  UNITS
	;


..secondary_unit_declaration..
	: /*empty*/
	| ..secondary_unit_declaration..
	  secondary_unit_declaration
		{
		yyerrok;
		}
	;

base_unit_declaration
	: Identifier
	  Semicolon_ERR
	;

secondary_unit_declaration
	: Identifier
	  EQSym
	  physical_literal
	  Semicolon_ERR
	;

physical_literal
	: .abstract_literal.
	  name      /* in LRM: UNIT_name */
	;


.abstract_literal.
	: /*empty*/
	| abstract_literal
	;

/* 3.2 */
composite_type_definition
	: array_type_definition
	| record_type_definition
	;

/* 3.2.1 */
array_type_definition
	: unconstrained_array_definition
	| constrained_array_definition
	;

unconstrained_array_definition
	: ARRAY
	  LeftParen
	  index_subtype_definition
	  ...index_subtype_definition..
	  RightParen_ERR
	  OF
	  subtype_indication
	;


...index_subtype_definition..
	: /*empty*/
	| ...index_subtype_definition..
	  Comma
	  index_subtype_definition
	;

constrained_array_definition
	: ARRAY
	  index_constraint
	  OF
	  subtype_indication
	;

index_subtype_definition
	: name    /* type_mark  - causes conflict */
	  RANGE
	  Box
	;

index_constraint
	: LeftParen
	  discrete_range
	  ...discrete_range..
	  RightParen_ERR
	;

...discrete_range..
	: /*empty*/
	| ...discrete_range..
	  Comma
	  discrete_range
		{
		yyerrok;
		}
	;

discrete_range
	: range  /* includes attribute_name */
	| name
	  range_constraint   /* subtype_indication - causes conflict */
	| type_mark 	/* type_mark causes 2 r/r conflicts - required for
			   louie's code */
	;

/* 3.2.2 */
record_type_definition
	: RECORD
	  element_declaration
	  ..element_declaration..
	  END_ERR
	  RECORD
	| RECORD
	  error
	  END_ERR
	  RECORD
	;


..element_declaration..
	: /*empty*/
	| ..element_declaration..
	  element_declaration
		  {
		  yyerrok;
		  }
	;

element_declaration
	: identifier_list
	  Colon
	  element_subtype_definition
	  Semicolon_ERR
	;

/*
**  identifier_list is used consistantly in definitions of new Identifiers,
**  with one exception--IMPORT_DIRECTIVE.  The IMPORT_DIRECTIVE expects to
**  find all Identifiers declared at the local scope and it is an error if
**  they are not.  In all other cases, it is an error to have two Identifiers
**  with the same name at the same level.  (Overloading not implemented.)
**  Therefore, identifier_list checks to see if the previous token was
**  IMPORT.
**  returns pointer to symbol table which has a list of identifier
**  definitions connected by the "next" pointers.
*/
identifier_list
	: Identifier
	  ...identifier..
	;


...identifier..
	: /*empty*/
	| Comma
	  Identifier
	  ...identifier..
	;


element_subtype_definition
	: subtype_indication
	;

/* 3.3 */
/* Access Types */
access_type_definition
	: ACCESS
	  subtype_indication
	;

/* 3.3.1 */
/* Incomplete Type Declarations */
incomplete_type_declaration
	: TYPE
	  Identifier
	  Semicolon_ERR
	;


/* 3.4 */
/* File Types */
file_type_definition
	: FILE_
	  OF
	  type_mark
	;



/*
**  Chapter 4:  Declarations
*/
/* 4.1.1 */
type_declaration
	: full_type_declaration
	| incomplete_type_declaration
	;

full_type_declaration
	: TYPE
	  Identifier
	  IS
	  type_definition
	  Semicolon_ERR
	;

type_definition
	: scalar_type_definition
	| composite_type_definition
	| access_type_definition
	| file_type_definition
	| error Semicolon_ERR
	;

/* 4.2 */
subtype_declaration
	: SUBTYPE
	  Identifier
	  IS
	  subtype_indication
 	  Semicolon_ERR
	;

subtype_indication
	: type_or_function_name
	  type_mark
	  .constraint.
	| type_mark
	  .constraint.
	;


.constraint.
	: /*empty*/
	| constraint
	;

type_or_function_name
	: expanded_name
	;


expanded_name
	: simple_name  /* Identifier  */
/*	| STANDARD
		 */
	| expanded_name  /* was Identifier  */
	  Dot
	  simple_name  /*  Identifier */
	  	{
		yyerrok;
	  	}
	;

type_mark
	: expanded_name		/* move to production.c !!! */
		
				/* type_mark and constraint 
				   will otherwise cause conflict */	
	;

constraint
	: range_constraint
	| aggregate   /* was: ( discrete_range ...discrete_range.. ) */
					          /* index_constraint */
	;
	
/* 4.3.1.1  */
constant_declaration
	: CONSTANT
	  identifier_list
	  Colon
	  subtype_indication
	  .VarAsgn__expression.
	  Semicolon_ERR
	;

/* 4.3.1.2 */
signal_declaration
	: SIGNAL
	  identifier_list
	  Colon
	  subtype_indication
	  .signal_kind.
	  .VarAsgn__expression.
	  Semicolon_ERR
	;

.signal_kind.
	: /*empty*/
	| signal_kind
	;

signal_kind
	: REGISTER
	| BUS
	;

/* 4.3.1.3 */
variable_declaration
	: VARIABLE
	  identifier_list
	  Colon
	  subtype_indication
	  .VarAsgn__expression.
	  Semicolon_ERR
	;

/* 4.3.2 */
/* File Declarations */
file_declaration
	: FILE_
	  Identifier
	  Colon
	  subtype_indication
	  IS
	  .mode.
	  expression
	  Semicolon_ERR
	;

/* 4.3.3 and 4.3.3.1 */
/* Interface Declaration and lists are interspersed
   where they are actually used port, generic and parameter */

/* 4.3.3.2 */
/* Association lists */

association_list
	: association_element
	  ...association_element..
	;

...association_element..
	: /*empty*/
	| Comma
	  association_element
	  ...association_element..
	   {
		yyerrok;
		}
	;

/*
**  ( expression ) is defined by aggregate as:
**			( general_element_association ) =>
**			( OPEN_or_expression ) =>
**			( expression )
*/

association_element
	: /* formal_part */ 	/* causes conflict */  
	  name 
	  Arrow
	  /* actual_part */ 
	  OPEN_or_expression   /* can be name also */
	| /* actual_part */ 
	OPEN_or_expression   /* can be name also */
	;
/* causes conflict
formal_part : name | name LeftParen name RightParen
	;
actual_part : OPEN_or_expression | name LeftParen OPEN_or_expression
	RightParen
	;
*/
OPEN_or_expression
	: OPEN
	| expression
	;
	
/* 4.3.4 */
alias_declaration
	:  ALIAS
  	 	Identifier
		Colon
		subtype_indication
		IS
		name
		Semicolon_ERR
	;


/* 4.4 */
attribute_declaration
	: ATTRIBUTE
	  Identifier
	  Colon
	  type_mark
	  Semicolon_ERR
	;


/* 4.5 */
component_declaration
	: COMPONENT
	  Identifier
	  .GENERIC__local_generic_list.
	  .PORT__local_port_list.
	  END_ERR
	  COMPONENT
	  Semicolon_ERR
	;

.PORT__local_port_list.
	: /*empty*/
	| PORT
	  LeftParen
	  local_port_list
	  RightParen_ERR
	  Semicolon_ERR
	;

local_port_list
	: local_port_element
	  ...local_port_element..
	| error RightParen_ERR
	;


...local_port_element..
	: /*empty*/
	| ...local_port_element..
	  Semicolon_ERR
	  local_port_element
	;


local_port_element
	: .SIGNAL.
	  identifier_list
	  Colon
	  .local_port_mode.
	  type_mark
	  .constraint.
	;

.local_port_mode.
	: /*empty*/
	| IN
	| OUT
	| INOUT
	| BUFFER
	| LINKAGE
	;

.GENERIC__local_generic_list.
	: /*empty*/
	| GENERIC
	  LeftParen
	  local_generic_list
	  RightParen_ERR
	  Semicolon_ERR
	;

local_generic_list
	: local_generic_element
	  ...local_generic_element..
	| error RightParen_ERR
	;


...local_generic_element..
	: /*empty*/
	| ...local_generic_element..
	  Semicolon_ERR
	  local_generic_element
	;


local_generic_element
	: .CONSTANT.
	  identifier_list
	  Colon
	  .IN.
	  type_mark
	  .constraint.
	;

/*
**  Chapter 5:  Specifications
*/

/* 5.1 */
attribute_specification
	: ATTRIBUTE
	  attribute_designator
	  OF
	  entity_specification
	  IS
	  expression
	  Semicolon_ERR
	;

entity_specification
	: entity_name_list
	  Colon
	  entity_class
	;


entity_class
	: ENTITY
	| ARCHITECTURE
	| PACKAGE
	| FUNCTION
	| PROCEDURE
	| SUBTYPE
	| CONSTANT
	| VARIABLE
	| SIGNAL
	| LABEL
	| TYPE
	| CONFIGURATION
	| COMPONENT
	;

entity_name_list
	: entity_designator
	  ...entity_designator..
	| OTHERS
	| ALL
	;

...entity_designator..
	: /*empty*/
	| ...entity_designator..
	  Comma
	  entity_designator
	;

entity_designator
	: simple_name
	| operator_symbol
	;


/* 5.2 */
configuration_specification
	: FOR
	  instantiation_list
	  Colon
	  /* Identifier */
	  name
	  USE
	  binding_indication
	  Semicolon_ERR
	| FOR
	  error
	  Semicolon_ERR
	;

instantiation_list
	: identifier_list
	| OTHERS
	| ALL
	| error Colon
		{
		yyerrok;
		}
	;

/* 5.2.1 */	
binding_indication
	: entity_aspect
	  .generic_map_aspect.
	  .port_map_aspect.
	;


/* 5.2.1.1 */
entity_aspect
	: ENTITY
	  /* Identifier */ 
	  name 		/* name causes 1 s/r conflict */
	  .architecture_identifier.
	| CONFIGURATION
	  Identifier 
	  /* name 	causes conflict */
	| OPEN
	;

.architecture_identifier.
	: /*empty*/
	| LeftParen
	  simple_name
	  RightParen_ERR
	;


/* entity_indication
	: library_name   entity library_name
	| OPEN
	; */

/* 5.2.1.2 */
...element_association..
	: /*empty*/
	| ...element_association..
	  Comma
	  element_association
		  {
		  yyerrok;
		  }
	;
/* 5.3 */
/* Disconnection_specification */
disconnection_specification
	: DISCONNECT
	  guarded_signal_specification
	  AFTER
	  expression
	  Semicolon_ERR
	;

guarded_signal_specification
	: signal_list
	  Colon
	  type_mark
	;



/* 6.2.3 */
/* initialize_directive
	: INITIALIZE
	  type_mark
	  TO
	  expression
	  ..waveform.
	  Semicolon_ERR
	;  */

/*
**  Chapter 6:  Names
*/

/* 6.1 */
/*
** According to the VHDL Test suite, library names are not used
** in expressions.  Therefore, the choice "library_name" is removed.
**     NEED TO CHECK THIS OUT!!!  */
name
	: simple_name   /* move to production.c */
	| indexed_name     /* includes "slice_name" */
	| selected_name
	| attribute_name /*  not implemented: causes 2 reduce/reduce conflicts.
	| operator_symbol   overloading not implemented
	  causes reduce/reduce conflicts (28) */
	;

prefix
	: name  /*function call handled by indexed_name*/
/*	| function_call
*/
	;


/* 6.2 */
simple_name      /* returns hash index */
	: Identifier
	;


.simple_name.
	: /*empty*/
	| simple_name
	;


/* 6.3 */
selected_name
	: prefix
	  Dot
	  suffix
	;

suffix
	: simple_name
	| CharacterLit
/*	|  operator_symbol  */  /* handled by characterLit */
	| ALL
	;

/* 6.4 */
indexed_name    /* also includes "slice_name"   6.5 */
	: name               /* in LRM: prefix */
	  aggregate  /* in LRM:  '(' expression { ',' expression } ')'  */
	;

/* 6.6 */
attribute_name
	: name   /* prefix  causes 7 shift/reduce conflicts */
	  Apostrophe
	  attribute_designator
	  .aggregate.  /* in LRM: '(' static_expression ')' */
	;


.aggregate.
	: /*empty*/
	| aggregate
	;

attribute_designator
	: simple_name      /* attribute simple_name */
	| RANGE      /*   somebody goofed!  Keyword used as an identifier */
	;

/********
**
** Chapter 7  Expressions
**
*********/

/* 7.1 */
expression
	: relation..AND__relation..
	| relation..OR__relation..
	| relation.NAND_NOR__relation.
	| relation..XOR__relation..
	;


relation..AND__relation..
	: relation
	  AND
	  relation
	| relation..AND__relation..
	  AND
	  relation
	;

relation..OR__relation..
	: relation
	  OR
	  relation
	| relation..OR__relation..
	  OR
	  relation
	;

relation.NAND_NOR__relation.
	: relation
	| relation
	  NAND
	  relation
	| relation
	  NOR
	  relation
	;

	
relation..XOR__relation..
	: relation
	  XOR
	  relation
	| relation..XOR__relation..
	  XOR
	  relation
	;

relation
	: simple_expression
	  .relop__simple_expression.
	;


.relop__simple_expression.
	: /*empty*/
	| relational_operator
	  simple_expression
	;

/*
** simple_expression ::= [sign] term { adding_operator term }
*/
simple_expression
	: .sign.term..add_op__term..
	;

term
	: factor
	| term
	  multiplying_operator
	  factor
		{
		yyerrok;
		}
	;


.sign.term..add_op__term..
	: term   %prec UNARY_SIGN
	| sign
	  term   %prec UNARY_SIGN
	| .sign.term..add_op__term..
	  adding_operator
	  term
	;

factor
	: primary
	  .DoubleStar__primary.
	| ABS
	  primary
	| NOT
	  primary
	;


.DoubleStar__primary.
	: /*empty*/
	| DoubleStar
	  primary
	;

    primary
	    : literal
	    | qualified_expression
/* 	    | function_call
*/
	    | name     /* name = simple_name = Identifier = enumeration_literal */
			    /* includes function_call */
	    | aggregate  /*(expression) is included under aggregate*/
    /*	| type_conversion		causes reduce/reduce conflicts
    */	| allocator
	    ;

    /* 7.2.1 */
    /* logical operators embedded in expression */

    /* 7.2.2 */
    relational_operator
	    : EQSym
	    | NESym
	    | LTSym
	    | LESym
	    | GTSym
	    | GESym
	    ;

    /* 7.2.3 */
    adding_operator
	    : Plus
	    | Minus
	| Ampersand
	;

sign
	: Plus
	| Minus
	;

/* 7.2.4 */
multiplying_operator
	: Star
	| Slash
	| MOD
	| REM
	;

/* 7.3.1 */
literal
	: numeric_literal
	| CharacterLit
	/*
	 * | enumeration_literal
	 *      Causes 99 reduce/reduce conflicts with Id and CharLit.
	 *      Covered under 'name'.
	 */	/* Identifier causes conflict */
	| StringLit
	| BitStringLit
	| NULL_
	;

numeric_literal
	: abstract_literal
	| abstract_literal      /* physical_literal */
	  name /* Identifier */            /* in LRM: UNIT_name */
		
	 	/* name in physical_literal causes conflict */
	;

/* 7.3.2 */
aggregate
	: LeftParen
	  element_association
	  ...element_association..
	  RightParen_ERR
	;

element_association
	: expression
	| choice
	  ..Bar__choice..
	  Arrow
	  expression
	| simple_expression
	  direction		/* because of production for "choice"
	                           to avoid conflict */
	  simple_expression
	| name
	  range_constraint
	;

choices
	: choice
	  ..Bar__choice..
		{
		yyerrok;
		}
	;


..Bar__choice..
	: /*empty*/
	| ..Bar__choice..
	  Bar
	  choice
	;

choice
	: simple_expression  /* includes simple_name */
	| simple_expression
	  direction
	  simple_expression	/* because of production for "discrete_range"
				   to avoid conflict */
	| name
	  range_constraint
	| OTHERS
	;


/* 7.3.3 */
/* function_call
	: Identifier 
	actual_parameter_part
	;
		
actual_parameter_part
	:
	 LeftParen
	  association_list
	  RightParen_ERR
	;  function_call handled by selected name */
/* .actual_parameter_part.
	:
	| LeftParen
	  association_list
	  RightParen_ERR
	; * function_call handled by selected name */

/* 7.3.4 */
qualified_expression
	: name
	  Apostrophe
	  aggregate
	  /*
	  ** type_mark ' aggregate | type_mark ' ( expression )
	  */
	;

/* 7.3.5 */
/* type_conversion		causes reduce/reduce conflict
	: Identifier  type_mark
	  LeftParen  aggregate 
	  expression
	  RightParen_ERR
	;
*/

/* 7.3.6 */
allocator
	: NEW
/*	  subtype_indication

	| NEW     causes numerous reduce/reduce conflicts */
	  qualified_expression
	;


/*
**  Chapter 8:   Sequential Statements
*/

/* 8.0 */
sequence_of_statements
	: ..sequential_statement..
	| error END_ERR
		{
		yyerrok;
		}
	| error ELSIF
		{
		yyerrok;
		}
	| error ELSE
		{
		yyerrok;
		}
	| error WHEN
		{
		yyerrok;
		}
	;


..sequential_statement..
	: /*empty*/
	| sequential_statement
	..sequential_statement..
	;

sequential_statement
	: assertion_statement
	| signal_assignment_statement
	| variable_assignment_statement
	| if_statement
	| case_statement
	| loop_statement
	| next_statement
	| exit_statement
	| return_statement
	| null_statement
	| procedure_call_statement
	| wait_statement
	;

/* 8.1 */
wait_statement
	: WAIT
	  .sensitivity_clause.
	  .condition_clause.
	  .timeout_clause.
	  Semicolon_ERR
	;

.sensitivity_clause.
	: /*empty*/
	| sensitivity_clause
	;

.condition_clause.
	: /*empty*/
	| condition_clause
	;

.timeout_clause.
	:  /*empty*/
	| timeout_clause
	;

sensitivity_clause
	: ON
	  /* sensitivity_list */
	  signal_list
	;

condition_clause
	: UNTIL
	  expression
	;

timeout_clause
	: FOR
	  expression
	;


/*
**  returns SYM_REF op tree indexes
*/
signal_list
	: name
	  ...name..
	| OTHERS
	| ALL
	;


...name..
	: /*empty*/
	| ...name..
	  Comma
	  name
	;

/* 8.2 */
assertion_statement
	: ASSERT
	  expression
	  .REPORT__expression.
	  .SEVERITY__expression.
	  Semicolon_ERR
	;


.REPORT__expression.
	: /*empty*/
	| REPORT
	  expression
	;

.SEVERITY__expression.
	: /*empty*/
	| SEVERITY
	  expression
	;

/* 8.3 */
signal_assignment_statement
	: target
	  LESym
	  .TRANSPORT.
	  waveform
	  Semicolon_ERR
	;

target
	: name
	| aggregate
	;


waveform
	: waveform_element
	  ...waveform_element..
	;


...waveform_element..
	: /*empty*/
	| Comma
	  waveform_element
	  ...waveform_element..
	;

/* 8.3.1 */
waveform_element
	: expression   /* NULL can be arrived at through expression - literal */
	  .AFTER__expression.
	;


.AFTER__expression.
	: /*empty*/
	| AFTER
	  expression /* numeric_literal */   /* in LRM: expression */
	;

/* 8.4 */
variable_assignment_statement
	: target
	  VarAsgn
	  expression
	  Semicolon_ERR
	;

/* 8.5 */
procedure_call_statement
	: name 			/* name includes "name ( association_list )" */
	  Semicolon_ERR     	/* need to include actual_parameter_part 
				   - causes conflict */
	;

/* 8.6 */
if_statement
	: IF
	  condition
	  THEN
	  sequence_of_statements
	  ..ELSIF__THEN__seq_of_stmts..
	  .ELSE__seq_of_stmts.
	  END_ERR
	  IF
	  Semicolon_ERR
	;


..ELSIF__THEN__seq_of_stmts..
	: /*empty*/
	| ELSIF
	  condition
	  THEN
	  sequence_of_statements
	  ..ELSIF__THEN__seq_of_stmts..
		{
		  yyerrok;
		}
	;

.ELSE__seq_of_stmts.
	: /*empty*/
	| ELSE
	  sequence_of_statements
		{
		  yyerrok;
		}
	;

/* 8.7 */
case_statement
	: CASE
	  expression
	  IS
	  case_statement_alternative
	  ..case_statement_alternative..
	  END_ERR
	  CASE
	  Semicolon_ERR
	;


..case_statement_alternative..
	: /*empty*/
	| ..case_statement_alternative..
	  case_statement_alternative
		{
		yyerrok;
		}
	;

case_statement_alternative
	: WHEN
	  choices
	  Arrow
	  sequence_of_statements
	;

/* 8.8 */
/*
**  To avoid shift/reduce conflicts, define rules for labeled/unlabeled loop
**  statement
*/
loop_statement
	:	a_label
		unlabeled_loop_statement
	|	unlabeled_loop_statement
	;

unlabeled_loop_statement
	: .iteration_scheme.
	  LOOP
	  sequence_of_statements
	  END_ERR
	  LOOP
	  .label.
	  Semicolon_ERR
	;


.iteration_scheme.
	: /*empty*/
	| iteration_scheme
	;

iteration_scheme
	: WHILE
	  condition
	| FOR
	  loop_parameter_specification
	;

.label.
	: /*empty*/
	| label
	;


loop_parameter_specification
	: Identifier
	  IN
	  discrete_range
	;
	
/* 8.9 */
next_statement
	: NEXT
	  .label.
	  .WHEN__condition.
	  Semicolon_ERR
	;
	

.WHEN__condition.
	: /*empty*/
	| WHEN
	  condition
	;
	
/* 8.10 */
exit_statement
	: EXIT
	  .label.
	  .WHEN__condition.
	  Semicolon_ERR
	;

/* 8.11 */
return_statement
	: RETURN
	  .expression.
	  Semicolon_ERR
	;


.expression.
	: /*empty*/
	| expression
	;

/* 8.12 */
null_statement
	: NULL_
	  Semicolon_ERR
	;
	
/*
* chapter 9 - concurrent statements
*/

/* 9.0 */
set_of_statements
	: ..concurrent_statement..
	| error END_ERR
	;


..concurrent_statement..
	: /*empty*/
	| concurrent_statement
	  ..concurrent_statement..
	;

concurrent_statement
	: block_statement
	| process_statement
	| concurrent_assertion_statement
	| concurrent_signal_assignment_statement
	| component_instantiation_statement
	| generate_statement
	| concurrent_procedure_call
	;

/* 9.1 */
block_statement    /****** needs changing *******/
	: a_label
	  BLOCK
	  .guard_expression.
	  .generic_clause_map_aspect.
	  .port_clause_map_aspect.
	  block_declarative_part
	  BEGIN_
	  set_of_statements
	  END_ERR
	  BLOCK
	  .label.
	  Semicolon_ERR
	;


.guard_expression.
	: /*empty*/
	| guard_expression
	;

guard_expression
	: LeftParen
	  expression
	  RightParen_ERR
	;

.generic_clause_map_aspect.
	: /*empty*/
	| generic_clause
	  .generic_map_aspect_Semicolon.
	;
.generic_map_aspect_Semicolon. 
	: 
	| generic_map_aspect
	Semicolon_ERR
	;

.port_clause_map_aspect.
	: /*empty*/
	| port_clause
	  .port_map_aspect_Semicolon.
	;
.port_map_aspect_Semicolon. 
	:
	| port_map_aspect
	Semicolon_ERR
	;

block_declarative_part
	: ..block_declarative_item..
	;


/* 9.2 */
/*
**  To avoid shift/reduce conflicts, define rules for labeled/unlabeled process
**  statements.
*/
process_statement
	:	a_label
		unlabeled_process_statement
	|	unlabeled_process_statement
	;

unlabeled_process_statement
	: PROCESS
	  .sensitivity_list.
	  process_declarative_part
	  BEGIN_
	  sequence_of_statements
	  END_ERR
	  PROCESS
	  .label.
	  Semicolon_ERR
	;


.sensitivity_list.
	: /*empty*/
	| sensitivity_list
	;

sensitivity_list
	: LeftParen
	  signal_list
	  RightParen_ERR
	;
	
process_declarative_part
	: ..process_declarative_item..
	;


..process_declarative_item..
	: /*empty*/
	| ..process_declarative_item..
	  process_declarative_item
		{
		yyerrok;
		}
	;

process_declarative_item
	: constant_declaration
	| variable_declaration
	| type_declaration
	| subtype_declaration
	| attribute_declaration
	| attribute_specification
	| subprogram_declaration
	| subprogram_body
	| file_declaration
	| alias_declaration
	| use_clause
	;

/* 9.3 */
/*
** to avoid shift/reduce conflicts for concurrent_procedure_call
** define rules for labeled and unlabeled statements separately
*/

concurrent_procedure_call
	: a_label
	  unlabeled_concurrent_procedure_call
	| unlabeled_concurrent_procedure_call
	;

unlabeled_concurrent_procedure_call
	: procedure_call_statement
	;



/* 9.4 */
/*
**  To avoid shift/reduce conflicts, define rules for labeled/unlabeled
**  concurrent_assertion_statements.
**
**  This creates an equivalent process statement which has a sensitivity
**  list of the longest static prefix of each signal name appearing in
**  the boolean expression of the assertion statement.
*/
concurrent_assertion_statement
	:	a_label
		unlabeled_concurrent_assertion_statement
	|	unlabeled_concurrent_assertion_statement
	;

unlabeled_concurrent_assertion_statement
	: assertion_statement
	;

/* 9.5 */
/*
**  To avoid shift/reduce conflicts, define rules for labeled/unlabeled
**  concurrent_signal_assignment_statements.
**
**  This creates an equivalent process statement.  See 8.2.4 of the LRM.
*/
concurrent_signal_assignment_statement
	: a_label
	  unlabeled_conditional_signal_assignment
	| unlabeled_conditional_signal_assignment
	| a_label
	  unlabeled_selected_signal_assignment
	| unlabeled_selected_signal_assignment
	;


/* 9.5.1 */
unlabeled_conditional_signal_assignment
	: target
	  LESym
	  /* options */
	  .GUARDED.
	  .TRANSPORT.
	  /* conditional_waveforms */
	  ..waveform__WHEN__condition__ELSE..
	  waveform
 	  Semicolon_ERR
	;


..waveform__WHEN__condition__ELSE..
	: /*empty*/
	| ..waveform__WHEN__condition__ELSE..
	  waveform
	  WHEN
	  expression 
	  ELSE
	;

/* 9.5.2 */
unlabeled_selected_signal_assignment
	: WITH
	  expression
	  SELECT
	  target
	  LESym
	  /* options */
	  .GUARDED.
	  .TRANSPORT.
	  /* selected_waveforms */
	  waveform
	  WHEN
	  choices
	  ...waveform__WHEN__choices.. /* changed from LRM for consistancy */
	  Semicolon_ERR
	;


...waveform__WHEN__choices..
	: /*empty*/
	| ...waveform__WHEN__choices..
	  Comma
	  waveform
	  WHEN
	  choices
	;


.GUARDED.
	: /*empty*/
	| GUARDED
	;

.TRANSPORT.
	: /*empty*/
	| TRANSPORT
	;

/* 9.6 */
component_instantiation_statement
	: a_label
	   /* Identifier */
	   name  
	  .generic_map_aspect.
	  .port_map_aspect.
	  Semicolon_ERR
	;


.port_map_aspect.
	: /*empty*/
	| port_map_aspect
	;
port_map_aspect
	:
	  PORT
	  MAP
	  LeftParen        /* was: PORT aggregate */
	  association_list
	  RightParen_ERR
	;


.generic_map_aspect.
	: /*empty*/
	| generic_map_aspect
	; 
generic_map_aspect
	:	
	  GENERIC
 	  MAP
	  LeftParen
	  association_list
	  RightParen_ERR
	;

/* 9.7 */
/*
**  To avoid shift/reduce conflicts, define labeled/unlabeled generate
**  statements.
*/
generate_statement
	:	a_label
		unlabeled_generate_statement
/*	|  unlabeled_generate_statement
*/	;

unlabeled_generate_statement
	: generation_scheme
	  GENERATE
	  set_of_statements
	  END_ERR
	  GENERATE
	  .label.
	  Semicolon_ERR
	;

generation_scheme
	: FOR
	  generate_parameter_specification
	| IF
	  condition
	;

generate_parameter_specification
	: Identifier
	  IN
	  discrete_range
	;

condition
	: expression
	;

/*
**  label declaration
*/
a_label
	:	label
		Colon
	;


label
	: Identifier
	;

/*
**  Chapter 10:  Scope and Visibility
*/

/* 10.4 */
use_clause
	: USE
	  selected_name    /* package simple name */
	  ...selected_name..
	  Semicolon_ERR
	;


...selected_name..
	: /*empty*/
	| ...selected_name..
	  Comma
	  selected_name
	;

/*
**  Design Units and Their Analysis
*/

/* 11.1 */
design_file
	: design_unit
	  ..design_unit..
	;

..design_unit..
	: /*empty*/
	| design_unit
	  ..design_unit..
	;

design_unit
	: context_clause
	  library_unit
	;

library_unit
	: primary_unit
	| secondary_unit
	| error
	;

primary_unit
	: entity_declaration
	| configuration_declaration
	| package_declaration
	;

secondary_unit
	: architecture_body
	| package_body
	;

/* Design Libraries */
/* 11.2 */

library_clause
	: LIBRARY
	  logical_name_list
	  Semicolon_ERR
	;

logical_name_list
	: Identifier
	  ...logical_name..
	;

...logical_name..
	: /*empty*/
	| ...logical_name..
	  Comma
	  Identifier
	;

/* 11.3 */
context_clause
	: ..context_item..
	;

..context_item..
	: /*empty*/
	| ..context_item..
	  context_item
	;

context_item
	: library_clause
	| use_clause
	;

/* A.4 */
/* abstract_literal */
/*
**  Normally, the grammar for abstract literal would be found here.  It
**  has been moved to the end of this file.  There you will find an
**  explanation.
*/


/*********************************
**
**  Error recovery non-terminals
**
*********************************/

/*
 *  Make ';', ')', and 'end' significant for error recovery.
 */

RightParen_ERR	
	:  RightParen
			{
		  	yyerrok;
			}
	;

Semicolon_ERR
	:  Semicolon
			{
		   yyerrok;
			}
	;

END_ERR
	:  END_
			{
			yyerrok;
			}
	;

/*
**  In order to implement floating point notation, it was necessary to
**  declare the types of the parameters for 'abstract_literal_real' and
**  'abstract_literal_int', as well as the return type for 'abstract_literal'.
**  But if you do this, then yacc demands that all following grammar rules
**  be similarily typed.  Therefore, this special case was made the last
**  rule in the grammar.  This will cause the compiler to complain about
**  "struct/union or struct/union pointer required", but the source code
**  produced by yacc is correct.
*/
abstract_literal
	: DecimalInt
	| DecimalReal
	| BasedInt
	| BasedReal
	;
%%


