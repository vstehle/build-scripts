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
#CONFIG_LOG_TEST=y
#CONFIG_UNIT_TEST=y
CONFIG_DM_REGULATOR_ANATOP=y
CONFIG_EFI_CAPSULE_AUTHENTICATE=y
EOF
./scripts/kconfig/merge_config.sh -O ${B} ${B}/.config ${B}/extraconfig
export ATF_LOAD_ADDR=0x920000
make O="$B"
