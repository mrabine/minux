#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/modules/depmod {
    need = system/initial system/mountroot;
    logfile = /tmp/boot.log;

    script start = {
        if [ ! -e /lib/modules/`/bin/uname -r`/modules.dep ]; then
            echo "Calculating module dependencies ..."
            /sbin/depmod
        else
            if [ /etc/modules.d -nt /etc/modules.conf ]; then
                echo "Updating module dependencies ..."
                /sbin/depmod
            fi
        fi

        exit 0
    };
}

service system/modules {
    need = system/initial system/mountroot;
    use = system/modules/depmod;

    script start = {
        load_modules() {
            /bin/grep -v "^#" "${1}" | /bin/grep -v "^$" | while read MODULE MODARGS
            do
                /sbin/modprobe -q ${MODULE} ${MODARGS} &
            done
        }

        load_modules /etc/modules

        wait
        exit 0
    };
}
