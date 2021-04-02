PCRE_VERSION = 8.39
PCRE_SOURCE = $(PCRE_NAME)-$(PCRE_VERSION)
PCRE_ARCHIVE = $(PCRE_SOURCE).tar.gz
PCRE_PATCH = 
PCRE_DEPENDENCIES = 

PCRE_INSTALL_STAGING = YES

PCRE_CONFIGURE_OPTS = \
	--enable-unicode-properties

$(eval $(add-autotools-package))
