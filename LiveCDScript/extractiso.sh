#!/bin/bash


function mkdirnoerro()
{
	if [ ! -d $1 ]; then
		mkdir $1		
	fi
}

# ���ع��̾���
echo "mount iso..."
mkdir mntiso
sudo mount -o loop ubuntu-10.04.4-desktop-amd64.iso mntiso

# 3��չ�������ļ��е����ݵ� extractĿ¼��
echo "extract file from iso..."
mkdirnoerro extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mntiso/ extract-cd

# ���ڹ����а����˺ܶ�windows���������������������Ѳ���Ҫ���ļ�ɾ������Ȼ����Ա�����
echo "remove windows programs..." 
rm -rf extract-cd/programs 

# չ������ϵͳ���ݵ�editĿ¼��
#mkdir squashfs
#sudo mount -t squashfs -o loop mntiso/casper/filesystem.squashfs squashfs
#mkdir edit
#sudo cp -a squashfs/* edit/
#sudo umount squashfs && rmdir squashfs

echo "extract squashfs..."
sudo unsquashfs mntiso/casper/filesystem.squashfs
sudo mv squashfs-root edit

sudo umount mntiso && rmdir mntiso

echo "cd and squashfs extracted, you can edit now, simple type ./editios.sh
"