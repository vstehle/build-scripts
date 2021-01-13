iot-gate-imx8 TBBR Building/Running Documents
================================================

This document describes the steps for building and running related
softwares for iot-gate-imx8.

## Debrick Process

Before doing anything. Make sure that you can boot into U-boot prompt by this way because we will easily break things on EMMC later.

### Preparing

First, prepare a SDCard and a USB Stick.
Format the USB stick with VFAT.

Download https://drive.google.com/file/d/14dD9sFTsZ5kfJrhrlahp1P0SrcAx9aKa/view?usp=sharing

Flash the SDCard by “sudo dd if=flash.bin of=/dev/sdX bs=1K seek=33 status=progress”
Put flash.bin on USB Stick VFAT partition too.

Insert the SDCard to P14. Insert the USB stick to the USB-A hole on the front panel.

### Debrick

 1. Power Off the machine
 2. Close Jumper E1
 3. Power on the machine
 4. Stop the U-boot auto boot by pressing Enter
 5. You should be U-boot prompt now “IOT-GATE-iMX8 =>”
 6. Run “usb reset”
 7. Run “load usb 0 ${loadaddr} flash.bin”
 8. Run “mmc dev 2 1; mmc write ${loadaddr} 0x42 0x1B00”
 9. Power off the machine
 10. Open Jumper E1


## Building boot images

Build the following images in sequence. They have dependencies.

### U-boot

Source: https://git.linaro.org/people/paul.liu/systemready/u-boot.git
Result: u-boot.bin

Steps:
 1. git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
 2. git -C u-boot checkout iot-uboot
 3. mkdir -p /tmp/u-boot-imx
 4. make -C u-boot O=/tmp/u-boot-imx ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- iot-gate-imx8_defconfig
 5. make -C u-boot O=/tmp/u-boot-imx ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

You should find u-boot.bin in /tmp/u-boot-imx


### OpTEE

Source: https://source.codeaurora.org/external/imx/imx-optee-os
Result: tee-*_v2.bin

Steps: 
 1. git clone https://source.codeaurora.org/external/imx/imx-optee-os
 2. git -C imx-optee-os checkout ${NXP_RELEASE}
 3. git -C imx-optee-os am ${LAYER_DIR}/recipes-security/optee-imx/compulab/imx8mm/*.patch
 4. git -C imx-optee-os cherry-pick 331ebf7eab80eb41828979ff4ba8372691117f30
 5. git -C imx-optee-os cherry-pick b836bfb07cfeadda4a1d90227ffbf9cec14a726d
 6. export ARCH=arm
 7. export CROSS_COMPILE=arm-linux-gnueabihf-
 8. export CROSS_COMPILE64=aarch64-linux-gnu-
 9. cd imx-optee-os
 10. ./scripts/nxp_build.sh mx8mmevk

You should find those binaries in imx-optee-os/build.*/core

### TF-A

Source: https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
Input: u-boot.bin tee-*_v2.bin
Output: bl2.bin fip.bin

Steps:
 1. git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
 2. git -C trusted-firmware-a checkout imx8-tbbr-2
 3. git clone https://github.com/ARMmbed/mbedtls.git
 4. make -C trusted-firmware-a ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- \
    PLAT=imx8mm \
    SPD=opteed BL32_BASE=0x7e000000 IMX_BOOT_UART_BASE=0x30880000 \
    NEED_BL32=yes NEED_BL33=yes BUILD_BL2=1 \
    LOG_LEVEL=50 \
    USE_TBBR_DEFS=1 GENERATE_COT=1 TRUSTED_BOARD_BOOT=1 \
    MBEDTLS_DIR=`pwd`/mbedtls \
    BL32=`pwd`/imx-optee-os/build.mx8mmevk/core/tee-header_v2.bin \
    BL32_EXTRA1=`pwd`/imx-optee-os/build.mx8mmevk/core/tee-pager_v2.bin \
    BL32_EXTRA2=`pwd`/imx-optee-os/build.mx8mmevk/core/tee-pageable_v2.bin \
    BL33=/tmp/u-boot-imx/u-boot.bin \
    fip bl2 bl31

You should get bl2.bin and fip.bin in trusted-firmware-a/build/imx8mm/release/

### Flash.bin

Source: https://git.linaro.org/people/paul.liu/systemready/non-free/imx-mkimage.git
Input: bl2.bin fip.bin u-boot-spl.bin
Result: flash.bin
Pre-built image: https://drive.google.com/file/d/14dD9sFTsZ5kfJrhrlahp1P0SrcAx9aKa/view?usp=sharing

Steps:
 1. git clone https://git.linaro.org/people/paul.liu/systemready/non-free/imx-mkimage.git
 2. git -C imx-mkimage checkout paulliu-imx8-1
 3. cd imx-mkimage
 4. sed "s/\(^dtbs = \).*/\1${MACHINE}.dtb/;s/\(mkimage\)_uboot/\1/;s/\(^TEE_LOAD_ADDR \).*/\1= 0x7e000000/g" soc.mak > Makefile
 5. make clean
 6. # put bl2.bin as bl31.bin
 7. # put fip.bin
 8. # put u-boot-spl.bin
 9. make flash_evk SOC=iMX8MM

And you should get flash.bin for replacing the one on board.

## Building Debian related images

### Linux
Source: https://git.linaro.org/people/paul.liu/systemready/linux.git
Branch: linux-compulab
Result: Image sb-iotgimx8.dtb

Steps:
 1. mkdir -p /tmp/linux-imx8
 2. make O=/tmp/linux-imx8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- iot-gate-imx8_defconfig
 3. make O=/tmp/linux-imx8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

You should get the kernel “Image” and the dtb “sb-iotgimx8.dtb”

### Debian Installer EFI image.
Pre-built image: 
https://drive.google.com/file/d/1PGLqCIKzCj0HkOaRe1GFmJu7rDFH1AXq/view?usp=sharing
Input: Image sb-iotgimx8.dtb 

To use the pre-built image, just extract it to a USB stick.

How to build the pre-built D-I EFI image

First, download the Debian installer from 
http://ftp.nl.debian.org/debian/dists/buster/main/installer-arm64/current/images/netboot/
Download the netboot.tar.gz

 1. Extract the tarball. Replace “linux” by “Image”. 
 2. Put sb-iotimx8.dtb to root directory.
 3. Copy efi binaries to EFI/BOOT. 
 4. Add console parameters to grub.cfg 

### Debian kernel package
Result: linux-image-*.deb linux-headers-*.deb
Pre-built image: https://drive.google.com/file/d/1vgN-sRm6a2Gkz1S3VvM13zaAL2jcQHGI/view?usp=sharing


Inside the linux tree
Steps:
 1. export ARCH=arm64
 2. export CROSS_COMPILE=aarch64-linux-gnu-
 3. make iot-gate-imx8_defconfig
 4. make LOCALVERSION=.paulliu-1-arm64 KDEB_PKGVERSION=$(make kernelversion)-1 deb-pkg



