%{
%}

%token <text>      IDENTIFIER SYSTEM_IDENTIFIER STRING TIME_LITERAL
%token <data_type> TYPE_IDENTIFIER
%token <package>   PACKAGE_IDENTIFIER
%token <discipline> DISCIPLINE_IDENTIFIER
%token <text>   PATHPULSE_IDENTIFIER
%token <number> BASED_NUMBER DEC_NUMBER UNBASED_NUMBER
%token <realtime> REALTIME
%token K_PLUS_EQ K_MINUS_EQ K_INCR K_DECR
%token K_LE K_GE K_EG K_EQ K_NE K_CEQ K_CNE K_LP K_LS K_RS K_RSS K_SG

 /* K_CONTRIBUTE is <+, the contribution assign. */
%token K_CONTRIBUTE
%token K_PO_POS K_PO_NEG K_POW
%token K_PSTAR K_STARP K_DOTSTAR
%token K_LOR K_LAND K_NAND K_NOR K_NXOR K_TRIGGER
%token K_SCOPE_RES
%token K_edge_descriptor

 /* The base tokens from 1364-1995. */
%token K_always K_and K_assign K_begin K_buf K_bufif0 K_bufif1 K_case
%token K_casex K_casez K_cmos K_deassign K_default K_defparam K_disable
%token K_edge K_else K_end K_endcase K_endfunction K_endmodule
%token K_endprimitive K_endspecify K_endtable K_endtask K_event K_for
%token K_force K_forever K_fork K_function K_highz0 K_highz1 K_if
%token K_ifnone K_initial K_inout K_input K_integer K_join K_large
%token K_macromodule K_medium K_module K_nand K_negedge K_nmos K_nor
%token K_not K_notif0 K_notif1 K_or K_output K_parameter K_pmos K_posedge
%token K_primitive K_pull0 K_pull1 K_pulldown K_pullup K_rcmos K_real
%token K_realtime K_reg K_release K_repeat K_rnmos K_rpmos K_rtran
%token K_rtranif0 K_rtranif1 K_scalared K_small K_specify K_specparam
%token K_strong0 K_strong1 K_supply0 K_supply1 K_table K_task K_time
%token K_tran K_tranif0 K_tranif1 K_tri K_tri0 K_tri1 K_triand K_trior
%token K_trireg K_vectored K_wait K_wand K_weak0 K_weak1 K_while K_wire
%token K_wor K_xnor K_xor

%token K_Shold K_Snochange K_Speriod K_Srecovery K_Ssetup K_Ssetuphold
%token K_Sskew K_Swidth

 /* Icarus specific tokens. */
%token KK_attribute K_bool K_logic

 /* The new tokens from 1364-2001. */
%token K_automatic K_endgenerate K_generate K_genvar K_localparam
%token K_noshowcancelled K_pulsestyle_onevent K_pulsestyle_ondetect
%token K_showcancelled K_signed K_unsigned

%token K_Sfullskew K_Srecrem K_Sremoval K_Stimeskew

 /* The 1364-2001 configuration tokens. */
%token K_cell K_config K_design K_endconfig K_incdir K_include K_instance
%token K_liblist K_library K_use

 /* The new tokens from 1364-2005. */
%token K_wone K_uwire

 /* The new tokens from 1800-2005. */
%token K_alias K_always_comb K_always_ff K_always_latch K_assert
%token K_assume K_before K_bind K_bins K_binsof K_bit K_break K_byte
%token K_chandle K_class K_clocking K_const K_constraint K_context
%token K_continue K_cover K_covergroup K_coverpoint K_cross K_dist K_do
%token K_endclass K_endclocking K_endgroup K_endinterface K_endpackage
%token K_endprogram K_endproperty K_endsequence K_enum K_expect K_export
%token K_extends K_extern K_final K_first_match K_foreach K_forkjoin
%token K_iff K_ignore_bins K_illegal_bins K_import K_inside K_int
 /* Icarus already has defined "logic" above! */
%token K_interface K_intersect K_join_any K_join_none K_local
%token K_longint K_matches K_modport K_new K_null K_package K_packed
%token K_priority K_program K_property K_protected K_pure K_rand K_randc
%token K_randcase K_randsequence K_ref K_return K_sequence K_shortint
%token K_shortreal K_solve K_static K_string K_struct K_super
%token K_tagged K_this K_throughout K_timeprecision K_timeunit K_type
%token K_typedef K_union K_unique K_var K_virtual K_void K_wait_order
%token K_wildcard K_with K_within
 /* Fake tokens that are passed once we have an initial token. */
%token K_timeprecision_check K_timeunit_check

 /* The new tokens from 1800-2009. */
%token K_accept_on K_checker K_endchecker K_eventually K_global K_implies
%token K_let K_nexttime K_reject_on K_restrict K_s_always K_s_eventually
%token K_s_nexttime K_s_until K_s_until_with K_strong K_sync_accept_on
%token K_sync_reject_on K_unique0 K_until K_until_with K_untyped K_weak

 /* The new tokens from 1800-2012. */
%token K_implements K_interconnect K_nettype K_soft

 /* The new tokens for Verilog-AMS 2.3. */
%token K_above K_abs K_absdelay K_abstol K_access K_acos K_acosh
 /* 1800-2005 has defined "assert" above! */
%token K_ac_stim K_aliasparam K_analog K_analysis K_asin K_asinh
%token K_atan K_atan2 K_atanh K_branch K_ceil K_connect K_connectmodule
%token K_connectrules K_continuous K_cos K_cosh K_ddt K_ddt_nature K_ddx
%token K_discipline K_discrete K_domain K_driver_update K_endconnectrules
%token K_enddiscipline K_endnature K_endparamset K_exclude K_exp
%token K_final_step K_flicker_noise K_floor K_flow K_from K_ground
%token K_hypot K_idt K_idtmod K_idt_nature K_inf K_initial_step
%token K_laplace_nd K_laplace_np K_laplace_zd K_laplace_zp
%token K_last_crossing K_limexp K_ln K_log K_max K_merged K_min K_nature
%token K_net_resolution K_noise_table K_paramset K_potential K_pow
 /* 1800-2005 has defined "string" above! */
%token K_resolveto K_sin K_sinh K_slew K_split K_sqrt K_tan K_tanh
%token K_timer K_transition K_units K_white_noise K_wreal
%token K_zi_nd K_zi_np K_zi_zd K_zi_zp


%token K_TAND
%right K_PLUS_EQ K_MINUS_EQ K_MUL_EQ K_DIV_EQ K_MOD_EQ K_AND_EQ K_OR_EQ
%right K_XOR_EQ K_LS_EQ K_RS_EQ K_RSS_EQ
%right '?' ':' K_inside
%left K_LOR
%left K_LAND
%left '|'
%left '^' K_NXOR K_NOR
%left '&' K_NAND
%left K_EQ K_NE K_CEQ K_CNE
%left K_GE K_LE '<' '>'
%left K_LS K_RS K_RSS
%left '+' '-'
%left '*' '/' '%'
%left K_POW
%left UNARY_PREC

/* to resolve dangling else ambiguity. */
%nonassoc less_than_K_else
%nonassoc K_else

 /* to resolve exclude (... ambiguity */
%nonassoc '('
%nonassoc K_exclude

%%

  /* IEEE1800-2005: A.1.2 */
source_text:
    description_list
  |
  ;

assertion_item /* IEEE1800-2012: A.6.10 */
  : concurrent_assertion_item
  ;

assignment_pattern /* IEEE1800-2005: A.6.7.1 */
  : K_LP expression_list_proper '}'
  | K_LP '}'
  ;

  /* Some rules have a ... [ block_identifier ':' ] ... part. This
     implements it in a LALR way. */
block_identifier_opt /* */
  : IDENTIFIER ':'
  |
  ;

class_declaration /* IEEE1800-2005: A.1.2 */
  : K_virtual_opt K_class class_identifier class_declaration_extends_opt ';'
    class_items_opt K_endclass
    class_declaration_endlabel_opt
  ;

class_constraint /* IEEE1800-2005: A.1.8 */
  : constraint_prototype
  | constraint_declaration
  ;

class_identifier
  : IDENTIFIER
  | TYPE_IDENTIFIER
  ;

  /* The endlabel after a class declaration is a little tricky because
     the class name is detected by the lexor as a TYPE_IDENTIFIER if it
     does indeed match a name. */
class_declaration_endlabel_opt
  : ':' TYPE_IDENTIFIER
  | ':' IDENTIFIER
  |
  ;

  /* This rule implements [ extends class_type ] in the
     class_declaration. It is not a rule of its own in the LRM.

     Note that for this to be correct, the identifier after the
     extends keyword must be a class name. Therefore, match
     TYPE_IDENTIFIER instead of IDENTIFIER, and this rule will return
     a data_type. */

class_declaration_extends_opt /* IEEE1800-2005: A.1.2 */
  : K_extends TYPE_IDENTIFIER
  | K_extends TYPE_IDENTIFIER '(' expression_list_with_nuls ')'
  |
  ;

  /* The class_items_opt and class_items rules together implement the
     rule snippet (zero or more class_item) of the
     class_declaration. */
class_items_opt /* IEEE1800-2005: A.1.2 */
  : class_items
  |
  ;

class_items /* IEEE1800-2005: A.1.2 */
  : class_items class_item
  | class_item
  ;

