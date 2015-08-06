version = $(strip $(shell cat VERSION))
name = fs-uae-plugin-capsimg
deb_version = 0
deb_series = unstable
DESTDIR =
prefix = /usr/local

all:
	cd capsimg && ./configure
	make -C capsimg

install: all
	install -D -m 0644 plugin.ini \
	$(DESTDIR)$(prefix)/lib/fs-uae/plugins/capsimg/plugin.ini
	install -D capsimg/capsimg.so \
	$(DESTDIR)$(prefix)/lib/fs-uae/plugins/capsimg/$(version)/capsimg.so

distdir:
	rm -Rf $(name)-$(version)
	mkdir $(name)-$(version)
	cp Makefile $(name)-$(version)
	cp plugin.ini $(name)-$(version)
	cp README.md $(name)-$(version)
	cp VERSION $(name)-$(version)

	mkdir $(name)-$(version)/debian
	cp debian/fs-uae-plugin-capsimg.install $(name)-$(version)/debian
	mkdir $(name)-$(version)/debian/source
	cp debian/source/format $(name)-$(version)/debian/source
	cp debian/changelog $(name)-$(version)/debian
	cp debian/compat $(name)-$(version)/debian
	cp debian/copyright $(name)-$(version)/debian
	cp debian/control $(name)-$(version)/debian
	cp debian/rules $(name)-$(version)/debian

	cp -a capsimg $(name)-$(version)
	rm -f $(name)-$(version)/capsimg/.gitignore
	rm -Rf $(name)-$(version)/capsimg/.git

dist: distdir
	tar Jcf $(name)-$(version).tar.xz $(name)-$(version)
	rm -Rf $(name)-$(version)

source-deb: distdir
	test -f $(name)_$(version).orig.tar.xz || tar -cJ --strip-components=1 -f $(name)_$(version).orig.tar.xz $(name)-$(version)
	sed -i "s/$(version)-0) unstable/$(version)-$(deb_version)$(deb_series)) $(deb_series)/g" $(name)-$(version)/debian/changelog
	cd $(name)-$(version) && dpkg-buildpackage -S -us -uc

clean:
	# cd capsimg && ./configure
	# make -C capsimg clean
