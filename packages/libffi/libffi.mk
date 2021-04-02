LIBFFI_VERSION = 3.2.1
LIBFFI_SOURCE = $(LIBFFI_NAME)-$(LIBFFI_VERSION)
LIBFFI_ARCHIVE = $(LIBFFI_SOURCE).tar.gz
LIBFFI_PATCH = 
LIBFFI_DEPENDENCIES = 

LIBFFI_INSTALL_STAGING = YES

# Move the headers to the usual location.
define LIBFFI_MOVE_STAGING_HEADERS
	$(MKDIR) -p $(STAGING_DIR)/usr/include
	$(MV) $(STAGING_DIR)/usr/lib/libffi-$(LIBFFI_VERSION)/include/*.h $(STAGING_DIR)/usr/include/
	$(SED) -i -e '/^includedir.*/d' -e '/^Cflags:.*/d' $(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
	$(RM) -rf $(STAGING_DIR)/usr/lib/libffi-*
endef

# Remove headers that are not at the usual location from the target.
define LIBFFI_REMOVE_TARGET_HEADERS
	$(RM) -rf $(TARGET_DIR)/usr/lib/libffi-*
endef

define LIBFFI_INSTALL_STAGING_CMD
	$(TARGET_MAKE_ARGS) $(MAKE) -C $(LIBFFI_DIR) $(LIBFFI_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
	$(LIBFFI_MOVE_STAGING_HEADERS)
endef

define LIBFFI_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(MAKE) -C $(LIBFFI_DIR) $(LIBFFI_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(LIBFFI_REMOVE_TARGET_HEADERS)
endef

$(eval $(add-autotools-package))
