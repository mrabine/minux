ROOTFS_EXT2_DEPENDENCIES = host-genext2fs

# calculate needed inodes
ROOTFS_EXT2_INODES = $(shell expr $(shell find $(TARGET_DIR) | wc -l) + 500)

# calculate needed blocks
ROOTFS_EXT2_SIZE = $(shell du -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//")
ROOTFS_EXT2_BLOCKS = $(shell expr 500 + \( $(ROOTFS_EXT2_SIZE) + $(ROOTFS_EXT2_INODES) / 8 \) \* 11 / 10)

define ROOTFS_EXT2_CMD
	$(GENEXT2FS) -U -N $(ROOTFS_EXT2_INODES) -b $(ROOTFS_EXT2_BLOCKS) -m 0 -d $(TARGET_DIR) $@
endef
	
$(eval $(call add-rootfs-targets,ext2))
