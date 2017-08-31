#!/bin/bash

# echo commands
set -x

# destroy stale volumes
umount -f /Volumes/Src
umount -f /Volumes/Dst
rm -f {Src,Dst}.sparseimage

# create BB volumes
./bbouncer create-vol Src
./bbouncer create-vol Dst

# fill test data
./bbouncer create /Volumes/Src

rsync -aNHAXx --protect-args --fileflags --force-change /Volumes/Src/ /Volumes/Dst/

./bbouncer verify -d /Volumes/{Src,Dst}

# cleanup volumes
umount -f /Volumes/Src
umount -f /Volumes/Dst
rm -f {Src,Dst}.sparseimage
