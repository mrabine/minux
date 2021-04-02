#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/mdev {
    need = system/initial/mountvirtfs;

    script start = {
        # Dynamic updates of device files using hotplugging.
        echo /sbin/mdev >/proc/sys/kernel/hotplug
        # Initial population of device files
        /sbin/mdev -s
        # Send SIGHUP to initng, will reopen /dev/initctl and /dev/initng.
        /bin/kill -HUP 1
        exit 0
    };
}
