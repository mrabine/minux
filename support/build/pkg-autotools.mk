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
define autotools-package
$(debug-enter)

ifndef $(2)_MAKE
$(2)_MAKE = $$(MAKE)
endif

# configure step
ifndef $(2)_CONFIGURE_CMD
ifeq ($(3),target)
# Configure for target
define $(2)_CONFIGURE_CMD
	$(CD) $$($$(PKG)_DIR); $(RM) -f config.cache; \
	$(TARGET_CONFIGURE_ARGS) \
	$$($$(PKG)_CONFIGURE_ARGS) \
	./configure \
		--build=$(HOST_NAME) \
		--target=$(TARGET_NAME) \
		--host=$(TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--program-prefix="" \
		--sysconfdir=/etc \
		--disable-option-checking \
		--disable-dependency-tracking \
		--disable-gtk-doc \
		--disable-gtk-doc-html \
		--disable-gtk-doc-pdf \
		--disable-doc \
		--disable-docs \
		--disable-documentation \
		--disable-manpages \
		--disable-nls \
		--disable-debug \
		--disable-static \
		--enable-shared \
		$$($$(PKG)_CONFIGURE_OPTS)
endef
else
# Configure for host
define $(2)_CONFIGURE_CMD
	$(CD) $$($$(PKG)_DIR); $(RM) -f config.cache; \
	$(HOST_CONFIGURE_ARGS) \
	$$($$(PKG)_CONFIGURE_ARGS) \
	./configure \
		--prefix="$(HOST_DIR)/usr" \
		$$($$(PKG)_CONFIGURE_OPTS)
endef
endif
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
	find $$(STAGING_DIR)/usr/lib* -name "*.la" | xargs --no-run-if-empty \
	$$(SED) -i -e "s:$$(OUTPUT_DIR):@OUTPUT_DIR@:g" \
		-e "s:$$(STAGING_DIR):@STAGING_DIR@:g" \
		-e "s:\(['= ]\)/usr:\\1@STAGING_DIR@/usr:g" \
		-e "s:@STAGING_DIR@:$$(STAGING_DIR):g" \
		-e "s:@OUTPUT_DIR@:$$(OUTPUT_DIR):g"
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

# distclean step
ifndef $(2)_DISTCLEAN_CMD
define $(2)_DISTCLEAN_CMD
	$$($$(PKG)_MAKE) -C $$($$(PKG)_DIR) distclean
endef
endif

# generate the necessary make targets
$(call generic-package,$(1),$(2),$(3))

$(debug-leave)
endef # autotools-package

################################################################################
# target generator macro
################################################################################
add-autotools-package = $(call autotools-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),target)
add-host-autotools-package = $(call autotools-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),host)
