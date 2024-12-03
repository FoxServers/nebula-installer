#!/bin/sh
echo "Backing up smb config..."
sudo cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak
echo "Creating server folder..."
sudo mkdir -p /srv/foxservers/
sudo chmod a+rwx /srv/foxservers/
echo "Editing smb config to include new folder..."
if ! grep -F "[FoxServers]" /etc/samba/smb.conf; then
    sudo /usr/bin/bash -c 'echo "[FoxServers]
    path = /srv/foxservers
    browseable = yes
    guest ok = no
    writeable = yes
    read only = no
    valid users = @smb" >> /etc/samba/smb.conf'
fi
echo "Updating firewall settings..."
sudo ufw allow samba
echo "Creating smb user..."
CURRENT_USER=$(whoami)
sudo addgroup smb
sudo adduser "$CURRENT_USER" smb
read -p "Enter your name [$CURRENT_USER]: " USER
USER="${USER:-$CURRENT_USER}"
echo "User $USER was selected..."
sudo smbpasswd -a "$USER"
echo "Updating folder permissions..."
sudo chmod -R g+rwx /srv/foxservers/
sudo chown "$USER":smb /srv/foxservers/
echo "Restarting smb service..."
sudo service smbd restart
echo "Done!"