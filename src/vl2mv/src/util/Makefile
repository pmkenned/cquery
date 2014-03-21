# util -- miscellaneous utility routines
#---------------------------------------------------------------------------

LIB_DIR = ../../lib

P	= util
PSRC	= cpu_time.c cpu_stats.c getopt.c safe_mem.c strsav.c texpand.c \
	  prtime.c pipefork.c saveimage.c pathsearch.c stub.c \
	  restart.c state.c tmpfile.c
POBJ	= cpu_time.o cpu_stats.o getopt.o safe_mem.o strsav.o texpand.o \
	  prtime.o pipefork.o saveimage.o pathsearch.o stub.o \
	  restart.o state.o tmpfile.o
MISC	= util.doc Makefile test-restart.c

INCLUDE	= -I../../include 

CFLAGS	= -O $(INCLUDE)
LDFLAGS	=

CC = cc

.c.o:
	$(CC) -c $(CFLAGS) $*.c
#---------------------------------------------------------------------------

install: lib$(P).a 
	mv -f lib$(P).a $(LIB_DIR)

lib$(P).a: $(POBJ)
	ar cr lib$(P).a $(POBJ)
	ranlib lib$(P).a
