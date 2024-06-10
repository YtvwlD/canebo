#!/bin/sh -x
set -eu

# create and export the rootfs
cd rootfs && docker build -t canebo . && cd ..
docker run -d --name canebo canebo
docker export -o build/rootfs.tar canebo
docker stop canebo
docker rm canebo
# docker rmi canebo
rm -rf build/rootfs
mkdir build/rootfs
# we need to use tar to extract because docker cp doesn't use C's IO functions,
# so fakeroot has no effect there
fakeroot -s build/fakeroot tar -C build/rootfs -xf build/rootfs.tar
rm build/rootfs.tar

# get the kernel and throw away the rest of /boot
cp --copy-contents build/rootfs/boot/vmlinuz-* build/kernel
rm -rf build/rootfs/boot

# let systemd know that this isn't docker
rm build/rootfs/.dockerenv

# create the initramfs
cd build/rootfs && find . | fakeroot -i ../fakeroot cpio -o --format=newc | xz -9 --format=xz --check=crc32 - > ../initramfs && cd ..
rm -rf build/rootfs

# create the efi file
docker run --rm -ti -v "$(pwd)/build:/build" canebo sh -c "apt install --yes --no-install-recommends systemd-ukify systemd-boot-efi && ukify build --linux=/build/kernel --initrd=/build/initramfs --output=/build/canebo.efi && chown 1000:1000 /build/canebo.efi"
