#
#
# Created on: 12 nov. 2012
#     Author: mrabine
#

################################################################################
# targets
################################################################################
# fetch
$(BUILD_DIR)/%/stamp_fetched:
	$(AT)$(call message,"Fetch")
	$(foreach p,$($(PKG)_URL),$(WGET) --no-clobber --output-document=$(DL_DIR)/$($(PKG)_ARCHIVE) $(p)$(endl))
	$(AT)$(MKDIR) -p $(@D)
	$(AT)$(TOUCH) $@

# extract
$(BUILD_DIR)/%/stamp_extracted:
	$(AT)$(call message,"Extract")
	$($(PKG)_EXTRACT_CMD)
	$(AT)$(TOUCH) $@

# patch
$(BUILD_DIR)/%/stamp_patched:
	$(AT)$(call message,"Patch")
	$(foreach p,$($(PKG)_PATCH),$(APPLY_PATCH) $($(PKG)_DIR) $($(PKG)_PKGDIR)$(p)$(endl))
	$(AT)$(TOUCH) $@

# configure
$(BUILD_DIR)/%/stamp_configured:
	$(AT)$(call message,"Configure")
	$($(PKG)_CONFIGURE_CMD)
	$(AT)$(TOUCH) $@

# build
$(BUILD_DIR)/%/stamp_built:
	$(AT)$(call message,"Build")
	$($(PKG)_BUILD_CMD)
	$(AT)$(TOUCH) $@

# install staging
$(BUILD_DIR)/%/stamp_staging_installed:
	$(AT)$(call message,"Install staging")
	$($(PKG)_INSTALL_STAGING_CMD)
	$(AT)$(TOUCH) $@

# install target
$(BUILD_DIR)/%/stamp_target_installed:
	$(AT)$(call message,"Install target")
	$($(PKG)_INSTALL_TARGET_CMD)
	$(AT)$(TOUCH) $@

# clean
$(BUILD_DIR)/%/stamp_cleaned:
	$(AT)$(call message,"Clean")
	$($(PKG)_CLEAN_CMD)

# distclean
$(BUILD_DIR)/%/stamp_distcleaned:
	$(AT)$(call message,"Distclean")
	$($(PKG)_DISTCLEAN_CMD)

# clear
$(BUILD_DIR)/%/stamp_cleared:
	$(AT)$(call message,"Clear")
	$(AT)$(RM) -rf $(@D) $($(PKG)_DIR) $(DL_DIR)/$($(PKG)_ARCHIVE)

################################################################################
# generates make targets
#
#  argument 1 lowercase package name
#  argument 2 uppercase package name
#  argument 3 package type (target or host)
################################################################################
define generic-package
$(debug-enter)

$(2)_NAME = $(1)
$(2)_DIR = $$(BUILD_DIR)/$$($(2)_SOURCE)
$(2)_STAMPDIR = $$(BUILD_DIR)/.$$($(2)_NAME)
$(2)_PKGDIR = $$(TOP_DIR)/$(pkgdir)

$(2)_ADD_TOOLCHAIN_DEPENDENCY ?= YES

ifeq ($(3),target)
ifneq ($(1),skeleton)
$(2)_DEPENDENCIES += skeleton
endif
ifeq ($$($(2)_ADD_TOOLCHAIN_DEPENDENCY),YES)
$(2)_DEPENDENCIES += toolchain
endif
endif

$(2)_FINAL_DEPENDENCIES = $$(sort $$($(2)_DEPENDENCIES))

ifneq ($$($(2)_USERS),)
PACKAGES_USERS += $$($(2)_USERS)$$(endl)
endif

$(2)_INSTALL_STAGING ?= NO
$(2)_INSTALL_TARGET ?= YES

