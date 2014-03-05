#!/bin/bash

# 生成ISO镜像（ 1、接下来重新制作 squashfs 文件：）（若未对squashfs操作可不做这一步）
if [ -f extract-cd/casper/filesystem.squashfs ]; then
	sudo rm extract-cd/casper/filesystem.squashfs
fi
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs
sudo chmod 444 extract-cd/casper/filesystem.squashfs

# 重新算一下文件的md5 生成新的 MD5 校验码到 md5sum.txt 文件中：
echo "caculate the md5..."
cd extract-cd
sudo find . -type f -print0 |xargs -0 md5sum |sudo tee md5sum.txt > /dev/null
cd ..

# 3、创建最终的 ISO 文件:
OUT_FILE=`pwd`/ubuntu-1004-64bit-`date +%Y%m%d_%H%M%S`.iso

echo "make the iso: ${OUT_FILE}"
cd extract-cd
sudo mkisofs -r -V "My Cool Ubuntu" -o ${OUT_FILE} -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table .
sudo chmod 777 ${OUT_FILE}

echo "out file: ${OUT_FILE}"
