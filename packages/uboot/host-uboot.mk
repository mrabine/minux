HOST_UBOOT_VERSION = 2014.07
HOST_UBOOT_SOURCE = host-u-boot-$(HOST_UBOOT_VERSION)
HOST_UBOOT_ARCHIVE = u-boot-$(HOST_UBOOT_VERSION).tar.bz2
HOST_UBOOT_PATCH =
HOST_UBOOT_DEPENDENCIES =

HOST_UBOOT_CONFIG_NAME = vexpress_ca9x4

define HOST_UBOOT_CONFIGURE_CMD
	$(MAKE) -C $(HOST_UBOOT_DIR) $(TARGET_MAKE_ENV) $(HOST_UBOOT_CONFIG_NAME)_config
endef

define HOST_UBOOT_BUILD_CMD
	$(MAKE) -C $(HOST_UBOOT_DIR) $(TARGET_MAKE_ENV) HOSTCC="$(HOST_CC)" tools-only
endef

define HOST_UBOOT_INSTALL_TARGET_CMD
	$(INSTALL) -m 0755 -D $(HOST_UBOOT_DIR)/tools/mkimage $(HOST_DIR)/usr/bin/mkimage
	$(INSTALL) -m 0755 -D $(HOST_UBOOT_DIR)/tools/mkenvimage $(HOST_DIR)/usr/bin/mkenvimage
endef

define HOST_UBOOT_CLEAN_CMD
	$(MAKE) -C $(HOST_UBOOT_DIR) $(TARGET_MAKE_ENV) clean
endef

define HOST_UBOOT_DISTCLEAN_CMD
	$(MAKE) -C $(HOST_UBOOT_DIR) $(TARGET_MAKE_ENV) distclean
endef

$(eval $(add-host-generic-package))

MKIMAGE = $(HOST_DIR)/usr/bin/mkimage
MKENVIMAGE = $(HOST_DIR)/usr/bin/mkenvimage
