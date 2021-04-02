BUSYBOX_VERSION = 1.24.2
BUSYBOX_SOURCE = $(BUSYBOX_NAME)-$(BUSYBOX_VERSION)
BUSYBOX_ARCHIVE = $(BUSYBOX_SOURCE).tar.bz2
BUSYBOX_PATCH = 
BUSYBOX_DEPENDENCIES = linux-pam

BUSYBOX_CONFIG_NAME = minux

BUSYBOX_MAKE_OPTS = \
	$(TARGET_MAKE_ENV) \
	EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
	EXTRA_LDFLAGS="$(TARGET_LDFLAGS)"

define BUSYBOX_INSTALL_CRON
	$(INSTALL) -m 0644 -D packages/busybox/crond.i $(TARGET_DIR)/etc/initng/daemon/crond.i
	$(SED) -i -e '$$a\' -e 'daemon/crond' -e "/daemon\/crond/d" $(TARGET_DIR)/etc/initng/runlevel/default.runlevel
endef

define BUSYBOX_INSTALL_WATCHDOG
	$(INSTALL) -m 0644 -D packages/busybox/watchdog.i $(TARGET_DIR)/etc/initng/daemon/watchdog.i
	$(SED) -i -e '$$a\' -e 'daemon/watchdog' -e "/daemon\/watchdog/d" $(TARGET_DIR)/etc/initng/runlevel/default.runlevel
endef

define BUSYBOX_INSTALL_MDEV
	$(INSTALL) -m 0644 -D packages/busybox/mdev.i $(TARGET_DIR)/etc/initng/system/mdev.i
	$(SED) -i -e '$$a\' -e 'system/mdev' -e "/system\/mdev/d" $(TARGET_DIR)/etc/initng/runlevel/system.virtual
	$(INSTALL) -m 0644 -D packages/busybox/mdev.conf $(TARGET_DIR)/etc/mdev.conf
endef

define BUSYBOX_INSTALL_UDHCPC_SCRIPT
	$(INSTALL) -m 0755 -D packages/busybox/udhcpc.script $(TARGET_DIR)/usr/share/udhcpc/default.script
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/share/udhcpc/default.script.d
endef

define BUSYBOX_INSTALL_LOGIN
	$(INSTALL) -m 0644 -D packages/busybox/login.pam $(TARGET_DIR)/etc/pam.d/login
endef

define BUSYBOX_CONFIGURE_CMD
	$(CP) -fu $(BUSYBOX_PKGDIR)$(BUSYBOX_CONFIG_NAME)_defconfig $(BUSYBOX_DIR)/configs/
	$(MAKE) -C $(BUSYBOX_DIR) $(BUSYBOX_MAKE_OPTS) $(BUSYBOX_CONFIG_NAME)_defconfig
endef

define BUSYBOX_BUILD_CMD
	$(MAKE) -C $(BUSYBOX_DIR) $(BUSYBOX_MAKE_OPTS)
endef

define BUSYBOX_INSTALL_TARGET_CMD
	$(MAKE) -C $(BUSYBOX_DIR) $(BUSYBOX_MAKE_OPTS) CONFIG_PREFIX=$(TARGET_DIR) install
	$(BUSYBOX_INSTALL_CRON)
	$(BUSYBOX_INSTALL_WATCHDOG)
	$(BUSYBOX_INSTALL_MDEV)
	$(BUSYBOX_INSTALL_UDHCPC_SCRIPT)
	$(BUSYBOX_INSTALL_LOGIN)
endef
	
define BUSYBOX_CLEAN_CMD
	$(MAKE) -C $(BUSYBOX_DIR) $(BUSYBOX_MAKE_OPTS) clean
endef

define BUSYBOX_DISTCLEAN_CMD
	$(MAKE) -C $(BUSYBOX_DIR) $(BUSYBOX_MAKE_OPTS) distclean
endef

$(eval $(add-generic-package))

busybox-menuconfig : busybox-configure
	$(AT)$(call message,"Open busybox config")
	$(MAKE1) -C $(BUILD_DIR)/$(BUSYBOX_SOURCE) $(BUSYBOX_MAKE_OPTS) $(subst busybox-,,$@)
	$(AT)$(RM) -f $(BUILD_DIR)/.busybox/stamp_built $(BUILD_DIR)/.busybox/stamp_target_installed

busybox-saveconfig: busybox-configure $(BUILD_DIR)/$(BUSYBOX_SOURCE)/.config
	$(AT)$(call message,"Save busybox config")
	$(CP) -fu $(BUILD_DIR)/$(BUSYBOX_SOURCE)/.config $(PACKAGES_DIR)/busybox/$(BUSYBOX_CONFIG_NAME)_defconfig
