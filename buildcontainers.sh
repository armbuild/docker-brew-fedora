#!/bin/bash

# Fetching & uncompress release
wget http://fedora.mirrors.ovh.net/linux/releases/21/Images/armhfp/Fedora-Minimal-armhfp-21-5-sda.raw.xz
unxz -v Fedora-Minimal-armhfp-21-5-sda.raw.xz

# Mounting the rootfs in loop
#    root@fwrz:~/docker-brew-fedora# fdisk -lu Fedora-Minimal-armhfp-21-5-sda.raw
#
#    Disk Fedora-Minimal-armhfp-21-5-sda.raw: 2139 MB, 2139095040 bytes
#    255 heads, 63 sectors/track, 260 cylinders, total 4177920 sectors
#    Units = sectors of 1 * 512 = 512 bytes
#    Sector size (logical/physical): 512 bytes / 512 bytes
#    I/O size (minimum/optimal): 512 bytes / 512 bytes
#    Disk identifier: 0xa99d2bd5
#
#                             Device Boot      Start         End      Blocks   Id  System
#    Fedora-Minimal-armhfp-21-5-sda.raw1            2048     1001471      499712   83  Linux
#    Fedora-Minimal-armhfp-21-5-sda.raw2         1001472     1251327      124928   83  Linux
#    Fedora-Minimal-armhfp-21-5-sda.raw3         1251328     3985407     1367040   83  Linux
# The first partition is /boot, the second partition is swap, the third partition is the rootfs (what we want)
rm -rf rootfs && mkdir rootfs
mount -o loop,offset=$((1251328 * 512)) Fedora-Minimal-armhfp-21-5-sda.raw.xz rootfs

# make clean ?

tar -C rootfs/ -jcf fedora-21-minimal.tar.xz .

