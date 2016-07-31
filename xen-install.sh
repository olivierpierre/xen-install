#!/bin/bash
set -euf -o pipefail

# Git branch / tag to checkout:
GIT_XEN_CO="RELEASE-4.7.0"
# Xen compile options
LOCK_PROF="no"
PERFC="no"
PERFC_ARRAYS="no"
# Xen git repository:
GIT_XEN="git://xenbits.xen.org/xen"

CPUS=`cat /proc/cpuinfo | grep processor | wc -l`

# Prerequisites
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential git python-dev bin86 bcc iasl uuid-dev libncurses5-dev libglib2.0-dev libpixman-1-dev libaio-dev libssl-dev libyajl-dev libc6-dev-i386 texinfo pandoc markdown transfig libnl-cli-3-dev libnl-3-200 libnl-cli-3-200 libnl-3-dev gettext libfdt-dev multiboot wget libpci-dev liblzma-dev

git clone $GIT_XEN
cd xen && git checkout $GIT_XEN_CO

# hack to fix etherboot compile with gcc6
#sed -i "s/IPXE_GIT_TAG := 9a93db3f0947484e30e753bbd61a10b17336e20e/IPXE_GIT_TAG := a4c4f72297bea6902001ce813aaf432bd49d382d/" tools/firmware/etherboot/Makefile
#cp tools/firmware/etherboot/patches/series tools/firmware/etherboot/patches/series.old
#echo "" > tools/firmware/etherboot/patches/series
# End hack

if [ "$LOCK_PROF" == "yes" ]; then
    export lock_profile=y
fi

if [ "$PERFC" == "yes" ]; then
    export perfc=y
fi

if [ "$PERFC_ARRAYS" == "yes" ]; then
    export perfc_arrays=y
fi

./configure
make -j$CPUS install

sudo ldconfig
sudo update-rc.d xencommons defaults 19 18
sudo update-rc.d xendomains defaults 21 20
sudo update-rc.d xen-watchdog defaults 22 23

fstab=`grep xenfs /etc/fstab || true`
if [ "$fstab" == ""  ]; then
    echo "none /proc/xen xenfs defaults,nobootwait 0 0" >> /etc/fstab
fi

if [ -e /etc/grub.d/20_linux_xen ]; then
sudo mv -f /etc/grub.d/20_linux_xen /etc/grub.d/09_linux_xen
fi
sudo update-grub

cd ..

reboot
