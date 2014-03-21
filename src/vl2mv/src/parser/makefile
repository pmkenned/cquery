#
#  vl2mv: Verilog to BLIF-MV Translator Distribution
#
#  Copyright (c) 1992, 1993
#        Regents of the University of California
#  All rights reserved.
#
#  Use and copying of this software and preparation of derivative works
#  based upon this software are permitted.  However, any distribution of
#  this software or derivative works must include the above copyright 
#  notice.
#
#  This software is made available AS IS, and neither the Electronics
#  Research Laboratory or the Universify of California make any
#  warranty about the software, its performance or its conformity to
#  any specification.
#
#
# $Header: /vol/eros/eros8/stcheng/vl2mv/src/parser/RCS/makefile,v 1.2 1993/01/15 19:48:20 stcheng Exp stcheng $
#
# makefile for vl2mv
#

# programs used
CC = cc
LEX = lex
MAKE = make
SED = sed
YACC = yacc

# .c.o suffixes
.SUFFIXES:
.SUFFIXES: .c .o

# target
TARGET = ../../vl2mv

# directories
INCLUDE = ../../include
LIB = ../../lib

# related files
CFILES = main.c vl_create.c vl_traverse.c vl_write.c util.c
OFILES = main.o vl_create.o vl_traverse.o vl_write.o util.o
HFILES = $(INCLUDE)/vlr_int.h $(INCLUDE)/vl_create.h $(INCLUDE)/vl_defs.h $(INCLDUDE)/vl_types.h $(INCLUDE)/vl_write.h
LFILES = verilog.l
YFILES = verilog.y
GCFILES = verilog_yacc.c
GLCFILES = verilog_lex.c
GOFILES = verilog_yacc.o
GLOFILES = verilog_lex.o
GHFILES = verilog_yacc.h

# libraries
LIBS = $(LIB)/libutil.a $(LIB)/libarray.a $(LIB)/libst.a  $(LIB)/liblist.a

# flags
CFLAGS = -g -I$(INCLUDE)
LDFLAGS = -g
LFLAGS = -n
YFLAGS = -d

# defaults
.c.o:
	$(CC) -c $(CFLAGS) $*.c

$(TARGET):= CFLAGS = -g
$(TARGET):= LDFLAGS = -g
$(TARGET): $(GOFILES) $(GLOFILES) $(OFILES) $(LIBS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(GOFILES) $(GLOFILES) $(OFILES) $(LIBS)

# yacc/lex rules
verilog_yacc.c verilog.h: verilog.y verilog.sed
	$(YACC) $(YFLAGS) verilog.y
	@$(SED) -f verilog.sed y.tab.c > verilog_yacc.c
	@$(SED) -f verilog.sed y.tab.h > $(INCLUDE)/verilog_yacc.h
	@$(RM) y.tab.c y.tab.h

verilog_lex.c: verilog.l verilog.sed
	$(LEX) $(LFLAGS) verilog.l
	@$(SED) -f verilog.sed lex.yy.c > verilog_lex.c
	@$(RM) lex.yy.c

#libraries
$(LIB)/libutil.a: 
	cd ../util; make; cd ../parser

$(LIB)/libarray.a:
	cd ../array; make; cd ../parser

$(LIB)/libst.a:
	cd ../st; make; cd ../parser

$(LIB)/liblist.a:
	cd ../list; make; cd ../parser

# everything depends on makefile
$(CFILES) $(HFILES) $(EFILES) $(LFILES) $(YFILES): makefile

# files which include .h files
$(CFILES): $(HFILES)

# clean up directory
clean:
	@$(RM) $(TARGET) $(OFILES) $(GCFILES) $(GLCFILES) $(GOFILES) $(GLOFILES) $(GHFILES)
	@$(RM) target make.out

