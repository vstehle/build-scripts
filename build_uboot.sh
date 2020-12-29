#!/bin/sh

set -e

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/uboot-imx8"
rm -rf "$B"
mkdir -p "$B"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

make O="$B" imx8mm-cl-iot-gate_defconfig
cat <<EOF > "${B}"/extraconfig
CONFIG_DFU_SF=y
CONFIG_DFU_MMC=y
CONFIG_DFU_RAM=y
CONFIG_DFU_TFTP=y
CONFIG_EFI_RUNTIME_UPDATE_CAPSULE=y
CONFIG_EFI_CAPSULE_ON_DISK=y
CONFIG_EFI_CAPSULE_FIRMWARE_MANAGEMENT=y
CONFIG_EFI_CAPSULE_FIRMWARE_RAW=y
CONFIG_CMD_DFU=y
CONFIG_RTC_ABX80X=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
if [ -e ../imx-mkimage/firmware-imx-8.8/firmware/ddr/synopsys/ddr3_dmem_1d.bin ]; then
    cp -f ../imx-mkimage/firmware-imx-8.8/firmware/ddr/synopsys/*.bin ${B}
fi
make O="$B"
ATF_LOAD_ADDR=0x00920000
TEE_LOAD_ADDR=0x7e000000
if [ -e ../trusted-firmware-a/build/imx8mm/release/bl2.bin ]; then
    cp -f ../trusted-firmware-a/build/imx8mm/release/bl2.bin "$B"/bl31.bin
fi
if [ -e ${B}/ddr3_dmem_1d.bin -a -e ${B}/bl31.bin ]; then
    make O="$B" flash.bin
fi
