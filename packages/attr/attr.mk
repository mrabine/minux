ATTR_VERSION = 2.4.47
ATTR_SOURCE = $(ATTR_NAME)-$(ATTR_VERSION)
ATTR_ARCHIVE = $(ATTR_SOURCE).src.tar.gz
ATTR_URL = http://ftp.igh.cnrs.fr/pub/nongnu/$(ATTR_NAME)/$(ATTR_ARCHIVE)
ATTR_PATCH = 
ATTR_DEPENDENCIES = 

ATTR_INSTALL_STAGING = YES

ATTR_CONFIGURE_OPTS = \
	--disable-gettext

ATTR_INSTALL_STAGING_OPTS = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
    PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib

ATTR_INSTALL_TARGET_OPTS = \
	prefix=$(TARGET_DIR)/usr \
	exec_prefix=$(TARGET_DIR)/usr

define ATTR_INSTALL_STAGING_CMD
	$(TARGET_MAKE_ARGS) $(ATTR_MAKE) $(ATTR_INSTALL_STAGING_OPTS) -C $(ATTR_DIR) install-dev install-lib
	find $(STAGING_DIR)/usr/lib* -name "*.la" | xargs --no-run-if-empty \
	$(SED) -i -e "s:$(OUTPUT_DIR):@OUTPUT_DIR@:g" \
		-e "s:$(STAGING_DIR):@STAGING_DIR@:g" \
		-e "s:\(['= ]\)/usr:\\1@STAGING_DIR@/usr:g" \
		-e "s:@STAGING_DIR@:$(STAGING_DIR):g" \
		-e "s:@OUTPUT_DIR@:$(OUTPUT_DIR):g"
endef

define ATTR_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(ATTR_MAKE) $(ATTR_INSTALL_TARGET_OPTS) -C $(ATTR_DIR) install install-lib
endef

$(eval $(add-autotools-package))
