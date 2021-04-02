#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/swap {
    need = system/initial system/mountfs;
    start_fail_ok;

    exec start = /sbin/swapon -a;
    exec stop = /sbin/swapoff -a;
}

