#!/bin/bash/
# This script displays host, OS, IP and storage information to the user

# This is the FQDN of the system
echo "FQDN: " $(hostname -f)

# This is the host information containing OS name, version and distro
echo "Host Information:" 
hostnamectl

# These are all the IP addresses the machine has that are not on the 127 network
echo "IP Addresses:"
(ip a s ens33 || ip a s enp2s1) | grep inet | awk '{printf "%s ", $2}' 	

# This is the amount of space available in the root filesystem displayed as human-friendly
echo -e "\nRoot Filesystems Status:" 
df -h | grep -w 'Filesystem\|/' 
exit
