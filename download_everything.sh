#!/bin/sh

# OPTEE
git clone https://git.linaro.org/people/paul.liu/systemready/optee_os.git
git -C optee_os checkout paulliu-compulab-rpmb

# TF-A
git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout paulliu-imx8mm-emmc

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout development
git -C mbedtls checkout 068a13d909ec08a12a5f74289b18142d27977044 -b test1

# U-boot
if [ x"$USER" = xpaulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout paulliu-compulab-tpm2-ab-tcp
