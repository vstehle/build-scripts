#!/bin/sh

git clone https://git.linaro.org/people/paul.liu/systemready/optee_os.git
git -C optee_os checkout origin/linaro-iot-gate-imx8 -b linaro-iot-gate-imx8

git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout imx8-tbbr-2

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout development

git clone https://git.linaro.org/people/paul.liu/systemready/non-free/imx-mkimage.git
git -C imx-mkimage checkout paulliu-imx8-1

if [ $USER = paulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout iot-gate-imx8-paulliu-master-oldusb-rtc-reset-uefisecboot


