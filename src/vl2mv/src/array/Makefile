# array -- dynamic array package
#---------------------------------------------------------------------------

LIBDIR =../../lib

P	= array
PSRC	= array.c
POBJ	= array.o
PHDR	= array.h
VISC	= array.doc Makefile

SRC	= arr_main.c
OBJ	= arr_main.o
HDR	=

INCLUDE	= -I../../include

CFLAGS	= -g $(INCLUDE)
LDFLAGS	= -g

CC = cc

#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIBDIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a

clean:
	rm -f $(TARGET) *.a *.o \
