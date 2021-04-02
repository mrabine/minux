#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

daemon daemon/crond {
    need = system/bootmisc;
    exec daemon = /usr/sbin/crond -L /dev/null -f;
}
