#!/bin/sh
echo "Moving core scripts to /opt/foxservers/core/scripts/"
sudo mv ./core/scripts/* /opt/foxservers/core/scripts

echo "Moving whitelist scripts to /opt/foxservers/core/whitelist/"
sudo mv ./core/whitelist/* /opt/foxservers/core/whitelist/

echo "Moving core scripts to /opt/foxservers/core/server/"
sudo mv ./core/server/* /opt/foxservers/core/server/

echo "Moving core manuals to /opt/foxservers/core/man/"
sudo mv ./core/man/* /opt/foxservers/core/man/

echo "Moving core binaries to /opt/foxservers/core/bin/"
sudo mv ./core/bin/* /opt/foxservers/core/bin/

echo "Moving servers.json to /opt/foxservers/core/"
sudo mv -n ./core/servers.json /opt/foxservers/core/servers.json

echo "Done!"