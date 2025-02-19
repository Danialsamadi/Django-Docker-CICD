#! /bin/bash

# Variables
DOMAIN=danialsamadi.github.io
SSH_PORT=1245
NOW=$(date +"%Y%m%d_%H%M%S")
BAC_DIR=/opt/backup/file_$NOW

# Check if the backup directory already exists
if [ -d "$BAC_DIR" ]; then
  echo "Backup directory already exists: $BAC_DIR"
else
  mkdir -p "$BAC_DIR"
  echo "Created backup directory: $BAC_DIR"
fi

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y curl vim fail2ban


# Disable and mask ufw
systemctl stop ufw
systemctl disable ufw
systemctl mask ufw

# Configure fail2ban
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sudo sed -i "s/#port = ssh/port = $SSH_PORT/g" /etc/fail2ban/jail.local

# Restart and enable fail2ban
systemctl restart fail2ban
systemctl enable fail2ban

# Check fail2ban status
fail2ban-client status
