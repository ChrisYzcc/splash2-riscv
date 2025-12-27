TARGET = radix
OBJS = radix.o
CFLAGS += -O2 -w 
LDFLAGS += -lpthread -lm
MACROS = ../../../null_macros/c.m4.null.pthread

x = *

PREFIX=${SPLASH2DIR}/radix/build/${PLATFORM}/${USAGE}
MACROS=${SPLASH2DIR}/null_macros/c.m4.null.pthread

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) -o $(TARGET) $(LDFLAGS)

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

