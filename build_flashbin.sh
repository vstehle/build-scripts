#!/bin/sh

export NXP_FIRMWARE=firmware-imx-8.10.bin

wget -c http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${NXP_FIRMWARE}
bash -x ${NXP_FIRMWARE} --auto-accept
cp -v $(find firmware* | awk '/train|hdmi_imx8|dp_imx8/' ORS=" ") iMX8M/

rm -f iMX8M/u-boot-nodtb.bin
rm -f iMX8M/tee.bin
touch iMX8M/u-boot-nodtb.bin
touch iMX8M/tee.bin

rm -f iMX8M/u-boot.itb
rm -f iMX8M/bl31.bin
rm -f iMX8M/fip.bin
rm -f iMX8M/flash.bin
rm -f iMX8M/u-boot-spl.bin
rm -f iMX8M/u-boot-spl-ddr.bin
rm -f iMX8M/mkimage

cp -v ../trusted-firmware-a/build/imx8mp/release/bl2.bin iMX8M/bl31.bin
cp -v ../trusted-firmware-a/build/imx8mp/release/fip.bin iMX8M/
cp -f /tmp/uboot-imx8mp/spl/u-boot-spl.bin iMX8M/
cp -f /tmp/uboot-imx8mp/u-boot.dtb iMX8M/imx8mp-evk.dtb
ln -s /tmp/uboot-imx8mp/tools/mkimage iMX8M/mkimage

cd iMX8M
sed "s/\(^dtbs = \).*/\1${MACHINE}.dtb/;s/\(mkimage\)_uboot/\1/;s/\(^TEE_LOAD_ADDR \).*/\1= 0x56000000/g" soc.mak > Makefile
make clean
make flash_evk SOC=iMX8MP
