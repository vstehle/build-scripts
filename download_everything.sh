#!/bin/sh

# OPTEE
git clone https://git.linaro.org/people/paul.liu/systemready/optee_os.git
git -C optee_os checkout --detach origin/paulliu-compulab-rpmb
git -C optee_os am ../patches/0001-Fix-link-with-ld-2.39.patch

# TF-A
git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout bfc3de891

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout 068a13d909ec08a12a5f74289b18142d27977044

# U-boot
if [ x"$USER" = xpaulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout paulliu-compulab-tpm2-ab-tcp
