#
#
# Created on: 12 nov. 2012
#     Author: mrabine
#

################################################################################
# generates make targets
#
#  argument 1 lowercase package name
#  argument 2 uppercase package name
#  argument 3 package type (target or host)
################################################################################
define cmake-package
$(debug-enter)

ifndef $(2)_MAKE
$(2)_MAKE = $$(MAKE)
endif

# configure step
ifndef $(2)_CONFIGURE_CMD
ifeq ($(3),target)
# Configure for target
define $(2)_CONFIGURE_CMD
	$(MKDIR) -p $$($$(PKG)_STAMPDIR)/build && \
	$(CD) $$($$(PKG)_STAMPDIR)/build; $(RM) -f CMakeCache.txt; \
	$$($$(PKG)_CONFIGURE_ARGS) \
	cmake $$($$(PKG)_DIR) \
		-Wno-dev \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_C_COMPILER="$(TARGET_CC)" \
		-DCMAKE_C_FLAGS="$(TARGET_CPPFLAGS)" \
		-DCMAKE_CXX_COMPILER="$(TARGET_CXX)" \
		-DCMAKE_CXX_FLAGS="$(TARGET_CPPFLAGS)" \
		-DCMAKE_LINKER="$(TARGET_LD)" \
		-DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS)" \
		-DCMAKE_MODULE_LINKER_FLAGS="$(TARGET_LDFLAGS)" \
		-DCMAKE_NM="$(TARGET_NM)" \
		-DCMAKE_AR="$(TARGET_AR)" \
		-DCMAKE_OBJCOPY="$(TARGET_OBJCOPY)" \
		-DCMAKE_OBJDUMP="$(TARGET_OBJDUMP)" \
		-DCMAKE_RANLIB="$(TARGET_RANLIB)" \
		-DCMAKE_STRIP="$(TARGET_STRIP)" \
		-DPKGCONFIG_EXECUTABLE="$(HOST_DIR)/usr/bin/pkg-config" \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		$$($$(PKG)_CONFIGURE_OPTS)
endef
else
# Configure for host
define $(2)_CONFIGURE_CMD
	$(MKDIR) -p $$($$(PKG)_STAMPDIR)/build && \
	$(CD) $$($$(PKG)_STAMPDIR)/build; $(RM) -f CMakeCache.txt; \
	$$($$(PKG)_CONFIGURE_ARGS) \
	cmake $$($$(PKG)_DIR) \
		-Wno-dev \
		-DCMAKE_INSTALL_SO_NO_EXE=0 \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_FIND_ROOT_PATH="$(HOST_DIR)" \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="BOTH" \
		-DCMAKE_INSTALL_PREFIX="$(HOST_DIR)/usr" \
		-DCMAKE_ASM_COMPILER="$(HOST_AS)" \
		-DCMAKE_C_COMPILER="$(HOST_CC)" \
		-DCMAKE_C_FLAGS="$(HOST_CPPFLAGS)" \
		-DCMAKE_CXX_COMPILER="$(HOST_CXX)" \
		-DCMAKE_CXX_FLAGS="$(HOST_CPPFLAGS)" \
		-DCMAKE_LINKER="$(HOST_LD)" \
		-DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
		-DCMAKE_MODULE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
		-DCMAKE_NM="$(HOST_NM)" \
		-DCMAKE_AR="$(HOST_AR)" \
		-DCMAKE_OBJCOPY="$(HOST_OBJCOPY)" \
		-DCMAKE_OBJDUMP="$(HOST_OBJDUMP)" \
		-DCMAKE_RANLIB="$(HOST_RANLIB)" \
		-DCMAKE_STRIP="$(HOST_STRIP)" \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		$$($$(PKG)_CONFIGURE_OPTS)
endef
endif
endif

# build step
ifndef $(2)_BUILD_CMD
ifeq ($(3),target)
# Build for target
define $(2)_BUILD_CMD
	$$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) VERBOSE=1 -C $$($$(PKG)_STAMPDIR)/build
endef
else
# Build for host
define $(2)_BUILD_CMD
	$$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) VERBOSE=1 -C $$($$(PKG)_STAMPDIR)/build
endef
endif
endif

# Install staging step
ifndef $(2)_INSTALL_STAGING_CMD
define $(2)_INSTALL_STAGING_CMD
	$$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) DESTDIR=$(STAGING_DIR) VERBOSE=1 -C $$($$(PKG)_STAMPDIR)/build install
endef
endif

# install target step
ifndef $(2)_INSTALL_TARGET_CMD
ifeq ($(3),target)
# install for target
define $(2)_INSTALL_TARGET_CMD
	$$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) DESTDIR=$(TARGET_DIR) VERBOSE=1 -C $$($$(PKG)_STAMPDIR)/build install
endef
else
# install for host
define $(2)_INSTALL_TARGET_CMD
	$(HOST_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) VERBOSE=1 -C $$($$(PKG)_STAMPDIR)/build install
endef
endif
endif

# clean step
ifndef $(2)_CLEAN_CMD
define $(2)_CLEAN_CMD
	$$($$(PKG)_MAKE) -C $$($$(PKG)_STAMPDIR)/build clean
endef
endif

# distclean step
ifndef $(2)_DISTCLEAN_CMD
define $(2)_DISTCLEAN_CMD
	$(RM) -rf $$($$(PKG)_STAMPDIR)/build
endef
endif

# generate the necessary make targets
$(call generic-package,$(1),$(2),$(3))

$(debug-leave)
endef # cmake-package

################################################################################
# target generator macro
################################################################################
add-cmake-package = $(call cmake-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),target)
add-host-cmake-package = $(call cmake-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),host)
