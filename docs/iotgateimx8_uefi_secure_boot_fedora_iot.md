Running Fedora IoT installer on Compulab iot-gate-imx8
========================================================

This document describes running Fedora IoT installer on iot-gate-imx8
and enabling UEFI secure boot.
It means things not signed by RedHat will not be able to run. For example,
SCT and Debian installer will fail to run.

## Download Fedora IoT installer

Please download Fedora IoT from
https://getfedora.org/iot/download/

And flash the ISO to an USB stick.

## Pre-setting

This section describes how to import the UEFI secure boot keys into
U-boot. Once the keys are set, it cannot be changed anymore until you
clean the eMMC.

First, please run gen_keys_fedora_iot.sh under uefi_secboot_keys directory.
Put PK.auth, KEK.auth, rh_ca.auth to TFTP server.

In U-boot prompt, run the following commands:
 1. setenv autoload 0; dhcp
 2. setenv serverip <your tftp server ip addr>
 3. tftp ${loadaddr} PK.auth
 4. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize PK
 5. tftp ${loadaddr} KEK.auth
 6. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize KEK
 7. tftp ${loadaddr} rh_ca.auth
 8. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize db

And reset the board.

## Boot into Fedora IoT installer

Insert the USB stick with Fedora IoT installer on it to the board.
You should see IoT installer being run after reboot.

If you change the USB stick with Debian installer or SCT, you should
find that U-boot refuse to boot into it.
