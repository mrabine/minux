#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME: 
# DESCRIPTION: 
# WWW: 

service system/urandom {
    need = system/bootmisc;

    env SAVEDFILE = /etc/random-seed;

    script start = {
        [ -f "${SAVEDFILE}" ] && /bin/cat "${SAVEDFILE}" >/dev/urandom

        umask 077
        /bin/dd if=/dev/urandom of=${SAVEDFILE} count=1 bs=512 >/dev/null 2>&1
    };

    script stop = {
        umask 077
        /bin/dd if=/dev/urandom of=${SAVEDFILE} count=1 bs=512 >/dev/null 2>&1
    };
}
