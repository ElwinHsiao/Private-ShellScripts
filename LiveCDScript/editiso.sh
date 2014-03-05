#!/bin/bash


# �ġ��ı����ã���root������༭����ϵͳ
# 1�������ļ���
echo "copy network config..."
sudo cp /etc/resolv.conf edit/etc/
sudo cp /etc/hosts edit/etc/
sudo cp /etc/apt/sources.list edit/etc/apt/
sudo cp install_app.sh edit/
if [ ! -d edit/opt/jdk1.6.0_33 ]; then
	sudo cp jdk-6u33-linux-x64.bin edit/opt	
fi

# ׼�������滷��
echo "prepare desktop root..."
sudo mount --bind /dev edit/dev
#sudo mount -t proc -o bind /proc edit/proc

echo "please type \". install_app.sh\""
sudo chroot edit
echo "
exit from chroot! continue..."

echo "umount dev..."
sudo umount edit/dev
#sudo umount edit/proc
sudo rm edit/etc/resolv.conf
sudo rm edit/etc/hosts
sudo rm edit/install_app.sh

# ��manifest������һ�� 
echo "reconstruct filesystem.manifest..."
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' |sudo tee extract-cd/casper/filesystem.manifest > /dev/null
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -ie '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop

echo "edit end, you can make iso now, simple type \"./mkiso.sh\"
"