#!/bin/bash

# ����ISO���� 1���������������� squashfs �ļ���������δ��squashfs�����ɲ�����һ����
if [ -f extract-cd/casper/filesystem.squashfs ]; then
	sudo rm extract-cd/casper/filesystem.squashfs
fi
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs
sudo chmod 444 extract-cd/casper/filesystem.squashfs

# ������һ���ļ���md5 �����µ� MD5 У���뵽 md5sum.txt �ļ��У�
echo "caculate the md5..."
cd extract-cd
sudo find . -type f -print0 |xargs -0 md5sum |sudo tee md5sum.txt > /dev/null
cd ..

# 3���������յ� ISO �ļ�:
OUT_FILE=`pwd`/ubuntu-1004-64bit-`date +%Y%m%d_%H%M%S`.iso

echo "make the iso: ${OUT_FILE}"
cd extract-cd
sudo mkisofs -r -V "My Cool Ubuntu" -o ${OUT_FILE} -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table .
sudo chmod 777 ${OUT_FILE}

echo "out file: ${OUT_FILE}"
