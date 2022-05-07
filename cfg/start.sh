#!/bin/sh

# setup variables
NETWORK="192.168.1.0/24"
INTERFACE="eth0"

# flush rules
iptables -F -t nat

# forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# nat
EXTERNAL_IP=`ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2`
iptables -t nat -A POSTROUTING -o $INTERFACE -j SNAT --to $EXTERNAL_IP

# connection tracker setup
RAM_SIZE=`free -gt|grep Mem|awk '{print $2}'`
CONNTRACK_MAX=`echo "$RAM_SIZE*1024^3/16384/2"|bc`
sysctl -w net.netfilter.nf_conntrack_max=$CONNTRACK_MAX > /dev/null

# redirect
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -m tcp --dport 80 \! -d $NETWORK -j REDIRECT --to-ports 30443
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -m tcp --dport 443 \! -d $NETWORK -j REDIRECT --to-ports 30443

# igmp
sysctl -w net.ipv4.conf.all.force_igmp_version=2 > /dev/null
sysctl -w net.ipv4.igmp_max_memberships=20 > /dev/null
sysctl -w net.ipv4.igmp_max_msf=10 > /dev/null

# iptv
iptables -t nat -A PREROUTING -m addrtype --dst-type MULTICAST --limit-iface-in -j ACCEPT
iptables -t nat -A PREROUTING -s $NETWORK -p udp -m udp --dport 1234 -j ACCEPT
