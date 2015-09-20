#!/usr/bin/env bash
START=$(date '+%T')
printf "Updating before installing..."$START
sudo apt-get update >/dev/null 2>&1
sudo apt-get upgrade -y >/dev/null 2>&1
sudo apt-get install -f >/dev/null 2>&1
printf "Installing essential software..."$(date '+%T')
sudo apt-get install -y build-essential make curl git dkms fakeroot >/dev/null 2>&1
sudo apt-get install -y linux-headers-$(uname -r) virtualbox-guest-x11 >/dev/null 2>&1
#sudo apt-get install -y xorg gnome-core gnome-system-tools gnome-app-install >/dev/null 2>&1

# Install Java (JRE/JDK)
printf "Installing JRE and JDK..."$(date '+%T')
sudo apt-get install -y default-jre default-jdk >/dev/null 2>&1

# Install Node and npm
printf "Preparing to install node.js and npm..."$(date '+%T')
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
printf "Installing node.js and npm..."$(date '+%T')
sudo apt-get install -y nodejs >/dev/null 2>&1

printf "Start: "$START
printf "End:   "$(date '+%T')