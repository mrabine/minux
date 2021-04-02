HOST_QEMU_VERSION = 2.5.1.1
HOST_QEMU_SOURCE = host-qemu-$(HOST_QEMU_VERSION)
HOST_QEMU_ARCHIVE = qemu-$(HOST_QEMU_VERSION).tar.bz2
HOST_QEMU_PATCH = 
HOST_QEMU_DEPENDENCIES = host-libglib2 host-pkgconf host-zlib

HOST_QEMU_CONFIGURE_OPTS = \
	--target-list=$(TARGET_ARCH)-softmmu \
	--interp-prefix="$(STAGING_DIR)" \
	--cc="$(HOST_CC)" \
	--host-cc="$(HOST_CC)" \
	--extra-cflags="$(HOST_CFLAGS)" \
	--extra-ldflags="$(HOST_LDFLAGS)"

$(eval $(add-host-autotools-package))

QEMU_SYSTEM = $(HOST_DIR)/usr/bin/qemu-system-$(TARGET_ARCH)

demo: all host-qemu
	$(CD) $(IMAGES_DIR) ; \
	sudo $(QEMU_SYSTEM) \
	-M vexpress-a9 \
	-kernel zImage \
	-drive file=rootfs.ext2,if=sd \
	-append "clocksource=pit console=ttyAMA0,115200n8 root=/dev/mmcblk0" \
	-net nic,model=lan9118 \
	-net tap,script=$(HOST_QEMU_PKGDIR)qemu-ifup \
	-serial stdio
