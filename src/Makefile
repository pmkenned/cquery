all:
	yacc -d verilog.yacc
	lex verilog.lex
#	gcc -o verilog y.tab.c lex.yy.c -ly -ll -DYYDEBUG=1
	gcc -o verilog y.tab.c lex.yy.c -DYYDEBUG=1

vhdl:
	yacc -d vhdl_ast.yacc
	lex vhdl_ast.lex
	gcc -o vhdl y.tab.c lex.yy.c

clean:
	rm y.tab.c lex.yy.c vhdl
