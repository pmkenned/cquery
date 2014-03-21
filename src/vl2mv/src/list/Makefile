#/*
# * Revision Control Information
# *
# * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/Makefile,v $
# * $Author: sis $
# * $Revision: 1.2 $
# * $Date: 1992/05/06 18:55:32 $
# *
# */
# list -- generic list package from David Harrison
#----------------------------------------------------------------------

LIB_DIR = ../../lib

P	= list
PSRC	= list.c
POBJ	= list.o
PHDR	= list.h
MISC	= list.doc Makefile

INCLUDE = -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a

clean:
	rm -f $(TARGET) *.a *.o \
