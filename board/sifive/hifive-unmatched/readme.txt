SiFive HiFive Unmatched
=======================

This file describes how to use the pre-defined Buildroot
configuration for the SiFive HiFive Unmatched board.

Further information about the HiFive Unmatched board can be found
at https://www.sifive.com/boards/hifive-unmatched.

Building
========

Configure Buildroot using the default board configuration:

  $ make hifive_unmatched_defconfig

Customise the build as necessary:

  $ make menuconfig

Start the build:

  $ make

Result of the build
===================

Once the build has finished you will have the following files:

    output/images/
    +-- boot.scr
    +-- fw_dynamic.bin
    +-- fw_dynamic.elf
    +-- fw_jump.bin
    +-- fw_jump.elf
    +-- hifive-unmatched-a00.dtb
    +-- Image
    +-- rootfs.cpio
    +-- rootfs.ext2
    +-- rootfs.ext4
    +-- rootfs.tar
    +-- sdcard.img
    +-- u-boot.bin
    +-- u-boot.itb
    +-- u-boot-spl.bin


Creating a bootable SD card with genimage
=========================================

By default Buildroot builds a SD card image for you. All you need to do
is dd the image to your SD card, which can be done with the following
command on your development host:

  $ sudo dd if=output/images/sdcard.img of=/dev/sdb bs=4096

The above example command assumes the SD card is accessed via a USB card
reader and shows up as /dev/sdb on the host. Adjust it accordingly per
your actual setup.

Booting the SD card on the board
================================

Make sure that the all DIP switches are set to the off position for
default boot mode (MSEL mode = 1011), insert the SD card and power
up the board.

Connect the USB cable and open minicom (/dev/ttyUSB1, 115200, 8N1).

See the 'SiFive HiFive Unmatched Getting Started Guide' for
more details (https://www.sifive.com/documentation).
