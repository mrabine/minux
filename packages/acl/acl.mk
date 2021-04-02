ACL_VERSION = 2.2.52
ACL_SOURCE = $(ACL_NAME)-$(ACL_VERSION)
ACL_ARCHIVE = $(ACL_SOURCE).src.tar.gz
ACL_URL = http://ftp.igh.cnrs.fr/pub/nongnu/$(ACL_NAME)/$(ACL_ARCHIVE)
ACL_PATCH = 
ACL_DEPENDENCIES = attr

ACL_INSTALL_STAGING = YES

ACL_CONFIGURE_OPTS = \
	--disable-gettext

ACL_MAKE_ARGS = \
	CFLAGS="$(TARGET_CFLAGS)"

ACL_INSTALL_STAGING_OPTS = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
    PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib

ACL_INSTALL_TARGET_OPTS = \
	prefix=$(TARGET_DIR)/usr \
	exec_prefix=$(TARGET_DIR)/usr

define ACL_INSTALL_STAGING_CMD
	$(TARGET_MAKE_ARGS) $(ACL_MAKE_ARGS) $(ACL_MAKE) $(ACL_INSTALL_STAGING_OPTS) -C $(ACL_DIR) install-dev install-lib
	find $(STAGING_DIR)/usr/lib* -name "*.la" | xargs --no-run-if-empty \
	$(SED) -i -e "s:$(OUTPUT_DIR):@OUTPUT_DIR@:g" \
		-e "s:$(STAGING_DIR):@STAGING_DIR@:g" \
		-e "s:\(['= ]\)/usr:\\1@STAGING_DIR@/usr:g" \
		-e "s:@STAGING_DIR@:$(STAGING_DIR):g" \
		-e "s:@OUTPUT_DIR@:$(OUTPUT_DIR):g"
endef

define ACL_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(ACL_MAKE_ARGS) $(ACL_MAKE) $(ACL_INSTALL_TARGET_OPTS) -C $(ACL_DIR) install install-lib
endef

$(eval $(add-autotools-package))
