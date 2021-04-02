TOOLCHAIN_VERSION = 2014.05
TOOLCHAIN_SOURCE = arm-$(TOOLCHAIN_VERSION)
TOOLCHAIN_ARCHIVE = $(TOOLCHAIN_SOURCE)-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
TOOLCHAIN_PATCH = 
TOOLCHAIN_DEPENDENCIES = system

TOOLCHAIN_ADD_TOOLCHAIN_DEPENDENCY = NO

TOOLCHAIN_PREFIX = arm-none-linux-gnueabi
TOOLCHAIN_INSTALL_DIR = $(HOST_DIR)/opt/$(TOOLCHAIN_SOURCE)
TOOLCHAIN_BIN_DIR = $(TOOLCHAIN_INSTALL_DIR)/bin

TOOLCHAIN_LIBS += libc libcrypt libdl libm libnsl libnss_dns libnss_files libpthread libresolv librt libutil
ifeq ($(BUILD_TYPE),DEBUG)
TOOLCHAIN_LIBS += libthread_db
endif
TOOLCHAIN_USR_LIBS += libstdc++

define TOOLCHAIN_EXTRACT_CMD
	$(MKDIR) -p $(TOOLCHAIN_INSTALL_DIR)
	$(TAR) -C $(TOOLCHAIN_INSTALL_DIR) --strip-components=1 -xvf $(TOOLCHAIN_PKGDIR)$(TOOLCHAIN_ARCHIVE)
endef

define TOOLCHAIN_INSTALL_TARGET_CMD
	TARGET_SYSROOT="$(shell support/scripts/find_sysroot.sh $(TARGET_CC))" ; \
	for lib in $(TOOLCHAIN_LIBS) ; do \
		$(CP) -dpf $${TARGET_SYSROOT}/lib/$${lib}-*.so $(TARGET_DIR)/lib ; \
		$(CP) -dpf $${TARGET_SYSROOT}/lib/$${lib}.so.[*0-9] $(TARGET_DIR)/lib ; \
	done ; \
	for lib in $(TOOLCHAIN_USR_LIBS) ; do \
		$(CP) -dpf $${TARGET_SYSROOT}/usr/lib/$${lib}.so.* $(TARGET_DIR)/usr/lib ; \
	done ; \
	$(CP) -dpf $${TARGET_SYSROOT}/lib/libgcc_s.so.* $(TARGET_DIR)/lib ; \
	$(CP) -dpf $${TARGET_SYSROOT}/lib/ld*.so* $(TARGET_DIR)/lib ; \
	if test "$(BUILD_TYPE)" = "DEBUG"; then \
		$(INSTALL) -m 755 -D $${TARGET_SYSROOT}/usr/bin/gdbserver $(TARGET_DIR)/usr/bin/gdbserver ; \
	fi ;
endef

define TOOLCHAIN_CLEAN_CMD
	$(RM) -f $(TARGET_DIR)/usr/bin/gdbserver
	$(RM) -f $(TARGET_DIR)/lib/libthread_db*
endef

$(eval $(add-generic-package))

TARGET_ARCH = arm
TARGET_CROSS = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN_PREFIX)-
TARGET_CC = $(TARGET_CROSS)gcc
TARGET_GCC = $(TARGET_CROSS)gcc
TARGET_CPP = $(TARGET_CROSS)cpp
TARGET_CXX = $(TARGET_CROSS)g++
TARGET_LD = $(TARGET_CROSS)ld
TARGET_NM = $(TARGET_CROSS)nm
TARGET_AR = $(TARGET_CROSS)ar
TARGET_AS = $(TARGET_CROSS)as
TARGET_STRIP = $(TARGET_CROSS)strip
TARGET_RANLIB = $(TARGET_CROSS)ranlib
TARGET_READELF = $(TARGET_CROSS)readelf
TARGET_OBJCOPY = $(TARGET_CROSS)objcopy
TARGET_OBJDUMP = $(TARGET_CROSS)objdump
TARGET_STRINGS = $(TARGET_CROSS)strings
TARGET_NAME = $(TOOLCHAIN_PREFIX)