class_item /* IEEE1800-2005: A.1.8 */

    /* IEEE1800 A.1.8: class_constructor_declaration */
  : method_qualifier_opt K_function K_new
    '(' tf_port_list_opt ')' ';'
    function_item_list_opt
    statement_or_null_list_opt
    K_endfunction endnew_opt

    /* Class properties... */
  | property_qualifier_opt data_type list_of_variable_decl_assignments ';'
  | K_const class_item_qualifier_opt data_type list_of_variable_decl_assignments ';'

    /* Class methods... */
  | method_qualifier_opt task_declaration
  | method_qualifier_opt function_declaration

    /* Class constraints... */
  | class_constraint

    /* Here are some error matching rules to help recover from various
       syntax errors within a class declaration. */
  | property_qualifier_opt data_type error ';'
  | property_qualifier_opt IDENTIFIER error ';'
  | method_qualifier_opt K_function K_new error K_endfunction endnew_opt
  | error ';'
  ;

class_item_qualifier /* IEEE1800-2005 A.1.8 */
  : K_static    
  | K_protected 
  | K_local     
  ;

class_item_qualifier_list
  : class_item_qualifier_list class_item_qualifier
  | class_item_qualifier
  ;

class_item_qualifier_opt
  : class_item_qualifier_list
  |
  ;

class_new /* IEEE1800-2005 A.2.4 */
  : K_new '(' expression_list_with_nuls ')'
  | K_new hierarchy_identifier
  | K_new
  ;

  /* The concurrent_assertion_item pulls together the
     concurrent_assertion_statement and checker_instantiation rules. */

concurrent_assertion_item /* IEEE1800-2012 A.2.10 */
  : block_identifier_opt K_assert K_property '(' property_spec ')' statement_or_null
  | block_identifier_opt K_assert K_property '(' error ')' statement_or_null
  ;

constraint_block_item /* IEEE1800-2005 A.1.9 */
  : constraint_expression
  ;

constraint_block_item_list
  : constraint_block_item_list constraint_block_item
  | constraint_block_item
  ;

constraint_block_item_list_opt
  :
  | constraint_block_item_list
  ;

constraint_declaration /* IEEE1800-2005: A.1.9 */
  : K_static_opt K_constraint IDENTIFIER '{' constraint_block_item_list_opt '}'

  /* Error handling rules... */
  | K_static_opt K_constraint IDENTIFIER '{' error '}'
  ;

constraint_expression /* IEEE1800-2005 A.1.9 */
  : expression ';'
  | expression K_dist '{' '}' ';'
  | expression K_TRIGGER constraint_set
  | K_if '(' expression ')' constraint_set %prec less_than_K_else
  | K_if '(' expression ')' constraint_set K_else constraint_set
  | K_foreach '(' IDENTIFIER '[' loop_variables ']' ')' constraint_set
  ;

constraint_expression_list /* */
  : constraint_expression_list constraint_expression
  | constraint_expression
  ;

constraint_prototype /* IEEE1800-2005: A.1.9 */
  : K_static_opt K_constraint IDENTIFIER ';'
  ;

constraint_set /* IEEE1800-2005 A.1.9 */
  : constraint_expression
  | '{' constraint_expression_list '}'
  ;

data_declaration /* IEEE1800-2005: A.2.1.3 */
  : attribute_list_opt data_type_or_implicit list_of_variable_decl_assignments ';'
  ;

data_type /* IEEE1800-2005: A.2.2.1 */
  : integer_vector_type unsigned_signed_opt dimensions_opt
  | non_integer_type
  | struct_data_type
  | enum_data_type
  | atom2_type signed_unsigned_opt
  | K_integer signed_unsigned_opt
  | K_time
  | TYPE_IDENTIFIER dimensions_opt
  | PACKAGE_IDENTIFIER K_SCOPE_RES TYPE_IDENTIFIER
  | K_string
  ;

  /* The data_type_or_implicit rule is a little more complex then the
     rule documented in the IEEE format syntax in order to allow for
     signaling the special case that the data_type is completely
     absent. The context may need that information to decide to resort
     to left context. */

data_type_or_implicit /* IEEE1800-2005: A.2.2.1 */
  : data_type
  | signing dimensions_opt
  | dimensions
  |
  ;

data_type_or_implicit_or_void
  : data_type_or_implicit
  | K_void
  ;

  /* NOTE 1: We pull the "timeunits_declaration" into the description
     here in order to be a little more flexible with where timeunits
     statements may go. This may be a bad idea, but it is legacy now. */

  /* NOTE 2: The "module" rule of the description combines the
     module_declaration and program_declaration rules from the
     standard description. */

description /* IEEE1800-2005: A.1.2 */
  : module
  | udp_primitive
  | config_declaration
  | nature_declaration
  | package_declaration
  | discipline_declaration
  | package_item
  | KK_attribute '(' IDENTIFIER ',' STRING ',' STRING ')'
  ;

description_list
  : description
  | description_list description
  ;


   /* This implements the [ : INDENTIFIER ] part of the constructure
      rule documented in IEEE1800-2005: A.1.8 */
endnew_opt : ':' K_new | ;

  /* The dynamic_array_new rule is kinda like an expression, but it is
     treated differently by rules that use this "expression". Watch out! */

dynamic_array_new /* IEEE1800-2005: A.2.4 */
  : K_new '[' expression ']'
  | K_new '[' expression ']' '(' expression ')'
  ;

for_step /* IEEE1800-2005: A.6.8 */
  : lpvalue '=' expression
  | inc_or_dec_expression
  | compressed_statement
  ;


  /* The function declaration rule matches the function declaration
     header, then pushes the function scope. This causes the
     definitions in the func_body to take on the scope of the function
     instead of the module. */
function_declaration /* IEEE1800-2005: A.2.6 */
  : K_function K_automatic_opt data_type_or_implicit_or_void IDENTIFIER ';'
    function_item_list statement_or_null_list_opt
    K_endfunction
    endlabel_opt

  | K_function K_automatic_opt data_type_or_implicit_or_void IDENTIFIER
    '(' tf_port_list_opt ')' ';'
    block_item_decls_opt
    statement_or_null_list_opt
    K_endfunction
    endlabel_opt

  /* Detect and recover from some errors. */
  | K_function K_automatic_opt data_type_or_implicit_or_void IDENTIFIER error K_endfunction
    endlabel_opt

  ;

implicit_class_handle /* IEEE1800-2005: A.8.4 */
  : K_this 
  | K_super
  ;

  /* SystemVerilog adds support for the increment/decrement
     expressions, which look like a++, --a, etc. These are primaries
     but are in their own rules because they can also be
     statements. Note that the operator can only take l-value
     expressions. */

inc_or_dec_expression /* IEEE1800-2005: A.4.3 */
  : K_INCR lpvalue %prec UNARY_PREC
  | lpvalue K_INCR %prec UNARY_PREC
  | K_DECR lpvalue %prec UNARY_PREC
  | lpvalue K_DECR %prec UNARY_PREC
  ;

inside_expression /* IEEE1800-2005 A.8.3 */
  : expression K_inside '{' open_range_list '}'
  ;

integer_vector_type /* IEEE1800-2005: A.2.2.1 */
  : K_reg   /* Usually a synonym for logic. */
  | K_bit  
  | K_logic
  | K_bool  /* Icarus Verilog xtypes extension */
  ;

join_keyword /* IEEE1800-2005: A.6.3 */
  : K_join
  | K_join_none
  | K_join_any
  ;

jump_statement /* IEEE1800-2005: A.6.5 */
  : K_break ';'
  | K_return ';'
  | K_return expression ';'
  ;

  /* Loop statements are kinds of statements. */

loop_statement /* IEEE1800-2005: A.6.8 */
  : K_for '(' lpvalue '=' expression ';' expression ';' for_step ')'
    statement_or_null
  | K_for '(' data_type IDENTIFIER '=' expression ';' expression ';' for_step ')'
    statement_or_null
  | K_forever statement_or_null
  | K_repeat '(' expression ')' statement_or_null
  | K_while '(' expression ')' statement_or_null
  | K_do statement_or_null K_while '(' expression ')' ';'
  | K_foreach '(' IDENTIFIER '[' loop_variables ']' ')' statement_or_null
  /* Error forms for loop statements. */
  | K_for '(' lpvalue '=' expression ';' expression ';' error ')'
    statement_or_null
  | K_for '(' lpvalue '=' expression ';' error ';' for_step ')'
    statement_or_null
  | K_for '(' error ')' statement_or_null
  | K_while '(' error ')' statement_or_null
  | K_do statement_or_null K_while '(' error ')' ';'
  | K_foreach '(' IDENTIFIER '[' error ']' ')' statement_or_null
  ;


/* TODO: Replace register_variable_list with list_of_variable_decl_assignments. */
list_of_variable_decl_assignments /* IEEE1800-2005 A.2.3 */
  : variable_decl_assignment
  | list_of_variable_decl_assignments ',' variable_decl_assignment
  ;

variable_decl_assignment /* IEEE1800-2005 A.2.3 */
  : IDENTIFIER dimensions_opt
  | IDENTIFIER '=' expression
  | IDENTIFIER '=' K_new '(' ')'
  ;


loop_variables /* IEEE1800-2005: A.6.8 */
  : loop_variables ',' IDENTIFIER
  | IDENTIFIER
  ;

method_qualifier /* IEEE1800-2005: A.1.8 */
  : K_virtual
  | class_item_qualifier
  ;

method_qualifier_opt
  : method_qualifier
  |
  ;


non_integer_type /* IEEE1800-2005: A.2.2.1 */
  : K_real
  | K_realtime
  | K_shortreal
  ;

number  : BASED_NUMBER
        | DEC_NUMBER
        | DEC_NUMBER BASED_NUMBER
        | UNBASED_NUMBER
        | DEC_NUMBER UNBASED_NUMBER
    ;

