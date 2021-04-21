advantech rsb-3720 Building/Running Documents
================================================

This document describes the steps for building and running related
softwares for Advantech RSB-3720.

## Debrick Process

The ethernet of U-boot is not working. It is hard to flash the eMMC.
We flash the sdcard first currently.

### Preparing

First, prepare a SDCard.

Flash the SDCard by "sudo dd if=flash.bin of=/dev/sdX bs=512 seek=64 status=progress"

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
 7. Run "mmc dev 2 0; mmc write ${loadaddr} 0x40 0x1B00"
 8. Reset the machine

## Building firmware image

 1. Run ./download_everything.sh
 2. Run ./build_everything.sh
 3. You should get the flash.bin from ./imx-mkimage/iMX8M/flash.bin
