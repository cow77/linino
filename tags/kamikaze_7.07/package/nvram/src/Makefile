# $Id$

LIBSHARED_OBJS := shutils.o wl.o linux_timer.o
LIBNVRAM_OBJS := nvram.o

all: libshared.so libnvram.so nvram

%.o: %.c
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -c -I. -Iinclude -o $@ $^

libshared.so: $(LIBSHARED_OBJS)
	$(CC) -shared -o $@ $^

libnvram.so: $(LIBNVRAM_OBJS)
	$(CC) -shared -o $@ $^

nvram: main.o
	$(CC) -o $@ $^ -L. -lnvram

clean:
	rm -f *.o *.so nvram