open_range_list /* IEEE1800-2005 A.2.11 */
  : open_range_list ',' value_range
  | value_range
  ;

package_declaration /* IEEE1800-2005 A.1.2 */
  : K_package IDENTIFIER ';'
    package_item_list_opt
    K_endpackage endlabel_opt
  ;

package_import_declaration /* IEEE1800-2005 A.2.1.3 */
  : K_import package_import_item_list ';'
  ;

package_import_item
  : PACKAGE_IDENTIFIER K_SCOPE_RES IDENTIFIER
  | PACKAGE_IDENTIFIER K_SCOPE_RES '*'
  ;

package_import_item_list
  : package_import_item_list',' package_import_item
  | package_import_item
  ;

package_item /* IEEE1800-2005 A.1.10 */
  : timeunits_declaration
  | K_parameter param_type parameter_assign_list ';'
  | K_localparam param_type localparam_assign_list ';'
  | type_declaration
  | function_declaration
  | task_declaration
  | data_declaration
  ;

package_item_list
  : package_item_list package_item
  | package_item
  ;

package_item_list_opt : package_item_list | ;

port_direction /* IEEE1800-2005 A.1.3 */
  : K_input 
  | K_output
  | K_inout 
  | K_ref
  ;

  /* port_direction_opt is used in places where the port direction is
     optional. The default direction is selected by the context,
     which needs to notice the PIMPLICIT direction. */

port_direction_opt
  : port_direction
  |               
  ;

property_expr /* IEEE1800-2012 A.2.10 */
  : expression
  ;

  /* The property_qualifier rule is as literally described in the LRM,
     but the use is usually as, which is
     implemented bt the property_qualifier_opt rule below. */

property_qualifier /* IEEE1800-2005 A.1.8 */
  : class_item_qualifier
  | random_qualifier
  ;

property_qualifier_opt /* IEEE1800-2005 A.1.8: ... */
  : property_qualifier_list
  |
  ;

property_qualifier_list /* IEEE1800-2005 A.1.8 */
  : property_qualifier_list property_qualifier
  | property_qualifier
  ;

  /* The property_spec rule uses some helper rules to implement this
     rule from the LRM:
     [ clocking_event ] [ disable iff ( expression_or_dist ) ] property_expr
     This does it is a YACC friendly way. */

property_spec /* IEEE1800-2012 A.2.10 */
  : clocking_event_opt property_spec_disable_iff_opt property_expr
  ;

property_spec_disable_iff_opt /* */
  : K_disable K_iff '(' expression ')'
  |
  ;

random_qualifier /* IEEE1800-2005 A.1.8 */
  : K_rand
  | K_randc
  ;

  /* real and realtime are exactly the same so save some code
   * with a common matching rule. */
real_or_realtime
    : K_real
    | K_realtime
    ;

signing /* IEEE1800-2005: A.2.2.1 */
  : K_signed  
  | K_unsigned
  ;

statement /* IEEE1800-2005: A.6.4 */
  : attribute_list_opt statement_item
  ;

  /* Many places where statements are allowed can actually take a
     statement or a null statement marked with a naked semi-colon. */

statement_or_null /* IEEE1800-2005: A.6.4 */
  : statement
  | attribute_list_opt ';'
  ;

stream_expression
  : expression
  ;

stream_expression_list
  : stream_expression_list ',' stream_expression
  | stream_expression
  ;

stream_operator
  : K_LS
  | K_RS
  ;

streaming_concatenation /* IEEE1800-2005: A.8.1 */
  : '{' stream_operator '{' stream_expression_list '}' '}'
  ;

  /* The task declaration rule matches the task declaration
     header, then pushes the function scope. This causes the
     definitions in the task_body to take on the scope of the task
     instead of the module. */

task_declaration /* IEEE1800-2005: A.2.7 */

  : K_task K_automatic_opt IDENTIFIER ';'
    task_item_list_opt
    statement_or_null_list_opt
    K_endtask
    endlabel_opt

  | K_task K_automatic_opt IDENTIFIER '('
    tf_port_list ')' ';'
    block_item_decls_opt
    statement_or_null_list_opt
    K_endtask
    endlabel_opt

  | K_task K_automatic_opt IDENTIFIER '(' ')' ';'
    block_item_decls_opt
    statement_or_null_list
    K_endtask
    endlabel_opt

  | K_task K_automatic_opt IDENTIFIER error K_endtask
    endlabel_opt

  ;


tf_port_declaration /* IEEE1800-2005: A.2.7 */
  : port_direction K_reg_opt unsigned_signed_opt dimensions_opt list_of_identifiers ';'

  /* When the port is an integer, infer a signed vector of the integer
     shape. Generate a range ([31:0]) to make it work. */
  | port_direction K_integer list_of_identifiers ';'

  /* Ports can be time with a width of [63:0] (unsigned). */
  | port_direction K_time list_of_identifiers ';'

  /* Ports can be real or realtime. */
  | port_direction real_or_realtime list_of_identifiers ';'
  ;

  /* These rules for tf_port_item are slightly expanded from the
     strict rules in the LRM to help with LALR parsing.

     NOTE: Some of these rules should be folded into the "data_type"
     variant which uses the data_type rule to match data type
     declarations. That some rules do not use the data_type production
     is a consequence of legacy. */

tf_port_item /* IEEE1800-2005: A.2.7 */
  : port_direction_opt data_type_or_implicit IDENTIFIER dimensions_opt tf_port_item_expr_opt
  /* Rules to match error cases... */
  | port_direction_opt data_type_or_implicit IDENTIFIER error
  ;

  /* This rule matches the [ = <expression> ] part of the tf_port_item rules. */
tf_port_item_expr_opt
  : '=' expression
  |               
  ;

tf_port_list /* IEEE1800-2005: A.2.7 */
  : tf_port_list ',' tf_port_item
  | tf_port_item
  /* Rules to handle some errors in tf_port_list items. */
  | error ',' tf_port_item
  | tf_port_list ','
  | tf_port_list ';'
  ;

  /* NOTE: Icarus Verilog is a little more generous with the
     timeunits declarations by allowing them to happen in multiple
     places in the file. So the rule is adjusted to be invoked by the
     "description" rule. This theoretically allows files to be
     concatenated together and still compile. */
timeunits_declaration /* IEEE1800-2005: A.1.2 */
  : K_timeunit TIME_LITERAL ';'
  | K_timeunit TIME_LITERAL '/' TIME_LITERAL ';'
  | K_timeprecision TIME_LITERAL ';'
  ;

value_range /* IEEE1800-2005: A.8.3 */
  : expression
  | '[' expression ':' expression ']'
  ;

variable_dimension /* IEEE1800-2005: A.2.5 */
  : '[' expression ':' expression ']'
  | '[' expression ']'
  | '[' ']'
  | '[' '$' ']'
  ;

  /* Verilog-2001 supports attribute lists, which can be attached to a
     variety of different objects. The syntax inside the (* *) is a
     comma separated list of names or names with assigned values. */
attribute_list_opt
    : attribute_instance_list
    |
    ;

attribute_instance_list
  : K_PSTAR K_STARP
  | K_PSTAR attribute_list K_STARP
  | attribute_instance_list K_PSTAR K_STARP
  | attribute_instance_list K_PSTAR attribute_list K_STARP
  ;

attribute_list
  : attribute_list ',' attribute
  | attribute
  ;


attribute
    : IDENTIFIER
    | IDENTIFIER '=' expression
    ;


  /* The block_item_decl is used in function definitions, task
     definitions, module definitions and named blocks. Wherever a new
     scope is entered, the source may declare new registers and
     integers. This rule matches those declarations. The containing
     rule has presumably set up the scope. */

block_item_decl
  /* variable declarations. Note that data_type can be 0 if we are
     recovering from an error. */
  : data_type register_variable_list ';'
  | K_reg data_type register_variable_list ';'
  | K_event list_of_identifiers ';'
  | K_parameter param_type parameter_assign_list ';'
  | K_localparam param_type localparam_assign_list ';'
  /* Blocks can have type declarations. */
  | type_declaration
  /* Recover from errors that happen within variable lists. Use the
     trailing semi-colon to resync the parser. */
  | K_integer error ';'
  | K_time error ';'
  | K_parameter error ';'
  | K_localparam error ';'
  ;

block_item_decls
    : block_item_decl
    | block_item_decls block_item_decl
    ;

block_item_decls_opt
    : block_item_decls
    |
    ;

  /* Type declarations are parsed here. The rule actions call pform
     functions that add the declaration to the current lexical scope. */
type_declaration
  : K_typedef data_type IDENTIFIER ';'
  /* These are forward declarations... */
  | K_typedef K_class  IDENTIFIER ';'
  | K_typedef K_enum   IDENTIFIER ';'
  | K_typedef K_struct IDENTIFIER ';'
  | K_typedef K_union  IDENTIFIER ';'
  | K_typedef          IDENTIFIER ';'
  | K_typedef data_type TYPE_IDENTIFIER ';'
  | K_typedef error ';'
  ;

  /* The structure for an enumeration data type is the keyword "enum",
     followed by the enumeration values in curly braces. Also allow
     for an optional base type. The default base type is "int", but it
     can be any of the integral or vector types. */
enum_data_type
  : K_enum '{' enum_name_list '}'
  | K_enum atom2_type signed_unsigned_opt '{' enum_name_list '}'
  | K_enum K_integer signed_unsigned_opt '{' enum_name_list '}'
  | K_enum K_logic unsigned_signed_opt dimensions '{' enum_name_list '}'
  | K_enum K_reg unsigned_signed_opt dimensions '{' enum_name_list '}'
  | K_enum K_bit unsigned_signed_opt dimensions '{' enum_name_list '}'
  ;

