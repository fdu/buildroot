setenv bootargs earlycon=sbi root=/dev/nvme0n1p5 rootwait rw
load mmc 0:3 ${kernel_addr_r} boot/Image
load mmc 0:3 ${fdt_addr_r} boot/hifive-unmatched-a00.dtb
booti ${kernel_addr_r} - ${fdt_addr_r}
