#
#
# Created on: 12 nov. 2012
#     Author: mrabine
#

# uppercase macro
define uppercase
$(shell echo $1 | tr '[:lower:]' '[:upper:]')
endef

# lowercase macro
define lowercase
$(shell echo $1 | tr '[:upper:]' '[:lower:]')
endef

# variables for use in make constructs
comma:=,
empty:=
space:=$(empty) $(empty)

# Needed for the foreach loops
define endl


endef

# determine the name of a package and its directory from
# its makefile directory, using the $(MAKEFILE_LIST)
# variable provided by make.
pkgdir = $(dir $(lastword $(MAKEFILE_LIST)))
pkgname = $(basename $(notdir $(lastword $(MAKEFILE_LIST))))

# message macro
message = echo "$(BOLD)$(BLUE)>>> $($(PKG)_NAME) $($(PKG)_VERSION) $(1)$(RESET)"
BOLD := $(shell tput bold)
RED := $(shell tput setaf 1)
YELLOW := $(shell tput setaf 3)
BLUE := $(shell tput setaf 4)
RESET := $(shell tput sgr 0)

define legal-inf
	echo "$(TERM_BOLD)$(TERM_BLUE)>>> $(1)$(TERM_RESET)"
endef

define legal-warn
	echo "$(TERM_BOLD)$(TERM_YELLOW)>>> WARNING: $(1)$(TERM_RESET)"
endef

define legal-err
	echo "$(TERM_BOLD)$(TERM_RED)>>> ERROR: $(1)$(TERM_RESET)"
endef

# simple debug trace
debug-enter = $(if $(debug_trace),$(info Entering $0($(subst '$(space)','$(comma)$(space)',$(foreach a,$1 $2 $3 $4 $5,'$a')))))
debug-leave = $(if $(debug_trace),$(info Leaving $0))
