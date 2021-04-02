#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME: 
# DESCRIPTION: 
# WWW: 

daemon daemon/syslog-ng {
    need = system/bootmisc;

    exec daemon = /usr/sbin/syslog-ng --foreground;
}