# define sub-target steps
$(2)_TARGET_FETCH = $$($(2)_STAMPDIR)/stamp_fetched
$(2)_TARGET_EXTRACT = $$($(2)_STAMPDIR)/stamp_extracted
$(2)_TARGET_PATCH = $$($(2)_STAMPDIR)/stamp_patched
$(2)_TARGET_CONFIGURE = $$($(2)_STAMPDIR)/stamp_configured
$(2)_TARGET_BUILD = $$($(2)_STAMPDIR)/stamp_built
$(2)_TARGET_INSTALL_STAGING = $$($(2)_STAMPDIR)/stamp_staging_installed
$(2)_TARGET_INSTALL_TARGET = $$($(2)_STAMPDIR)/stamp_target_installed
$(2)_TARGET_CLEAN = $$($(2)_STAMPDIR)/stamp_cleaned
$(2)_TARGET_DISTCLEAN = $$($(2)_STAMPDIR)/stamp_distcleaned
$(2)_TARGET_CLEAR = $$($(2)_STAMPDIR)/stamp_cleared

# extract command
$(2)_EXTRACT_CMD ?= \
	$$(if $$($(2)_SOURCE),$$(MKDIR) -p $$($$(PKG)_DIR) && $$(TAR) -C $$($$(PKG)_DIR) --strip-components=1 -xvf $$(DL_DIR)/$$($$(PKG)_ARCHIVE))

# targets
$(1): $(1)-install

$(1)-install: $(1)-install-staging $(1)-install-target

ifeq ($$($(2)_INSTALL_STAGING),YES)
$(1)-install-staging: $(1)-build $$($(2)_TARGET_INSTALL_STAGING)
else
$(1)-install-staging:
endif

ifeq ($$($(2)_INSTALL_TARGET),YES)
$(1)-install-target: $(1)-build $$($(2)_TARGET_INSTALL_TARGET)
else
$(1)-install-target:
endif

$(1)-build: $(1)-configure $$($(2)_TARGET_BUILD)

$(1)-configure: $(1)-patch $$($(2)_TARGET_CONFIGURE)
$$($(2)_TARGET_CONFIGURE): | $$($(2)_FINAL_DEPENDENCIES)

$(1)-depends: $$($(2)_FINAL_DEPENDENCIES)

$(1)-patch: $(1)-extract $$($(2)_TARGET_PATCH)

$(1)-extract: $(1)-fetch $$($(2)_TARGET_EXTRACT)

$(1)-fetch: $$($(2)_TARGET_FETCH)
$$($(2)_TARGET_FETCH): | dirs

$(1)-clean: $$($(2)_TARGET_CLEAN)
	$(AT)$(RM) -f $$($(2)_TARGET_BUILD)
	$(AT)$(RM) -f $$($(2)_TARGET_INSTALL_STAGING)
	$(AT)$(RM) -f $$($(2)_TARGET_INSTALL_TARGET)

$(1)-distclean: $$($(2)_TARGET_DISTCLEAN)
	$(AT)$(RM) -f $$($(2)_TARGET_CONFIGURE)
	$(AT)$(RM) -f $$($(2)_TARGET_BUILD)
	$(AT)$(RM) -f $$($(2)_TARGET_INSTALL_STAGING)
	$(AT)$(RM) -f $$($(2)_TARGET_INSTALL_TARGET)

$(1)-clear: $$($(2)_TARGET_CLEAR)

# define the PKG variable for all targets
$$($(2)_TARGET_FETCH): PKG=$(2)
$$($(2)_TARGET_EXTRACT): PKG=$(2)
$$($(2)_TARGET_PATCH): PKG=$(2)
$$($(2)_TARGET_CONFIGURE): PKG=$(2)
$$($(2)_TARGET_BUILD): PKG=$(2)
$$($(2)_TARGET_INSTALL_STAGING): PKG=$(2)
$$($(2)_TARGET_INSTALL_TARGET): PKG=$(2)
$$($(2)_TARGET_CLEAN): PKG=$(2)
$$($(2)_TARGET_DISTCLEAN): PKG=$(2)
$$($(2)_TARGET_CLEAR): PKG=$(2)

TARGETS += $(1)

$(debug-leave)
endef # generic-package

################################################################################
# target generator macro
################################################################################
add-generic-package = $(call generic-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),target)
add-host-generic-package = $(call generic-package,$(pkgname),$(subst -,_,$(call uppercase,$(pkgname))),host)
