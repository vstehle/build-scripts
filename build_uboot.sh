#!/bin/sh

set -e

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/uboot-imx8mp"
rm -rf "$B"
mkdir -p "$B"

export CROSS_COMPILE=aarch64-linux-gnu-

make O="$B" imx8mp_rsb3720a1_6G_defconfig
cat <<EOF > "${B}"/extraconfig
CONFIG_USB_XHCI_DWC3_OF_SIMPLE=y
CONFIG_USB_XHCI_DWC3=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB=y
CONFIG_DM_USB=y
CONFIG_CMD_USB=y
CONFIG_USB_XHCI_IMX8M=y
# CONFIG_DM_DEVICE_REMOVE is not set
CONFIG_DM_GPIO_LOOKUP_LABEL=y
CONFIG_SPL_DM_GPIO_LOOKUP_LABEL=y
CONFIG_DM_I2C_GPIO=y
CONFIG_OF_BOARD_FIXUP=y
CONFIG_CMD_DNS=y
CONFIG_MISC=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig

if [ x"$SDCARD" = x"" ]; then
cat <<EOF > "${B}"/extraconfig2
CONFIG_CMD_OPTEE_RPMB=y
CONFIG_EFI_MM_COMM_TEE=y
CONFIG_MMC_WRITE_PROTECT_ACTIVE_BOOT=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig2
fi

export ATF_LOAD_ADDR=0x970000
make O="$B"
