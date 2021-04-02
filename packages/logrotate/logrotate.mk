LOGROTATE_VERSION = 3.10.0
LOGROTATE_SOURCE = $(LOGROTATE_NAME)-$(LOGROTATE_VERSION)
LOGROTATE_ARCHIVE = $(LOGROTATE_SOURCE).tar.xz
LOGROTATE_PATCH = 
LOGROTATE_DEPENDENCIES = host-pkgconf popt

LOGROTATE_CONFIGURE_OPTS = \
	--without-selinux \
	--without-acl

define LOGROTATE_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(MAKE) -C $(LOGROTATE_DIR) $(LOGROTATE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -m 0644 -D packages/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf
	$(INSTALL) -m 0644 -D packages/logrotate/crontab $(TARGET_DIR)/var/spool/cron/crontabs/root
endef

$(eval $(add-autotools-package))
