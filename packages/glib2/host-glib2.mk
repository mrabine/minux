HOST_LIBGLIB2_VERSION = 2.49.5
HOST_LIBGLIB2_SOURCE = host-glib-$(HOST_LIBGLIB2_VERSION)
HOST_LIBGLIB2_ARCHIVE = glib-$(HOST_LIBGLIB2_VERSION).tar.xz
HOST_LIBGLIB2_PATCH = 
HOST_LIBGLIB2_DEPENDENCIES = host-pcre host-pkgconf host-libffi

HOST_LIBGLIB2_CONFIGURE_OPTS = \
		--with-pcre=system

$(eval $(add-host-autotools-package))
