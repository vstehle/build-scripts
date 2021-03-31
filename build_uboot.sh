#!/bin/sh

set -e

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/uboot-imx8mp"
rm -rf "$B"
mkdir -p "$B"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

make O="$B" imx8mp_rsb3720a1_6G_defconfig
cat <<EOF > "${B}"/extraconfig
CONFIG_SPL_LEGACY_IMAGE_SUPPORT=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
if [ -e ../imx-mkimage/firmware-imx-8.10/firmware/ddr/synopsys/ddr3_dmem_1d.bin ]; then
    cp -f ../imx-mkimage/firmware-imx-8.10/firmware/ddr/synopsys/*.bin ${B}
fi
make O="$B"
export ATF_LOAD_ADDR=0x00960000
export TEE_LOAD_ADDR=0x56000000
BL31_PATH="../trusted-firmware-a/build/imx8mp/release/bl31.bin"
if [ -e "$BL31_PATH" ]; then
    cp -f "$BL31_PATH" "$B"/bl31.bin
fi
BL32_PATH="../imx-optee-os/build.mx8mpevk/tee.bin"
if [ -e "$BL32_PATH" ]; then
    cp -f "$BL32_PATH" "$B"/tee.bin
fi
if [ -e ${B}/ddr3_dmem_1d.bin -a -e ${B}/bl31.bin ]; then
    make O="$B" flash.bin
fi