enum_name_list
  : enum_name
  | enum_name_list ',' enum_name
  ;

pos_neg_number
  : number
  | '-' number
  ;

enum_name
  : IDENTIFIER
  | IDENTIFIER '[' pos_neg_number ']'
  | IDENTIFIER '[' pos_neg_number ':' pos_neg_number ']'
  | IDENTIFIER '=' expression
  | IDENTIFIER '[' pos_neg_number ']' '=' expression
  | IDENTIFIER '[' pos_neg_number ':' pos_neg_number ']' '=' expression
  ;

struct_data_type
  : K_struct K_packed_opt '{' struct_union_member_list '}'
  | K_union K_packed_opt '{' struct_union_member_list '}'
  | K_struct K_packed_opt '{' error '}'
  | K_union K_packed_opt '{' error '}'
  ;

  /* This is an implementation of the rule snippet:
       struct_union_member
     that is used in the rule matching struct and union types
     in IEEE 1800-2012 A.2.2.1. */
struct_union_member_list
  : struct_union_member_list struct_union_member
  | struct_union_member
  ;

struct_union_member /* IEEE 1800-2012 A.2.2.1 */
  : attribute_list_opt data_type list_of_variable_decl_assignments ';'
  | error ';'
  ;

case_item
    : expression_list_proper ':' statement_or_null
    | K_default ':' statement_or_null
    | K_default  statement_or_null
    | error ':' statement_or_null
    ;

case_items
    : case_items case_item
    | case_item
    ;

charge_strength
    : '(' K_small ')'
    | '(' K_medium ')'
    | '(' K_large ')'
    ;

charge_strength_opt
    : charge_strength
    |
    ;

defparam_assign
    : hierarchy_identifier '=' expression
    ;

defparam_assign_list
  : defparam_assign
  | dimensions defparam_assign
  | defparam_assign_list ',' defparam_assign
    ;

delay1
    : '#' delay_value_simple
    | '#' '(' delay_value ')'
    ;

delay3
    : '#' delay_value_simple
    | '#' '(' delay_value ')'
    | '#' '(' delay_value ',' delay_value ')'
    | '#' '(' delay_value ',' delay_value ',' delay_value ')'
    ;

delay3_opt
    : delay3
    |       
    ;

delay_value_list
  : delay_value
  | delay_value_list ',' delay_value
  ;

delay_value
    : expression
    | expression ':' expression ':' expression
    ;


delay_value_simple
    : DEC_NUMBER
    | REALTIME
    | IDENTIFIER
    | TIME_LITERAL
    ;

  /* The discipline and nature declarations used to take no ';' after
     the identifier. The 2.3 LRM adds the ';', but since there are
     programs written to the 2.1 and 2.2 standard that don't, we
     choose to make the ';' optional in this context. */
optional_semicolon : ';' | ;

discipline_declaration
  : K_discipline IDENTIFIER optional_semicolon
    discipline_items K_enddiscipline
  ;

discipline_items
  : discipline_items discipline_item
  | discipline_item
  ;

discipline_item
  : K_domain K_discrete ';'
  | K_domain K_continuous ';'
  | K_potential IDENTIFIER ';'
  | K_flow IDENTIFIER ';'
  ;

nature_declaration
  : K_nature IDENTIFIER optional_semicolon
    nature_items
    K_endnature
  ;

nature_items
  : nature_items nature_item
  | nature_item
  ;

nature_item
  : K_units '=' STRING ';'
  | K_abstol '=' expression ';'
  | K_access '=' IDENTIFIER ';'
  | K_idt_nature '=' IDENTIFIER ';'
  | K_ddt_nature '=' IDENTIFIER ';'
  ;

config_declaration
  : K_config IDENTIFIER ';'
    K_design lib_cell_identifiers ';'
    list_of_config_rule_statements
    K_endconfig
  ;

lib_cell_identifiers
  : /* The BNF implies this can be blank, but I'm not sure exactly what
     * this means. */
  | lib_cell_identifiers lib_cell_id
  ;

list_of_config_rule_statements
  : /* config rules are optional. */
  | list_of_config_rule_statements config_rule_statement
  ;

config_rule_statement
  : K_default K_liblist list_of_libraries ';'
  | K_instance hierarchy_identifier K_liblist list_of_libraries ';'
  | K_instance hierarchy_identifier K_use lib_cell_id opt_config ';'
  | K_cell lib_cell_id K_liblist list_of_libraries ';'
  | K_cell lib_cell_id K_use lib_cell_id opt_config ';'
  ;

opt_config
  : /* The use clause takes an optional :config. */
  | ':' K_config
  ;

lib_cell_id
  : IDENTIFIER
  | IDENTIFIER '.' IDENTIFIER
  ;

list_of_libraries
  : /* A NULL library means use the parents cell library. */
  | list_of_libraries IDENTIFIER
  ;

drive_strength
    : '(' dr_strength0 ',' dr_strength1 ')'
    | '(' dr_strength1 ',' dr_strength0 ')'
    | '(' dr_strength0 ',' K_highz1 ')'
    | '(' dr_strength1 ',' K_highz0 ')'
    | '(' K_highz1 ',' dr_strength0 ')'
    | '(' K_highz0 ',' dr_strength1 ')'
    ;

drive_strength_opt
    : drive_strength
    |               
    ;

dr_strength0
    : K_supply0
    | K_strong0
    | K_pull0  
    | K_weak0  
    ;

dr_strength1
    : K_supply1
    | K_strong1
    | K_pull1  
    | K_weak1  
    ;

clocking_event_opt /* */
  : event_control
  |
  ;

event_control /* A.K.A. clocking_event */
    : '@' hierarchy_identifier
    | '@' '(' event_expression_list ')'
    | '@' '(' error ')'
    ;

event_expression_list
    : event_expression
    | event_expression_list K_or event_expression
    | event_expression_list ',' event_expression
    ;

event_expression
    : K_posedge expression
    | K_negedge expression
    | expression
    ;

  /* A branch probe expression applies a probe function (potential or
     flow) to a branch. The branch may be implicit as a pair of nets
     or explicit as a named branch. Elaboration will check that the
     function name really is a nature attribute identifier. */
branch_probe_expression
  : IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ')'
  | IDENTIFIER '(' IDENTIFIER ')'
  ;

expression
  : expr_primary
  | inc_or_dec_expression
  | inside_expression
  | '+' attribute_list_opt expr_primary %prec UNARY_PREC
  | '-' attribute_list_opt expr_primary %prec UNARY_PREC
  | '~' attribute_list_opt expr_primary %prec UNARY_PREC
  | '&' attribute_list_opt expr_primary %prec UNARY_PREC
  | '!' attribute_list_opt expr_primary %prec UNARY_PREC
  | '|' attribute_list_opt expr_primary %prec UNARY_PREC
  | '^' attribute_list_opt expr_primary %prec UNARY_PREC
  | '~' '&' attribute_list_opt expr_primary %prec UNARY_PREC
  | '~' '|' attribute_list_opt expr_primary %prec UNARY_PREC
  | '~' '^' attribute_list_opt expr_primary %prec UNARY_PREC
  | K_NAND attribute_list_opt expr_primary %prec UNARY_PREC
  | K_NOR attribute_list_opt expr_primary %prec UNARY_PREC
  | K_NXOR attribute_list_opt expr_primary %prec UNARY_PREC
  | '!' error %prec UNARY_PREC
  | '^' error %prec UNARY_PREC
  | expression '^' attribute_list_opt expression
  | expression K_POW attribute_list_opt expression
  | expression '*' attribute_list_opt expression
  | expression '/' attribute_list_opt expression
  | expression '%' attribute_list_opt expression
  | expression '+' attribute_list_opt expression
  | expression '-' attribute_list_opt expression
  | expression '&' attribute_list_opt expression
  | expression '|' attribute_list_opt expression
  | expression K_NAND attribute_list_opt expression
  | expression K_NOR attribute_list_opt expression
  | expression K_NXOR attribute_list_opt expression
  | expression '<' attribute_list_opt expression
  | expression '>' attribute_list_opt expression
  | expression K_LS attribute_list_opt expression
  | expression K_RS attribute_list_opt expression
  | expression K_RSS attribute_list_opt expression
  | expression K_EQ attribute_list_opt expression
  | expression K_CEQ attribute_list_opt expression
  | expression K_LE attribute_list_opt expression
  | expression K_GE attribute_list_opt expression
  | expression K_NE attribute_list_opt expression
  | expression K_CNE attribute_list_opt expression
  | expression K_LOR attribute_list_opt expression
  | expression K_LAND attribute_list_opt expression
  | expression '?' attribute_list_opt expression ':' expression
  ;

expr_mintypmax
    : expression
    | expression ':' expression ':' expression
    ;


  /* Many contexts take a comma separated list of expressions. Null
     expressions can happen anywhere in the list, so there are two
     extra rules in expression_list_with_nuls for parsing and
     installing those nulls.

     The expression_list_proper rules do not allow null items in the
     expression list, so can be used where nul expressions are not allowed. */

expression_list_with_nuls
  : expression_list_with_nuls ',' expression
  | expression
  |
  | expression_list_with_nuls ','
    ;

expression_list_proper
  : expression_list_proper ',' expression
  | expression
  ;

