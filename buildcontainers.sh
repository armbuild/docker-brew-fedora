#!/bin/bash

set -xe

VERSION="25"
MINORVER="1.3"
MINORVER_DOCKERTAG="1-3"
VERSIONWORD="twenty-five"

IMAGE="Fedora-Minimal-armhfp-$VERSION-$MINORVER-sda.raw"
URLBASE="https://download.fedoraproject.org/pub/fedora/linux/releases/$VERSION/Spins/armhfp/images/"

# Fetching & uncompress release
if [ ! -f $IMAGE ]; then
  wget -c $URLBASE$IMAGE.xz
  unxz -v -k $IMAGE.xz
fi

LOOPDEV=`losetup -P --show -f $IMAGE`
if [ "x$?" != "x0" ]; then
  echo "Could not create loopback device for $IMAGE" >&2
  exit 1
fi

ROOTVOL=$(blkid -t LABEL="_/" -o device | grep ^/dev/loop101p)
if [ "x$?" != "x0" ]; then
  echo "There was no volume with label "_/" in $IMAGE" >&2
  losetup -d $LOOPDEV
  exit 1
fi

TMPDIR=`mktemp -d`
mount $ROOTVOL $TMPDIR

tar -C $TMPDIR -Jcf fedora-$VERSION-minimal.tar.xz .

umount $TMPDIR

losetup -d $LOOPDEV

docker build -t armbuild/fedora-qcow-minimal:$VERSION .
docker tag armbuild/fedora-qcow-minimal:$VERSION armbuild/fedora-qcow-minimal:latest
docker tag armbuild/fedora-qcow-minimal:$VERSION armbuild/fedora-qcow-minimal:$VERSIONWORD
docker tag armbuild/fedora-qcow-minimal:$VERSION armbuild/fedora-qcow-minimal:$VERSION-$MINORVER_DOCKERTAG
