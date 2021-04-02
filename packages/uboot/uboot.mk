UBOOT_VERSION = 2014.07
UBOOT_SOURCE = u-boot-$(UBOOT_VERSION)
UBOOT_ARCHIVE = $(UBOOT_SOURCE).tar.bz2
UBOOT_PATCH =
UBOOT_DEPENDENCIES =

UBOOT_CONFIG_NAME = vexpress_ca9x4

define UBOOT_CONFIGURE_CMD
	$(MAKE) -C $(UBOOT_DIR) $(TARGET_MAKE_ENV) $(UBOOT_CONFIG_NAME)_config
endef

define UBOOT_BUILD_CMD
	$(MAKE) -C $(UBOOT_DIR) $(TARGET_MAKE_ENV) u-boot.bin
	$(MAKE) -C $(UBOOT_DIR) $(TARGET_MAKE_ENV) env no-dot-config-targets=env
endef

define UBOOT_INSTALL_TARGET_CMD
	$(INSTALL) -m 0755 -D $(UBOOT_DIR)/u-boot.bin $(IMAGES_DIR)/u-boot.bin
	$(INSTALL) -m 0755 -D $(UBOOT_DIR)/tools/env/fw_printenv $(TARGET_DIR)/usr/sbin/fw_printenv
	$(LN) -snf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef

define UBOOT_CLEAN_CMD
	$(MAKE) -C $(UBOOT_DIR) $(TARGET_MAKE_ENV) clean
endef

define UBOOT_DISTCLEAN_CMD
	$(MAKE) -C $(UBOOT_DIR) $(TARGET_MAKE_ENV) distclean
endef

$(eval $(add-generic-package))
