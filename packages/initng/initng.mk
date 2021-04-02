INITNG_VERSION = 0.6.10.2
INITNG_SOURCE = $(INITNG_NAME)-$(INITNG_VERSION)
INITNG_ARCHIVE = $(INITNG_SOURCE).tar.bz2
#INITNG_PATCH = initng-0.6.10.2-fix-inotify.patch initng-0.6.10.2-fix-unused-param.patch initng-0.6.10.2-fix-output.patch initng-0.6.10.2-fix-restart.patch initng-0.6.10.2-fix-reboot-speed.patch initng-0.6.10.2-hang-on-start-stop-restart.patch initng-0.6.10.2-sanitize-stdio.patch initng-0.6.10.2-reload-ipc.patch
INITNG_PATCH = initng-0.6.10.2-fix-inotify.patch initng-0.6.10.2-fix-unused-param.patch initng-0.6.10.2-fix-output.patch initng-0.6.10.2-fix-restart.patch
INITNG_DEPENDENCIES = host-pkgconf

INITNG_INSTALL_STAGING = YES

INITNG_MAKE = $(MAKE1)

INITNG_CONFIGURE_OPTS = \
	-DBUILD_LIMIT=OFF \
	-DBUILD_INITCTL=OFF \
	-DINSTALL_AS_INIT=ON \
	-DDEBUG=OFF \
	-DWITH_BUSYBOX=ON

define INITNG_INSTALL_TARGET_CMD
	$(INITNG_MAKE) -C $(INITNG_STAMPDIR)/build DESTDIR=$(TARGET_DIR) VERBOSE=1 install
	$(LN) -snf initng $(TARGET_DIR)/sbin/init;
endef

$(eval $(add-cmake-package))
