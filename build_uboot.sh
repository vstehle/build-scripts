#!/bin/sh

set -e

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/uboot-imx8"
rm -rf "$B"
mkdir -p "$B"

export CROSS_COMPILE=aarch64-linux-gnu-

make O="$B" imx8mm-cl-iot-gate_defconfig
cat <<EOF > "${B}"/extraconfig
CONFIG_DM_REGULATOR_ANATOP=y
CONFIG_CMD_SPI=y
CONFIG_MXC_SPI=y
CONFIG_DM_PCA953X=y
CONFIG_CMD_TPM_TEST=y
CONFIG_OF_BOARD_FIXUP=y
# CONFIG_WATCHDOG_AUTOSTART is not set
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
export ATF_LOAD_ADDR=0x920000
make O="$B"
