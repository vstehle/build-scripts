advantech rsb-3720 Fedora IoT installer Documents
=================================================

The pre-built image can be found on
https://drive.google.com/file/d/19x1Dxw4ujrATU_3IehmkemeqOEg3Xh2g/view?usp=sharing

We replaced the kernel image with vendor's one and also put the dtb onto it.

The vendor kernel can be downloaded from
git://github.com/ADVANTECH-Corp/linux-imx.git
The branch is adv_5.4.70_2.3.0

To build the kernel please run build_linux.sh inside the kernel directory.
