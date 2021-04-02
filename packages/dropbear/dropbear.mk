DROPBEAR_VERSION = 2016.74
DROPBEAR_SOURCE = $(DROPBEAR_NAME)-$(DROPBEAR_VERSION)
DROPBEAR_ARCHIVE = $(DROPBEAR_SOURCE).tar.bz2
DROPBEAR_PATCH = dropbear-2016.74-enable-pam.patch
DROPBEAR_DEPENDENCIES = zlib linux-pam

DROPBEAR_CONFIGURE_OPTS = \
	--enable-pam \
	--disable-lastlog

DROPBEAR_MAKE_OPTS = \
	MULTI=1 \
	SCPPROGRESS=1 \
	PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

define DROPBEAR_INSTALL_INIT_NG
	$(INSTALL) -m 0644 -D packages/dropbear/dropbear.i $(TARGET_DIR)/etc/initng/daemon/dropbear.i
	$(SED) -i -e '$$a\' -e 'daemon/dropbear' -e "/daemon\/dropbear/d" $(TARGET_DIR)/etc/initng/runlevel/default.runlevel
endef

define DROPBEAR_INSTALL_PAM
	$(INSTALL) -m 0644 -D packages/dropbear/dropbear.pam $(TARGET_DIR)/etc/pam.d/sshd
endef

define DROPBEAR_INSTALL_KEY
	$(INSTALL) -m 0600 -D packages/dropbear/dropbear_rsa_host_key $(TARGET_DIR)/etc/dropbear/dropbear_rsa_host_key
	$(INSTALL) -m 0600 -D packages/dropbear/dropbear_dss_host_key $(TARGET_DIR)/etc/dropbear/dropbear_dss_host_key
	$(INSTALL) -m 0600 -D packages/dropbear/dropbear_ecdsa_host_key $(TARGET_DIR)/etc/dropbear/dropbear_ecdsa_host_key
endef

define DROPBEAR_INSTALL_TARGET_CMD
    $(MAKE) -C $(DROPBEAR_DIR) $(DROPBEAR_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
    $(LN) -snf ../bin/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbear
    $(LN) -snf dropbearmulti $(TARGET_DIR)/usr/bin/dbclient
    $(LN) -snf dropbearmulti $(TARGET_DIR)/usr/bin/dropbearconvert
    $(LN) -snf dropbearmulti $(TARGET_DIR)/usr/bin/dropbearkey
    $(LN) -snf dropbearmulti $(TARGET_DIR)/usr/bin/scp
    $(LN) -snf dropbearmulti $(TARGET_DIR)/usr/bin/ssh
	$(DROPBEAR_INSTALL_INIT_NG)
	$(DROPBEAR_INSTALL_PAM)
	$(DROPBEAR_INSTALL_KEY)
endef

$(eval $(add-autotools-package))
