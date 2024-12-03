#!/bin/sh
sudo mkdir /etc/foxservers/
sudo mv ./.foxservers /etc/foxservers/
if ! grep -F "[FoxServers]" /etc/bash.bashrc; then
    sudo /usr/bin/bash -c 'echo "#[FoxServers]
    . /etc/foxservers/.foxservers" >> /etc/bash.bashrc'
else
    echo "Already installed aliases for foxservers"
fi
