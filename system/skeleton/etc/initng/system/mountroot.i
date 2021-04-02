#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/mountroot {
    need = system/initial/mountvirtfs;
    critical;

    script start = {
        /bin/mount -o remount,rw / >/dev/null 2>&1
        if [ ${?} -ne 0 ]
        then
            echo "Root filesystem could not be mounted read/write"
            exit 1
        fi
    };

    script stop = {
        /bin/mount -o remount,ro /
        /bin/sync
        exit 0
    };
}
