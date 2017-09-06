#!/bin/bash

BB_DIR=$PWD

# echo commands
set -x

# destroy stale volumes
umount -f /Volumes/Src
umount -f /Volumes/Dst
rm -f {Src,Dst}.sparseimage
sudo rm -rf /tmp/duplicacy-bbouncer{,-test-pref-dir-{src,dst}} 
mkdir -p /tmp/duplicacy-bbouncer{,-test-pref-dir-{src,dst}} 
chmod 777 /tmp/duplicacy-bbouncer{,-test-pref-dir-{src,dst}} 

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
sudo duplicacy restore -r 1 -overwrite

cd "$BB_DIR"
./bbouncer verify -d /Volumes/{Src,Dst} 2>/dev/null

# cleanup volumes
umount -f /Volumes/Src
umount -f /Volumes/Dst
rm -f {Src,Dst}.sparseimage
rm -rf /tmp/duplicacy-bbouncer-test{,-pref-dir-{src,dst}}
