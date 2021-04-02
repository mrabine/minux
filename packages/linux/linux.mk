LINUX_VERSION = 3.18.11
LINUX_SOURCE = $(LINUX_NAME)-$(LINUX_VERSION)
LINUX_ARCHIVE = $(LINUX_SOURCE).tar.xz
LINUX_PATCH = 
LINUX_DEPENDENCIES = host-uboot

LINUX_CONFIG_NAME = minux

LINUX_MAKE_OPTS = \
	$(TARGET_MAKE_ENV) \
	HOSTCC="$(HOST_CC)" \
	INSTALL_MOD_PATH=$(TARGET_DIR)

LINUX_VERSION_PROBED = $(shell $(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) --no-print-directory -s kernelrelease)

define LINUX_CONFIGURE_CMD
	$(CP) -fu $(LINUX_PKGDIR)$(LINUX_CONFIG_NAME)_defconfig $(LINUX_DIR)/arch/$(TARGET_ARCH)/configs/
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) $(LINUX_CONFIG_NAME)_defconfig
endef

define LINUX_BUILD_CMD
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) zImage
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) modules
endef

define LINUX_INSTALL_TARGET_CMD
	$(INSTALL) -m 0644 -D $(LINUX_DIR)/arch/$(TARGET_ARCH)/boot/zImage $(IMAGES_DIR)/zImage
	$(MKIMAGE) -A $(TARGET_ARCH) -C none -O linux -T kernel -d $(IMAGES_DIR)/zImage -a 0x00010000 -e 0x00010000 $(IMAGES_DIR)/uImage
	$(MAKE1) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) modules_install
	$(RM) -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/source
	$(RM) -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/build
endef

define LINUX_CLEAN_CMD
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) clean
endef

define LINUX_DISTCLEAN_CMD
	$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_OPTS) distclean
endef

$(eval $(add-generic-package))

linux-menuconfig linux-xconfig: linux-configure
	$(AT)$(call message,"Open linux config")
	$(MAKE1) -C $(BUILD_DIR)/$(LINUX_SOURCE) $(LINUX_MAKE_OPTS) $(subst linux-,,$@)
	$(AT)$(RM) -f $(BUILD_DIR)/.linux/stamp_built $(BUILD_DIR)/.linux/stamp_target_installed

linux-saveconfig: linux-configure $(BUILD_DIR)/$(LINUX_SOURCE)/.config
	$(AT)$(call message,"Save linux config")
	$(CP) -fu $(BUILD_DIR)/$(LINUX_SOURCE)/.config $(PACKAGES_DIR)/linux/$(LINUX_CONFIG_NAME)_defconfig
