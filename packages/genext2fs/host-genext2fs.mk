HOST_GENEXT2FS_VERSION = 1.4.1
HOST_GENEXT2FS_SOURCE = host-genext2fs-$(HOST_GENEXT2FS_VERSION)
HOST_GENEXT2FS_ARCHIVE = genext2fs-$(HOST_GENEXT2FS_VERSION).tar.gz
HOST_GENEXT2FS_PATCH = 
HOST_GENEXT2FS_DEPENDENCIES =

$(eval $(add-host-autotools-package))

GENEXT2FS = $(HOST_DIR)/usr/bin/genext2fs
