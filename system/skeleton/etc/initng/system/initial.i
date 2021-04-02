#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/initial/mountvirtfs {
    critical;

    script start = {
        if [ ! -d /proc -o ! -d /sys ]
        then
            echo "The /sys or /proc is missing, can't mount it!" >&2
            echo "Please sulogin, remount rw and create them." >&2
            exit 1 # It can't work. Critical!
        fi

        mount -n -t proc proc /proc &
        mount -n -t sysfs sys /sys &

        wait
        exit 0
    };
}

service system/initial/filldev {
    need = system/initial/mountvirtfs;
    use = system/mdev;
    critical;

    script start = {
        /bin/mkdir -p /dev/pts &&
            /bin/mount -n -t devpts -o gid=5,mode=0620 none /dev/pts &

		/bin/mkdir -p /dev/shm &&
            /bin/mount -n -t tmpfs none /dev/shm &

		wait
		exit 0
    };
}

service system/initial/loglevel {
    # set the console loglevel to 5
    exec start = /bin/dmesg -n 5;
}

virtual system/initial {
    need = system/initial/loglevel system/initial/mountvirtfs system/initial/filldev;
    use = system/mdev;
    critical;
}