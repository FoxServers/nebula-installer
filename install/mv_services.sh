#!/bin/sh
echo "Installing services..."
sudo mv ./services/*.service /etc/systemd/system/
sudo systemctl daemon-reload
echo "Done!"