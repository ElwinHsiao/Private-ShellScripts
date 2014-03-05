#!/bin/bash


function mkdirnoerro()
{
	if [ ! -d $1 ]; then
		mkdir $1		
	fi
}

# 挂载光盘镜像
echo "mount iso..."
mkdir mntiso
sudo mount -o loop ubuntu-10.04.4-desktop-amd64.iso mntiso

# 3、展开镜像文件中的内容到 extract目录下
echo "extract file from iso..."
mkdirnoerro extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mntiso/ extract-cd

# 由于光盘中包含了很多windows下面的自由软件，我们来把不必要的文件删除。当然你可以保留。
echo "remove windows programs..." 
rm -rf extract-cd/programs 

# 展开桌面系统内容到edit目录下
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