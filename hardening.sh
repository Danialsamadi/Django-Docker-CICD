#! /bin/bash

# Variables
DOMAIN="danialsamadi.github.io"
SSH_PORT=1245
NOW=$(date +"%Y%m%d_%H%M%S")  # Define NOW variable for timestamp
BAC_DIR="/opt/backup/file_$NOW"

# Function to create backup directory
create_backup_dir() {
  if [ -d "$BAC_DIR" ]; then
    echo "Backup directory already exists: $BAC_DIR"
  else
    mkdir -p "$BAC_DIR"
    echo "Created backup directory: $BAC_DIR"
  fi
}

# Function to update and upgrade the system
update_system() {
  echo "Updating and upgrading the system..."
  sudo apt update && sudo apt upgrade -y
}

# Function to install required packages
install_packages() {
  echo "Installing required packages..."
  sudo apt install -y curl vim fail2ban
}

# Function to disable and mask ufw
disable_ufw() {
  echo "Disabling and masking ufw..."
  sudo systemctl stop ufw
  sudo systemctl disable ufw
  sudo systemctl mask ufw
}

# Function to configure fail2ban
configure_fail2ban() {
  echo "Configuring fail2ban..."
  sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
  sudo sed -i "s/#port = ssh/port = $SSH_PORT/g" /etc/fail2ban/jail.local
}

# Function to restart and enable fail2ban
restart_fail2ban() {
  echo "Restarting and enabling fail2ban..."
  sudo systemctl restart fail2ban
  sudo systemctl enable fail2ban
}

# Function to check fail2ban status
check_fail2ban_status() {
  echo "Checking fail2ban status..."
  fail2ban-client status
}

# Main function to execute all tasks
main() {
  create_backup_dir
  update_system
  install_packages
  disable_ufw
  configure_fail2ban
  restart_fail2ban
  check_fail2ban_status
  echo "All tasks completed!"
}

# Execute the main function
main
