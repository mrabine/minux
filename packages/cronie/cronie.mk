CRONIE_VERSION = 1.5.1
CRONIE_SOURCE = $(CRONIE_NAME)-$(CRONIE_VERSION)
CRONIE_ARCHIVE = $(CRONIE_SOURCE).tar.gz
CRONIE_URL = https://github.com/cronie-crond/cronie/releases/download/$(CRONIE_SOURCE)/$(CRONIE_ARCHIVE)
CRONIE_PATCH = 
CRONIE_DEPENDENCIES =

$(eval $(add-autotools-package))
