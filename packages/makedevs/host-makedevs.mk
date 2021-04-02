HOST_MAKEDEVS_SOURCE = host-makedevs
HOST_MAKEDEVS_PATCH = 
HOST_MAKEDEVS_DEPENDENCIES = 

define HOST_MAKEDEVS_EXTRACT_CMD
	$(MKDIR) -p $(HOST_MAKEDEVS_DIR)
	$(CP) -dp $(HOST_MAKEDEVS_PKGDIR)makedevs.c $(HOST_MAKEDEVS_DIR)/
endef

define HOST_MAKEDEVS_BUILD_CMD
	$(HOST_CC) $(HOST_MAKEDEVS_DIR)/makedevs.c -o $(HOST_MAKEDEVS_DIR)/makedevs
endef

define HOST_MAKEDEVS_INSTALL_TARGET_CMD
	$(INSTALL) -m 0755 -D $(HOST_MAKEDEVS_DIR)/makedevs $(HOST_DIR)/usr/bin/makedevs
endef

define HOST_MAKEDEVS_CLEAN_CMD
	$(RM) -f $(HOST_MAKEDEVS_DIR)/makedevs
endef

$(eval $(add-host-generic-package))

MAKEDEVS = $(HOST_DIR)/usr/bin/makedevs
