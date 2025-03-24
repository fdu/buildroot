#!/bin/bash

ARCH=riscv64
IMAGE_SIZE=1024
IMAGE_FILE=output/images/debian.ext4
DIR_ROOTFS_TEMP=$(mktemp -d)
DIR_ROOTFS_BUILDROOT_TEMP=$(mktemp -d)
IMAGE_ROOTFS_BUILDROOT=output/images/rootfs.ext2
USER=deb
HOSTNAME=debian

if [ ! -f $IMAGE_FILE ]; then
    sudo dd if=/dev/null of=$IMAGE_FILE bs=1M seek=$IMAGE_SIZE
    (echo n; echo ""; echo ""; echo ""; echo ""; echo w) | sudo fdisk $IMAGE_FILE
    sudo mkfs.ext4 -F $IMAGE_FILE
    sudo mount -t ext4 $IMAGE_FILE $DIR_ROOTFS_TEMP
    # sudo mmdebstrap --architectures=riscv64 sid $DIR_ROOTFS_TEMP "deb http://deb.debian.org/debian sid main" --components="main non-free-firmware" --include=net-tools,openssh-server,pciutils,sudo,passwd,adduser,firmware-intel-graphics
    sudo mmdebstrap --architectures=riscv64 sid $DIR_ROOTFS_TEMP "deb http://deb.debian.org/debian sid main non-free-firmware" --include=net-tools,openssh-server,pciutils,sudo,passwd,adduser,firmware-intel-graphics,ntpsec
    sudo cp /usr/bin/qemu-riscv64-static $DIR_ROOTFS_TEMP/usr/bin/
    sudo chroot $DIR_ROOTFS_TEMP adduser --disabled-password --gecos "" deb
    sudo chroot $DIR_ROOTFS_TEMP usermod -aG video deb
    sudo chroot $DIR_ROOTFS_TEMP usermod -aG render deb
    echo "deb:deb" | sudo chroot $DIR_ROOTFS_TEMP /usr/sbin/chpasswd
    echo "deb ALL=(ALL) NOPASSWD:ALL" | sudo tee -a $DIR_ROOTFS_TEMP/etc/sudoers
    echo -e "[Match]\nName=en*\n\n[Network]\nDHCP=yes" | sudo tee $DIR_ROOTFS_TEMP/etc/systemd/network/20-wired.network
    sudo ln -s /lib/systemd/system/systemd-networkd.service $DIR_ROOTFS_TEMP/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
    echo $HOSTNAME | sudo tee $DIR_ROOTFS_TEMP/etc/hostname
    echo "nameserver 192.168.1.1" | sudo tee $DIR_ROOTFS_TEMP/etc/resolv.conf
else
   sudo mount -t ext4 $IMAGE_FILE $DIR_ROOTFS_TEMP
fi

sudo mount $IMAGE_ROOTFS_BUILDROOT $DIR_ROOTFS_BUILDROOT_TEMP
sudo mkdir -p $DIR_ROOTFS_TEMP/lib/modules/
sudo cp -r $DIR_ROOTFS_BUILDROOT_TEMP/lib/modules/* $DIR_ROOTFS_TEMP/lib/modules/
#sudo cp $DIR_ROOTFS_BUILDROOT_TEMP/etc/hostname $DIR_ROOTFS_TEMP/etc/
echo $HOSTNAME | sudo tee $DIR_ROOTFS_TEMP/etc/hostname
sudo umount $DIR_ROOTFS_BUILDROOT_TEMP
sudo umount $DIR_ROOTFS_TEMP
sudo chmod 777 $IMAGE_FILE
