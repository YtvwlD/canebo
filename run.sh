#!/bin/sh
qemu-system-x86_64 -kernel build/kernel -initrd build/initramfs -m 6144 -serial stdio -machine pc,accel=kvm
