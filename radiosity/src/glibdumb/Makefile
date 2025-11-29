# 
#  Device independent graphics package GLIB.
#  NULL graphic device version
#

OBJS   = glib.o
TARGET = glib.a
CCOPT  = -O 
CFLAGS = $(CCOPT) $(CCDEFS)
LDFLAGS = -lm


all:	$(TARGET)

clean:
	touch dummy~
	rm -f core *.o *~ $(TARGET)

lint:
	lint $(INCLUDE_DIRS) $(SRCS)


$(TARGET): glib.o
	$(AR) crv $(TARGET) glib.o

testlib:
	$(CC) -O -o testlib testlib.c $(TARGET) $(LDFLAGS)

