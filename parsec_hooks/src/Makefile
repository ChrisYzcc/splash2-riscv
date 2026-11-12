# PARSEC hooks library (BSD license; see LICENSE and COPYRIGHT).
# Copyright (C) 2006-2009 by Princeton University
# Author: Christian Bienia

PREFIX = ${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/${USAGE}
TARGET = libhooks.a
OBJS = hooks.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) rcs $@ $(OBJS)
	$(RANLIB) $@

hooks.o: hooks.c config.h include/hooks.h
	$(CC) $(CFLAGS) -Wall -D_GNU_SOURCE -D_XOPEN_SOURCE=600 -c $< -o $@

install: all
	mkdir -p $(PREFIX)/lib $(PREFIX)/include
	cp -f $(TARGET) $(PREFIX)/lib/
	cp -f include/*.h $(PREFIX)/include/

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all install clean
