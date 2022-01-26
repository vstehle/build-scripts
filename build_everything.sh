#!/bin/sh

./build_edk2.sh

cd optee_os
../build_optee.sh
cd ..

cd u-boot
../build_uboot.sh
cd ..

cd trusted-firmware-a
../build_atf.sh
cd ..

cd u-boot
../build_flashbin.sh
cd ..

FLASHBIN=`find /tmp/uboot-imx8mp -name flash.bin`
UBOOTITB=`find /tmp/uboot-imx8mp -name u-boot.itb`

echo "flash.bin:" "$FLASHBIN"
echo "u-boot.itb:" "$UBOOTITB"

if [ x"$USER" = xpaulliu ]; then
    atftp -p -l "$FLASHBIN" -r flash.bin 192.168.66.10
    atftp -p -l "$UBOOTITB" -r u-boot.itb 192.168.66.10
fi

if [ x"$USER" = xpaulliu ]; then
    atftp -p -l /tmp/uboot-imx8mp/capsule1.bin -r capsule1.bin 192.168.66.10
fi

echo "capsule: " "/tmp/uboot-imx8mp/capsule1.bin"
