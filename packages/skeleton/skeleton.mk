SKELETON_ADD_TOOLCHAIN_DEPENDENCY = NO

define SKELETON_INSTALL_TARGET_CMD
	$(RSYNC) -a -u --ignore-times --exclude .svn --exclude .empty --exclude '*~' \
		--chmod=u=rwX,go=rX system/skeleton/ $(TARGET_DIR)/
endef

$(eval $(add-generic-package))
