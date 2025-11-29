TARGET = ocean_cp
OBJS = main.o jacobcalc.o jacobcalc2.o laplacalc.o \
	slave1.o slave2.o multi.o linkup.o subblock.o 
LDFLAGS = -lpthread -lm 
MACROS = ../../../null_macros/c.m4.null.pthread
M4 = m4 -s -Ulen -Uindex

x = *

PREFIX=${SPLASH2DIR}/ocean_cp/build/${PLATFORM}
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
	${M4} ${MACROS} $*.H > $*.h

.C.c: 
	${M4} $(MACROS) $*.C > $*.c

.c.o: 
	$(CC) -c $(CFLAGS) $*.c

.C.o: 
	${M4} $(MACROS) $*.C > $*.c
	$(CC) -c $(CFLAGS) $*.c

decs.h: decs.H
jacobcalc.c: decs.h
linkup.c: decs.h
slave1.c: decs.h
jacobcalc2.c: decs.h
main.c: decs.h
slave2.c: decs.h
laplacalc.c: decs.h
multi.c: decs.h
subblock.c: decs.h

