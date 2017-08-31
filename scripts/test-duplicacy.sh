#!/bin/bash

BB_DIR=$PWD

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

cd /Volumes/Src
duplicacy init -pref-dir /tmp/duplicacy-bbouncer-test-pref-dir-src duplicacy-bbouncer /tmp/duplicacy-bbouncer-test
duplicacy backup

cd /Volumes/Dst
duplicacy init -pref-dir /tmp/duplicacy-bbouncer-test-pref-dir-dst duplicacy-bbouncer /tmp/duplicacy-bbouncer-test
duplicacy restore -r 1 -overwrite

cd "$BB_DIR"
./bbouncer verify -d /Volumes/{Src,Dst}

# cleanup volumes
umount -f /Volumes/Src
umount -f /Volumes/Dst
rm -f {Src,Dst}.sparseimage
rm -rf /tmp/duplicacy-bbouncer-test /tmp/duplicacy-bbouncer-test-pref-dir-{src,dst}
