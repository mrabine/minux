EVENTLOG_VERSION = 0.2.12
EVENTLOG_SOURCE = $(EVENTLOG_NAME)_$(EVENTLOG_VERSION)
EVENTLOG_ARCHIVE = $(EVENTLOG_SOURCE).tar.gz
EVENTLOG_PATCH = 
EVENTLOG_DEPENDENCIES = 

EVENTLOG_INSTALL_STAGING = YES

$(eval $(add-autotools-package))
