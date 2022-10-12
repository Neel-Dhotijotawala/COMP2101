# This is the script to install lxd to create a container called COMP2101-S22
# It also installed apache2 server on the container COMP2101-S22 to recieve its default web page to the host machine


# This line checks if lxd is installed on the system
which lxd > /dev/null
if [ $? -ne 0 ]; then
# This part snap installs lxd if it is not already
	echo "Installing lxd- You may have to insert password"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
	# if the installation was unsuccessful it shows message and exits
		echo "lxd installation failed. Ending script execution"
		exit 1
	fi
fi

# This part of the script checks if the lxdbr0 interface is already initialized
ls /sys/class/net | grep -w "lxdbr0" > /dev/null
# if not it performs auto initialization
if [ $? -ne 0 ]; then
	echo "Initializing lxd"
	lxd init --auto > /dev/null
	if [ $? -ne 0 ]; then
	# if the initialization was unsuccessful it shows message and exits
		echo "lxd initialization failed. Ending script execution"
		exit 1
	fi
fi

# This checks if a container called COMP2101-S22 exists and is running
lxc list | grep -w "COMP2101-S22" > /dev/null
# if not then it creates a container called COMP2101-S22
if [ $? -ne 0 ]; then
	echo "Creating container COMP2101-S22 as Ubuntu 20.04 server"
	lxc launch ubuntu:20.04 COMP2101-S22
	if [ $? -ne 0 ]; then
	# if it is unsuccessful then it shows message and exits
		echo "Container creation unsuccessful. Ending script execution"
		exit 1
	fi
fi


##VARIABLES##
ip=$(lxc list | grep "COMP2101" | awk '{print $6}')
hostname="COMP2101-S22"
#############

# This block checks if the host COMP2101-S22 exists in /etc/hosts file
grep -w "COMP2101-S22" /etc/hosts > /dev/null
# if not then it adds it
if [ $? -ne 0 ]; then
	echo "Adding COMP2101-S22 container to /etc/hosts"
	sudo sed -i.bkp "$ a $ip $hostname" /etc/hosts
	if [ $? -ne 0 ]; then
	# if it fails then it shows message and exits
		echo "Appending failed. Ending script execution"
		exit 1
	fi
fi

# This code block check if apache2 is installed on COMP2101-S22 container
lxc exec COMP2101-S22 -- which apache2 > /dev/null
# if not then it installs it
if [ $? -ne 0 ]; then
	echo "Installing apache on container COMP2101-S22"
	lxc exec COMP2101-S22 -- apt install apache2 -y > /dev/null
	if [ $? -ne 0 ]; then
	# if that fails then it shows message and exits
		echo "Apache installation failed. Ending script execution"
		exit 1
	fi
	lxc exec COMP2101-S22 -- exit
fi

# Cheching if curl is availabe on the system
which curl > /dev/null
# if not then it installs it
if [ $? -ne 0 ]; then
	sudo apt install curl -y > /dev/null
	if [ $? -ne 0 ]; then
	# if it fails then it shows message and exits
		echo "Curl installation failed. Ending script execution"
		exit 1
	fi
if

# This part retrieves the default web page of COMP2101-S22 apache server
echo "Checking default web page retrival from container COMP2101-S22"
curl http://COMP2101-S22 > /dev/null
# It shows messege to notify of success and failure
if [ $? -ne 0 ]; then
	echo "Default web page retrieval was unsuccessful"
else
	echo "Default web page retrieval was successful"
fi
exit
