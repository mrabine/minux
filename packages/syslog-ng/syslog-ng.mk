SYSLOG_NG_VERSION = 3.8.1
SYSLOG_NG_SOURCE = $(SYSLOG_NG_NAME)-$(SYSLOG_NG_VERSION)
SYSLOG_NG_ARCHIVE = $(SYSLOG_NG_SOURCE).tar.gz
SYSLOG_NG_PATCH = syslog-ng-3.8.1-enable-flush-timeout.patch
SYSLOG_NG_DEPENDENCIES = host-pkgconf eventlog libglib2 openssl pcre

SYSLOG_NG_INSTALL_STAGING = YES

SYSLOG_NG_CONFIGURE_ARGS = \
	LIBS=-lrt

SYSLOG_NG_CONFIGURE_OPTS = \
	--disable-sql \
	--disable-linux-caps \
	--disable-mongodb \
	--disable-legacy-mongodb-options \
	--with-mongoc=no \
	--disable-json \
	--with-jsonc=no \
	--disable-amqp \
	--disable-stomp \
	--disable-smtp \
	--disable-http \
	--disable-redis \
	--disable-systemd \
	--disable-geoip \
	--disable-riemann \
	--disable-python \
	--without-python \
	--disable-java \
	--disable-java-modules \
	--disable-native

define SYSLOG_NG_FIXUP_CONF
	$(TARGET_MAKE_ARGS) $(MAKE) -C $(SYSLOG_NG_DIR) DESTDIR=$(TARGET_DIR) scl-uninstall-local
	$(INSTALL) -m 0644 -D packages/syslog-ng/syslog-ng.conf $(TARGET_DIR)/etc/syslog-ng.conf
endef

define SYSLOG_NG_INSTALL_INIT_NG
	$(INSTALL) -m 0644 -D packages/syslog-ng/syslog-ng.i $(TARGET_DIR)/etc/initng/daemon/syslog-ng.i
	$(SED) -i -e '$$a\' -e 'daemon/syslog-ng' -e "/daemon\/syslog-ng/d" $(TARGET_DIR)/etc/initng/runlevel/default.runlevel
endef

define SYSLOG_NG_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(MAKE) -C $(SYSLOG_NG_DIR) $(SYSLOG_NG_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(SYSLOG_NG_FIXUP_CONF)
	$(SYSLOG_NG_INSTALL_INIT_NG)
endef

$(eval $(add-autotools-package))
