#!/bin/bash

function umount_recur()
{
	arg1=$1
	#echo "\$arg1=$arg1"
	#echo "umount $arg1/*"
	mntArr=(`mount | grep "$arg1" | cut -d' ' -f3`)
	#echo "mntArr=${mntArr[*]}"
	len=${#mntArr[*]}									#数组长度
	for (( i=0; i<"${len}"; i++ ))
	do
		let j=${len}-i
		value=${mntArr[j-1]}
		echo "umount $value"
		umount $value
	done
}

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

# 为了避免区域问题以及导入GPS key
export HOME=/root
export LC_ALL=C

echo "install application by apt-get ..."
# 装应用程序
if [ ! -f /etc/apt/sources.list.bak ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bak
	apt-get update
fi

apt-get install git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
  x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
  libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown \
  libxml2-utils xsltproc \
  openssh-server vim-gnome samba subversion nfs-kernel-server vnc4server

apt-get clean
if [ ! -f /etc/samba/smb.conf.bak ]; then
	cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
	echo "
[homes]
   comment = Home Directories
   browseable = no
   create mask = 0644
   writable = yes
   directory mask = 0755
" >> /etc/samba/smb.conf
fi

echo "remove network configation..."
rm -rf /tmp/*

# 安装JDK
if [ ! -d /opt/jdk1.6.0_33 ]; then
	echo "install JDK ..."
	cd /opt
	chmod +x jdk-6u33-linux-x64.bin
	./jdk-6u33-linux-x64.bin
	rm jdk-6u33-linux-x64.bin
	echo "
export JAVA_HOME=/opt/jdk1.6.0_33
export JRE_HOME=\$JAVA_HOME/jre 
export PATH=$JAVA_HOME/bin:\$PATH
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
" >> /etc/profile
	cd ..
fi

umount_recur /proc
umount /sys
umount /dev/pts
exit