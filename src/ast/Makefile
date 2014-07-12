all:
	yacc -d vhdl_ast.yacc
	lex vhdl_ast.lex
	gcc -o vhdl y.tab.c lex.yy.c

clean:
	rm y.tab.c lex.yy.c vhdl
