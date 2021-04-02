#
#
# Created on: 12 nov. 2012
#     Author: mrabine
#

# Can not be executed in parallel
.NOTPARALLEL:

# Absolute path
TOP_DIR      := $(shell pwd)

# Input dirs.
PACKAGES_DIR := $(TOP_DIR)/packages

# Output dirs.
OUTPUT_DIR   := $(shell mkdir -p out && cd out >/dev/null && pwd)
DL_DIR       := $(OUTPUT_DIR)/dl
BUILD_DIR    := $(OUTPUT_DIR)/build
IMAGES_DIR   := $(OUTPUT_DIR)/images
HOST_DIR     := $(OUTPUT_DIR)/host
STAGING_DIR  := $(OUTPUT_DIR)/staging
TARGET_DIR   := $(OUTPUT_DIR)/target

# Host.
HOST_CPPFLAGS = -I$(HOST_DIR)/include -I$(HOST_DIR)/usr/include
HOST_CFLAGS   = -O2 $(HOST_CPPFLAGS)
HOST_CXXFLAGS = $(HOST_CFLAGS)
HOST_LDFLAGS  = -L$(HOST_DIR)/lib -L$(HOST_DIR)/usr/lib -Wl,-rpath,$(HOST_DIR)/usr/lib
HOST_PATH     = $(HOST_DIR)/bin:$(HOST_DIR)/sbin:$(HOST_DIR)/usr/bin:$(HOST_DIR)/usr/sbin:$(PATH)

HOST_ARCH    := $(shell uname -m | sed -e s/i.86/x86/)
HOST_CC      := $(shell which gcc)
HOST_GCC     := $(shell which gcc)
HOST_CXX     := $(shell which g++)
HOST_CPP     := $(shell which cpp)
HOST_LD      := $(shell which ld)
HOST_NM      := $(shell which nm)
HOST_AR      := $(shell which ar)
HOST_AS      := $(shell which as)
HOST_STRIP   := $(shell which strip)
HOST_RANLIB  := $(shell which ranlib)
HOST_READELF := $(shell which readelf)
HOST_OBJCOPY := $(shell which objcopy)
HOST_OBJDUMP := $(shell which objdump)
HOST_STRINGS := $(shell which strings)
HOST_NAME    := $(shell $(HOST_CC) -dumpmachine)

HOST_MAKE_ARGS = \
	PATH="$(HOST_PATH)" \
	CC="$(HOST_CC)" \
	GCC="$(HOST_GCC)" \
	CPP="$(HOST_CPP)" \
	CXX="$(HOST_CXX)" \
	LD="$(HOST_LD)" \
	NM="$(HOST_NM)" \
	AR="$(HOST_AR)" \
	AS="$(HOST_AS)" \
	RANLIB="$(HOST_RANLIB)" \
	READELF="$(HOST_READELF)" \
	OBJCOPY="$(HOST_OBJCOPY)" \
	OBJDUMP="$(HOST_OBJDUMP)" \
	LD_LIBRARY_PATH="$(HOST_DIR)/usr/lib$(if $(LD_LIBRARY_PATH),:$(LD_LIBRARY_PATH))" \

HOST_CONFIGURE_ARGS = \
	PATH="$(HOST_PATH)" \
	CC="$(HOST_CC)" \
	GCC="$(HOST_GCC)" \
	CPP="$(HOST_CPP)" \
	CXX="$(HOST_CXX)" \
	LD="$(HOST_LD)" \
	NM="$(HOST_NM)" \
	AR="$(HOST_AR)" \
	AS="$(HOST_AS)" \
	RANLIB="$(HOST_RANLIB)" \
	READELF="$(HOST_READELF)" \
	OBJCOPY="$(HOST_OBJCOPY)" \
	OBJDUMP="$(HOST_OBJDUMP)" \
	CPPFLAGS="$(HOST_CPPFLAGS)" \
	CFLAGS="$(HOST_CFLAGS)" \
	CXXFLAGS="$(HOST_CXXFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
	PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_LIBDIR="$(HOST_DIR)/usr/lib/pkgconfig:$(HOST_DIR)/usr/share/pkgconfig" \
	LD_LIBRARY_PATH="$(HOST_DIR)/usr/lib$(if $(LD_LIBRARY_PATH),:$(LD_LIBRARY_PATH))" \
	ac_cv_func_realloc_0_nonnull=yes \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_memcmp_working=yes
		
# Hide troublesome environment variables from sub processes.
unexport CROSS_COMPILE
unexport ARCH
unexport CC
unexport CXX
unexport CPP
unexport CFLAGS
unexport CXXFLAGS
unexport LDFLAGS

# Targets.
TARGETS:=
ROOTFS_TARGETS:=

# Main.
all: world

include Makefile.in

include toolchain/*.mk
include packages/*/*.mk
include fs/*.mk

TARGETS := $(patsubst host-%,,$(TARGETS))
TARGETS_CLEAN := $(patsubst %,%-clean,$(TARGETS))
TARGETS_DISTCLEAN := $(patsubst %,%-distclean,$(TARGETS))

dirs: $(DL_DIR) $(BUILD_DIR) $(IMAGES_DIR) $(HOST_DIR) $(STAGING_DIR) $(TARGET_DIR)

world: $(ROOTFS_TARGETS)

.PHONY: $(DL_DIR) $(BUILD_DIR) $(IMAGES_DIR) $(HOST_DIR) $(STAGING_DIR) $(TARGET_DIR) \
		all dirs world show-targets clean distclean mrproper \
		$(TARGETS) $(TARGETS_CLEAN) $(TARGETS_DISTCLEAN)

$(DL_DIR) $(BUILD_DIR) $(IMAGES_DIR) $(HOST_DIR) $(STAGING_DIR) $(TARGET_DIR):
	$(AT)$(MKDIR) -p $@

show-targets:
	$(AT)$(ECHO) $(TARGETS) $(ROOTFS_TARGETS)

finalize: $(TARGETS)
	$(AT)$(call message,"Finalizing target directory")
	$(RM) -rf $(TARGET_DIR)/include $(TARGET_DIR)/usr/include
	$(RM) -rf $(TARGET_DIR)/lib/pkgconfig $(TARGET_DIR)/usr/lib/pkgconfig $(TARGET_DIR)/usr/share/pkgconfig
	$(FIND) $(TARGET_DIR)/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
	$(FIND) $(TARGET_DIR)/usr/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
	$(RM) -rf $(TARGET_DIR)/usr/share/bash-completion
	$(RM) -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/man
	$(RM) -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/share/info
	$(RM) -rf $(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/doc
	$(RM) -rf $(TARGET_DIR)/usr/share/gtk-doc 
	$(FIND) $(TARGET_DIR) -type f \( -perm /a+x -o -name '*.so*' \) -not \( -name 'libpthread*.so*' -o -name '*.ko' \) -print | \
		xargs -r $(TARGET_STRIP) 2>/dev/null || true
	$(TOUCH) $(TARGET_DIR)/etc/ld.so.conf
	$(MKDIR) -p $(TARGET_DIR)/var/cache/ldconfig
	/sbin/ldconfig -r $(TARGET_DIR)

clean: $(TARGETS_CLEAN)

distclean: $(TARGETS_DISTCLEAN)

mrproper:
	$(RM) -rf $(OUTPUT_DIR)
