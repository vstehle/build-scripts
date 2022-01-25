#!/bin/sh

./build_edk2.sh

cd optee_os
../build_optee.sh
cd ..

cd u-boot
../build_uboot.sh
cd ..

cd trusted-firmware-a
#cd imx-atf
../build_atf.sh
cd ..

cd u-boot
../build_flashbin.sh
cd ..

FLASHBIN=`find /tmp/uboot-imx8 -name flash.bin`

echo "flash.bin:" "$FLASHBIN"

if [ x"$USER" = x"paulliu" ]; then
    atftp -p -l "$FLASHBIN" -r flash.bin 192.168.66.10
fi

if [ x"$USER" = x"paulliu" ]; then
    atftp -p -l /tmp/uboot-imx8/capsule1.bin -r capsule1.bin 192.168.66.10
fi

echo "capsule: " "/tmp/uboot-imx8/capsule1.bin"
