#!/bin/sh

# setup variables
NETWORK="192.168.1.0/24"
INTERFACE="eth0"

# flush rules
iptables -F -t nat

# forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null
sysctl -w net.ipv4.tcp_fin_timeout=20 > /dev/null
sysctl -w net.ipv4.tcp_tw_reuse=2 > /dev/null

# nat
EXTERNAL_IP=$(ip a s $INTERFACE | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)
iptables -t nat -A POSTROUTING -o $INTERFACE -j SNAT --to $EXTERNAL_IP

# connection tracker setup
RAM_SIZE=`free -gt|grep Mem|awk '{print $2}'`
CONNTRACK_MAX=`echo "$RAM_SIZE*1024^3/16384/2"|bc`
sysctl -w net.netfilter.nf_conntrack_max=$CONNTRACK_MAX > /dev/null

# redirect http
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -m tcp --dport 80 \! -d $NETWORK -j REDIRECT --to-ports 30443
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -m tcp --dport 443 \! -d $NETWORK -j REDIRECT --to-ports 30443

# redirect http_v3
iptables -t nat -A PREROUTING -i $INTERFACE -p udp -m udp --dport 80 \! -d $NETWORK -j REDIRECT --to-ports 30443
iptables -t nat -A PREROUTING -i $INTERFACE -p udp -m udp --dport 443 \! -d $NETWORK -j REDIRECT --to-ports 30443