PREFIX ?= /usr/local
LIBDIR = $(PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include
PYTHONDIR = $(PREFIX)/lib/python3.8/site-packages
BINDIR = $(PREFIX)/bin

all: libflox.so main flox_hello_world_py.so

libflox.so: src/flox_hello_world.o
	@s=2 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -shared -o $@ $^

src/flox_hello_world.o: src/flox_hello_world.c
	@s=1 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -fPIC -c -o $@ $^

main: src/main.o libflox.so
	@s=4 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -o $@ $< -L. -lflox

src/main.o: src/main.c src/flox_hello_world.h
	@s=3 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -c -o $@ $<

flox_hello_world_py.so: src/flox_hello_world_py.o libflox.so
	@s=6 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -shared -o $@ $^ $(shell python3-config --includes) -L. -lflox

src/flox_hello_world_py.o: src/flox_hello_world_py.c
	@s=5 && echo Delaying build of $@ by $$s seconds && sleep $$s
	$(CC) -fPIC -c -o $@ $< $(shell python3-config --includes)

# Installation targets

$(LIBDIR)/libflox.so: libflox.so FORCE
	mkdir -p $(@D)
	-rm -f $@
	cp $< $@

$(INCLUDEDIR)/flox_hello_world.h: src/flox_hello_world.h
	mkdir -p $(@D)
	-rm -f $@
	cp $< $@

$(PYTHONDIR)/flox_hello_world_py.so: src/flox_hello_world_py.o $(LIBDIR)/libflox.so
	mkdir -p $(@D)
	-rm -f $@
	$(CC) -shared -o $@ $^ $(shell python3-config --includes) -L$(LIBDIR) -lflox

$(BINDIR)/main: src/main.o $(LIBDIR)/libflox.so
	mkdir -p $(@D)
	-rm -f $@
	$(CC) -o $@ $< -L$(LIBDIR) -lflox

$(BINDIR)/test_flox_hello_world.py: python/test_flox_hello_world.py
	mkdir -p $(@D)
	-rm -f $@
	cp $< $@
	sed -i 's%/usr/local%$(PREFIX)%g' $@

install-include: $(INCLUDEDIR)/flox_hello_world.h
install-lib: $(LIBDIR)/libflox.so
install-bin: $(BINDIR)/main
install-pylib: $(PYTHONDIR)/flox_hello_world_py.so
install-pybin: $(BINDIR)/test_flox_hello_world.py
install: install-include install-lib install-pylib install-bin install-pybin

clean:
	rm -f src/*.o libflox.so main flox_hello_world_py.so \
	  result-* *.targets.png *.targets.dot \
	  headlines src/headlines.json

FORCE:

.PHONY: all install install-include install-lib install-pylib install-bin install-pybin clean FORCE

# The following targets relate to the "headline" server that reads
# a private API key to connect to a thing.

src/headlines.json: FORCE
	curl -s "https://newsapi.org/v2/top-headlines?country=us&apiKey=$$(cat newsapi.org.api.key)" > $@

$(INCLUDEDIR)/headlines.json: src/headlines.json
	mkdir -p $(@D)
	-rm -f $@
	cp $< $@

headlines: src/headlines.sh src/headlines.json
	cp $< $@
	chmod +x $@

HEADLINESDIR ?= $(INCLUDEDIR)

$(BINDIR)/headlines: src/headlines.sh
	mkdir -p $(@D)
	cp $< $@
	sed -i 's%src/headlines.json%$(HEADLINESDIR)/headlines.json%' $@
	chmod +x $@

install-headlines: $(INCLUDEDIR)/headlines.json $(BINDIR)/headlines
install-headlines-bin: $(BINDIR)/headlines
install-headlines-json: $(INCLUDEDIR)/headlines.json
