#!/bin/sh

dir=$1
patch=$2

if [ ! -d $dir ] ; then
    echo "Error: '$dir' is not a directory."
    exit 1
fi

if [ ! -e $patch ] ; then
    echo "Error: missing patch file '$patch'"
    exit 1
fi

patch --dry-run --silent -g0 -p1 -E -t -N -d $dir < $patch
if [ $? -eq 0 ]; then
    patch --verbose -g0 -p1 -E -t -N -d $dir < $patch
    if [ $? -ne 0 ]; then
        echo "Error: can't apply patch '$patch'"
        exit 1
    fi
fi

exit 0    
