#!/bin/bash

if [ $EUID -ne 0 ];
then
	echo "script needs to be run with sudo or as root"
else
	df| awk 'dev ($4 > $3)' | grep dev/sd 2>/dev/null
	[ $? -eq 0 ] && echo "Space avalialble on device" || echo "Ensure that there is enough space on the storage device"

	apt_install() {
        sudo apt update #update packages
	sudo apt install nala -y; source use_nala.sh
	whereis lsb_release 2>/dev/null || sudo apt install lsb_release && lsb_release -a | grep KDE 2>/dev/null && pkcon update || sudo apt upgrade -y
	sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https
        sudo apt install code || sudo apt install code-insiders
        sudo apt install neofetch
	sudo echo "neofetch" >> ~/.bashrc
        # search for a few directories before install
        # rhythmbox
        # plocate, git, curl,
        whereis rhythmbox 2>/dev/null || sudo apt install rhythmbox && echo "Rhythmbox is installed"
	whereis plocate 2>/dev/null || sudo apt install plocate
	whereis git 2>/dev/null || sudo apt install git
	whereis curl 2>/dev/null || sudo apt install curl
}

# search for the package manager and install relevant packages
	if sudo find /etc/ -name "apt" 2>/dev/null;
	then
		apt_install
	elif sudo find /etc/ -name "rpm" 2>/dev/null;
	then
		rpm_install
	elif sudo find /etc/ -name "yum" 2>/dev/null;
	then
		yum_install
	elif sudo find /etc/ -name "pacman" 2>/dev/null;
	then
		pacman_install
	else
		echo "Script runs only on debian, RHEL, OpenSUSE and arch systems" 
	fi
	echo neofetch >| /etc/bash_profile
fi
