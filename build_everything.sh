#!/bin/sh

cd imx-optee-os
../build_optee.sh
cd ..

cd trusted-firmware-a
../build_atf.sh
cd ..

cd uboot-imx
../build_uboot.sh
cd ..

cd imx-mkimage
../build_flashbin.sh
cd ..

FLASHBIN=`find imx-mkimage -name flash.bin`

echo "$FLASHBIN"
