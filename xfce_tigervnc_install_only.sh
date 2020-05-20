#!/bin/sh

if (( $EUID != 0 )); then
	echo "Please run as root or with sudo."
	exit
fi

yum -y install epel-release
yum -y groupinstall "Xfce"
dnf -y install tigervnc-server vim
vncserver
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup_old
echo "#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4" > ~/.vnc/xstartup