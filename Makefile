PREFIX ?= /usr/local
LIBDIR = $(PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include
PYTHONDIR = $(PREFIX)/lib/python3.8/site-packages

all: libflox.so main flox_hello_world_py.so

libflox.so: src/flox_hello_world.o
	$(CC) -shared -o $@ $^

src/flox_hello_world.o: src/flox_hello_world.c
	$(CC) -fPIC -c -o $@ $^

main: src/main.o libflox.so
	$(CC) -o $@ $< -L. -lflox

src/main.o: src/main.c src/flox_hello_world.h
	$(CC) -c -o $@ $<

flox_hello_world_py.so: src/flox_hello_world_py.o libflox.so
	$(CC) -shared -o $@ $^ -I$(shell python3-config --includes) -L. -lflox

src/flox_hello_world_py.o: src/flox_hello_world_py.c
	$(CC) -fPIC -c -o $@ $< -I$(shell python3-config --includes)

install: all
	mkdir -p $(LIBDIR) $(INCLUDEDIR) $(PYTHONDIR)
	cp libflox.so $(LIBDIR)
	cp src/flox_hello_world.h $(INCLUDEDIR)
	cp flox_hello_world_py.so $(PYTHONDIR)

clean:
	rm -f src/*.o libflox.so main flox_hello_world_py.so

.PHONY: all install clean
