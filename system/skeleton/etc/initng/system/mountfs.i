#!/sbin/itype
# This is a i file, used by initng parsed by install_service

# NAME:
# DESCRIPTION:
# WWW:

service system/mountfs {
    need = system/initial/filldev system/mountroot;
    never_kill;
    critical;

    script start = {
        /bin/mount -a -v -t tmpfs
        exit 0
    };

    script stop = {
        while read n d t
        do
            case "${d}" in
            /|/proc|/sys|/dev*)
                ;;
            *)
                /bin/umount -r -f "${d}"
                ;;
            esac
        done < /proc/mounts | /usr/bin/sort -r
    };
}
