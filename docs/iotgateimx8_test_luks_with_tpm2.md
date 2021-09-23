# Testing LUKS encrypt/decrypt by TPM2

This document describes how to use TPM2 for LUKS encryption and decryption.

## Flash Fedora IoT raw image to eMMC

Due to some issues (could be USB) in Fedora kernel, the
Fedora IoT installer 34 is not working now.
But we can still download the "raw" image of Fedora IoT and
directly flash it to eMMC by fastboot.

### On U-boot

 * setenv fastboot_raw_partition_raw1_a "0x0 0x800000"
 * setenv autoload 0;dhcp 
 * fastboot udp

### On host

 * xz -d Fedora-IoT-34-20210801.0.aarch64.raw.xz
 * img2simg Fedora-IoT-34-20210801.0.aarch64.raw f1.img
 * fastboot -s udp:<ip_address_of_the_board> flash raw1 f1.img

## LUKS test

This section is modified from
https://fedoraproject.org/wiki/User:Pwhalen/QA/IoT_Tests/Clevis

Because the root filesystem is flashed directly by raw image.
We cannot encrypt it after flashing.
So we create our own luks by using the empty space left on eMMC.

### Test encrypt/decrypt by TPM2

 * echo foo | clevis encrypt tpm2 '{}' | clevis decrypt

 Should output foo.

### Create new partition on /dev/mmcblk2

 * fdisk /dev/mmcblk2
 * Use "n" to create a new extended partition
 * Use "n" to create a new logical partition with "+1G" size
 * Use "w" to save the partition table to the disk

Now /dev/mmcblk2p4 is the extension partition.
And /dev/mmcblk2p5 is the 1G logical partition.
We will create luks on /dev/mmcblk2p5.

### Format the luks

 * cryptsetup luksFormat /dev/mmcblk2p5

You should set a password here for your luks.

### Test your password

 * cryptsetup luksOpen --test-passphrase --key-slot 0 /dev/mmcblk2p5
   && echo correct

### bind your password, encrypt your password by tpm2.

 * clevis luks bind -f -k- -d /dev/mmcblk2p5 tpm2 '{}' <<< "Your password"

### unlock your luks without input password (by tpm2)

 * clevis luks unlock -d /dev/mmcblk2p5



## Reference

 1. https://software.intel.com/content/www/us/en/develop/articles/code-sample-protecting-secret-data-and-keys-using-intel-platform-trust-technology.html
 
