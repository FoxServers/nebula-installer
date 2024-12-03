#!/bin/sh
echo "Initializing python for foxservers core"
sudo python3 -m venv /opt/foxservers/.venv
source /opt/foxservers/.venv/bin/activate
echo "Installing requirements..."
sudo /opt/foxservers/.venv/bin/pip install -r /opt/foxservers/core/whitelist/requirements.txt
deactivate
echo "Done!"