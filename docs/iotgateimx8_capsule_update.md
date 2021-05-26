Capsule Updates on Compulab iot-gate-imx8
=================================================

This document describes how to perform capsule updates on iot-gate-imx8.

## Pre-setting

This has to be done before things run.
In U-boot prompt, run the following commands:

 1. efidebug boot add 0 Boot0000 mmc 2:1 capsule1.bin
 2. efidebug boot next 0

## Make capsule1.bin

Build capsule1.itb first. And then use the following command to build
capsule1.bin

 1. Write a capsule1.its. Please see build_flashbin.sh
 2. mkimage -f capsule1.its capsule1.itb
 3. ./tools/mkeficapsule --fit capsule1.itb --index 1 capsule1.bin

## Using efidebug to directly update. (Testing purpose)

Assume that we load the capsule1.bin to ${loadaddr}
Run the following command to update U-boot

 1. efidebug capsule update -v ${loadaddr}

## Put capsule to /EFI/UpdateCapsule and reboot

 1. # Put capsule1.bin to /EFI/UpdateCapsule
    fatwrite mmc 2:1 ${loadaddr} /EFI/UpdateCapsule/capsule1.bin 0x${filesize}
 2. # Set OsIndications
    setenv -e -nv -bs -rt -v OsIndications =0x04
 3. efidebug capsule disk-update

And reboot the board. Don’t interrupt u-boot. Let the board runs into grub. Before grub runs, it should update the bootloader automatically and remove capsule1.bin. And reboot again you should run the updated u-boot.
