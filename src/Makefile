all:
	yacc -d verilog.yacc
	lex verilog.lex
	gcc -o verilog y.tab.c lex.yy.c -ly -ll