expr_primary
  : number
  | REALTIME
  | STRING
  | SYSTEM_IDENTIFIER
  /* There are a few special cases (notably $bits argument) where the
     expression may be a type name. Let the elaborator sort this out. */
  | TYPE_IDENTIFIER
  /* The hierarchy_identifier rule matches simple identifiers as well as
     indexed arrays and part selects */
  | hierarchy_identifier
  | PACKAGE_IDENTIFIER K_SCOPE_RES hierarchy_identifier
  /* An identifier followed by an expression list in parentheses is a
     function call. If a system identifier, then a system function
     call. */
  | hierarchy_identifier '(' expression_list_with_nuls ')'
  | SYSTEM_IDENTIFIER '(' expression_list_proper ')'
  | PACKAGE_IDENTIFIER K_SCOPE_RES IDENTIFIER '(' expression_list_proper ')'
  | SYSTEM_IDENTIFIER '('  ')'
  | implicit_class_handle
  | implicit_class_handle '.' hierarchy_identifier
  /* Many of the VAMS built-in functions are available as builtin
     functions with $system_function equivalents. */
  | K_acos '(' expression ')'
  | K_acosh '(' expression ')'
  | K_asin '(' expression ')'
  | K_asinh '(' expression ')'
  | K_atan '(' expression ')'
  | K_atanh '(' expression ')'
  | K_atan2 '(' expression ',' expression ')'
  | K_ceil '(' expression ')'
  | K_cos '(' expression ')'
  | K_cosh '(' expression ')'
  | K_exp '(' expression ')'
  | K_floor '(' expression ')'
  | K_hypot '(' expression ',' expression ')'
  | K_ln '(' expression ')'
  | K_log '(' expression ')'
  | K_pow '(' expression ',' expression ')'
  | K_sin '(' expression ')'
  | K_sinh '(' expression ')'
  | K_sqrt '(' expression ')'
  | K_tan '(' expression ')'
  | K_tanh '(' expression ')'
  /* These mathematical functions are conveniently expressed as unary
     and binary expressions. They behave much like unary/binary
     operators, even though they are parsed as functions.  */
  | K_abs '(' expression ')'
  | K_max '(' expression ',' expression ')'
  | K_min '(' expression ',' expression ')'
  /* Parenthesized expressions are primaries. */
  | '(' expr_mintypmax ')'
  /* Various kinds of concatenation expressions. */
  | '{' expression_list_proper '}'
  | '{' expression '{' expression_list_proper '}' '}'
  | '{' expression '{' expression_list_proper '}' error '}'
  | '{' '}'
  /* Cast expressions are primaries */
  | DEC_NUMBER '\'' '(' expression ')'
  /* Aggregate literals are primaries. */
  | assignment_pattern
  /* SystemVerilog supports streaming concatenation */
  | streaming_concatenation
  | K_null
  ;

  /* A function_item_list borrows the task_port_item run to match
     declarations of ports. We check later to make sure there are no
     output or inout ports actually used.
     The function_item is the same as tf_item_declaration. */
function_item_list_opt
  : function_item_list
  |                   
  ;

function_item_list
  : function_item
  | function_item_list function_item
 ;

function_item
  : tf_port_declaration
  | block_item_decl
  ;

  /* A gate_instance is a module instantiation or a built in part
     type. In any case, the gate has a set of connections to ports. */
gate_instance
  : IDENTIFIER '(' expression_list_with_nuls ')'
  | IDENTIFIER dimensions '(' expression_list_with_nuls ')'
  | '(' expression_list_with_nuls ')'
  /* Degenerate modules can have no ports. */
  | IDENTIFIER dimensions
  /* Modules can also take ports by port-name expressions. */
  | IDENTIFIER '(' port_name_list ')'
  | IDENTIFIER dimensions '(' port_name_list ')'
  | IDENTIFIER '(' error ')'
  | IDENTIFIER dimensions '(' error ')'
  ;

gate_instance_list
    : gate_instance_list ',' gate_instance
    | gate_instance
    ;

gatetype
    : K_and 
    | K_nand
    | K_or  
    | K_nor 
    | K_xor 
    | K_xnor
    | K_buf 
    | K_bufif0
    | K_bufif1
    | K_not   
    | K_notif0
    | K_notif1
    ;

switchtype
    : K_nmos 
    | K_rnmos
    | K_pmos 
    | K_rpmos
    | K_cmos 
    | K_rcmos
    | K_tran 
    | K_rtran
    | K_tranif0
    | K_tranif1
    | K_rtranif0
    | K_rtranif1
    ;


  /* A general identifier is a hierarchical name, with the right most
     name the base of the identifier. This rule builds up a
     hierarchical name from the left to the right, forming a list of
     names. */

hierarchy_identifier
    : IDENTIFIER
    | hierarchy_identifier '.' IDENTIFIER
    | hierarchy_identifier '[' expression ']'
    | hierarchy_identifier '[' expression ':' expression ']'
    | hierarchy_identifier '[' expression K_PO_POS expression ']'
    | hierarchy_identifier '[' expression K_PO_NEG expression ']'
    ;

  /* This is a list of identifiers. The result is a list of strings,
     each one of the identifiers in the list. These are simple,
     non-hierarchical names separated by ',' characters. */
list_of_identifiers
    : IDENTIFIER
    | list_of_identifiers ',' IDENTIFIER
    ;

list_of_port_identifiers
    : IDENTIFIER
    | IDENTIFIER '=' expression
    | list_of_port_identifiers ',' IDENTIFIER
    | list_of_port_identifiers ',' IDENTIFIER '=' expression
    ;


  /* The list_of_ports and list_of_port_declarations rules are the
     port list formats for module ports. The list_of_ports_opt rule is
     only used by the module start rule.

     The first, the list_of_ports, is the 1364-1995 format, a list of
     port names, including .name() syntax.

     The list_of_port_declarations the 1364-2001 format, an in-line
     declaration of the ports.

     In both cases, the list_of_ports and list_of_port_declarations
     returns an array of Module::port_t* items that include the name
     of the port internally and externally. The actual creation of the
     nets/variables is done in the declaration, whether internal to
     the port list or in amongst the module items. */

list_of_ports
    : port_opt
    | list_of_ports ',' port_opt
    ;

list_of_port_declarations
    : port_declaration
    | list_of_port_declarations ',' port_declaration
    | list_of_port_declarations ',' IDENTIFIER
    | list_of_port_declarations ','
    | list_of_port_declarations ';'
        ;

port_declaration
  : attribute_list_opt K_input net_type_opt data_type_or_implicit IDENTIFIER dimensions_opt
  | attribute_list_opt
    K_input K_wreal IDENTIFIER
  | attribute_list_opt K_inout net_type_opt data_type_or_implicit IDENTIFIER dimensions_opt
  | attribute_list_opt
    K_inout K_wreal IDENTIFIER
  | attribute_list_opt K_output net_type_opt data_type_or_implicit IDENTIFIER dimensions_opt
  | attribute_list_opt
    K_output K_wreal IDENTIFIER
  | attribute_list_opt K_output net_type_opt data_type_or_implicit IDENTIFIER '=' expression
  ;



net_type_opt
    : net_type
    |
    ;

  /*
   * The signed_opt rule will return "true" if K_signed is present,
   * for "false" otherwise. This rule corresponds to the declaration
   * defaults for reg/bit/logic.
   *
   * The signed_unsigned_opt rule with match K_signed or K_unsigned
   * and return true or false as appropriate. The default is
   * "true". This corresponds to the declaration defaults for
   * byte/shortint/int/longint.
   */
unsigned_signed_opt
  : K_signed  
  | K_unsigned
  |           
  ;

signed_unsigned_opt
  : K_signed  
  | K_unsigned
  |           
  ;

  /*
   * In some places we can take any of the 4 2-value atom-type
   * names. All the context needs to know if that type is its width.
   */
atom2_type
  : K_byte    
  | K_shortint
  | K_int     
  | K_longint 
  ;

  /* An lpvalue is the expression that can go on the left side of a
     procedural assignment. This rule handles only procedural
     assignments. It is more limited than the general expr_primary
     rule to reflect the rules for assignment l-values. */
lpvalue
  : hierarchy_identifier
  | implicit_class_handle '.' hierarchy_identifier
  | '{' expression_list_proper '}'
  | streaming_concatenation
  ;

  /* Continuous assignments have a list of individual assignments. */
cont_assign
  : lpvalue '=' expression
  ;

cont_assign_list
  : cont_assign_list ',' cont_assign
  | cont_assign
  ;

  /* We allow zero, one or two unique declarations. */
local_timeunit_prec_decl_opt
    : /* Empty */
    | K_timeunit TIME_LITERAL '/' TIME_LITERAL ';'
    | local_timeunit_prec_decl
    | local_timeunit_prec_decl local_timeunit_prec_decl2
    ;

  /* By setting the appropriate have_time???_decl we allow only
     one declaration of each type in this module. */
local_timeunit_prec_decl
    : K_timeunit TIME_LITERAL ';'
    | K_timeprecision TIME_LITERAL ';'
    ;
local_timeunit_prec_decl2
    : K_timeunit TIME_LITERAL ';'
    | K_timeprecision TIME_LITERAL ';'
      /* As the second item this form is always a check. */
    | K_timeunit TIME_LITERAL '/' TIME_LITERAL ';'
    ;

  /* This is the global structure of a module. A module in a start
     section, with optional ports, then an optional list of module
     items, and finally an end marker. */

module
  : attribute_list_opt module_start IDENTIFIER
    module_parameter_port_list_opt
    module_port_list_opt
    module_attribute_foreign ';'
    local_timeunit_prec_decl_opt
    module_item_list_opt
    module_end
    endlabel_opt
  ;

  /* Modules start with module/macromodule or program keyword, and end
     with the endmodule or endprogram keyword. The syntax for modules
     and programs is almost identical, so let semantics sort out the
     differences. */
