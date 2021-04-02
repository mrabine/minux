#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME: watchdog
# DESCRIPTION: Start watchdog

daemon daemon/watchdog {
    need = system/bootmisc;

    exec daemon = /sbin/watchdog -F -t 30 /dev/watchdog;
}
