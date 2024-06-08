#!/bin/sh -x
set -eu

# create and export the rootfs
cd rootfs && docker build -t canebo . && cd ..
docker run -d --name canebo canebo
rm -rf build/rootfs
mkdir build/rootfs
docker cp canebo:/ build/rootfs
docker stop canebo
docker rm canebo
# docker rmi canebo

# get the kernel and throw away the rest of /boot
cp --copy-contents build/rootfs/boot/vmlinuz-* build/kernel
rm -rf build/rootfs/boot

# create the initramfs
cd build/rootfs && find . | cpio -o --format=newc | gzip -9 >../initramfs && cd ..
rm -rf build/rootfs