module_start
  : K_module     
  | K_macromodule
  | K_program    
  ;

module_end
  : K_endmodule  
  | K_endprogram 
  ;

endlabel_opt
  : ':' IDENTIFIER
  |               
  ;

module_attribute_foreign
    : K_PSTAR IDENTIFIER K_integer IDENTIFIER '=' STRING ';' K_STARP
    |
    ;

module_port_list_opt
  : '(' list_of_ports ')'
  | '(' list_of_port_declarations ')'
  |                      
  | '(' error ')'
  ;

  /* Module declarations include optional ANSI style module parameter
     ports. These are simply advance ways to declare parameters, so
     that the port declarations may use them. */
module_parameter_port_list_opt
    :
        | '#' '(' module_parameter_port_list ')'
    ;

module_parameter_port_list
    : K_parameter param_type parameter_assign
    | module_parameter_port_list ',' parameter_assign
    | module_parameter_port_list ',' K_parameter param_type parameter_assign
    ;

module_item

  /* Modules can contain further sub-module definitions. */
  : module
  | attribute_list_opt net_type data_type_or_implicit delay3_opt net_variable_list ';'
  | attribute_list_opt K_wreal delay3 net_variable_list ';'
  | attribute_list_opt K_wreal net_variable_list ';'
  /* Very similar to the rule above, but this takes a list of
     net_decl_assigns, which are <name> = <expr> assignment
     declarations. */
  | attribute_list_opt net_type data_type_or_implicit delay3_opt net_decl_assigns ';'
  /* This form doesn't have the range, but does have strengths. This
     gives strength to the assignment drivers. */
  | attribute_list_opt net_type data_type_or_implicit drive_strength net_decl_assigns ';'
  | attribute_list_opt K_wreal net_decl_assigns ';'
    | K_trireg charge_strength_opt dimensions_opt delay3_opt list_of_identifiers ';'
  | attribute_list_opt port_direction unsigned_signed_opt dimensions_opt delay3_opt list_of_identifiers ';'
  /* The next two rules handle Verilog 2001 statements of the form:
       input wire signed [h:l] <list>;
     This creates the wire and sets the port type all at once. */
  | attribute_list_opt port_direction net_type unsigned_signed_opt dimensions_opt list_of_identifiers ';'
  | attribute_list_opt K_output var_type unsigned_signed_opt dimensions_opt list_of_port_identifiers ';'
  | attribute_list_opt port_direction K_wreal list_of_identifiers ';'
  /* var_type declaration (reg variables) cannot be input or output,
     because the port declaration implies an external driver, which
     cannot be attached to a reg. These rules catch that error early. */
  | attribute_list_opt K_input var_type unsigned_signed_opt dimensions_opt list_of_identifiers ';'
  | attribute_list_opt K_inout var_type unsigned_signed_opt dimensions_opt list_of_identifiers ';'
  | attribute_list_opt port_direction unsigned_signed_opt dimensions_opt delay3_opt error ';'
  /* Maybe this is a discipline declaration? If so, then the lexor
     will see the discipline name as an identifier. We match it to the
     discipline or type name semantically. */
  | DISCIPLINE_IDENTIFIER list_of_identifiers ';'
  /* block_item_decl rule is shared with task blocks and named
     begin/end. Careful to pass attributes to the block_item_decl. */
  | attribute_list_opt block_item_decl
  /* */
    | K_defparam defparam_assign_list ';'
  /* Most gate types have an optional drive strength and optional
     two/three-value delay. These rules handle the different cases.
     We check that the actual number of delays is correct later. */
  | attribute_list_opt gatetype gate_instance_list ';'
  | attribute_list_opt gatetype delay3 gate_instance_list ';'
  | attribute_list_opt gatetype drive_strength gate_instance_list ';'
  | attribute_list_opt gatetype drive_strength delay3 gate_instance_list ';'
  /* The switch type gates do not support a strength. */
  | attribute_list_opt switchtype gate_instance_list ';'
  | attribute_list_opt switchtype delay3 gate_instance_list ';'
  /* Pullup and pulldown devices cannot have delays, and their
     strengths are limited. */
  | K_pullup gate_instance_list ';'
  | K_pulldown gate_instance_list ';'
  | K_pullup '(' dr_strength1 ')' gate_instance_list ';'
  | K_pullup '(' dr_strength1 ',' dr_strength0 ')' gate_instance_list ';'
  | K_pullup '(' dr_strength0 ',' dr_strength1 ')' gate_instance_list ';'
  | K_pulldown '(' dr_strength0 ')' gate_instance_list ';'
  | K_pulldown '(' dr_strength1 ',' dr_strength0 ')' gate_instance_list ';'
  | K_pulldown '(' dr_strength0 ',' dr_strength1 ')' gate_instance_list ';'
  /* This rule handles instantiations of modules and user defined
     primitives. These devices to not have delay lists or strengths,
     but then can have parameter lists. */
    | attribute_list_opt
      IDENTIFIER parameter_value_opt gate_instance_list ';'
        | attribute_list_opt
      IDENTIFIER parameter_value_opt error ';'
  /* Continuous assignment can have an optional drive strength, then
     an optional delay3 that applies to all the assignments in the
     cont_assign_list. */
    | K_assign drive_strength_opt delay3_opt cont_assign_list ';'
  /* Always and initial items are behavioral processes. */
  | attribute_list_opt K_always statement_item
  | attribute_list_opt K_initial statement_item
  | attribute_list_opt K_final statement_item
  | attribute_list_opt K_analog analog_statement
  | attribute_list_opt assertion_item
  | class_declaration
  | task_declaration
  | function_declaration
  /* A generate region can contain further module items. Actually, it
     is supposed to be limited to certain kinds of module items, but
     the semantic tests will check that for us. Do check that the
     generate/endgenerate regions do not nest. Generate schemes nest,
     but generate regions do not. */
  | K_generate module_item_list_opt K_endgenerate
  | K_genvar list_of_identifiers ';'
  | K_for '(' IDENTIFIER '=' expression ';'
              expression ';'
              IDENTIFIER '=' expression ')'
    generate_block
  | generate_if
    generate_block_opt
    K_else
    generate_block
  | generate_if
    generate_block_opt %prec less_than_K_else
  | K_case '(' expression ')'
    generate_case_items
    K_endcase
  /* Handle some anachronistic syntax cases. */
  | K_generate K_begin module_item_list_opt K_end K_endgenerate
  | K_generate K_begin ':' IDENTIFIER  module_item_list_opt K_end K_endgenerate
  | package_import_declaration
  /* 1364-2001 and later allow specparam declarations outside specify blocks. */
  | attribute_list_opt K_specparam specparam_decl ';'
  /* specify blocks are parsed but ignored. */
    | K_specify K_endspecify
    | K_specify specify_item_list K_endspecify
    | K_specify error K_endspecify
  /* These rules match various errors that the user can type into
     module items. These rules try to catch them at a point where a
     reasonable error message can be produced. */
    | error ';'
    | K_assign error '=' expression ';'
    | K_assign error ';'
    | K_function error K_endfunction endlabel_opt
  /* These rules are for the Icarus Verilog specific $attribute
     extensions. Then catch the parameters of the $attribute keyword. */
    | KK_attribute '(' IDENTIFIER ',' STRING ',' STRING ')' ';'
    | KK_attribute '(' error ')' ';'
    | K_timeunit_check  TIME_LITERAL ';'
    | K_timeunit_check TIME_LITERAL '/' TIME_LITERAL ';'
    | K_timeprecision_check TIME_LITERAL ';'
    ;

generate_if : K_if '(' expression ')' ;

generate_case_items
  : generate_case_items generate_case_item
  | generate_case_item
  ;

generate_case_item
  : expression_list_proper ':' generate_block_opt
  | K_default ':' generate_block_opt
  ;

module_item_list
    : module_item_list module_item
    | module_item
    ;

module_item_list_opt
    : module_item_list
    |
    ;

  /* A generate block is the thing within a generate scheme. It may be
     a single module item, an anonymous block of module items, or a
     named module item. In all cases, the meat is in the module items
     inside, and the processing is done by the module_item rules. We
     only need to take note here of the scope name, if any. */

generate_block
        : module_item
        | K_begin module_item_list_opt K_end
        | K_begin ':' IDENTIFIER module_item_list_opt K_end endlabel_opt
        ;

generate_block_opt : generate_block | ';' ;


  /* A net declaration assignment allows the programmer to combine the
     net declaration and the continuous assignment into a single
     statement.

     Note that the continuous assignment statement is generated as a
     side effect, and all I pass up is the name of the l-value. */

net_decl_assign
  : IDENTIFIER '=' expression
  ;

net_decl_assigns
    : net_decl_assigns ',' net_decl_assign
    | net_decl_assign
    ;

bit_logic
  : K_logic
  | K_bool 
  | K_bit  
  ;

bit_logic_opt
  : bit_logic
  |        
  ;

net_type
    : K_wire   
    | K_tri    
    | K_tri1   
    | K_supply0
    | K_wand   
    | K_triand 
    | K_tri0   
    | K_supply1
    | K_wor    
    | K_trior  
    | K_wone   
    | K_uwire  
    ;

var_type
    : K_reg
    ;

param_type
  : bit_logic_opt unsigned_signed_opt dimensions_opt
  | K_integer
  | K_time
  | real_or_realtime
  | atom2_type
  ;

  /* parameter and localparam assignment lists are broken into
     separate BNF so that I can call slightly different parameter
     handling code. localparams parse the same as parameters, they
     just behave differently when someone tries to override them. */

