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
mv ~/.vnc/startup ~/.vnc/startup_old
echo "#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4" > ~/.vnc/startup

# create systemd file
echo "[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
User=root
WorkingDirectory=/home/root
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver %i
ExecStop=/usr/bin/vncserver -kill %i

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/vncserver@.service
systemctl start vncserver@:1.service
systemctl enable vncserver@:1.service
