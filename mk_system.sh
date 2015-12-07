#!/bin/bash

WALLE_ROOT=".."
if [ "$1"x != ""x  ]; then
         WALLE_ROOT=$1
fi

if [ ! -d $WALLE_ROOT/system ] && [ ! -d $WALLE_ROOT/kernel ]
then
	echo "Invalid walle root: $WALLE_ROOT"
	exit
fi

echo "WALLE_ROOT=$WALLE_ROOT"
OUT=$WALLE_ROOT/output
SYSTEM_IMG=$OUT/image/system.img

echo "Building system"

mkdir -p $OUT/img_mount
mkdir -p $OUT/image

if [ ! -f $SYSTEM_IMG ]; then
	cp $WALLE_ROOT/system/lubuntu/lubuntu-14.04.img $SYSTEM_IMG
fi

# block size
block_size=`tune2fs -l $SYSTEM_IMG | grep "Block size:" | awk '{print $3;}'`
echo "Block size: $block_size"

#let delta=128*1024*1024/$block_size
delta=$((256*1024*1024/$block_size))
echo "delta is $delta"

# minimal system block
block_num=`resize2fs -P $SYSTEM_IMG 2>&1 | tail -n1 | awk '{print $7;}'`
echo "Block min num: $block_num"
block_num=$(($block_num + $delta))

echo "New system blocks: $block_num"
e2fsck -fy $SYSTEM_IMG
resize2fs $SYSTEM_IMG $block_num

sudo mount -o loop $SYSTEM_IMG $OUT/img_mount

if [ -d $OUT/rootfs ]
then
	sudo cp -ap $OUT/rootfs/* $OUT/img_mount/
	sync
fi

sudo umount -f -l $OUT/img_mount && \
rm -rf $OUT/img_mount

echo "Optimization system..."
e2fsck -fy $SYSTEM_IMG && \
resize2fs -p -M $SYSTEM_IMG && \
tune2fs -O dir_index,filetype,sparse_super -L system -c -1 -i 0 $SYSTEM_IMG && \
tune2fs -j $SYSTEM_IMG && \
e2fsck -fyD $SYSTEM_IMG
sync
echo "Done."

