#! /bin/bash

# Variables
DOMAIN="danialsamadi.github.io"
SSH_PORT=1245
NOW=$(date +"%Y%m%d_%H%M%S")  # Define NOW variable for timestamp
BAC_DIR="/opt/backup/file_$NOW"
LOG_FILE="script.log"  # Log file name

# Function to initialize logging
setup_logging() {
  exec > >(tee -a "$LOG_FILE") 2>&1  # Redirect stdout and stderr to log file and terminal
  echo "Logging started at $(date)"
}

# Function to create backup directory
create_backup_dir() {
  echo "Creating backup directory..."
  if [ -d "$BAC_DIR" ]; then
    echo "Backup directory already exists: $BAC_DIR"
  else
    if mkdir -p "$BAC_DIR"; then
      echo "Created backup directory: $BAC_DIR"
    else
      echo "Failed to create backup directory: $BAC_DIR"
      exit 1
    fi
  fi
}

# Function to update and upgrade the system
update_system() {
  echo "Updating and upgrading the system..."
  if sudo apt update && sudo apt upgrade -y; then
    echo "System updated and upgraded successfully."
  else
    echo "Failed to update and upgrade the system."
    exit 1
  fi
}

# Function to install required packages
install_packages() {
  echo "Installing required packages..."
  if sudo apt install -y curl vim fail2ban; then
    echo "Packages installed successfully."
  else
    echo "Failed to install packages."
    exit 1
  fi
}

# Function to disable and mask ufw
disable_ufw() {
  echo "Disabling and masking ufw..."
  if sudo systemctl stop ufw && sudo systemctl disable ufw && sudo systemctl mask ufw; then
    echo "ufw disabled and masked successfully."
  else
    echo "Failed to disable and mask ufw."
    exit 1
  fi
}

# Function to configure fail2ban
configure_fail2ban() {
  echo "Configuring fail2ban..."
  if sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local && \
     sudo sed -i "s/#port = ssh/port = $SSH_PORT/g" /etc/fail2ban/jail.local; then
    echo "fail2ban configured successfully."
  else
    echo "Failed to configure fail2ban."
    exit 1
  fi
}

# Function to restart and enable fail2ban
restart_fail2ban() {
  echo "Restarting and enabling fail2ban..."
  if sudo systemctl restart fail2ban && sudo systemctl enable fail2ban; then
    echo "fail2ban restarted and enabled successfully."
  else
    echo "Failed to restart and enable fail2ban."
    exit 1
  fi
}

# Function to check fail2ban status
check_fail2ban_status() {
  echo "Checking fail2ban status..."
  if fail2ban-client status; then
    echo "fail2ban status checked successfully."
  else
    echo "Failed to check fail2ban status."
    exit 1
  fi
}

# Main function to execute all tasks
main() {
  setup_logging
  create_backup_dir
  update_system
  install_packages
  disable_ufw
  configure_fail2ban
  restart_fail2ban
  check_fail2ban_status
  echo "All tasks completed at $(date)"
}

# Execute the main function
main
