# st -- hash table package
#---------------------------------------------------------------------------

LIB_DIR = ../../lib

P	= st
PSRC	= st.c
POBJ	= st.o
PHDR	= st.h
MISC	= st.doc Makefile st_bench1.c

INCLUDE	= -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a
