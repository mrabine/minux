FLEX_VERSION = 2.6.0
FLEX_SOURCE = $(FLEX_NAME)-$(FLEX_VERSION)
FLEX_ARCHIVE = $(FLEX_SOURCE).tar.xz
FLEX_URL = https://sourceforge.net/projects/$(FLEX_NAME)/files/$(FLEX_ARCHIVE)/download
FLEX_PATCH = 
FLEX_DEPENDENCIES =

FLEX_INSTALL_STAGING = YES

$(eval $(add-autotools-package))
