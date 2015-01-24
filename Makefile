.SUFFIXES: .3 .3.html

CFLAGS		= -g -W -Wall -Wstrict-prototypes -Wno-unused-parameter -Wwrite-strings
CPPFLAGS	= `pkg-config --cflags --silence-errors cairo || echo '-I/usr/X11/include/cairo'`
VERSION		= 0.1.7
LDADD		= `pkg-config --libs --silence-errors cairo || echo '-L/usr/X11/lib -lcairo'`
#If you're on GNU/Linux, you'll need to uncomment this.
#LDADD		+= -lbsd
VERSIONS	= version_0_1_4.xml \
		  version_0_1_5.xml \
		  version_0_1_6.xml \
		  version_0_1_7.xml
EXAMPLES	= example0 \
		  example1 \
		  example2 \
		  example3 \
		  example4 \
		  example5 \
		  example6 \
		  example7 \
		  example8
PNGS		= example0.png \
		  example1.png \
		  example2.png \
		  example3.png \
		  example4.png \
		  example5.png \
		  example6.png \
		  example7.png \
		  example8.png
SRCS		= Makefile \
		  compat.post.h \
		  compat.pre.h \
		  compat.sh \
		  extern.h \
		  kplot.h \
		  array.c \
		  border.c \
		  bucket.c \
		  buffer.c \
		  draw.c \
		  example0.c \
		  example1.c \
		  example2.c \
		  example3.c \
		  example4.c \
		  example5.c \
		  example6.c \
		  example7.c \
		  example8.c \
		  grid.c \
		  hist.c \
		  label.c \
		  kdata.c \
		  kplot.c \
		  margin.c \
		  mean.c \
		  plotctx.c \
		  reallocarray.c \
		  stddev.c \
		  test-reallocarray.c \
		  tic.c \
		  vector.c
OBJS		= array.o \
		  border.o \
		  bucket.o \
		  buffer.o \
		  draw.o \
		  grid.o \
		  hist.o \
		  label.o \
		  kdata.o \
		  kplot.o \
		  margin.o \
		  mean.o \
		  plotctx.o \
		  reallocarray.o \
		  stddev.o \
		  tic.o \
		  vector.o
PREFIX		= /usr/local
HTMLS		= index.html \
		  man/kdata_array_alloc.3.html \
		  man/kdata_array_fill.3.html \
		  man/kdata_bucket_alloc.3.html \
		  man/kdata_bucket_add.3.html \
		  man/kdata_buffer_alloc.3.html \
		  man/kdata_buffer_copy.3.html \
		  man/kdata_destroy.3.html \
		  man/kdata_hist_alloc.3.html \
		  man/kdata_hist_add.3.html \
		  man/kdata_mean_alloc.3.html \
		  man/kdata_mean_attach.3.html \
		  man/kdata_stddev_alloc.3.html \
		  man/kdata_stddev_attach.3.html \
		  man/kdata_vector_append.3.html \
		  man/kdata_vector_alloc.3.html \
		  man/kdatacfg_defaults.3.html \
		  man/kplot.3.html \
		  man/kplot_alloc.3.html \
		  man/kplot_attach_data.3.html \
		  man/kplot_attach_datas.3.html \
		  man/kplot_attach_smooth.3.html \
		  man/kplot_draw.3.html \
		  man/kplot_free.3.html \
	 	  man/kplotcfg_defaults.3.html
