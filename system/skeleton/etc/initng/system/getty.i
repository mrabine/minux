#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

daemon system/getty {
    need = system/bootmisc;
    term_timeout = 3;
    respawn;
    last;

    exec daemon = /sbin/getty -L ttyAMA0 115200 vt100;
}
