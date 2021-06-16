advantech rsb-3720 Building/Running Documents
================================================

This document describes the steps for building and running related
softwares for Advantech RSB-3720.

## Debrick Process

The ethernet of U-boot is not working. It is hard to flash the eMMC.
We flash the sdcard first currently.

### Preparing

First, prepare a SDCard.

Flash the SDCard by "sudo dd if=flash.bin of=/dev/sdX bs=512 seek=64 status=progress; sudo dd if=u-boot.itb of=/dev/sdX bs=512 seek=768 status=progress"

Insert the SDCard.

Set Jumper SW1 to ON ON OFF OFF

Power on.

### Update U-Boot from TFTP to eMMC

 1. Power Off the machine
 2. Set Jumper SW1 to OFF ON OFF OFF
 3. Power on the machine
 4. Stop the U-boot auto boot by pressing Enter
 5. You should be U-boot prompt now "u-boot =>"
 6. Run "tftp ${loadaddr} flash.bin"
 7. Run "mmc dev 2 0; mmc write ${loadaddr} 0x40 0x250"
 8. Run "tftp ${loadaddr} u-boot.itb"
 9. Run "mmc dev 2 0; mmc write ${loadaddr} 0x300 0x1B00"
 10. Reset the machine

## Building firmware image

 1. Run ./download_everything.sh
 2. Run ./build_everything.sh
 3. You should get the flash.bin and u-boot.itb from /tmp/uboot-imx8mp

## Debian installer

We have to use custom kernel with Debian installer right now.
The master kernel (checked at 79a106fc) doesn't boot.
So we replace the kernel by a custom kernel for Debian installer.
The Debian instller for rsb3720 can be downloaded at
https://drive.google.com/file/d/1EkfyhY1Y8rZv_dikWGoTYiimSPjmPElK/view?usp=sharing

Extraing this tarball to a USB disk should be able to install Debian.

After installing Debian, please install the following kernel packages
to boot.
https://drive.google.com/file/d/1lltXLtLSzUJxM606xXqD81Z0hdNALeEu/view?usp=sharing

