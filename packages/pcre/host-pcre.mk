HOST_PCRE_VERSION = 8.39
HOST_PCRE_SOURCE = host-pcre-$(HOST_PCRE_VERSION)
HOST_PCRE_ARCHIVE = pcre-$(HOST_PCRE_VERSION).tar.gz
HOST_PCRE_PATCH = 
HOST_PCRE_DEPENDENCIES = 

HOST_PCRE_CONFIGURE_OPTS = \
		--enable-unicode-properties

$(eval $(add-host-autotools-package))
