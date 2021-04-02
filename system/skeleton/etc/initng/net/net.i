#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service net/all {
    need = system/bootmisc;
    use = system/modules;
    stdall = /dev/null;

    script start = {
        mkdir -p /var/run/network
        for i in $(/usr/bin/awk '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
        do
            ngc -u net/${i}
        done
    };

    script stop = {
        for i in $(/usr/bin/awk '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
        do
            ngc -d net/${i}
        done
    };
}

service net/lo {
    need = system/bootmisc;
    use = system/modules;

    exec start = /sbin/ifup lo;
    exec stop = /sbin/ifdown lo;
}

service net/* {
    need = system/bootmisc;
    use = system/modules;
    stdall = /dev/null;

    script start = {
        # Put up the interface
        /sbin/ifup ${NAME}
        # Check so its up
        /sbin/ifconfig ${NAME} | /bin/grep -qF "UP" || exit 1
        exit 0
    };

    script stop = {
        set -e
        # Shut down.
        /sbin/ifdown ${NAME}
        # Check so its down.
        /sbin/ifconfig ${NAME} | /bin/grep -qF "UP" && exit 1
        exit 0
    };
}
