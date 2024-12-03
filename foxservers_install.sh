#!/bin/sh
sudo mkdir /tmp/foxservers/
sudo chmod +x ./install/*.sh
./install/apt-install.sh
./install/create_folders.sh
echo "Fixing permissions..."
sudo chmod +x ./core/scripts/*.sh
sudo chmod +x ./core/bin/*
sudo chmod +x ./core/server/*.sh
sudo chmod -x ./services/*.service
echo "Done!"
./install/mv_core.sh
./install/mv_services.sh
./install/alias.sh
./install/init_python.sh
./install/smb.sh
./install/cleanup.sh