LIBGLIB2_VERSION = 2.49.5
LIBGLIB2_SOURCE = glib-$(LIBGLIB2_VERSION)
LIBGLIB2_ARCHIVE = $(LIBGLIB2_SOURCE).tar.xz
LIBGLIB2_PATCH = 
LIBGLIB2_DEPENDENCIES = host-pkgconf libffi pcre zlib

LIBGLIB2_INSTALL_STAGING = YES
LIBGLIB2_INSTALL_TARGET = NO

LIBGLIB2_CONFIGURE_ARGS = \
	ac_cv_func_posix_getpwuid_r=yes \
	ac_cv_func_posix_getgrgid_r=no \
	glib_cv_stack_grows=no \
	glib_cv_uscore=no

LIBGLIB2_CONFIGURE_OPTS = \
	--enable-static \
	--disable-shared \
	--with-pcre=system \
	--disable-libelf

LIBGLIB2_MAKE_OPTS = \
	LDFLAGS="-L$(STAGING_DIR)/usr/lib"

$(eval $(add-autotools-package))
