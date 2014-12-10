#!/bin/bash

# Fetching & uncompress release
wget http://fedora.mirrors.ovh.net/linux/updates/20/Images/armhfp/Fedora-Minimal-armhfp-20-20140407-sda.raw.xz
unxz -v Fedora-Minimal-armhfp-20-20140407-sda.raw.xz

# Mounting the rootfs in loop
#    root@devbox-image-tools-docker-builder:~/docker-brew-fedora# fdisk -lu Fedora-Minimal-armhfp-20-20140407-sda.raw
#    Disk Fedora-Minimal-armhfp-20-20140407-sda.raw: 2 GiB, 2139095040 bytes, 4177920 sectors
#    Units: sectors of 1 * 512 = 512 bytes
#    Sector size (logical/physical): 512 bytes / 512 bytes
#    I/O size (minimum/optimal): 512 bytes / 512 bytes
#    Disklabel type: dos
#    Disk identifier: 0x0000a6dd
#    Device                                     Boot   Start     End Sectors   Size Id Type
#    Fedora-Minimal-armhfp-20-20140407-sda.raw1         1953 1001953 1000001 488.3M 83 Linux
#    Fedora-Minimal-armhfp-20-20140407-sda.raw2      1001954 1251953  250000 122.1M 83 Linux
#    Fedora-Minimal-armhfp-20-20140407-sda.raw3      1251954 3986328 2734375   1.3G 83 Linux
# The first partition is /boot, the second partition is swap, the third partition is the rootfs (what we want)
rm -rf rootfs && mkdir rootfs
mount -o loop,offset=$((1251954 * 512)) Fedora-Minimal-armhfp-20-20140407-sda.raw rootfs

# make clean ?

tar -C rootfs/ -jcf fedora-20-minimal.tar.xz .

