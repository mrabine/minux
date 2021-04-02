#!/bin/sh

sysroot=`$1 -print-file-name=libc.a`
sysroot=`readlink -f $sysroot`
sysroot=`echo -n $sysroot | sed -r -e 's:(/usr)?/lib(32|64)?/([^/]*/)?libc\.a::'`

echo "$sysroot"
