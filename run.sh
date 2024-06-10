#!/bin/sh
uefi-run --bios-path /usr/share/ovmf/OVMF.fd --size 1024 build/canebo.efi -- -m 6144 -serial stdio -machine pc,accel=kvm
