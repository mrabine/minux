#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME: Dropbear
# DESCRIPTION: SSH client with small memory footprint
# WWW: http://matt.ucc.asn.au/dropbear/dropbear.html

service daemon/dropbear/genkeys {
    need = daemon/syslog-ng;

    env KEYGEN=/usr/bin/dropbearkey;
    env DROPBEAR_DSSKEY=/etc/dropbear/dropbear_dss_host_key;
    env DROPBEAR_RSAKEY=/etc/dropbear/dropbear_rsa_host_key;
    env DROPBEAR_ECDSAKEY=/etc/dropbear/dropbear_ecdsa_host_key;

    script start = {
        # create key store.
        mkdir -p --mode=755 /etc/dropbear

        if [ ! -s ${DROPBEAR_DSSKEY} ]; then
            ${KEYGEN} -t dss -f ${DROPBEAR_DSSKEY} > /dev/null 2>&1
            chmod 600 ${DROPBEAR_DSSKEY}
        fi
        if [ ! -s ${DROPBEAR_RSAKEY} ]; then
            ${KEYGEN} -t rsa -f ${DROPBEAR_RSAKEY} > /dev/null 2>&1
            chmod 600 ${DROPBEAR_RSAKEY}
        fi
        if [ ! -s ${DROPBEAR_ECDSAKEY} ]; then
            ${KEYGEN} -t ecdsa -f ${DROPBEAR_ECDSAKEY} > /dev/null 2>&1
            chmod 600 ${DROPBEAR_ECDSAKEY}
        fi
    };
}

daemon daemon/dropbear {
    need = daemon/syslog-ng;
    use = daemon/dropbear/genkeys;
    daemon_stops_badly;

    exec daemon = /usr/sbin/dropbear -F;
}
