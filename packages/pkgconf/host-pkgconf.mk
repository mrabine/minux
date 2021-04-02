HOST_PKGCONF_VERSION = 0.9.9
HOST_PKGCONF_SOURCE = host-pkgconf-$(HOST_PKGCONF_VERSION)
HOST_PKGCONF_ARCHIVE = pkgconf-$(HOST_PKGCONF_VERSION).tar.bz2
HOST_PKGCONF_PATCH = 
HOST_PKGCONF_DEPENDENCIES = 

define HOST_PKGCONF_INSTALL_TARGET_CMD
	$(HOST_MAKE_ARGS) $(HOST_PKGCONF_MAKE) -C $(HOST_PKGCONF_DIR) install
	$(INSTALL) -m 0755 -D $(HOST_PKGCONF_PKGDIR)pkg-config.in $(HOST_DIR)/usr/bin/pkg-config
	$(SED) -i -e 's,@PKG_CONFIG_LIBDIR@,$(STAGING_DIR)/usr/lib/pkgconfig:$(STAGING_DIR)/usr/share/pkgconfig,' \
		-e 's,@PKG_CONFIG_SYSROOT_DIR@,$(STAGING_DIR),' $(HOST_DIR)/usr/bin/pkg-config
endef

define HOST_PKGCONF_DISTCLEAN_CMD
	$(HOST_PKGCONF_CLEAN_CMD)
endef

$(eval $(add-host-autotools-package))
