#!/bin/bash

if [ "$1"x == ""x  ]; then
	echo "Please specify walle root path."
	exit
fi

WALLE_ROOT=$1
ROOTFS=$WALLE_ROOT/output/rootfs
IMAGE=$WALLE_ROOT/output/image

rm -rf $ROOTFS
mkdir -p $ROOTFS

echo "copying.."
mkdir -p $ROOTFS/root/
cp -rf $WALLE_ROOT/hardware/rk_ffmpeg_linux/out/* $ROOTFS/
cp -rf $WALLE_ROOT/hardware/rk_ffmpeg_linux/ffmpeg-example/ffmpegexample $ROOTFS/root/

mkdir -p $IMAGE
cp -rf $WALLE_ROOT/system/lubuntu/RK3288UbootLoader_*.bin $IMAGE
cp -rf $WALLE_ROOT/system/lubuntu/parameter $IMAGE
cp -rf $WALLE_ROOT/system/lubuntu/boot.img $IMAGE

cp -rf $WALLE_ROOT/kernel/kernel.img $IMAGE
cp -rf $WALLE_ROOT/kernel/resource.img $IMAGE
echo "done."
