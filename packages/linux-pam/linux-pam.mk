LINUX_PAM_VERSION = 1.3.0
LINUX_PAM_SOURCE = Linux-PAM-$(LINUX_PAM_VERSION)
LINUX_PAM_ARCHIVE = $(LINUX_PAM_SOURCE).tar.bz2
LINUX_PAM_URL = http://linux-pam.org/library/$(LINUX_PAM_ARCHIVE)
LINUX_PAM_PATCH = 
LINUX_PAM_DEPENDENCIES = flex

LINUX_PAM_INSTALL_STAGING = YES

LINUX_PAM_CONFIGURE_OPTS = \
	--libdir=/lib \
	--enable-securedir=/lib/security \
	--disable-regenerate-docu \
	--disable-prelude \
	--disable-isadir \
	--disable-nis \
	--disable-db

define LINUX_PAM_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(LINUX_PAM_MAKE) -C $(LINUX_PAM_DIR) DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -m 0644 -D $(LINUX_PAM_PKGDIR)other.pam $(TARGET_DIR)/etc/pam.d/other
endef

$(eval $(add-autotools-package))
