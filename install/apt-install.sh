#!/bin/sh
echo "Updating apt packages..."
sudo apt update -y
sudo apt upgrade -y
echo "Installing samba..."
sudo apt install samba -y
echo "Installing python..."
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
echo "Installing docker-compose..."
sudo apt install docker-compose -y
echo "Done!"
