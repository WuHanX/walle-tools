#!/bin/bash

WALLE_ROOT=".."
if [ "$1"x != ""x  ]; then
         WALLE_ROOT=$1
fi

if [ ! -d $WALLE_ROOT/kernel ]
then
	echo "Invalid walle root: $WALLE_ROOT"
	exit
fi

echo "WALLE_ROOT=$WALLE_ROOT"
OUT=$WALLE_ROOT/output
KERNEL=$WALLE_ROOT/kernel

if [ ! -f $KERNEL/kernel.img ] || [ ! -f $KERNEL/resource.img ]
then
	echo "Building kernel"
        cd $KERNEL
	make rockchip_defconfig && make rk3288-evb-act8846.img -j3
	echo "Done."
	cd -
else
	echo "Kernel has ready."
fi

