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
define make-package
$(debug-enter)

ifndef $(2)_MAKE
$(2)_MAKE = $$(MAKE)
endif

# build step
ifndef $(2)_BUILD_CMD
ifeq ($(3),target)
# Build for target
define $(2)_BUILD_CMD
	$(TARGET_MAKE_ARGS) $$($$(PKG)_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) -C $$($$(PKG)_DIR)
endef
else
# Build for host
define $(2)_BUILD_CMD
	$(HOST_MAKE_ARGS) $$($$(PKG)_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) -C $$($$(PKG)_DIR)
endef
endif
endif

# Install staging step
ifndef $(2)_INSTALL_STAGING_CMD
define $(2)_INSTALL_STAGING_CMD
	$(TARGET_MAKE_ARGS) $$($$(PKG)_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) DESTDIR=$(STAGING_DIR) -C $$($$(PKG)_DIR) install
endef
endif

# install target step
ifndef $(2)_INSTALL_TARGET_CMD
ifeq ($(3),target)
# install for target
define $(2)_INSTALL_TARGET_CMD
	$(TARGET_MAKE_ARGS) $$($$(PKG)_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) DESTDIR=$(TARGET_DIR) -C $$($$(PKG)_DIR) install
endef
else
# install for host
define $(2)_INSTALL_TARGET_CMD
	$(HOST_MAKE_ARGS) $$($$(PKG)_MAKE_ARGS) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) -C $$($$(PKG)_DIR) install
endef
endif
endif

# clean step
ifndef $(2)_CLEAN_CMD
define $(2)_CLEAN_CMD
	$$($$(PKG)_MAKE) -C $$($$(PKG)_DIR) clean
endef
endif

# generate the necessary make targets
$(call generic-package,$(1),$(2),$(3))

$(debug-leave)
endef # make-package

################################################################################
# target generator macro
################################################################################
add-make-package = $(call make-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),target)
add-host-make-package = $(call make-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),host)
