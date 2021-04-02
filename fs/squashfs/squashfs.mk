ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs

define ROOTFS_SQUASHFS_CMD
	$(MKSQUASHFS) $(TARGET_DIR) $@ -comp lzo -noappend && \
	$(CHMOD) 0644 $@
endef

$(eval $(call add-rootfs-targets,squashfs))
