#!/bin/bash

if [ `id -u` -ne "0" ]
then
	echo "Must be root"
	exit 4
fi

### Required runtime libraries
yum install -y libstdc++ libstdc++.i686 compat-libstdc++-33 \
    compat-libtermcap.i686 glibc.i686 openmotif ksh \
    redhat-lsb-core ncurses-libs.i686

### Packages that are nice to have
yum install -y gvim git

### Video Drivers
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm

# Install pre-compiled video driver
yum install -y nvidia-detect
yum install -y $(nvidia-detect)

### Install services
cp abaqus-doc abaqus-lm /etc/init.d
chkconfig abaqus-doc on
chkconfig abaqus-lm on

### Copy launcher
for d in /home/*/Desktop
do
    cp Abaqus\ CAE.desktop $d
    chmod 777 $d/Abaqus\ CAE.desktop
done

### Patch the configuration file so Abaqus CAE will work
cd /etc/X11
patch <<__PATCH__
--- xorg.conf.orig	2016-10-11 14:33:05.567967398 -0400
+++ xorg.conf	2016-10-11 14:31:14.315365941 -0400
@@ -48,6 +48,7 @@
 	Identifier  "Device0"
 	Driver      "nvidia"
 	VendorName  "NVIDIA Corporation"
+	Option      "AllowIndirectGLXProtocol" "true"
 EndSection
 
 Section "Screen"
__PATCH__