parameter_assign_list
  : parameter_assign
  | parameter_assign_list ',' parameter_assign
  ;

localparam_assign_list
  : localparam_assign
  | localparam_assign_list ',' localparam_assign
  ;

parameter_assign
  : IDENTIFIER '=' expression parameter_value_ranges_opt
  ;

localparam_assign
  : IDENTIFIER '=' expression
  ;

parameter_value_ranges_opt : parameter_value_ranges | ;

parameter_value_ranges
  : parameter_value_ranges parameter_value_range
  | parameter_value_range
  ;

parameter_value_range
  : from_exclude '[' value_range_expression ':' value_range_expression ']'
  | from_exclude '[' value_range_expression ':' value_range_expression ')'
  | from_exclude '(' value_range_expression ':' value_range_expression ']'
  | from_exclude '(' value_range_expression ':' value_range_expression ')'
  | K_exclude expression
  ;

value_range_expression
  : expression
  | K_inf
  | '+' K_inf
  | '-' K_inf
  ;

from_exclude : K_from | K_exclude ;

  /* The parameters of a module instance can be overridden by writing
     a list of expressions in a syntax much like a delay list. (The
     difference being the list can have any length.) The pform that
     attaches the expression list to the module checks that the
     expressions are constant.

     Although the BNF in IEEE1364-1995 implies that parameter value
     lists must be in parentheses, in practice most compilers will
     accept simple expressions outside of parentheses if there is only
     one value, so I'll accept simple numbers here. This also catches
     the case of a UDP with a single delay value, so we need to accept
     real values as well as decimal ones.

     The parameter value by name syntax is OVI enhancement BTF-B06 as
     approved by WG1364 on 6/28/1998. */

parameter_value_opt
    : '#' '(' expression_list_with_nuls ')'
    | '#' '(' parameter_value_byname_list ')'
    | '#' DEC_NUMBER
    | '#' REALTIME
    | '#' error
    |
    ;

parameter_value_byname
    : '.' IDENTIFIER '(' expression ')'
    | '.' IDENTIFIER '(' ')'
    ;

parameter_value_byname_list
  : parameter_value_byname
  | parameter_value_byname_list ',' parameter_value_byname
  ;


  /* The port (of a module) is a fairly complex item. Each port is
     handled as a Module::port_t object. A simple port reference has a
     name and a PExpr object, but more complex constructs are possible
     where the name can be attached to a list of PWire objects.

     The port_reference returns a Module::port_t, and so does the
     port_reference_list. The port_reference_list may have built up a
     list of PWires in the port_t object, but it is still a single
     Module::port_t object.

     The port rule below takes the built up Module::port_t object and
     tweaks its name as needed. */

port
    : port_reference
  /* This syntax attaches an external name to the port reference so
     that the caller can bind by name to non-trivial port
     references. The port_t object gets its PWire from the
     port_reference, but its name from the IDENTIFIER. */
    | '.' IDENTIFIER '(' port_reference ')'
  /* A port can also be a concatenation of port references. In this
     case the port does not have a name available to the outside, only
     positional parameter passing is possible here. */
    | '{' port_reference_list '}'
  /* This attaches a name to a port reference concatenation list so
     that parameter passing be name is possible. */
    | '.' IDENTIFIER '(' '{' port_reference_list '}' ')'
    ;

port_opt
    : port
    |
    ;

  /* The port_name rule is used with a module is being *instantiated*,
     and not when it is being declared. See the port rule if you are
     looking for the ports of a module declaration. */

port_name
    : '.' IDENTIFIER '(' expression ')'
    | '.' IDENTIFIER '(' error ')'
    | '.' IDENTIFIER '(' ')'
    | '.' IDENTIFIER
    | K_DOTSTAR
    ;

port_name_list
  : port_name_list ',' port_name
  | port_name
  ;


  /* A port reference is an internal (to the module) name of the port,
     possibly with a part of bit select to attach it to specific bits
     of a signal fully declared inside the module.

     The parser creates a PEIdent for every port reference, even if the
     signal is bound to different ports. The elaboration figures out
     the mess that this creates. The port_reference (and the
     port_reference_list below) puts the port reference PEIdent into the
     port_t object to pass it up to the module declaration code. */

port_reference
    : IDENTIFIER
    | IDENTIFIER '[' expression ':' expression ']'

    | IDENTIFIER '[' expression ']'

    | IDENTIFIER '[' error ']'
    ;

port_reference_list
    : port_reference
    | port_reference_list ',' port_reference
    ;

  /* The range is a list of variable dimensions. */
dimensions_opt
  :
  | dimensions
  ;

dimensions
  : variable_dimension
  | dimensions variable_dimension
  ;

  /* The register_variable rule is matched only when I am parsing
     variables in a "reg" definition. I therefore know that I am
     creating registers and I do not need to let the containing rule
     handle it. The register variable list simply packs them together
     so that bit ranges can be assigned. */
register_variable
  : IDENTIFIER dimensions_opt
  | IDENTIFIER dimensions_opt '=' expression
  ;

register_variable_list
    : register_variable
    | register_variable_list ',' register_variable
    ;

net_variable
  : IDENTIFIER dimensions_opt
  ;

net_variable_list
    : net_variable
    | net_variable_list ',' net_variable
    ;