MANS		= man/kdata_array_alloc.3 \
		  man/kdata_array_fill.3 \
		  man/kdata_bucket_alloc.3 \
		  man/kdata_bucket_add.3 \
		  man/kdata_buffer_alloc.3 \
		  man/kdata_buffer_copy.3 \
		  man/kdata_destroy.3 \
		  man/kdata_hist_alloc.3 \
		  man/kdata_hist_add.3 \
		  man/kdata_mean_alloc.3 \
		  man/kdata_mean_attach.3 \
		  man/kdata_stddev_alloc.3 \
		  man/kdata_stddev_attach.3 \
		  man/kdata_vector_append.3 \
		  man/kdata_vector_alloc.3 \
		  man/kdatacfg_defaults.3 \
		  man/kplot.3 \
		  man/kplot_alloc.3 \
		  man/kplot_attach_data.3 \
		  man/kplot_attach_datas.3 \
		  man/kplot_attach_smooth.3 \
		  man/kplot_draw.3 \
		  man/kplot_free.3 \
	 	  man/kplotcfg_defaults.3

all: libkplot.a $(EXAMPLES)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	mkdir -p $(DESTDIR)$(PREFIX)/include
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man3
	install -m 0444 libkplot.a $(DESTDIR)$(PREFIX)/lib
	install -m 0444 kplot.h $(DESTDIR)$(PREFIX)/include
	install -m 0444 $(MANS) $(DESTDIR)$(PREFIX)/man/man3

www: $(HTMLS) $(PNGS) kplot-$(VERSION).tgz kplot-$(VERSION).tgz.sha512

installwww: www
	mkdir -p $(PREFIX)
	mkdir -p $(PREFIX)/snapshots
	install -m 0444 $(PNGS) $(HTMLS) index.css $(PREFIX)
	install -m 0444 kplot-$(VERSION).tgz $(PREFIX)/snapshots/kplot.tgz
	install -m 0444 kplot-$(VERSION).tgz.sha512 $(PREFIX)/snapshots/kplot.tgz.sha512
	install -m 0444 kplot-$(VERSION).tgz $(PREFIX)/snapshots
	install -m 0444 kplot-$(VERSION).tgz.sha512 $(PREFIX)/snapshots

$(EXAMPLES): libkplot.a

example0: example0.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -lm -o $@ $< libkplot.a

example1: example1.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example2: example2.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example3: example3.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example4: example4.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example5: example5.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example6: example6.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example7: example7.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example8: example8.c libkplot.a
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDADD) -o $@ $< libkplot.a

example0.png: example0
	./example0

example1.png: example1
	./example1

example2.png: example2
	./example2

example3.png: example3
	./example3

example4.png: example4
	./example4

example5.png: example5
	./example5

example6.png: example6
	./example6

example7.png: example7
	./example7

example8.png: example8
	./example8

libkplot.a: $(OBJS)
	$(AR) rs $@ $(OBJS)

$(OBJS): kplot.h compat.h extern.h

compat.h: compat.pre.h compat.post.h
	( cat compat.pre.h ; \
	  CC="$(CC)" CFLAGS="$(CFLAGS)" sh compat.sh reallocarray ; \
	  cat compat.post.h ; ) >$@

.3.3.html:
	mandoc -Thtml -Oman=%N.%S.html $< >$@

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

index.html: index.xml $(VERSIONS)
	sblg -t index.xml -o- $(VERSIONS) | sed "s!@VERSION@!$(VERSION)!g" >$@

kplot-$(VERSION).tgz.sha512: kplot-$(VERSION).tgz
	openssl dgst -sha512 kplot-$(VERSION).tgz >$@

kplot-$(VERSION).tgz:
	mkdir -p .dist/kplot-$(VERSION)
	mkdir -p .dist/kplot-$(VERSION)/man
	cp $(SRCS) .dist/kplot-$(VERSION)
	cp $(MANS) .dist/kplot-$(VERSION)/man
	(cd .dist && tar zcf ../$@ kplot-$(VERSION))
	rm -rf .dist

clean:
	rm -f libkplot.a compat.h test-reallocarray 
	rm -f $(EXAMPLES)
	rm -rf *.dSYM
	rm -f $(OBJS)
	rm -f $(HTMLS) $(PNGS)
	rm -f kplot-$(VERSION).tgz kplot-$(VERSION).tgz.sha512
