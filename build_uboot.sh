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
CONFIG_FASTBOOT_FLASH_MMC_DEV=2
CONFIG_USB_XHCI_IMX8M=y
CONFIG_RTC_EMULATION=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
export ATF_LOAD_ADDR=0x960000
make O="$B"