specify_item
    : K_specparam specparam_decl ';'
    | specify_simple_path_decl ';'
    | specify_edge_path_decl ';'
    | K_if '(' expression ')' specify_simple_path_decl ';'
    | K_if '(' expression ')' specify_edge_path_decl ';'
    | K_ifnone specify_simple_path_decl ';'
    | K_ifnone specify_edge_path_decl ';'
    | K_Sfullskew '(' spec_reference_event ',' spec_reference_event
      ',' delay_value ',' delay_value spec_notifier_opt ')' ';'
    | K_Shold '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Snochange '(' spec_reference_event ',' spec_reference_event
      ',' delay_value ',' delay_value spec_notifier_opt ')' ';'
    | K_Speriod '(' spec_reference_event ',' delay_value
      spec_notifier_opt ')' ';'
    | K_Srecovery '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Srecrem '(' spec_reference_event ',' spec_reference_event
      ',' delay_value ',' delay_value spec_notifier_opt ')' ';'
    | K_Sremoval '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Ssetup '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Ssetuphold '(' spec_reference_event ',' spec_reference_event
      ',' delay_value ',' delay_value spec_notifier_opt ')' ';'
    | K_Sskew '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Stimeskew '(' spec_reference_event ',' spec_reference_event
      ',' delay_value spec_notifier_opt ')' ';'
    | K_Swidth '(' spec_reference_event ',' delay_value ',' expression
      spec_notifier_opt ')' ';'
    | K_Swidth '(' spec_reference_event ',' delay_value ')' ';'
    | K_pulsestyle_onevent specify_path_identifiers ';'
    | K_pulsestyle_ondetect specify_path_identifiers ';'
    | K_showcancelled specify_path_identifiers ';'
    | K_noshowcancelled specify_path_identifiers ';'
    ;

specify_item_list
    : specify_item
    | specify_item_list specify_item
    ;

specify_edge_path_decl
    : specify_edge_path '=' '(' delay_value_list ')'
    | specify_edge_path '=' delay_value_simple
    ;

edge_operator : K_posedge | K_negedge ;

specify_edge_path
    : '('               specify_path_identifiers spec_polarity
          K_EG '(' specify_path_identifiers polarity_operator expression ')' ')'
    | '(' edge_operator specify_path_identifiers spec_polarity
          K_EG '(' specify_path_identifiers polarity_operator expression ')' ')'
    | '('               specify_path_identifiers spec_polarity
          K_SG  '(' specify_path_identifiers polarity_operator expression ')' ')'
    | '(' edge_operator specify_path_identifiers spec_polarity
          K_SG '(' specify_path_identifiers polarity_operator expression ')' ')'
    ;

polarity_operator
        : K_PO_POS
    | K_PO_NEG
    | ':'
    ;

specify_simple_path_decl
    : specify_simple_path '=' '(' delay_value_list ')'
    | specify_simple_path '=' delay_value_simple
    | specify_simple_path '=' '(' error ')'
    ;

specify_simple_path
    : '(' specify_path_identifiers spec_polarity
              K_EG specify_path_identifiers ')'
    | '(' specify_path_identifiers spec_polarity
              K_SG specify_path_identifiers ')'
    | '(' error ')'
    ;

specify_path_identifiers
    : IDENTIFIER
    | IDENTIFIER '[' expr_primary ']'
    | specify_path_identifiers ',' IDENTIFIER
    | specify_path_identifiers ',' IDENTIFIER '[' expr_primary ']'
    ;

specparam
    : IDENTIFIER '=' expression
    | IDENTIFIER '=' expression ':' expression ':' expression
    | PATHPULSE_IDENTIFIER '=' expression
    | PATHPULSE_IDENTIFIER '=' '(' expression ',' expression ')'
    ;

specparam_list
  : specparam
  | specparam_list ',' specparam
  ;

specparam_decl
  : specparam_list
  | dimensions
    specparam_list
  ;

spec_polarity
    : '+' 
    | '-' 
    |     
    ;

spec_reference_event
  : K_posedge expression
  | K_negedge expression
  | K_posedge expr_primary K_TAND expression
  | K_negedge expr_primary K_TAND expression
  | K_edge '[' edge_descriptor_list ']' expr_primary
  | K_edge '[' edge_descriptor_list ']' expr_primary K_TAND expression
  | expr_primary K_TAND expression
  | expr_primary
  ;

  /* The edge_descriptor is detected by the lexor as the various
     2-letter edge sequences that are supported here. For now, we
     don't care what they are, because we do not yet support specify
     edge events. */
edge_descriptor_list
  : edge_descriptor_list ',' K_edge_descriptor
  | K_edge_descriptor
  ;

spec_notifier_opt
    : /* empty */
    | spec_notifier
    ;
spec_notifier
    : ','
    | ','  hierarchy_identifier
    | spec_notifier ','
    | spec_notifier ',' hierarchy_identifier
  /* How do we match this path? */
    | IDENTIFIER
    ;


statement_item /* This is roughly statement_item in the LRM */

  /* assign and deassign statements are procedural code to do
     structural assignments, and to turn that structural assignment
     off. This is stronger than any other assign, but weaker than the
     force assignments. */
    : K_assign lpvalue '=' expression ';'
    | K_deassign lpvalue ';'

  /* Force and release statements are similar to assignments,
     syntactically, but they will be elaborated differently. */
    | K_force lpvalue '=' expression ';'
    | K_release lpvalue ';'
  /* begin-end blocks come in a variety of forms, including named and
     anonymous. The named blocks can also carry their own reg
     variables, which are placed in the scope created by the block
     name. These are handled by pushing the scope name, then matching
     the declarations. The scope is popped at the end of the block. */
  | K_begin K_end
  | K_begin statement_or_null_list K_end
  | K_begin ':' IDENTIFIER
    block_item_decls_opt
    statement_or_null_list_opt K_end endlabel_opt
  /* fork-join blocks are very similar to begin-end blocks. In fact,
     from the parser's perspective there is no real difference. All we
     need to do is remember that this is a parallel block so that the
     code generator can do the right thing. */
  | K_fork join_keyword
  | K_fork statement_or_null_list join_keyword
  | K_fork ':' IDENTIFIER
    block_item_decls_opt
    statement_or_null_list_opt join_keyword endlabel_opt
    | K_disable hierarchy_identifier ';'
    | K_disable K_fork ';'
    | K_TRIGGER hierarchy_identifier ';'
  | loop_statement
  | jump_statement
    | K_case '(' expression ')' case_items K_endcase
    | K_casex '(' expression ')' case_items K_endcase
    | K_casez '(' expression ')' case_items K_endcase
    | K_case '(' expression ')' error K_endcase
    | K_casex '(' expression ')' error K_endcase
    | K_casez '(' expression ')' error K_endcase
    | K_if '(' expression ')' statement_or_null %prec less_than_K_else
    | K_if '(' expression ')' statement_or_null K_else statement_or_null
    | K_if '(' error ')' statement_or_null %prec less_than_K_else
    | K_if '(' error ')' statement_or_null K_else statement_or_null
  /* SytemVerilog adds the compressed_statement */
  | compressed_statement ';'
  /* increment/decrement expressions can also be statements. When used
     as statements, we can rewrite a++ as a += 1, and so on. */
  | inc_or_dec_expression ';'
  | delay1 statement_or_null
  | event_control statement_or_null
  | '@' '*' statement_or_null
  | '@' '(' '*' ')' statement_or_null
  /* Various assignment statements */
  | lpvalue '=' expression ';'
  | error '=' expression ';'
  | lpvalue K_LE expression ';'
  | error K_LE expression ';'
  | lpvalue '=' delay1 expression ';'
  | lpvalue K_LE delay1 expression ';'
  | lpvalue '=' event_control expression ';'
  | lpvalue '=' K_repeat '(' expression ')' event_control expression ';'
  | lpvalue K_LE event_control expression ';'
  | lpvalue K_LE K_repeat '(' expression ')' event_control expression ';'
  /* The IEEE1800 standard defines dynamic_array_new assignment as a
     different rule from regular assignment. That implies that the
     dynamic_array_new is not an expression in general, which makes
     some sense. Elaboration should make sure the lpvalue is an array name. */
  | lpvalue '=' dynamic_array_new ';'
  /* The class new and dynamic array new expressions are special, so
     sit in rules of their own. */
  | lpvalue '=' class_new ';'
  | K_wait '(' expression ')' statement_or_null
  | K_wait K_fork ';'
  | SYSTEM_IDENTIFIER '(' expression_list_with_nuls ')' ';'
  | SYSTEM_IDENTIFIER ';'
  | hierarchy_identifier '(' expression_list_with_nuls ')' ';'
  | hierarchy_identifier K_with '{' constraint_block_item_list_opt '}' ';'
  | implicit_class_handle '.' hierarchy_identifier '(' expression_list_with_nuls ')' ';'
  | hierarchy_identifier ';'
    /* IEEE1800 A.1.8: class_constructor_declaration with a call to
       parent constructor. Note that the implicit_class_handle must
       be K_super ("this.new" makes little sense) but that would
       cause a conflict. Anyhow, this statement must be in the
       beginning of a constructor, but let the elaborator figure that
       out. */
  | implicit_class_handle '.' K_new '(' expression_list_with_nuls ')' ';'
  | hierarchy_identifier '(' error ')' ';'
  | error ';'
  ;

compressed_statement
  : lpvalue K_PLUS_EQ expression
  | lpvalue K_MINUS_EQ expression
  | lpvalue K_MUL_EQ expression
  | lpvalue K_DIV_EQ expression
  | lpvalue K_MOD_EQ expression
  | lpvalue K_AND_EQ expression
  | lpvalue K_OR_EQ expression
  | lpvalue K_XOR_EQ expression
  | lpvalue K_LS_EQ expression
  | lpvalue K_RS_EQ expression
  | lpvalue K_RSS_EQ expression
  ;

statement_or_null_list_opt
  : statement_or_null_list
  |
  ;

statement_or_null_list
  : statement_or_null_list statement_or_null
  | statement_or_null
  ;

analog_statement
  : branch_probe_expression K_CONTRIBUTE expression ';'
  ;

  /* Task items are, other than the statement, task port items and
     other block items. */
task_item
  : block_item_decl 
  | tf_port_declaration  
  ;

task_item_list
  : task_item_list task_item
  | task_item
  ;

task_item_list_opt
    : task_item_list
    |
    ;

tf_port_list_opt
  : tf_port_list
  |                    
  ;

  /* Note that the lexor notices the "table" keyword and starts
     the UDPTABLE state. It needs to happen there so that all the
     characters in the table are interpreted in that mode. It is still
     up to this rule to take us out of the UDPTABLE state. */
udp_body
  : K_table udp_entry_list K_endtable
  | K_table K_endtable
  | K_table error K_endtable
  ;

udp_entry_list
    : udp_comb_entry_list
    | udp_sequ_entry_list
    ;

udp_comb_entry
    : udp_input_list ':' udp_output_sym ';'
    ;

udp_comb_entry_list
    : udp_comb_entry
    | udp_comb_entry_list udp_comb_entry
    ;

udp_sequ_entry_list
    : udp_sequ_entry
    | udp_sequ_entry_list udp_sequ_entry
    ;

udp_sequ_entry
    : udp_input_list ':' udp_input_sym ':' udp_output_sym ';'
    ;

udp_initial
    : K_initial IDENTIFIER '=' number ';'
    ;

udp_init_opt
    : udp_initial 
    |             
    ;

udp_input_list
    : udp_input_sym
    | udp_input_list udp_input_sym
    ;

udp_input_sym
    : '0'
    | '1'
    | 'x'
    | '?'
    | 'b'
    | '*'
    | '%'
    | 'f'
    | 'F'
    | 'l'
    | 'h'
    | 'B'
    | 'r'
    | 'R'
    | 'M'
    | 'n'
    | 'N'
    | 'p'
    | 'P'
    | 'Q'
    | 'q'
    | '_'
    | '+'
    | DEC_NUMBER
    ;

udp_output_sym
    : '0'
    | '1'
    | 'x'
    | '-'
    | DEC_NUMBER
    ;

  /* Port declarations create wires for the inputs and the output. The
     makes for these ports are scoped within the UDP, so there is no
     hierarchy involved. */
udp_port_decl
  : K_input list_of_identifiers ';'
  | K_output IDENTIFIER ';'
  | K_reg IDENTIFIER ';'
  | K_reg K_output IDENTIFIER ';'
    ;

udp_port_decls
  : udp_port_decl
  | udp_port_decls udp_port_decl
  ;

udp_port_list
  : IDENTIFIER
  | udp_port_list ',' IDENTIFIER
  ;

udp_reg_opt
  : K_reg
  |
  ;

udp_initial_expr_opt
    : '=' expression
    |               
    ;

udp_input_declaration_list
        : K_input IDENTIFIER
    | udp_input_declaration_list ',' K_input IDENTIFIER
    ;

udp_primitive
        /* This is the syntax for primitives that uses the IEEE1364-1995
       format. The ports are simply names in the port list, and the
       declarations are in the body. */

    : K_primitive IDENTIFIER '(' udp_port_list ')' ';'
        udp_port_decls
        udp_init_opt
        udp_body
      K_endprimitive endlabel_opt

        /* This is the syntax for IEEE1364-2001 format definitions. The port
       names and declarations are all in the parameter list. */

    | K_primitive IDENTIFIER
        '(' K_output udp_reg_opt IDENTIFIER udp_initial_expr_opt ','
        udp_input_declaration_list ')' ';'
        udp_body
      K_endprimitive endlabel_opt
    ;

  /* Many keywords can be optional in the syntax, although their
     presence is significant. This is a fairly common pattern so
     collect those rules here. */

K_automatic_opt: K_automatic | ;
K_packed_opt   : K_packed    | ;
K_reg_opt      : K_reg       | ;
K_static_opt   : K_static    | ;
K_virtual_opt  : K_virtual   | ;

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
