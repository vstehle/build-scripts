#!/bin/sh

set -e

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/uboot-imx8"
rm -rf "$B"
mkdir -p "$B"

export CROSS_COMPILE=aarch64-linux-gnu-

make O="$B" imx8mm-cl-iot-gate-optee_defconfig
cat <<EOF > "${B}"/extraconfig
CONFIG_DM_REGULATOR_ANATOP=y
CONFIG_CMD_SPI=y
CONFIG_MXC_SPI=y
CONFIG_DM_PCA953X=y
CONFIG_CMD_TPM_TEST=y
CONFIG_OF_BOARD_FIXUP=y
# CONFIG_WATCHDOG_AUTOSTART is not set
CONFIG_CMD_EXTENSION=y
CONFIG_SYS_MALLOC_LEN=0xc000000
CONFIG_SPL_LOAD_FIT_APPLY_OVERLAY=y
CONFIG_CMD_DNS=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
if [ x"$SDCARD" = x"" ]; then
cat <<EOF > "${B}"/extraconfig2
CONFIG_CMD_OPTEE_RPMB=y
CONFIG_EFI_MM_COMM_TEE=y
CONFIG_MMC_WRITE_PROTECT_ACTIVE_BOOT=y
CONFIG_PROT_TCP=y
CONFIG_PROT_TCP_SACK=y
CONFIG_CMD_WGET=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig2
fi

export ATF_LOAD_ADDR=0x920000
make O="$B"
