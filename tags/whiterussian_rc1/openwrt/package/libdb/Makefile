# $Id$

include $(TOPDIR)/rules.mk

PKG_NAME:=libdb
PKG_VERSION:=4.3.28
PKG_RELEASE:=0
PKG_MD5SUM:=e27759537db6054b31d8cb3e99ba6fbb

PKG_SOURCE_URL:=ftp://ftp.sleepycat.com/releases/ \
	http://downloads.sleepycat.com/
PKG_SOURCE:=db-$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(BUILD_DIR)/db-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(TOPDIR)/package/rules.mk

$(eval $(call PKG_template,LIBDB,libdb,$(PKG_VERSION)-$(PKG_RELEASE),$(ARCH)))

$(PKG_BUILD_DIR)/.configured: $(PKG_BUILD_DIR)/.prepared
	(cd $(PKG_BUILD_DIR)/build_unix ; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="-I$(STAGING_DIR)/usr/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib" \
		../dist/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--program-prefix="" \
		--program-suffix="" \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--datadir=/usr/share \
		--includedir=/usr/include \
		--infodir=/usr/share/info \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--localstatedir=/var \
		--mandir=/usr/share/man \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--enable-shared \
		--enable-static \
		--disable-java \
		--disable-cxx \
		--disable-tcl \
		--disable-rpc \
		--disable-compat185 \
		--disable-debug \
		--disable-statistics \
		--disable-replication \
		--disable-cryptography \
		--enable-smallbuild \
	);
	touch $@

$(PKG_BUILD_DIR)/.built: $(PKG_BUILD_DIR)/.configured
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR)/build_unix \
		DESTDIR="$(PKG_INSTALL_DIR)" install
	touch $@

$(IPKG_LIBDB): $(STAGING_DIR)/usr/lib/libdb.so
	install -m0755 -d $(IDIR_LIBDB)/usr/lib
	cp -fpR $(PKG_INSTALL_DIR)/usr/lib/libdb*.so $(IDIR_LIBDB)/usr/lib/
	$(RSTRIP) $(IDIR_LIBDB)
	$(IPKG_BUILD) $(IDIR_LIBDB) $(PACKAGE_DIR)

$(STAGING_DIR)/usr/lib/libdb.so: $(PKG_BUILD_DIR)/.built
	mkdir -p $(STAGING_DIR)/usr/include
	cp -fpR $(PKG_INSTALL_DIR)/usr/include/db.h $(STAGING_DIR)/usr/include/
	mkdir -p $(STAGING_DIR)/usr/lib
	cp -fpR $(PKG_INSTALL_DIR)/usr/lib/libdb*.{a,so} $(STAGING_DIR)/usr/lib/
	touch $(STAGING_DIR)/usr/lib/libdb.so

install-dev: $(STAGING_DIR)/usr/lib/libdb.so

uninstall-dev:
	rm -rf $(STAGING_DIR)/usr/include/db.h
	rm -rf $(STAGING_DIR)/usr/lib/libdb*.{a,so}

compile: install-dev
clean: uninstall-dev
