#!/bin/sh
echo "Creating folder structure for app..."
sudo mkdir /opt/foxservers/
sudo mkdir /opt/foxservers/core/
sudo mkdir /opt/foxservers/core/logs/
sudo mkdir /opt/foxservers/core/whitelist/
sudo mkdir /opt/foxservers/core/scripts/
sudo mkdir /opt/foxservers/core/server/
sudo mkdir /opt/foxservers/core/man/
sudo mkdir /opt/foxservers/core/bin/
sudo mkdir /opt/foxservers/plugins/
echo "Creating folder structure for servers..."
sudo mkdir /srv/foxservers/
echo "Done!"
