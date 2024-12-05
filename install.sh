#!/bin/sh

alias() {
    sudo mkdir /etc/nebula/
    sudo mv ./.nebula /etc/nebula/
    sudo mv ./nebula /opt/nebula/bin/
    if ! grep -F "[FoxServers Nebula]" /etc/bash.bashrc; then
        sudo /usr/bin/bash -c 'echo "#[FoxServers Nebula]
        . /etc/nebula/.nebula" >> /etc/bash.bashrc'
    else
        echo "Already installed aliases for nebula"
    fi
}

cleanup_download() {
    sudo rm -rf /tmp/nebula/{*,.*}
}

cleanup_git_extras() {
    sudo rm -rf /opt/nebula/*LICENSE
    sudo rm -rf /opt/nebula/*README.md
}

create_folders() {
    echo "Creating folder structure for app..."
    sudo mkdir /opt/nebula/
    sudo mkdir /opt/nebula/bin/
    sudo mkdir /opt/nebula/core/
    sudo mkdir /opt/nebula/logs/
    sudo mkdir /opt/nebula/extensions/
    echo "Creating folder structure for servers..."
    sudo mkdir /srv/nebula/
    echo "Done!"
}

init_python() {
    echo "Initializing python for nebula core"
    sudo python3 -m venv /opt/nebula/.venv
    source /opt/nebula/.venv/bin/activate
    echo "Installing requirements..."
    find /opt/nebula/ -type f -name "*requirements.txt" -exec /opt/nebula/.venv/bin/pip install -r {} ';'
    deactivate
    echo "Done!"
}

core_apt_install() {
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
}

get_core() {
    core_apt_install
    echo "Downloading Core..."
    cd /tmp/nebula/
    sudo curl -o nebula-core.tar.gz -L `curl -s https://api.github.com/repos/FoxServers/nebula-core/releases/latest | grep -oP '"tarball_url": "\K(.*)(?=")'`
    echo "Installing Core..."
    sudo tar -zvxf nebula-core.tar.gz --directory /opt/nebula/core/ --strip-components=1
    cleanup_download
    echo "Fixing permissions..."
    sudo chmod +x /opt/nebula/core/bin/*
    sudo chmod +x /opt/nebula/core/scripts/*
    sudo chmod -x /opt/nebula/core/services/*.service
    echo "Done!"
}

access_apt_install() {
    echo "Updating apt packages..."
    sudo apt update -y
    sudo apt upgrade -y
    echo "Installing python..."
    sudo apt install python3 -y
    sudo apt install python3-pip -y
    sudo apt install python3-venv -y
    echo "Done!"
}

get_access() {
    access_apt_install
    echo "Downloading Access..."
    cd /tmp/nebula/
    sudo curl -o nebula-access.tar.gz -L `curl -s https://api.github.com/repos/FoxServers/nebula-access/releases/latest | grep -oP '"tarball_url": "\K(.*)(?=")'`
    echo "Installing Access..."
    sudo mkdir -p /opt/nebula/extensions/access/
    sudo tar -zvxf nebula-access.tar.gz --directory /opt/nebula/extensions/access/ --strip-components=1
    cleanup_download
    echo "Fixing permissions..."
    sudo chmod +x /opt/nebula/extensions/access/bin/*
    sudo chmod -x opt/nebula/extensions/access/services/*.service
    echo "Done!"
}

install_services() {
    echo "Installing services..."
    sudo mv /opt/nebula/*.service /etc/systemd/system/
    sudo systemctl daemon-reload
    echo "Done!"
}

smb_pass() {
    CURRENT_USER=$(whoami)
    sudo adduser "$CURRENT_USER" smb
    read -p "Enter your name [$CURRENT_USER]: " USER
    USER="${USER:-$CURRENT_USER}"
    echo "User $USER was selected..."
    sudo smbpasswd -a "$USER"
    echo "Updating folder permissions..."
    sudo chmod -R g+rwx /srv/nebula/
    sudo chown "$USER":smb /srv/nebula/
}

smb() {
    echo "Backing up smb config..."
    sudo cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak
    echo "Creating server folder..."
    sudo mkdir -p /srv/nebula/
    sudo chmod a+rwx /srv/nebula/
    echo "Editing smb config to include new folder..."
    if ! grep -F "[FoxServers Nebula]" /etc/samba/smb.conf; then
        sudo /usr/bin/bash -c 'echo "[FoxServers Nebula]
        path = /srv/nebula
        browseable = yes
        guest ok = no
        writeable = yes
        read only = no
        valid users = @smb" >> /etc/samba/smb.conf'
    fi
    echo "Updating firewall settings..."
    sudo ufw allow samba
    echo "Creating smb user..."
    sudo addgroup smb && smb_pass
    echo "Restarting smb service..."
    sudo service smbd restart
    echo "Done!"
}

# Check if yes flag has been passed to install all first-party extensions
case $1 in
    -y|-Y)
        $yes=true
    ;;
    *)
        $yes=false
    ;;
esac

# Prepare download location
sudo mkdir -p /tmp/nebula/ || cleanup_download
alias # Moves nebula alias to bashrc
cd /tmp/nebula/

# Build empty directories
create_folders

# Install Core (Not Optional)
get_core

# Install Access (Optional)
if ["$yes" == true] ; then
    get_access
else
    read -p "Install Nebula Access Extension? (y/N): " access
    access="${access:-N}"
    case $access in
        y|Y|-y|-Y)
            get_access
        ;;
        *)
            echo "Skipping Access install..."
        ;;
    esac
fi

### Add first-party extension installs below this line ###

### Add first party extension installs above this line ###

# Finish Installs
install_services

# Install python dependencies
init_python

# Create smb folder
smb

# Run cleanup scripts
cleanup_download
cleanup_git_extras