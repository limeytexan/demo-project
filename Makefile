PREFIX ?= /usr/local
LIBDIR = $(PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include
PYTHONDIR = $(PREFIX)/lib/python3.8/site-packages
BINDIR = $(PREFIX)/bin

all: libflox.so main flox_hello_world_py.so

libflox.so: src/flox_hello_world.o
	@echo Delaying build of $@ by 2 seconds && sleep 2
	$(CC) -shared -o $@ $^

src/flox_hello_world.o: src/flox_hello_world.c
	@echo Delaying build of $@ by 1 second && sleep 1
	$(CC) -fPIC -c -o $@ $^

main: src/main.o libflox.so
	@echo Delaying build of $@ by 4 seconds && sleep 4
	$(CC) -o $@ $< -L. -lflox

src/main.o: src/main.c src/flox_hello_world.h
	@echo Delaying build of $@ by 3 seconds && sleep 3
	$(CC) -c -o $@ $<

flox_hello_world_py.so: src/flox_hello_world_py.o libflox.so
	@echo Delaying build of $@ by 6 seconds && sleep 6
	$(CC) -shared -o $@ $^ $(shell python3-config --includes) -L. -lflox

src/flox_hello_world_py.o: src/flox_hello_world_py.c
	@echo Delaying build of $@ by 5 seconds && sleep 5
	$(CC) -fPIC -c -o $@ $< $(shell python3-config --includes)

install: all
	mkdir -p $(LIBDIR) $(INCLUDEDIR) $(PYTHONDIR) $(BINDIR)
	cp libflox.so $(LIBDIR)
	cp src/flox_hello_world.h $(INCLUDEDIR)
	cp flox_hello_world_py.so $(PYTHONDIR)
	cp main $(BINDIR)
	cp python/test_flox_hello_world.py $(BINDIR)
	sed -i 's%/usr/local%$(PREFIX)%g' $(BINDIR)/test_flox_hello_world.py

clean:
	rm -f src/*.o libflox.so main flox_hello_world_py.so

.PHONY: all install clean
