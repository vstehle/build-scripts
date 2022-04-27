#!/bin/sh

B="/tmp/uboot-imx8"

O1=`pwd`

cd "$B"
mkdir -p nonfree-firmware
cd nonfree-firmware
export NXP_FIRMWARE=firmware-imx-8.8.bin
wget -c http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${NXP_FIRMWARE}
bash -x ${NXP_FIRMWARE} --auto-accept
cp -v $(find firmware* | awk '/train|hdmi_imx8|dp_imx8/' ORS=" ") "$B"

cd "$O1"

cp -v ../trusted-firmware-a/build/imx8mm/release/bl2.bin "$B"/bl31.bin
cp -v ../trusted-firmware-a/build/imx8mm/release/fip.bin "$B"/fip.bin
#cp -v ../imx-atf/build/imx8mm/release/bl2.bin "$B"/bl31.bin
#cp -v ../imx-atf/build/imx8mm/release/fip.bin "$B"/fip.bin

export CROSS_COMPILE=aarch64-linux-gnu-
export ATF_LOAD_ADDR=0x920000

make O="$B"

cat <<EOF > "$B"/capsule1.its
/*
 * Automatic software update for U-Boot
 * Make sure the flashing addresses ('load' prop) is correct for your board!
 */

/dts-v1/;

/ {
	description = "Automatic U-Boot environment update";
	#address-cells = <2>;

	images {
		flash-bin {
			description = "U-Boot binary on SPI Flash";
			data = /incbin/("flash.bin");
			compression = "none";
			type = "firmware";
			arch = "arm64";
			load = <0>;
			hash-1 {
				algo = "sha1";
			};
		};
	};
};
EOF

cd "$B"
"$B"/tools/mkimage -f capsule1.its capsule1.itb
"$B"/tools/mkeficapsule --index 1 --instance 0 --guid 0bf1165c-1831-4864-945e-ac3d3848f499 \
    capsule1.itb capsule1.bin
cd "$O1"
