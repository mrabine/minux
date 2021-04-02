HOST_LIBFFI_VERSION = 3.2.1
HOST_LIBFFI_SOURCE = host-libffi-$(HOST_LIBFFI_VERSION)
HOST_LIBFFI_ARCHIVE = libffi-$(HOST_LIBFFI_VERSION).tar.gz
HOST_LIBFFI_PATCH = 
HOST_LIBFFI_DEPENDENCIES = 

# Move the headers to the usual location.
define HOST_LIBFFI_MOVE_HEADERS
	$(MKDIR) -p $(HOST_DIR)/usr/include
	$(MV) $(HOST_DIR)/usr/lib/libffi-$(LIBFFI_VERSION)/include/*.h $(HOST_DIR)/usr/include/
	$(SED) -i -e '/^includedir.*/d' -e '/^Cflags:.*/d' $(HOST_DIR)/usr/lib/pkgconfig/libffi.pc
	$(RM) -rf $(HOST_DIR)/usr/lib/libffi-*
endef

define HOST_LIBFFI_INSTALL_TARGET_CMD
	$(HOST_MAKE_ARGS) $(MAKE) -C $(HOST_LIBFFI_DIR) $(HOST_LIBFFI_MAKE_OPTS) install
    $(HOST_LIBFFI_MOVE_HEADERS)
endef

$(eval $(add-host-autotools-package))
