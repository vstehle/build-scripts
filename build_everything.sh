#!/bin/sh

cd optee_os
../build_optee.sh
cd ..

cd u-boot
../build_uboot.sh
cd ..

cd trusted-firmware-a
../build_atf.sh
cd ..

cd imx-mkimage
../build_flashbin.sh
cd ..

FLASHBIN=`find imx-mkimage -name flash.bin`

echo "$FLASHBIN"

if [ $USER = paulliu ]; then
    atftp -p -l "$FLASHBIN" -r flash.bin 192.168.66.10
fi

/tmp/uboot-imx8/tools/mkeficapsule --raw "$FLASHBIN" --index 1 /tmp/uboot-imx8/capsule1.bin

if [ $USER = paulliu ]; then
    atftp -p -l /tmp/uboot-imx8/capsule1.bin -r capsule1.bin 192.168.66.10
fi
