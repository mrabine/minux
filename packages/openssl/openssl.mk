OPENSSL_VERSION = 1.0.2h
OPENSSL_SOURCE = $(OPENSSL_NAME)-$(OPENSSL_VERSION)
OPENSSL_ARCHIVE = $(OPENSSL_SOURCE).tar.gz
OPENSSL_PATCH = 
OPENSSL_DEPENDENCIES = zlib

OPENSSL_INSTALL_STAGING = YES

define OPENSSL_CONFIGURE_CMD
	$(CD) $(OPENSSL_DIR); \
	$(TARGET_CONFIGURE_ARGS) \
	./Configure \
		linux-armv4 \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		--libdir=/lib \
		zlib-dynamic \
		no-ssl2 \
		no-ssl3 \
		no-dtls \
		shared
	$(SED) -i -e "s:-march=[-a-z0-9] ::" -e "s:-mcpu=[-a-z0-9] ::g" $(OPENSSL_DIR)/Makefile
	$(SED) -i -e "s:-O[0-9]:-Os $(TARGET_CFLAGS):" $(OPENSSL_DIR)/Makefile
	$(SED) -i -e "s: build_tests::" $(OPENSSL_DIR)/Makefile
endef

define OPENSSL_BUILD_CMD
	$(TARGET_MAKE_ARGS) $(MAKE1) -C $(OPENSSL_DIR) all
endef

define OPENSSL_INSTALL_STAGING_CMD
	$(TARGET_MAKE_ARGS) $(MAKE1) -C $(OPENSSL_DIR) INSTALL_PREFIX=$(STAGING_DIR) install_sw
endef

define OPENSSL_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(MAKE1) -C $(OPENSSL_DIR) INSTALL_PREFIX=$(TARGET_DIR) install_sw
	$(CHMOD) -R +w $(TARGET_DIR)/usr/lib/engines
	for lib in libcrypto libssl; do \
		$(CHMOD) +w $(TARGET_DIR)/usr/lib/$${lib}.so*; \
	done
endef

define OPENSSL_CLEAN_CMD
	$(TARGET_MAKE_ARGS) $(MAKE1) -C $(OPENSSL_DIR) clean
endef

define OPENSSL_DISTCLEAN_CMD
	$(TARGET_MAKE_ARGS) $(MAKE1) -C $(OPENSSL_DIR) dclean
endef

$(eval $(add-generic-package))
