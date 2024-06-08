#!/bin/sh
qemu-system-x86_64 -kernel build/kernel -initrd build/initramfs -m 4096 -serial stdio -append console=ttyS0
