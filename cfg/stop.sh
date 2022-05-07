#!/bin/bash

# flush rules
iptables -F -t nat

# forward
sysctl -w net.ipv4.ip_forward=0 > /dev/null
