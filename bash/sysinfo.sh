#!/bin/bash
# This script displays host, OS, IP and storage information report to the user
# for Bash Lab 2

#################
#   Variables   #
#################
# The system hostname
hostname=$( hostname )
# The Fully Qualified Domain Name
fqdn=$( hostname -f )
# The OS name and version
osname=$( hostnamectl | grep 'Operating System' | cut -d ':' -f 2- | awk '{print $1,$2}' )
osversion=$( hostnamectl | grep 'Kernel' |  cut -d ':' -f 2- | awk '{print $1,$2}' )
# The system IP Address
ipaddr=$( ip route | grep -w 'default' | awk '{print $3}' )
# The available space on the primary disk
space=$( df -h | grep -w '/' | awk '{print $4}' )

# Displayed Report
#################
#     Main      #
#################
cat << EOF

Report for $hostname
===============
FQDN: $fqdn
Operating System name and version: $osname/$osversion
IP Address: $ipaddr
Root Filesystem Free Space: $space
===============

EOF
