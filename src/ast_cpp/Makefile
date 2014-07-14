all:
	lex vhdl_ast.lex
	yacc -d vhdl_ast.yacc
	g++ -o vhdl main.cpp y.tab.c lex.yy.c

clean:
	rm y.tab.c lex.yy.c vhdl
