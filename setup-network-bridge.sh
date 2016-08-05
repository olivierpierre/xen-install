#!/bin/bash

# Primary network interface
IFACE=eth0
# Name of the network bridge to create
BR_NAME=xenbr0
# IP of the host - this machine - on the bridge
IP=10.0.0.1
# Where to put the init script
INIT_SCRIPT=/etc/init.d/xen_bridge

me=`whoami`
if [ ! "$me" == "root" ]; then
    echo "Please run as root."
    exit
fi

if [ -e  $INIT_SCRIPT ]; then
    echo "$INIT_SCRIPT already exists, exiting."
    exit
fi

cat << EOF > $INIT_SCRIPT
#!/bin/sh
### BEGIN INIT INFO
# Provides: xen bridge
# Required-Start: $local_fs $network
# Required-Stop: $local_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: xen_bridge
# Description: xen bridge
### END INIT INFO

brctl addbr $BR_NAME
ifconfig $BR_NAME $IP up
echo '1' >> /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD --in-interface br -j ACCEPT
iptables --table nat -A POSTROUTING --out-interface $IFACE -j MASQUERADE
EOF

chmod +x $INIT_SCRIPT
update-rc.d xen_bridge defaults
