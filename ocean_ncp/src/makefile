TARGET = ocean_ncp
OBJS = main.o jacobcalc.o laplacalc.o \
	slave1.o slave2.o multi.o
CFLAGS += -O2 -w  
LDFLAGS += -lpthread -lm
MACROS = ../../../null_macros/c.m4.null.pthread

x = *

PREFIX=${SPLASH2DIR}/ocean_ncp/build/${PLATFORM}/${USAGE}
MACROS = ${SPLASH2DIR}/null_macros/c.m4.null.pthread

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LDFLAGS)

install:
	mkdir -p $(PREFIX)/bin
	cp -f $(TARGET) $(PREFIX)/bin/$(TARGET)

clean:
	rm -rf *.c *.h *.o $(TARGET)

.SUFFIXES:
.SUFFIXES:	.o .c .C .h .H

.H.h: 
	m4 ${MACROS} $*.H > $*.h

.C.c: 
	m4 $(MACROS) $*.C > $*.c

.c.o: 
	$(CC) -c $(CFLAGS) $*.c

.C.o: 
	m4 $(MACROS) $*.C > $*.c
	$(CC) -c $(CFLAGS) $*.c

decs.h: decs.H
jacobcalc.c: decs.h
main.c: decs.h
slave1.c: decs.h
laplacalc.c: decs.h
multi.c : decs.h
slave2.c: decs.h

