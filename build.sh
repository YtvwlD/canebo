#!/bin/sh -x
set -eu

# create and get the rootfs image
nix-shell -p nixos-generators --command "nixos-generate --format raw-efi --configuration rootfs.nix --out-link build/rootfs-out"
rm -f build/rootfs.img
cp build/rootfs-out/nixos.img build/rootfs.img
