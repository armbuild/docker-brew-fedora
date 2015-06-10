#!/bin/bash

set -xe

# Fetching & uncompress release
wget http://fedora.mirrors.ovh.net/linux/releases/22/Images/armhfp/Fedora-Minimal-armhfp-22-3-sda.raw.xz
unxz -v Fedora-Minimal-armhfp-22-3-sda.raw.xz

# Mounting the rootfs in loop
#    root@7f8f5e3c610b:/# fdisk -lu /host/Fedora-Minimal-armhfp-22-3-sda.raw
#
#    Disk /host/Fedora-Minimal-armhfp-22-3-sda.raw: 1841 MB, 1841299456 bytes
#    255 heads, 63 sectors/track, 223 cylinders, total 3596288 sectors
#    Units = sectors of 1 * 512 = 512 bytes
#    Sector size (logical/physical): 512 bytes / 512 bytes
#    I/O size (minimum/optimal): 512 bytes / 512 bytes
#    Disk identifier: 0xbcdd5210
#
#    Device Boot      Start         End      Blocks   Id  System
#    /host/Fedora-Minimal-armhfp-22-3-sda.raw1            2048      587775      292864   83  Linux
#    /host/Fedora-Minimal-armhfp-22-3-sda.raw2          587776     1087487      249856   83  Linux
#    /host/Fedora-Minimal-armhfp-22-3-sda.raw3         1087488     3432447     1172480   83  Linux

rm -rf rootfs && mkdir rootfs
mount -o loop,offset=$((1087488 * 512)) Fedora-Minimal-armhfp-22-3-sda.raw rootfs

# make clean ?

tar -C rootfs/ -jcf fedora-22-minimal.tar.xz .

umount rootfs

docker build -t armbuild/fedora-qcow-minimal:22 .
docker tag armbuild/fedora-qcow-minimal:22 armbuild/fedora-qcow-minimal:latest
docker tag armbuild/fedora-qcow-minimal:22 armbuild/fedora-qcow-minimal:twenty-two
docker tag armbuild/fedora-qcow-minimal:22 armbuild/fedora-qcow-minimal:22-3
