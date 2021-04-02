#
#
# Created on: 12 nov. 2012
#     Author: mrabine
#

FAKEROOT_SCRIPT = $(BUILD_DIR)/_fakeroot.fs
DEVICE_TABLE = $(BUILD_DIR)/_device_table.txt

################################################################################
# rootfs-targets -- generates make targets for rootfs
#
#  argument 1 lowercase rootfs type
#  argument 2 uppercase rootfs type
################################################################################
define rootfs-targets
$(debug-enter)

ROOTFS_$(2)_DEPENDENCIES += host-fakeroot host-makedevs \
	$$(if $$(PACKAGES_USERS),host-mkusers)

$$(IMAGES_DIR)/rootfs.$(1): finalize $$(ROOTFS_$(2)_DEPENDENCIES)
	$(AT)$(call message,"Generating $(1) root filesystem image")
	$(RM) -f $$(FAKEROOT_SCRIPT) $$(DEVICE_TABLE)
	$(ECHO) "chown -h -R 0:0 $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
	$(CAT) fs/device_table.txt > $$(DEVICE_TABLE)
	$(ECHO) "$$(MAKEDEVS) -d $$(DEVICE_TABLE) $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
	printf '$$(subst $$(endl),\n,$$(PACKAGES_USERS))' >> $$(FAKEROOT_SCRIPT)
	$(ECHO) "$$(ROOTFS_$(2)_CMD)" >> $$(FAKEROOT_SCRIPT)
	$(CHMOD) a+x $$(FAKEROOT_SCRIPT)
	PATH="$$(HOST_PATH)" $$(FAKEROOT) -- $$(FAKEROOT_SCRIPT)
	$(RM) -f $$(FAKEROOT_SCRIPT) $$(DEVICE_TABLE)

rootfs-$(1): $$(IMAGES_DIR)/rootfs.$(1)

ROOTFS_TARGETS += rootfs-$(1)

$(debug-leave)
endef # rootfs-targets

################################################################################
# add-rootfs-targets -- make targets generator macro for file system
################################################################################
define add-rootfs-targets
$(call rootfs-targets,$(1),$(call uppercase,$(1)))
endef

include fs/*/*.mk
