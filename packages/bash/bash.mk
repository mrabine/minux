BASH_VERSION = 4.3.30
BASH_SOURCE = $(BASH_NAME)-$(BASH_VERSION)
BASH_ARCHIVE = $(BASH_SOURCE).tar.gz
BASH_PATCH = 
BASH_DEPENDENCIES = 

BASH_MAKE = $(MAKE1)

BASH_CONFIGURE_OPTS = \
	--without-bash-malloc

BASH_MAKE_OPTS = \
	exec_prefix=/

define BASH_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $(BASH_MAKE) -C $(BASH_DIR) DESTDIR=$(TARGET_DIR) $(BASH_MAKE_OPTS) install
	$(LN) -snf bash $(TARGET_DIR)/bin/sh
	$(RM) -f $(TARGET_DIR)/bin/bashbug
endef

$(eval $(add-autotools-package))
