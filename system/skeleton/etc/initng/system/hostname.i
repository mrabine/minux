#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME: hostname
# DESCRIPTION: Sets the system hostname

service system/hostname {
    need = system/bootmisc;

    exec start = /bin/hostname -F /etc/hostname;
}
